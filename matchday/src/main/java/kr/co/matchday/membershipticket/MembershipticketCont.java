package kr.co.matchday.membershipticket;

import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

@Controller
@RequestMapping("/membershipticket")
public class MembershipticketCont {

    private static final Logger logger = LoggerFactory.getLogger(MembershipticketCont.class);

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

        membershipticketDao.insertUserMembership(userMembershipId, userId, membershipID, status, purchaseDate);

        ModelAndView mav = new ModelAndView();
        mav.setViewName("membershipticket/success"); // 경로 확인
        return mav;
    }

   
    
    
    
    
    
}
