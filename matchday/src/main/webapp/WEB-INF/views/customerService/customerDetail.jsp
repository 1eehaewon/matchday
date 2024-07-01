<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
$(document).ready(function() {
    $("#orderSelect").change(function() {
        var selectedValue = $(this).val();
        $("#referenceID").val(selectedValue);
    });

    console.log("message: ${message}");
    console.log("error: ${error}");

    <c:if test="${not empty message}">
        alert("${message}");
        window.location.href = "/customerService/customerPage";
    </c:if>
    <c:if test="${not empty error}">
        alert("${error}");
    </c:if>

    // 답변 섹션을 회원 등급이 M인 경우에만 보이게 처리
    <c:if test="${sessionScope.userGrade == 'M'}">
        $("#replySection").show();
    </c:if>

    // Summernote 초기화
    $('.summernote').summernote({
        height: 300,
        lang: 'ko-KR',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
            onImageUpload: function(files) {
                sendFile(files[0]);
            }
        }
    });

    function sendFile(file) {
        var data = new FormData();
        data.append("file", file);
        $.ajax({
            url: '/customerService/uploadImage',
            method: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function(url) {
                $('.summernote').summernote('insertImage', url);
            },
            error: function() {
                alert('이미지 업로드 중 오류가 발생하였습니다.');
            }
        });
    }
});

function deleteInquiry(inquiryID) {
    if (confirm("정말로 이 문의글을 삭제하시겠습니까?")) {
        $.ajax({
            url: "/customerService/delete/" + inquiryID,
            type: 'POST',
            success: function(response) {
                alert("문의글이 삭제되었습니다.");
                window.location.href = "/customerService/customerPage";
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
        url: "/customerService/addReply",
        type: 'POST',
        data: {
            inquiryID: inquiryID,
            inquiryReply: replyContent
        },
        success: function(response) {
            if (response.status === "success") {
                alert("답변이 등록되었습니다.");
                window.location.href = "/customerService/customerPage";
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
                <div class="text-center mb-4">
                    <a href="/customerService/customerPage" class="btn btn-outline-primary btn-lg">문의목록</a>
                </div>
                <div class="card shadow-card border-0 rounded-lg">
                    <div class="card-header custom-card-header">
                        <h2 class="mb-0 fw-bold">문의글 상세정보</h2>
                    </div>
                    <div class="card-body p-5">
                        <form name="customerDetailForm" id="customerDetailForm" method="post" action="/customerService/update" enctype="multipart/form-data">
                            <div class="mb-4">
                                <label for="inquiryID" class="form-label custom-form-label">문의 ID</label>
                                <input type="text" name="inquiryID" id="inquiryID" value="${inquiry.inquiryID}" readonly class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="category" class="form-label custom-form-label">카테고리</label>
                                <select name="category" id="category" class="form-select custom-form-control" required>
                                    <option value="">카테고리를 선택하세요</option>
                                    <option value="상품문의" ${inquiry.boardType == '상품문의' ? 'selected' : ''}>상품문의</option>
                                    <option value="경기문의" ${inquiry.boardType == '경기문의' ? 'selected' : ''}>경기문의</option>
                                    <option value="배송문의" ${inquiry.boardType == '배송문의' ? 'selected' : ''}>배송문의</option>
                                    <option value="주문/결제" ${inquiry.boardType == '주문/결제' ? 'selected' : ''}>주문/결제</option>
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
                                <textarea name="content" id="content" class="form-control custom-form-control summernote" required>${inquiry.content}</textarea>
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
