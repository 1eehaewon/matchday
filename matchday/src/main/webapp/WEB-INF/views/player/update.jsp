<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<!-- 본문 시작 main.jsp -->
<main>
    <hr style="width: 65%; margin-left: auto; margin-right: auto;">
    <div class="text-center mb-4">
        <h3>선수 정보 수정</h3>
        <hr style="width: 65%; margin-left: auto; margin-right: auto;">
    </div>

    <div class="row justify-content-center">
        <div class="col-md-8">
            <form name="playerfrm" id="playerfrm" method="post" action="update" enctype="multipart/form-data">
               <input type="hidden" name="playerid" value="${player.playerid}">    
                 <table class="table table-striped">
                    <tbody>
                        <tr>
                            <td>선수ID</td>
                            <td><input type="text" name="playerid" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>소속 팀</td>
                            <td><input type="text" name="teamname" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>선수 이름</td>
                            <td><input type="text" name="playername" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>포지션</td>
                            <td><input type="text" name="position" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>등 번호</td>
                            <td><input type="text" name="backnumber" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>생년월일</td>
                            <td><input type="date" name="birthdate" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>신장</td>
                            <td><input type="text" name="height" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>체중</td>
                            <td><input type="text" name="weight" class="form-control"></td>
                        </tr>
                        <tr>
					        <td>입단년도</td>
					        <td><input type="date" name="joiningyear" class="form-control"></td>
			            </tr>
			            <tr>
					        <td>출생지</td>
					        <td><input type="text" name="birthplace" class="form-control"></td>
			            </tr>
			            <tr>
					        <td>선수 사진</td>
					        <td><input type="file" name="img" class="form-control"></td>
			            </tr>
                        <tr>
                            <td colspan="2" class="text-center"><input type="submit" value="선수 정보 수정" class="btn btn-success"></td>
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

<%@ include file="../footer.jsp" %>
