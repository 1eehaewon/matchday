<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <h2 class="text-center">FAQ 상세</h2>
    <form action="/customerService/updateFaq" method="post">
        <input type="hidden" name="inquiryID" value="${faq.inquiryID}">
        <div class="mb-3">
            <label for="title" class="form-label">질문</label>
            <input type="text" class="form-control" id="title" name="title" value="${faq.title}" required>
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">답변</label>
            <textarea class="form-control" id="content" name="content" rows="5" required>${faq.content}</textarea>
        </div>
        <div class="mb-3">
            <label for="userID" class="form-label">작성자 ID</label>
            <input type="text" class="form-control" id="userID" name="userID" value="${faq.userID}" readonly>
        </div>
        <div class="d-flex justify-content-between">
            <button type="submit" class="btn btn-primary">수정하기</button>
            <button type="button" class="btn btn-danger" onclick="deleteFaq(${faq.inquiryID})">삭제하기</button>
        </div>
    </form>
</div>

<script>
function deleteFaq(inquiryID) {
    if (confirm("정말로 이 FAQ를 삭제하시겠습니까?")) {
        $.ajax({
            url: "/customerService/deleteFaq/" + inquiryID,
            type: 'POST',
            success: function(response) {
                alert("FAQ가 삭제되었습니다.");
                window.location.href = "/customerService/customerFaq";
            },
            error: function(xhr, status, error) {
                console.error("삭제 요청 중 오류 발생:", error);
                alert("삭제에 실패하였습니다.");
            }
        });
    }
}
</script>

<%@ include file="../footer.jsp" %>
