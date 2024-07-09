<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

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
        IMP.init('imp05021463'); // 아임포트 관리자 콘솔에서 발급받은 가맹점 식별코드
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
    </style>
</head>
<body>
    <div class="container mt-4">
        <h1>예매 확인</h1>
        <div class="row">
            <div class="col-md-6">
                <h2>티켓수령방법</h2>
                <form>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="pickup" value="receiving01" checked>
                        <label class="form-check-label" for="pickup">
                            현장수령
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="shipping" value="receiving02">
                        <label class="form-check-label" for="shipping">
                            배송 (3,200원)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="mobile" value="receiving03">
                        <label class="form-check-label" for="mobile">
                            모바일 티켓
                        </label>
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
            <div class="col-md-6">
                <h2>My예매정보</h2>
                <table class="table table-bordered">
                    <tr>
                        <th>일시</th>
                        <td><fmt:formatDate value="${match.matchdate}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></td>
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
                        <td id="delivery-fee">0원</th>
                    </tr>
                    <tr>
                        <th>할인</th>
                        <td id="discount">0원</td>
                    </tr>
                    <tr>
                        <th>할인쿠폰</th>
                        <td>적용 안함</td>
                    </tr>
                    <tr>
                        <th>취소기간</th>
                        <td><fmt:formatDate value="${match.cancellationDeadline}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></td>
                    </tr>
                    <tr>
                        <th>취소수수료</th>
                        <td>티켓금액의 0~10%</td>
                    </tr>
                    <tr>
                        <th>총 결제금액</th>
                        <td id="total-amount"></td>
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
        var totalPrice = ${totalPrice}; // 전달받은 총 티켓 금액
        var seats = "${seats}".split(","); // seats 파라미터를 배열로 변환

        // 배송 방법에 따른 배송료 설정
        function updateDeliveryFee() {
            var deliveryOption = $('input[name="deliveryOption"]:checked').val();
            var deliveryFee = deliveryOption === 'receiving02' ? 3200 : 0;
            $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
            if (deliveryOption === 'receiving02') {
                $('#delivery-address').show();
            } else {
                $('#delivery-address').hide();
            }
            updateTotalAmount();
        }

        // 총 결제 금액 계산
        function updateTotalAmount() {
            var serviceFee = 2000;
            var deliveryOption = $('input[name="deliveryOption"]:checked').val();
            var deliveryFee = deliveryOption === 'receiving02' ? 3200 : 0;
            var discount = 0;
            var totalAmount = totalPrice + serviceFee + deliveryFee - discount;
            $('#total-amount').text(totalAmount.toLocaleString() + '원');
            return totalAmount; // 총 결제 금액 반환
        }

        // 주소 찾기 API 호출
        $('#find-postcode').click(function() {
            new daum.Postcode({
                oncomplete: function(data) {
                    var addr = ''; // 주소 변수
                    var extraAddr = ''; // 참고항목 변수

                    if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
                        addr = data.roadAddress;
                    } else { // 사용자가 지번 주소를 선택했을 경우
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

        // 배송 방법 변경 시 이벤트
        $('.delivery-option').change(function() {
            updateDeliveryFee();
        });

        // 초기 계산
        updateDeliveryFee();

        // 이전 단계로 이동하는 버튼의 클릭 이벤트 핸들러
        $('#prev-step').click(function() {
            window.history.back();
        });

        // 결제 버튼 클릭 이벤트 핸들러
        // 결제 버튼 클릭 이벤트 핸들러
$('#pay-button').click(function() {
    var totalAmount = updateTotalAmount(); // 총 결제 금액 가져오기

    // 결제 요청
    IMP.request_pay({
        pg: 'html5_inicis',
        pay_method: 'card',
        merchant_uid: 'merchant_' + new Date().getTime(),
        name: '티켓 결제',
        amount: totalAmount, // 총 결제 금액으로 설정
        buyer_email: $('#email').val(),
        buyer_name: $('#name').val(),
        buyer_tel: $('#phone').val(),
        m_redirect_url: 'http://yourdomain.com/complete'
    }, function(rsp) {
        if (rsp.success) {
            var seatsStr = seats.join(','); // 좌석 정보를 쉼표로 구분된 문자열로 변환
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
                seats: seatsStr // 좌석 정보를 추가
            };

            seats.forEach(function(seat, index) {
                formData['seat' + index] = seat; // 각 좌석 ID를 seat 파라미터로 추가
            });

            console.log('FormData before sending:', formData); // 로그 추가

            $.ajax({
                type: 'POST',
                url: '/tickets/verifyPayment',
                data: formData,
                traditional: true,
                success: function(data) {
                    if (data.success) {
                        window.location.href = '/tickets/confirmation?reservationid=' + data.reservationid;
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




        // 결제 취소 버튼 클릭 이벤트 핸들러
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

        function validateEmail(email) {
            var re = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
            return re.test(email);
        }
    });
    </script>
</body>
</html>
