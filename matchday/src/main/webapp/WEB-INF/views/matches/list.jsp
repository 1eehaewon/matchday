<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<!-- 본문 시작 list.jsp -->
<div class="container mt-4"> <!-- mt-4 클래스 추가하여 위쪽 여백 추가 -->
    <div class="row">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1>예매하기</h1>
            <c:if test="${sessionScope.grade == 'M'}">
                <button type="button" class="btn btn-success" onclick="location.href='write'">경기 일정 등록</button>
                <button type="button" class="btn btn-primary" onclick="location.href='/tickets/ticketspayment'">예매하기</button>
            </c:if>
        </div>
    </div>

<!-- 본문 끝 -->

<%@ include file="../footer.jsp" %>
