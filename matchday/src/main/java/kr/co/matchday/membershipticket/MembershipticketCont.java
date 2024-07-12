package kr.co.matchday.membershipticket;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import kr.co.matchday.memberships.MembershipsDAO;

@Controller
@RequestMapping("/membershipticket")
public class MembershipticketCont {


	 public  MembershipticketCont() {
		System.out.println("------MembershipticketCont() 객체 생성됨"); 
	 }//class end	
	 
	 @Autowired
	 private MembershipticketDAO MembershipticketDao;
	 
	    
}//class end