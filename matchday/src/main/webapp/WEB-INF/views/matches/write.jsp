<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

<!-- 본문 시작 write.jsp -->
<div class="container mt-4">
    <h1>경기 일정 등록</h1>
    <form action="saveMatch" method="post">
        <div class="form-group">
            <label for="matchdate">경기 날짜</label>
            <input type="text" class="form-control" id="matchdate" name="matchdate" required>
        </div>
        <div class="form-group">
            <label for="matchtime">경기 시간</label>
            <input type="text" class="form-control" id="matchtime" name="matchtime" required>
        </div>
        <div class="form-group">
            <label for="hometeamid">홈팀 이름</label>
            <input type="text" class="form-control" id="hometeamid" name="hometeamid" required>
        </div>
        <div class="form-group">
            <label for="awayteamid">원정팀 이름</label>
            <input type="text" class="form-control" id="awayteamid" name="awayteamid" required>
        </div>
        <div class="form-group">
            <label for="stadiumid">경기장 이름</label>
            <input type="text" class="form-control" id="stadiumid" name="stadiumid" required>
        </div>
      
        <button type="submit" class="btn btn-success">저장하기</button>
    </form>
</div>
<!-- 본문 끝 -->

<%@ include file="../footer.jsp" %>