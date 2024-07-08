<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
	

<%@ include file="../header.jsp"%>


<!-- 본문 시작 main.jsp -->
<main>
<hr style="width: 65%; margin-left: auto; margin-right: auto;">
	<div class="text-center mb-4">
		<h3>공지사항 or 이벤트 등록</h3>
		<hr style="width: 65%; margin-left: auto; margin-right: auto;">
		<p>
			<button type="button" class="btn btn-primary" onclick="location.href='list'">공지사항</button>
			<button type="button" class="btn btn-info" onclick="location.href='evl'">이벤트</button>
		</p>
	</div>

	<div class="row justify-content-center">
		<div class="col-md-8">
			<form name="noticefrm" id="noticefrm" method="post" action="insert" enctype="multipart/form-data">
				<table class="table table-striped">
					<tbody>
						<tr>
							<td>카테고리</td>
							<td>
							    <select name="category" class="form-select">
									<option value="notice">공지사항</option>
									<option value="event">이벤트</option>
							    </select>
							</td>
						</tr>
						<tr>
							<td>제목</td>
							<td><input type="text" name="title" class="form-control"></td>
						</tr>
						<tr>
							<td>내용</td>
							<td><textarea rows="5" name="content" class="form-control"></textarea></td>
						</tr>
						<tr>
							<td colspan="2" class="text-center"><input type="submit" value="공지/이벤트 등록" class="btn btn-success"></td>
						</tr>
					</tbody>
				</table>
			</form>
		</div>
	</div>
</main>
<!-- 본문 끝 -->


<%@ include file="../footer.jsp"%>



</body>
</html>
