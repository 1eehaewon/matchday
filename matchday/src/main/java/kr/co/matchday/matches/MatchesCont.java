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
    private MatchesDAO matchesDao;

    @Autowired
    private MatchesService matchesService;

    public MatchesCont() {
        System.out.println("-----MatchesCont() 객체 생성됨");
    }

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

    @GetMapping("/write")
    public ModelAndView write() {
        List<String> teams = matchesService.getAllTeams();
        List<String> stadiums = matchesService.getAllStadiums();
        ModelAndView mav = new ModelAndView("matches/write");
        mav.addObject("teams", teams);
        mav.addObject("stadiums", stadiums);
        return mav;
    }

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
            String matchDateTime = matchdate + " " + matchtime;
            SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd HH:mm");
            Date parsedMatchDate = dateFormat.parse(matchDateTime);
            matchesDTO.setMatchdate(parsedMatchDate);

            SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
            Date parsedBookingStartDate = dateTimeFormat.parse(bookingstartdate);
            Date parsedBookingEndDate = dateTimeFormat.parse(bookingenddate);
            matchesDTO.setBookingstartdate(parsedBookingStartDate);
            matchesDTO.setBookingenddate(parsedBookingEndDate);

            matchesDTO.setHometeamid(hometeamid);
            matchesDTO.setAwayteamid(awayteamid);
            matchesDTO.setStadiumid(stadiumid);
            matchesDTO.setReferee(referee);

        } catch (ParseException e) {
            e.printStackTrace();
        }
        matchesService.insertMatch(matchesDTO);
        return "redirect:/matches/list";
    }

    @GetMapping("/list")
    public ModelAndView list() {
        System.out.println("-----list() 메서드 호출됨-----");
        List<MatchesDTO> matchList = matchesService.list();
        ModelAndView mav = new ModelAndView("matches/list");
        mav.addObject("matchList", matchList);
        return mav;
    }

    @GetMapping("/test")
    public String test() {
        System.out.println("-----test() 메서드 호출됨-----");
        return "matches/test";
    }
}
