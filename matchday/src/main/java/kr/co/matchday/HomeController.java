package kr.co.matchday;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import kr.co.matchday.instagram.InstagramDAO;
import kr.co.matchday.instagram.InstagramDTO;
import kr.co.matchday.matches.MatchesDTO;
import kr.co.matchday.matches.MatchesService;
import kr.co.matchday.video.VideoDAO;
import kr.co.matchday.video.VideoDTO;
import kr.co.matchday.visit.VisitDAO;

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
   
   @Autowired
   VisitDAO visitDao;
   
   //matchday 프로젝트의 첫페이지 호출 명령어 등록
   //http://localhost:9095/home.do
   @GetMapping("/")
   public String redirectToHome() {
       return "redirect:/home.do";
   }
   
   @GetMapping("/home.do")
   public String home(HttpServletRequest request, Model model) {
       // 방문 기록을 삽입합니다.
       HttpSession session = request.getSession();
       String sessionId = session.getId();
       visitDao.recordVisit(sessionId);

       // 오늘 방문자 수와 전체 방문자 수를 조회합니다.
       int todayVisitors = visitDao.getTodayVisitors();
       int totalVisitors = visitDao.getTotalVisitors();

       // 조회한 데이터를 JSP에 전달합니다.
       model.addAttribute("todayVisitors", todayVisitors);
       model.addAttribute("totalVisitors", totalVisitors);

       // Instagram, Video, Matches 데이터를 조회하여 모델에 추가합니다.
       List<InstagramDTO> instagramList = instagramDao.list();
       model.addAttribute("instagramList", instagramList);
       
       List<VideoDTO> videoList = videoDao.list();
       model.addAttribute("videoList", videoList);
       
       List<MatchesDTO> matchList = matchesService.getMatchesWithinFiveDays(); // 경기 일정 가져오기
       model.addAttribute("matchList", matchList); // 모델에 추가
       
       return "index"; // JSP 파일 이름 (index.jsp)
   }

}//class end
