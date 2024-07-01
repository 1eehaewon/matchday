<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!-- 로그인 폼 -->
<!DOCTYPE html>
<html lang="ko">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>로그인</title>
<link rel="stylesheet" href="/css/styles.css">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/css/bootstrap.min.css">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>
<script src="/js/script.js"></script>
</head>
<body>
    <div class="login-container">
        <h2>로그인</h2>
        <!-- 마이페이지에 로그인이 안되어있을 때 alert창 -->
         <c:if test="${not empty message}">
            <script type="text/javascript">
                document.addEventListener('DOMContentLoaded', function() {
                    var message = "${message}";
                    if (message.trim() !== '') {
                        alert(message);
                    }
                });
            </script>
        </c:if>
        <form id="login-form" method="post" action="/member/login.do">
            <div class="form-group">
                <label for="userID">아이디</label>
                <input type="text" id="userID" name="userID" class="form-control" required>
            </div>
            <div class="form-group">
                <label for="password">비밀번호</label>
                <input type="password" id="password" name="password" class="form-control" required>
            </div>
            <button type="submit" class="btn btn-primary">로그인</button>
            <!-- 로그인 실패 alert -->
            <% if (request.getAttribute("alert") != null && (boolean) request.getAttribute("alert")) { %>
            <script>
                alert("${errorMessage}");
            </script>
        <% } %>
        </form>
    </div>
</body>
</html>