//script.js

document.addEventListener('DOMContentLoaded', function() {
	const emailDomainSelect = document.getElementById('emailDomainSelect');
	const customEmailDomainInput = document.getElementById('emailDomain');
	const emailIDInput = document.getElementById('emailID');

	// Set initial state to show the custom email domain input
	customEmailDomainInput.classList.remove('hidden');
	customEmailDomainInput.required = true;

	emailDomainSelect.addEventListener('change', function() {
		if (emailDomainSelect.value === "") { // 직접입력 선택 시
			customEmailDomainInput.classList.remove('hidden');
			customEmailDomainInput.required = true;
			customEmailDomainInput.value = ""; // 입력 필드를 비웁니다.
		} else {
			customEmailDomainInput.classList.add('hidden');
			customEmailDomainInput.required = false;
			customEmailDomainInput.value = emailDomainSelect.value; // 선택한 도메인 값을 입력 필드에 넣습니다.
		}
	});

	customEmailDomainInput.addEventListener('input', function() {
		updateEmailID();
	});

	emailIDInput.addEventListener('input', function() {
		updateEmailID();
	});

	function updateEmailID() {
		const emailID = emailIDInput.value;
		const emailDomain = emailDomainSelect.value || customEmailDomainInput.value;
		if (emailDomain) {
			console.log(`${emailID}@${emailDomain}`);
		}
	}
});

document.addEventListener("DOMContentLoaded", function() {
	// 우편번호 찾기 찾기 화면을 넣을 element
	var element_wrap = document.getElementById('wrap');

	function foldDaumPostcode() {
		// iframe을 넣은 element를 안보이게 한다.
		element_wrap.style.display = 'none';
	}

	function DaumPostcode() {
		// 현재 scroll 위치를 저장해놓는다.
		var currentScroll = Math.max(document.body.scrollTop,
			document.documentElement.scrollTop);
		new daum.Postcode({
			oncomplete: function(data) {
				// 검색결과 항목을 클릭했을때 실행할 코드를 작성하는 부분.

				// 각 주소의 노출 규칙에 따라 주소를 조합한다.
				// 내려오는 변수가 값이 없는 경우엔 공백('')값을 가지므로, 이를 참고하여 분기 한다.
				var addr = ''; // 주소 변수
				var extraAddr = ''; // 참고항목 변수

				//사용자가 선택한 주소 타입에 따라 해당 주소 값을 가져온다.
				if (data.userSelectedType === 'R') { // 사용자가 도로명 주소를 선택했을 경우
					addr = data.roadAddress;
				} else { // 사용자가 지번 주소를 선택했을 경우(J)
					addr = data.jibunAddress;
				}

				// 사용자가 선택한 주소가 도로명 타입일때 참고항목을 조합한다.
				if (data.userSelectedType === 'R') {
					// 법정동명이 있을 경우 추가한다. (법정리는 제외)
					// 법정동의 경우 마지막 문자가 "동/로/가"로 끝난다.
					if (data.bname !== '' && /[동|로|가]$/g.test(data.bname)) {
						extraAddr += data.bname;
					}
					// 건물명이 있고, 공동주택일 경우 추가한다.
					if (data.buildingName !== '' && data.apartment === 'Y') {
						extraAddr += (extraAddr !== '' ? ', '
							+ data.buildingName : data.buildingName);
					}
					// 표시할 참고항목이 있을 경우, 괄호까지 추가한 최종 문자열을 만든다.
					if (extraAddr !== '') {
						extraAddr = ' (' + extraAddr + ')';
					}
					// 조합된 참고항목을 해당 필드에 넣는다.
					document.getElementById("address2").value = extraAddr;

				} else {
					document.getElementById("address2").value = '';
				}

				// 우편번호와 주소 정보를 해당 필드에 넣는다.
				document.getElementById('zipcode').value = data.zonecode;
				document.getElementById("address1").value = addr;
				// 커서를 상세주소 필드로 이동한다.
				document.getElementById("address2").focus();

				// iframe을 넣은 element를 안보이게 한다.
				// (autoClose:false 기능을 이용한다면, 아래 코드를 제거해야 화면에서 사라지지 않는다.)
				element_wrap.style.display = 'none';

				// 우편번호 찾기 화면이 보이기 이전으로 scroll 위치를 되돌린다.
				document.body.scrollTop = currentScroll;
			},
			// 우편번호 찾기 화면 크기가 조정되었을때 실행할 코드를 작성하는 부분. iframe을 넣은 element의 높이값을 조정한다.
			onresize: function(size) {
				element_wrap.style.height = size.height + 'px';
			},
			width: '100%',
			height: '100%'
		}).embed(element_wrap);

		// iframe을 넣은 element를 보이게 한다.
		element_wrap.style.display = 'block';
	}
	// 이벤트 리스너 추가
	document.getElementById('editAddressBtn').addEventListener('click', DaumPostcode);
	document.getElementById('btnFoldWrap').addEventListener('click', foldDaumPostcode);
});
/*<!-- ----- DAUM 우편번호 API 종료----- -->*/

