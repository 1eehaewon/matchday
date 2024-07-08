package kr.co.matchday.tickets;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Controller;
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

    /**
     * 주어진 matchid에 해당하는 경기의 티켓 예매 페이지를 반환하는 메서드.
     * @param matchid 경기 ID
     * @return ModelAndView 티켓 예매 페이지와 경기 정보
     */
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

    /**
     * 주어진 matchid와 section에 해당하는 좌석 배치도 페이지를 반환하는 메서드.
     * @param matchid 경기 ID
     * @param section 구역
     * @return ModelAndView 좌석 배치도 페이지와 좌석 정보
     */
    @GetMapping("/seatmap")
    public ModelAndView seatmap(@RequestParam String matchid, @RequestParam String section) {
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }
        Map<String, Object> seatsData = generateSeats(section);
        ModelAndView mav = new ModelAndView("tickets/seatmap");
        mav.addObject("section", section);
        mav.addObject("match", matchesDto);
        try {
            ObjectMapper objectMapper = new ObjectMapper();
            mav.addObject("seatsJson", objectMapper.writeValueAsString(seatsData.get("seats")));
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            mav.addObject("seatsJson", "[]");
        }
        return mav;
    }

    /**
     * 주어진 matchid, seats, totalPrice로 예매 확인 페이지를 반환하는 메서드.
     * @param matchid 경기 ID
     * @param seats 선택한 좌석들
     * @param totalPrice 총 금액
     * @param session 사용자 세션
     * @return ModelAndView 예매 확인 페이지와 예매 정보
     */
    @GetMapping("/reservation")
    public ModelAndView reservation(@RequestParam String matchid, @RequestParam String seats, @RequestParam int totalPrice, HttpSession session) {
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }

        String userId = (String) session.getAttribute("userID");
        System.out.println("UserID from session: " + userId);  // 로그 추가
        Map<String, Object> userInfo = ticketsDao.getUserInfo(userId);
        System.out.println("UserInfo from DB: " + userInfo);  // 로그 추가

        // 취소일자를 경기일의 3일 전으로 설정
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(matchesDto.getMatchdate());
        calendar.add(Calendar.DAY_OF_MONTH, -3);
        matchesDto.setCancellationDeadline(calendar.getTime());

        ModelAndView mav = new ModelAndView("tickets/reservation");
        mav.addObject("match", matchesDto);
        mav.addObject("userInfo", userInfo); // 사용자 정보 추가
        String[] seatArray = seats.split(",");
        mav.addObject("seats", seatArray); // 선택한 좌석 정보를 배열로 전달
        mav.addObject("totalPrice", totalPrice); // 총 티켓 금액 전달

        return mav;
    }

    /**
     * 아임포트 결제 검증 및 티켓 예약 처리 메서드.
     * @param imp_uid 아임포트 결제 UID
     * @param merchant_uid 상점 거래 UID
     * @param paid_amount 결제 금액
     * @param matchid 경기 ID
     * @param seats 선택한 좌석들
     * @param totalPrice 총 금액
     * @param deliveryOption 배송 방법
     * @param recipientName 수령인 이름
     * @param shippingAddress 배송 주소
     * @param shippingRequest 배송 요청사항
     * @param session 사용자 세션
     * @return Map<String, Object> 결제 검증 결과
     */
    @PostMapping("/verifyPayment")
    @ResponseBody
    public Map<String, Object> verifyPayment(@RequestParam String imp_uid, @RequestParam String merchant_uid, @RequestParam int paid_amount, @RequestParam String matchid, @RequestParam String seats, @RequestParam int totalPrice, @RequestParam(required = false) String recipientname, @RequestParam(required = false) String shippingaddress, @RequestParam(required = false) String shippingrequest, @RequestParam String collectionmethodcode, HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // 아임포트 인증 토큰 발급
        String token = getToken();
        if (token == null) {
            response.put("success", false);
            return response;
        }

        // 결제 정보 조회
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> paymentResponse = restTemplate.exchange("https://api.iamport.kr/payments/" + imp_uid, HttpMethod.GET, entity, String.class);

        if (paymentResponse.getStatusCode() == HttpStatus.OK) {
            try {
                JSONObject paymentJson = new JSONObject(paymentResponse.getBody());
                int amount = paymentJson.getJSONObject("response").getInt("amount");

                if (amount == paid_amount) {
                    // 결제 금액이 일치하면 결제 완료 처리
                    String reservationid = generateReservationId();

                    // 세션에서 사용자 ID를 가져옵니다.
                    String userId = (String) session.getAttribute("userID");
                    if (userId == null) {
                        response.put("success", false);
                        response.put("message", "User ID not found in session");
                        return response;
                    }

                    // 티켓 예약 정보 저장
                    TicketsDTO ticketsDto = new TicketsDTO();
                    ticketsDto.setReservationid(reservationid);
                    ticketsDto.setMatchid(matchid);
                    ticketsDto.setQuantity(seats.split(",").length);
                    ticketsDto.setPrice(totalPrice);
                    ticketsDto.setUserid(userId); // 실제 사용자 ID로 교체
                    ticketsDto.setPaymentmethodcode("pay01"); // 결제 방법 설정
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
                    response.put("reservationid", reservationid); // 실제 예약 ID 반환
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


    /**
     * 아임포트 결제 취소 처리 메서드.
     * @param imp_uid 아임포트 결제 UID
     * @return Map<String, Object> 결제 취소 결과
     */
    @DeleteMapping("/cancelPayment")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestParam String imp_uid) {
        Map<String, Object> response = new HashMap<>();

        // 아임포트 인증 토큰 발급
        String token = getToken();
        if (token == null) {
            response.put("success", false);
            response.put("message", "Failed to get token");
            return response;
        }

        // 결제 취소 요청
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
            String.class
        );

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

    /**
     * 아임포트 인증 토큰을 발급받는 메서드.
     * @return String 아임포트 인증 토큰
     */
    private String getToken() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> request = new HashMap<>();
            request.put("imp_key", env.getProperty("iamport.api_key"));
            request.put("imp_secret", env.getProperty("iamport.api_secret"));

            // 요청 바디를 JSON 형식으로 직렬화
            ObjectMapper objectMapper = new ObjectMapper();
            String requestBody = objectMapper.writeValueAsString(request);

            // 디버깅 로그 추가
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


    /**
     * 주어진 section에 해당하는 좌석 배치도를 생성하는 메서드.
     * @param section 구역
     * @return Map<String, Object> 좌석 배치도 정보
     */
    private Map<String, Object> generateSeats(String section) {
        int rows = 20;
        int cols = 20;
        String[][] seats = new String[rows][cols];

        // 각 섹션에 대한 좌석 번호 할당
        switch (section.toLowerCase()) {
            case "north":
                for (int i = rows - 1; i >= 0; i--) {
                    for (int j = 0; j < cols; j++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf(i * cols + j + 1);
                    }
                }
                break;
            case "south":
                for (int i = 0; i < rows; i++) {
                    for (int j = 0; j < cols; j++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf(i * cols + j + 1);
                    }
                }
                break;
            case "east":
                for (int j = 0; j < cols; j++) {
                    for (int i = 0; i < rows; i++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf(j * rows + i + 1);
                    }
                }
                break;
            case "west":
                for (int j = cols - 1; j >= 0; j--) {
                    for (int i = 0; i < rows; i++) {
                        seats[i][j] = section.toUpperCase().charAt(0) + String.valueOf((cols - j - 1) * rows + i + 1);
                    }
                }
                break;
        }

        Map<String, Object> seatMap = new HashMap<>();
        seatMap.put("seats", seats);
        return seatMap;
    }
    
    /**
     * 최근 결제 정보를 가져오는 메서드.
     * @return List<String> 결제 정보 리스트
     */
    @GetMapping("/payments/recent")
    @ResponseBody
    public List<String> getRecentPayments() {
        String token = getToken();
        if (token == null) {
            return Collections.emptyList();
        }

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> response = restTemplate.exchange(
            "https://api.iamport.kr/payments/status/paid",
            HttpMethod.GET,
            entity,
            String.class
        );

        List<String> impUids = new ArrayList<>();
        if (response.getStatusCode() == HttpStatus.OK) {
            JSONObject json = new JSONObject(response.getBody());
            JSONArray payments = json.getJSONObject("response").getJSONArray("list");
            for (int i = 0; i < payments.length(); i++) {
                String impUid = payments.getJSONObject(i).getString("imp_uid");
                impUids.add(impUid);
                System.out.println("imp_uid: " + impUid); // 콘솔에 출력
            }
        }

        return impUids;
    }
}
