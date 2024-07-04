package kr.co.matchday.carts;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

@Controller
@RequestMapping("/carts")
public class CartsCont {

	public CartsCont() {
		System.out.println("-----CartsCont() 객체 생성됨");
	}//end
	
	@Autowired
	CartsDAO cartsDao;
	
	@GetMapping("/list")
    public ModelAndView list() {
        ModelAndView mav = new ModelAndView();
        mav.setViewName("carts/list");
        // Add any necessary data to the model here
        return mav;
    }
	
	
}//class end
