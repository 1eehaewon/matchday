<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
            <li class="list-group-item"><a href="/membershipticket/membershippaymentlist">멤버쉽 구매내역</a></li>
        </ul>
    </div>