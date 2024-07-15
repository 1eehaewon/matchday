package kr.co.matchday.membershipticket;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.springframework.http.HttpHeaders;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.MediaType;

@Controller
@RequestMapping("/membershipticket")
public class MembershipticketCont {

    private static final Logger logger = LoggerFactory.getLogger(MembershipticketCont.class);

    @Value("${iamport.api_key}")
    private String apiKey;

    @Value("${iamport.api_secret}")
    private String apiSecret;

    public MembershipticketCont() {
        System.out.println("------MembershipticketCont() 객체 생성됨");
    }

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
    public ModelAndView paymentSuccess(@RequestBody Map<String, Object> paymentData, HttpSession session) {
        String userId = (String) session.getAttribute("userID");
        logger.info("Session UserID: {}", userId);
        logger.info("Payment Data: {}", paymentData);

        if (userId == null || paymentData.get("membershipID") == null) {
            logger.error("Missing userID or membershipID");
            return new ModelAndView("error"); // error.jsp로 이동하도록 수정 필요
        }

        String membershipID = (String) paymentData.get("membershipID");
        String status = "completed";
        String purchaseDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String userMembershipId = UUID.randomUUID().toString(); // UUID 생성
        String impUid = (String) paymentData.get("imp_uid"); // imp_uid 추가

        System.out.println(impUid);

        membershipticketDao.insertUserMembership(userMembershipId, userId, membershipID, status, purchaseDate, impUid);

        // 결제 완료 후 memberships/list로 리디렉션 
        return new ModelAndView("redirect:/memberships/list");
    }

    @RequestMapping("/membershippaymentlist")
    public ModelAndView membershipPaymentList(HttpSession session) {
        String userId = (String) session.getAttribute("userID");
        ModelAndView mav = new ModelAndView();
        mav.setViewName("membershipticket/membershippaymentlist");

        if (userId != null) {
            List<Map<String, Object>> membershipDetails = membershipticketDao.getUserMembershipDetails(userId);
            mav.addObject("membershipDetails", membershipDetails);
        } else {
            mav.setViewName("redirect:/member/login"); // 로그인 페이지로 리디렉션
        }

        return mav;
    }

    @PostMapping("/refund")
    public ResponseEntity<String> refund(@RequestParam("userMembershipId") String userMembershipId, HttpSession session) {
        String userId = (String) session.getAttribute("userID");
        logger.info("Refund Request UserID: {}", userId);
        logger.info("User Membership ID: {}", userMembershipId);

        if (userId == null) {
            logger.error("User not logged in");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body("User not logged in");
        }

        Map<String, Object> membership = membershipticketDao.getUserMembershipById(userMembershipId);

        if (membership == null) {
            logger.error("Membership not found");
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Membership not found");
        }

        String impUid = (String) membership.get("imp_uid");

        if (impUid == null) {
            logger.error("Payment UID not found");
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body("Payment UID not found");
        }

        // Log the impUid before making the Iamport token request
        System.out.println("imp_uid before token request: " + impUid);

        // Iamport access token request
        RestTemplate restTemplate = new RestTemplate();
        String url = "https://api.iamport.kr/users/getToken";
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);

        Map<String, String> tokenRequest = new HashMap<>();
        tokenRequest.put("imp_key", apiKey); // Iamport API Key
        tokenRequest.put("imp_secret", apiSecret); // Iamport API Secret

        // Log the apiKey and apiSecret for debugging
        System.out.println("API Key: " + apiKey);
        System.out.println("API Secret: " + apiSecret);

        HttpEntity<Map<String, String>> tokenEntity = new HttpEntity<>(tokenRequest, headers);
        try {
            ResponseEntity<Map> tokenResponseEntity = restTemplate.postForEntity(url, tokenEntity, Map.class);
            Map<String, Object> tokenResponse = tokenResponseEntity.getBody();

            if (tokenResponse == null || !tokenResponse.containsKey("response") || tokenResponse.get("response") == null) {
                logger.error("Failed to obtain access token from Iamport");
                System.out.println("Token Response: " + tokenResponse); // Log the full response for debugging
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Failed to obtain access token");
            }

            String token = (String) ((Map<String, Object>) tokenResponse.get("response")).get("access_token");

            // Log the token
            System.out.println("Access Token: " + token);

            // Refund request
            url = "https://api.iamport.kr/payments/cancel";
            headers.setBearerAuth(token);

            Map<String, String> refundRequest = new HashMap<>();
            refundRequest.put("imp_uid", impUid);
            refundRequest.put("reason", "Membership refund request");

            HttpEntity<Map<String, String>> refundEntity = new HttpEntity<>(refundRequest, headers);
            ResponseEntity<Map> refundResponseEntity = restTemplate.postForEntity(url, refundEntity, Map.class);
            Map<String, Object> refundResponse = refundResponseEntity.getBody();

            // Log the impUid in the response handling
            System.out.println("imp_uid in refund response: " + impUid);

            if (refundResponse != null && Boolean.TRUE.equals(refundResponse.get("success"))) {
                membershipticketDao.updateUserMembershipStatus(userMembershipId, "환불완료");
                return ResponseEntity.ok("Refund successful");
            } else {
                logger.error("Refund failed: {}", refundResponse != null ? refundResponse.get("message") : "Unknown error");
                System.out.println("Refund Response: " + refundResponse); // Log the full response for debugging
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Refund failed: " + (refundResponse != null ? refundResponse.get("message") : "Unknown error"));
            }
        } catch (Exception e) {
            logger.error("Error during refund process", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("Error during refund process: " + e.getMessage());
        }
    }
}
