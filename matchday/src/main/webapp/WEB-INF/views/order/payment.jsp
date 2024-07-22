<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

        .order_tit {
            border-bottom: 0.5px solid #000;
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
    <!-- 숨겨진 필드로 goodsid 추가 -->
    <form id="payment-form">
        <input type="hidden" name="userid" value="${sessionScope.userID}">
        <input type="hidden" name="orderid" id="orderid" value="${order.orderid}">
        <input type="hidden" name="goodsid" id="goodsid" value="${goods.goodsid}">
        <input type="hidden" name="orderstatus" id="orderstatus" value="주문완료">
        <input type="hidden" name="paymentmethodcode" id="paymentmethodcode" value="pay01">
        <input type="hidden" name="receiptmethodcode" id="receiptmethodcode" value="receiving02">
        <input type="hidden" name="quantity" id="quantity" value="${quantity}">
        <input type="hidden" name="price" id="price" value="${price}">
        <input type="hidden" name="deliveryfee" id="deliveryfee" value="${deliveryfee}">
        <input type="hidden" name="finalpaymentamount" id="finalpaymentamount" value="${totalPrice - discountprice - points}">
        <input type="hidden" name="discountprice" id="discountprice" value="${discountprice}">
        <input type="hidden" name="usedpoints" id="usedpoints" value="${points}">
        <input type="hidden" name="totalPrice" id="total-price" value="${totalPrice}">
        <input type="hidden" name="size" id="size" value="${size}"> <!-- 사이즈 필드 추가 -->
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
	                            <td class="quantity-text">${quantity}</td> <!-- 수량 값 표시 -->
	                            <td class="price-text"><fmt:formatNumber value="${price}" pattern="#,###원" /></td>
	                            <td class="totalprice-text"><fmt:formatNumber value="${totalPrice}" pattern="#,###원" /></td>
	                        </tr>
	                        </tbody>
	                    </table>
	                </div>
	            </div>
	        </div>
	    </form>
	</section>
    <!-- 주문상세내역 end -->

    <!-- 주문자 정보 -->
    <section class="customer-section">
        <h2>주문자 정보</h2>
        <form id="order-form">
            <div class="mb-3">
                <label for="recipientname" class="form-label">이름</label>
                <input type="text" id="recipientname" name="recipientname" class="form-control" value="${order.recipientname}" required>
            </div>
            <div class="mb-3">
                <label for="recipientemail" class="form-label">이메일</label>
                <input type="email" id="recipientemail" name="recipientemail" class="form-control" value="${order.recipientemail}" required>
            </div>
            <div class="mb-3">
                <label for="recipientphone" class="form-label">전화번호</label>
                <input type="text" id="recipientphone" name="recipientphone" class="form-control" value="${order.recipientphone}" required>
            </div>
        </form>
    </section>

    <!-- 배송 정보 -->
    <section class="delivery-section">
        <h2>배송 정보</h2>
        <form id="delivery-form">
            <div class="mb-3">
                <label for="postcode" class="form-label">우편번호</label>
                <input type="text" class="form-control" id="postcode" value="${order.shippingaddress}" readonly>
                <button type="button" class="btn btn-primary mt-2" id="find-postcode">우편번호 찾기</button>
            </div>
            <div class="mb-3">
                <label for="shippingaddress" class="form-label">배송 주소</label>
                <input type="text" class="form-control" id="shippingaddress" name="shippingaddress" value="${order.shippingaddress}" readonly>
            </div>
            <div class="mb-3">
                <label for="detailAddress" class="form-label">상세주소</label>
                <input type="text" class="form-control" id="detailAddress">
            </div>
            <div class="mb-3">
                <label for="shippingrequest">배송 시 요청 사항</label>
                <select id="shippingrequest" name="shippingrequest" class="form-select">
                    <option value="배송 시 요청사항을 선택해주세요.">배송 시 요청사항을 선택해주세요.</option>
                    <option value="부재 시 경비실에 맡겨주세요.">부재 시 경비실에 맡겨주세요.</option>
                    <option value="부재 시 택배함에 넣어주세요.">부재 시 택배함에 넣어주세요.</option>
                    <option value="부재 시 집 앞에 놔주세요.">부재 시 집 앞에 놔주세요.</option>
                    <option value="배송 전 연락 바랍니다.">배송 전 연락 바랍니다.</option>
                    <option value="파손의 위험이 있는 상품입니다. 배송 시 주의해 주세요.">파손의 위험이 있는 상품입니다. 배송 시 주의해 주세요.</option>
                    <option value="빠른 배송 부탁 드립니다">빠른 배송 부탁 드립니다.</option>
                    <option value="">직접 입력</option>
                </select>
                <textarea name="shippingrequest" id="shippingrequestText" onkeyup="" rows="5" maxlength="50" placeholder="최대 50까지 입력 가능합니다." style="display: none;"></textarea>
            </div>
        </form>
    </section>

    <!-- 할인 혜택 -->
    <section class="discount-section">
        <h2>할인 혜택</h2>
        <form id="discount-form">
            <label for="couponid" class="form-label">쿠폰 선택</label>
            <select id="couponid" name="couponid" class="form-select">
                <option value="">쿠폰 선택</option>
                <c:forEach items="${couponList}" var="coupon">
                    <option value="${coupon.couponid}" data-discount="${coupon.discountrate}">
                        ${coupon.couponname} ${coupon.discountrate}% (${coupon.startdate} ~ ${coupon.enddate})
                    </option>
                </c:forEach>
            </select>
            <br>
            <label for="point" id="usedpoints" class="form-label">보유 포인트 : ${totalpoints} point</label>
            <label for="point" id="usedpointsLabel" class="form-label">사용할 포인트 :
                <input type="number" id="pointsToUse" name="usedpoints" min="0" max="${totalpoints}" value="" placeholder="0 point" class="form-label">
            </label>
            <button type="button" id="usePointsButton" class="btn btn-info">포인트 사용</button>
        </form>
    </section>

    <div class="total-amount">
        <br>
        배송비 : <span id="delivery-fee">${deliveryfee}</span> (100,000원 이상 구매 시 무료)
        <br>
        최종 결제 금액 : <span id="final-amount">${finalpaymentamount}원</span>
    </div>

    <div class="checkout-button">
        <button type="button" id="pay-button">결제하기</button>
        <button type="button" class="btn btn-danger" onclick="closePopup()">결제취소</button>
    </div>
</div>

<script>
$(document).ready(function() {
    function updateTotalAmount() {
        var totalPrice = parseInt($('#total-price').val(), 10) || 0;
        var deliveryFee = parseInt($('#delivery-fee').text().replace(/[^0-9]/g, ''), 10) || 0;
        var discountRate = parseInt($('#couponid').find(':selected').data('discount'), 10) || 0;
        var points = parseInt($('#pointsToUse').val(), 10) || 0;

        var discountprice = Math.floor(totalPrice * (discountRate / 100)); //쿠폰 할인 금액
        var finalPaymentAmount = totalPrice - discountprice + deliveryFee - points;

        $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
        $('#final-amount').text(finalPaymentAmount.toLocaleString() + '원');
        $('#finalpaymentamount').val(finalPaymentAmount);
        $('#usedpoints').val(points);

        return totalPrice; 
    }

    $('#couponid').change(function() {
        updateTotalAmount();
    });

    $('#usePointsButton').click(function() {
        updateTotalAmount();
    });

    updateTotalAmount();

    $('#find-postcode').click(function() {
        new daum.Postcode({
            oncomplete: function(data) {
                var addr = '';
                var extraAddr = '';

                if (data.userSelectedType === 'R') {
                    addr = data.roadAddress;
                } else {
                    addr = data.jibunAddress;
                }

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

                $('#postcode').val(data.zonecode);
                $('#shippingaddress').val(addr);
                $('#detailAddress').focus();
            }
        }).open();
    });

    $('#pay-button').click(function() {
        var totalPrice = updateTotalAmount();
        var finalPaymentAmount = parseInt($('#finalpaymentamount').val(), 10) || 0;
        var couponId = $('#couponid').val();
        var couponName = $('#couponid').find(':selected').text();
        var discountRate = parseInt($('#couponid').find(':selected').data('discount'), 10) || 0;
        var discountprice = Math.floor(totalPrice * (discountRate / 100)); //쿠폰 할인 금액
        var deliveryFee = $('#delivery-fee').text().replace(/[^0-9]/g, '');
        var points = $('#pointsToUse').val();
        var quantity = parseInt($('#quantity').val(), 10) || 1; // 수량 값 가져오기
        var size = $('#size').val(); // 사이즈 값 가져오기

        IMP.request_pay({
            pg: 'html5_inicis',
            pay_method: 'card',
            merchant_uid: 'merchant_' + new Date().getTime(),
            name: '상품 주문 결제',
            amount: finalPaymentAmount,
            buyer_email: $('#recipientemail').val(),
            buyer_name: $('#recipientname').val(),
            buyer_tel: $('#recipientphone').val(),
            m_redirect_url: 'http://yourdomain.com/complete'
        }, function(rsp) {
            if (rsp.success) {
                var formData = {
                    imp_uid: rsp.imp_uid,
                    merchant_uid: rsp.merchant_uid,
                    paid_amount: rsp.paid_amount,
                    recipientname: $('#recipientname').val(),
                    recipientemail: $('#recipientemail').val(),
                    recipientphone: $('#recipientphone').val(),
                    shippingaddress: $('#shippingaddress').val() + ' ' + $('#detailAddress').val(),
                    shippingrequest: $('#shippingrequest').val(),
                    paymentmethodcode: $('#paymentmethodcode').val(),
                    couponid: couponId,
                    couponName: couponName,
                    deliveryFee: deliveryFee,
                    totalPaymentAmount: finalPaymentAmount,
                    usedpoints: points,
                    finalpaymentamount: finalPaymentAmount,
                    discountprice : discountprice,
                    goodsid: $('#goodsid').val(),
                    totalPrice: totalPrice,
                    price: parseInt($('#price').val(), 10),
                    quantity: quantity, // 수량 값 추가
                    size: size // 사이즈 값 추가
                };

                console.log('formData:', formData); // 로그 메시지 추가

                $.ajax({
                    type: 'POST',
                    url: '/order/verifyPayment',
                    data: formData,
                    traditional: true,
                    success: function(data) {
                        if (data.success) {
                        	alert('결제가 완료되었습니다.');
                            window.opener.location.href = data.redirectUrl; // 팝업 호출 base page url 이동
                            window.close();									// 현재 팝업 close
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

    function closePopup() {
        alert("결제가 취소되었습니다.");
        window.close();
    }
});
</script>
</body>
</html>