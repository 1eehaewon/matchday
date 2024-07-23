<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    .signup-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background-color: #f8f9fa;
        padding: 30px 10px;
    }
    .signup-form {
        width: 100%;
        max-width: 600px; /* 최대 너비 */
        padding: 30px;
        border: 1px solid #ccc;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        background-color: #fff;
    }
    .signup-title {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
        font-weight: bold;
        color: #333;
    }
    .form-group {
        margin-bottom: 15px;
    }
    .form-table {
        width: 100%;
    }
    .form-table th, .form-table td {
        padding: 8px;
        vertical-align: middle;
    }
    .form-table th {
        text-align: left;
    }
    @media (max-width: 768px) {
        .form-table th, .form-table td {
            display: block;
            width: 100%;
            text-align: left;
        }
        .form-table th {
            margin-top: 10px;
        }
        .form-table td {
            margin-bottom: 10px;
        }
    }
    .input-group {
        display: flex;
        align-items: center;
    }
    .input-group input {
        flex: 1;
    }
    .input-group button {
        margin-left: 10px;
    }
</style>
<div class="signup-container">
    <h2 class="signup-title">회원가입</h2>
    <div class="signup-form">
        <form id="signup-form" action="/member/join/insert" method="post" onsubmit="return validateForm()">
            <table class="form-table">
                <tr>
                    <th><label for="userID">아이디</label></th>
                    <td>
                        <div class="input-group">
                            <input type="text" id="userID" name="userID" class="form-control" required pattern="^[a-zA-Z0-9]{6,20}$" placeholder="(6~20자 영문, 숫자)">
                            <button type="button" class="btn btn-info" onclick="idCheck()">ID중복확인</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="password">비밀번호</label></th>
                    <td>
                        <input type="password" id="password" name="password" class="form-control" required placeholder="(8~12자 영문, 숫자, 특수문자)" oninput="pwCheck(); validatePassword();">
                        <span id="password-validation-message"></span>
                    </td>
                </tr>
                <tr>
                    <th><label for="confirmPassword">비밀번호 확인</label></th>
                    <td>
                        <input type="password" id="confirmPassword" name="confirmPassword" class="form-control" required placeholder="비밀번호를 다시 입력하세요" oninput="pwCheck()">
                        <span id="password-match-message"></span>
                    </td>
                </tr>
                <tr>
                    <th><label for="name">이름</label></th>
                    <td>
                        <input type="text" id="name" name="name" class="form-control" required placeholder="이름을 입력하세요">
                    </td>
                </tr>
                <tr>
                    <th><label>성별</label></th>
                    <td>
                        <div class="form-check form-check-inline">
                            <input type="radio" id="male" name="gender" value="M" class="form-check-input">
                            <label for="male" class="form-check-label">남성</label>
                        </div>
                        <div class="form-check form-check-inline">
                            <input type="radio" id="female" name="gender" value="F" class="form-check-input">
                            <label for="female" class="form-check-label">여성</label>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="emailID">이메일</label></th>
                    <td>
                        <div class="input-group">
                            <input type="text" id="emailID" name="emailID" class="form-control" required placeholder="이메일 아이디를 입력하세요">
                            <span class="input-group-text">@</span>
                            <input type="text" id="emailDomain" name="emailDomain" class="form-control" placeholder="도메인을 입력하세요">
                            <select id="emailDomainSelect" name="emailDomainSelect" class="form-select">
                                <option value="" selected>직접입력</option>
                                <option value="naver.com">naver.com</option>
                                <option value="gmail.com">gmail.com</option>
                                <option value="hanmail.net">hanmail.net</option>
                                <option value="nate.com">nate.com</option>
                            </select>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th><label for="number">전화번호</label></th>
                    <td>
                        <input type="tel" id="number" name="number" class="form-control" required pattern="^010-\d{4}-\d{4}$" placeholder="전화번호 (-포함)">
                    </td>
                </tr>
                <tr>
                    <th>우편번호</th>
                    <td>
                        <div class="input-group">
                            <input type="text" name="zipcode" id="zipcode" class="form-control" readonly>
                            <button type="button" class="btn btn-info" id="editAddressBtn" onclick="DaumPostcode()">주소찾기</button>
                        </div>
                    </td>
                </tr>
                <tr>
                    <th>주소</th>
                    <td>
                        <input type="text" name="address1" id="address1" class="form-control" readonly>
                    </td>
                </tr>
                <tr>
                    <th>나머지주소</th>
                    <td>
                        <input type="text" name="address2" id="address2" class="form-control">
                    </td>
                </tr>
                
                <tr>
                    <td colspan="2" class="text-center">
                        <button type="submit" class="btn btn-primary">회원가입</button>
                    </td>
                </tr>
            </table>
        </form>
    </div>
</div>

<!-- Modal -->
<div class="modal fade" id="myModal" role="dialog">
    <div class="modal-dialog">
        <!-- Modal content-->
        <div class="modal-content">
            <div class="modal-header">
                <h4 class="modal-title">ID중복확인</h4>
            </div>
            <div class="modal-body" id="modal-body">
                <p><!-- 표시할 메시지 --></p>
            </div>
            <div class="modal-footer">
                <!-- 표시할 버튼 -->
            </div>
        </div>
    </div>
</div>
<!-- Modal end -->

<!-- ----- DAUM 우편번호 API 시작 ----- -->
<div id="wrap" style="display: none; border: 1px solid; width: 500px; height: 300px; margin: 5px 0; position: relative">
    <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap"
         style="cursor: pointer; position: absolute; right: 0px; top: -1px; z-index: 1" onclick="foldDaumPostcode()" alt="접기 버튼">
</div>

<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<%@ include file="../footer.jsp" %>
