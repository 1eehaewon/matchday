package kr.co.matchday.membershipticket;

import java.util.HashMap;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/membershipticket")
public class MembershipticketCont {

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
}
