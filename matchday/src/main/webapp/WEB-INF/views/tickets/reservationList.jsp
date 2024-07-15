<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <h1 class="text-center mb-4">예매내역</h1>

    <div class="table-responsive">
        <table class="table table-striped table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>예매일</th>
                    <th>예약번호</th>
                    <th>상품명</th>
                    <th>이용일/매수</th>
                    <th>취소가능일</th>
                    <th>현재상태</th>
                </tr>
            </thead>
            <tbody>
                <c:forEach var="reservation" items="${reservations}">
                    <tr>
                        <td><fmt:formatDate value="${reservation.reservationdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td><a href="/tickets/reservationDetail?reservationid=${reservation.reservationid}" class="link-primary">${reservation.reservationid}</a></td>
                        <td style="white-space: nowrap;">${reservation.hometeamid} vs ${reservation.awayteamid}</td>
                        <td><fmt:formatDate value="${reservation.matchdate}" pattern="yyyy-MM-dd HH:mm:ss"/> / ${reservation.quantity}</td>
                        <td><fmt:formatDate value="${reservation.matchdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                        <td>
                            <c:choose>
                                <c:when test="${reservation.reservationstatus == 'Confirmed'}">
                                    <span class="badge bg-success">결제완료</span>
                                </c:when>
                                <c:otherwise>
                                    <span class="badge bg-danger">결제취소</span>
                                </c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>
</div>

<%@ include file="../footer.jsp" %>
