package kr.co.matchday.order;

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
@RequestMapping("/order")
public class OrderCont {

	public OrderCont() {
		System.out.println("-----OrderCont() 객체 생성됨");
	}//end
	
	@Autowired
	private OrderDAO orderDao;
	
	@Autowired
    private GoodsDAO goodsDao;
	
	@PostMapping("/insert")
	public String insert(@ModelAttribute OrderDTO orderDto, HttpSession session) {
		// 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        orderDto.setUserid(userid);
        
        // 주문 정보 삽입
        orderDao.insert(orderDto);
        
        return "redirect:/order/payment?goodsid=" + orderDto.getOrderid();
		/* return "redirect:/order/payment"; */
	}//insert end
	
	@GetMapping("/payment")
    public String payment(@RequestParam("goodsid") String goodsid, Model model) {
        // 여기에서 결제 관련 로직을 처리합니다.
        // 예를 들어, 결제 페이지로 이동
		GoodsDTO goods = goodsDao.detail(goodsid);
		//굿즈 목록 조회
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        System.out.println("goodsList");
        return "order/payment";
    }
	
	 @GetMapping("/list")
	    public String list(HttpSession session, Model model) {
	        // 로그인된 사용자 정보 가져오기
	        String userid = (String) session.getAttribute("userID");
	        if (userid == null) {
	            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
	        }
	        
	        // 사용자의 주문 목록 조회
	        List<OrderDTO> orderList = orderDao.list(userid);
	        model.addAttribute("orderList", orderList);
	        System.out.println("orderList");
	        //굿즈 목록 조회
	        List<GoodsDTO> goodsList = goodsDao.list();
	        model.addAttribute("goodsList", goodsList);
	        System.out.println(goodsList);
	        
	        return "order/list";
	    }
	
	
	
	
	
	
}//class ends
