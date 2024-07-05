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
</head>
<body>
    <div class="container">
        <h1>예매 확인</h1>
        <div class="row">
            <div class="col-md-6">
                <h2>티켓수령방법</h2>
                <form>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="pickup" value="pickup" checked>
                        <label class="form-check-label" for="pickup">
                            현장수령
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="shipping" value="shipping">
                        <label class="form-check-label" for="shipping">
                            배송 (3,200원)
                        </label>
                    </div>
                    <div class="form-check">
                        <input class="form-check-input delivery-option" type="radio" name="deliveryOption" id="mobile" value="mobile">
                        <label class="form-check-label" for="mobile">
                            모바일 티켓
                        </label>
                    </div>
                </form>
            </div>
            <div class="col-md-6">
                <h2>예매자 확인</h2>
                <form>
                    <div class="mb-3">
                        <label for="name" class="form-label">이름</label>
                        <input type="text" class="form-control" id="name" value="사용자 이름" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="birthdate" class="form-label">생년월일</label>
                        <input type="text" class="form-control" id="birthdate" value="생년월일" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="phone" class="form-label">연락처</label>
                        <input type="text" class="form-control" id="phone" value="연락처" readonly>
                    </div>
                    <div class="mb-3">
                        <label for="email" class="form-label">이메일</label>
                        <input type="email" class="form-control" id="email" value="이메일" readonly>
                    </div>
                </form>
            </div>
        </div>
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
                <td id="delivery-fee">0원</td>
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
        <div class="d-flex justify-content-end">
            <button type="button" class="btn btn-secondary me-2" id="prev-step">이전단계</button>
            <button type="button" class="btn btn-primary">다음단계</button>
        </div>
    </div>
    <script>
        $(document).ready(function() {
            var totalPrice = ${totalPrice}; // 전달받은 총 티켓 금액

            // 배송 방법에 따른 배송료 설정
            function updateDeliveryFee() {
                var deliveryOption = $('input[name="deliveryOption"]:checked').val();
                var deliveryFee = deliveryOption === 'shipping' ? 3200 : 0;
                $('#delivery-fee').text(deliveryFee.toLocaleString() + '원');
                updateTotalAmount();
            }

            // 총 결제 금액 계산
            function updateTotalAmount() {
                var serviceFee = 2000;
                var deliveryOption = $('input[name="deliveryOption"]:checked').val();
                var deliveryFee = deliveryOption === 'shipping' ? 3200 : 0;
                var discount = 0;
                var totalAmount = totalPrice + serviceFee + deliveryFee - discount;
                $('#total-amount').text(totalAmount.toLocaleString() + '원');
            }

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
        });
    </script>
</body>
</html>
