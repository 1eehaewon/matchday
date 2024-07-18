<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>

<!DOCTYPE html>
<html lang="ko">
<head>
	<meta charset="UTF-8">
	<title>구매하기</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript">
        IMP.init('imp05021463'); // 아임포트 관리자 콘솔에서 발급받은 가맹점 식별코드
    </script>
    <style>
    * {
	    margin: 0;
	    padding: 0;
	    box-sizing: border-box;
	}
	
	body {
	    font-family: Arial, sans-serif;
	    background-color: #f0f0f0;
	    padding: 20px;
	}
	
	.container {
	    max-width: 1000px;
	    margin: 0 auto;
	    background-color: #fff;
	    padding: 20px;
	    border-radius: 8px;
	    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
	}
	
	h1, h2 {
	    font-size: 24px;
	    margin-bottom: 20px;
	}
	
/* 주문 및 결제 라인 */
	.order_tit {
		border-bottom: 0.5px solid #000; /* 아래쪽 선 */
		margin-bottom: 30px;
	}
	
	.order_tit h2 {
		font-size: 30px;
		font-weight: bold;
		color: #333;
		margin-bottom: 10px;
	}
		
	.order_tit ol {
		list-style: none;
		display: flex;
		justify-content: right;
	}
	
	.order_tit ol li {
		display: flex;
		align-items: center;
		margin-right: 30px;
		font-size: 20px;
		color: #666;
	}
	
	.order_tit ol li.page_on span {
		font-weight: bold;
		color: #333;
	}
	
	.order_tit ol li img {
		margin-left: 5px;
		vertical-align: middle;
	}
/* 주문 및 결제 라인 end */

.text-center {
        text-align: center;
    }

    .productname-text,
    .size-text,
    .quantity-text,
    .price-text,
    .totalprice-text {
    	vertical-align: middle;
        font-size: 25px;
    }
    
	.order-section,
	.customer-section,
	.delivery-section,
	.discount-section {
	    border-bottom: 1px solid #ddd;
	    padding-top: 15px;
	    margin-top: 15px;
	}
	
	.order-details {
	    margin-bottom: 20px;
	}
	
	.quantity,
	.price,
	.discount,
	.total,
	.shipping {
	    margin-bottom: 10px;
	}
	
	.subtotal-amount {
	    text-align: right;
	    font-weight: bold;
	    font-size: 18px;
	    margin-bottom: 20px;
	}
	
	.total-amount {
	    text-align: right;
	    font-weight: bold;
	    font-size: 18px;
	    margin-bottom: 20px;
	}
	
	form {
	    margin-bottom: 20px;
	}
	
	form label {
	    display: block;
	    margin-bottom: 5px;
	}
	
	form input[type="text"],
	form input[type="email"],
	form input[type="tel"],
	form textarea,
	form input[type="radio"] {
	    width: 100%;
	    padding: 10px;
	    font-size: 16px;
	    border: 1px solid #ddd;
	    border-radius: 4px;
	    margin-bottom: 10px;
	}
	
	form input[type="radio"] {
	    margin-right: 10px;
	}
	
	.form-label {
		font-weight: bold;
	}
	.form-control[readonly] {
		background-color: #e9ecef;
	}
	
	.checkout-button {
	    text-align: center;
	}
	
	.checkout-button button {
	    padding: 10px 20px;
	    background-color: #4CAF50;
	    color: #fff;
	    border: none;
	    border-radius: 4px;
	    cursor: pointer;
	    font-size: 16px;
	}
	
	
	
	
	
	
	
	
	


    </style>
