package kr.co.matchday.order;

import java.sql.Timestamp;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.json.JSONObject;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.env.Environment;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;

import com.fasterxml.jackson.databind.ObjectMapper;

import jakarta.servlet.http.HttpSession;
import kr.co.matchday.admin.CouponMasterDTO;
import kr.co.matchday.coupon.CouponDAO;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;
import kr.co.matchday.goods.StockDTO;
import kr.co.matchday.point.PointHistoryDTO;
import kr.co.matchday.tickets.TicketsDTO;
import kr.co.matchday.tickets.TicketsDetailDTO;

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
	
	@Autowired
	private CouponDAO couponDao;
	
	@Autowired
    private Environment env; // 환경변수를 관리하는 객체
	
	//@RequestMapping(value = "/order/insert", method = RequestMethod.POST)
	@GetMapping("/insert")
	public String insert(@ModelAttribute OrderDTO orderDto, HttpSession session) {
		// 로그인된 사용자 정보 가져오기
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login"; // 로그인 페이지로 리디렉션
        }
        orderDto.setUserid(userid);
        
        // 주문 정보 삽입
        orderDao.insert(orderDto);
        
        /*return "redirect:/order/payment?goodsid=" + orderDto.getGoodsid() +
		 "&size=" + stockDto.getSize() + 
                "&quantity=" + orderDto.getQuantity() +
                "&price=" + orderDto.getPrice() +
                "&totalPrice=" + orderDto.getFinalpaymentamount();*/
        return "redirect:/order/payment?goodsid=" + orderDto.getOrderid();
		 //return "redirect:/order/payment";
	}//insert end
	
	//@PostMapping("/payment")
	@GetMapping("/payment")
	//@ResponseBody
	public String payment(@RequestParam("goodsid") String goodsid,
			@ModelAttribute OrderDTO orderDto,
	//public Map<String, Object> payment(@RequestParam("goodsid") String goodsid, 
    					@RequestParam("size") String size,
    					@RequestParam("quantity") String quantity,
    					@RequestParam("price") String price, 
    					@RequestParam("totalPrice") String totalPrice,
    					@RequestParam Map<String, String> requestParams,
    					@RequestParam(value = "couponid", required = false) String couponid, // 쿠폰 ID 추가
    					@RequestParam(value = "usedpoints", required = false, defaultValue = "0") int usedPoints,
    					Model model,
    					HttpSession session) {
	    
	    // 사용자 정보 조회
	    String userid = (String) session.getAttribute("userID");
	    Map<String, Object> userInfo = orderDao.getUserInfo(userid);
	    model.addAttribute("userInfo", userInfo); // 모델에 사용자 정보 추가
	    
		//Map<String, Object> response = new HashMap<>();
		//System.out.println("payment 시작");
		
		GoodsDTO goods = goodsDao.detail(goodsid);
		//굿즈 목록 조회
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        model.addAttribute("size", size);
        model.addAttribute("quantity", quantity);
        model.addAttribute("price", price);
        model.addAttribute("totalPrice", totalPrice);        

        // 사용자에게 사용 가능한 쿠폰 조회
        List<CouponDTO> couponList = orderDao.getCouponsByUserId(userid);
        model.addAttribute("couponList", couponList);

        // 쿠폰 코드가 제공된 경우 쿠폰 할인 적용
        int discountRate = 0;
        if (couponid != null && !couponid.isEmpty()) {
            discountRate = orderDao.getDiscountRateByCouponId(couponid); // 할인율 가져오기
         // 쿠폰 사용 상태 업데이트
            orderDao.updateCouponUsage(couponid);
        }
        model.addAttribute("discountRate", discountRate); 

        // 사용자의 포인트 이력 조회
        List<PointHistoryDTO> pointHistoryList = orderDao.getPointByUserId(userid);
        model.addAttribute("pointHistoryList", pointHistoryList);

        
        
        
        
        
        
        
        
        /*// 포인트 이력 추가
        PointHistoryDTO pointHistoryDto = new PointHistoryDTO();
        pointHistoryDto.setUserid(userid);
        pointHistoryDto.setPointcategoryid("1"); // 포인트 카테고리 ID 설정 (예시)
        pointHistoryDto.setPointtype("Use"); // Accumulate 또는 Use 설정
        pointHistoryDto.setPointamount(Integer.parseInt(totalPrice)); // 결제한 총 금액을 포인트로 사용
        pointHistoryDto.setPointsource("Order Payment"); // 포인트 출처 설정
        pointHistoryDto.setPointcreationdate(new Timestamp(System.currentTimeMillis()));

        orderDao.insertPointHistory(pointHistoryDto); // 포인트 이력 데이터베이스에 추가
        */
        
        
        
        
        
        
        // 요청 파라미터를 추출
        /*String imp_uid = requestParams.get("imp_uid");
        String merchant_uid = requestParams.get("merchant_uid");
        int paid_amount = Integer.parseInt(requestParams.get("paid_amount"));
        String orderid = requestParams.get("orderid");
        int finalpaymentamount = Integer.parseInt(requestParams.get("finalpaymentamount"));
        String recipientname = requestParams.get("recipientname");
        String recipientemail = requestParams.get("recipientemail");
        String recipientphone = requestParams.get("recipientphone");
        String shippingaddress = requestParams.get("shippingaddress");
        String shippingrequest = requestParams.get("shippingrequest");
        String collectionmethodcode = requestParams.get("collectionmethodcode");
        String couponId = requestParams.get("couponid"); // 쿠폰 ID 추가
        
        // 토큰 획득
        String token = getToken();
        if (token == null) {
            response.put("success", false);
            System.out.println("토큰을 가져오지 못했습니다.");
            return response;
        }
        
     // 아임포트 API를 통해 결제 정보 조회
        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> paymentResponse = restTemplate.exchange(
                "https://api.iamport.kr/payments/" + imp_uid, HttpMethod.GET, entity, String.class);

        if (paymentResponse.getStatusCode() == HttpStatus.OK) {
            try {
                // 결제 정보를 JSON으로 파싱
            	ObjectMapper objectMapper = new ObjectMapper();
                Map<String, Object> paymentJson = objectMapper.readValue(paymentResponse.getBody(), Map.class);
                Map<String, Object> responseJson = (Map<String, Object>) paymentJson.get("response");
                int amount = (Integer) responseJson.get("amount");

                if (amount == paid_amount) {
                    System.out.println("결제 금액이 일치합니다.");

                    // 세션에서 사용자 ID 가져오기
                    String userid = (String) session.getAttribute("userID");
                    if (userid == null) {
                        response.put("success", false);
                        response.put("message", "세션에서 사용자 ID를 찾을 수 없습니다.");
                        System.out.println("세션에서 사용자 ID를 찾을 수 없습니다.");
                        return response;
                    }

                    String currentTimestamp = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

                    // 결제가 완료된 후 쿠폰 사용 업데이트
                    if (couponId != null && !couponId.equals("0")) {
                        int updateResult = orderDao.updateCouponUsage(couponId);
                        if (updateResult > 0) {
                            System.out.println("쿠폰 사용 업데이트 성공: " + couponId);
                        } else {
                            System.out.println("쿠폰 사용 업데이트 실패: " + couponId);
                        }
                    }

                    response.put("success", true);
                } else {
                    response.put("success", false);
                    response.put("message", "결제 금액이 일치하지 않습니다.");
                    System.out.println("결제 금액이 일치하지 않습니다.");
                }
            } catch (Exception e) {
                response.put("success", false);
                response.put("message", "결제 검증 중 오류 발생.");
                e.printStackTrace();
            }
        } else {
            response.put("success", false);
            response.put("message", "결제 정보를 가져오지 못했습니다.");
            System.out.println("결제 정보를 가져오지 못했습니다.");
        }
*/
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

	        //굿즈 목록 조회
	        List<GoodsDTO> goodsList = goodsDao.list();
	        model.addAttribute("goodsList", goodsList);
	        
	        // 사용자의 받은 쿠폰 목록 조회
	        List<CouponDTO> couponList = couponDao.selectReceivedCoupons(userid);
	        model.addAttribute("couponList", couponList);
	        //List<CouponMasterDTO> couponmasterList = couponDao.selectAvailableCoupons();
	        //model.addAttribute("couponmasterList", couponmasterList);
	        
	        
	        return "order/list";
	    }
	 
	 	// 사용자의 포인트 이력을 추가하는 메서드
	    @PostMapping("/addPointHistory")
	    public String addPointHistory(@RequestParam("userid") String userid,
	                                  @RequestParam("pointcategoryid") String pointcategoryid,
	                                  @RequestParam("pointtype") String pointtype,
	                                  @RequestParam("pointamount") int pointamount,
	                                  HttpSession session) {
	        // 포인트 이력 DTO 생성 및 설정
	        PointHistoryDTO pointHistoryDto = new PointHistoryDTO();
	        pointHistoryDto.setUserid(userid);
	        pointHistoryDto.setPointcategoryid(pointcategoryid);
	        pointHistoryDto.setPointtype(pointtype);
	        pointHistoryDto.setPointamount(pointamount);
	        pointHistoryDto.setPointsource("Order Payment"); // 예시로 "Order Payment"로 설정
	        pointHistoryDto.setPointcreationdate(new Timestamp(System.currentTimeMillis()));
	        pointHistoryDto.setPointusedate(null); // 사용 날짜는 null로 설정 (사용 시에 설정)

	        // 포인트 이력 추가
	        orderDao.insertPointHistory(pointHistoryDto);

	        return "redirect:/order/payment";
	    }
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 /**
	     * 아임포트 API 토큰 획득 메서드
	     * @return API 토큰 문자열
	     */
	   /* private String getToken() {
	        try {
	            RestTemplate restTemplate = new RestTemplate();
	            HttpHeaders headers = new HttpHeaders();
	            headers.setContentType(MediaType.APPLICATION_JSON);

	            Map<String, String> request = new HashMap<>();
	            request.put("imp_key", env.getProperty("iamport.api_key"));
	            request.put("imp_secret", env.getProperty("iamport.api_secret"));

	            ObjectMapper objectMapper = new ObjectMapper();
	            String requestBody = objectMapper.writeValueAsString(request);

	            System.out.println("Request Body: " + requestBody);

	            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);
	            ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", entity, String.class);

	            if (response.getStatusCode() == HttpStatus.OK) {
	                JSONObject json = new JSONObject(response.getBody());
	                return json.getJSONObject("response").getString("access_token");
	            } else {
	                System.out.println("Failed to get token, response: " + response.getBody());
	            }
	        } catch (Exception e) {
	            e.printStackTrace();
	        }

	        return null;
	    }
	 
	 */
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	 
	/*
	 @PostMapping("/confirm")
	 public String confirm(@ModelAttribute OrderDTO orderDto, HttpSession session, Model model) {
	     // 로그인된 사용자 정보 가져오기
	     String userid = (String) session.getAttribute("userID");
	     if (userid == null) {
	         return "redirect:/member/login"; // 로그인 페이지로 리디렉션
	     }

	     // 결제 처리 로직
	     orderDto.setUserid(userid);
	     orderDao.insert(orderDto);

	     model.addAttribute("orderDto", orderDto);
	     return "order/confirmation"; // 결제 확인 페이지로 이동
	 }

	*/
	
	
	
}//class end