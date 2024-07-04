<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<%@ page import="java.sql.*, java.util.*" %>

<%
// 데이터베이스에서 데이터 불러오기
List<Map<String, Object>> matchList = new ArrayList<>();
try {
    Class.forName("com.mysql.cj.jdbc.Driver");
    Connection conn = DriverManager.getConnection("jdbc:mysql://localhost:3306/yourdatabase", "yourusername", "yourpassword");
    String sql = "SELECT matchid, hometeamid, awayteamid, stadiumid, matchdate, matchtime FROM matches";
    Statement stmt = conn.createStatement();
    ResultSet rs = stmt.executeQuery(sql);
    while (rs.next()) {
        Map<String, Object> match = new HashMap<>();
        match.put("matchid", rs.getString("matchid"));
        match.put("hometeamid", rs.getString("hometeamid"));
        match.put("awayteamid", rs.getString("awayteamid"));
        match.put("stadiumid", rs.getString("stadiumid"));
        match.put("matchdate", rs.getString("matchdate"));
        match.put("matchtime", rs.getInt("matchtime"));
        matchList.add(match);
    }
    rs.close();
    stmt.close();
    conn.close();
} catch (Exception e) {
    e.printStackTrace();
}
pageContext.setAttribute("matchList", matchList);
%>

<!-- 본문 시작 list.jsp -->
<div class="container mt-4">
    <div class="row">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1>예매하기</h1>
            <c:if test="${sessionScope.grade == 'M'}">
                <button type="button" class="btn btn-success" onclick="location.href='write.jsp'">경기 일정 등록</button>
                <button type="button" class="btn btn-primary" onclick="openReservationPopup()">예매하기</button>
            </c:if>
        </div>
    </div>

    <div class="mt-4">
        <c:forEach var="match" items="${matchList}">
            <div class="row align-items-center mb-3 border p-2">
                <div class="col-md-2 text-center">
                    <div>${match.matchdate}</div>
                    <div>${match.matchtime}</div>
                </div>
                <div class="col-md-2 text-center">
                    <div>${match.hometeamid}</div>
                </div>
                <div class="col-md-1 text-center">
                    VS
                </div>
                <div class="col-md-2 text-center">
                    <div>${match.awayteamid}</div>
                </div>
                <div class="col-md-3 text-center">
                    <div>홈: ${match.stadiumid}</div>
                </div>
                <div class="col-md-2 text-center">
                    <button type="button" class="btn btn-success">
                        예매하기
                    </button>
                </div>
            </div>
        </c:forEach>
    </div>
</div>
<!-- 본문 끝 -->

<%@ include file="../footer.jsp" %>

<script>
    function openReservationPopup() {
        window.open('/tickets/ticketspayment', 'popup', 'width=800,height=600,scrollbars=yes');
    }
</script>
