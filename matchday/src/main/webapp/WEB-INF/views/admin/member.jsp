<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>

<!-- 회원 목록 및 삭제 기능 -->
<div class="container-fluid px-4">
	<h1 class="mt-4">회원 관리</h1>
	<ol class="breadcrumb mb-4">
	</ol>
	<div class="card mb-4">
		<div class="card-header">
			<i class="fas fa-table me-1"></i> 회원 목록
		</div>
		<div class="card-body">
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
							<td><input type="checkbox" id="user-${user.userid}"
								onchange="toggleUserSelection('${user.userid}')" /></td>
							<td><a href="/admin?userid=${user.userid}">${user.userid}</a></td>
							<td>${user.name}</td>
							<td>${user.email}</td>
							<td>${user.grade}</td>
							<td>${user.joinDate}</td>
							<td><fmt:formatNumber value="${user.totalSpent}"
									type="number" groupingUsed="true" /> 원</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
			<!-- 선택한 회원 삭제 버튼 -->
			<div class="delete-button-container">
				<button onclick="suspendSelectedUsers()">선택한 회원 정지</button>
			</div>
			<!-- 선택한 회원 정지 해제 버튼 -->
			<div class="delete-button-container">
				<button onclick="unsuspendSelectedUsers()">선택한 회원 정지 해제</button>
			</div>
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

 // 회원 정지 요청
    function suspendSelectedUsers() {
        if (selectedUsers.length === 0) {
            alert("정지할 회원을 선택해주세요.");
            return;
        }
        
        if (confirm("선택한 회원을 정지하시겠습니까?")) {
            $.ajax({
                type: "POST",
                url: "/admin/suspendUsers",
                data: { userIds: selectedUsers }, // 선택된 회원들의 userId 배열
                success: function(response) {
                    alert(response);
                    location.reload(); // 페이지 새로고침
                },
                error: function(xhr, status, error) {
                    alert("회원 정지 중 오류가 발생했습니다.");
                    console.error(error);
                }
            });
        }
    }
 
    // 회원 정지 해제 요청
    function unsuspendSelectedUsers() {
        if (selectedUsers.length === 0) {
            alert("정지 해제할 회원을 선택해주세요.");
            return;
        }
        
        if (confirm("선택한 회원의 정지를 해제하시겠습니까?")) {
            $.ajax({
                type: "POST",
                url: "/admin/unsuspendUsers",
                data: { userIds: selectedUsers }, // 선택된 회원들의 userId 배열
                success: function(response) {
                    alert(response);
                    location.reload(); // 페이지 새로고침
                },
                error: function(xhr, status, error) {
                    alert("회원 정지 해제 중 오류가 발생했습니다.");
                    console.error(error);
                }
            });
        }
    }
    
</script>

<%@ include file="adfooter.jsp"%>