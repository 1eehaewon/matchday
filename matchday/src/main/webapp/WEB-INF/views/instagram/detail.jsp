<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
    function instagram_delete_confirm(instagram_code) {
    	//alert(instagram_code);   	
        if (confirm("게시물을 삭제합니다. 진행할까요?")) {
            //document.getElementById("instagramfrm").action = "/instagram/delete?instagram_code=" + instagram_code;
            //document.getElementById("instagramfrm").submit();
                        
            location.href = "/instagram/delete?instagram_code=" + instagram_code;
        }
    }

    function instagram_update(instagram_code) {
      
    	 location.href = "/instagram/update/" + instagram_code;
    }
</script>

<div class="row">
    <div class="col-sm-12 text-center">
        <p><h1>상세페이지</h1></p>
        <p>
            <button type="button" class="btn btn-primary" onclick="location.href='/instagram/list'">인스타그램 전체목록</button>
        </p>
    </div><!-- col end -->
</div><!-- row end -->

<div class="row">
    <div class="col-sm-12 text-center">

        <form name="instagramfrm" id="instagramfrm" method="post" action="update">
            <table class="table table-hover">
                <tbody style="text-align: left;">
                <tr>
                    <td>게시물 이름</td>
                    <td> <input type="text" name="instagram_name" value="${detail.instagram_name}" class="form-control"> </td>
                </tr>
                <tr>
                    <td>인스타그램 주소</td>
                    <td>
                        <input type="text" name="instagram_url" value="${detail.instagram_url}" class="form-control">
                    </td>
                </tr>             
                <tr>
                    <td colspan="2" align="center">
                        <input type="hidden" name="instagram_code" value="${detail.instagram_code}">
                        <button type="button" class="btn btn-primary" onclick="instagram_update(${detail.instagram_code})">수정</button>
                        <button type="button" class="btn btn-danger" onclick="instagram_delete_confirm(${detail.instagram_code})">삭제</button>
                    </td>
                </tr>
                </tbody>
            </table>
        </form>
    </div><!-- col end -->
</div><!-- row end -->

<%@ include file="../footer.jsp" %>
