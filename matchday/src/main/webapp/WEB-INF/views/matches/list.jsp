<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>

<div class="container mt-4">
    <div class="row">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1>예매하기</h1>
            <!-- 세션 등급이 'M'일 때만 경기 일정 등록 버튼 보이기 -->
                <!-- <button type="button" class="btn btn-success" onclick="location.href='/write'">경기 일정 등록</button> -->
                <a href="/matches/write" class="btn btn-success">경기 일정 등록</a>
                <button type="button" class="btn btn-primary" onclick="openReservationPopup()">예매하기</button>
        </div>
    </div>

    <div class="mt-4">
        <!-- matchList를 순회하며 경기 일정을 표시 -->
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

<%@ include file="../footer.jsp" %>

<script>
    function openReservationPopup() {
        window.open('/tickets/ticketspayment', 'popup', 'width=800,height=600,scrollbars=yes');
    }
</script>