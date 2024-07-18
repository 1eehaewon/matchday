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
	
	.checkout-button button:hover {
	    background-color: #45a049;
	}
	
	
	
	
	
	
	


    </style>
</head>
<body>
<div class="container">
	<form id="Orderfrm" name="Orderfrm" method="post" action="/order/insert">
		<input type="hidden" name="userid" value="${sessionScope.userID}">
		<input type="hidden" name="orderid" id="orderid" value="">
		<input type="hidden" name="goodsid" id="goodsid" value="${param.goodsid}">
		<input type="hidden" name="orderstatus" id="orderstatus" value="주문완료">
		<input type="hidden" name="paymentmethodcode" id="paymentmethodcode" value="pay01">
		<input type="hidden" name="receiptmethodcode" id="receiptmethodcode" value="receiving02">
		<input type="hidden" name="quantity" value="${quantity}">
		<input type="hidden" name="price" value="${price}">
				
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
			<div class="total-amount">
				<p>총 결제 금액: <fmt:formatNumber value="${totalPrice}" pattern="#,###원" /></p>
			</div>
		</section>
		<!-- 주문상세내역 end -->

		<!-- 주문자 정보 -->
		<section class="customer-section">
			<h2>주문자 정보</h2>

				<label for="name">이름</label>
				<input type="text" id="recipientname" name="recipientname" class="form-control" required>
				<label for="email">이메일</label>
				<input type="email" id="recipientemail" name="recipientemail" class="form-control" required>
				<label for="phone">전화번호</label>
				<input type="tel" id="recipientphone" name="recipientphone" class="form-control" required>

		</section>

		<!-- 배송 정보 -->
		<section class="delivery-section">
			<h2>배송 정보</h2>
				<label for="postcode" class="form-label">우편번호</label>
				<input type="text" class="form-control" id="postcode" readonly>
				<button type="button" class="btn btn-primary mt-2" id="find-postcode">우편번호 찾기</button>
				<label for="shippingaddress" class="form-label">배송 주소</label>
				<input type="text" class="form-control" id="shippingaddress" name="shippingaddress" readonly>
				<label for="detailAddress" class="form-label">상세주소</label>
				<input type="text" class="form-control" id="detailAddress" required>
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
				<textarea name="" id="" onkeyup="" rows="5" maxlength="50" placeholder="최대 50까지 입력 가능합니다." style="display: none;"></textarea>
		</section> <!-- delivery-section end -->

		<!-- 할인 혜택 -->
		<section class="discount-section">
		<h2>할인 혜택</h2>
		
		<!-- 쿠폰 선택 -->
		<label for="couponid">쿠폰 선택</label>
		<select id="couponid" name="couponid" class="form-select" onchange="updateTotalAmount()">
		    <option value="">쿠폰 선택</option>
		    <c:forEach items="${couponList}" var="coupon">
		        <option value="${coupon.couponid}" data-discount="${coupon.discountrate}">
		            ${coupon.couponname} ${coupon.discountrate}% (${coupon.startdate} ~ ${coupon.enddate})
		        </option>
		    </c:forEach>
		</select>     
		<br>
        <!-- 포인트 정보 -->
	        <label for="point" id="usedpoints">보유 포인트 : ${totalpoints} point</label>
	        사용할 포인트
	        <input type="number" id="usedpoints" name="usedpoints" min="0" max="${totalpoints}" value="0" class="form-control" oninput="updateTotalAmount()">
        <button type="button" onclick="usePoints()">포인트 사용</button>
        <button type="submit">포인트 사용</button>          
  		</section> <!-- discount-section end -->
		<div class="total-amount">
		        <br>
		        배송비 : <span id="shipping-fee">3500</span>원 (100,000원 이상 구매 시 무료)
		        <br>
		        <!-- <p id="final-total-price">최종 결제 금액: 0</p>  -->
		        <!--<p id="finaltotalprice">최종 결제 금액: <fmt:formatNumber value="${totalPrice + shippingFee}" pattern="#,###원" /></p> -->
				최종 결제 금액 : <input type="number" name="finalpaymentamount" id="finaltotalprice" value="${totalPrice + shippingFee}" pattern="#,###원" readonly>
		</div>
		
            
            
            

        <div class="checkout-button">
        <button type="submit" id="pay-button">결제하기</button> <!-- 이니시스,인서트 됨 -->
            <button type="button" id="pay-button">결제하기</button>
            <button type="button" onclick="closePopup()">결제취소</button>
        </div>
 	</form>
        
</div><!-- container end -->


</body>

<script>

