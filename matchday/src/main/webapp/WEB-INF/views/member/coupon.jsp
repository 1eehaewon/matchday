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
    .form-group {
        margin-bottom: 15px;
    }
    .form-table {
        width: 100%;
    }
    .form-table th, .form-table td {
        padding: 8px;
        vertical-align: middle;
        border: 1px solid #ccc;
    }
    .form-table th {
        text-align: left;
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
    .input-group {
        display: flex;
        align-items: center;
    }
    .input-group input {
        flex: 1;
    }
    .input-group button {
        margin-left: 10px;
    }
</style>
<div class="mypage-container">
    <table class="table table-bordered">
        <tr>
            <td class="mypage-sidebar" style="border-right: none;">
                <ul class="list-group">
                    <li class="list-group-item"><a href="/member/mypage">회원 정보</a></li>
                    <c:choose>
                        <c:when test="${user.grade == 'M'}">
                            <li class="list-group-item"><a href="/member/mypage/point">포인트 관리</a></li>
                            <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰 관리</a></li>
                        </c:when>
                        <c:otherwise>
                            <li class="list-group-item"><a href="/member/mypage/point">포인트 내역</a></li>
                            <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰함</a></li>
                        </c:otherwise>
                    </c:choose>
                </ul>
            </td>
            <td width="15" style="border: none;"></td>
            <td class="mypage-form" style="border-left: none;">
                <h2 class="mypage-title">쿠폰 목록</h2>
                <table class="form-table">
                    <thead>
                        <tr>
                            <th>쿠폰번호</th>
                            <th>쿠폰종류이름</th>
                            <th>사용여부</th>
                            <th>사용시작일자</th>
                            <th>사용만료일자</th>
                            <th>적용구분</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="coupon" items="${couponList}">
                            <tr>
                                <td>${coupon.couponid}</td>
                                <td>${coupon.coupontypename}</td>
                                <td>${coupon.usage}</td>
                                <td>${coupon.startdate}</td>
                                <td>${coupon.enddate}</td>
                                <td>${coupon.applicationcategory}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </td>
        </tr>
    </table>
</div>
<%@ include file="../footer.jsp" %>
