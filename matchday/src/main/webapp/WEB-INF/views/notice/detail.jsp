<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<script>
   function playerDelete(playerid) { 
	   //alert(playerid);
      if (confirm("선수를 삭제할까요?")) {
         location.href = "/player/delete?playerid=" + playerid;
      }
   } 
</script>

<!-- detail.jsp -->
<main>
   <div class="spacing"></div>
   
   <div style="margin-left: 3%">
      <h2>선수 상세 정보</h2>
   </div>
   <hr>

   <div class="container">
      <div class="row">
         <div class="col-md-4">
            <!-- 선수 사진 -->
            <div class="player-photo">
               <img src="/storage/players/${player.filename}" class="img-responsive" style="width: 325px; height: 325px;">
            </div>
         </div>
         <div class="col-md-8">
            <!-- 선수 정보 테이블 -->
            <table class="table table-bordered">
               <tbody>
                  <tr>
                     <th scope="row">한글 이름</th>
                     <td>${player.playername}</td>
                  </tr>
                  <tr>
                     <th scope="row">영어 이름</th>
                     <td>${player.playerid}</td>
                  </tr>
                  <tr>
                     <th scope="row">포지션</th>
                     <td>${player.position}</td>
                  </tr>
                  <tr>
                     <th scope="row">등번호</th>
                     <td>${player.backnumber}</td>
                  </tr>
                  <tr>
                     <th scope="row">출생일</th>
                     <td>${player.birthdate}</td>
                  </tr>
                  <tr>
                     <th scope="row">키</th>
                     <td>${player.height}</td>
                  </tr>
                  <tr>
                     <th scope="row">몸무게</th>
                     <td>${player.weight}</td>
                  </tr>
                  <tr>
                     <th scope="row">입단일</th>
                     <td>${player.joiningyear}</td>
                  </tr>
                  <tr>
                     <th scope="row">태어난곳</th>
                     <td>${player.birthplace}</td>
                  </tr>
               </tbody>
            </table>
         </div>
      </div>
   </div>
   
   
   <div class="spacing"></div>
      <div class="text-center">
         <input type="hidden" name="playerid" value="${player.playerid}">
            <button type="button" class="btn btn-success mr-2" onclick="location.href='/player/update?playerid=${player.playerid}'">선수정보 수정</button>
            <button type="button" class="btn btn-danger" onclick="playerDelete('${player.playerid}')">선수삭제</button>
      </div>
   
   
</main>


<style>
   .spacing {
      height: 15px;
   }
</style>

<%@ include file="../footer.jsp" %>
