<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>
<div class="container-fluid px-4">
	<h1 class="mt-4">회원목록조회</h1>
	<ol class="breadcrumb mb-4">
	</ol>

	<div class="card mb-4">
		<div class="card-header">
			<i class="fas fa-table me-1"></i> 회원목록
		</div>
		<div class="card-body">
			<table id="datatablesSimple">
				<thead>
					<tr>
						<th>아이디</th>
						<th>이름</th>
						<th>이메일</th>
						<th>등급</th>
						<th>가입생성일</th>
						<th>총 사용한 금액</th>
					</tr>
				</thead>
				<tbody>
				<!-- var.아이템에서가져온값 -->
					<c:forEach var="user" items="${users}">
						<tr>
							<td>${user.userid}</td>
							<td>${user.name}</td>
							<td>${user.email}</td>
							<td>${user.grade}</td>
							<td>${user.joinDate}</td>
							<td></td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
	</div>
</div>
<%@ include file="adfooter.jsp"%>