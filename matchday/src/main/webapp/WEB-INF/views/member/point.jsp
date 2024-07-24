<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
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
    .mypage-content {
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
    .form-table {
        width: 100%;
        border-collapse: collapse;
    }
    .form-table th, .form-table td {
        padding: 8px;
        border: 1px solid #ccc;
        text-align: center;
    }
    .form-table th {
        background-color: #f0f0f0;
    }
    @media (max-width: 768px) {
        .form-table th, .form-table td {
            display: block;
            width: 100%;
            text-align: left;
            border: none;
            padding: 5px 0;
        }
        .form-table th {
            margin-top: 10px;
        }
        .form-table td {
            margin-bottom: 10px;
        }
    }
    .point-type-적립 {
        color: blue;
        font-weight: bold;
    }
    .point-type-사용, .point-type-적립취소 {
        color: red;
        font-weight: bold;
    }
</style>
<div class="mypage-container">
    <!-- 사이드바 -->
    <div class="mypage-sidebar">
        <ul class="list-group">
            <li class="list-group-item"><a href="/member/mypage">회원 정보</a></li>
            <li class="list-group-item active"><a href="/member/mypage/point">포인트 내역</a></li>
            <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰함</a></li>
            <li class="list-group-item"><a href="/cart/list">장바구니</a></li>
            <li class="list-group-item"><a href="/tickets/reservationList">나의 예매내역</a></li>
            <li class="list-group-item"><a href="/order/orderList">나의 주문내역</a></li>
            <li class="list-group-item"><a href="/membershipticket/membershippaymentlist">멤버쉽 구매내역</a></li>
        </ul>
    </div>

    <!-- 포인트 적립 내역 -->
    <div class="mypage-content">
        <h2 class="mypage-title">포인트 적립 내역</h2>
        <table class="form-table">
            <thead>
                <tr>
                    <th>적립일</th>
                    <th>적립 유형</th>
                    <th>적립 포인트</th>
                    <th>포인트 출처</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="history" items="${pointHistoryList}">
                    <tr>
                        <td>${history.pointcreationdate}</td>
                         <td class="${history.pointtype eq '적립' ? 'point-type-적립' : (history.pointtype eq '사용' ? 'point-type-사용' : 'point-type-적립취소')}">${history.pointtype}</td>
                        <td>${history.pointamount}</td>
                        <td>${history.pointsource}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../footer.jsp" %>
