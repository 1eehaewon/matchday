<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="ko">
<head>
<title>MatchDay 마이페이지</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link
	href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css"
	rel="stylesheet">
<script
	src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/js/jquery-3.7.1.min.js"></script>
<script src="/js/script.js"></script>
<link href="/css/styles.css" rel="stylesheet" type="text/css">
</head>
<body>
	<div class="container">
		<h2>마이페이지</h2>
		<form id="myPageForm" action="/member/mypage/edit" method="post">
			<table class="table table-bordered">
				<tr>
					<th><label for="userID" class="form-label">아이디</label></th>
					<td><input type="text" class="form-control" id="userID"
						name="userID" value="${user.userID}" readonly></td>
				</tr>
				<tr>
					<th><label for="email" class="form-label">이메일</label></th>
					<td><input type="email" class="form-control" id="email"
						name="email" value="${user.email}" required></td>
				</tr>
				<tr>
					<th><label for="zipcode" class="form-label">주소</label></th>
					<td><input type="text" class="form-control" id="zipcode"
						name="zipcode" placeholder="우편번호" value="${user.zipcode}">
						<input type="text" class="form-control mt-2" id="address1"
						name="address1" placeholder="기본 주소" value="${user.address1}">
						<input type="text" class="form-control mt-2" id="address2"
						name="address2" placeholder="상세 주소" value="${user.address2}"></td>
				</tr>
				<tr>
					<th><label for="number" class="form-label">전화번호</label></th>
					<td><input type="text" class="form-control" id="number"
						name="number" value="${user.number}" required></td>
				</tr>
				<tr>
					<th><label for="point" class="form-label">포인트</label></th>
					<td><input type="text" class="form-control" id="point"
						name="point" value="${user.points}" required readonly></td>
				</tr>
			</table>
			<div class="d-flex justify-content-between">
				<button type="submit" class="btn btn-primary">수정하기</button>
				<a href="/home.do" class="btn btn-secondary">취소</a>
				<!-- 회원 탈퇴 버튼 -->
				<button id="deleteButton" class="btn btn-danger">회원탈퇴</button>
			</div>
		</form>
	</div>

	<script>
    // 회원탈퇴 버튼 클릭 시
	document.addEventListener('DOMContentLoaded', function() {
		// 서버에서 전달된 메시지를 확인하고 alert 창으로 표시
	    var message = "${message}";
	    if (message) {
	        alert(message);
	    }
		
    	document.getElementById('deleteButton').addEventListener('click', function(event) {
        	event.preventDefault(); // 기본 동작(폼 제출) 방지
        
        	if (confirm('정말로 회원탈퇴 하시겠습니까?')) {
            	document.getElementById('myPageForm').action = '/member/mypage/delete'; // 삭제 페이지 경로로 변경
            	document.getElementById('myPageForm').submit(); // 폼 제출
        	}
    	});
	});
	</script>
</body>
</html>
