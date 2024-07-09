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

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;

@Controller
@RequestMapping("/cart")
public class CartCont {

	public CartCont() {
		System.out.println("-----CartCont() 객체 생성됨");
	}//end
	
	@Autowired
	CartDAO cartDao;

	@Autowired
    private GoodsDAO goodsDao;
	
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
    }//insert end

    @GetMapping("/list")
    public String showCartList(Model model, HttpSession session) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        
        List<GoodsDTO> goodsList = goodsDao.list();
        List<CartDTO> cartList = cartDao.getCartList(userid);
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("cartList", cartList);
        return "cart/list";
    }//list end
	
    /*@GetMapping("/delete")
    public String deleteItem(@RequestParam("cartid") int cartid) {
        cartDao.delete(cartid);
        return "redirect:/cart/list";
    }//delete end*/
	
    @GetMapping("/delete")
    public String deleteItems(@RequestParam("cartid") List<Integer> cartid) {
        for (int id : cartid) {
            cartDao.delete(id);
        }
        return "redirect:/cart/list";
    }
    
    
    
}//class end
