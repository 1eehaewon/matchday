package kr.co.matchday.cart;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;


import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/cart")
public class CartCont {

	public CartCont() {
		System.out.println("-----CartCont() 객체 생성됨");
	}//end
	
	@Autowired
	CartDAO cartDao;

    @PostMapping("/insert")
    public String insert(@ModelAttribute CartDTO cartDto, HttpSession session) {
        // 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        cartDto.setUserid(userid);

        // 장바구니에 상품 추가
        cartDao.insert(cartDto);
        return "redirect:/cart/list";
    }

    @GetMapping("/list")
    public String showCartList(Model model, HttpSession session) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }

        List<CartDTO> cartList = cartDao.getCartList(userid);
        model.addAttribute("cartList", cartList);
        return "cart/list";
	
    }
	
	
}//class end
