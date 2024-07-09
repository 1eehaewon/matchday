<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
    function noticeDelete(noticeid) {
        if (confirm("공지사항/이벤트를 삭제할까요?")) {
            location.href = "/notice/delete?noticeid=" + noticeid;
        }
    }
</script>

<!-- 본문 시작 detail.jsp -->
<main>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 mx-auto">
                <h3 class="text-center mb-4">공지사항</h3>
                <hr style="width: 100%; margin-left: auto; margin-right: auto;">
                <h5 style="text-align: left; color: blue;">${notice.title}</h5>
                <hr style="width: 100%; margin-left: auto; margin-right: auto;">
                <div style="display: flex; justify-content: space-between;">
                   <h5 style="text-align: left;">작성자: ${notice.userid}</h5>
                   <%-- 수정일이 null이 아닌 경우에만 출력 --%>
                   <c:if test="${not empty notice.modifieddate}">
                      <h5 style="text-align: right;">수정일:${notice.modifieddate}</h5>
                   </c:if>
                </div>
                <hr style="width: 100%; margin-left: auto; margin-right: auto;">
                <div class="card" style="height: 500px">
                    <div class="card-body">
                        <form name="noticefrm" id="noticefrm" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <div class="content">
                                    ${notice.content}
                                </div>
                            </div>
                        </form>
                    </div>
                    <div class="spacing"></div>
                    <div class="text-center">
                        <input type="hidden" name="noticeid" value="${notice.noticeid}">
                        <button type="button" class="btn btn-success mr-2" onclick="location.href='update?noticeid=${notice.noticeid}'">공지사항 수정</button>
                        <button type="button" class="btn btn-danger" onclick="noticeDelete(${notice.noticeid})">공지사항 삭제</button>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <div class="spacing"></div>

</main>

<style>
    .spacing {
        height: 20px;
    }
</style>

<%@ include file="../footer.jsp" %>
