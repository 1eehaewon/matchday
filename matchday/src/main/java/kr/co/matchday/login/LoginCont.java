package kr.co.matchday.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/member")
public class LoginCont {

	@Autowired
	private LoginDAO loginDao;

	@GetMapping("/login")
	public String login() {
		return "/member/login"; // login.jsp 반환
	}

	@PostMapping("/login.do")
	public ModelAndView login(@RequestParam("userID") String userID, @RequestParam("password") String password,
			HttpSession session) {
		boolean isValidUser = loginDao.validateUser(userID, password);

		ModelAndView modelAndView = new ModelAndView();

		// 회원 등급 확인
		String grade = loginDao.getUserGrade(userID);
		if ("F".equals(grade)) {
			modelAndView.setViewName("/member/login"); // 로그인 페이지로 리다이렉트
			modelAndView.addObject("errorMessage", "이미 탈퇴한 회원입니다.");
			modelAndView.addObject("alert", true); // alert 창을 띄우기 위한 플래그
			return modelAndView;
		}

		if (isValidUser) {
			session.setAttribute("userID", userID); // 로그인 성공 시 세션에 사용자 정보 저장
			modelAndView.setViewName("redirect:/home.do"); // 메인 페이지로 리다이렉트
		} else {
			modelAndView.setViewName("/member/login"); // /WEB-INF/views/member/login.jsp
			modelAndView.addObject("errorMessage", "아이디 또는 비밀번호가 잘못되었습니다.");
			modelAndView.addObject("alert", true); // alert 창을 띄우기 위한 플래그
		}
		return modelAndView;
	}

	@GetMapping("/logout")
	public String logout(HttpSession session) {
		session.invalidate(); // 세션 무효화하여 로그아웃
		return "redirect:/home.do"; // 메인 페이지로 리다이렉트
	}
}// class end
