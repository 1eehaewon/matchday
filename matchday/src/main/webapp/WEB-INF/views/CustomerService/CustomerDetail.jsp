<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
$(document).ready(function() {
    // 주문 선택 시 referenceID 자동 입력
    $("#orderSelect").change(function() {
        var selectedValue = $(this).val();
        $("#referenceID").val(selectedValue);
    });

    // 디버깅을 위해 메시지를 로그로 출력
    console.log("message: ${message}");
    console.log("error: ${error}");

    // 수정 완료 또는 실패 메시지를 alert로 출력
    <c:if test="${not empty message}">
        alert("${message}");
        window.location.href = "${pageContext.request.contextPath}/CustomerService/CustomerPage";
    </c:if>
    <c:if test="${not empty error}">
        alert("${error}");
    </c:if>

    // 관리자인 경우 답변하기 버튼 추가
    <c:if test="${empty inquiry.inquiryReply}">
        $("#replySection").show();
    </c:if>
});

function deleteInquiry(inquiryID) {
    if (confirm("정말로 이 문의글을 삭제하시겠습니까?")) {
        $.ajax({
            url: "${pageContext.request.contextPath}/CustomerService/delete/" + inquiryID,
            type: 'POST',
            success: function(response) {
                alert("문의글이 삭제되었습니다.");
                window.location.href = "${pageContext.request.contextPath}/CustomerService/CustomerPage";
            },
            error: function(xhr, status, error) {
                console.error("삭제 요청 중 오류 발생:", error);
                alert("삭제에 실패하였습니다.");
            }
        });
    }
}

function addReply(inquiryID) {
    var replyContent = $("#replyContent").val();
    if (replyContent.trim() === "") {
        alert("답변 내용을 입력해주세요.");
        return;
    }

    $.ajax({
        url: "${pageContext.request.contextPath}/CustomerService/addReply",
        type: 'POST',
        data: {
            inquiryID: inquiryID,
            replyContent: replyContent
        },
        success: function(response) {
            if (response.status === "success") {
                alert("답변이 등록되었습니다.");
                window.location.href = "${pageContext.request.contextPath}/CustomerService/CustomerPage";
            } else {
                alert(response.message);
            }
        },
        error: function(xhr, status, error) {
            console.error("답변 등록 중 오류 발생:", error);
            alert("답변 등록에 실패하였습니다.");
        }
    });
}
</script>

<div class="main-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <!-- 문의 목록으로 돌아가기 버튼 -->
                <div class="text-center mb-4">
                    <a href="${pageContext.request.contextPath}/CustomerService/CustomerPage" class="btn btn-outline-primary btn-lg">문의목록</a>
                </div>
                <!-- 문의글 상세 정보 카드 -->
                <div class="card shadow-card border-0 rounded-lg">
                    <div class="card-header custom-card-header">
                        <h2 class="mb-0 fw-bold">문의글 상세정보</h2>
                    </div>
                    <div class="card-body p-5">
                        <!-- 문의글 상세 정보 폼 -->
                        <form name="customerDetailForm" id="customerDetailForm" method="post" action="${pageContext.request.contextPath}/CustomerService/update" enctype="multipart/form-data">
                            <div class="mb-4">
                                <label for="inquiryID" class="form-label custom-form-label">문의 ID</label>
                                <input type="text" name="inquiryID" id="inquiryID" value="${inquiry.inquiryID}" readonly class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="category" class="form-label custom-form-label">카테고리</label>
                                <select name="category" id="category" class="form-select custom-form-control" required>
                                    <option value="">카테고리를 선택하세요</option>
                                    <option value="goods" ${inquiry.boardType == 1 ? 'selected' : ''}>상품문의</option>
                                    <option value="match" ${inquiry.boardType == 2 ? 'selected' : ''}>경기문의</option>
                                    <option value="delivery" ${inquiry.boardType == 3 ? 'selected' : ''}>배송문의</option>
                                    <option value="patment" ${inquiry.boardType == 4 ? 'selected' : ''}>주문/결제</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label for="referenceID" class="form-label custom-form-label">주문 / 예매번호</label>
                                <input type="text" name="referenceID" id="referenceID" value="${inquiry.referenceID}" readonly class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="userID" class="form-label custom-form-label">회원 ID</label>
                                <input type="text" name="userID" id="userID" value="${inquiry.userID}" readonly class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="title" class="form-label custom-form-label">제목</label>
                                <input type="text" name="title" id="title" value="${inquiry.title}" class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="content" class="form-label custom-form-label">내용</label>
                                <textarea name="content" id="content" class="form-control custom-form-control">${inquiry.content}</textarea>
                            </div>
                            <div class="mb-4">
                                <label for="inqpasswd" class="form-label custom-form-label">비밀번호</label>
                                <input type="password" name="inqpasswd" id="inqpasswd" value="${inquiry.inqpasswd}" class="form-control custom-form-control">
                            </div>
                            <div class="d-flex justify-content-end mt-5">
                                <button type="submit" class="btn btn-primary btn-lg custom-button me-2">수정하기</button>
                                <button type="button" class="btn btn-danger btn-lg custom-button" onclick="deleteInquiry(${inquiry.inquiryID})">삭제하기</button>
                            </div>
                        </form>
                        <!-- 관리자용 답변 입력 섹션 -->
                        <div id="replySection" style="display: none;">
                            <hr>
                            <h3>답변하기</h3>
                            <div class="mb-4">
                                <label for="replyContent" class="form-label custom-form-label">답변 내용</label>
                                <textarea id="replyContent" class="form-control custom-form-control"></textarea>
                            </div>
                            <div class="d-flex justify-content-end">
                                <button type="button" class="btn btn-primary btn-lg custom-button" onclick="addReply(${inquiry.inquiryID})">답변 등록</button>
                            </div>
                        </div>

                        <!-- 답변 내용 표시 섹션 -->
                        <c:if test="${not empty inquiry.inquiryReply}">
                            <div class="reply-section">
                                <div class="reply-header">
                                    <h3 class="mb-0">관리자 답변</h3>
                                </div>
                                <div class="reply-content">
                                    <p>${inquiry.inquiryReply}</p>
                                    <div class="reply-date">
                                        답변 시간: <c:out value="${inquiry.formattedReplyDate}" />
                                    </div>
                                </div>
                            </div>
                        </c:if>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>


<%@ include file="../footer.jsp" %>
