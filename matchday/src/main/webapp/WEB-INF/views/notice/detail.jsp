<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

   <script>
 	
   function noticeDelete(noticeid) {
 		
 		//alert(noticeid);
 		
		if(confirm("공지사항/이벤트를 삭제할까요?")) {
            location.href = "/notice/delete?noticeid=" + noticeid;
		}//if end
	}//noticeDelete() end 

	
   </script>


<!-- 본문 시작 detail.jsp -->
<main>
    <div class="container mt-5">
        <div class="row">
            <div class="col-md-8 mx-auto">
            <div id="menu">
            <ul>
               <li><a href="list">공지사항</a></li>
               <li><a href="evl">이벤트</a></li>
            </ul>
            </div>
                <h3 class="text-center mb-4">공지사항</h3>
            <hr style="width: 100%; margin-left: auto; margin-right: auto;">
                   <h5 style="text-align: left; color: blue;">${notice.title}</h5>
            <hr style="width: 100%; margin-left: auto; margin-right: auto;">
                   <h5 style="text-align: left;">작성자: ${notice.userid}</h5>
            <hr style="width: 100%; margin-left: auto; margin-right: auto;">
                <div class="card">
                    <div class="card-body">
                        <form name="noticefrm" id="noticefrm" method="post" enctype="multipart/form-data">
                            <div class="form-group">
                                <textarea class="form-control" id="content" rows="5" readonly>${notice.content}</textarea>
                            </div>
                            </div>
                        </form>
                    </div>
                    <div class="spacing"></div>
                    <div class="text-center">
                       <input type="hidden" name="noticeid" value="${notice.noticeid}">
                       <button type="submit" class="btn btn-success mr-2" onclick="location.href='update?noticeid=${notice.noticeid}'">공지사항 수정</button>
                       <button type="button" class="btn btn-danger" onclick="noticeDelete(${notice.noticeid})">공지사항 삭제</button>
                </div>
            </div>
        </div>
    </div>
    
    <div class="spacing"></div>
    
</main>


<style>
    .spacing {
               height: 20px; /* 원하는 높이로 조정 가능 */
             }
    li {
       list-style: none;
    }
    #menu {
       width: 250px;
       height: 50px;
       outline: 1px dotted white;
    }
    #menu ul li {
    float: left;
    width: 50%;
    height: 100%;
    line-height: 50px;
    text-align: center;
    background: orange;
    }
    #menu ul li a {
       display: block;
    }
    #menu ul li a:hover {
       background: #ff7f00;
       color: white;
    }
    a {
       text-decoration-line: none;
       color: black;
    }
    
   </style>
   
   
<!-- 본문 끝 -->


<%@ include file="../footer.jsp" %>