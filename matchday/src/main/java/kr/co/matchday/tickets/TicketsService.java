package kr.co.matchday.tickets;

import java.io.IOException;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.*;
import java.sql.Timestamp;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
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
import org.json.JSONObject;

@Service
public class TicketsService {

    @Autowired
    private TicketsDAO ticketsDao;
    
    private static final int PAGE_SIZE = 10;

    /**
     * 티켓 결제 페이지로 이동
     * @param matchid 경기 ID
     * @return ModelAndView 객체
     */
    public ModelAndView getTicketPaymentPage(String matchid) {
        // 주어진 매치 ID를 사용하여 매치 정보를 가져옴
        MatchesDTO matchesDto = getMatchById(matchid);

        // 매치 정보가 존재하지 않는 경우 "errorPage" 뷰와 오류 메시지를 포함하는 ModelAndView 객체 반환
        if (matchesDto == null) {
            return new ModelAndView("errorPage")
                    .addObject("message", "Match not found for ID: " + matchid);
        }

        // 매치 정보가 존재하는 경우 'tickets/ticketspayment' 뷰를 사용하는 ModelAndView 객체 생성
        ModelAndView mav = new ModelAndView("tickets/ticketspayment");

        // 모델에 매치 정보를 추가
        mav.addObject("match", matchesDto);

        // ModelAndView 객체를 반환하여 뷰와 모델 데이터 제공
        return mav;
    }


