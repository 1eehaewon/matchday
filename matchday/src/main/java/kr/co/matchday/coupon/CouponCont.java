package kr.co.matchday.coupon;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpSession;
import kr.co.matchday.mypage.MypageDAO;
import kr.co.matchday.mypage.MypageDTO;

@Controller
@RequestMapping("/member/mypage")
public class CouponCont extends HttpServlet {
	public CouponCont() {
		System.out.println("CouponCont() 객체 생성됨");
	}//end
	
	@Autowired
	MypageDAO mypageDao;
	
	@Autowired
	CouponDAO couponDao;
	
	@GetMapping("/coupon")
	public String point(HttpSession session, Model model) {
		String userID = (String) session.getAttribute("userID");
		if (userID == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "/member/login"; // 경고 메시지와 함께 로그인페이지로 이동
		}
		MypageDTO user = mypageDao.getUserById(userID);
		model.addAttribute("user", user);

		// 쿠폰목록 조회 couponList : coupon.jsp의 items명
		List<CouponDTO> couponList = couponDao.selectCouponList(userID);
		model.addAttribute("couponList", couponList);
		return "/member/coupon"; // 마이페이지의 쿠폰으로 이동
	}
	
	
}//class end
