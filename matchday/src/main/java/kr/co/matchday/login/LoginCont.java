package kr.co.matchday.login;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
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
			session.setAttribute("grade", grade); // 세션에 사용자 등급 저장(M,A,F)
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
	}//logout() end
	
	/**
     * 아이디 찾기 폼을 보여주는 메서드
     *
     * @return 아이디 찾기 페이지
     */
    @GetMapping("/findID")
    public String findIDForm() {
        return "/member/findID";
    }

    /**
     * 아이디 찾기 요청을 처리하는 메서드
     *
     * @param email 사용자 이메일
     * @param model 뷰에 데이터를 전달하기 위한 모델 객체
     * @return 아이디 찾기 결과 페이지
     */
    @PostMapping("/findID")
    public String findID(@RequestParam("email") String email, Model model) {
        String userID = loginDao.findIDByEmail(email);
        if (userID != null) {
            model.addAttribute("userID", userID);
        } else {
            model.addAttribute("alert", true);
            model.addAttribute("errorMessage", "Email not found");
        }
        return "findIDResult";
    }

    /**
     * 비밀번호 찾기 폼을 보여주는 메서드
     *
     * @return 비밀번호 찾기 페이지
     */
    @GetMapping("/findPassword")
    public String findPasswordForm() {
        return "findPassword";
    }

    /**
     * 비밀번호 찾기 요청을 처리하는 메서드
     *
     * @param userID 사용자 ID
     * @param email 사용자 이메일
     * @param model 뷰에 데이터를 전달하기 위한 모델 객체
     * @return 비밀번호 찾기 결과 페이지
     */
    @PostMapping("/findPassword")
    public String findPassword(@RequestParam("userID") String userID, @RequestParam("email") String email, Model model) {
        String password = loginDao.findPasswordByIDAndEmail(userID, email);
        if (password != null) {
            model.addAttribute("password", password);
        } else {
            model.addAttribute("alert", true);
            model.addAttribute("errorMessage", "UserID or Email not found");
        }
        return "findPasswordResult";
    }
}// class end
