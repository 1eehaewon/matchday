<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!-- 회원가입 폼 -->
<!DOCTYPE html>
<html lang="ko">

<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>회원가입</title>
<link rel="stylesheet" href="/css/styles.css">
<link rel="stylesheet"
	href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script
	src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script
	src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="/js/script.js" defer></script>
<!-- static까지 root : / -->
</head>

<body>
	<div class="signup-container">
		<h2>회원가입</h2>
										<!-- 멤버폴더의 join.jsp, 매핑된 insert실행 -->
		<form id="signup-form" action="/member/join/insert" method="post"
			onsubmit="return validateForm()">
			<table>
				<tr>
					<td><label for="userID">아이디</label></td>
					<td><input type="text" id="userID" name="userID" required
						pattern="^[a-zA-Z0-9]{6,20}$" placeholder="(6~20자 영문, 숫자)">
						<button type="button" class="btn btn-info" onclick="idCheck()">ID중복확인</button>
				</tr>
				<tr>
					<td><label for="password">비밀번호</label></td>
					<td><input type="password" id="password" name="password"
						required placeholder="(8~12자 영문, 숫자, 특수문자)"
						oninput="pwCheck(); validatePassword();"></td>
					<td><span id="password-validation-message"></span></td>
				</tr>
				<tr>
					<td><label for="confirmPassword">비밀번호 확인</label></td>
					<td><input type="password" id="confirmPassword"
						name="confirmPassword" required placeholder="비밀번호를 다시 입력하세요"
						oninput="pwCheck()"></td>
					<td><span id="password-match-message" class="message"></span></td>
				</tr>
				<tr>
					<td><label for="name">이름</label></td>
					<td><input type="text" id="name" name="name" required
						placeholder="이름을 입력하세요"></td>
				</tr>
				<tr>
					<td><label>성별</label></td>
					<td><label> <input type="radio" name="gender"
							value="M"> 남성
					</label> <label> <input type="radio" name="gender" value="F">
							여성
					</label></td>
				</tr>
				<tr>
					<td><label for="emailID">이메일</label></td>
					<td><input type="text" id="emailID" name="emailID" required
						placeholder="이메일 아이디를 입력하세요"> @ <input type="text"
						id="emailDomain" name="emailDomain" placeholder="도메인을 입력하세요"
						class="hidden"> <select id="emailDomainSelect"
						name="emailDomainSelect">
							<option value="" selected>직접입력</option>
							<option value="naver.com">naver.com</option>
							<option value="gmail.com">gmail.com</option>
							<option value="hanmail.net">hanmail.net</option>
							<option value="nate.com">nate.com</option>
					</select></td>
				</tr>
				<tr>
					<td><label for="number">전화번호</label></td>
					<td><input type="tel" id="number" name="number" required
						pattern="^010-\d{4}-\d{4}$" placeholder="전화번호 (-포함)"></td>
				</tr>
				<tr>
					<th>우편번호</th>
					<td style="text-align: left">
						<div class="col-xs-5">
							<input type="text" name="zipcode" id="zipcode" readonly
								class="form-control">
						</div>
						<div class="col-xs-3">
							<input type="button" value="주소찾기" id="editAddressBtn" onclick="DaumPostcode()"
								class="btn btn-info">
						</div>
					</td>
				</tr>
				<tr>
					<th>주소</th>
					<td style="text-align: left">
						<div class="col-xs-10">
							<input type="text" name="address1" id="address1" readonly
								class="form-control">
						</div>
					</td>
				</tr>
				<tr>
					<th>나머지주소</th>
					<td style="text-align: left">
						<div class="col-xs-10">
							<input type="text" name="address2" id="address2" size="45"
								class="form-control">
						</div>
					</td>
				</tr>
				<tr>
					<td colspan="2">
						<div class="checkbox-group">
							<label> <input type="checkbox" id="smsEmailConsent"
								name="smsEmailConsent"> SMS, 이메일로 상품 및 이벤트 정보를 받겠습니다.
								(선택)
							</label>
					</td>
				</tr>
				<tr>
					<td><label> <input type="checkbox" id="under14"
							name="under14"> 14세 미만입니다.
					</label>
						</div></td>
				</tr>
				<tr id="guardianConsent" class="hidden">
					<td colspan="2">
						<p>만 14세 미만 회원은 법정대리인(부모님) 동의를 받은 경우만 회원가입이 가능합니다.</p> <!-- 추가적인 법정대리인 동의 정보 입력란을 여기에 추가할 수 있습니다 -->
					</td>
				</tr>
				<tr>
					<td colspan="2"><button type="submit">회원가입</button></td>
				</tr>
			</table>
		</form>
	</div>

	<!-- Modal -->
	<div class="modal fade" id="myModal" role="dialog">
		<div class="modal-dialog">

			<!-- Modal content-->
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">&times;</button>
					<h4 class="modal-title">ID중복확인</h4>
				</div>
				<div class="modal-body" id="modal-body">
					<p>
						<!-- 표시할 메시지 -->
					</p>
				</div>
				<div class="modal-footer">
					<!-- 표시할 버튼 -->
				</div>
			</div>

		</div>
	</div>
	<!-- Modal end -->
</body>
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

</html>