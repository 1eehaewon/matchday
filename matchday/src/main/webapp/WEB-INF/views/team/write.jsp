<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ include file="../header.jsp"%>


<!-- write.jsp -->
<main>
    <hr style="width: 65%; margin-left: auto; margin-right: auto;">
    <div class="text-center mb-4">
        <h3>팀 정보 작성</h3>
        <hr style="width: 65%; margin-left: auto; margin-right: auto;">
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <form name="noticefrm" id="noticefrm" method="post" action="insert" enctype="multipart/form-data">
                <table class="table table-striped">
                    <tbody>
                        <tr>
                            <td>팀 이름</td>
                            <td><input type="text" name="teamname" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>팀 한글 이름</td>
                            <td><input type="text" name="koreanname" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>경기장 번호</td>
                            <td><input type="text" name="stadiumid" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>창단일</td>
                            <td><input type="text" name="foundingyear" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>감독</td>
                            <td><input type="text" name="coach" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>소속 도시</td>
                            <td><input type="text" name="city" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>소개</td>
                            <td><textarea class="form-control summernote" id="introduction" name="introduction" rows="5" required></textarea></td>
                        </tr>
                        <tr>
                            <td>소속 리그</td>
                            <td><input type="text" name="leaguecategory" class="form-control"></td>
                        </tr>
                        <tr>
					        <td>팀 로고</td>
					        <td> <input type="file" name="img" class="form-control"> </td>
			            </tr>
                        <tr>
                            <td colspan="2" class="text-center"><input type="submit" value="팀 정보 등록" class="btn btn-success"></td>
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


<%@ include file="../footer.jsp"%>
