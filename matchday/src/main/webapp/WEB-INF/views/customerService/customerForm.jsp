<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<main class="main-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="text-center mb-4">
                    <a href="customerPage" class="btn btn-outline-primary btn-lg">문의목록</a>
                </div>
                <div class="card shadow-card border-0 rounded-lg">
                    <div class="card-header custom-card-header">
                        <h2 class="mb-0 fw-bold">1:1 문의</h2>
                    </div>
                    <div class="card-body p-5">
                        <div class="text-center mb-4">
                            <button id="viewPurchases" class="btn btn-outline-secondary btn-lg">내가 구매한 상품조회</button>
                        </div>
                        <form name="customerForm" id="customerForm" method="post" action="insert" enctype="multipart/form-data" onsubmit="return validateForm()">
                            <div class="mb-4">
                                <label for="referenceID" class="form-label custom-form-label">주문 / 예매번호</label>
                                <input type="text" name="referenceID" id="referenceID" readonly class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="category" class="form-label custom-form-label">문의 카테고리</label>
                                <select name="category" id="category" class="form-select custom-form-control" required>
                                    <option value="">카테고리를 선택하세요</option>
                                    <option value="상품문의">상품문의</option>
                                    <option value="경기문의">경기문의</option>
                                    <option value="배송문의">배송문의</option>
                                    <option value="주문/결제">주문/결제</option>
                                </select>
                            </div>
                            <div class="mb-4">
                                <label for="userID" class="form-label custom-form-label">회원 ID</label>
                                <input type="text" name="userID" id="userID" value="${userID}" readonly class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="title" class="form-label custom-form-label">제목</label>
                                <input type="text" name="title" id="title" maxlength="100" required class="form-control custom-form-control">
                            </div>
                            <div class="mb-4">
                                <label for="content" class="form-label custom-form-label">내용</label>
                                <textarea name="content" id="content" class="form-control custom-form-control summernote" required></textarea>
                            </div>
                            <div class="mb-4">
                                <label for="inqpasswd" class="form-label custom-form-label">비밀번호</label>
                                <input type="password" name="inqpasswd" id="inqpasswd" maxlength="10" required class="form-control custom-form-control">
                            </div>
                            <div class="d-flex justify-content-end mt-5">
                                <button type="submit" class="btn btn-primary btn-lg custom-button me-2">제출하기</button>
                                <a href="customerPage" class="btn btn-outline-primary btn-lg custom-button">취소</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
$(document).ready(function() {
    $("#viewPurchases").click(function() {
        window.open("/customerService/purchaseHistoryPopup", "purchaseHistoryPopup", "width=1000,height=800,scrollbars=yes");
    });

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

// 폼 검증 함수
function validateForm() {
    var referenceID = document.getElementById("referenceID").value.trim();
    var title = document.getElementById("title").value.trim();
    var content = $('.summernote').summernote('isEmpty') ? "" : $('.summernote').summernote('code').trim();
    
    if (referenceID === "" || title === "" || content === "" || content === "<p><br></p>") {
        alert("주문/예매번호, 제목, 내용을 작성해주세요.");
        return false; // 폼 제출을 막음
    }
    
    return true; // 폼 제출을 허용
}
</script>

<%@ include file="../footer.jsp" %>
