package kr.co.matchday.matches;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomDateEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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

    @GetMapping("/list")
    public String list() {
        return "matches/list";
    }

    @GetMapping("/write")
    public String write(Model model) {
        List<String> teams = matchesService.getAllTeams();
        List<String> stadiums = matchesService.getAllStadiums();
        model.addAttribute("teams", teams);
        model.addAttribute("stadiums", stadiums);
        return "matches/write"; // views/matches/write.jsp로 매핑
    }

    @InitBinder
    public void initBinder(WebDataBinder binder) {
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        dateFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, new CustomDateEditor(dateFormat, true));
        
        SimpleDateFormat dateTimeFormat = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm");
        dateTimeFormat.setLenient(false);
        binder.registerCustomEditor(Date.class, "bookingstartdate", new CustomDateEditor(dateTimeFormat, true));
        binder.registerCustomEditor(Date.class, "bookingenddate", new CustomDateEditor(dateTimeFormat, true));
    }

    @PostMapping("/saveMatch")
    public String saveMatch(@ModelAttribute MatchesDTO matchesDTO) {
        matchesService.insertMatch(matchesDTO);
        return "redirect:/matches";
    }
}
