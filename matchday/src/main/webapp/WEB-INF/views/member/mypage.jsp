<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    .mypage-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background-color: #f8f9fa;
        padding: 30px 10px;
    }
    .mypage-form {
        width: 100%;
        max-width: 600px; /* 최대 너비 */
        padding: 30px;
        border: 1px solid #ccc;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
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
    }
    .form-table th {
        text-align: left;
    }
    @media (max-width: 768px) {
        .form-table th, .form-table td {
            display: block;
            width: 100%;
            text-align: left;
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
    <h2 class="mypage-title">마이페이지</h2>
    <div class="mypage-form">
        <form id="myPageForm" action="/member/mypage/edit" method="post">
            <table class="form-table">
                <tr>
                    <th><label for="userID">아이디</label></th>
                    <td><input type="text" class="form-control" id="userID" name="userID" value="${user.userID}" readonly></td>
                </tr>
                <tr>
                    <th><label for="email">이메일</label></th>
                    <td><input type="email" class="form-control" id="email" name="email" value="${user.email}" required></td>
                </tr>
                <tr>
                    <th><label for="zipcode">주소</label></th>
                    <td>
                        <input type="text" class="form-control" id="zipcode" name="zipcode" placeholder="우편번호" value="${user.zipcode}">
                        <input type="text" class="form-control mt-2" id="address1" name="address1" placeholder="기본 주소" value="${user.address1}">
                        <input type="text" class="form-control mt-2" id="address2" name="address2" placeholder="상세 주소" value="${user.address2}">
                    </td>
                </tr>
                <tr>
                    <th><label for="number">전화번호</label></th>
                    <td><input type="text" class="form-control" id="number" name="number" value="${user.number}" required></td>
                </tr>
                <tr>
                    <th><label for="point">포인트</label></th>
                    <td><input type="text" class="form-control" id="point" name="point" value="${user.points}" required readonly></td>
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