function validateForm() { //회원가입폼 유효성검사

	// 아이디 중복 확인 여부 검사
	if (!isIdChecked) {
		alert('아이디 중복 확인을 해주세요.');
		return false; // 폼 전송을 중지
	}

	var password = document.getElementById("password").value;
	var confirmPassword = document.getElementById("confirmPassword").value;

	// 비밀번호와 비밀번호 확인 필드의 값이 일치하는지 확인
	if (password !== confirmPassword) {
		alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		return false; // 폼 전송을 중지
	}

	// 성별 선택 여부 검사
	if (!validateGender()) {
		return false; // 성별 선택되지 않은 경우 폼 전송 중지
	}


	// 휴대폰 번호
	var number = document.getElementById('number').value;
	if (!number.match(/^010-\d{4}-\d{4}$/)) {
		alert('휴대폰 번호는 010-xxxx-xxxx 형식으로 입력해야 합니다.');
		return false;
	}

	// 이메일
	var emailID = document.getElementById('emailID').value;
	if (!emailID.match(/^[a-zA-Z0-9]+$/)) {
		alert('이메일 아이디는 영문과 숫자만 사용할 수 있습니다.');
		return false;
	}
	// 일치할 경우 폼을 전송
	return true;
}//validateForm() end

function idCheck() { //id 중복확인
	var userId = $('#userID').val(); // 입력된 아이디 값 가져오기

	// 아이디 길이 및 유효성 검사 (영문 대소문자와 숫자로만, 6~20자 사이)
	if (!/^[a-zA-Z0-9]{6,20}$/.test(userId)) {
		alert("아이디는 영문과 숫자로만, 6~20자 이내로 입력하세요.");
		return;
	}

	// AJAX 요청
	$.ajax({
		url: '/member/checkUserId', // 요청할 서버 URL 컨트롤러에서 RequestMapping한거 = member, checkUserId 매핑
		type: 'GET',
		data: { userId: userId }, // 전송할 데이터
		success: function(response) {
			$('#modal-body').html('<p>' + response + '</p>'); // 모달 본문에 결과 메시지 출력

			// 모달 footer의 기존 버튼 제거
			$('#myModal .modal-footer').empty();
			// 모달 footer에 버튼 추가
			if (response == "사용 가능한 아이디입니다.") {
				isIdChecked = true; // 아이디 중복 확인 완료 표시
				// 사용 가능한 아이디일 경우
				var useButton = $('<button>')
					.attr('type', 'button')
					.addClass('btn btn-success')
					.text('사용하기')
					.click(function() {
						// 사용 버튼 클릭 시 동작
						$('#userID').val(userId); // 아이디 입력 필드에 선택한 아이디 입력
						$('#myModal').modal('hide'); // 모달 닫기
						$('.check-mark').remove(); // 기존 체크 표시 삭제
						$('#userID').after('<span class="check-mark">✔</span>'); // 새로운 체크 표시 추가
					});
				$('#myModal .modal-footer').append(useButton); // 모달 footer에 버튼 추가
			} else {
				// 사용 불가능한 아이디일 경우
				var retryButton = $('<button>')
					.attr('type', 'button')
					.addClass('btn btn-danger')
					.text('다시 입력')
					.click(function() {
						// 다시 입력 버튼 클릭 시 동작
						$('#myModal').modal('hide'); // 모달 닫기
						$('#userID').val(''); // 아이디 입력 필드 초기화
						$('.check-mark').remove(); // 체크 표시도 함께 초기화
					});
				$('#myModal .modal-footer').append(retryButton); // 모달 footer에 버튼 추가
			}

			$('#myModal').modal('show'); // 모달 표시
		},
		error: function(xhr, status, error) {
			console.error('AJAX 요청 중 오류 발생: ' + error);
		}
	});
}

