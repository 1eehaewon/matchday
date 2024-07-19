package kr.co.matchday.admin;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.google.gson.Gson;

import jakarta.servlet.http.HttpServletResponse;

@Controller
@RequestMapping("/admin")
public class AdminCont {
	public AdminCont() {
		System.out.println("AdminCont() 객체 생성됨");
	}// end

	@Autowired
	AdminDAO adminDao;

	@Autowired
	AdminService adminService;
	
	// 관리자모드메인페이지
	@GetMapping("/dashboard")
	public String dashboard() {
		return "/admin/dashboard";
	}

	// 관리자모드회원관리페이지 users : jsp의 items명
//	@GetMapping("/member")
//	public String member(Model model) {
//		List<AdminDTO> users = adminDao.selectAllUsers();
//		model.addAttribute("users", users);
//		return "/admin/member";
//	}
	//총금액추가
	@GetMapping("/member")
	public String member(Model model) {
	    List<Map<String, Object>> users = adminDao.getTotalSpentByUsers();
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
    
    //포인트페이지
    @GetMapping("/point/setting")
    public String pointSettingForm(Model model) {
    	List<PointMasterDTO> pointMasterDto = adminDao.getPointCategories();
    	model.addAttribute("points", pointMasterDto);
    	return "/admin/point";
    }
    
    @PostMapping("/point/add")
    public String createPoint(PointMasterDTO pointMasterDto, RedirectAttributes redirectAttributes) {
        adminDao.createPoint(pointMasterDto);
     // 기본값 설정
        if (pointMasterDto.getAccumulatedpoints() == null) {
            pointMasterDto.setAccumulatedpoints(0);
        }
        if (pointMasterDto.getRate() == null) {
            pointMasterDto.setRate(0.0);
        }
        redirectAttributes.addFlashAttribute("message", "포인트가 성공적으로 등록되었습니다.");
        return "redirect:/admin/point/setting";
    }
    
    @GetMapping("/deletePoint")
    public String deletePoint(@RequestParam("id") String pointcategoryid, RedirectAttributes redirectAttributes) {
        int deletedRows = adminDao.deletePoint(pointcategoryid);
        if (deletedRows > 0) {
            redirectAttributes.addFlashAttribute("message", "포인트가 성공적으로 삭제되었습니다.");
        } else {
            redirectAttributes.addFlashAttribute("message", "포인트 삭제에 실패했습니다.");
        }
        return "redirect:/admin/point/setting";
    }
    
    //회원정지
    @PostMapping("/suspendUsers")
    public ResponseEntity<String> suspendUsers(@RequestParam(value = "userIds", required = false) String[] userIds) {
        if (userIds == null || userIds.length == 0) {
            return ResponseEntity.badRequest().body("정지할 회원을 선택해주세요.");
        }
        
        try {
            adminService.suspendUsers(Arrays.asList(userIds));
            return ResponseEntity.ok("회원 정지가 완료되었습니다.");
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body("회원 삭제 중 오류가 발생했습니다.");
        }
    }//suspendUsers() end
    
    //각회원정보
    @GetMapping
    public String getUserActivity(@RequestParam("userid") String userId, Model model) {
        Map<String, Object> userActivity = adminDao.getUserActivity(userId);
        
        List<Map<String, Object>> pointHistory = adminDao.getPointHistory(userId);
        List<Map<String, Object>> purchaseHistory = adminDao.getPurchaseHistory(userId);
        
        userActivity.put("pointHistory", pointHistory);
        userActivity.put("purchaseHistory", purchaseHistory);
        
        model.addAttribute("userActivity", userActivity);
        return "admin/userActivity";
    }
    
    
    //매출현황
    @GetMapping("/chart")
    public String chart() {
    	return "admin/chart";
    }
    
    @GetMapping("/chart/daily")
    public void getDailySales(HttpServletResponse response) throws IOException {
        response.setContentType("application/json");
        response.setCharacterEncoding("UTF-8");

        List<Map<String, Object>> salesData = adminDao.getDailySales();
        
        Gson gson = new Gson();
        String json = gson.toJson(salesData);
        response.getWriter().write(json);
    }
}// class end
