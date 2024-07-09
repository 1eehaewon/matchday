package kr.co.matchday.tickets;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.matchday.matches.MatchesDTO;

import org.mybatis.spring.SqlSessionTemplate;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {

    @Autowired
    private Environment env;

    @Autowired
    private TicketsDAO ticketsDao;

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate;

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
    @Transactional
    public Map<String, Object> verifyPayment(
            @RequestParam Map<String, String> requestParams,
            @RequestParam("seats") String seatsJson,
            HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        System.out.println("verifyPayment 시작");

        // Request parameters
        String imp_uid = requestParams.get("imp_uid");
        String merchant_uid = requestParams.get("merchant_uid");
        int paid_amount = Integer.parseInt(requestParams.get("paid_amount"));
        String matchid = requestParams.get("matchid");
        int totalPrice = Integer.parseInt(requestParams.get("totalPrice"));
        String recipientname = requestParams.get("recipientname");
        String shippingaddress = requestParams.get("shippingaddress");
        String shippingrequest = requestParams.get("shippingrequest");
        String collectionmethodcode = requestParams.get("collectionmethodcode");

        // JSON 파싱
        System.out.println("seatsJson: " + seatsJson);
        ObjectMapper objectMapper = new ObjectMapper();
        List<String> seats;
        try {
            seats = objectMapper.readValue(seatsJson, new TypeReference<List<String>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "좌석 정보를 파싱하는 중 오류가 발생했습니다.");
            return response;
        }

        // seats 리스트 값 출력
        System.out.println("seats: " + seats);

        // 토큰 획득
        String token = getToken();
        if (token == null) {
            response.put("success", false);
            System.out.println("토큰을 가져오지 못했습니다.");
            return response;
        }

        // 아임포트 API를 통해 결제 정보 조회
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> paymentResponse = restTemplate.exchange(
                "https://api.iamport.kr/payments/" + imp_uid, HttpMethod.GET, entity, String.class);

        if (paymentResponse.getStatusCode() == HttpStatus.OK) {
            try {
                Map<String, Object> paymentJson = objectMapper.readValue(paymentResponse.getBody(), Map.class);
                Map<String, Object> responseJson = (Map<String, Object>) paymentJson.get("response");
                int amount = (Integer) responseJson.get("amount");

                if (amount == paid_amount) {
                    System.out.println("결제 금액이 일치합니다.");

                    // 예약 ID 생성
                    String reservationid = generateReservationId();

                    // 세션에서 사용자 ID 가져오기
                    String userId = (String) session.getAttribute("userID");
                    if (userId == null) {
                        response.put("success", false);
                        response.put("message", "세션에서 사용자 ID를 찾을 수 없습니다.");
                        System.out.println("세션에서 사용자 ID를 찾을 수 없습니다.");
                        return response;
                    }

                    // 현재 시간
                    String currentTimestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

                    // TicketsDTO 객체 생성 및 설정
                    TicketsDTO ticketsDto = new TicketsDTO();
                    ticketsDto.setReservationid(reservationid);
                    ticketsDto.setMatchid(matchid);
                    ticketsDto.setQuantity(seats.size());
                    ticketsDto.setPrice(totalPrice);
                    ticketsDto.setUserid(userId);
                    ticketsDto.setPaymentmethodcode("pay01");
                    ticketsDto.setReservationstatus("Confirmed");
                    ticketsDto.setCollectionmethodcode(collectionmethodcode);
                    ticketsDto.setReservationdate(currentTimestamp);
                    ticketsDto.setRecipientname(recipientname);
                    ticketsDto.setShippingaddress(shippingaddress);
                    ticketsDto.setShippingrequest(shippingrequest);

                    // 티켓 예약 정보 삽입
                    ticketsDao.insertTicket(ticketsDto);
                    System.out.println("티켓 삽입 결과: 1");

                    // 티켓 상세 정보 삽입
                    for (String seatId : seats) {
                        System.out.println("좌석 ID: " + seatId);
                        // 각 좌석 정보 가져오기
                        Map<String, Object> seatInfo = ticketsDao.getSeatInfo(seatId);
                        if (seatInfo != null) {
                            TicketsDetailDTO ticketsDetailDto = new TicketsDetailDTO();
                            ticketsDetailDto.setReservationid(reservationid);
                            ticketsDetailDto.setMatchid(matchid);
                            ticketsDetailDto.setSeatid((String) seatInfo.get("seatid"));
                            ticketsDetailDto.setPrice((Integer) seatInfo.get("price"));
                            ticketsDetailDto.setTotalamount((Integer) seatInfo.get("price"));
                            ticketsDetailDto.setIscanceled(false);
                            ticketsDetailDto.setIsrefunded(false);

                            ticketsDao.insertTicketDetail(ticketsDetailDto);
                            System.out.println("좌석 ID: " + seatId + " 삽입 완료");
                        } else {
                            System.out.println("좌석 정보를 찾을 수 없습니다. 좌석 ID: " + seatId);
                        }
                    }

                    response.put("success", true);
                } else {
                    response.put("success", false);
                    response.put("message", "결제 금액이 일치하지 않습니다.");
                    System.out.println("결제 금액이 일치하지 않습니다.");
                }
            } catch (Exception e) {
                response.put("success", false);
                response.put("message", "결제 검증 중 오류 발생.");
                e.printStackTrace();
            }
        } else {
            response.put("success", false);
            response.put("message", "결제 정보를 가져오지 못했습니다.");
            System.out.println("결제 정보를 가져오지 못했습니다.");
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
