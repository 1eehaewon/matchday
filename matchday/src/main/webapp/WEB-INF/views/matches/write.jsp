<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<!-- Custom CSS for additional styling -->
<style>
    .match-form-container {
        max-width: 600px;
        margin-top: 50px;
    }

    .match-form-container .form-group label {
        font-weight: bold;
    }

    .match-form-container .btn-success {
        width: 100%;
        padding: 10px;
        font-size: 18px;
    }

    .match-form-container h1 {
        margin-bottom: 20px;
        color: #007bff;
        text-align: center;
    }
</style>

<div class="match-form-container container mt-4">
    <h1>경기 일정 등록</h1>
    <form action="saveMatch" method="post">
        <div class="form-group">
            <label for="matchdate">경기 날짜</label>
            <input type="date" class="form-control" id="matchdate" name="matchdate" required>
        </div>
        <div class="form-group">
            <label for="matchtime">경기 시간</label>
            <input type="time" class="form-control" id="matchtime" name="matchtime" required>
        </div>
        <div class="form-group">
            <label for="hometeamid">홈팀 이름</label>
            <select class="form-control" id="hometeamid" name="hometeamid" required>
                <c:forEach var="team" items="${teams}">
                    <option value="${team}">${team}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label for="awayteamid">원정팀 이름</label>
            <select class="form-control" id="awayteamid" name="awayteamid" required>
                <c:forEach var="team" items="${teams}">
                    <option value="${team}">${team}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label for="stadiumid">경기장 이름</label>
            <select class="form-control" id="stadiumid" name="stadiumid" required>
                <c:forEach var="stadium" items="${stadiums}">
                    <option value="${stadium}">${stadium}</option>
                </c:forEach>
            </select>
        </div>
        <div class="form-group">
            <label for="referee">심판 이름</label>
            <input type="text" class="form-control" id="referee" name="referee">
        </div>
        <div class="form-group">
            <label for="bookingstartdate">판매 시작일</label>
            <input type="datetime-local" class="form-control" id="bookingstartdate" name="bookingstartdate" required>
        </div>
        <div class="form-group">
            <label for="bookingenddate">판매 종료일</label>
            <input type="datetime-local" class="form-control" id="bookingenddate" name="bookingenddate" required>
        </div>
        <button type="submit" class="btn btn-success">저장하기</button>
    </form>
</div>

<%@ include file="../footer.jsp" %>
