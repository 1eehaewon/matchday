package kr.co.matchday.tickets;

import java.io.IOException;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
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

import com.example.websocket.WebSocketController;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.matches.MatchesDTO;
import kr.co.matchday.point.PointHistoryDTO;

import org.mybatis.spring.SqlSessionTemplate;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {

    @Autowired
    private Environment env; // 환경변수를 관리하는 객체

    @Autowired
    private TicketsService ticketsService; // 티켓 관련 Service 객체

    @Autowired
    private SqlSessionTemplate sqlSessionTemplate; // MyBatis의 SqlSessionTemplate 객체
    
    @Autowired
    private WebSocketController webSocketController; // WebSocketController 주입

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
        MatchesDTO matchesDto = ticketsService.getMatchById(matchid);
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
        List<Map<String, Object>> seats = ticketsService.getSeatsByStadiumIdAndSection(stadiumid, section);
        List<String> reservedSeats = ticketsService.getReservedSeats(matchid);
        ModelAndView mav = new ModelAndView("tickets/seatmap");
        mav.addObject("section", section);
        mav.addObject("stadiumid", stadiumid);
        mav.addObject("matchid", matchid);

        try {
            ObjectMapper objectMapper = new ObjectMapper();
            String seatsJson = objectMapper.writeValueAsString(seats);
            String reservedSeatsJson = objectMapper.writeValueAsString(reservedSeats);
            mav.addObject("seatsJson", seatsJson);
            mav.addObject("reservedSeatsJson", reservedSeatsJson);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            mav.addObject("seatsJson", "[]");
            mav.addObject("reservedSeatsJson", "[]");
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

        MatchesDTO match = ticketsService.getMatchById(matchId);
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
        Map<String, Object> userInfo = userId != null ? ticketsService.getUserInfo(userId) : new HashMap<>();
        List<CouponDTO> coupons = ticketsService.getCouponsByUserId(userId);

        List<Map<String, Object>> memberships = ticketsService.getMembershipsByUserId(userId);
        List<Map<String, Object>> applicableMemberships = new ArrayList<>();

        for (Map<String, Object> membership : memberships) {
            String teamName = (String) membership.get("teamname");
            if (teamName != null) {
                if (teamName.equals(match.getHometeamid()) || teamName.equals(match.getAwayteamid())) {
                    applicableMemberships.add(membership);
                }
            }
        }

        model.addAttribute("match", match);
        model.addAttribute("seats", seatList);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("section", section);
        model.addAttribute("stadiumid", stadiumId);
        model.addAttribute("userInfo", userInfo);
        model.addAttribute("coupons", coupons);
        model.addAttribute("memberships", applicableMemberships);

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
        String maxReservationId = ticketsService.getMaxReservationId(date);
        
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
        String couponId = requestParams.get("couponid");
        String membershipId = requestParams.get("membershipid");

        // 쿠폰 ID가 null 또는 빈 문자열이면 null로 설정
        if (couponId == null || couponId.trim().isEmpty() || "0".equals(couponId)) {
            couponId = null;
        }

        // imp_uid 로그 출력
        System.out.println("imp_uid: " + imp_uid);

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

        // 좌석 가용성 확인
        String userId = (String) session.getAttribute("userID");
        if (!webSocketController.checkIfSeatsAvailable(seats.toArray(new String[0]), userId)) {
            response.put("success", false);
            response.put("message", "다른 사용자가 구매진행중인 좌석이 있습니다.");
            return response;
        }

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
                    ticketsDto.setImpUid(imp_uid); // 결제 UID 설정
                    ticketsDto.setCouponid(couponId); // 쿠폰 ID 설정 (null 일 수 있음)
                    ticketsDto.setMembershipid(membershipId); // 멤버십 ID 설정
                    ticketsDto.setMethodcode("someMethodCode"); // 방법 코드 설정
                    ticketsDto.setFinalpaymentamount(paid_amount); // 최종 결제 금액 설정

                    // 티켓 예약 정보 삽입
                    ticketsService.insertTicket(ticketsDto);
                    System.out.println("티켓 삽입 결과: 1");

                    // 티켓 상세 정보 삽입
                    for (String seatId : seats) {
                        // 대괄호 제거
                        seatId = seatId.replace("[", "").replace("]", "").trim();
                        System.out.println("좌석 ID: " + seatId);

                        // 각 좌석 정보 가져오기
                        Map<String, Object> seatInfo = ticketsService.getSeatInfo(seatId);
                        if (seatInfo != null) {
                            TicketsDetailDTO ticketsDetailDto = new TicketsDetailDTO();
                            ticketsDetailDto.setReservationid(reservationid);
                            ticketsDetailDto.setMatchid(matchid);
                            ticketsDetailDto.setSeatid((String) seatInfo.get("seatid"));
                            ticketsDetailDto.setPrice((Integer) seatInfo.get("price"));
                            ticketsDetailDto.setTotalamount((Integer) seatInfo.get("price"));
                            ticketsDetailDto.setIscanceled(false);
                            ticketsDetailDto.setIsrefunded(false);

                            ticketsService.insertTicketDetail(ticketsDetailDto);
                            System.out.println("좌석 ID: " + seatId + " 삽입 완료");
                        } else {
                            System.out.println("좌석 정보를 찾을 수 없습니다. 좌석 ID: " + seatId);
                        }
                    }

                    // 결제가 완료된 후 쿠폰 사용 업데이트
                    if (couponId != null && !couponId.equals("0")) {
                        int updateResult = ticketsService.updateCouponUsage(couponId);
                        if (updateResult > 0) {
                            System.out.println("쿠폰 사용 업데이트 성공: " + couponId);
                        } else {
                            System.out.println("쿠폰 사용 업데이트 실패: " + couponId);
                        }
                    }

                    // 결제가 완료된 후 포인트 적립
                    String pointcategoryid = "15"; // 예매적립 ID
                    double rate = ticketsService.getRateByCategoryId(pointcategoryid); // rate 가져오기
                    int pointsToAccumulate = (int) (paid_amount * rate); // 결제 금액의 rate 비율로 포인트 계산

                    // PointHistoryDTO 객체 생성 및 설정
                    PointHistoryDTO pointHistoryDto = new PointHistoryDTO();
                    pointHistoryDto.setUserid(userId);
                    pointHistoryDto.setPointcategoryid(pointcategoryid);
                    pointHistoryDto.setPointtype("적립");
                    pointHistoryDto.setPointsource("좌석예매 포인트 적립");
                    pointHistoryDto.setPointamount(pointsToAccumulate);
                    pointHistoryDto.setPointcreationdate(Timestamp.valueOf(currentTimestamp));
                    pointHistoryDto.setReservationid(reservationid); // reservationid 설정

                    ticketsService.insertPointHistory(pointHistoryDto);

                    // 세션에 결제 정보 저장
                    session.setAttribute("serviceFee", requestParams.get("serviceFee"));
                    session.setAttribute("deliveryFee", requestParams.get("deliveryFee"));
                    session.setAttribute("couponName", requestParams.get("couponName"));
                    session.setAttribute("membershipName", requestParams.get("membershipName"));
                    session.setAttribute("totalDiscount", requestParams.get("totalDiscount"));
                    session.setAttribute("totalPaymentAmount", requestParams.get("totalPaymentAmount"));
                    
                    // 세션에 수령 방법 코드 저장
                    session.setAttribute("collectionmethodcode", collectionmethodcode);

                    response.put("success", true);
                    response.put("redirectUrl", "/tickets/reservationList?reservationid=" + reservationid);
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
     * @param reservationid 예약 ID
     * @param impUid 결제 UID
     * @return 취소 결과 맵
     */
    @PostMapping("/cancelPayment")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestParam("reservationid") String reservationid) {
        Map<String, Object> response = new HashMap<>();

        try {
            // reservationid로 imp_uid 가져오기
            String impUid = ticketsService.getImpUidByReservationId(reservationid);

            if (impUid == null || impUid.isEmpty()) {
                response.put("success", false);
                response.put("message", "결제 정보를 찾을 수 없습니다.");
                return response;
            }

            // 아임포트 API를 통해 결제 취소
            String token = getToken();
            if (token == null) {
                response.put("success", false);
                response.put("message", "토큰을 가져오지 못했습니다.");
                return response;
            }

            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(token);
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> body = new HashMap<>();
            body.put("imp_uid", impUid);
            body.put("reason", "사용자 요청에 의한 취소");

            HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<String> cancelResponse = restTemplate.postForEntity(
                    "https://api.iamport.kr/payments/cancel", entity, String.class);

            if (cancelResponse.getStatusCode() == HttpStatus.OK) {
                // 결제 취소 성공 시 포인트 적립 취소 처리
                ticketsService.cancelPointHistoryByReservationId(reservationid);

                // 예약 상태 업데이트 (취소 처리)
                ticketsService.updateReservationStatus(reservationid, "Cancelled");

                response.put("success", true);
                response.put("message", "결제가 성공적으로 취소되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "결제 취소에 실패했습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "결제 취소 처리 중 오류가 발생했습니다.");
            e.printStackTrace();
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

            String apiKey = env.getProperty("iamport.api_key");
            String apiSecret = env.getProperty("iamport.api_secret");

            Map<String, String> request = new HashMap<>();
            request.put("imp_key", apiKey);
            request.put("imp_secret", apiSecret);

            String jsonRequest = new ObjectMapper().writeValueAsString(request);
            HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

            ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                JSONObject json = new JSONObject(response.getBody());
                if (!json.isNull("response")) {
                    return json.getJSONObject("response").getString("access_token");
                } else {
                    System.out.println("Failed to get token, response is null: " + json.getString("message"));
                }
            } else {
                System.out.println("Failed to get token, response: " + response.getBody());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }

    /**
     * 예약 목록 페이지로 이동
     * @param session 세션 객체
     * @return ModelAndView 객체
     */
    @GetMapping("/reservationList")
    public ModelAndView reservationList(HttpSession session) {
        String userId = (String) session.getAttribute("userID");
        if (userId == null) {
            System.out.println("User ID not found in session.");
            return new ModelAndView("redirect:/login"); // 로그인 페이지로 리다이렉트
        }

        System.out.println("Fetching reservations for userId: " + userId);
        List<Map<String, Object>> reservations = ticketsService.getReservationsByUserId(userId);

        ModelAndView mav = new ModelAndView("tickets/reservationList");
        mav.addObject("reservations", reservations);
        return mav;
    }
    
    /**
     * reservationdate를 String에서 Date로 변환하는 유틸리티 메서드
     * @param dateString 날짜 문자열
     * @return Date 객체
     */
    private Date convertStringToDate(String dateString) {
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        try {
            return formatter.parse(dateString);
        } catch (ParseException e) {
            e.printStackTrace();
            return null;
        }
    }
    
    /**
     * 예약 상세 정보 페이지로 이동
     * @param reservationid 예약 ID
     * @return ModelAndView 객체
     */
    @GetMapping("/reservationDetail")
    public ModelAndView reservationDetail(@RequestParam("reservationid") String reservationid, HttpSession session) {
        ModelAndView mav = new ModelAndView("tickets/reservationDetail");

        // 예약 정보 조회
        TicketsDTO reservation = ticketsService.getReservationById(reservationid);
        if (reservation == null) {
            mav.setViewName("errorPage");
            mav.addObject("message", "Reservation not found for ID: " + reservationid);
            return mav;
        }

        // 티켓 상세 정보 조회
        List<TicketsDetailDTO> details = ticketsService.getTicketDetailsByReservationId(reservationid);
        reservation.setDetails(details);

        // 예약 날짜를 Date 객체로 변환
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date reservationDate = null;
        try {
            reservationDate = formatter.parse(reservation.getReservationdate());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        mav.addObject("reservationDate", reservationDate);

        // 취소 마감시간 설정 (임의로 3일 전으로 설정)
        Calendar cal = Calendar.getInstance();
        cal.setTime(reservation.getMatchdate());
        cal.add(Calendar.DATE, -3);
        reservation.setCancelDeadline(cal.getTime());

        // 결제 내역 설정
        int serviceFee = session.getAttribute("serviceFee") != null ? Integer.parseInt(session.getAttribute("serviceFee").toString()) : 0;
        int deliveryFee = session.getAttribute("deliveryFee") != null ? Integer.parseInt(session.getAttribute("deliveryFee").toString()) : 0;
        int totalDiscount = session.getAttribute("totalDiscount") != null ? Integer.parseInt(session.getAttribute("totalDiscount").toString()) : 0;
        int totalPrice = reservation.getPrice() * reservation.getQuantity();
        int totalPaymentAmount = session.getAttribute("totalPaymentAmount") != null ? Integer.parseInt(session.getAttribute("totalPaymentAmount").toString()) : 0;
        String couponName = session.getAttribute("couponName") != null ? session.getAttribute("couponName").toString() : "";
        String membershipName = session.getAttribute("membershipName") != null ? session.getAttribute("membershipName").toString() : "";

        mav.addObject("serviceFee", serviceFee);
        mav.addObject("deliveryFee", deliveryFee);
        mav.addObject("couponName", couponName);
        mav.addObject("membershipName", membershipName);
        mav.addObject("totalDiscount", totalDiscount);
        mav.addObject("totalPrice", totalPrice);
        mav.addObject("totalPaymentAmount", totalPaymentAmount);
        mav.addObject("reservation", reservation);

        return mav;
    }
    
    @GetMapping("/generateQRCode")
    @ResponseBody
    public ResponseEntity<byte[]> generateQRCode(@RequestParam("reservationid") String reservationid) {
        try {
            TicketsDTO reservation = ticketsService.getReservationById(reservationid);
            if (reservation == null) {
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }
            
            List<TicketsDetailDTO> details = ticketsService.getTicketDetailsByReservationId(reservationid);
            
            // QR 코드에 포함될 정보를 JSON 형식으로 생성
            Map<String, Object> qrData = new HashMap<>();
            qrData.put("reservationid", reservationid);
            qrData.put("matchid", reservation.getMatchid());
            qrData.put("seats", details.stream().map(TicketsDetailDTO::getSeatid).toArray());
            qrData.put("username", reservation.getUserName());
            qrData.put("matchdate", reservation.getMatchdate().getTime()); // 타임스탬프로 변환
			/*
			 * qrData.put("stadiumid", reservation.getStadiumName()); // 경기장 ID 추가
			 */            
            ObjectMapper objectMapper = new ObjectMapper();
            String qrText = objectMapper.writeValueAsString(qrData);
            
            byte[] qrImage = QRCodeGenerator.generateQRCodeImage(qrText, 200, 200);
            
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_PNG);
            return new ResponseEntity<>(qrImage, headers, HttpStatus.OK);
        } catch (Exception e) {
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }
}