function validateGender() { //성별 선택했는지?
	const genderRadios = document.getElementsByName("gender");
	let isChecked = false;

	for (let i = 0; i < genderRadios.length; i++) {
		if (genderRadios[i].checked) {
			isChecked = true;
			break;
		}
	}
	if (!isChecked) {
		alert("성별을 선택하세요.");
		return false;
	}
}

//oninput에서 함수호출하려면 DOMContentLoaded 방식이용
document.addEventListener('DOMContentLoaded', function() {
	var passwordInput = document.getElementById('password');
	var confirmPasswordInput = document.getElementById('confirmPassword');

	passwordInput.addEventListener('input', function() {
		pwCheck();
		validatePassword();
	});

	confirmPasswordInput.addEventListener('input', function() {
		pwCheck();
	});

	function pwCheck() {
		var password = passwordInput.value;
		var confirmPassword = confirmPasswordInput.value;
		var matchMessage = document.getElementById('password-match-message');

		// 비밀번호가 입력되지 않은 경우 메시지를 초기화
		if (password.length === 0 || confirmPassword.length === 0) {
			$('#password-match-message').text('');
			return;
		}

		if (password === confirmPassword && password.length >= 8 && password.length <= 12) {
			matchMessage.textContent = '비밀번호가 일치합니다.';
			matchMessage.style.color = 'green';
		} else if (password !== confirmPassword) {
			matchMessage.textContent = '비밀번호가 일치하지 않습니다.';
			matchMessage.style.color = 'red';
		} else {
			matchMessage.textContent = '';
		}
	}

	function validatePassword() {
		var password = passwordInput.value;
		var validationMessage = document.getElementById('password-validation-message');
		// 비밀번호가 입력되지 않은 경우 메시지를 초기화
		if (password.length === 0) {
			$('#password-validation-message').text('');
			return;
		}
		if (password.length < 8 || password.length > 12) {
			validationMessage.textContent = '비밀번호는 8자에서 12자 사이여야 합니다.';
			validationMessage.style.color = 'red';
		} else {
			validationMessage.textContent = '';
		}
	}
});

function validateEditForm() { //수정폼유효성검사
	// 비밀번호 검사
	var password = document.getElementById("password").value;
	var confirmPassword = document.getElementById("confirmPassword").value;

	// 비밀번호 길이 확인
	if (password.length < 8 || password.length > 12) {
		alert("비밀번호는 8자에서 12자 사이여야 합니다.");
		return false;
	}

	// 비밀번호 일치 여부 확인
	if (password !== confirmPassword) {
		alert("비밀번호와 비밀번호 확인이 일치하지 않습니다.");
		return false;
	}

	// 이메일 유효성 검사 - 간단하게 @ 포함 여부만 확인
	var email = document.getElementById("email").value;
	if (email.indexOf("@") === -1) {
		alert("올바른 이메일 주소를 입력하세요.");
		return false;
	}

	// 우편번호, 기본 주소, 상세 주소 유효성 검사 (빈 값 여부만 확인)
	var zipcode = document.getElementById("zipcode").value;
	var address1 = document.getElementById("address1").value;
	var address2 = document.getElementById("address2").value;
	if (zipcode.trim() === "" || address1.trim() === "" || address2.trim() === "") {
		alert("주소 정보를 모두 입력하세요.");
		return false;
	}

	// 전화번호 유효성 검사 - 간단히 숫자로만 구성되었는지 확인
	var number = document.getElementById("number").value;
	if (!/^010-\d{4}-\d{4}$/.test(number)) {
		alert("전화번호는 형식에 맞게 (-포함) 입력하세요.");
		return false;
	}

	// 모든 유효성 검사 통과
	alert("정보가 수정되었습니다.");
	return true;
}//end


