<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-4">
    <h1>예매내역 확인・취소</h1>

    <table class="table table-bordered">
        <thead>
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
                    <td>${reservation.reservationdate}</td>
                    <td>${reservation.reservationid}</td>
                    <td>${reservation.hometeamid} vs ${reservation.awayteamid}</td>
                    <td>${reservation.matchdate} / ${reservation.quantity}</td>
                    <td><fmt:formatDate value="${reservation.matchdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${reservation.reservationstatus == 'Confirmed'}">
                                결제완료
                            </c:when>
                            <c:otherwise>
                                취소
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="../footer.jsp" %>
