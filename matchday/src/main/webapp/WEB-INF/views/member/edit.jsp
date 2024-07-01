<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
<title>회원정보 수정</title>
<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
<script src="/js/jquery-3.7.1.min.js"></script>
<script src="/js/script.js"></script>
<link href="/css/styles.css" rel="stylesheet" type="text/css">
</head>
<body>
    <div class="container">
        <h2>회원정보 수정</h2>		<!-- action : 이동할 url -->
        <form id="editForm" action="/member/mypage" method="post" onsubmit="return validateEditForm()">
            <table class="table table-bordered">
                <tr>
					<th><label for="password" class="form-label">비밀번호</label></th>
					<td><input type="password" class="form-control" id="password" name="password"
						placeholder="새 비밀번호" oninput="pwCheck(); validatePassword();">
						<div><span id="password-validation-message"></span></div></td>
				</tr>
				<tr>
					<th><label for="confirmPassword" class="form-label">비밀번호 확인</label></th>
					<td><input type="password" class="form-control" id="confirmPassword"
						name="confirmPassword" placeholder="비밀번호 확인" oninput="pwCheck()">
						<div id="password-match-message" class="message"></div></td>
				</tr>
                <tr>
                    <th><label for="email" class="form-label">이메일</label></th>
                    <td><input type="email" class="form-control" id="email" name="email" value="${user.email}" required></td>
                </tr>
                
                <tr>
					<th><label for="zipcode" class="form-label">주소</label>
					<button type="button" class="btn btn-outline-secondary"
							id="editAddressBtn" onclick="DaumPostcode()">편집</button></th>
					<td><input type="text" class="form-control" id="zipcode" name="zipcode"
							placeholder="우편번호" value="${user.zipcode}"> 
						<input type="text" class="form-control mt-2" id="address1" name="address1"
							placeholder="기본 주소" value="${user.address1}"> 
						<input type="text" class="form-control mt-2" id="address2" name="address2"
							placeholder="상세 주소" value="${user.address2}"></td>
				</tr>
                <tr>
                    <th><label for="number" class="form-label">전화번호</label></th>
                    <td><input type="text" class="form-control" id="number" name="number" value="${user.number}" required></td>
                </tr>
            </table>
            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-primary">저장하기</button>
                <a href="/member/mypage" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
    <!-- ----- DAUM 우편번호 API 시작 ----- -->
	<div id="wrap"
		style="display: none; border: 1px solid; width: 500px; height: 300px; margin: 5px 0; position: relative">
		<img src="//t1.daumcdn.net/postcode/resource/images/close.png"
			id="btnFoldWrap"
			style="cursor: pointer; position: absolute; right: 0px; top: -1px; z-index: 1"
			onclick="foldDaumPostcode()" alt="접기 버튼">
	</div>

	<script
		src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>
    
</body>
</html>
