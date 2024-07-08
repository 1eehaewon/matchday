<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ include file="../header.jsp"%>

<!-- list.jsp -->
<main>
   <div class="spacing"></div>
   <div class="header-with-search">
       <h1>Teams</h1>
       <!-- 검색 -->
       <form method="get" action="search" class="search-form" style="margin-right: 10%">
          <input type="text" name="teamname" value="${teamname}" placeholder="Team name">
          <input type="submit" value="검색" class="btn btn-secondary">
       </form>
   </div>
   <div class="spacing"></div>
   
   
    <div class="row">
      <c:forEach items="${list}" var="row" varStatus="vs">
         <div class="col-sm-4 col-md-4 team-item" style="width: 200px; height: 100px;">
            <c:choose>
               <c:when test="${row.filename != '-'}">
                  <a href="detail/${row.teamname}">
                     <img src="/storage/teams/${row.filename}" class="img-responsive margin team-img" style="width:100%">
                  </a>
               </c:when>
               <c:otherwise>
                  <h2>등록된 사진 없음!!</h2><br>
               </c:otherwise>
            </c:choose>
            <div class="team-info">
               <p class="team-text" style="font-size: 12px;">${row.teamname}</p>
               <p class="team-text" style="font-size: 10px;">${row.leaguecategory}</p>
            </div>
         </div>
		
		
		<!-- 한줄에 10칸씩 -->
        <c:if test="${vs.count mod 8 == 0}">
        	</div><!-- row end -->
            <div style="height: 10px;"></div>
            <div class="row">
        </c:if>
      </c:forEach>
   </div>
   
   
   <div class="text-right" style="margin-right: 10%; text-align: right">
      <button class="btn btn-primary" onclick="location.href='write'">팀 등록</button>
   </div>
   
   
</main>
<!-- 본문 끝 -->


<style>
.spacing {
    height: 20px;
}

.header-with-search {
    display: flex;
    justify-content: space-between;
    align-items: center;
}

.search-form {
    display: flex;
    align-items: center;
}

.team-item {
    text-align: center;
    display: flex;
    flex-direction: column;
    align-items: center;
}

.team-img {
    margin: 0;
}

.team-info {
    display: flex;
    flex-direction: column;
    align-items: center;
}

.team-text {
    margin: 0;
    padding: 0;
}

</style>



<%@ include file="../footer.jsp"%>