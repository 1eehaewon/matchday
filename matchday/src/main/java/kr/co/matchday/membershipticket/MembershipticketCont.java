package kr.co.matchday.membershipticket;

import java.text.SimpleDateFormat;
import java.util.Date;
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
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;

import org.springframework.http.HttpHeaders; // 수정됨
import org.springframework.http.HttpEntity; // 수정됨
import org.springframework.http.ResponseEntity;
import org.springframework.http.HttpStatus;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/membershipticket")
public class MembershipticketCont {

    private static final Logger logger = LoggerFactory.getLogger(MembershipticketCont.class);

    @Value("${iamport.api_key}")
    private String apiKey;

    @Value("${iamport.api_secret}")
    private String apiSecret;

    @Autowired
    private MembershipticketDAO membershipticketDao;

    @Autowired
    public MembershipticketCont(@Value("${iamport.api_key}") String apiKey,
                                @Value("${iamport.api_secret}") String apiSecret) {
        this.apiKey = apiKey;
        this.apiSecret = apiSecret;
    }

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

        if (userId == null || paymentData.get("membershipID") == null) {
            return new ModelAndView("error"); // error.jsp로 이동하도록 수정 필요
        }

        String membershipID = (String) paymentData.get("membershipID");
        String status = "completed";
        String purchaseDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());
        String userMembershipId = UUID.randomUUID().toString(); // UUID 생성
        String impUid = (String) paymentData.get("imp_uid"); // imp_uid 추가

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
    @ResponseBody
    public ResponseEntity<String> refund(@RequestParam("imp_uid") String impUid) {
        try {
            // 아임포트 토큰 발급
            RestTemplate restTemplate = new RestTemplate();
            String tokenUrl = "https://api.iamport.kr/users/getToken";

            HttpHeaders tokenHeaders = new HttpHeaders(); // 수정됨
            tokenHeaders.setContentType(org.springframework.http.MediaType.APPLICATION_JSON); // 수정됨
            Map<String, String> tokenRequest = new HashMap<>();
            tokenRequest.put("imp_key", apiKey);
            tokenRequest.put("imp_secret", apiSecret);
            
            HttpEntity<Map<String, String>> tokenEntity = new HttpEntity<>(tokenRequest, tokenHeaders); // 수정됨
            Map<String, Object> tokenResponse = restTemplate.postForObject(tokenUrl, tokenEntity, Map.class); // 수정됨
            
            if (tokenResponse == null || tokenResponse.get("response") == null) {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("토큰 발급 실패");
            }

            String accessToken = (String) ((Map<String, Object>) tokenResponse.get("response")).get("access_token");

            // 결제 취소 요청
            String cancelUrl = "https://api.iamport.kr/payments/cancel";
            Map<String, String> cancelRequest = new HashMap<>();
            cancelRequest.put("imp_uid", impUid);

            HttpHeaders headers = new HttpHeaders();
            headers.set("Authorization", "Bearer " + accessToken); // 수정됨
            HttpEntity<Map<String, String>> entity = new HttpEntity<>(cancelRequest, headers);

            ResponseEntity<Map> cancelResponse = restTemplate.postForEntity(cancelUrl, entity, Map.class);

            if (cancelResponse.getStatusCode() == HttpStatus.OK) {
                // 결제 취소 성공 시 DB 상태 업데이트
                membershipticketDao.updateUserMembershipStatus(impUid, "refunded");
                return ResponseEntity.ok("환불 완료");
            } else {
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("환불 실패");
            }
        } catch (Exception e) {
            logger.error("Refund failed", e);
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("환불 실패");
        }
    }
}
