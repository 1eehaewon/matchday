package kr.co.matchday.admin;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/admin")
public class AdminCont {
	public AdminCont() {
		System.out.println("AdminCont() 객체 생성됨");
	}//end
	
	
	//관리자모드메인페이지
	@GetMapping("/dashboard")
	public String dashboard() {
		return "/admin/dashboard";
	}
	
	//관리자모드회원관리페이지
	@GetMapping("/member")
	public String member() {
		return "/admin/member";
	}
	
	
}//class end
