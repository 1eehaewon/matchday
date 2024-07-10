<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    .edit-container {
        display: flex;
        flex-direction: column;
        justify-content: center;
        align-items: center;
        min-height: 100vh;
        background-color: #f8f9fa;
        padding: 30px 10px;
    }
    .edit-form {
        width: 100%;
        max-width: 600px; /* 최대 너비 */
        padding: 30px;
        border: 1px solid #ccc;
        border-radius: 10px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        background-color: #fff;
    }
    .edit-title {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
        font-weight: bold;
        color: #333;
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
<div class="edit-container">
    <h2 class="edit-title">회원정보 수정</h2>
    <div class="edit-form">
        <form id="editForm" action="/member/mypage" method="post" onsubmit="return validateEditForm()">
            <table class="table table-bordered">
                <tr>
                    <th><label for="password">새 비밀번호</label></th>
                    <td>
                        <input type="password" class="form-control" id="password" name="password"
                            placeholder="새 비밀번호" oninput="pwCheck(); validatePassword();">
                        <div><span id="password-validation-message"></span></div>
                    </td>
                </tr>
                <tr>
                    <th><label for="confirmPassword">비밀번호 확인</label></th>
                    <td>
                        <input type="password" class="form-control" id="confirmPassword" name="confirmPassword"
                            placeholder="비밀번호 확인" oninput="pwCheck()">
                        <div id="password-match-message" class="message"></div>
                    </td>
                </tr>
                <tr>
                    <th><label for="email">이메일</label></th>
                    <td><input type="email" class="form-control" id="email" name="email" value="${user.email}" required></td>
                </tr>
                <tr>
                    <th><label for="zipcode">주소</label></th>
                    <td>
                        <div class="input-group">
                            <input type="text" class="form-control" id="zipcode" name="zipcode"
                                placeholder="우편번호" value="${user.zipcode}">
                            <button type="button" class="btn btn-outline-secondary" id="editAddressBtn" onclick="DaumPostcode()">편집</button>
                        </div>
                        <input type="text" class="form-control mt-2" id="address1" name="address1"
                            placeholder="기본 주소" value="${user.address1}">
                        <input type="text" class="form-control mt-2" id="address2" name="address2"
                            placeholder="상세 주소" value="${user.address2}">
                    </td>
                </tr>
                <tr>
                    <th><label for="number">전화번호</label></th>
                    <td><input type="text" class="form-control" id="number" name="number" value="${user.number}" required></td>
                </tr>
            </table>
            <div class="d-flex justify-content-between">
                <button type="submit" class="btn btn-primary">저장하기</button>
                <a href="/member/mypage" class="btn btn-secondary">취소</a>
            </div>
        </form>
    </div>
</div>

<!-- DAUM 우편번호 API -->
<div id="wrap" style="display: none; border: 1px solid; width: 500px; height: 300px; margin: 5px 0; position: relative">
    <img src="//t1.daumcdn.net/postcode/resource/images/close.png" id="btnFoldWrap"
        style="cursor: pointer; position: absolute; right: 0px; top: -1px; z-index: 1" onclick="foldDaumPostcode()" alt="접기 버튼">
</div>
<script src="//t1.daumcdn.net/mapjsapi/bundle/postcode/prod/postcode.v2.js"></script>

<%@ include file="../footer.jsp" %>
