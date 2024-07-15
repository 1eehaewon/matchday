<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>예매 확인</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/jquery@3.6.0/dist/jquery.min.js"></script>
    <script type="text/javascript" src="https://cdn.iamport.kr/js/iamport.payment-1.2.0.js"></script>
    <script src="https://t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    <script type="text/javascript">
        // 아임포트 관리자 콘솔에서 발급받은 가맹점 식별코드로 초기화
        IMP.init('imp05021463'); 
    </script>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f0f2f5;
            color: #333;
        }
        .container {
            max-width: 900px;
            margin-top: 50px;
            background-color: #fff;
            padding: 20px;
            border-radius: 10px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        h1, h2 {
            margin-top: 20px;
            margin-bottom: 20px;
            text-align: center;
        }
        .form-check-label, .form-label {
            font-weight: bold;
        }
        .form-check-input {
            margin-top: 7px;
        }
        .form-control[readonly] {
            background-color: #e9ecef;
        }
        .table th, .table td {
            vertical-align: middle;
        }
        .d-flex {
            margin-top: 20px;
        }
        #delivery-address {
            display: none;
            margin-top: 20px;
        }
        .cancellation-deadline {
            color: red;
            font-weight: bold;
        }
        .btn-primary, .btn-secondary {
            width: 100%;
        }
        .btn-group {
            margin-top: 20px;
        }
        .steps {
            text-align: center;
            margin-bottom: 20px;
        }
        .steps span {
            margin: 0 10px;
            font-size: 1.2rem;
        }
        .steps .active {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="steps">
        <span>1. 구역선택</span> -> 
        <span>2. 좌석선택</span> -> 
        <span class="active">3. 결제정보확인</span>
    </div>
    <div class="container">
        <h1>예매 확인</h1>
        <div class="row">
            <!-- 좌측 예약 정보 폼 -->
            <div class="col-md-6">
                <h2>티켓수령방법</h2>
                <form>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="pickup" value="receiving01" checked>
                        <label class="form-check-label" for="pickup">현장수령</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="shipping" value="receiving02">
                        <label class="form-check-label" for="shipping">배송 (3,200원)</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="mobile" value="receiving03">
                        <label class="form-check-label" for="mobile">모바일 티켓</label>
                    </div>
                </form>
                <div id="delivery-address">
                    <h2>배송지 주소</h2>
                    <form>
                        <div class="mb-3">
                            <label for="postcode" class="form-label">우편번호</label>
                            <input type="text" class="form-control" id="postcode" readonly>
                            <button type="button" class="btn btn-primary mt-2" id="find-postcode">우편번호 찾기</button>
                        </div>
                        <div class="mb-3">
                            <label for="address" class="form-label">주소</label>
                            <input type="text" class="form-control" id="address" readonly>
                        </div>
                        <div class="mb-3">
                            <label for="detailAddress" class="form-label">상세주소</label>
                            <input type="text" class="form-control" id="detailAddress">
                        </div>
                        <div class="mb-3">
                            <label for="extraAddress" class="form-label">참고항목</label>
                            <input type="text" class="form-control" id="extraAddress" readonly>
                        </div>
                    </form>
                </div>
                <h2>예매자 확인</h2>
                <form>
                    <div class="mb-3">
                        <label for="name" class="form-label">이름</label>
                        <input type="text" class="form-control" id="name" value="${userInfo.name}" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email" value="${userInfo.email}" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">연락처</label>
                        <input type="text" class="form-control" id="phone" value="${userInfo.number}" readonly>
                    </div>
                </form>
            </div>
            <!-- 우측 예약 정보 테이블 -->
            <div class="col-md-6">
                <h2>My예매정보</h2>
                <table class="table table-bordered">
                    <tr>
                        <th>일시</th>
                        <td id="match-date"><fmt:formatDate value="${match.matchdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    </tr>
                    <tr>
                        <th>선택좌석</th>
                        <td>
                            <c:forEach var="seat" items="${seats}">
                                <div>${seat}</div>
                            </c:forEach>
                        </td>
                    </tr>
                    <tr>
                        <th>티켓금액</th>
                        <td id="ticket-price">${totalPrice}원</td>
                    </tr>
                    <tr>
                        <th>수수료</th>
                        <td id="service-fee">2,000원</td>
                    </tr>
                    <tr>
                        <th>배송료</th>
                        <td id="delivery-fee">0원</td>
                    </tr>
                    <tr>
                        <th>합계금액</th>
                        <td id="subtotal-amount">0원</td>
                    </tr>
                    <tr>
                        <th>멤버십</th>
                        <td>
                            <c:if test="${!empty memberships}">
                                <select id="membership-select" class="form-select">
                                    <c:forEach var="membership" items="${memberships}">
                                        <option value="${membership.membershipid}" data-discount="2000" data-teamname="${membership.teamname}">
                                            ${membership.membershipname} (${membership.teamname})
                                        </option>
                                    </c:forEach>
                                </select>
                            </c:if>
                        </td>
                    </tr>
                    <tr>
                        <th>할인쿠폰</th>
                        <td>
                            <select id="coupon-select" class="form-select">
                                <option value="0" data-discount="0">적용 안함</option>
                                <c:forEach var="coupon" items="${coupons}">
                                    <option value="${coupon.couponid}" data-discount="${coupon.discountrate}">${coupon.couponname}</option>
                                </c:forEach>
                            </select>
                        </td>
                    </tr>
                    <tr>
                        <th>할인</th>
                        <td id="discount">0원</td>
                    </tr>
                    <tr>
                        <th>취소기간</th>
                        <td><span id="cancellation-deadline" class="cancellation-deadline"></span></td>
                    </tr>
                    <tr>
                        <th>취소수수료</th>
                        <td>티켓금액의 0~10%</td>
                    </tr>
                    <tr>
                        <th>총 결제금액</th>
                        <td id="total-amount">0원</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary me-2" id="prev-step">이전단계</button>
            <button type="button" class="btn btn-primary" id="pay-button">결제하기</button>
        </div>
    </div>
    <script>
    $(document).ready(function() {
        var totalPrice = parseInt("${totalPrice}".replace(/[^0-9]/g, ''), 10);
        var seats = "${seats}".split(",");

        function updateSubtotalAmount() {
            var serviceFee = parseInt($('#service-fee').text().replace(/[^0-9]/g, ''), 10);
            var deliveryFee = parseInt($('#delivery-fee').text().replace(/[^0-9]/g, ''), 10);
            var subtotalAmount = totalPrice + serviceFee + deliveryFee;
            $('#subtotal-amount').text(subtotalAmount.toLocaleString() + '원');
            return subtotalAmount;
        }

        function updateTotalAmount() {
            var subtotalAmount = updateSubtotalAmount();
            var discount = parseInt($('#discount').text().replace(/[^0-9]/g, ''), 10);
            var totalAmount = subtotalAmount - discount;
            $('#total-amount').text(totalAmount.toLocaleString() + '원');
            return totalAmount;
        }

        function updateDeliveryFee() {
            var deliveryOption = $('input[name="deliveryOption"]:checked').val();
            var deliveryFee = deliveryOption === 'receiving02' ? 3200 : 0;
            var serviceFee = deliveryOption === 'receiving01' ? 2000 : 0;

            $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
            $('#service-fee').text(serviceFee.toLocaleString() + '원');

            if (deliveryOption === 'receiving02') {
                $('#delivery-address').show();
            } else {
                $('#delivery-address').hide();
            }
            updateTotalAmount();
        }

        function updateDiscount() {
            var selectedCoupon = $('#coupon-select').find(':selected');
            var discountRate = selectedCoupon.data('discount') || 0;
            var selectedMembership = $('#membership-select').find(':selected');
            var membershipDiscount = selectedMembership.data('discount') || 0;
            var seatCount = seats.length;

            var subtotalAmount = updateSubtotalAmount();
            var discountAmount = Math.floor(subtotalAmount * (discountRate / 100));
            
            var membershipAmount = selectedMembership.val() ? seatCount * membershipDiscount : 0;
            var totalDiscount = discountAmount + membershipAmount;
            $('#discount').text(totalDiscount.toLocaleString() + '원');
            updateTotalAmount();
        }

        function updateCancellationDeadline() {
            var matchDateStr = $('#match-date').text().split(' ')[0];
            var matchDateParts = matchDateStr.split('-');
            var matchDate = new Date(matchDateParts[0], matchDateParts[1] - 1, matchDateParts[2]);
            if (!isNaN(matchDate)) {
                matchDate.setDate(matchDate.getDate() - 3);
                var year = matchDate.getFullYear();
                var month = ('0' + (matchDate.getMonth() + 1)).slice(-2);
                var day = ('0' + matchDate.getDate()).slice(-2);
                var dayName = ['일', '월', '화', '수', '목', '금', '토'][matchDate.getDay()];
                $('#cancellation-deadline').text(year + '년 ' + month + '월 ' + day + '일 (' + dayName + ') 12:00시 까지 취소가능');
            } else {
                $('#cancellation-deadline').text('날짜 오류');
            }
        }

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
                    $('#address').val(addr);
                    $('#detailAddress').focus();
                }
            }).open();
        });

        $('.delivery-option').change(function() {
            updateDeliveryFee();
        });

        $('#coupon-select').change(function() {
            updateDiscount();
        });

        $('#membership-select').change(function() {
            updateDiscount();
        });

        updateDeliveryFee();
        updateSubtotalAmount();
        updateDiscount();
        updateCancellationDeadline();

        $('#prev-step').click(function() {
            window.history.back();
        });

        $('#pay-button').click(function() {
            var totalAmount = updateTotalAmount();
            var couponId = $('#coupon-select').val();
            var membershipId = $('#membership-select').val();
            var couponName = $('#coupon-select').find(':selected').text();
            var membershipName = $('#membership-select').find(':selected').text();
            var serviceFee = $('#service-fee').text().replace(/[^0-9]/g, '');
            var deliveryFee = $('#delivery-fee').text().replace(/[^0-9]/g, '');
            var totalDiscount = $('#discount').text().replace(/[^0-9]/g, '');

            IMP.request_pay({
                pg: 'html5_inicis',
                pay_method: 'card',
                merchant_uid: 'merchant_' + new Date().getTime(),
                name: '티켓 결제',
                amount: totalAmount,
                buyer_email: $('#email').val(),
                buyer_name: $('#name').val(),
                buyer_tel: $('#phone').val(),
                m_redirect_url: 'http://yourdomain.com/complete'
            }, function(rsp) {
                if (rsp.success) {
                    var seatsStr = JSON.stringify(seats);
                    var formData = {
                        imp_uid: rsp.imp_uid,
                        merchant_uid: rsp.merchant_uid,
                        paid_amount: rsp.paid_amount,
                        matchid: '${match.matchid}',
                        totalPrice: totalPrice,
                        collectionmethodcode: $('input[name="deliveryOption"]:checked').val(),
                        recipientname: $('#name').val(),
                        shippingaddress: $('#address').val() + ' ' + $('#detailAddress').val(),
                        shippingrequest: $('#extraAddress').val(),
                        seats: seatsStr,
                        couponid: couponId,
                        membershipid: membershipId,
                        couponName: couponName,
                        membershipName: membershipName,
                        serviceFee: serviceFee,
                        deliveryFee: deliveryFee,
                        totalDiscount: totalDiscount,
                        totalPaymentAmount: totalAmount
                    };

                    $.ajax({
                        type: 'POST',
                        url: '/tickets/verifyPayment',
                        data: formData,
                        traditional: true,
                        success: function(data) {
                            if (data.success) {
                                window.opener.location.href = data.redirectUrl;
                                window.close();
                            } else {
                                alert('결제 검증에 실패했습니다.');
                            }
                        }
                    });
                } else {
                    alert('결제에 실패하였습니다.');
                }
            });
        });

        $('#cancel-button').click(function() {
            var impUid = prompt("취소할 결제의 imp_uid를 입력하세요:");
            if (impUid) {
                $.ajax({
                    url: '/tickets/cancelPayment',
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
    });
    </script>
</body>
</html>
