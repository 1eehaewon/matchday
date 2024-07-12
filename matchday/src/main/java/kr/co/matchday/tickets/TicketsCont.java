package kr.co.matchday.tickets;

import java.io.IOException;
import java.text.SimpleDateFormat;
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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.matches.MatchesDTO;
import org.mybatis.spring.SqlSessionTemplate;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {

    @Autowired
    private Environment env; // 환경변수를 관리하는 객체

    @Autowired
    private TicketsDAO ticketsDao; // 티켓 관련 DAO 객체

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate; // MyBatis의 SqlSessionTemplate 객체

    public TicketsCont() {
        System.out.println("----TicketsCont() 객체 생성");
    }

    /**
     * 티켓 결제 페이지로 이동
     * @param matchid 경기 ID
     * @return ModelAndView 객체
     */
    @GetMapping("/ticketspayment")
    public ModelAndView ticketspayment(@RequestParam String matchid) {
        System.out.println("Received matchid: " + matchid);

        // 경기 정보를 가져옴
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }

        // ModelAndView 객체를 생성하여 반환
        ModelAndView mav = new ModelAndView("tickets/ticketspayment");
        mav.addObject("match", matchesDto);
        return mav;
    }

    /**
     * 좌석 배치도를 보여주는 페이지로 이동
     * @param stadiumid 경기장 ID
     * @param section 구역
     * @param matchid 경기 ID
     * @return ModelAndView 객체
     */
    @GetMapping("/seatmap")
    public ModelAndView seatmap(@RequestParam String stadiumid, @RequestParam String section, @RequestParam String matchid) {
        // 경기장 ID와 구역에 따른 좌석 정보를 가져옴
        List<Map<String, Object>> seats = ticketsDao.getSeatsByStadiumIdAndSection(stadiumid, section);
        ModelAndView mav = new ModelAndView("tickets/seatmap");
        mav.addObject("section", section);
        mav.addObject("stadiumid", stadiumid);
        mav.addObject("matchid", matchid);

        try {
            // 좌석 정보를 JSON 형태로 변환하여 추가
            ObjectMapper objectMapper = new ObjectMapper();
            String seatsJson = objectMapper.writeValueAsString(seats);
            mav.addObject("seatsJson", seatsJson);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            mav.addObject("seatsJson", "[]");
        }

        return mav;
    }

    /**
     * 예약 확인 페이지로 이동
     * @param matchId 경기 ID
     * @param seats 좌석 목록
     * @param totalPrice 총 가격
     * @param section 구역
     * @param stadiumId 경기장 ID
     * @param session 세션 객체
     * @param model 모델 객체
     * @return 예약 확인 페이지 뷰 이름
     */
    @GetMapping("/reservation")
    public String showReservationPage(
            @RequestParam("matchid") String matchId,
            @RequestParam("seats") String seatsJson,
            @RequestParam("totalPrice") int totalPrice,
            @RequestParam("section") String section,
            @RequestParam("stadiumid") String stadiumId,
            HttpSession session,
            Model model) {

        // 경기 정보 가져오기
        MatchesDTO match = ticketsDao.getMatchById(matchId);
        if (match == null) {
            return "error";
        }

        List<String> seatList = null;
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            seatList = objectMapper.readValue(seatsJson, new TypeReference<List<String>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            return "error";
        }

        String userId = (String) session.getAttribute("userID");
        Map<String, Object> userInfo = userId != null ? ticketsDao.getUserInfo(userId) : new HashMap<>();

        // 사용자의 쿠폰 정보 조회
        List<CouponDTO> coupons = ticketsDao.getCouponsByUserId(userId);

        model.addAttribute("match", match);
        model.addAttribute("seats", seatList);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("section", section);
        model.addAttribute("stadiumid", stadiumId);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("coupons", coupons); // 쿠폰 정보를 모델에 추가

        return "tickets/reservation";
    }
    
    
    /**
     * 예약 ID 생성 메서드
     * @return 예약 ID 문자열
     */
    private String generateReservationId() {
        String prefix = "reservation";
        String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
        // 주어진 날짜에 대한 현재 최대 예약 ID를 가져옴
        String maxReservationId = ticketsDao.getMaxReservationId(date);
        
        int nextSuffix = 1;
        if (maxReservationId != null) {
            // 예약 ID의 숫자 부분을 추출하여 다음 순번을 계산
            nextSuffix = Integer.parseInt(maxReservationId.substring(maxReservationId.length() - 6)) + 1;
        }
        
        // 새로운 예약 ID를 생성하여 반환
        return String.format("%s%s%06d", prefix, date, nextSuffix);
    }

    /**
     * 결제 검증 메서드
     * @param requestParams 요청 파라미터 맵
     * @param seatsJson 좌석 목록 JSON 문자열
     * @param session 세션 객체
     * @return 검증 결과 맵
     */
    @PostMapping("/verifyPayment")
    @ResponseBody
    public Map<String, Object> verifyPayment(
            @RequestParam Map<String, String> requestParams,
            @RequestParam("seats") String seatsJson,
            HttpSession session) {

        Map<String, Object> response = new HashMap<>();
        System.out.println("verifyPayment 시작");

        // 요청 파라미터를 추출
        String imp_uid = requestParams.get("imp_uid");
        String merchant_uid = requestParams.get("merchant_uid");
        int paid_amount = Integer.parseInt(requestParams.get("paid_amount"));
        String matchid = requestParams.get("matchid");
        int totalPrice = Integer.parseInt(requestParams.get("totalPrice"));
        String recipientname = requestParams.get("recipientname");
        String shippingaddress = requestParams.get("shippingaddress");
        String shippingrequest = requestParams.get("shippingrequest");
        String collectionmethodcode = requestParams.get("collectionmethodcode");
        String couponId = requestParams.get("couponid"); // 쿠폰 ID 추가

        // 좌석 정보 JSON 파싱
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
                // 결제 정보를 JSON으로 파싱
                Map<String, Object> paymentJson = objectMapper.readValue(paymentResponse.getBody(), Map.class);
                Map<String, Object> responseJson = (Map<String, Object>) paymentJson.get("response");
                int amount = (Integer) responseJson.get("amount");

                if (amount == paid_amount) {
                    System.out.println("결제 금액이 일치합니다.");

                    // 세션에서 사용자 ID 가져오기
                    String userId = (String) session.getAttribute("userID");
                    if (userId == null) {
                        response.put("success", false);
                        response.put("message", "세션에서 사용자 ID를 찾을 수 없습니다.");
                        System.out.println("세션에서 사용자 ID를 찾을 수 없습니다.");
                        return response;
                    }

                    String currentTimestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

                    // 예약 ID 생성
                    String reservationid = generateReservationId();

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
                        // 대괄호 제거
                        seatId = seatId.replace("[", "").replace("]", "").trim();
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

                    // 결제가 완료된 후 쿠폰 사용 업데이트
                    if (couponId != null && !couponId.equals("0")) {
                        int updateResult = ticketsDao.updateCouponUsage(couponId);
                        if (updateResult > 0) {
                            System.out.println("쿠폰 사용 업데이트 성공: " + couponId);
                        } else {
                            System.out.println("쿠폰 사용 업데이트 실패: " + couponId);
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
    /**
     * 결제 취소 메서드
     * @param imp_uid 아임포트 UID
     * @return 취소 결과 맵
     */
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

    /**
     * 아임포트 API 토큰 획득 메서드
     * @return API 토큰 문자열
     */
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
    
    @GetMapping("/reservationList")
    public String reservationList() {
    	return "tickets/reservationList";
    }
}