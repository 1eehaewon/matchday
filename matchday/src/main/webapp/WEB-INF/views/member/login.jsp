<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    .login-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        height: 80vh; /* 화면 높이의 80%를 사용하여 중앙에 배치 */
        background-color: #f8f9fa; /* 백그라운드 색상을 약간 회색으로 설정 */
    }
    .login-form {
        width: 100%;
        max-width: 400px; /* 최대 너비 설정 */
        padding: 30px;
        border: 1px solid #ccc;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        background-color: #fff; /* 폼 배경 색상을 흰색으로 설정 */
    }
    .login-title {
        text-align: center;
        margin-bottom: 20px; /* 제목 아래에 여백 추가 */
        font-size: 24px;
        font-weight: bold;
        color: #333;
    }
    .form-group {
        margin-bottom: 15px; /* 폼 그룹 아래에 여백 추가 */
    }
</style>
    <div class="login-container">
        <h4 class="login-title">로그인</h4>
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
        <div class="text-center mt-3">
            <a href="/member/findID">아이디 찾기</a> | <a href="/member/findPassword">비밀번호 찾기</a>
        </div>
    </div>
<%@ include file="../footer.jsp" %>