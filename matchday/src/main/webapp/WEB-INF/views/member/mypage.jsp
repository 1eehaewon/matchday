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
</style>
<div class="mypage-container">
    <!-- 사이드바 -->
    <div class="mypage-sidebar">
        <ul class="list-group">
            <li class="list-group-item active"><a href="/member/mypage">회원 정보</a></li>
            <li class="list-group-item"><a href="/member/mypage/point">포인트 내역</a></li>
            <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰함</a></li>
            <li class="list-group-item"><a href="/cart/list">장바구니</a></li>
            <li class="list-group-item"><a href="/tickets/reservationList">나의 예매내역</a></li>
            <li class="list-group-item"><a href="/membershipticket/membershippaymentlist">멤버쉽 구매내역</a></li>
        </ul>
    </div>
    <!-- 회원 정보 내용 -->
    <div class="mypage-form">
        <h2 class="mypage-title">회원 정보</h2>
        <form id="myPageForm" action="/member/mypage/edit" method="post">
            <table class="form-table">
                <tr>
                    <th><label for="userID">아이디</label></th>
                    <td><input type="text" class="form-control" id="userID" name="userID" value="${user.userID}" readonly></td>
                </tr>
                <tr>
                    <th><label for="email">이메일</label></th>
                    <td><input type="email" class="form-control" id="email" name="email" value="${user.email}" required readonly></td>
                </tr>
                <tr>
                    <th><label for="zipcode">주소</label></th>
                    <td>
                        <input type="text" class="form-control" id="zipcode" name="zipcode" placeholder="우편번호" value="${user.zipcode}" readonly>
                        <input type="text" class="form-control mt-2" id="address1" name="address1" placeholder="기본 주소" value="${user.address1}" readonly>
                        <input type="text" class="form-control mt-2" id="address2" name="address2" placeholder="상세 주소" value="${user.address2}" readonly>
                    </td>
                </tr>
                <tr>
                    <th><label for="number">전화번호</label></th>
                    <td><input type="text" class="form-control" id="number" name="number" value="${user.number}" required readonly></td>
                </tr>
                <tr>
                    <th><label for="point">포인트</label></th>
                    <td><input type="text" class="form-control" id="totalpoints" name="totalpoints" value="${totalpoints}" required readonly></td>
                </tr>
                <tr>
                    <th>구입한 멤버쉽</th>
                    <td>
                        <ul>
                            <c:forEach var="membership" items="${userPurchasedMemberships}">
                                <li>${membership.membershipname} (구매일: ${membership.purchasedate})</li>
                            </c:forEach>
                        </ul>
                    </td>
                </tr>
                <tr>
                    <td colspan="2" class="text-center">
                        <button type="submit" class="btn btn-primary">수정하기</button>
                        <a href="/home.do" class="btn btn-secondary">취소</a>
                        <button id="deleteButton" class="btn btn-danger">회원탈퇴</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    var message = "${message}";
    if (message) {
        alert(message);
    }

    document.getElementById('deleteButton').addEventListener('click', function(event) {
        event.preventDefault();
        if (confirm('정말로 회원탈퇴 하시겠습니까?')) {
            document.getElementById('myPageForm').action = '/member/mypage/delete';
            document.getElementById('myPageForm').submit();
        }
    });
});
</script>

<%@ include file="../footer.jsp" %>
