<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <h2 class="text-center">FAQ 작성</h2>
    <form action="/customerService/insertFaq" method="post" enctype="multipart/form-data">
        <div class="mb-3">
            <label for="title" class="form-label">질문</label>
            <input type="text" class="form-control" id="title" name="title" required>
        </div>
        <div class="mb-3">
            <label for="content" class="form-label">답변</label>
            <textarea class="form-control summernote" id="content" name="content" rows="5" required></textarea>
        </div>
        <button type="submit" class="btn btn-primary">저장하기</button>
    </form>
</div>

<script>
$(document).ready(function() {
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
</script>

<%@ include file="../footer.jsp" %>
