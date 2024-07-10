<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

	<div class="row">
	<div class="col-sm-12 text-center">
		<!-- 본문 시작 main.jsp -->	
				<p><h1>하이라이트 등록</h1></p>
				<p>
					<button type="button" class="btn btn-primary" onclick="location.href='list'">하이라이트 전체목록</button>
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
					<td> <input type="text" name="video_name" class="form-control"> </td>
			    </tr>
			     <tr>
					<td>하이라이트 주소</td>
					<td> <input type="text" name="video_url" class="form-control"> </td>
			    </tr>		    
			   <tr>
					<td>하이라이트 내용</td>
					<td> <input type="text" name="description" class="form-control"> </td>
			    </tr>								    
			    <tr>
					<td colspan="2" align="center">
					    <input type="submit" value=" 하이라이트 등록" class="btn btn-success"> 
					</td>
			    </tr>   
			    </tbody> 
		    </table>	
				</form>
			</div><!-- col end -->
	</div><!-- row end -->
	

</main>



<%@ include file="../footer.jsp" %>
