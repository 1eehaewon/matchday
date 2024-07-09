package kr.co.matchday.review;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/review")
public class ReviewCont {

	public ReviewCont() {
		System.out.println("-----ReviewCont() 객체 생성됨");
	}//end
	
	@Autowired
	private ReviewDAO reviewDao;
	
	@GetMapping("/list")
    public String list() {
        return "review/list";
    }//list end
	
	@GetMapping("/write")
    public String write(@ModelAttribute("reviewDto") ReviewDTO reviewDto) {
        return "review/write";
    }//list end
	
	
	
	
	
	
	
}//class end
