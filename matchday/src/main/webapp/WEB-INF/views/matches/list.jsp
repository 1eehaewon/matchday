<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
<%@ include file="../header.jsp" %>

<style>
    .match-card {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px;
        margin-bottom: 20px;
        background-color: #fff;
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        transition: transform 0.3s, box-shadow 0.3s;
    }
    .match-card:hover {
        transform: translateY(-5px);
        box-shadow: 0 6px 12px rgba(0, 0, 0, 0.15);
    }
    .match-card h5 {
        margin-bottom: 15px;
        font-weight: bold;
        color: #343a40;
    }
    .team-container {
        text-align: center;
    }
    .team-logo {
        width: 60px;
        height: auto;
    }
    .teams {
        font-size: 1.25rem;
        font-weight: bold;
    }
    .vs {
        font-size: 1.5rem;
        font-weight: bold;
        color: #dc3545;
    }
    .stadium {
        margin-top: 10px;
        font-size: 1rem;
        color: #6c757d;
    }
    .booking-dates {
        font-size: 0.9rem;
        color: #6c757d;
        margin-top: 10px;
    }
    .btn-book {
        margin-top: 15px;
    }
</style>

<script>
    function openPopup(url) {
        window.open(url, "popupWindow", "width=1200,height=800,scrollbars=yes");
    }

    function handleBooking(matchId) {
        var now = new Date().getTime();
        
        $.ajax({
            url: "/matches/getBookingEndDate",
            type: "GET",
            data: { matchid: matchId },
            success: function(result) {
                var endDate = new Date(result).getTime();
                
                if (now > endDate) {
                    alert("판매가 종료된 경기입니다.");
                } else {
                    var isLoggedIn = '${sessionScope.userID}' !== '';
                    if (isLoggedIn) {
                        openPopup('/tickets/ticketspayment?matchid=' + matchId);
                    } else {
                        alert("로그인 후 이용해주세요.");
                    }
                }
            },
            error: function(error) {
                alert("판매 종료일 조회에 실패했습니다.");
            }
        });
    }
</script>

<div class="container mt-4">
    <div class="row">
        <div class="col-12 d-flex justify-content-between align-items-center">
            <h1>예매하기</h1>
            <!-- 회원 등급이 M인 경우에만 경기 일정 등록 버튼 표시 -->
            <c:if test="${sessionScope.grade == 'M'}">
                <a href="/matches/write" class="btn btn-success">경기 일정 등록</a>
            </c:if>
        </div>
    </div>

    <!-- 팀 검색 섹션 시작 -->
    <div class="row mt-4">
        <div class="col-12">
            <form action="/matches/search" method="get" class="d-flex">
                <select name="teamname" class="form-control mr-2">
                    <option value="">전체</option>
                    <c:forEach var="team" items="${teams}">
                        <option value="${team}">${team}</option>
                    </c:forEach>
                </select>
                <button type="submit" class="btn btn-primary">검색</button>
            </form>
        </div>
    </div>
    <!-- 팀 검색 섹션 끝 -->

    <div class="mt-4">
        <c:forEach var="match" items="${matchList}">
            <div class="match-card p-3 shadow-sm rounded">
                <h5 class="text-center mb-4">
                    <fmt:formatDate value="${match.matchdate}" pattern="yyyy년 M월 d일 E요일 a h시 m분" />
                </h5>
                <div class="row align-items-center">
                    <div class="col text-end">
                        <div class="team-container">
                            <img src="/storage/matchimg/${match.hometeamid}.jpg" alt="${match.hometeamid} 로고" class="team-logo img-fluid">
                            <div class="teams mt-2">${match.hometeamid}</div>
                        </div>
                    </div>
                    <div class="col text-center">
                        <div class="vs">VS</div>
                    </div>
                    <div class="col text-start">
                        <div class="team-container">
                            <img src="/storage/matchimg/${match.awayteamid}.jpg" alt="${match.awayteamid} 로고" class="team-logo img-fluid">
                            <div class="teams mt-2">${match.awayteamid}</div>
                        </div>
                    </div>
                </div>
                <div class="text-center stadium mt-3">
                    경기장: ${match.stadiumname}
                </div>
                <div class="text-center booking-dates mt-2">
                    판매 시작일: <fmt:formatDate value="${match.bookingstartdate}" pattern="yyyy-MM-dd HH:mm" />
                    <br>
                    판매 종료일: <fmt:formatDate value="${match.bookingenddate}" pattern="yyyy-MM-dd HH:mm" />
                </div>
                <div class="text-center mt-3">
                    <button type="button" class="btn btn-success btn-book" onclick="handleBooking('${match.matchid}')">
                        예매하기
                    </button>
                    <c:if test="${sessionScope.grade == 'M'}">
                        <div class="text-center mt-2">
                            <a href="/matches/detail/${match.matchid}" class="btn btn-primary">상세 보기</a>
                        </div>
                    </c:if>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="../footer.jsp" %>
