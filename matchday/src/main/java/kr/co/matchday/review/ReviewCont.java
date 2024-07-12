package kr.co.matchday.review;

import java.io.File;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;

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
    public String write(@ModelAttribute("reviewDto") ReviewDTO reviewDto, Model model, HttpSession session) {
		// 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
		
		List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        return "review/write";
    }
	
    @PostMapping("/insert")
    public String insert(@ModelAttribute ReviewDTO reviewDto, HttpSession session, @RequestParam("upfiles") MultipartFile[] files) {
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
    	
    	// 파일 업로드 처리
        if (files != null && files.length > 0) {
            for (MultipartFile file : files) {
                if (!file.isEmpty()) {
                    try {
                        // 실제 서버에 파일 저장하는 로직 추가 (예: 파일명 중복 처리 필요)
                        String filePath = "/storage/review" + file.getOriginalFilename(); // 실제 저장할 경로 설정
                        File dest = new File(filePath);
                        file.transferTo(dest);
                        // 리뷰ID와 함께 DB에 파일 정보 저장하는 로직 추가 필요
                    } catch (Exception e) {
                        e.printStackTrace();
                    }
                }
            }
        }
    	
    	
    	
    	
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
