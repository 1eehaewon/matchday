package kr.co.matchday.mypage;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class MypageCont {

	public MypageCont() {
		System.out.println("MypageCont() 객체 생성됨");
	}

	@Autowired
	MypageDAO mypageDao;

	// 로그인 후 마이페이지 이동
	@GetMapping("/mypage")
	public String mypage(HttpSession session, Model model) {
		String userID = (String) session.getAttribute("userID");
		if (userID == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "/member/login"; // 경고 메시지와 함께 로그인페이지로 이동
		}
		MypageDTO user = mypageDao.getUserById(userID);
		model.addAttribute("user", user);
		return "member/mypage"; // 마이페이지로 이동
	}
	/*
	 * public String mypage() { return "mypage"; }
	 */

	// 수정 페이지로 이동
	@PostMapping("/mypage/edit")
	public String editPage(@RequestParam("userID") String userID, Model model, HttpSession session) {
		if (session.getAttribute("userID") == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "member/login"; // 경고 메시지와 함께 로그인페이지로 이동
		}
		MypageDTO user = mypageDao.getUserById(userID);
		model.addAttribute("user", user);
		return "member/edit"; // 수정 페이지로 이동
	}

	// 마이페이지 수정 후 이동
	@PostMapping("/mypage")
	public String updateMyPage(MypageDTO mypageDto, HttpSession session, Model model) {
		String userID = (String) session.getAttribute("userID");
		if (userID == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "member/login"; // 경고 메시지와 함께 로그인페이지로 이동
		}
		mypageDto.setUserID(userID);
		mypageDao.updateUser(mypageDto);
		return "redirect:/member/mypage";
	}

	// 회원 탈퇴
	@PostMapping("/mypage/delete")
	public String deleteAccount(HttpSession session, Model model, RedirectAttributes redirectAttributes) {
		String userID = (String) session.getAttribute("userID");
		if (userID == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "member/login"; // 경고 메시지와 함께 로그인 페이지로 이동
		}

		try {
			mypageDao.updateUserGradeToF(userID);
			session.invalidate(); // 세션 무효화
			redirectAttributes.addFlashAttribute("message", "회원탈퇴가 완료되었습니다."); // 성공 메시지 추가
			return "redirect:/member/login"; // 로그인 페이지로 리다이렉트
		} catch (Exception e) {
			System.out.println("탈퇴 실패 : " + e);
			return "/member/mypage"; // 실패 시 마이페이지 유지
		}
	}//deleteAccount() end
}// class end
