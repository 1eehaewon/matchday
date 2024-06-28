<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <h2 class="text-center">FAQ 작성</h2>
    <form action="/customerService/insertFaq" method="post">
        <div class="mb-3">
            <label for="title" class="form-label">질문</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">답변</label>
            <textarea class="form-control" id="content" name="content" rows="5" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">저장하기</button>
    </form>
</div>

<%@ include file="../footer.jsp" %>
