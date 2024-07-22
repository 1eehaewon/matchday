package kr.co.matchday.cart;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;
import kr.co.matchday.mypage.MypageDAO;
import kr.co.matchday.mypage.MypageDTO;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.order.OrderDAO;

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

    @Autowired
    private OrderDAO orderDao;
    
    @Autowired
    private MypageDAO mypageDao;
	
    @PostMapping("/insert")
    @ResponseBody
    public String insert(@ModelAttribute CartDTO cartDto, HttpSession session) {
    	System.out.println("-----insert INININ됨");
        String userid = (String) session.getAttribute("userID");
        System.out.println("-----insert 1111됨");
        if (userid == null) {
            return "redirect:/member/login";
        }
        System.out.println("-----insert 222됨");
        cartDto.setUserid(userid);
        cartDao.insert(cartDto);
        System.out.println("-----insert 3333됨");
        return "SUCCESS";
    }

    @GetMapping("/list")
    public String showCartList(Model model, HttpSession session) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login";
        }
        
        List<GoodsDTO> goodsList = goodsDao.list();
        List<CartDTO> cartList = cartDao.getCartList(userid);
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("cartList", cartList);
        return "cart/list";
    }

    @GetMapping("/delete")
    public String deleteItems(@RequestParam("cartid") List<Integer> cartid) {
        for (int id : cartid) {
            cartDao.delete(id);
        }
        return "redirect:/cart/list";
    }

    @GetMapping("/cartPayment")
    public String cartPayment(
    		@RequestParam("cartid") String cartid,
            @RequestParam("goodsid") String goodsid,
            @RequestParam("size") String size,
            @RequestParam("quantity") String quantity,
            @RequestParam("price") String price,
            @RequestParam("deliveryfee") String deliveryfee,
            @RequestParam("totalPrice") String totalPrice,
            HttpSession session, Model model) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login";
        }

        List<String> goodsidList = Arrays.asList(goodsid.split(","));
        List<String> sizeList = Arrays.asList(size.split(","));
        List<Integer> quantityList = Arrays.asList(quantity.split(",")).stream().map(Integer::parseInt).collect(Collectors.toList());
        List<Integer> priceList = Arrays.asList(price.split(",")).stream().map(Integer::parseInt).collect(Collectors.toList());
        List<Integer> totalPriceList = Arrays.asList(totalPrice.split(",")).stream().map(Integer::parseInt).collect(Collectors.toList());

        List<GoodsDTO> goodsList = goodsidList.stream().map(goodsDao::detail).collect(Collectors.toList());
        model.addAttribute("goodsid", goodsid);
        model.addAttribute("size", size);
        model.addAttribute("quantity", quantity);
        model.addAttribute("price", price);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("deliveryfee", deliveryfee);
        model.addAttribute("cartid", cartid);
        
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("sizeList", sizeList);
        model.addAttribute("quantityList", quantityList);
        model.addAttribute("priceList", priceList);
        model.addAttribute("totalPriceList", totalPriceList);

        List<CouponDTO> couponList = orderDao.getCouponsByUserId(userid);
        model.addAttribute("couponList", couponList);

        MypageDTO mypageDto = mypageDao.getUserById(userid);
        if (mypageDto == null) {
            model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
            return "error";
        }
        model.addAttribute("totalpoints", mypageDto.getTotalpoints());

        return "cart/cartPayment";
    }
}