    /**
     * 좌석 배치도를 보여주는 페이지로 이동
     * @param stadiumid 경기장 ID
     * @param section 구역
     * @param matchid 경기 ID
     * @return ModelAndView 객체
     */
    public ModelAndView getSeatMapPage(String stadiumid, String section, String matchid) {
        // 주어진 경기장 ID와 섹션에 해당하는 좌석 목록을 가져옴
        List<Map<String, Object>> seats = getSeatsByStadiumIdAndSection(stadiumid, section);
        // 주어진 매치 ID에 대해 예약된 좌석 목록을 가져옴
        List<String> reservedSeats = getReservedSeats(matchid);

        // 'tickets/seatmap' 뷰를 사용하는 ModelAndView 객체 생성
        ModelAndView mav = new ModelAndView("tickets/seatmap");

        // 모델에 섹션, 경기장 ID, 매치 ID 추가
        mav.addObject("section", section);  // 좌석이 위치한 섹션
        mav.addObject("stadiumid", stadiumid);  // 경기장 ID
        mav.addObject("matchid", matchid);  // 매치 ID

        try {
            // 좌석 목록과 예약된 좌석 목록을 JSON 문자열로 변환
            ObjectMapper objectMapper = new ObjectMapper();
            String seatsJson = objectMapper.writeValueAsString(seats);  // 좌석 목록 JSON
            String reservedSeatsJson = objectMapper.writeValueAsString(reservedSeats);  // 예약된 좌석 목록 JSON
            
            // JSON 문자열을 모델에 추가
            mav.addObject("seatsJson", seatsJson);
            mav.addObject("reservedSeatsJson", reservedSeatsJson);
        } catch (JsonProcessingException e) {
            // JSON 변환 중 오류 발생 시 예외 처리
            e.printStackTrace();
            
            // 오류 발생 시 빈 배열을 JSON 문자열로 모델에 추가
            mav.addObject("seatsJson", "[]");
            mav.addObject("reservedSeatsJson", "[]");
        }

        // ModelAndView 객체를 반환하여 뷰와 모델 데이터 제공
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
    public String getReservationPage(String matchId, String seatsJson, int totalPrice, String section, String stadiumId, HttpSession session, Model model) {
        // 주어진 matchId를 사용하여 매치 정보를 가져옴
        MatchesDTO match = getMatchById(matchId);
        if (match == null) {
            // 매치 정보가 없는 경우 "error" 페이지 반환
            return "error";
        }

        // 좌석 정보가 담긴 JSON 문자열을 List<String>으로 변환
        List<String> seatList = null;
        ObjectMapper objectMapper = new ObjectMapper();
        try {
            seatList = objectMapper.readValue(seatsJson, new TypeReference<List<String>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            // JSON 파싱 중 오류가 발생한 경우 "error" 페이지 반환
            return "error";
        }

        // 세션에서 사용자 ID를 가져옴
        String userId = (String) session.getAttribute("userID");

        // 사용자 ID가 존재하는 경우 사용자 정보를 가져옴
        Map<String, Object> userInfo = userId != null ? getUserInfo(userId) : new HashMap<>();
        // 사용자 ID가 존재하는 경우 사용자에게 제공되는 쿠폰 목록을 가져옴
        List<CouponDTO> coupons = getCouponsByUserId(userId);

        // 사용자 ID로 사용자의 모든 멤버십 목록을 가져옴
        List<Map<String, Object>> allMemberships = getMembershipsByUserId(userId);

        // 모든 멤버십을 로그로 출력하여 확인
        System.out.println("All memberships: " + allMemberships);

        // 경기 팀과 일치하는 멤버십을 필터링
        List<Map<String, Object>> applicableMemberships = new ArrayList<>();
        for (Map<String, Object> membership : allMemberships) {
            String teamName = (String) membership.get("teamname");
            if (teamName != null && (teamName.equals(match.getHometeamid()) || teamName.equals(match.getAwayteamid()))) {
                applicableMemberships.add(membership);
            }
        }

        // 필터링된 멤버십을 로그로 출력하여 확인
        System.out.println("Applicable memberships: " + applicableMemberships);

        // 모델에 필요한 데이터를 추가
        model.addAttribute("match", match);  // 매치 정보
        model.addAttribute("seats", seatList);  // 좌석 목록
        model.addAttribute("totalPrice", totalPrice);  // 총 가격
        model.addAttribute("section", section);  // 섹션 정보
        model.addAttribute("stadiumid", stadiumId);  // 경기장 ID
        model.addAttribute("userInfo", userInfo);  // 사용자 정보
        model.addAttribute("coupons", coupons);  // 사용자 쿠폰 목록
        model.addAttribute("memberships", applicableMemberships);  // 적용 가능한 멤버십 목록

        // 예약 페이지의 뷰 이름 반환
        return "tickets/reservation";
    }


    /**
     * 결제 검증 메서드
     * @param requestParams 요청 파라미터 맵
     * @param seatsJson 좌석 목록 JSON 문자열
     * @param session 세션 객체
     * @param webSocketController WebSocketController 객체
     * @param env Environment 객체
     * @return 검증 결과 맵
     */
    public Map<String, Object> verifyPayment(Map<String, String> requestParams, String seatsJson, HttpSession session, WebSocketController webSocketController, Environment env) {
        Map<String, Object> response = new HashMap<>();
        System.out.println("verifyPayment 시작");

        // 요청 파라미터에서 결제 관련 정보와 기타 정보를 추출
        String imp_uid = requestParams.get("imp_uid");  // 결제 고유 ID
        String merchant_uid = requestParams.get("merchant_uid");  // 상점 고유 ID
        int paid_amount = Integer.parseInt(requestParams.get("paid_amount"));  // 실제 결제 금액
        String matchid = requestParams.get("matchid");  // 결제 ID
        int totalPrice = Integer.parseInt(requestParams.get("totalPrice"));  // 총 가격
        String recipientname = requestParams.get("recipientname");  // 수령자 이름
        String shippingaddress = requestParams.get("shippingaddress");  // 배송 주소
        String shippingrequest = requestParams.get("shippingrequest");  // 배송 요청 사항
        String collectionmethodcode = requestParams.get("collectionmethodcode");  // 수령 방법 코드
        String couponId = requestParams.get("couponid");  // 쿠폰 ID
        String membershipId = requestParams.get("membershipid");  // 멤버십 ID
        int discount = Integer.parseInt(requestParams.get("totalDiscount")); // 할인금액
        
        // 쿠폰 ID가 유효하지 않으면 null로 설정
        if (couponId == null || couponId.trim().isEmpty() || "0".equals(couponId)) {
            couponId = null;
        }

        System.out.println("imp_uid: " + imp_uid);

        // 좌석 정보가 담긴 JSON 문자열을 List<String>으로 변환
        System.out.println("seatsJson: " + seatsJson);
        ObjectMapper objectMapper = new ObjectMapper();
        List<String> seats;
        try {
            seats = objectMapper.readValue(seatsJson, new TypeReference<List<String>>() {});
        } catch (IOException e) {
            e.printStackTrace();
            response.put("success", false);
            response.put("message", "좌석 정보를 파싱하는 중 오류가 발생했습니다.");
            return response;  // 좌석 정보 파싱에 실패한 경우 오류 응답 반환
        }

        System.out.println("seats: " + seats);

        // WebSocket을 통해 좌석의 가용성 확인
        String userId = (String) session.getAttribute("userID");
        if (!webSocketController.checkIfSeatsAvailable(seats.toArray(new String[0]), userId)) {
            response.put("success", false);
            response.put("message", "다른 사용자가 구매진행중인 좌석이 있습니다.");
            return response;  // 좌석 가용성 확인 실패 시 오류 응답 반환
        }

        // API 호출을 위한 토큰 획득
        String token = getToken(env);
        if (token == null) {
            response.put("success", false);
            System.out.println("토큰을 가져오지 못했습니다.");
            return response;  // 토큰 획득 실패 시 오류 응답 반환
        }

        // 결제 정보 검증을 위한 API 호출 설정
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);  // Bearer 토큰을 사용하여 인증

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> paymentResponse = restTemplate.exchange(
                "https://api.iamport.kr/payments/" + imp_uid, HttpMethod.GET, entity, String.class);

        if (paymentResponse.getStatusCode() == HttpStatus.OK) {
            try {
                // 결제 정보 JSON을 Map으로 변환
                Map<String, Object> paymentJson = objectMapper.readValue(paymentResponse.getBody(), Map.class);
                Map<String, Object> responseJson = (Map<String, Object>) paymentJson.get("response");
                int amount = (Integer) responseJson.get("amount");  // 결제 금액

                // 결제 금액이 실제 결제 금액과 일치하는지 확인
                if (amount == paid_amount) {
                    System.out.println("결제 금액이 일치합니다.");

                    // 세션에서 사용자 ID를 가져와 확인
                    if (userId == null) {
                        response.put("success", false);
                        response.put("message", "세션에서 사용자 ID를 찾을 수 없습니다.");
                        System.out.println("세션에서 사용자 ID를 찾을 수 없습니다.");
                        return response;  // 사용자 ID 확인 실패 시 오류 응답 반환
                    }

                    // 현재 시간으로 예약 ID 생성
                    String currentTimestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
                    String reservationid = generateReservationId();  // 예약 ID 생성

                    // 티켓 정보를 설정하고 데이터베이스에 삽입
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
                    ticketsDto.setImpUid(imp_uid);
                    ticketsDto.setCouponid(couponId);
                    ticketsDto.setMembershipid(membershipId);
                    ticketsDto.setMethodcode("someMethodCode");
                    ticketsDto.setFinalpaymentamount(paid_amount);
                    ticketsDto.setDiscount(discount); // 할인금액

                    insertTicket(ticketsDto);
                    System.out.println("티켓 삽입 결과: 1");

                    // 각 좌석에 대한 상세 정보 설정 및 데이터베이스에 삽입
                    for (String seatId : seats) {
                        seatId = seatId.replace("[", "").replace("]", "").trim();  // 좌석 ID 문자열 정리
                        System.out.println("좌석 ID: " + seatId);

                        Map<String, Object> seatInfo = getSeatInfo(seatId);
                        if (seatInfo != null) {
                            TicketsDetailDTO ticketsDetailDto = new TicketsDetailDTO();
                            ticketsDetailDto.setReservationid(reservationid);
                            ticketsDetailDto.setMatchid(matchid);
                            ticketsDetailDto.setSeatid((String) seatInfo.get("seatid"));
                            ticketsDetailDto.setPrice((Integer) seatInfo.get("price"));
                            ticketsDetailDto.setTotalamount((Integer) seatInfo.get("price"));
                            ticketsDetailDto.setIscanceled(false);
                            ticketsDetailDto.setIsrefunded(false);

                            insertTicketDetail(ticketsDetailDto);
                            System.out.println("좌석 ID: " + seatId + " 삽입 완료");
                        } else {
                            System.out.println("좌석 정보를 찾을 수 없습니다. 좌석 ID: " + seatId);
                        }
                    }

                    // 쿠폰 사용 업데이트
                    if (couponId != null && !couponId.equals("0")) {
                        int updateResult = updateCouponUsage(couponId);
                        if (updateResult > 0) {
                            System.out.println("쿠폰 사용 업데이트 성공: " + couponId);
                        } else {
                            System.out.println("쿠폰 사용 업데이트 실패: " + couponId);
                        }
                    }

                    // 포인트 적립 처리
                    String pointcategoryid = "15";  // 포인트 카테고리 ID
                    double rate = getRateByCategoryId(pointcategoryid);  // 포인트 적립 비율
                    int pointsToAccumulate = (int) (paid_amount * rate);  // 적립할 포인트 수

                    PointHistoryDTO pointHistoryDto = new PointHistoryDTO();
                    pointHistoryDto.setUserid(userId);
                    pointHistoryDto.setPointcategoryid(pointcategoryid);
                    pointHistoryDto.setPointtype("적립");
                    pointHistoryDto.setPointsource("좌석예매 포인트 적립");
                    pointHistoryDto.setPointamount(pointsToAccumulate);
                    pointHistoryDto.setPointcreationdate(Timestamp.valueOf(currentTimestamp));
                    pointHistoryDto.setReservationid(reservationid);

                    insertPointHistory(pointHistoryDto);

                    // 세션에 추가 정보를 저장
                    session.setAttribute("serviceFee", requestParams.get("serviceFee"));
                    session.setAttribute("deliveryFee", requestParams.get("deliveryFee"));
                    session.setAttribute("couponName", requestParams.get("couponName"));
                    session.setAttribute("membershipName", requestParams.get("membershipName"));
                    session.setAttribute("totalDiscount", requestParams.get("totalDiscount"));
                    session.setAttribute("totalPaymentAmount", requestParams.get("totalPaymentAmount"));
                    session.setAttribute("collectionmethodcode", collectionmethodcode);

                    // 성공적인 응답과 예약 목록 페이지로 리다이렉트 URL 반환
                    response.put("success", true);
                    response.put("redirectUrl", "/tickets/reservationList?reservationid=" + reservationid);
                } else {
                    // 결제 금액이 일치하지 않는 경우 오류 응답 반환
                    response.put("success", false);
                    response.put("message", "결제 금액이 일치하지 않습니다.");
                    System.out.println("결제 금액이 일치하지 않습니다.");
                }
            } catch (Exception e) {
                // 결제 검증 중 오류 발생 시 오류 응답 반환
                response.put("success", false);
                response.put("message", "결제 검증 중 오류 발생.");
                e.printStackTrace();
            }
        } else {
            // 결제 정보를 가져오는 데 실패한 경우 오류 응답 반환
            response.put("success", false);
            response.put("message", "결제 정보를 가져오지 못했습니다.");
            System.out.println("결제 정보를 가져오지 못했습니다.");
        }

        return response;
    }


    /**
     * 결제 취소 메서드
     * @param reservationid 예약 ID
     * @param env Environment 객체
     * @return 취소 결과 맵
     */
    @Transactional
    public Map<String, Object> cancelPayment(String reservationid, Environment env) {
        Map<String, Object> response = new HashMap<>();

        try {
            String impUid = getImpUidByReservationId(reservationid);

            if (impUid == null || impUid.isEmpty()) {
                response.put("success", false);
                response.put("message", "결제 정보를 찾을 수 없습니다.");
                return response;
            }

            String token = getToken(env);
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
                cancelPointHistoryByReservationId(reservationid);
                cancelReservationAndUpdateCoupon(reservationid);

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
     * 예약 취소 및 쿠폰 사용 상태 업데이트
     * @param reservationid 예약 ID
     */
    @Transactional
    public void cancelReservationAndUpdateCoupon(String reservationid) {
        // 예약 상태 업데이트
        System.out.println("Cancelling reservation: " + reservationid);
        ticketsDao.updateReservationStatus(reservationid, "Cancelled");

        // 쿠폰 사용 상태를 'Not Used'로 업데이트
        TicketsDTO reservation = ticketsDao.getReservationById(reservationid);
        String couponId = reservation.getCouponid();
        if (couponId != null && !couponId.isEmpty()) {
            int result = ticketsDao.resetCouponUsage(couponId);
            System.out.println("Coupon usage update result (Not Used): " + result);
        }
    }
    
    /**
     * 예약 ID로 포인트 기록 취소
     * @param reservationid 예약 ID
     */
    public void cancelPointHistoryByReservationId(String reservationid) {
        // reservationid로 기존 포인트 적립 내역 가져오기
        PointHistoryDTO existingPointHistory = ticketsDao.getPointHistoryByReservationId(reservationid);

        if (existingPointHistory != null) {
            // 기존 포인트 적립 내역의 금액을 음수로 설정하고 결제 취소 내역 추가
            PointHistoryDTO cancelPointHistory = new PointHistoryDTO();
            cancelPointHistory.setUserid(existingPointHistory.getUserid());
            cancelPointHistory.setPointcategoryid(existingPointHistory.getPointcategoryid());
            cancelPointHistory.setPointtype("적립취소");
            cancelPointHistory.setReviewid(existingPointHistory.getReviewid());
            cancelPointHistory.setPointsource("결제취소");
            cancelPointHistory.setPointamount(-existingPointHistory.getPointamount());
            cancelPointHistory.setReservationid(reservationid);

            // 로깅 추가
            System.out.println("Cancel Point History: " + cancelPointHistory);

            // 적립 취소 기록 삽입
            ticketsDao.insertPointHistory(cancelPointHistory);
            System.out.println("Point history cancellation inserted successfully.");
        } else {
            System.out.println("No existing point history found for reservationid: " + reservationid);
        }
    }



    /**
     * 예약 목록 페이지로 이동
     * @param session 세션 객체
     * @return ModelAndView 객체
     */
    public ModelAndView getReservationListPage(HttpSession session) {
        // 세션에서 사용자 ID를 가져옴
        String userId = (String) session.getAttribute("userID");
        
        // 사용자 ID가 세션에 없으면 로그인 페이지로 리디렉션
        if (userId == null) {
            System.out.println("User ID not found in session.");
            return new ModelAndView("redirect:/login");
        }

        // 사용자 ID로 예약 목록을 조회
        System.out.println("Fetching reservations for userId: " + userId);
        List<Map<String, Object>> reservations = getReservationsByUserId(userId);

        // 예약 목록을 보여주기 위한 ModelAndView 객체 생성
        ModelAndView mav = new ModelAndView("tickets/reservationList");
        
        // 조회한 예약 목록을 모델에 추가
        mav.addObject("reservations", reservations);

        // 준비된 ModelAndView 객체 반환
        return mav;
    }


    /**
     * 예약 상세 정보 페이지로 이동
     * @param reservationid 예약 ID
     * @return ModelAndView 객체
     */
    public ModelAndView getReservationDetailPage(String reservationid, HttpSession session) {
        ModelAndView mav = new ModelAndView("tickets/reservationDetail");

        TicketsDTO reservation = getReservationById(reservationid);
        if (reservation == null) {
            mav.setViewName("errorPage");
            mav.addObject("message", "Reservation not found for ID: " + reservationid);
            return mav;
        }

        List<TicketsDetailDTO> details = getTicketDetailsByReservationId(reservationid);
        reservation.setDetails(details);

        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date reservationDate = null;
        try {
            reservationDate = formatter.parse(reservation.getReservationdate());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        mav.addObject("reservationDate", reservationDate);

        Calendar cal = Calendar.getInstance();
        cal.setTime(reservation.getMatchdate());
        cal.add(Calendar.DATE, -3);
        reservation.setCancelDeadline(cal.getTime());

        Map<String, Object> additionalInfo = ticketsDao.getAdditionalReservationInfo(reservationid);

        mav.addObject("totalPrice", additionalInfo.get("price"));  // price 필드를 totalPrice로 변경
        mav.addObject("deliveryFee", additionalInfo.get("shippingFee"));
        mav.addObject("couponName", additionalInfo.get("couponName"));
        mav.addObject("membershipName", additionalInfo.get("membershipName"));
        mav.addObject("totalDiscount", additionalInfo.get("totalDiscount"));
        mav.addObject("totalPaymentAmount", additionalInfo.get("totalPaymentAmount"));
        mav.addObject("reservation", reservation);

        return mav;
    }

    // 추가 정보 조회 메서드
    private Map<String, Object> getAdditionalReservationInfo(String reservationid) {
        return ticketsDao.getAdditionalReservationInfo(reservationid);
    }



    public ResponseEntity<byte[]> generateQRCode(String reservationid) {
        try {
            // 예약 ID를 기반으로 예약 정보를 조회
            TicketsDTO reservation = getReservationById(reservationid);
            if (reservation == null) {
                // 예약 정보를 찾을 수 없는 경우 404 Not Found 반환
                return ResponseEntity.status(HttpStatus.NOT_FOUND).build();
            }

            // 예약 ID로 티켓 상세 정보를 조회
            List<TicketsDetailDTO> details = getTicketDetailsByReservationId(reservationid);

            // QR 코드에 포함할 데이터 준비
            Map<String, Object> qrData = new HashMap<>();
            qrData.put("reservationid", reservationid);
			/*
			 * qrData.put("matchid", reservation.getMatchid()); qrData.put("seats",
			 * details.stream().map(TicketsDetailDTO::getSeatid).toArray());
			 * qrData.put("username", reservation.getUserName()); qrData.put("matchdate",
			 * reservation.getMatchdate().getTime());
			 */

            // 데이터 객체를 JSON 문자열로 변환
            ObjectMapper objectMapper = new ObjectMapper();
            String qrText = objectMapper.writeValueAsString(qrData);

            // JSON 문자열을 QR 코드 이미지로 변환
            byte[] qrImage = QRCodeGenerator.generateQRCodeImage(qrText, 200, 200);

            // QR 코드 이미지를 PNG 형식으로 응답
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.IMAGE_PNG);
            return new ResponseEntity<>(qrImage, headers, HttpStatus.OK);
        } catch (Exception e) {
            // 예외 발생 시 500 Internal Server Error 반환
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).build();
        }
    }

    private String getToken(Environment env) {
        try {
            // RestTemplate을 사용하여 API 호출
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 환경 변수에서 API 키와 시크릿 가져오기
            String apiKey = env.getProperty("iamport.api_key");
            String apiSecret = env.getProperty("iamport.api_secret");

            // API 호출 요청 데이터 준비
            Map<String, String> request = new HashMap<>();
            request.put("imp_key", apiKey);
            request.put("imp_secret", apiSecret);

            // 요청 데이터를 JSON 문자열로 변환
            String jsonRequest = new ObjectMapper().writeValueAsString(request);
            HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

            // API 호출
            ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                // 응답에서 액세스 토큰 추출
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
     * 모바일 티켓 정보를 가져오는 메서드
     * @param reservationId 예약 ID
     * @return 예약 상세 정보를 포함한 ModelAndView 객체
     */
    public ModelAndView getMobileTicket(String reservationId) {
        TicketsDTO reservation = getReservationById(reservationId);
        if (reservation == null) {
            ModelAndView mav = new ModelAndView("errorPage");
            mav.addObject("message", "Reservation not found for ID: " + reservationId);
            return mav;
        }

        ModelAndView mav = new ModelAndView("tickets/mobileTicket");
        String matchDetail = reservation.getHometeam() + " vs " + reservation.getAwayteam();
        mav.addObject("reservation", reservation);
        mav.addObject("matchDetail", matchDetail);
        return mav;
    }

    public MatchesDTO getMatchById(String matchid) {
        // matchid를 기반으로 경기 정보를 조회
        return ticketsDao.getMatchById(matchid);
    }

    public List<Map<String, Object>> getSeatsByStadiumIdAndSection(String stadiumid, String section) {
        // 경기장 ID와 섹션을 기반으로 좌석 정보 조회
        return ticketsDao.getSeatsByStadiumIdAndSection(stadiumid, section);
    }

    public Map<String, Object> getUserInfo(String userID) {
        // 사용자 ID를 기반으로 사용자 정보 조회
        return ticketsDao.getUserInfo(userID);
    }

    public List<CouponDTO> getCouponsByUserId(String userId) {
        // 사용자 ID를 기반으로 쿠폰 목록 조회
        return ticketsDao.getCouponsByUserId(userId);
    }

    public int getDiscountRateByCouponId(String couponId) {
        // 쿠폰 ID를 기반으로 할인율 조회
        return ticketsDao.getDiscountRateByCouponId(couponId);
    }

    public int updateCouponUsage(String couponId) {
        // 쿠폰 사용 상태 업데이트
        return ticketsDao.updateCouponUsage(couponId);
    }

    public void insertTicket(TicketsDTO ticket) {
        // 티켓 정보를 데이터베이스에 삽입
        ticketsDao.insertTicket(ticket);
    }

    public void insertTicketDetail(TicketsDetailDTO ticketsDetail) {
        // 티켓 상세 정보를 데이터베이스에 삽입
        ticketsDao.insertTicketDetail(ticketsDetail);
    }

    public int checkSeatId(String seatId) {
        // 좌석 ID가 유효한지 확인
        return ticketsDao.checkSeatId(seatId);
    }

    public String getMaxReservationId(String date) {
        // 날짜를 기준으로 최대 예약 ID 조회
        return ticketsDao.getMaxReservationId(date);
    }

    @Transactional
    public String generateNewReservationId(String date) {
        // 날짜를 기준으로 새로운 예약 ID 생성
        return ticketsDao.generateNewReservationId(date);
    }

    public Map<String, Object> getSeatInfoByJson(String seatId) {
        // JSON 형식의 좌석 ID를 기반으로 좌석 정보 조회
        return ticketsDao.getSeatInfoByJson(seatId);
    }

    public Map<String, Object> getSeatInfo(String seatId) {
        // 좌석 ID를 기반으로 좌석 정보 조회
        return ticketsDao.getSeatInfo(seatId);
    }

    public List<Map<String, Object>> getReservationsByUserId(String userId) {
        // 사용자 ID를 기반으로 예약 목록 조회
        return ticketsDao.getReservationsByUserId(userId);
    }

    public List<String> getReservedSeats(String matchid) {
        // 경기 ID를 기반으로 예약된 좌석 목록 조회
        return ticketsDao.getReservedSeats(matchid);
    }

    public TicketsDTO getReservationById(String reservationid) {
        // 예약 ID를 기반으로 예약 정보 조회
        return ticketsDao.getReservationById(reservationid);
    }

    public List<TicketsDetailDTO> getTicketDetailsByReservationId(String reservationid) {
        // 예약 ID를 기반으로 티켓 상세 정보 조회
        return ticketsDao.getTicketDetailsByReservationId(reservationid);
    }

    public List<Map<String, Object>> getMembershipsByUserId(String userId) {
        // 사용자 ID를 기반으로 회원 정보 조회
        return ticketsDao.getMembershipsByUserId(userId);
    }

    @Transactional
    public void updateReservationStatus(String reservationid, String status) {
        // 예약 ID와 상태를 기반으로 예약 상태 업데이트
        ticketsDao.updateReservationStatus(reservationid, status);
    }

    public String getImpUidByReservationId(String reservationid) {
        // 예약 ID를 기반으로 Imp UID 조회
        return ticketsDao.getImpUidByReservationId(reservationid);
    }

    public int resetCouponUsage(String couponId) {
        // 쿠폰 사용 이력을 초기화
        System.out.println("Service: Resetting coupon usage for couponId: " + couponId);
        return ticketsDao.resetCouponUsage(couponId);
    }

    public void insertPointHistory(PointHistoryDTO pointHistoryDTO) {
        // 포인트 이력 정보를 데이터베이스에 삽입
        ticketsDao.insertPointHistory(pointHistoryDTO);
    }

    public double getRateByCategoryId(String pointcategoryid) {
        // 포인트 카테고리 ID를 기반으로 비율 조회
        return ticketsDao.getRateByCategoryId(pointcategoryid);
    }

    public PointHistoryDTO getPointHistoryByReservationId(String reservationid) {
        // 예약 ID를 기반으로 포인트 이력 정보 조회
        return ticketsDao.getPointHistoryByReservationId(reservationid);
    }


    private String generateReservationId() {
        // 새로운 예약 ID를 생성
        String prefix = "reservation";
        String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String maxReservationId = getMaxReservationId(date);
        int nextSuffix = 1;
        if (maxReservationId != null) {
            nextSuffix = Integer.parseInt(maxReservationId.substring(maxReservationId.length() - 6)) + 1;
        }
        return String.format("%s%s%06d", prefix, date, nextSuffix);
    }

}
