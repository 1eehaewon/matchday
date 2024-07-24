<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>


<%@ include file="../header.jsp" %>

<script>
   function teamDelete(teamname) { 
      if (confirm("팀을 삭제할까요?")) {
         location.href = "/team/delete?teamname=" + teamname;
      }
   } 
</script>

<!-- 본문 시작 detail.jsp -->
<main>
 <div class="spacing"></div>
   <div style="background-color: white" class="container-fluid">
      <a style="font-size: 50px"><img src="/storage/teams/${team.filename}" class="img-responsive margin team-img" style="width:5%">${team.teamname}</a>
   </div>
   <hr>
   <div style="background-color: white;" class="container-fluid">
      <h5 style="margin-left: 2%; color: #282828">창단일: ${team.foundingyear}</h5>
      <h5 style="margin-left: 2%; color: #282828">감독: ${team.coach}</h5>
      <h5 style="margin-left: 2%; color: #282828">연고지: ${team.city}</h5>
      <h5 style="margin-left: 2%; color: #282828">소속리그: ${team.leaguecategory}</h5>
      <h5 style="margin-left: 2%; color: #282828">${team.introduction}</h5>
      <hr>
   </div>
   <div class="spacing"></div>
   
   <div>
      <h3 style="margin-left: 60px">Players</h3>
   </div>
   <div class="spacing"></div>
   
   <div class="row" style="margin-left: 50px">
      <c:forEach items="${players}" var="player" varStatus="vs">
         <div class="col-sm-4 col-md-4 team-item" style="width: 270px; height: 270px;">
            <div class="player-info-box">
               <c:choose>
                  <c:when test="${player.filename != '-'}">
                     <a href="/player/detail/${player.playerid}">
                        <img src="/storage/players/${player.filename}" class="img-responsive margin team-img" style="width:90%">
                     </a>
                  </c:when>
                  <c:otherwise>
                     <h2>등록된 사진 없음!!</h2><br>
                  </c:otherwise>
               </c:choose>
               <div class="team-info">
                  <p class="team-text" style="font-size: 12px;">${player.playername}</p>
                  <p class="team-text" style="font-size: 10px;">${player.backnumber}</p>
                  <p class="team-text" style="font-size: 10px;">${player.position}</p>
               </div>
            </div>
         </div>
         
         <!-- 한줄에 7칸씩 -->
         <c:if test="${vs.count % 7 == 0}">
            </div><!-- row end -->
            <div style="height: 10px;"></div>
            <div class="row" style="margin-left: 50px">
         </c:if>
      </c:forEach>
   </div>
   <div class="spacing"></div>
 <c:if test="${sessionScope.grade == 'M'}">
   <div class="text-right" style="margin-right: 10px; text-align: right">
      <button class="btn btn-primary" onclick="location.href='/player/write'">선수등록</button>
      <button class="btn btn-primary" onclick="location.href='/team/update?teamname=${team.teamname}'">팀 정보 수정</button>
      <button type="button" class="btn btn-danger" onclick="teamDelete('${team.teamname}')">팀 삭제</button>
   </div>
 </c:if>
</main>


<style>
   .spacing {
      height: 10px;
   }
   
   .player-info-box {
      border: 2px solid #ccc;
      padding: 10px;
      text-align: center;
      margin-bottom: 10px; /* Adjust this if needed */
   }
   
   .team-text {
      font-size: 12px;
      margin-bottom: 5px; /* Adjust the margin between paragraphs */
   }
   .player-info-box img {
      width: 40px;
      height: 180px;
      margin-right: 2px;
   }
</style>

<%@ include file="../footer.jsp" %>