</head>
<body>
<div class="container">
	<form>
		<input type="hidden" name="userid" value="${sessionScope.userID}">
		<input type="hidden" name="orderid" id="orderid" value="">
		<input type="hidden" name="goodsid" id="goodsid" value="${param.goodsid}">
		<input type="hidden" name="orderstatus" id="orderstatus" value="주문완료">
		<input type="hidden" name="paymentmethodcode" id="paymentmethodcode" value="pay01">
		<input type="hidden" name="receiptmethodcode" id="receiptmethodcode" value="receiving02">
		<input type="hidden" name="quantity" value="${quantity}">
		<input type="hidden" name="price" value="${price}">
	</form>
	
	<div class="order_tit">
		<h1>주문 및 결제</h1>
		<ol>
			<li class="page_on"><span>01</span>장바구니<span><img src="https://cdn-pro-web-210-60.cdn-nhncommerce.com/difkorea4_godomall_com/data/skin/front/TOPSKIN/img/member/icon_join_step_off.png" alt="장바구니진행 중"></span></li>
			<li><span>02</span> 주문서작성/결제<span><img src="https://cdn-pro-web-210-60.cdn-nhncommerce.com/difkorea4_godomall_com/data/skin/front/TOPSKIN/img/member/icon_join_step_on.png" alt="주문서작성/결제대기"></span></li>
			<li><span>03</span> 주문완료</li>
		</ol>
	</div>
	
		<!-- 주문상세내역 -->
		<section class="order-section">
			<h2>주문상세내역</h2>
			<form>
				<div class="order-details">
					<!-- 장바구니 상품리스트 시작 -->
					<div class="row">
						<div class="col-sm-12">
							<table class="table table-hover">
								<thead class="table-active">
									<tr>
										<th class="text-center">상품 정보</th>
										<th class="text-center">사이즈</th>
										<th class="text-center">수량</th>
										<th class="text-center">가격</th>
										<th class="text-center">총 가격</th>
									</tr>
								</thead>
								<tbody class="text-center">
									<c:forEach items="${goodsList}" var="goods">
									    <c:if test="${goods.goodsid eq param.goodsid}">
									        <tr>
									            <td>
									                <div class="product-image">
									                    <c:if test="${not empty goods.filename}">
									                            <img src="${pageContext.request.contextPath}/storage/goods/${goods.filename}" alt="${goods.productname}" style="width: 100px; height: 100px; object-fit: cover;">
									                    </c:if>
									                </div>
									                <br>
									                <span class="productname-text">${goods.productname}</span>
									            </td>
									            <td class="size-text">${size}</td>
									            <td class="quantity-text">${quantity}</td>
									            <td class="price-text"><fmt:formatNumber value="${price}" pattern="#,###원" /></td>
									            <td class="totalprice-text"><fmt:formatNumber value="${totalPrice}" pattern="#,###원" /></td>
									        </tr>
									    </c:if>
									</c:forEach>
								</tbody>
							</table>
						</div> <!-- col end -->
					</div> <!-- row end -->
				</div> <!-- order-details end -->
			</form>
			<div class="subtotal-amount">
				<p id="subtotal-amount">총 결제 금액: <fmt:formatNumber value="${totalPrice}" pattern="#,###원" /></p>
			</div>
		</section>
		<!-- 주문상세내역 end -->

		<!-- 주문자 정보 -->
		<section class="customer-section">
			<h2>주문자 정보</h2>
			<form id="order-form">
				<div class="mb-3">
					<label for="name" class="form-label">이름</label>
					<input type="text" id="recipientname" name="recipientname" class="form-control" required>
				</div>
				<div class="mb-3">
					<label for="email" class="form-label">이메일</label>
					<input type="email" id="recipientemail" name="recipientemail" class="form-control" required>
				</div>
				<div class="mb-3">
					<label for="phone" class="form-label">전화번호</label>
					<!-- <input type="tel" id="recipientphone" name="recipientphone" class="form-control" required> -->
					<input type="text" id="recipientphone" name="recipientphone" class="form-control" required>
				</div>
			</form>
		</section>

		<!-- 배송 정보 -->
		<section class="delivery-section">
			<h2>배송 정보</h2>
			<form id="delivery-form">
				<div class="mb-3">
					<label for="postcode" class="form-label">우편번호</label>
					<input type="text" class="form-control" id="postcode" readonly>
					<button type="button" class="btn btn-primary mt-2" id="find-postcode">우편번호 찾기</button>
				</div>
				<div class="mb-3">
					<label for="shippingaddress" class="form-label">배송 주소</label>
					<input type="text" class="form-control" id="shippingaddress" name="shippingaddress" readonly>
				</div>
					<div class="mb-3">
					<label for="detailAddress" class="form-label">상세주소</label>
					<input type="text" class="form-control" id="detailAddress">
				</div>
				<div class="mb-3">
				<label for="shippingrequest">배송 시 요청 사항</label>
				<select id="shippingrequest" name="shippingrequest" class="form-select">
					<option value="배송 시 요청사항을 선택해주세요">배송 시 요청사항을 선택해주세요</option>
					<option value="부재 시 경비실에 맡겨주세요">부재 시 경비실에 맡겨주세요</option>
					<option value="부재 시 택배함에 넣어주세요">부재 시 택배함에 넣어주세요</option>
					<option value="부재 시 집 앞에 놔주세요">부재 시 집 앞에 놔주세요</option>
					<option value="배송 전 연락 바랍니다">배송 전 연락 바랍니다</option>
					<option value="파손의 위험이 있는 상품입니다. 배송 시 주의해 주세요">파손의 위험이 있는 상품입니다. 배송 시 주의해 주세요</option>
					<option value="빠른 배송 부탁 드립니다">빠른 배송 부탁 드립니다</option>
					<option value="">직접 입력</option>
				</select>
				<textarea name="shippingrequest" id="" onkeyup="" rows="5" maxlength="50" placeholder="최대 50까지 입력 가능합니다." style="display: none;"></textarea>
				</div>
			</form>
		</section> <!-- delivery-section end -->

		<!-- 할인 혜택 -->
		<section class="discount-section">
			<h2>할인 혜택</h2>
			<form id="discount-form">
				<!-- 쿠폰 선택 -->
				<label for="couponid" class="form-label">쿠폰 선택</label>
				<input type="hidden" id="discount" value="${coupon.discountrate}">
				<select id="couponid" name="couponid" class="form-select">
				    <option value="">쿠폰 선택</option>
				    <c:forEach items="${couponList}" var="coupon">
				        <option value="${coupon.couponid}" data-discount="${coupon.discountrate}">
				            ${coupon.couponname} ${coupon.discountrate}% (${coupon.startdate} ~ ${coupon.enddate})
				        </option>
				    </c:forEach>
				</select>     
				<br>
		        <!-- 포인트 정보 -->
		        <label for="point" id="usedpoints" class="form-label">보유 포인트 : ${totalpoints} point</label>
		        <label for="point" id="usedpoints" class="form-label">사용할 포인트 :
		        <input type="number" id="usedpoints" name="usedpoints" min="0" max="${totalpoints}" value="" placeholder="0 point" class="form-label">
		        </label>      
		        <button type="button">포인트 사용</button>
		        <button type="submit">포인트 사용</button>
	        </form>        
  		</section> <!-- discount-section end -->
  		
  		
		<div class="total-amount">
	        <br>
	        배송비 : <span id="delivery-fee">0</span> (100,000원 이상 구매 시 무료)
	        <br>
	        <!-- <p id="final-total-price">최종 결제 금액: 0</p>  -->
	        <!--<p id="finaltotalprice">최종 결제 금액: <fmt:formatNumber value="${totalPrice + shippingFee}" pattern="#,###원" /></p> -->
			<%-- 최종 결제 금액 : <input type="number" name="finalpaymentamount" id="total-amount" value="${totalPrice + shippingFee}" pattern="#,###원" readonly> --%>
			<!-- 최종 결제 금액 : <input type="number" name="finalpaymentamount" id="total-amount" value="" readonly> -->
			최종 결제 금액 : <span id="total-amount">0원</span>
			<!-- <input type="number" name="finalpaymentamount" id="total-amount" readonly> -->
		</div>
		
            
            
            

        <div class="checkout-button">
        	<!-- <button type="submit" id="pay-button">결제하기</button> -->
            <button type="button" id="pay-button">결제하기</button>
            <button type="button" class="btn btn-danger" onclick="closePopup()">결제취소</button>
        </div>

        
