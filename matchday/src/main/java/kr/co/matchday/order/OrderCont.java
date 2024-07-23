package kr.co.matchday.order;

import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Calendar;
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
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.servlet.ModelAndView;

import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.http.HttpSession;
import kr.co.matchday.cart.CartDAO;
import kr.co.matchday.cart.CartDTO;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.goods.GoodsDAO;
import kr.co.matchday.goods.GoodsDTO;
import kr.co.matchday.goods.StockDTO;
import kr.co.matchday.mypage.MypageDAO;
import kr.co.matchday.mypage.MypageDTO;
import kr.co.matchday.point.PointHistoryDTO;
import kr.co.matchday.tickets.TicketsDTO;

@Controller
@RequestMapping("/order")
public class OrderCont {

    @Autowired
    private OrderDAO orderDao;

    @Autowired
    private GoodsDAO goodsDao;

    @Autowired
    private MypageDAO mypageDao;
    
    @Autowired
    private CartDAO cartDao;

    @Autowired
    private Environment env;

    @GetMapping("/payment")
    public String payment(@RequestParam("goodsid") String goodsid,
                          @RequestParam("size") String size,
                          @RequestParam("quantity") int quantity,
                          @RequestParam("price") int price,
                          @RequestParam("deliveryfee") int deliveryfee,
                          @RequestParam("totalPrice") int totalPrice,
                          @RequestParam(value = "couponid", required = false) String couponid,
                          @RequestParam(value = "usedpoints", required = false, defaultValue = "0") int usedpoints,
                          HttpSession session, Model model) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login";
        }

        GoodsDTO goods = goodsDao.detail(goodsid);
        if (goods == null) {
            model.addAttribute("error", "상품 정보를 찾을 수 없습니다.");
            return "error";
        }
        model.addAttribute("goods", goods);
        model.addAttribute("size", size);
        model.addAttribute("quantity", quantity);
        model.addAttribute("price", price);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("deliveryfee", deliveryfee);
        model.addAttribute("couponid", couponid);
        model.addAttribute("usedpoints", usedpoints);

        List<CouponDTO> couponList = orderDao.getCouponsByUserId(userid);
        model.addAttribute("couponList", couponList);

        int discountRate = 0;
        if (couponid != null && !couponid.isEmpty()) {
            try {
                discountRate = orderDao.getDiscountRateByCouponId(couponid);
            } catch (Exception e) {
                model.addAttribute("error", "유효하지 않은 쿠폰입니다.");
                return "error";
            }
        }
        model.addAttribute("discountRate", discountRate);

        MypageDTO mypageDto = mypageDao.getUserById(userid);
        if (mypageDto == null) {
            model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
            return "error";
        }
        model.addAttribute("totalpoints", mypageDto.getTotalpoints());

        return "order/payment";
    }

    @PostMapping("/verifyPayment")
    @ResponseBody
    public Map<String, Object> verifyPayment(@RequestParam Map<String, String> requestParams, HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        
        System.out.println("HERE !! ");
        System.out.println(requestParams);
        System.out.println(requestParams.get("goodsid"));
        
        
        String imp_uid = requestParams.get("imp_uid");
        String merchant_uid = requestParams.get("merchant_uid");
        int paid_amount = parseInteger(requestParams.get("paid_amount"), 0);
        int finalpaymentamount = parseInteger(requestParams.get("finalpaymentamount"), 0);
        String recipientname = requestParams.get("recipientname");
        String recipientemail = requestParams.get("recipientemail");
        String recipientphone = requestParams.get("recipientphone");
        String shippingaddress = requestParams.get("shippingaddress");
        String shippingrequest = requestParams.get("shippingrequest");
        String paymentmethodcode = requestParams.get("paymentmethodcode");
        String couponid = requestParams.get("couponid");
        int deliveryFee = parseInteger(requestParams.get("deliveryFee"), 0);
        int discountprice = parseInteger(requestParams.get("discountprice"), 0);
        String userId = (String) session.getAttribute("userID");
        int usedpoints = parseInteger(requestParams.get("usedpoints"), 0);
System.out.println("usedpoints = " + usedpoints);
        List<String> goodsidList = Arrays.asList(requestParams.get("goodsid").split(","));
        List<String> quantities = Arrays.asList(requestParams.get("quantity").split(","));
        List<String> sizes = Arrays.asList(requestParams.get("size").split(","));
        List<String> prices = Arrays.asList(requestParams.get("price").split(","));
        List<String> totalPrices = Arrays.asList(requestParams.get("totalPrice").split(","));

System.out.println("imp_uid: " + imp_uid);       
        
        String allcartid = requestParams.get("cartid");
        List<String> cartidList = new ArrayList<String>();
        
        if(allcartid != "" && allcartid != null) {
        	cartidList = Arrays.asList(allcartid.split(","));		// 장바구니 삭제용
        }
        
        if (userId == null) {
            response.put("success", false);
            response.put("message", "세션에서 사용자 ID를 찾을 수 없습니다.");
            return response;
        }

        if (goodsidList.isEmpty()) {
            response.put("success", false);
            response.put("message", "상품 ID가 유효하지 않습니다.");
            return response;
        }

        if (paymentmethodcode == null || paymentmethodcode.isEmpty()) {
            response.put("success", false);
            response.put("message", "결제 방법 코드가 유효하지 않습니다.");
            return response;
        }

        String token = getToken();
        if (token == null) {
            response.put("success", false);
            response.put("message", "토큰을 가져오지 못했습니다.");
            return response;
        }

        RestTemplate restTemplate = new RestTemplate();
        HttpHeaders headers = new HttpHeaders();
        headers.setBearerAuth(token);

        HttpEntity<String> entity = new HttpEntity<>(headers);
        ResponseEntity<String> paymentResponse = restTemplate.exchange(
        "https://api.iamport.kr/payments/" + imp_uid, HttpMethod.GET, entity, String.class);

        String redirectUrl = "/order/orderDetail?orderid=";
        if (paymentResponse.getStatusCode() == HttpStatus.OK) {
            try {
                ObjectMapper objectMapper = new ObjectMapper();
                Map<String, Object> paymentJson = objectMapper.readValue(paymentResponse.getBody(), Map.class);
                Map<String, Object> responseJson = (Map<String, Object>) paymentJson.get("response");
                int amount = (Integer) responseJson.get("amount");

                if (amount == paid_amount) {
                    String orderid = generateOrderId();
                    redirectUrl = redirectUrl + orderid;
                    String currentDate = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(new Date());

                    
                    OrderDTO orderDto = new OrderDTO();
                    orderDto.setOrderid(orderid);
                    orderDto.setUserid(userId);
                    //orderDto.setGoodsid(goodsidList.get(i));
                    orderDto.setOrderdate(currentDate); // 결제 날짜 설정
                    orderDto.setOrderstatus("Completed");
                    if (couponid != null && !couponid.isEmpty() && !couponid.equals("null")) {
                        orderDto.setCouponid(couponid);
                    } else {
                        orderDto.setCouponid(null);
                    }
                    orderDto.setUsedpoints(usedpoints);
                    orderDto.setFinalpaymentamount(finalpaymentamount);
                    orderDto.setShippingstatus("Pending");
                    orderDto.setRecipientname(recipientname);
                    orderDto.setRecipientemail(recipientemail);
                    orderDto.setRecipientphone(recipientphone);
                    orderDto.setShippingaddress(shippingaddress);
                    orderDto.setShippingrequest(shippingrequest);
                    orderDto.setPaymentmethodcode(paymentmethodcode);
                    orderDto.setDeliveryfee(deliveryFee);
                    orderDto.setDiscountprice(discountprice);
                    orderDto.setImpUid(imp_uid);

                    List<OrderdetailDTO> orderDetails = new ArrayList<>();	// TB : orderDetail : 장바구니 개별 구매내역 리스트
                    int Orderquantity = 0;		// TB : order (전체 주문내역 : 장바구니 선택 구매 갯수 합계)
                    int Orderprice = 0;			// TB : order (전체 주문내역 : 장바구니 선택 구매 가격 합계)
                    
                    for (int i = 0; i < goodsidList.size(); i++) {
	                	int quantity = parseInteger(quantities.get(i), 1);
	                    int price = parseInteger(prices.get(i), 0);
	                   
	                    Orderquantity = Orderquantity + quantity;
	                    Orderprice = Orderprice + (price*quantity);
	                    
	                    OrderdetailDTO orderDetail = new OrderdetailDTO();
	                    orderDetail.setGoodsid(goodsidList.get(i));
	                    orderDetail.setSize(sizes.get(i));
	                    orderDetail.setQuantity(quantity);
	                    orderDetail.setPrice(price);
	                    orderDetail.setTotalamount(price * quantity);
	                    orderDetails.add(orderDetail);
	
	                    // 재고수정 start!
	                    StockDTO stockDto = new StockDTO();
	                    stockDto.setGoodsid(goodsidList.get(i));
	                    stockDto.setSize(sizes.get(i));
	                    stockDto.setStockquantity(quantity);
	                    goodsDao.buystockupdate(stockDto);			
	                    // 재고수정 end!
	                    
	                    if(cartidList.size() > 0) {
	                    	cartDao.delete(Integer.parseInt(cartidList.get(i)));	// 장바구니 삭제
	                    }
	                    
	                    orderDto.setOrderDetails(orderDetails);
                    }
                    
                    // 주문 상세 추가
                    orderDto.setPrice(Orderprice);
                    orderDto.setQuantity(Orderquantity);
                    orderDto.setTotalprice(Orderprice);
                    orderDto.setReceiptmethodcode("receiving02");
                   
                    
                    try {
                        orderDao.insert(orderDto); // 주문 저장
                        System.out.println("Order and Order details inserted successfully");
                    } catch (Exception e) {
                        System.err.println("Error inserting order: " + e.getMessage());
                        e.printStackTrace();
                        response.put("success", false);
                        response.put("message", "Order insertion failed.");
                        return response;
                    }
                    
                    // 쿠폰 사용 업데이트
                    if (couponid != null && !couponid.equals("0")) {
                        orderDao.updateCouponUsage(couponid);
                    }
                    /*
                    MypageDTO mypageDto = mypageDao.getUserById(userId);
                    if (mypageDto != null) {
                    	//사용자 포인트 업데이트
                        int totalpoints = mypageDto.getTotalpoints();
                        if (totalpoints >= usedpoints) {
                            mypageDao.buyupdateTotalPoints(userId);

                            PointHistoryDTO pointHistory = new PointHistoryDTO();
                            pointHistory.setUserid(userId);
                            pointHistory.setPointcategoryid("point_use");
                            pointHistory.setPointtype("사용");
                            pointHistory.setPointamount(-usedpoints);
                            //pointHistory.setOrderid(orderid);
                            orderDao.insertPointHistory(pointHistory);

                            response.put("success", true);
                            response.put("redirectUrl", redirectUrl);
                        } else {
                            response.put("success", false);
                            response.put("message", "사용 가능한 포인트가 부족합니다.");
                            return response;
                        }
                    } else {
                        response.put("success", false);
                        response.put("message", "사용자 포인트 정보를 찾을 수 없습니다.");
                        return response;
                    }*/

                    response.put("success", true);
                    response.put("redirectUrl", redirectUrl);
                } else {
                    response.put("success", false);
                    response.put("message", "결제 금액이 일치하지 않습니다.");
                }
            } catch (Exception e) {
                response.put("success", false);
                response.put("message", "결제 검증 중 오류 발생.");
                e.printStackTrace();
            }
        } else {
            response.put("success", false);
            response.put("message", "결제 정보를 가져오지 못했습니다.");
        }

        return response;
    }

    private int parseInteger(String value, int defaultValue) {
        try {
            return Integer.parseInt(value);
        } catch (NumberFormatException e) {
            return defaultValue;
        }
    }

    private String generateOrderId() {
        String prefix = "order";
        String date = new SimpleDateFormat("yyyyMMdd").format(new Date());
        String maxOrderId = orderDao.getMaxOrderId(date);

        int nextSuffix = 1;
        if (maxOrderId != null) {
            nextSuffix = Integer.parseInt(maxOrderId.substring(maxOrderId.length() - 6)) + 1;
        }

        return String.format("%s%s%06d", prefix, date, nextSuffix);
    }

    private String getToken() {
        try {
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> request = new HashMap<>();
            request.put("imp_key", env.getProperty("iamport.api_key"));
            request.put("imp_secret", env.getProperty("iamport.api_secret"));

            ObjectMapper objectMapper = new ObjectMapper();
            String requestBody = objectMapper.writeValueAsString(request);

            HttpEntity<String> entity = new HttpEntity<>(requestBody, headers);
            ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                JSONObject json = new JSONObject(response.getBody());
                return json.getJSONObject("response").getString("access_token");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }
    
    //Mypage 결제 내역
    @GetMapping("/orderList")
    public ModelAndView orderList(@RequestParam(value = "orderid", required = false) String orderid, HttpSession session,Model model) {
        String userId = (String) session.getAttribute("userID");
        if (userId == null) {
            System.out.println("User ID not found in session.");
            return new ModelAndView("redirect:/login"); // 로그인 페이지로 리다이렉트
        }

        System.out.println("Fetching orders for userId: " + userId);
        List<OrderDTO> order = orderDao.getOrderByUserId(userId);
        List<OrderdetailDTO> orderDetail = new ArrayList<>();
        
        // 주문 날짜를 Date 객체로 변환하고 취소 마감시간을 설정하는 로직
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        SimpleDateFormat outputFormatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        
        for (OrderDTO orderDto : order) {
            Date orderDate = null;
            try {
            	// 주문 날짜를 Date 객체로 변환
                orderDate = formatter.parse(orderDto.getOrderdate());
            } catch (ParseException e) {
                e.printStackTrace();
            }
            // 취소 마감시간 설정 (임의로 3일 후로 설정)
            Calendar cal = Calendar.getInstance();
            if (orderDate != null) {
                cal.setTime(orderDate);
                cal.add(Calendar.DATE, 3);
                orderDto.setCancelDeadline(cal.getTime());
            }
        }

        ModelAndView mav = new ModelAndView("order/orderList");
        mav.addObject("order", order);
        
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        
        // 모든 주문에 대한 상세 정보를 조회
        if (orderid != null && !orderid.isEmpty()) {
            orderDetail = orderDao.getOrderDetailByOrderId(orderid);
        } else {
            // 전체 주문에 대한 상세 정보를 조회
            for (OrderDTO orderDto : order) {
                List<OrderdetailDTO> details = orderDao.getOrderDetailByOrderId(orderDto.getOrderid());
                orderDto.setOrderDetails(details);
            }
        }
        mav.addObject("orderDetail", orderDetail); // 상세 정보를 추가
        
        return mav;
    }
    
    //결제 상세 정보
    @GetMapping("/orderDetail")
    public ModelAndView reservationDetail(@RequestParam("orderid") String orderid, HttpSession session, Model model) {
    	String userId = (String) session.getAttribute("userID");
        if (userId == null) {
            System.out.println("User ID not found in session.");
            return new ModelAndView("redirect:/login"); // 로그인 페이지로 리다이렉트
        }
    	
    	ModelAndView mav = new ModelAndView("order/orderDetail");

        // 주문 정보 조회
        OrderDTO order = orderDao.getOrderById(orderid);
        if (order == null) {
            mav.setViewName("errorPage");
            mav.addObject("message", "주문을 찾을 수 없습니다. ID: " + orderid);
            return mav;
        }
        //굿즈 상품
        List<GoodsDTO> goodsList = goodsDao.list();
        model.addAttribute("goodsList", goodsList);
        
        // 주문 상세 정보 조회
        List<OrderdetailDTO> orderdetail = orderDao.getOrderDetailByOrderId(orderid);
        model.addAttribute("orderdetail", orderdetail);

        //쿠폰
        List<CouponDTO> couponList = orderDao.getCouponsByUserId(userId);
        model.addAttribute("couponList", couponList);
        
        // 주문 날짜를 Date 객체로 변환하고 취소 마감시간을 설정하는 로직
        SimpleDateFormat formatter = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
        Date orderDate = null;
        try {
            // 주문 날짜를 Date 객체로 변환
            orderDate = formatter.parse(order.getOrderdate());
        } catch (ParseException e) {
            e.printStackTrace();
        }
        
        // 취소 마감시간 설정 (임의로 3일 후로 설정)
        Calendar cal = Calendar.getInstance();
        if (orderDate != null) {
            cal.setTime(orderDate);
            cal.add(Calendar.DATE, 3);
            order.setCancelDeadline(cal.getTime());
        }
        
        // 결제 내역 설정
        int serviceFee = session.getAttribute("serviceFee") != null ? Integer.parseInt(session.getAttribute("serviceFee").toString()) : 0;
        int deliveryFee = session.getAttribute("deliveryFee") != null ? Integer.parseInt(session.getAttribute("deliveryFee").toString()) : 0;
        int totalDiscount = session.getAttribute("totalDiscount") != null ? Integer.parseInt(session.getAttribute("totalDiscount").toString()) : 0;
        int totalPrice = order.getPrice() * order.getQuantity();
        int finalpaymentamount = session.getAttribute("finalpaymentamount") != null ? Integer.parseInt(session.getAttribute("totalPaymentAmount").toString()) : 0;
        String couponName = session.getAttribute("couponName") != null ? session.getAttribute("couponName").toString() : "";
        //포인트
        
        mav.addObject("serviceFee", serviceFee);
        mav.addObject("deliveryFee", deliveryFee);
        mav.addObject("couponName", couponName);
        //포인트
        mav.addObject("totalDiscount", totalDiscount);
        mav.addObject("totalPrice", totalPrice);
        mav.addObject("finalpaymentamount", finalpaymentamount);
        mav.addObject("order", order);

        return mav;
    }
    
    
    /* 결제 취소 메서드 */
    @PostMapping("/cancelPayment")
    @ResponseBody
    public Map<String, Object> cancelPayment(@RequestParam("orderid") String orderid) {
        Map<String, Object> response = new HashMap<>();

        try {
            String impUid = orderDao.getImpUidByOrderId(orderid);

            if (impUid == null || impUid.isEmpty()) {
                response.put("success", false);
                response.put("message", "결제 정보를 찾을 수 없습니다.");
                return response;
            }

            String token = getToken();
            if (token == null) {
                response.put("success", false);
                response.put("message", "토큰을 가져오지 못했습니다.");
                return response;
            }

            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setBearerAuth(token);
            headers.setContentType(MediaType.APPLICATION_JSON);

            Map<String, String> body = new HashMap<>();
            body.put("imp_uid", impUid);
            body.put("reason", "사용자 요청에 의한 취소");

            HttpEntity<Map<String, String>> entity = new HttpEntity<>(body, headers);

            ResponseEntity<String> cancelResponse = restTemplate.postForEntity(
                    "https://api.iamport.kr/payments/cancel", entity, String.class);

            if (cancelResponse.getStatusCode() == HttpStatus.OK) {
                //cancelPointHistoryByOrderId(orderid);
            	cancelOrderAndUpdateCoupon(orderid);

                response.put("success", true);
                response.put("message", "결제가 성공적으로 취소되었습니다.");
            } else {
                response.put("success", false);
                response.put("message", "결제 취소에 실패했습니다.");
            }
        } catch (Exception e) {
            response.put("success", false);
            response.put("message", "결제 취소 처리 중 오류가 발생했습니다.");
            e.printStackTrace();
        }

        return response;
    }
    
    /* 주문 취소 및 쿠폰 사용 상태 업데이트 */
    public void cancelOrderAndUpdateCoupon(String orderid) {
        // 주문 상태 업데이트
        System.out.println("Cancelling orderid: " + orderid);
        orderDao.updateOrderStatus(orderid, "Cancelled");

        // 쿠폰 사용 상태를 'Not Used'로 업데이트
        OrderDTO order = orderDao.getOrderById(orderid);
        String couponid = order.getCouponid();
        if (couponid != null && !couponid.isEmpty()) {
            int result = orderDao.resetCouponUsage(couponid);
            System.out.println("Coupon usage update result (Not Used): " + result);
        }
    }
    
    /* 예약 ID로 포인트 기록 취소 *//*
    public void cancelPointHistoryByorderId(String orderid) {
        // orderid로 기존 포인트 적립 내역 가져오기
        PointHistoryDTO existingPointHistory = orderDao.getPointHistoryByorderId(orderid);

        if (existingPointHistory != null) {
            // 기존 포인트 적립 내역의 금액을 음수로 설정하고 결제 취소 내역 추가
            PointHistoryDTO cancelPointHistory = new PointHistoryDTO();
            cancelPointHistory.setUserid(existingPointHistory.getUserid());
            cancelPointHistory.setPointcategoryid(existingPointHistory.getPointcategoryid());
            cancelPointHistory.setPointtype("적립취소");
            cancelPointHistory.setReviewid(existingPointHistory.getReviewid());
            cancelPointHistory.setPointsource("결제취소");
            cancelPointHistory.setPointamount(-existingPointHistory.getPointamount());
            cancelPointHistory.setOrderid(orderid);

            // 로깅 추가
            System.out.println("Cancel Point History: " + cancelPointHistory);

            // 적립 취소 기록 삽입
            orderDao.insertPointHistory(cancelPointHistory);
            System.out.println("Point history cancellation inserted successfully.");
        } else {
            System.out.println("No existing point history found for orderid: " + orderid);
        }
    }*/
    
    
    private String getToken(Environment env) {
        try {
            // RestTemplate을 사용하여 API 호출
            RestTemplate restTemplate = new RestTemplate();
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);

            // 환경 변수에서 API 키와 시크릿 가져오기
            String apiKey = env.getProperty("iamport.api_key");
            String apiSecret = env.getProperty("iamport.api_secret");

            // API 호출 요청 데이터 준비
            Map<String, String> request = new HashMap<>();
            request.put("imp_key", apiKey);
            request.put("imp_secret", apiSecret);

            // 요청 데이터를 JSON 문자열로 변환
            String jsonRequest = new ObjectMapper().writeValueAsString(request);
            HttpEntity<String> entity = new HttpEntity<>(jsonRequest, headers);

            // API 호출
            ResponseEntity<String> response = restTemplate.postForEntity("https://api.iamport.kr/users/getToken", entity, String.class);

            if (response.getStatusCode() == HttpStatus.OK) {
                // 응답에서 액세스 토큰 추출
                JSONObject json = new JSONObject(response.getBody());
                if (!json.isNull("response")) {
                    return json.getJSONObject("response").getString("access_token");
                } else {
                    System.out.println("Failed to get token, response is null: " + json.getString("message"));
                }
            } else {
                System.out.println("Failed to get token, response: " + response.getBody());
            }
        } catch (Exception e) {
            e.printStackTrace();
        }

        return null;
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    /*
    @GetMapping("/cartPayment")
    public String cartPayment(@RequestParam("goodsid") String goodsid,
                              @RequestParam("size") String size,
                              @RequestParam("quantity") int quantity,
                              @RequestParam("price") int price,
                              @RequestParam("totalPrice") int totalPrice,
                              @RequestParam(value = "couponid", required = false) String couponid,
                              @RequestParam(value = "usedpoints", required = false, defaultValue = "0") int usedpoints,
                              HttpSession session, Model model) {
        String userid = (String) session.getAttribute("userID");
        if (userid == null) {
            return "redirect:/member/login";
        }

        GoodsDTO goods = goodsDao.detail(goodsid);
        if (goods == null) {
            model.addAttribute("error", "상품 정보를 찾을 수 없습니다.");
            return "error";
        }
        model.addAttribute("goods", goods);
        model.addAttribute("size", size);
        model.addAttribute("quantity", quantity);
        model.addAttribute("price", price);
        model.addAttribute("totalPrice", totalPrice);
        model.addAttribute("couponid", couponid);
        model.addAttribute("usedpoints", usedpoints);

        List<CouponDTO> couponList = orderDao.getCouponsByUserId(userid);
        model.addAttribute("couponList", couponList);

        int discountRate = 0;
        if (couponid != null && !couponid.isEmpty()) {
            try {
                discountRate = orderDao.getDiscountRateByCouponId(couponid);
            } catch (Exception e) {
                model.addAttribute("error", "유효하지 않은 쿠폰입니다.");
                return "error";
            }
        }
        model.addAttribute("discountRate", discountRate);

        MypageDTO mypageDto = mypageDao.getUserById(userid);
        if (mypageDto == null) {
            model.addAttribute("error", "사용자 정보를 찾을 수 없습니다.");
            return "error";
        }
        model.addAttribute("totalpoints", mypageDto.getTotalpoints());

        return "cart/cartPayment"; // 여기서 cart/cartPayment로 이동하도록 설정
    }
    */
}