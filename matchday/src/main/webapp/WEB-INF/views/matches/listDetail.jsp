<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %> <!-- header.jsp include 시작 -->

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

    .match-form-container .btn-danger {
        width: 100%;
        padding: 10px;
        font-size: 18px;
        margin-top: 10px;
    }

    .match-form-container h1 {
        margin-bottom: 20px;
        color: #007bff;
        text-align: center;
    }
</style> <!-- CSS 스타일 끝 -->

<div class="match-form-container container mt-4">
    <h1>경기 일정 상세보기</h1>
    <form action="/matches/saveMatch" method="post">
        <input type="hidden" name="matchid" value="${match.matchid}">
        <div class="form-group">
            <label for="matchdate">경기 날짜</label>
            <input type="date" class="form-control" id="matchdate" name="matchdate" value="${matchdate}" required>
        </div> <!-- 경기 날짜 입력 끝 -->

        <div class="form-group">
            <label for="matchtime">경기 시간</label>
            <input type="time" class="form-control" id="matchtime" name="matchtime" value="${matchtime}" required>
        </div> <!-- 경기 시간 입력 끝 -->

        <div class="form-group">
            <label for="hometeamid">홈팀 이름</label>
            <select class="form-control" id="hometeamid" name="hometeamid" required>
                <c:forEach var="team" items="${teams}">
                    <option value="${team}" ${team == match.hometeamid ? 'selected' : ''}>${team}</option>
                </c:forEach>
            </select>
        </div> <!-- 홈팀 선택 끝 -->

        <div class="form-group">
            <label for="awayteamid">원정팀 이름</label>
            <select class="form-control" id="awayteamid" name="awayteamid" required>
                <c:forEach var="team" items="${teams}">
                    <option value="${team}" ${team == match.awayteamid ? 'selected' : ''}>${team}</option>
                </c:forEach>
            </select>
        </div> <!-- 원정팀 선택 끝 -->

        <div class="form-group">
            <label for="stadiumid">경기장 이름</label>
            <select class="form-control" id="stadiumid" name="stadiumid" required>
                <c:forEach var="stadium" items="${stadiums}">
                    <option value="${stadium}" ${stadium == match.stadiumid ? 'selected' : ''}>${stadium}</option>
                </c:forEach>
            </select>
        </div> <!-- 경기장 선택 끝 -->

        <div class="form-group">
            <label for="referee">심판 이름</label>
            <input type="text" class="form-control" id="referee" name="referee" value="${match.referee}" required>
        </div> <!-- 심판 이름 입력 끝 -->

        <div class="form-group">
            <label for="bookingstartdate">판매 시작일</label>
            <input type="datetime-local" class="form-control" id="bookingstartdate" name="bookingstartdate" value="${bookingstartdate}" required>
        </div> <!-- 판매 시작일 입력 끝 -->

        <div class="form-group">
            <label for="bookingenddate">판매 종료일</label>
            <input type="datetime-local" class="form-control" id="bookingenddate" name="bookingenddate" value="${bookingenddate}" required>
        </div> <!-- 판매 종료일 입력 끝 -->

        <button type="submit" class="btn btn-success">저장하기</button>
    </form> <!-- 경기 일정 상세보기 폼 끝 -->

    <!-- 삭제 버튼 -->
    <form action="/matches/delete/${match.matchid}" method="post" onsubmit="return confirmDelete();">
        <button type="submit" class="btn btn-danger">삭제하기</button>
    </form> <!-- 경기 삭제 폼 끝 -->
</div> <!-- 경기 일정 상세보기 컨테이너 끝 -->

<script>
    function confirmDelete() {
        return confirm("정말로 이 경기를 삭제하시겠습니까?");
    }
</script>

<%@ include file="../footer.jsp" %> <!-- footer.jsp include 끝 -->
