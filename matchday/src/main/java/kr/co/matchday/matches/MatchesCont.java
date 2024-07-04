package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/matches")
public class MatchesCont {

	
	@Autowired
	private MatchesDAO matchesDao;
	
    public MatchesCont() {
        System.out.println("-----MatchesCont() 객체 생성됨");
    }
    
   @GetMapping("/list") 
   public String list() {
	   return "matches/list";
   }
   
   @GetMapping("/write")
   public String write() {
       return "matches/write";
   }//write() end
    

    

   
}//class end
