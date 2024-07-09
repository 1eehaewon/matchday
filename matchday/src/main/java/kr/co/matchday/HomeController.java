package kr.co.matchday;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import kr.co.matchday.instagram.InstagramDAO;
import kr.co.matchday.instagram.InstagramDTO;

@Controller
public class HomeController {

   public HomeController() {
      System.out.println("-----HomeController()객체 생성 됨");
   }//end
   
   @Autowired
   private InstagramDAO instagramDao;
   
   //matchday 프로젝트의 첫페이지 호출 명령어 등록
   //http://localhost:9095/home.do
    @RequestMapping("/home.do")
       public String home(Model model) {
           List<InstagramDTO> instagramList = instagramDao.list();
           model.addAttribute("instagramList", instagramList);
           return "index";
       }//home() end
   
   
   
   
}//class end
