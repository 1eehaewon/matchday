package kr.co.matchday.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

@Controller
@RequestMapping("/admin")
public class AdminCont {
	public AdminCont() {
		System.out.println("AdminCont() 객체 생성됨");
	}// end

	@Autowired
	AdminDAO adminDao;

	// 관리자모드메인페이지
	@GetMapping("/dashboard")
	public String dashboard() {
		return "/admin/dashboard";
	}

	// 관리자모드회원관리페이지 users : jsp의 items명
	@GetMapping("/member")
	public String member(Model model) {
		List<AdminDTO> users = adminDao.selectAllUsers();
		model.addAttribute("users", users);
		return "/admin/member";
	}

	// 쿠폰등록페이지
	@GetMapping("/coupon/create")
	public String createCouponForm() {
		return "/admin/createCoupon";
	}
	
	// 쿠폰등록하기
	@PostMapping("/coupon/create")
    public String createCoupon(CouponMasterDTO couponMasterDto, RedirectAttributes redirectAttributes) {
        adminDao.insertCoupon(couponMasterDto);
        redirectAttributes.addFlashAttribute("message", "쿠폰이 성공적으로 생성되었습니다.");
        return "redirect:/admin/coupon/list";
    }
	
	// 관리자 모드 쿠폰 관리 페이지
    @GetMapping("/coupon/list")
    public String coupons(Model model) {
    	List<CouponMasterDTO> coupons = adminDao.selectAllCoupons();
        model.addAttribute("coupons", coupons);
        return "/admin/coupons";
    }
    
    //쿠폰수정버튼
    @GetMapping("/editCoupon")
    public String editCouponForm(@RequestParam("id") String coupontypeid, Model model) {
        CouponMasterDTO coupon = adminDao.getCouponById(coupontypeid);
        model.addAttribute("coupon", coupon);
        return "/admin/editCoupon";
    }
    
    //쿠폰수정하기
    @PostMapping("/editCoupon")
    public String editCouponSubmit(CouponMasterDTO coupon, RedirectAttributes redirectAttributes) {
        int updatedRows = adminDao.updateCoupon(coupon);
        if (updatedRows > 0) {
            redirectAttributes.addFlashAttribute("message", "쿠폰이 성공적으로 수정되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("message", "쿠폰 수정에 실패했습니다.");
        }
        return "redirect:/admin/coupon/list";
    }

    @GetMapping("/deleteCoupon")
    public String deleteCoupon(@RequestParam("id") String coupontypeid, RedirectAttributes redirectAttributes) {
        int deletedRows = adminDao.deleteCoupon(coupontypeid);
        if (deletedRows > 0) {
            redirectAttributes.addFlashAttribute("message", "쿠폰이 성공적으로 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("message", "쿠폰 삭제에 실패했습니다.");
        }
        return "redirect:/admin/coupon/list";
    }
}// class end
