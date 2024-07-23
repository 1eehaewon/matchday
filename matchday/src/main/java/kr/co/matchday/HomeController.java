package kr.co.matchday;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

import kr.co.matchday.instagram.InstagramDAO;
import kr.co.matchday.instagram.InstagramDTO;
import kr.co.matchday.matches.MatchesService;
import kr.co.matchday.matches.MatchesDTO;
import kr.co.matchday.video.VideoDAO;
import kr.co.matchday.video.VideoDTO;

@Controller
public class HomeController {

   public HomeController() {
      System.out.println("-----HomeController()객체 생성 됨");
   }//end
   
   @Autowired
   private InstagramDAO instagramDao;
   
   @Autowired
   private VideoDAO videoDao;
   
   @Autowired
   private MatchesService matchesService; // MatchesService 주입
   
   //matchday 프로젝트의 첫페이지 호출 명령어 등록
   //http://localhost:9095/home.do
   @RequestMapping("/home.do")
   public String home(Model model) {
       List<InstagramDTO> instagramList = instagramDao.list();
       model.addAttribute("instagramList", instagramList);    

       List<VideoDTO> videoList = videoDao.list();
       model.addAttribute("videoList", videoList);

       List<MatchesDTO> matchList = matchesService.getMatchesWithinFiveDays();
       model.addAttribute("matchList", matchList);

       // 데이터 로그 출력
       System.out.println("Instagram List: " + instagramList);
       System.out.println("Video List: " + videoList);
       System.out.println("Match List: " + matchList);
       
       return "index";
   }


}//class end
