<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>비밀번호 찾기</title>
    <link rel="stylesheet" href="/css/styles.css">
    <link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
    <style>
        body {
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            background-color: #f8f9fa;
        }
        .find-password-container {
            width: 100%;
            max-width: 400px; /* 폼의 최대 너비 설정 */
            padding: 20px;
            background-color: #fff;
            border: 1px solid #ccc;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .find-password-container h2 {
            text-align: center;
            margin-bottom: 20px;
        }
        .form-group {
            margin-bottom: 15px;
        }
        .form-group label {
            font-weight: bold;
        }
        .form-control {
            width: 100%;
            padding: 10px;
            font-size: 16px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }
        .btn-primary {
            width: 100%;
            padding: 10px;
            font-size: 16px;
        }
        .matchday-box {
            background-color: #007bff; /* 파란색 배경 */
            color: #fff;
            padding: 10px;
            border-radius: 8px;
            width: 100%;
            max-width: 400px; /* 최대 너비 설정 */
            text-align: center;
            margin: 0 auto; /* 가운데 정렬 */
        }
    </style>
    <script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
    <script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
    <script>
        function findPassword(event) {
            event.preventDefault();

            const form = document.getElementById('find-password-form');
            const formData = new FormData(form);

            fetch('/member/findPassword.do', {
                method: 'POST',
                body: formData
            })
            .then(response => response.json())
            .then(data => {
                alert(data.message);
                if (data.message === "비밀번호 재설정 링크가 이메일로 전송되었습니다.") {
                    window.location.href = "/member/login";
                }
            })
            .catch(error => {
                console.error('Error:', error);
                alert('An error occurred: ' + error.message);
            });
        }
    </script>
</head>
<body>
    <div class="matchday-box">
        <a href="/" class="home-link" style="color: white; font-size: 24px;">matchday</a>
    </div>
    <div class="find-password-container">
        <h2>비밀번호 찾기</h2>
        <form id="find-password-form" onsubmit="findPassword(event)">
            <div class="form-group">
                <label for="userID">아이디</label>
                <input type="text" id="userID" name="userID" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">비밀번호 찾기</button>
        </form>
    </div>
</body>
</html>