</div><!-- container end -->


</body>

<script>

$(document).ready(function() {

	generateOrderId(); // 주문서 페이지가 로드될 때 orderid 생성
	// 주문서 페이지 로드 시 실행되는 함수
	function generateOrderId() {
	    var prefix = 'order'; // order라는 prefix를 사용
	    var num;
	    var existingIds = []; // 기존 orderid 리스트 (실제 사용 데이터를 가져와야 함)

	    // 기존 orderid들을 배열에 추가 (실제로는 서버에서 기존 데이터를 가져와야 함)
	    // 이 예제에서는 sessionScope.userID로 이미 로그인한 사용자의 주문 목록을 가져온다고 가정
	    <c:forEach items="${orderList}" var="order">
	        existingIds.push('${order.orderid}');
	    </c:forEach>

	    // 중복되지 않는 orderid 생성
	    do {
	        num = generateRandomNumber(); // 랜덤 숫자 생성 함수 호출
	        var newId = prefix + num.toString().padStart(3, '0'); // 3자리 숫자로 포맷
	    } while (existingIds.includes(newId)); // 생성된 아이디가 기존 아이디들과 중복되는지 확인

	    // 생성된 orderid를 hidden input 필드에 설정
	    document.getElementById('orderid').value = newId;
	}

	// 랜덤 숫자 생성 함수
	function generateRandomNumber() {
	    return Math.floor(Math.random() * 999) + 1; // 1부터 999 사이의 랜덤 숫자 생성
	}
	
    /* function updateTotalAmount() {
        var subtotalAmount = updateSubtotalAmount();
        var deliveryFee = parseInt($('#delivery-fee').text().replace(/[^0-9]/g, ''), 10);
        var discount = parseInt($('#discount').text().replace(/[^0-9]/g, ''), 10);
        var totalAmount = subtotalAmount - discount;
        $('#total-amount').text(totalAmount.toLocaleString() + '원');
        return totalAmount;
    }

    function updateDeliveryFee() {
        var deliveryOption = $('input[name="deliveryOption"]:checked').val();
        var deliveryFee = deliveryOption === '#delivery-fee' ? 3500 : 0;

        $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');

        if (deliveryOption === '#delivery-fee') {
            $('#delivery-address').show();
        } else {
            $('#delivery-address').hide();
        }
        updateTotalAmount();
    }

    function updateDiscount() {
        var selectedCoupon = $('#coupon-select').find(':selected');
        var discountRate = selectedCoupon.data('discount') || 0;

        var subtotalAmount = updateSubtotalAmount();
        var discountAmount = Math.floor(subtotalAmount * (discountRate / 100));
        
        $('#discount').text(totalDiscount.toLocaleString() + '원');
        updateTotalAmount();
    } */
    
 // Update total amount considering discounts and delivery fee
    function updateTotalAmount() {
        var subtotalAmount = parseInt('${totalPrice}', 10);
        var deliveryFee = parseInt($('#delivery-fee').text().replace(/[^0-9]/g, ''), 10);
        var discount = parseInt($('#discount').text().replace(/[^0-9]/g, ''), 10);
        var points = parseInt($('#usedpoints').val() || '0', 10);
        var totalAmount = subtotalAmount + deliveryFee - discount - points;
        $('#total-amount').text(totalAmount.toLocaleString() + '원');
        return totalAmount;
    }

    function updateDeliveryFee() {
        var deliveryFee = 0; // 기본 배송비는 0원
        var subtotalAmount = parseInt('${totalPrice}', 10);
        
        // 총 결제 금액이 100,000원 미만일 때만 배송비 추가
        if (subtotalAmount < 100000) {
            deliveryFee = 3500;
        }

        $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
        updateTotalAmount();
    }

    function updateDiscount() {
        var selectedCoupon = $('#couponid').find(':selected');
        var discountRate = selectedCoupon.data('discount') || 0;
        var subtotalAmount = parseInt('${totalPrice}', 10);
        var discountAmount = Math.floor(subtotalAmount * (discountRate / 100));

        $('#discount').text(discountAmount.toLocaleString() + '원');
        updateTotalAmount();
    }

    $('#couponid').change(function() {
        updateDiscount();
    });

    $('#usedpoints').change(function() {
        updateTotalAmount();
    });

    updateDeliveryFee();
    updateTotalAmount();
    updateDiscount();

  //주소 찾기 API 호출 함수
    $('#find-postcode').click(function() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = ''; // 주소 변수
                var extraAddr = ''; // 참고항목 변수

                // 도로명 주소를 선택했을 경우
                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else { // 지번 주소를 선택했을 경우
                    addr = data.jibunAddress;
                }

                // 참고항목 설정
                if (data.userSelectedType === 'R') {
                    if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
                        extraAddr += data.bname;
                    }
                    if (data.buildingName !== '' && data.apartment === 'Y') {
                        extraAddr += (extraAddr !== '' ? ', ' + data.buildingName : data.buildingName);
                    }
                    if (extraAddr !== '') {
                        extraAddr = ' (' + extraAddr + ')';
                    }
                    $('#extraAddress').val(extraAddr);
                } else {
                    $('#extraAddress').val('');
                }

                $('#postcode').val(data.zonecode); // 우편번호 설정
                $('#shippingaddress').val(addr); // 주소 설정
                $('#detailAddress').focus(); // 상세주소 입력 필드로 포커스 이동
            }
        }).open();
    }); //주소 찾기 API 호출 함수 end

    /* $('.delivery-option').change(function() {
        updateDeliveryFee();
    });

    $('#coupon-select').change(function() {
        updateDiscount();
    });

    updateDeliveryFee();
    updateSubtotalAmount();
    updateDiscount();
    updateCancellationDeadline(); */

  	//결제 처리 함수
    $('#pay-button').click(function() {
        var totalAmount = updateTotalAmount(); // 최종 결제 금액 업데이트
       /*  var couponId = $('#coupon-select').val();
        var couponName = $('#coupon-select').find(':selected').text();
        var deliveryFee = $('#delivery-fee').text().replace(/[^0-9]/g, '');
        var totalDiscount = $('#discount').text().replace(/[^0-9]/g, ''); */
        var couponId = $('#couponid').val();
        var couponName = $('#couponid').find(':selected').text();
        var deliveryFee = $('#delivery-fee').text().replace(/[^0-9]/g, '');
        var totalDiscount = $('#discount').text().replace(/[^0-9]/g, '');
        var points = $('#usedpoints').val();
        
        IMP.request_pay({
            pg: 'html5_inicis',
            pay_method: 'card',
            merchant_uid: 'merchant_' + new Date().getTime(),
            name: '상품 주문 결제',
            amount: totalAmount,
            buyer_email: $('#recipientemail').val(),
            buyer_name: $('#recipientname').val(),
            buyer_tel: $('#recipientphone').val(),
            m_redirect_url: 'http://yourdomain.com/complete' // 성공 시 이동할 URL 설정
        }, function(rsp) {
            if (rsp.success) {
                var formData = {
                    imp_uid: rsp.imp_uid,
                    merchant_uid: rsp.merchant_uid,
                    paid_amount: rsp.paid_amount,
                    orderid: '${order.orderid}',
                    totalPrice: totalPrice,
                    recipientname: $('#recipientname').val(),
                    recipientemail: $('#recipientemail').val(),
                    recipientphone: $('#recipientphone').val(),
                    shippingaddress: $('#shippingaddress').val() + ' ' + $('#detailAddress').val(),
                    shippingrequest: $('#shippingrequest').val(),
                    couponid: couponId,
                    couponName: couponName,
                    deliveryFee: deliveryFee,
                    totalDiscount: totalDiscount,
                    totalPaymentAmount: totalAmount
                    //couponid: $('#couponid').val(),
                    //usedpoints: $('#usedpoints').val()
                };

                $.ajax({
                    type: 'POST',
                    url: '/order/payment',
                    data: formData,
                    traditional: true,
                    success: function(data) {
                        if (data.success) {
                            window.opener.location.href = data.redirectUrl;
                            window.close();
                         	// 결제 완료 후 화면 이동
                            //window.location.href = '/order/confirmation?orderid=' + data.orderid;
                        } else {
                            alert('결제 검증에 실패했습니다.');
                        }
                    }
                });
            } else {
                alert('결제에 실패하였습니다. 오류 내용 :' + rsp.error_msg);
            }
        });
    });
