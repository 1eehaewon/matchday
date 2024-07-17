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
     .delete-button-container {
        margin-top: 20px; /* 버튼과 테이블 사이의 간격 조정 */
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
            <li class="list-group-item"><a href="/membershipticket/membershippaymentlist">멤버쉽 구매내역</a></li>
        </ul>
    </div>

    <!-- 회원 목록 및 삭제 기능 -->
    <div class="mypage-content">
        <h2 class="mypage-title">회원 목록</h2>
        <table id="datatablesSimple" class="form-table">
            <thead>
                <tr>
                    <th>선택</th>
                    <th>아이디</th>
                    <th>이름</th>
                    <th>이메일</th>
                    <th>등급</th>
                    <th>가입생성일</th>
                    <th>총 사용한 금액</th>
                </tr>
            </thead>
            <tbody>
                <!-- 반복문을 통해 사용자 데이터 표시 -->
                <c:forEach var="user" items="${users}">
                    <tr>
                        <td><input type="checkbox" id="user-${user.userid}" onchange="toggleUserSelection('${user.userid}')" /></td>
                        <td>${user.userid}</td>
                        <td>${user.name}</td>
                        <td>${user.email}</td>
                        <td>${user.grade}</td>
                        <td>${user.joinDate}</td>
                        <td><fmt:formatNumber value="${user.totalSpent}" type="number" groupingUsed="true"/> 원</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
        <!-- 선택한 회원 삭제 버튼 -->
        <div class="delete-button-container">
            <button onclick="deleteSelectedUsers()">선택한 회원 삭제</button>
        </div>
    </div>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
    // 사용자 선택 상태를 저장할 배열
    let selectedUsers = [];

    // 체크박스 선택 시 배열에 추가 또는 제거
    function toggleUserSelection(userId) {
        if (selectedUsers.includes(userId)) {
            selectedUsers = selectedUsers.filter(id => id !== userId);
        } else {
            selectedUsers.push(userId);
        }
    }

 // 회원 삭제 요청
    function deleteSelectedUsers() {
        if (selectedUsers.length === 0) {
            alert("삭제할 회원을 선택해주세요.");
            return;
        }
        
        if (confirm("선택한 회원을 삭제하시겠습니까?")) {
            $.ajax({
                type: "POST",
                url: "/admin/deleteUsers",
                data: { userIds: selectedUsers }, // 선택된 회원들의 userId 배열
                success: function(response) {
                    alert(response);
                    location.reload(); // 페이지 새로고침
                },
                error: function(xhr, status, error) {
                    alert("회원 삭제 중 오류가 발생했습니다.");
                    console.error(error);
                }
            });
        }
    }
</script>

<%@ include file="../footer.jsp" %>
