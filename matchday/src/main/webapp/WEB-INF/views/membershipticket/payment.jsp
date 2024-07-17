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
        .container {
            max-width: 900px;
        }
        h1, h2 {
            margin-top: 20px;
            margin-bottom: 20px;
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
        .cancellation-deadline, .cancellation-fee {
            color: red; /* 빨간색 텍스트 */
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1>멤버쉽 구매🎫</h1>
        <div class="row">
            <!-- 좌측 예약 정보 폼 -->
            <div class="col-md-6">
                <h2>멤버쉽 수령방법</h2>
                <form>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="pickup" value="receiving01" checked>
                        <label class="form-check-label" for="pickup">현장수령</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="shipping" value="receiving02">
                        <label class="form-check-label" for="shipping">배송 (0원)</label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="mobile" value="receiving03">
                        <label class="form-check-label" for="mobile">모바일 멤버쉽</label>
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
                <h2>My예매정보😀</h2>
                <table class="table table-bordered">
                    <tr>
                        <th>일시</th>
                        <td>상시</td>
                    </tr>
                    <tr>
                        <th>선택 멤버쉽</th>
                        <td>${membershipInfo.membershipname}</td>
                    </tr>
                    <tr>
                        <th>멤버쉽 금액</th>
                        <td id="ticket-price"><fmt:formatNumber value="${membershipInfo.price}" pattern="#,###"/>원</td>
                    </tr>
                    <tr>
                        <th>수수료</th>
                        <td id="service-fee">0원</td>
                    </tr>
                    <tr>
                        <th>배송료</th>
                        <td id="delivery-fee">0원</td>
                    </tr>
                    <tr>
                        <th>합계금액</th>
                        <td id="subtotal-amount">원</td>
                    </tr>
                    <tr>
                        <th>취소기간</th>
                        <td class="cancellation-deadline">금일 23:59 까지</td>
                    </tr>
                    <tr>
                        <th>취소수수료</th>
                        <td class="cancellation-fee">없음</td>
                    </tr>
                    <tr>
                        <th>총 결제금액</th>
                        <td id="total-amount">0원</td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-primary" id="pay-button">결제하기</button>
        </div>
    </div>
    <script>
$(document).ready(function() {
    // 아임포트 관리자 콘솔에서 발급받은 가맹점 식별코드로 초기화
    IMP.init('imp05021463'); 

    // 멤버쉽 금액을 불러오기
    var membershipPrice = parseInt("${membershipInfo.price}".replace(/[^0-9]/g, ''), 10);

    // Subtotal amount를 업데이트하는 함수
    function updateSubtotalAmount() {
        var serviceFee = parseInt($('#service-fee').text().replace(/[^0-9]/g, ''), 10) || 0;
        var deliveryFee = parseInt($('#delivery-fee').text().replace(/[^0-9]/g, ''), 10) || 0;
        var subtotalAmount = membershipPrice + serviceFee + deliveryFee;
        $('#subtotal-amount').text(subtotalAmount.toLocaleString() + '원');
        return subtotalAmount;
    }

    // Total amount를 업데이트하는 함수
    function updateTotalAmount() {
        var subtotalAmount = updateSubtotalAmount();
        var discount = parseInt($('#discount').text().replace(/[^0-9]/g, ''), 10) || 0;
        var totalAmount = subtotalAmount - discount;
        $('#total-amount').text(totalAmount.toLocaleString() + '원');
        return totalAmount;
    }

    // Delivery fee를 업데이트하는 함수
    function updateDeliveryFee() {
        var deliveryOption = $('input[name="deliveryOption"]:checked').val();
        var deliveryFee = 0;
        var serviceFee = 0;

        if (deliveryOption === 'receiving02') {
            deliveryFee = 100;
        } else if (deliveryOption === 'receiving01') {
            serviceFee = 100;
        }

        $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
        $('#service-fee').text(serviceFee.toLocaleString() + '원');

        if (deliveryOption === 'receiving02') {
            $('#delivery-address').show();
        } else {
            $('#delivery-address').hide();
        }
        updateTotalAmount();
    }

    // 초기 값 설정
    updateDeliveryFee();
    updateSubtotalAmount();
    updateTotalAmount();

    // 배송 옵션 변경 시 요금 업데이트
    $('.delivery-option').change(function() {
        updateDeliveryFee();
    });

    // 결제 버튼 클릭 시 결제 요청 및 예약 리스트 페이지로 이동
    $('#pay-button').click(function() {
        var totalAmount = updateTotalAmount();
        var couponId = $('#coupon-select').val(); // 쿠폰 ID 가져오기

        IMP.request_pay({
            pg: 'html5_inicis',
            pay_method: 'card',
            merchant_uid: 'merchant_' + new Date().getTime(),
            name: '멤버쉽 결제',
            amount: totalAmount,
            buyer_email: $('#email').val(),
            buyer_name: $('#name').val(),
            buyer_tel: $('#phone').val(),
            m_redirect_url: 'http://yourdomain.com/complete'
        }, function(rsp) {
            if (rsp.success) {
                var formData = {
                    imp_uid: rsp.imp_uid,
                    merchant_uid: rsp.merchant_uid,
                    paid_amount: rsp.paid_amount,
                    membershipID: '${membershipInfo.membershipid}',
                    totalPrice: totalAmount,
                    collectionmethodcode: $('input[name="deliveryOption"]:checked').val(),
                    recipientname: $('#name').val(),
                    shippingaddress: $('#address').val() + ' ' + $('#detailAddress').val(),
                    shippingrequest: $('#extraAddress').val(),
                    couponid: couponId // 쿠폰 ID 추가
                };

                $.ajax({
                    type: 'POST',
                    url: '/membershipticket/paymentSuccess',
                    contentType: 'application/json',
                    data: JSON.stringify(formData),
                    success: function(data) {
                        alert('결제가 성공적으로 완료되었습니다.');
                        window.close(); // 결제창 닫기
                    },
                    error: function(error) {
                        alert('결제 처리 중 오류가 발생했습니다.');
                    }
                });
            } else {
                alert('결제에 실패하였습니다.');
            }
        });
    });
});
</script>
</body>
</html>
