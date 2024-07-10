package kr.co.matchday.review;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.cart.CartDTO;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;

@Controller
@RequestMapping("/review")
public class ReviewCont {

	public ReviewCont() {
		System.out.println("-----ReviewCont() 객체 생성됨");
	}//end
	
	@Autowired
	private ReviewDAO reviewDao;
	
	@Autowired
    private GoodsDAO goodsDao;
/*
	@GetMapping("/write")
    public String write(@ModelAttribute("reviewDto") ReviewDTO reviewDto) {
        return "review/write";
    }//write end
*/
	@GetMapping("/write")
    public String write(@ModelAttribute("reviewDto") ReviewDTO reviewDto, Model model) {
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        return "review/write";
    }
	
    @PostMapping("/insert")
    public String insert(@ModelAttribute ReviewDTO reviewDto, HttpSession session) {
    	// 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        
        // 기타 필요한 정보 설정 (userid, matchid, goodsid)
        reviewDto.setUserid(userid);
        reviewDto.setMatchid(reviewDto.getMatchid()); // 매치 ID 설정 필요
        reviewDto.setGoodsid(reviewDto.getGoodsid()); // 굿즈 ID 설정 필요
        
        //reviewDto.setUserid(userid);
        //reviewDto.setMatchid(userid);
        //reviewDto.setGoodsid(userid);
        
    	reviewDao.insert(reviewDto);
        return "redirect:/review/list";
    }//insert end

    @GetMapping("/list")
    public String list(Model model, HttpSession session) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        /*
        List<GoodsDTO> goodsList = goodsDao.list();
        List<ReviewDTO> reviewList = reviewDao.list();
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("reviewList", reviewList);
        return "review/list";
        */
        List<ReviewDTO> reviewList = reviewDao.list();
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("reviewList", reviewList);
        model.addAttribute("goodsList", goodsList);
        return "review/list";
        
    }//list end
	 
	
	
	
	
	
	
	
}//class end
