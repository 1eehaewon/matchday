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
        background-color: #f9f9f9;
    }
    .match-card h5 {
        margin-bottom: 15px;
    }
    .team-container {
        text-align: center;
    }
    .team-logo {
        width: 50px; /* 원하는 크기로 설정 */
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
    .btn-book {
        margin-top: 15px;
    }
    .booking-dates {
        font-size: 0.9rem;
        color: #6c757d;
        margin-top: 10px;
    }
</style>

<script>
    function openPopup(url) {
        window.open(url, "popupWindow", "width=1200,height=800,scrollbars=yes");
    }

    function handleBooking(matchId) {
        // 현재 날짜와 시간 가져오기
        var now = new Date().getTime();
        
        // Ajax를 통해 서버에서 판매 종료일을 조회
        $.ajax({
            url: "/matches/getBookingEndDate",
            type: "GET",
            data: { matchid: matchId },
            success: function(result) {
                // 조회한 판매 종료일을 Date 객체로 변환
                var endDate = new Date(result).getTime();
                
                // 판매 종료일이 현재 날짜와 시간 이전인지 확인
                if (now > endDate) {
                    alert("판매가 종료된 경기입니다.");
                } else {
                    // 로그인 여부를 세션에서 확인
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

    <div class="mt-4">
        <c:forEach var="match" items="${matchList}">
            <div class="match-card" data-bookingenddate="${match.bookingenddate}">
                <h5 class="text-center">
                    <fmt:formatDate value="${match.matchdate}" pattern="yyyy년 M월 d일 E요일 a h시 m분" />
                </h5>
                <div class="row align-items-center">
                    <div class="col text-end">
                        <div class="team-container">
                            <img src="/storage/matchimg/${match.hometeamid}.jpg" alt="${match.hometeamid} 로고" class="team-logo">
                            <div class="teams">${match.hometeamid}</div>
                        </div>
                    </div>
                    <div class="col text-center">
                        <div class="vs">VS</div>
                    </div>
                    <div class="col text-start">
                        <div class="team-container">
                            <img src="/storage/matchimg/${match.awayteamid}.jpg" alt="${match.awayteamid} 로고" class="team-logo">
                            <div class="teams">${match.awayteamid}</div>
                        </div>
                    </div>
                </div>
                <div class="text-center stadium">
                    경기장: ${match.stadiumname}
                </div>
                <div class="text-center booking-dates">
                    판매 시작일: <fmt:formatDate value="${match.bookingstartdate}" pattern="yyyy-MM-dd HH:mm" />
                    <br>
                    판매 종료일: <fmt:formatDate value="${match.bookingenddate}" pattern="yyyy-MM-dd HH:mm" />
                </div>
                <div class="text-center">
                    <button type="button" class="btn btn-success btn-book" 
                            onclick="handleBooking('${match.matchid}')">
                        예매하기
                    </button>
                    <!-- 회원 등급이 M인 경우에만 상세 보기 버튼 표시 -->
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
