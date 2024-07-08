<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../header.jsp" %>

<style>
    .match-card {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 20px;
        background-color: #f9f9f9;
    }
    .match-card h5 {
        margin-bottom: 15px;
    }
    .match-card .teams {
        font-size: 1.25rem;
        font-weight: bold;
    }
    .match-card .vs {
        font-size: 1.5rem;
        font-weight: bold;
        color: #dc3545;
    }
    .match-card .stadium {
        margin-top: 10px;
        font-size: 1rem;
        color: #6c757d;
    }
    .match-card .btn-book {
        margin-top: 15px;
    }
</style>

<script>
    function openPopup(url) {
        window.open(url, "popupWindow", "width=1200,height=800,scrollbars=yes");
    }
</script>

<div class="container mt-4">
    <div class="row">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1>예매하기</h1>
            <a href="/matches/write" class="btn btn-success">경기 일정 등록</a>
        </div>
    </div>

    <div class="mt-4">
        <c:forEach var="match" items="${matchList}">
            <div class="match-card">
                <h5 class="text-center">
                    <fmt:formatDate value="${match.matchdate}" pattern="yyyy년 M월 d일 E요일 a h시 m분" />
                </h5>
                <div class="row align-items-center">
                    <div class="col text-end">
                        <div class="teams">${match.hometeamid}</div>
                    </div>
                    <div class="col text-center">
                        <div class="vs">VS</div>
                    </div>
                    <div class="col text-start">
                        <div class="teams">${match.awayteamid}</div>
                    </div>
                </div>
                <div class="text-center stadium">
                    경기장: ${match.stadiumid}
                </div>
                <div class="text-center">
                    <button type="button" class="btn btn-success btn-book" onclick="openPopup('/tickets/ticketspayment?matchid=${match.matchid}')">
                        예매하기
                    </button>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="../footer.jsp" %>
