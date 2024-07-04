<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<!-- 본문 시작 write.jsp -->
<div class="row">
	<div class="col-sm-12 text-center">
		
				<form name="videofrm" id="videofrm" method="post" action="insert">
				<table class="table table-hover">
			    <tbody style="text-align: left;">
			    <tr>
					<td>카드뉴스 제목</td>
					<td> <input type="text" name="cardnewstitle" class="form-control"> </td>
			    </tr>
			     <tr>
					<td>카드뉴스 내용</td>
					<td> <input type="text" name="description" class="form-control"> </td>
			    </tr>		    
			   <tr>
					<td>카드뉴스 주소</td>
					<td> <input type="text" name="cardnewsurl" class="form-control"> </td>
			    </tr>								    
			    <tr>
					<td colspan="2" align="center">
					    <input type="submit" value=" 카드뉴스 수정" class="btn btn-success">
					    <input type="submit" value=" 카드뉴스 삭제" class="btn btn-danger">
					</td>
			    </tr>   
			    </tbody> 
		    </table>	
				</form>
			</div><!-- col end -->
	</div><!-- row end -->
<!-- 본문 끝 -->

<%@ include file="../footer.jsp" %>