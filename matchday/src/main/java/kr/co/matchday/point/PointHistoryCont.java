package kr.co.matchday.point;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.mypage.MypageDAO;
import kr.co.matchday.mypage.MypageDTO;

@Controller
@RequestMapping("/member/mypage")
public class PointHistoryCont {
public PointHistoryCont() {
		System.out.println("PointCont() 객체 생성됨");
	}//end

@Autowired
MypageDAO mypageDao;

@Autowired
PointHistoryDAO pointHistoryDao;

@GetMapping("/point")
public String point(HttpSession session, Model model) {
	String userID = (String) session.getAttribute("userID");
	if (userID == null) {
		model.addAttribute("message", "로그인이 필요합니다.");
		return "/member/login"; // 경고 메시지와 함께 로그인페이지로 이동
	}
	MypageDTO user = mypageDao.getUserById(userID);
	model.addAttribute("user", user);
	
	// 포인트 적립 내역 조회
    List<PointHistoryDTO> pointHistoryList = pointHistoryDao.getPointHistoryList(userID);
    model.addAttribute("pointHistoryList", pointHistoryList);
	return "/member/point"; // 마이페이지의 포인트로 이동
}
}//class end
