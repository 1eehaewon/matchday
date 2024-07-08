<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<!-- 본문 시작 main.jsp -->
<main>
    <hr style="width: 65%; margin-left: auto; margin-right: auto;">
    <div class="text-center mb-4">
        <h3>공지사항/이벤트 수정</h3>
        <hr style="width: 65%; margin-left: auto; margin-right: auto;">
        <p>
            <button type="button" class="btn btn-primary" onclick="location.href='list'">공지사항</button>
            <button type="button" class="btn btn-info" onclick="location.href='../event/list'">이벤트</button>
        </p>
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <form name="noticefrm" id="noticefrm" method="post" action="update" enctype="multipart/form-data">
                <input type="hidden" name="noticeid" value="${notice.noticeid}">
                <table class="table table-striped">
                    <tbody>
                        <tr>
                            <td>카테고리</td>
                            <td>
                                <select name="category" class="form-select">
                                    <option value="notice" ${notice.category == 'notice' ? 'selected' : ''}>공지사항</option>
                                    <option value="event" ${notice.category == 'event' ? 'selected' : ''}>이벤트</option>
                                </select>
                            </td>
                        </tr>
                        <tr>
                            <td>제목</td>
                            <td><input type="text" name="title" value="${notice.title}" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>내용</td>
                            <td><textarea class="form-control summernote" id="content" name="content" rows="5" required>${notice.content}</textarea></td>
                        </tr>
                        <tr>
                            <td colspan="2" class="text-center"><input type="submit" value="공지/이벤트 수정" class="btn btn-success"></td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div>
    </div>
</main>
<!-- 본문 끝 -->

<style>
    .spacing {
        height: 20px; /* 원하는 높이로 조정 가능 */
    }
</style>

<script>
    $(document).ready(function() {
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
                url: '/notice/uploadImage',
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