/*
    $('#cancel-button').click(function() {
        var impUid = prompt("취소할 결제의 imp_uid를 입력하세요:");
        if (impUid) {
            $.ajax({
                url: '/order/cancelPayment',
                type: 'DELETE',
                data: { imp_uid: impUid },
                success: function(response) {
                    if (response.success) {
                        alert("결제가 취소되었습니다.");
                    } else {
                        alert("결제 취소에 실패했습니다: " + response.message);
                    }
                },
                error: function(error) {
                    alert("결제 취소 요청 중 오류가 발생했습니다.");
                }
            });
        }
    });
*/
/*
    // WebSocket 연결 설정
    var socket = new SockJS('/ws');
    var stompClient = Stomp.over(socket);
    var userId = "${sessionScope.userID}";

    stompClient.connect({}, function(frame) {
        console.log('Connected: ' + frame);
        stompClient.subscribe('/topic/seatSelected', function(message) {
            var seatMessage = JSON.parse(message.body);
            if (seatMessage.userId !== userId && seatMessage.status === 'selected') {
                seats = seats.filter(function(seat) {
                    return seat !== seatMessage.seatId;
                });
                alert('다른 회원이 구매진행중인 좌석이 있습니다. 다시 선택해주세요.');
                window.location.href = '/tickets/seatmap?matchid=${param.matchid}&section=${param.section}&stadiumid=${param.stadiumid}';
            }
        });
    });
*/


});










//결제 취소 버튼 클릭 이벤트
function closePopup() {
	alert("결제가 취소되었습니다.");
    window.close();
}
</script>


</html>