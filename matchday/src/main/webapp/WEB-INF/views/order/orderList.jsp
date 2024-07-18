<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    .mypage-container {
        display: flex;
        min-height: 100vh;
        background-color: #f8f9fa;
        padding: 30px 10px;
    }
    .mypage-sidebar {
        width: 200px; /* 사이드바 너비 */
        padding: 20px;
        background-color: #ffffff;
        border: 1px solid #ccc;
        border-radius: 10px;
        margin-right: 20px;
    }
    .mypage-form {
        flex: 1;
        padding: 30px;
        border: 1px solid #ccc;
        border-radius: 10px;
        background-color: #fff;
    }
    .mypage-title {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
        font-weight: bold;
        color: #333;
    }
    .table-container {
        margin-top: 20px;
    }
    .table {
        width: 100%;
        border-collapse: collapse;
        margin-top: 10px;
    }
    .table th, .table td {
        border: 1px solid #ccc;
        padding: 8px;
        text-align: center;
    }
    .table th {
        background-color: #f0f0f0;
    }
    .badge {
        display: inline-block;
        padding: 5px 10px;
        border-radius: 5px;
        font-size: 12px;
        font-weight: bold;
        text-transform: uppercase;
    }
    .badge-success {
        background-color: #28a745;
        color: #fff;
    }
    .badge-danger {
        background-color: #dc3545;
        color: #fff;
    }
</style>
<div class="mypage-container">
    <!-- 사이드바 -->
    <div class="mypage-sidebar">
        <ul class="list-group">
            <li class="list-group-item"><a href="/member/mypage">회원 정보</a></li>
            <li class="list-group-item"><a href="/member/mypage/point">포인트 내역</a></li>
            <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰함</a></li>
            <li class="list-group-item"><a href="/cart/list">장바구니</a></li>
            <li class="list-group-item"><a href="/tickets/reservationList">나의 예매내역</a></li>
            <li class="list-group-item active"><a href="/order/orderList">나의 주문내역</a></li>
            <li class="list-group-item"><a href="/membershipticket/membershippaymentlist">멤버쉽 구매내역</a></li>
        </ul>
    </div>
    <!-- 주문내역 내용 -->
    <div class="mypage-form">
        <h2 class="mypage-title">나의 주문내역</h2>
        <div class="table-container">
            <table class="table">
                <thead>
                    <tr>
                        <th>주문일</th>
                        <th>주문번호</th>
                        <th>상품명</th>
                        <th>사이즈/수량</th>
                        <th>결제 금액</th>
                        <th>취소가능일</th>
                        <th>현재상태</th>
                    </tr>
                </thead>
                <tbody>
	                <c:forEach items="${order}" var="order">
	                	<tr>
	                		<td>${order.orderdate}</td>
	                		<td><a href="/order/orderDetail?orderid=${order.orderid}" class="link-primary">${order.orderid}</a></td>
	                		<c:forEach items="${goodsList}" var="goods">
	                		<c:if test="${goods.goodsid eq order.goodsid}">
                                    <td>${goods.productname}</td>
                                    </c:if>
	                		</c:forEach>
                                    <td>${order.size} / ${order.quantity}</td>
                                
	                		<td><fmt:formatNumber value="${order.finalpaymentamount}" pattern="#,###원" /></td>
	                		<td></td>
	                		<td></td>
	                	</tr>
	                </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>

<!-- <a href="/orderlist?goodsid=12345&size=M&quantity=2&price=100&totalPrice=200&couponid=COUPON123&usedpoints=10">
    Order Now
</a> -->

<%@ include file="../footer.jsp" %>
