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
	<input name="userid" value="${sessionScope.userID}">
						<input name="orderid" id="orderid" value="">
						<input name="goodsid" id="goodsid" value="${param.goodsid}">
						<input name="orderstatus" id="orderstatus" value="f">
						<input name="finalpaymentamount" id="finalpaymentamount" value="5">
						<input name="recipientname" id="recipientname" value="d">
						<input name="paymentmethodcode" id="paymentmethodcode" value="pay01">
						<input name="price" id="price" value="1">
						<input name="quantity" id="quantity" value="1">
						<input name="receiptmethodcode" id="receiptmethodcode" value="d">

						
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
										<th>상품 정보</th>
										<th>사이즈</th>
										<th>수량</th>
										<th>가격</th>
										<th>총 가격</th>
									</tr>
								</thead>
								<tbody style="text-align: center;">
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
                <span>${goods.productname}</span>
            </td>
            <td>${goods.size}</td>
            <td>
                <button type="button" onclick="decrementQuantity(this)" class="수량-button">-</button> 
                <input type="text" class="quantity-input" value="1" readonly>
                <button type="button" onclick="incrementQuantity(this)" class="수량-button">+</button>
            </td>
            <td><fmt:formatNumber value="1" pattern="#,###원" /></td>
            <td><fmt:formatNumber value="1" pattern="#,###원" /></td>
        </tr>
    </c:if>
	</c:forEach>
								</tbody>
							</table>
						</div> <!-- col end -->
					</div> <!-- row end -->

			</div> <!-- order-details end -->
			<div class="total-amount">
				<p>총 결제 금액: 102,000원</p>
			</div>
		</section>
		<!-- 주문상세내역 end -->

		<!-- 주문자 정보 -->
		<section class="customer-section">
			<h2>주문자 정보</h2>

				<label for="name">이름</label>
				<input type="text" id="recipientname" name="recipientname" class="form-control" required>
				<label for="email">이메일</label>
				<input type="email" id="email" name="email" class="form-control" required>
				<label for="phone">전화번호</label>
				<input type="tel" id="phone" name="phone" class="form-control" required>

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
				<input type="text" class="form-control" id="detailAddress">
				<label for="notes">배송 시 요청 사항</label>
				<select>
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

		</section>


		<!-- 할인 혜택 및 결제 정보 -->
<div class="discount-section">
    <h2>할인 혜택 및 결제 정보</h2>

        <label for="coupon">쿠폰 선택</label>
        <select id="couponid" name="couponid">
            <option value="7515f751-ca15-4c8e-96dd-83ad9f16d8c7">쿠폰 1</option>
            <option value="coupon2">쿠폰 2</option>
            <option value="coupon3">쿠폰 3</option>
        </select>
        <br>
        <label for="point">보유 포인트 사용</label>
        <input type="number" id="usedpoints" name="usedpoints" min="0" value="0">
        point

    <!-- 총 결제 금액 -->
    <div class="total-amount">
        <p id="finalpaymentamount">총 결제 금액: 102,000원</p> <!-- 예시 금액 대신, 실제로 계산된 금액을 출력할 수 있도록 하세요. -->
    </div>
</div>







		
            
            
            

        <div class="checkout-button">
            <button type="submit">결제하기</button>
            <button type="button" onclick="closePopup()">결제취소</button>
        </div>
    </div>

</form>
</body>

<script>

//페이지 로드될 때 실행되는 함수
document.addEventListener('DOMContentLoaded', function() {
    generateOrderId(); // 주문서 페이지가 로드될 때 orderid 생성
});

// orderid 생성 함수
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



	// 결제 취소 버튼 클릭 이벤트
	function closePopup() {
		alert("결제가 취소되었습니다.");
	    window.close();
	}

</script>


</html>