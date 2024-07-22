package kr.co.matchday.visit;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
public class VisitCont {

	@Autowired
	VisitDAO visitDao;
	
	@GetMapping("/home.do")
	public String homePage(HttpServletRequest request) {
        HttpSession session = request.getSession();
        String sessionId = session.getId();

        // 방문 기록을 삽입합니다.
        visitDao.recordVisit(sessionId);

        // 오늘 방문자 수와 전체 방문자 수를 조회합니다.
        int todayVisitors = visitDao.getTodayVisitors();
        int totalVisitors = visitDao.getTotalVisitors();

        // 조회한 데이터를 JSP에 전달합니다.
        request.setAttribute("todayVisitors", todayVisitors);
        request.setAttribute("totalVisitors", totalVisitors);

        return "index"; // JSP 파일 이름 (index.jsp)
    }

	
}//class end
