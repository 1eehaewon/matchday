package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import jakarta.servlet.http.HttpSession;

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
    public String saveMatch(@RequestParam(value = "matchid", required = false) String matchid,
                            @RequestParam("matchdate") String matchdate, 
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

            if (matchid == null || matchid.isEmpty()) {
                // matchid가 없는 경우 새로 생성
                matchesService.insertMatch(matchesDTO);
            } else {
                // matchid가 있는 경우 업데이트
                matchesDTO.setMatchid(matchid);
                matchesService.updateMatch(matchesDTO);
            }

        } catch (ParseException e) {
            e.printStackTrace();
        }
        return "redirect:/matches/list"; // 경기 목록 페이지로 리다이렉트
    }

    // 경기 목록 페이지로 이동하는 메서드
    @GetMapping("/list")
    public ModelAndView list(HttpSession session) {
        System.out.println("-----list() 메서드 호출됨-----");
        List<MatchesDTO> matchList = matchesService.listActiveMatches();
        List<String> teams = matchesService.getAllTeams(); // 팀 목록 가져오기

        ModelAndView mav = new ModelAndView("matches/list");
        mav.addObject("matchList", matchList);
        mav.addObject("teams", teams); // 팀 목록을 모델에 추가

        String userGrade = (String) session.getAttribute("grade");
        System.out.println("회원 등급: " + userGrade); // 디버깅 로그
        mav.addObject("userGrade", userGrade);

        return mav;
    }



    // 경기 상세 정보 페이지로 이동하는 메서드
    @GetMapping("/detail/{matchid}")
    public ModelAndView detail(@PathVariable("matchid") String matchid) {
        MatchesDTO matchDetail = matchesService.getMatchDetail(matchid);
        
        // matchdate에서 날짜와 시간 분리
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");

        String matchdate = dateFormat.format(matchDetail.getMatchdate());
        String matchtime = timeFormat.format(matchDetail.getMatchdate());
        String bookingstartdate = dateTimeFormat.format(matchDetail.getBookingstartdate());
        String bookingenddate = dateTimeFormat.format(matchDetail.getBookingenddate());

        ModelAndView mav = new ModelAndView("matches/listDetail");
        mav.addObject("match", matchDetail);
        mav.addObject("matchdate", matchdate);
        mav.addObject("matchtime", matchtime);
        mav.addObject("bookingstartdate", bookingstartdate);
        mav.addObject("bookingenddate", bookingenddate);
        mav.addObject("teams", matchesService.getAllTeams());
        mav.addObject("stadiums", matchesService.getAllStadiums());
        return mav;
    }

    // 경기 정보를 삭제하는 메서드
    @PostMapping("/delete/{matchid}")
    public String deleteMatch(@PathVariable("matchid") String matchid, RedirectAttributes redirectAttributes) {
        matchesService.deleteMatch(matchid);
        redirectAttributes.addFlashAttribute("message", "경기가 삭제되었습니다.");
        return "redirect:/matches/list";
    }

    // 테스트 메서드
    @GetMapping("/test")
    public String test() {
        System.out.println("-----test() 메서드 호출됨-----");
        return "matches/test";
    }
    
    // 특정 경기의 판매 종료일을 조회하는 메서드
    @GetMapping("/getBookingEndDate")
    @ResponseBody
    public Date getBookingEndDate(@RequestParam("matchid") String matchid) {
        return matchesService.getBookingEndDate(matchid);
    }
    
    @GetMapping("/search")
    public ModelAndView search(@RequestParam(value = "teamname", required = false) String teamname, HttpSession session) {
        System.out.println("-----search() 메서드 호출됨-----");
        List<MatchesDTO> matchList;

        if (teamname == null || teamname.isEmpty()) {
            matchList = matchesService.listActiveMatches();
        } else {
            matchList = matchesService.searchMatchesByTeamName(teamname);
        }

        List<String> teams = matchesService.getAllTeams(); // 팀 목록 가져오기

        ModelAndView mav = new ModelAndView("matches/list");
        mav.addObject("matchList", matchList);
        mav.addObject("teams", teams); // 팀 목록을 모델에 추가

        String userGrade = (String) session.getAttribute("grade");
        System.out.println("회원 등급: " + userGrade); // 디버깅 로그
        mav.addObject("userGrade", userGrade);

        return mav;
    }
}
