package kr.co.matchday.matches;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/matches")
public class MatchesCont {

    @Autowired
    private MatchesDAO matchesDao; // MatchesDAO 주입

    @Autowired
    private MatchesService matchesService; // MatchesService 주입

    // 컨트롤러 객체 생성 시 출력되는 메시지
    public MatchesCont() {
        System.out.println("-----MatchesCont() 객체 생성됨");
    }

    // 날짜 형식 변환을 위한 바인더 설정
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));

        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        dateTimeFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, "bookingstartdate", new CustomDateEditor(dateTimeFormat, true));
        binder.registerCustomEditor(Date.class, "bookingenddate", new CustomDateEditor(dateTimeFormat, true));
    }

    // 경기 등록 페이지로 이동하는 메서드
    @GetMapping("/write")
    public ModelAndView write() {
        List<String> teams = matchesService.getAllTeams(); // 모든 팀 가져오기
        List<String> stadiums = matchesService.getAllStadiums(); // 모든 경기장 가져오기
        ModelAndView mav = new ModelAndView("matches/write");
        mav.addObject("teams", teams); // 팀 목록을 모델에 추가
        mav.addObject("stadiums", stadiums); // 경기장 목록을 모델에 추가
        return mav; // write.jsp 페이지로 이동
    }

    // 경기 정보를 저장하는 메서드
    @PostMapping("/saveMatch")
    public String saveMatch(@RequestParam("matchdate") String matchdate, 
                            @RequestParam("matchtime") String matchtime, 
                            @RequestParam("bookingstartdate") String bookingstartdate, 
                            @RequestParam("bookingenddate") String bookingenddate, 
                            @RequestParam("hometeamid") String hometeamid, 
                            @RequestParam("awayteamid") String awayteamid, 
                            @RequestParam("stadiumid") String stadiumid, 
                            @RequestParam("referee") String referee) {
        MatchesDTO matchesDTO = new MatchesDTO();
        try {
            // matchdate와 matchtime을 결합하여 Date 객체로 변환
            String matchDateTime = matchdate + " " + matchtime;
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date parsedMatchDate = dateFormat.parse(matchDateTime);
            matchesDTO.setMatchdate(parsedMatchDate);

            // bookingstartdate와 bookingenddate를 Date 객체로 변환
            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date parsedBookingStartDate = dateTimeFormat.parse(bookingstartdate);
            Date parsedBookingEndDate = dateTimeFormat.parse(bookingenddate);
            matchesDTO.setBookingstartdate(parsedBookingStartDate);
            matchesDTO.setBookingenddate(parsedBookingEndDate);

            // 나머지 필드 설정
            matchesDTO.setHometeamid(hometeamid);
            matchesDTO.setAwayteamid(awayteamid);
            matchesDTO.setStadiumid(stadiumid);
            matchesDTO.setReferee(referee);

        } catch (ParseException e) {
            e.printStackTrace();
        }
        matchesService.insertMatch(matchesDTO); // 경기 정보 삽입
        return "redirect:/matches/list"; // 경기 목록 페이지로 리다이렉트
    }

    // 경기 목록 페이지로 이동하는 메서드
    @GetMapping("/list")
    public ModelAndView list() {
        System.out.println("-----list() 메서드 호출됨-----");
        List<MatchesDTO> matchList = matchesService.list(); // 모든 경기 정보 가져오기
        ModelAndView mav = new ModelAndView("matches/list");
        mav.addObject("matchList", matchList); // 경기 목록을 모델에 추가
        return mav; // list.jsp 페이지로 이동
    }

    // 테스트 메서드
    @GetMapping("/test")
    public String test() {
        System.out.println("-----test() 메서드 호출됨-----");
        return "matches/test";
    }
}
