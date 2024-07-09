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
                <!-- 티켓 수령 방법 선택 폼 -->
                <form>
                    <!-- 현장 수령 옵션 -->
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="pickup" value="receiving01" checked>
                        <label class="form-check-label" for="pickup">
                            현장수령
                        </label>
                    </div>
                    <!-- 배송 옵션 -->
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="shipping" value="receiving02">
                        <label class="form-check-label" for="shipping">
                            배송 (3,200원)
                        </label>
                    </div>
                    <!-- 모바일 티켓 옵션 -->
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="mobile" value="receiving03">
                        <label class="form-check-label" for="mobile">
                            모바일 티켓
                        </label>
                    </div>
                </form>

                <!-- 배송지 주소 입력 폼 (배송 옵션 선택 시만 표시) -->
                <div id="delivery-address">
                    <h2>배송지 주소</h2>
                    <form>
                        <!-- 우편번호 입력 -->
                        <div class="mb-3">
                            <label for="postcode" class="form-label">우편번호</label>
                            <input type="text" class="form-control" id="postcode" readonly>
                            <button type="button" class="btn btn-primary mt-2" id="find-postcode">우편번호 찾기</button>
                        </div>
                        <!-- 주소 입력 -->
                        <div class="mb-3">
                            <label for="address" class="form-label">주소</label>
                            <input type="text" class="form-control" id="address" readonly>
                        </div>
                        <!-- 상세 주소 입력 -->
                        <div class="mb-3">
                            <label for="detailAddress" class="form-label">상세주소</label>
                            <input type="text" class="form-control" id="detailAddress">
                        </div>
                        <!-- 참고 항목 입력 -->
                        <div class="mb-3">
                            <label for="extraAddress" class="form-label">참고항목</label>
                            <input type="text" class="form-control" id="extraAddress" readonly>
                        </div>
                    </form>
                </div>

                <h2>예매자 확인</h2>
                <!-- 예매자 정보 입력 폼 -->
                <form>
                    <!-- 이름 입력 -->
                    <div class="mb-3">
                        <label for="name" class="form-label">이름</label>
                        <input type="text" class="form-control" id="name" value="${userInfo.name}" readonly>
                    </div>
                    <!-- 이메일 입력 -->
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email" value="${userInfo.email}" readonly>
                    </div>
                    <!-- 연락처 입력 -->
                    <div class="mb-3">
                        <label for="phone" class="form-label">연락처</label>
                        <input type="text" class="form-control" id="phone" value="${userInfo.number}" readonly>
                    </div>
                </form>
            </div>
            <div class="col-md-6">
                <h2>My예매정보</h2>
                <!-- 예매 정보 테이블 -->
                <table class="table table-bordered">
                    <!-- 경기 일시 -->
                    <tr>
                        <th>일시</th>
                        <td><fmt:formatDate value="${match.matchdate}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></td>
                    </tr>
                    <!-- 선택 좌석 -->
                    <tr>
                        <th>선택좌석</th>
                        <td>
                            <c:forEach var="seat" items="${seats}">
                                <div>${seat}</div>
                            </c:forEach>
                        </td>
                    </tr>
                    <!-- 티켓 금액 -->
                    <tr>
                        <th>티켓금액</th>
                        <td id="ticket-price">${totalPrice}원</td>
                    </tr>
                    <!-- 수수료 -->
                    <tr>
                        <th>수수료</th>
                        <td id="service-fee">2,000원</td>
                    </tr>
                    <!-- 배송료 -->
                    <tr>
                        <th>배송료</th>
                        <td id="delivery-fee">0원</td>
                    </tr>
                    <!-- 할인 -->
                    <tr>
                        <th>할인</th>
                        <td id="discount">0원</td>
                    </tr>
                    <!-- 할인 쿠폰 -->
                    <tr>
                        <th>할인쿠폰</th>
                        <td>적용 안함</td>
                    </tr>
                    <!-- 취소 기간 -->
                    <tr>
                        <th>취소기간</th>
                        <td><fmt:formatDate value="${match.cancellationDeadline}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></td>
                    </tr>
                    <!-- 취소 수수료 -->
                    <tr>
                        <th>취소수수료</th>
                        <td>티켓금액의 0~10%</td>
                    </tr>
                    <!-- 총 결제 금액 -->
                    <tr>
                        <th>총 결제금액</th>
                        <td id="total-amount"></td>
                    </tr>
                </table>
            </div>
        </div>
        <div class="d-flex justify-content-end">
            <!-- 이전 단계 버튼 -->
            <button type="button" class="btn btn-secondary me-2" id="prev-step">이전단계</button>
            <!-- 결제 버튼 -->
            <button type="button" class="btn btn-primary" id="pay-button">결제하기</button>
        </div>
    </div>
    <script>
        $(document).ready(function() {
            // 초기 총 티켓 금액 설정
            var totalPrice = ${totalPrice};
            // 선택된 좌석들을 배열로 변환
            var seats = "${seats}".split(",");

            // 배송 방법에 따른 배송료 업데이트 함수
            function updateDeliveryFee() {
                var deliveryOption = $('input[name="deliveryOption"]:checked').val();
                var deliveryFee = deliveryOption === 'receiving02' ? 3200 : 0; // 배송료 설정
                $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
                if (deliveryOption === 'receiving02') {
                    $('#delivery-address').show(); // 배송 옵션 선택 시 주소 입력 폼 표시
                } else {
                    $('#delivery-address').hide(); // 배송 옵션이 아닐 경우 숨김
                }
                updateTotalAmount(); // 총 결제 금액 업데이트
            }

            // 총 결제 금액 계산 및 업데이트 함수
            function updateTotalAmount() {
                var serviceFee = 2000; // 수수료 설정
                var deliveryOption = $('input[name="deliveryOption"]:checked').val();
                var deliveryFee = deliveryOption === 'receiving02' ? 3200 : 0; // 배송료 설정
                var discount = 0; // 할인 설정
                var totalAmount = totalPrice + serviceFee + deliveryFee - discount; // 총 금액 계산
                $('#total-amount').text(totalAmount.toLocaleString() + '원');
                return totalAmount; // 총 결제 금액 반환
            }

            // 주소 찾기 API 호출 함수
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
                        $('#address').val(addr); // 주소 설정
                        $('#detailAddress').focus(); // 상세주소 입력 필드로 포커스 이동
                    }
                }).open();
            });

            // 배송 방법 변경 시 이벤트 리스너 추가
            $('.delivery-option').change(function() {
                updateDeliveryFee(); // 배송료 업데이트 함수 호출
            });

            // 초기 배송료 계산
            updateDeliveryFee();

            // 이전 단계로 이동하는 버튼의 클릭 이벤트 리스너 추가
            $('#prev-step').click(function() {
                window.history.back(); // 이전 페이지로 이동
            });

            // 결제 버튼 클릭 이벤트 리스너 추가
            $('#pay-button').click(function() {
                var totalAmount = updateTotalAmount(); // 총 결제 금액 가져오기

                // 결제 요청
                IMP.request_pay({
                    pg: 'html5_inicis', // 결제 PG사
                    pay_method: 'card', // 결제 방법
                    merchant_uid: 'merchant_' + new Date().getTime(), // 주문 번호
                    name: '티켓 결제', // 결제 이름
                    amount: totalAmount, // 총 결제 금액 설정
                    buyer_email: $('#email').val(), // 구매자 이메일
                    buyer_name: $('#name').val(), // 구매자 이름
                    buyer_tel: $('#phone').val(), // 구매자 연락처
                    m_redirect_url: 'http://yourdomain.com/complete' // 결제 완료 후 리다이렉트될 URL
                }, function(rsp) {
                    if (rsp.success) {
                        // 결제 성공 시 처리
                        var seatsStr = JSON.stringify(seats); // 좌석 정보를 JSON 문자열로 변환
                        var formData = {
                            imp_uid: rsp.imp_uid, // 아임포트 UID
                            merchant_uid: rsp.merchant_uid, // 주문 번호
                            paid_amount: rsp.paid_amount, // 결제 금액
                            matchid: '${match.matchid}', // 경기 ID
                            totalPrice: totalPrice, // 총 티켓 금액
                            collectionmethodcode: $('input[name="deliveryOption"]:checked').val(), // 수령 방법
                            recipientname: $('#name').val(), // 수령자 이름
                            shippingaddress: $('#address').val() + ' ' + $('#detailAddress').val(), // 배송 주소
                            shippingrequest: $('#extraAddress').val(), // 배송 요청 사항
                            seats: seatsStr // 좌석 정보
                        };

                        console.log('FormData before sending:', formData); // 디버깅을 위한 콘솔 로그

                        // 결제 검증 요청
                        $.ajax({
                            type: 'POST',
                            url: '/tickets/verifyPayment',
                            data: formData,
                            traditional: true,
                            success: function(data) {
                                if (data.success) {
                                    window.location.href = '/tickets/confirmation?reservationid=' + data.reservationid; // 결제 검증 성공 시 리다이렉트
                                } else {
                                    alert('결제 검증에 실패했습니다.'); // 결제 검증 실패 시 경고
                                }
                            }
                        });
                    } else {
                        alert('결제에 실패하였습니다.'); // 결제 실패 시 경고
                    }
                });
            });

            // 결제 취소 버튼 클릭 이벤트 리스너 추가
            $('#cancel-button').click(function() {
                var impUid = prompt("취소할 결제의 imp_uid를 입력하세요:");
                if (impUid) {
                    $.ajax({
                        url: '/tickets/cancelPayment',
                        type: 'DELETE',
                        data: { imp_uid: impUid },
                        success: function(response) {
                            if (response.success) {
                                alert("결제가 취소되었습니다."); // 결제 취소 성공 시 알림
                            } else {
                                alert("결제 취소에 실패했습니다: " + response.message); // 결제 취소 실패 시 경고
                            }
                        },
                        error: function(error) {
                            alert("결제 취소 요청 중 오류가 발생했습니다."); // 결제 취소 요청 중 오류 발생 시 경고
                        }
                    });
                }
            });

            // 이메일 유효성 검증 함수
            function validateEmail(email) {
                var re = /^[^\s@]+@[^\s@]+$/.test(email);
                return re;
            }
        });
    </script>
</body>
</html>
