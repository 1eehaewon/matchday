package kr.co.matchday.coupon;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.admin.CouponMasterDTO;
import kr.co.matchday.mypage.MypageDAO;

@Controller
@RequestMapping("/member/mypage")
public class CouponCont {
	public CouponCont() {
		System.out.println("CouponCont() 객체 생성됨");
	}// end

	@Autowired
	MypageDAO mypageDao;

	@Autowired
	CouponDAO couponDao;

	/*
	 * @GetMapping("/coupon") public String point(HttpSession session, Model model){
	 * String userID = (String) session.getAttribute("userID"); if (userID == null)
	 * { model.addAttribute("message", "로그인이 필요합니다."); return "/member/login"; // 경고
	 * 메시지와 함께 로그인페이지로 이동 } MypageDTO user = mypageDao.getUserById(userID);
	 * model.addAttribute("user", user);
	 * 
	 * // 쿠폰목록 조회 couponList : coupon.jsp의 items명 List<CouponDTO> couponList =
	 * couponDao.selectCouponList(userID); model.addAttribute("couponList",
	 * couponList); return "/member/coupon"; // 마이페이지의 쿠폰으로 이동 }
	 */

	@GetMapping("/coupon")
	public String couponPage(HttpSession session, Model model) {

		String userID = (String) session.getAttribute("userID");
		if (userID == null) {
			model.addAttribute("message", "로그인이 필요합니다.");
			return "/member/login"; // 경고 메시지와 함께 로그인페이지로 이동
		}
		// 사용자가 보유한 쿠폰 및 받을 수 있는 쿠폰 목록을 불러옴
		List<CouponDTO> receivedCoupons = couponDao.selectReceivedCoupons("userid");
		List<CouponMasterDTO> availableCoupons = couponDao.selectAvailableCoupons();

		model.addAttribute("receivedCoupons", receivedCoupons);
		model.addAttribute("availableCoupons", availableCoupons);
		return "/member/coupon";
	}

	@PostMapping("/coupon/download")
    @ResponseBody
    public Response downloadCoupon(@RequestBody DownloadRequest request, HttpSession session) {
        String userID = (String) session.getAttribute("userID");
        if (userID == null) {
            return new Response(false, "로그인이 필요합니다.");
        }
        try {
            String coupontypeid = request.getCoupontypeid();
            CouponMasterDTO couponMasterDTO = couponDao.selectCouponByType(coupontypeid);

            if (couponMasterDTO == null) {
                return new Response(false, "해당 쿠폰 정보를 찾을 수 없습니다.");
            }

            String couponid = UUID.randomUUID().toString();
            CouponDTO couponDTO = new CouponDTO();
            couponDTO.setCouponid(couponid);
            couponDTO.setCoupontypeid(coupontypeid);
            couponDTO.setUserid(userID);
            couponDTO.setUsage("Not Used");

            couponDao.insertUserCoupon(couponDTO);

            return new Response(true, "쿠폰이 성공적으로 다운로드되었습니다.");
        } catch (Exception e) {
            return new Response(false, "다운로드 중 오류가 발생했습니다.");
        }
    }

	static class DownloadRequest {
		private String couponid;
		private String coupontypeid;

		public String getCouponid() {
			return couponid;
		}

		public void setCouponid(String couponid) {
			this.couponid = couponid;
		}

		public String getCoupontypeid() {
			return coupontypeid;
		}

		public void setCoupontypeid(String coupontypeid) {
			this.coupontypeid = coupontypeid;
		}
	}

	static class Response {
		private boolean success;
		private String message;

		public Response(boolean success, String message) {
			this.success = success;
			this.message = message;
		}

		public boolean isSuccess() {
			return success;
		}

		public String getMessage() {
			return message;
		}
	}

}// class end
