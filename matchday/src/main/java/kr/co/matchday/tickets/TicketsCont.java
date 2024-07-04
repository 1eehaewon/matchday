package kr.co.matchday.tickets;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/tickets")
public class TicketsCont {
	
	public TicketsCont() {
		System.out.println("----TicketsCont() 객체");
	}
	
	@GetMapping("/ticketspayment")
	public String ticketspayment() {
		return "tickets/ticketspayment";
	}
	
}
