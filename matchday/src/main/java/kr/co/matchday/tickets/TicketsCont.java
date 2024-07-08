package kr.co.matchday.tickets;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import org.json.JSONArray;
import org.json.JSONObject;
import kr.co.matchday.matches.MatchesDTO;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {

    @Autowired
    private Environment env;

    @Autowired
    private TicketsDAO ticketsDao;

    public TicketsCont() {
        System.out.println("----TicketsCont() 객체");
    }

    @GetMapping("/ticketspayment")
    public ModelAndView ticketspayment(@RequestParam String matchid) {
        System.out.println("Received matchid: " + matchid);
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }
        ModelAndView mav = new ModelAndView("tickets/ticketspayment");
        mav.addObject("match", matchesDto);
        return mav;
    }

    @GetMapping("/seatmap")
    public ModelAndView seatmap(@RequestParam String stadiumid, @RequestParam String section, @RequestParam String matchid) {
        List<Map<String, Object>> seats = ticketsDao.getSeatsByStadiumIdAndSection(stadiumid, section);
        ModelAndView mav = new ModelAndView("tickets/seatmap");
        mav.addObject("section", section);
        mav.addObject("stadiumid", stadiumid);
        mav.addObject("matchid", matchid);

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String seatsJson = objectMapper.writeValueAsString(seats);
            mav.addObject("seatsJson", seatsJson);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            mav.addObject("seatsJson", "[]");
        }

        return mav;
    }

    @GetMapping("/reservation")
    public String showReservationPage(
            @RequestParam("matchid") String matchId,
            @RequestParam("seats") String seats,
            @RequestParam("totalPrice") int totalPrice,
            @RequestParam("section") String section,
            @RequestParam("stadiumid") String stadiumId,
            HttpSession session,
            Model model) {

        System.out.println("matchId: " + matchId);
        System.out.println("seats: " + seats);
        System.out.println("totalPrice: " + totalPrice);
        System.out.println("section: " + section);
        System.out.println("stadiumId: " + stadiumId);

        MatchesDTO match = ticketsDao.getMatchById(matchId);
        if (match == null) {
            System.out.println("Match not found for ID: " + matchId);
            return "error";
        }

        String[] seatArray = seats.split(",");

        String userId = (String) session.getAttribute("userID");
        System.out.println("userID: " + userId);
        // if (userId == null) {
        //     System.out.println("User ID not found in session");
        //     return "error";
        // }
        Map<String, Object> userInfo = userId != null ? ticketsDao.getUserInfo(userId) : new HashMap<>();

        model.addAttribute("match", match);
        model.addAttribute("seats", seatArray);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("section", section);
        model.addAttribute("stadiumid", stadiumId);
        model.addAttribute("userInfo", userInfo);

        System.out.println("Returning view: reservation");
        return "tickets/reservation";
    }




    @PostMapping("/verifyPayment")
    @ResponseBody
    public Map<String, Object> verifyPayment(
            @RequestParam String imp_uid,
            @RequestParam String merchant_uid,
            @RequestParam int paid_amount,
            @RequestParam String matchid,
            @RequestParam String seats,
            @RequestParam int totalPrice,
            @RequestParam(required = false) String recipientname,
            @RequestParam(required = false) String shippingaddress,
            @RequestParam(required = false) String shippingrequest,
            @RequestParam String collectionmethodcode,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        String token = getToken();
        if (token == null) {
            response.put("success", false);
            return response;
        }

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> paymentResponse = restTemplate.exchange(
            "https://api.iamport.kr/payments/" + imp_uid, HttpMethod.GET, entity, String.class);

        if (paymentResponse.getStatusCode() == HttpStatus.OK) {
            try {
                JSONObject paymentJson = new JSONObject(paymentResponse.getBody());
                int amount = paymentJson.getJSONObject("response").getInt("amount");

                if (amount == paid_amount) {
                    String reservationid = generateReservationId();

                    String userId = (String) session.getAttribute("userID");
                    if (userId == null) {
                        response.put("success", false);
                        response.put("message", "User ID not found in session");
                        return response;
                    }

                    TicketsDTO ticketsDto = new TicketsDTO();
                    ticketsDto.setReservationid(reservationid);
                    ticketsDto.setMatchid(matchid);
                    ticketsDto.setQuantity(seats.split(",").length);
                    ticketsDto.setPrice(totalPrice);
                    ticketsDto.setUserid(userId);
                    ticketsDto.setPaymentmethodcode("pay01");
                    ticketsDto.setReservationstatus("Confirmed");
                    ticketsDto.setCollectionmethodcode(collectionmethodcode);
                    ticketsDto.setRecipientname(recipientname);
                    ticketsDto.setShippingaddress(shippingaddress);
                    ticketsDto.setShippingrequest(shippingrequest);
                    ticketsDto.setFinalpaymentamount(totalPrice);

                    if ("receiving02".equals(collectionmethodcode)) {
                        ticketsDto.setShippingstatus("배송준비중");
                    }

                    ticketsDao.insertTicket(ticketsDto);

                    for (String seat : seats.split(",")) {
                        TicketsDetailDTO ticketDetailsDto = new TicketsDetailDTO();
                        ticketDetailsDto.setReservationid(reservationid);
                        ticketDetailsDto.setMatchid(matchid);
                        ticketDetailsDto.setSeatid(seat);
                        ticketDetailsDto.setPrice(totalPrice / seats.split(",").length);
                        ticketDetailsDto.setTotalamount(totalPrice / seats.split(",").length);
                        ticketDetailsDto.setIscanceled(false);
                        ticketDetailsDto.setIsrefunded(false);

                        ticketsDao.insertTicketDetail(ticketDetailsDto);
                    }

                    response.put("success", true);
                    response.put("reservationid", reservationid);
                } else {
                    response.put("success", false);
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.put("success", false);
            }
        } else {
            response.put("success", false);
        }

        return response;
    }

    private String generateReservationId() {
        String prefix = "reservation";
        String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
        int randomNumber = (int) (Math.random() * 100000);
        return String.format("%s%s%05d", prefix, date, randomNumber);
    }

    @DeleteMapping("/cancelPayment")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestParam String imp_uid) {
        Map<String, Object> response = new HashMap<>();

        String token = getToken();
        if (token == null) {
            response.put("success", false);
            response.put("message", "Failed to get token");
            return response;
        }

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);

        Map<String, Object> body = new HashMap<>();
        body.put("reason", "고객 요청에 의한 결제 취소");

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
        ResponseEntity<String> cancelResponse = restTemplate.exchange(
            "https://api.iamport.kr/payments/cancel/" + imp_uid,
            HttpMethod.POST,
            entity,
            String.class);

        if (cancelResponse.getStatusCode() == HttpStatus.OK) {
            try {
                JSONObject cancelJson = new JSONObject(cancelResponse.getBody());
                boolean success = cancelJson.getJSONObject("response").getBoolean("cancelled");
                if (success) {
                    response.put("success", true);
                    response.put("message", "Payment cancelled successfully");
                } else {
                    response.put("success", false);
                    response.put("message", "Failed to cancel payment");
                }
            } catch (Exception e) {
                e.printStackTrace();
                response.put("success", false);
                response.put("message", "Exception occurred while cancelling payment");
            }
        } else {
            response.put("success", false);
            response.put("message", "Failed to cancel payment");
        }

        return response;
    }

    private String getToken() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> request = new HashMap<>();
            request.put("imp_key", env.getProperty("iamport.api_key"));
            request.put("imp_secret", env.getProperty("iamport.api_secret"));

            ObjectMapper objectMapper = new ObjectMapper();
            String requestBody = objectMapper.writeValueAsString(request);

            System.out.println("Request Body: " + requestBody);

            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                JSONObject json = new JSONObject(response.getBody());
                return json.getJSONObject("response").getString("access_token");
            } else {
                System.out.println("Failed to get token, response: " + response.getBody());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
}
