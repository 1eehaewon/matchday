<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>
<script>
    function video_delete_confirm(video_code) {
        if (confirm("하이라이트를 삭제합니다. 진행할까요?")) {
            location.href = "/video/delete?video_code=" + video_code;
        }
    }

    function video_update(video_code) {
        //alert(video_code);
        location.href = "/video/update?video_code=" + video_code;
    }
</script>

<div class="row">
    <div class="col-sm-12 text-center">
        <p><h1>상세페이지</h1></p>
        <p>
            <button type="button" class="btn btn-primary" onclick="location.href='/video/list'">하이라이트 전체목록</button>
        </p>
    </div><!-- col end -->
</div><!-- row end -->

<div class="row">
    <div class="col-sm-12 text-center">

        <form name="videofrm" id="videofrm" method="post" action="insert">
            <table class="table table-hover">
                <tbody style="text-align: left;">
                <tr>
                    <td>하이라이트 이름</td>
                    <td> <input type="text" name="video_name" value="${detail.video_name}" class="form-control" readonly="${sessionScope.grade != 'M'}"> </td>
                </tr>
                <tr>
                    <td>하이라이트 주소</td>
                    <td>
                        <iframe width="560" height="315" src="${detail.video_url}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                    </td>
                </tr>
                <tr>
                    <td>하이라이트 내용</td>
                    <td> <input type="text" name="description" value="${detail.description}" class="form-control" readonly="${sessionScope.grade != 'M'}"> </td>
                </tr>
                <tr>
                    <td colspan="2" align="center">
                        <input type="hidden" name="video_code" value="${detail.video_code}">
                        <c:if test="${sessionScope.grade == 'M'}">
                            <button type="button" class="btn btn-primary" onclick="video_update(${detail.video_code})">수정</button>
                            <button type="button" class="btn btn-danger" onclick="video_delete_confirm(${detail.video_code})">삭제</button>
                        </c:if>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div><!-- col end -->
</div><!-- row end -->

<!-- 댓글 시작 -->
<div class="row"><!-- 댓글 쓰기 -->
    <div class="col-sm-12">
        <form name="commentInsertForm" id="commentInsertForm">
            <!-- 부모글번호 -->
            <input type="hidden" name="video_code" id="video_code" value="${detail.video_code}">
            <table class="table table-borderless">
            <tr>
                <td>
                    <input type="text" name="content" id="content" placeholder="댓글 내용 입력해 주세요" class="form-control">
                </td>
                <td>
                    <button type="button" name="commentInsertBtn" id="commentInsertBtn" class="btn btn-secondary">댓글등록</button>
                </td>
            </table>
        </form>
    </div><!-- col end -->
</div><!-- row end -->

<div class="row"><!-- 댓글 목록 -->
    <div class="col-sm-12">
        <div class="commentList"></div>
    </div><!-- col end -->
</div><!-- row end -->
<!-- 댓글 끝 -->

<!-- 댓글 관련 자바스크립트 시작 -->  
<script>
    let video_code = '${detail.video_code}'; // 전역변수. 부모글 번호 

    $(document).ready(function(){ // 상세페이지 로딩시 댓글 목록 함수 출력
        commentList(); 
    });// ready() end

    $("#commentInsertBtn").click(function(){
        let video_code = $("#video_code").val();
        let content = $("#content").val().trim();
        if(content.length == 0) {
            $("#content").focus();
        } else {
            let insertData = "video_code=" + video_code + "&content=" + content;
            commentInsert(insertData); // 댓글등록 함수 호출
        }
    });// click end

    function commentInsert(insertData) { // 댓글등록 함수
        $.ajax({
            url    : '/comment/insert', // 요청명령어
            type   : 'post', 
            data   : insertData, // 전달값
            error  : function(error){
                alert(error);
            },
            success: function(result){
                if(result == 1){ // 댓글등록 성공했다면
                    alert("댓글이 등록되었습니다");
                    commentList(); // 댓글등록후 댓글목록 함수 호출
                    $("#content").val(''); // 기존 댓글내용을 빈 문자열로 대입(초기화)
                }
            }
        });
    }

    function commentList() {
        $.ajax({
            url    : '/comment/list',
            type   : 'get',
            data   : {'video_code' : video_code}, // 부모글번호(전역변수 선언되어 있음)
            error  : function(error){
                alert(error);
            },
            success: function(result){
                let a = ''; // 출력할 결과값
                $.each(result, function(key, value){
                    a += '<div class="commentArea" style="border-bottom:1px solid darkgray; margin-bottom:15px;">';
                    a += '    <div class="commentInfo' + value.cno + '">';
                    a += '        댓글번호:' + value.cno + " / 작성자:" + value.wname + " " + value.regdate;
                    a += '        <a href="javascript:commentUpdate(' + value.cno + ', \'' + value.content + '\')">[수정]</a>';
                    a += '        <a href="javascript:commentDelete(' + value.cno + ')">[삭제]</a>';
                    a += '    </div>';
                    a += '    <div class="commentContent' + value.cno + '">';
                    a += '        <p>내용:' + value.content + '</p>';
                    a += '    </div>';
                    a += '</div>';
                });
                $(".commentList").html(a);
            }
        });
    }

    function commentUpdate(cno, content) {
        let a = '';
        a += '<div class="input-group">';
        a += '    <input type="text" value="' + content + '" id="content_' + cno + '">';
        a += '    <button type="button" onclick="commentUpdateProc('+ cno +')">수정</button>';    
        a += '</div>';
        $(".commentContent" + cno).html(a);             
    }

    function commentUpdateProc(cno) {
        let updateContent = $("#content_" + cno).val();
        let params = "cno=" + cno + "&content=" + updateContent
        $.ajax({
            url    : '/comment/updateproc',
            type   : 'post',
            data   : {'cno': cno, 'content': updateContent}, //또는 params
            success: function(result){
                if(result == 1){
                    alert("댓글이 수정되었습니다");
                    commentList(); // 댓글수정후 목록 출력
                }
            }
        });  
    }

    function commentDelete(cno) {
        $.ajax({
            url    : '/comment/delete',
            type   : 'post',
            data   : {'cno' : cno},
            success: function(result){
                if(result == 1){
                    alert("댓글이 삭제되었습니다");
                    commentList(); // 댓글삭제후 목록 함수 출력
                } else {
                    alert("댓글삭제실패:로그인후 사용이 가능합니다");
                }
            }
        });
    }
</script>
<%@ include file="../footer.jsp" %>
