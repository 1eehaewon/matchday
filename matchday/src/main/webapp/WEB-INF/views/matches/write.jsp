<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

	<div class="row">
	<div class="col-sm-12 text-center">
		<!-- 본문 시작 main.jsp -->	
				<p><h1>경기 일정 등록</h1></p>
				<p>
					<button type="button" class="btn btn-primary" onclick="location.href='list'">경기 일정 전체목록</button>					
				</p>
			
					<button type="button" class="btn btn-primary">예매하기</button>
				
			</div><!-- col end -->
	</div><!-- row end -->
	
	<div class="row">
	<div class="col-sm-12 text-center">
		
				<form name="matchesfrm" id="matchesfrm" method="post" action="insert">
				<table class="table table-hover">
			    <tbody style="text-align: left;">
			    <tr>
					<td>날짜</td>
					<td> <input type="text" name="matches_date" class="form-control"> </td>
			    </tr>
			     <tr>
					<td>시간</td>
					<td> <input type="text" name="matches_time" class="form-control"> </td>
			    </tr>		    
			   <tr>
					<td>홈팀</td>
					<td> <input type="text" name="hometeam_id" class="form-control"> </td>
			    </tr>
			    <tr>
					<td>원정팀</td>
					<td> <input type="text" name="awayteam_id" class="form-control"> </td>
			    </tr>
			     <tr>
					<td>경기장</td>
					<td> <input type="text" name="stadium_id" class="form-control"> </td>
			    </tr>									    
			    <tr>
					<td colspan="2" align="center">
					    <input type="submit" value=" 경기 일정 등록" class="btn btn-success"> 
					</td>
			    </tr>   
			    </tbody> 
		    </table>	
				</form>
			</div><!-- col end -->
	</div><!-- row end -->
	

</main>



<%@ include file="../footer.jsp" %>
