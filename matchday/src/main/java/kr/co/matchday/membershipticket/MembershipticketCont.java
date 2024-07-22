package kr.co.matchday.membershipticket;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders; 
import org.springframework.http.HttpEntity; 
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.json.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/membershipticket")
public class MembershipticketCont {

    private static final Logger logger = LoggerFactory.getLogger(MembershipticketCont.class);

    @Autowired
    private Environment env;

    @Autowired
    private MembershipticketDAO membershipticketDao;

    @RequestMapping("/payment")
    public ModelAndView payment(HttpSession session, @RequestParam(value = "membershipID", required = false) String membershipID) {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("membershipticket/payment");

        String userId = (String) session.getAttribute("userID");
        Map<String, Object> userInfo = userId != null ? membershipticketDao.getUserInfo(userId) : new HashMap<>();

        if (membershipID == null) {
            membershipID = "defaultMembershipID"; // 기본 멤버쉽 ID 설정
        }
        Map<String, Object> membershipInfo = membershipticketDao.getMembershipInfo(membershipID);

        mav.addObject("userInfo", userInfo);
        mav.addObject("membershipInfo", membershipInfo);

        return mav;
    }

    @PostMapping("/paymentSuccess")
    @ResponseBody
    public ResponseEntity<Map<String, String>> paymentSuccess(@RequestBody Map<String, Object> paymentData, HttpSession session) {
        String userId = (String) session.getAttribute("userID");

        if (userId == null || paymentData.get("membershipID") == null) {
            Map<String, String> response = new HashMap<>();
            response.put("message", "error");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(response);
        }

        String membershipID = (String) paymentData.get("membershipID");
        String status = "completed";
        String purchaseDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String userMembershipId = UUID.randomUUID().toString();
        String impUid = (String) paymentData.get("imp_uid");
        String expirationStatus = "활성화";

        membershipticketDao.insertUserMembership(userMembershipId, userId, membershipID, status, purchaseDate, impUid, expirationStatus);

        Map<String, String> response = new HashMap<>();
        response.put("message", "success");

        // 결제 완료 후 memberships/list로 리디렉션을 클라이언트 측에서 수행할 수 있도록 수정
        return ResponseEntity.ok(response);
    }

    @RequestMapping("/membershippaymentlist")
    public ModelAndView membershipPaymentList(HttpSession session) {
        String userId = (String) session.getAttribute("userID");
        ModelAndView mav = new ModelAndView();
        mav.setViewName("membershipticket/membershippaymentlist");

        if (userId != null) {
            membershipticketDao.updateExpirationStatus(); // 상태 업데이트 호출
            List<Map<String, Object>> membershipDetails = membershipticketDao.getUserMembershipDetails(userId);
            mav.addObject("membershipDetails", membershipDetails);
        } else {
            mav.setViewName("redirect:/member/login"); // 로그인 페이지로 리디렉션
        }

        return mav;
    }

    @PostMapping("/refund")
    @ResponseBody
    public ResponseEntity<String> refund(@RequestParam("usermembershipid") String userMembershipId) {
        try {
            logger.info("Refund requested for usermembershipid: {}", userMembershipId);
            
            // 데이터베이스에서 imp_uid와 결제 시간을 조회
            Map<String, Object> userMembership = membershipticketDao.getUserMembershipById(userMembershipId);
            if (userMembership == null) {
                logger.error("User membership not found for id: {}", userMembershipId);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("해당 usermembershipid를 찾을 수 없습니다.");
            }

            String impUid = (String) userMembership.get("imp_uid");
            java.sql.Timestamp purchaseTimestamp = (java.sql.Timestamp) userMembership.get("purchasedate");

            if (impUid == null || impUid.isEmpty()) {
                logger.error("imp_uid not found for usermembershipid: {}", userMembershipId);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("해당 usermembershipid에 대한 imp_uid를 찾을 수 없습니다.");
            }

            // 현재 시간과 결제 시간을 비교
            Date purchaseDate = new Date(purchaseTimestamp.getTime());
            Date currentTime = new Date();

            logger.info("Current time: {}, Purchase time: {}", currentTime, purchaseDate);

            long diffInMillies = currentTime.getTime() - purchaseDate.getTime();
            long diffInMinutes = (diffInMillies / 1000) / 60;

            logger.info("Time difference in minutes: {}", diffInMinutes);

            if (diffInMinutes >= 1440) { // 24시간 = 1440분
                logger.warn("Refund request time exceeded for usermembershipid: {}", userMembershipId);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("환불 요청 시간이 초과되었습니다.");
            }

            String token = getToken();
            if (token == null) {
                logger.error("Failed to obtain token for iamport");
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("아임포트 토큰 발급 실패");
            }

            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            headers.setBearerAuth(token);

            Map<String, String> request = new HashMap<>();
            request.put("imp_uid", impUid);

            String jsonRequest = new ObjectMapper().writeValueAsString(request);
            HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

            ResponseEntity<String> paymentResponse = restTemplate.postForEntity(
                    "https://api.iamport.kr/payments/cancel", entity, String.class);

            if (paymentResponse.getStatusCode() == HttpStatus.OK) {
                JSONObject json = new JSONObject(paymentResponse.getBody());
                if (!json.isNull("response")) {
                    logger.info("Payment cancellation successful for imp_uid: {}", impUid);
                    membershipticketDao.updateUserMembershipStatus(impUid, "환불완료");
                    return ResponseEntity.ok("환불 완료");
                } else {
                    logger.error("Payment cancellation failed: {}", json.getString("message"));
                    return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                            .body("결제 취소 실패: " + json.getString("message"));
                }
            } else {
                logger.error("Payment cancellation failed: {}", paymentResponse.getBody());
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                        .body("결제 취소 실패: " + paymentResponse.getBody());
            }
        } catch (Exception e) {
            logger.error("Refund failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("환불 실패");
        }
    }


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

            ResponseEntity<String> response = restTemplate.postForEntity(
                    "https://api.iamport.kr/users/getToken", entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                JSONObject json = new JSONObject(response.getBody());
                if (!json.isNull("response")) {
                    return json.getJSONObject("response").getString("access_token");
                } else {
                    logger.error("Failed to get token, response is null: {}", json.getString("message"));
                }
            } else {
                logger.error("Failed to get token, response: {}", response.getBody());
            }
        } catch (Exception e) {
            logger.error("Failed to get token", e);
        }
        return null;
    }
}
