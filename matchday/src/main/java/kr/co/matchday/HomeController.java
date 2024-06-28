package kr.co.matchday;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
public class HomeController {

	public HomeController() {
		System.out.println("-----HomeController()객체 생성 됨");
	}//end
	
	
	//matchday 프로젝트의 첫페이지 호출 명령어 등록
	//http://localhost:9095/home.do
	
	@RequestMapping("/home.do")
	public ModelAndView home() {
		ModelAndView mav = new ModelAndView();
		mav.setViewName("index");
		return mav;
	}//home() end
	
	
	
	
}//class end