//페이지 로드될 때 실행되는 함수
document.addEventListener('DOMContentLoaded', function() {
    generateOrderId(); // 주문서 페이지가 로드될 때 orderid 생성
    
 	// 초기 총 결제 금액 업데이트
    document.addEventListener('DOMContentLoaded', updateTotalAmount);
    
 	// 쿠폰 선택 이벤트
    document.getElementById('couponid').addEventListener('change', updateTotalAmount);

    // 포인트 입력 이벤트
    //document.getElementById('usedpoints').addEventListener('input', updateTotalAmount);

    // 결제 버튼 클릭 이벤트
    document.getElementById('pay-button').addEventListener('click', function(event) {
        event.preventDefault(); // 기본 제출 동작 방지
        //processPayment();
    });

    // 우편번호 찾기 이벤트
    //document.getElementById('find-postcode').addEventListener('click', findPostcode);

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

//포인트 사용 버튼 클릭 시 호출되는 함수
function usePoints() {
    var usedPoints = parseFloat(document.getElementById('usedpoints').value) || 0; // 입력된 포인트
    var maxPoints = parseFloat(document.getElementById('usedpoints').getAttribute('max')); // 최대 사용 가능 포인트

    var finalTotalPrice = parseFloat(document.getElementById('finaltotalprice').innerText.replace(/[^0-9.-]+/g,"")); // 최종 결제 금액

    if (usedPoints < 0 || isNaN(usedPoints)) {
        alert('잘못된 포인트 입력입니다.');
        document.getElementById('usedpoints').value = 0;
        return;
    }

    if (usedPoints > maxPoints) {
        alert('최대 사용 가능 포인트를 초과하였습니다.');
        document.getElementById('usedpoints').value = maxPoints; // 최대 사용 가능 포인트로 설정
        usedPoints = maxPoints;
    }

    if (usedPoints > finalTotalPrice) {
        alert('최종 결제 금액을 초과하여 포인트를 사용할 수 없습니다.');
        document.getElementById('usedpoints').value = finalTotalPrice; // 최종 결제 금액으로 설정
        usedPoints = finalTotalPrice;
    }

    updateTotalAmount(); // 총 결제 금액 업데이트
}

//최종 결제 금액 업데이트 함수
function updateTotalAmount() {
    var totalPrice = parseFloat(${totalPrice}); // 상품 총 금액
    var finalTotalPrice = totalPrice;

    // 쿠폰 할인 적용
    var couponSelect = document.getElementById('couponid');
    var couponDiscount = 0;
    if (couponSelect.value) {
        couponDiscount = parseFloat(couponSelect.options[couponSelect.selectedIndex].getAttribute('data-discount')) || 0;
    }
    finalTotalPrice *= (1 - couponDiscount / 100);

    // 사용 포인트 적용
    var usedPoints = parseFloat(document.getElementById('usedpoints').value) || 0;
 	// 최종 결제 금액 보다 사용 포인트가 더 클 경우, 최종 결제 금액으로 설정
    if (usedPoints > finalTotalPrice) {
        document.getElementById('usedpoints').value = finalTotalPrice;
        usedPoints = finalTotalPrice;
    }

    finalTotalPrice -= usedPoints;

    // 배송비 적용
    var shippingFee = (finalTotalPrice >= 100000) ? 0 : 3500;
    finalTotalPrice += shippingFee;

    // 배송비 업데이트
    document.getElementById('shipping-fee').innerText = shippingFee.toLocaleString(); // 배송비에 천 단위 구분자 적용

    // 최종 결제 금액 업데이트
    //document.getElementById('finaltotalprice').innerText = '최종 결제 금액: ' + finalTotalPrice.toLocaleString() + '원';

 	// 최종 결제 금액 업데이트
    var formattedFinalTotalPrice = finalTotalPrice.toLocaleString() + '원'; // 천 단위 구분자와 원 추가
    document.getElementById('finaltotalprice').innerText = '최종 결제 금액: ' + formattedFinalTotalPrice;
}


//결제 처리 함수
$('#pay-button').click(function() {
	// 최종 결제 금액 업데이트
    updateTotalAmount();

    var finalTotalPrice = parseFloat(document.getElementById('finaltotalprice').innerText.replace(/[^0-9.-]+/g,""));

    /*var couponId = $('#coupon-select').val(); // 쿠폰 ID 가져오기 */

    IMP.request_pay({
        pg: 'html5_inicis',
        pay_method: 'card',
        merchant_uid: 'merchant_' + new Date().getTime(),
        name: '상품 주문 결제',
        amount: finalTotalPrice, 
        buyer_email: $('#recipientemail').val(),
        buyer_name: $('#recipientname').val(),
        //buyer_tel: $('#recipientphone').val(),
        buyer_tel: '010-4921-7450',
        m_redirect_url: 'http://yourdomain.com/complete' // 성공 시 이동할 URL 설정
    }, function(rsp) {
        if (rsp.success) { 
        	// 결제 성공 시 처리
            var formData = {
                imp_uid: rsp.imp_uid,
                merchant_uid: rsp.merchant_uid,
                paid_amount: rsp.paid_amount,
                orderid: '${order.orderid}',
                //orderid: document.getElementById('orderid').value, // 주문 번호
                finalpaymentamount: ${'finalpaymentamount'}.val(),
                //finalpaymentamount: finalTotalPrice, // 최종 결제 금액
                recipientname: $('#recipientname').val(),
                recipientemail: $('#recipientemail').val(),
                recipientphone: $('#recipientphone').val(),
                shippingaddress: $('#shippingaddress').val() + ' ' + $('#detailAddress').val(),
                shippingrequest: $('#shippingrequest').val(),
                couponid: $('#couponid').val(),
                usedpoints: $('#usedpoints').val()
            };
         	// AJAX를 사용한 서버로의 결제 데이터 전송
            $.ajax({
            	//type: 'GET',
                type: 'POST',
                url: '/order/payment',
                contentType: 'application/json',
                //data: JSON.stringify(formData),
                data: formData,
                traditional: true,
                success: function(data) {
                    if (data.success) {
                    	// 결제 완료 후 화면 이동
                        window.location.href = '/order/confirmation?orderid=' + data.orderid;
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

/* $('#cancel-button').click(function() {
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
}); */










	// 결제 취소 버튼 클릭 이벤트
	function closePopup() {
		alert("결제가 취소되었습니다.");
	    window.close();
	}
});
</script>


</html>