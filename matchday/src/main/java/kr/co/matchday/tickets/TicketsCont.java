package kr.co.matchday.tickets;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import kr.co.matchday.matches.MatchesDTO;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {
    
	@Autowired
	private TicketsDAO ticketsDao;
	
    public TicketsCont() {
        System.out.println("----TicketsCont() 객체");
    }
    
    @GetMapping("/ticketspayment")
    public ModelAndView ticketspayment(@RequestParam String matchid) {
        System.out.println("Received matchid: " + matchid);
        MatchesDTO matchesDto = ticketsDao.getMatchById(matchid);
        if (matchesDto == null) {
            return new ModelAndView("errorPage").addObject("message", "Match not found for ID: " + matchid);
        }
        ModelAndView mav = new ModelAndView("tickets/ticketspayment");
        mav.addObject("match", matchesDto);
        return mav;
    }
}
