package kr.co.matchday.cart;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.login.LoginDAO;
import kr.co.matchday.login.LoginDTO;
import kr.co.matchday.mypage.MypageDTO;

@Controller
@RequestMapping("/cart")
public class CartCont {

	public CartCont() {
		System.out.println("-----CartCont() 객체 생성됨");
	}//end
	
	@Autowired
	CartDAO cartDao;

	// Handle request to insert into cart
    @PostMapping("/insert")
    public String insert(@ModelAttribute CartDTO cartDto) {
        cartDao.insert(cartDto);
        return "redirect:/cart/list";
    }

	/*
	 * // Handle request to show cart list
	 * 
	 * @GetMapping("/list") public String showCartList(Model
	 * model, @RequestParam("userid") String userid) { List<CartDTO> cartList =
	 * cartDao.getCartList(userid); model.addAttribute("cartList", cartList); return
	 * "cart-list"; // Assuming you have a Thymeleaf template named "cart-list.html"
	 * }
	 */
	

	
	
}//class end
