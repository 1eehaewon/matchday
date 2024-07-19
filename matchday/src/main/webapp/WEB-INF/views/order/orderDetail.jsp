<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ include file="../header.jsp" %>

<style>
    .card-header {
        background-color: #f8f9fa;
        font-weight: bold;
    }
    .info-title {
        font-weight: bold;
    }
    .info-content {
        margin-bottom: 0.5rem;
    }
    .table {
        width: 100%;
        table-layout: fixed;
    }
    .table th, .table td {
        word-wrap: break-word;
    }
    .btn-group {
        display: flex;
        justify-content: center;
        gap: 10px;
    }
</style>

<div class="container mt-4">
    <h1 class="mb-4">주문 상세 정보</h1>
    
    <div class="card mb-4">
        <div class="card-header">
            주문 정보
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>회원 ID</th>
                    <td>${order.userid}</td>
                </tr>
                <tr>
                    <th>주문번호</th>
                    <td>${order.orderid}</td>
                </tr>
                <tr>
                    <th>구매일자</th>
                    <td>${order.orderdate}</td>
                </tr>
                <tr>
                    <th>수령인 이름</th>
                    <td>${order.recipientname}</td>
                </tr>
                <tr>
                    <th>수령인 이메일</th>
                    <td>${order.recipientemail}</td>
                </tr>
                <tr>
                    <th>수령인 전화번호</th>
                    <td>${order.recipientphone}</td>
                </tr>
                <tr>
                    <th>배송지</th>
                    <td>${order.shippingaddress}</td>
                </tr>
                <tr>
                    <th>배송 요청사항</th>
                    <td>${order.shippingrequest}</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            결제 내역
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>배송일?</th>
                    <td>${reservation.reservationdate}</td>
                </tr>
                <tr>
                    <th>현재상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${order.orderstatus == 'Confirmed'}">
                                주문완료
                            </c:when>
                            <c:when test="${order.orderstatus == 'Cancelled'}">
                                결제취소
                            </c:when>
                            <c:otherwise>
                                ${order.orderstatus}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>결제수단</th>
                    <td>
                       <%--  <c:choose>
                            <c:when test="${order.paymentmethodname == 'card'}">
                                카드
                            </c:when>
                            <c:otherwise>
                                ${order.paymentmethodname}
                            </c:otherwise>
                        </c:choose> --%>
                    </td>
                </tr>
                <tr>
                    <th>수수료</th>
                    <td>${serviceFee}원</td>
                </tr>
                <tr>
                    <th>배송료</th>
                    <td>${deliveryFee}원</td>
                </tr>
                <tr>
                    <th>사용한 쿠폰</th>
                    <td>${couponid}</td>
                </tr>
                <tr>
                    <th>사용한 포인트</th>
                    <td>${order.usedpoints}&nbsp;point</td>
                </tr>
                <tr>
                    <th>총 할인액</th>
                    <td>${totalDiscount}원</td>
                </tr>
                <tr>
                    <th>총 결제금액</th>
                    <td>${finalpaymentamount}원</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            주문 내역
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>주문 ID</th>
                        <th>상품명</th>
                        <th>상품 사이즈</th>
                        <th>상품 수량</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${reservation.details}">
                        <tr>
                            <td>${detail.seatid}</td>
                            <td>${detail.price}원</td>
                            <td>${detail.price}원</td>
                            <td>${detail.price}원</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            예약 취소 유의사항
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>취소 마감시간</th>
                    <td>~<fmt:formatDate value="${order.cancelDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>
            </table>
            <p class="text-danger mt-3">취소 유의사항을 여기에 추가하세요.</p>
        </div>
    </div>

    <div class="btn-group" align="center">
        <button id="cancel-payment" class="btn btn-danger">결제 취소</button>
        &nbsp;&nbsp;
        <button id="go-back" class="btn btn-secondary">목록으로</button>
    </div>

<script>
    $(document).ready(function() {
        $('#cancel-payment').click(function() {
            if (confirm('정말로 결제를 취소하시겠습니까?')) {
                $.ajax({
                    url: '/tickets/cancelPayment',
                    type: 'POST',
                    data: { reservationid: '${reservation.reservationid}' },
                    success: function(response) {
                        if (response.success) {
                            alert('결제가 취소되었습니다.');
                            window.location.href = '/tickets/reservationList';
                        } else {
                            alert('결제 취소에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(error) {
                        alert('결제 취소 요청 중 오류가 발생했습니다.');
                    }
                });
            }
        });

        $('#go-back').click(function() {
            window.location.href = '/order/orderList';
        });
    });
</script>

<%@ include file="../footer.jsp" %>
