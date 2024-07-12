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
                 <c:choose>
                    <c:when test="${notice.category == 'Notice'}">
                        <h3 class="text-center mb-4">공지사항</h3>
                    </c:when>
                    <c:when test="${notice.category == 'Event'}">
                        <h3 class="text-center mb-4">이벤트</h3>
                    </c:when>
                </c:choose>
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
                <div class="card">
                    <div class="card-body">
                        <form name="noticefrm" id="noticefrm" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <div class="content">
                                    ${notice.content}
                                </div>
                            </div>
                        </form>
                    </div>
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
    
  <c:choose>
     <c:when test="${notice.category == 'Event'}">
  <!-- 댓글 시작 -->
  <div class="row" style="margin-left: 26%">
    <div class="col-sm-12">
		<form name="replyInsertForm" id="replyInsertForm">
			<!-- 부모글번호 -->
			<input type="hidden" name="noticeid" id=noticeid value="${notice.noticeid}">
			<table class="table table-borderless">
			<tr>
				<td>
					<input type="text" name="content" id="content" placeholder="댓글 내용 입력해 주세요" class="form-control">
				</td>
				<td>
					<button type="button" name="replyInsertBtn" id="replyInsertBtn" class="btn btn-secondary">댓글등록</button>
				</td>
			</table>
		</form>
    </div><!-- col end -->
  </div><!-- row end -->
  

  <div class="row" style="margin-left: 26%"><!-- 댓글 목록 -->
    <div class="col-sm-12">
		<div class="replyList"></div>
    </div><!-- col end -->
  </div><!-- row end -->
  <!-- 댓글 끝 -->
     </c:when>
  </c:choose>
  
</main>


 <!-- 댓글 관련 자바스크립트 시작 -->
  <script>
  	  let noticeid = '${notice.noticeid}'; //전역변수. 부모글 번호 
 
      $(document).ready(function(){ //상세페이지 로딩시 댓글 목록 함수 출력
          replyList(); 
      });//ready() end
  	  
  	  
  	  //댓글등록 버튼을 클릭했을때
  	  $("#replyInsertBtn").click(function(){
  		  let content = $("#content").val().trim();
  		  if(content.length==0) {
  			  alert("댓글 내용 입력해주세요~");
  			  $("#content").focus();
  		  } else {
  	  		  let insertData = $("#replyInsertForm").serialize();
  			  replyInsert(insertData); //댓글등록 함수 호출
  		  }//if end  		  
  	  });//click end
  	  
  	  
  	  function replyInsert(insertData) { //댓글등록 함수
  		  //alert("댓글등록함수호출:" + insertData); //댓글등록함수호출:noticeid=95&content=12
  		  $.ajax({
  			  url    : '/reply/insert' //요청명령어 //ReplyCont.java파일에 @PostMapping("/insert") 가리킴
  			 ,type   : 'post' 
  			 ,data   : insertData        //전달값
  			 ,error  :function(error){
  				 alert("댓글등록실패:" + error);
  			 }//error end
  		     ,success:function(result){
  		    	 //alert(result);
  		    	 if(result==1){ //댓글등록 성공했다면
  		    		alert("댓글이 등록되었습니다");
  		    		replyList(); //댓글등록후 댓글목록 함수 호출
  		    	 	$("#content").val('');//기존 댓글내용을 빈 문자열로 대입(초기화)
  		    	 }//if end
  		     }
  		  });//ajax() end		
	  }//replyInsert() end
	  
	  
	  function replyList() {
		  $.ajax({
			  url    : '/reply/list' //ReplyCont.java @GetMapping("/list")
			 ,type   : 'get'
			 ,data   : {'noticeid' : noticeid} //부모글번호(전역변수 선언되어 있음) //96행 let noticeid 변수를 가리킴 //noticeid -> ReplyCont.java  public List<ReplyDTO> replyServiceList(@RequestParam("noticeid") int noticeid) throws Exception { 에서 받아옴
			 ,error  : function(error){
				 alert(" 오류 " + error)
			 }
			 ,success: function(result){
				 //alert("성공"+result);
				 //console.log(result);
				 let a = ''; //출력할 결과값
				 $.each(result, function(key, value){
					 //console.log(key);  //순서 0 1
					 //console.log(value);//{cno: 1, product_code: 1, content: '비싸요~~', wname: 'test', regdate: '2024-05-23 12:09:40'}
					 //console.log(value.cno);
					 //console.log(value.product_code);
					 //console.log(value.content);
					 //console.log(value.wname);
					 //console.log(value.regdate);
					 
					 a += '<div class="replyArea" style="border-bottom:1px solid darkgray; margin-bottom:15px;">';
					 a += '    <div class="replyInfo' + value.replyid + '">';
					 a += '        댓글번호:' + value.replyid + " / 작성자:" + value.userid + " " + value.createddate;
					 a += '        <a href="javascript:replyUpdate(' + value.replyid + ',\'' + value.content + '\')">[수정]</a>';
					 a += '        <a href="javascript:replyDelete(' + value.replyid + ')">[삭제]</a>';
					 a += '    </div>';
					 a += '    <div class="replyContent' + value.replyid + '">';
					 a += '        <p>내용:' + value.content + '</p>';
					 a += '    </div>';
					 a += '</div>';
				 });//each() end
				 
				 $(".replyList").html(a);
				 
			 }
		  });//ajax() end
	  }//replyList() end
	  
	  
	  //[수정] : 댓글수정-전달받은 댓글내용을 <input type=text>에 출력함
	  function replyUpdate(replyid, content) {
		  let a = '';
		  a += '<div class="input-group">';
		  a += '	<input type="text" value="' + content + '" id="content_' + replyid + '">';
		  a += '    <button type="button" onclick="replyUpdateProc(' + replyid + ')">수정</button>';
		  a += '</div>';
		  //alert(a);
		  $(".replyContent" + replyid).html(a);
	  }//replyUpdate() end
	  
	  
	  //댓글수정후 댓글목록 함수 호출
	  function replyUpdateProc(replyid) {
		  let updateContent = $("#content_" + replyid).val();
		  //alert("수정된 댓글내용:" + updateContent);
		  let params = "replyid=" + replyid + "&content=" + updateContent
		  
		  $.ajax({
			  url    : '/reply/updateproc'
			 ,type   : 'post'
			 ,data   : {'replyid':replyid, 'content':updateContent} //또는 params
			 ,success: function(result){
				 if(result==1){
					 alert("댓글이 수정되었습니다");
					 replyList(); //댓글수정후 목록 출력
				 }//if end
			 }//success end
		  });//ajax() end
	  }//replyUpdateProc() end
	  
	  
	  function replyDelete(replyid) {
		  //alert("댓글삭제:" + cno);
		  $.ajax({
			  url    : '/reply/delete'
			 ,type   : 'post'
			 ,data   : {'replyid' : replyid}
		     ,success: function(result){
		    	 if(result==1){
		    		 alert("댓글이 삭제되었습니다");
		    		 replyList(); //댓글삭제후 목록 함수 출력
		    	 } else {
		    		 alert("댓글삭제실패:로그인후 사용이 가능합니다");
		    	 }//if end
		     }//success end
		  });//ajax() end
	  }//replyDelete() end
  </script>
  <!-- 댓글 관련 자바스크립트 끝 -->


<style>
    .spacing {
        height: 200px;
    }
</style>


<%@ include file="../footer.jsp" %>
