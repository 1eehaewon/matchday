<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<%@ include file="../header.jsp" %>

<div class="container mt-4">
    <h2>멤버쉽 구매 목록</h2>
    <table class="table table-bordered">
        <thead>
            <tr>
                <th>구매 날짜</th>
                <th>멤버쉽 ID</th>
                <th>멤버쉽 이름</th>
                <th>멤버쉽 시작 날짜</th>
                <th>멤버쉽 종료 날짜</th>
                <th>결제 상태</th>
                <th>환불</th> <!-- 환불하기 버튼을 위한 새로운 열 -->
            </tr>
        </thead>
        <tbody>
            <c:forEach var="membership" items="${membershipDetails}">
                <tr>
                    <td><fmt:formatDate value="${membership.purchasedate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                    <td>${membership.membershipid}</td>
                    <td>${membership.membershipname}</td>
                    <td><fmt:formatDate value="${membership.startdate}" pattern="yyyy-MM-dd"/></td>
                    <td><fmt:formatDate value="${membership.enddate}" pattern="yyyy-MM-dd"/></td>
                    <td>
                        <c:choose>
                            <c:when test="${membership.status == '환불완료'}">
                                환불완료
                            </c:when>
                            <c:otherwise>
                                결제 완료
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>
                        <c:if test="${membership.status != '환불완료'}">
                            <form action="/membershipticket/refund" method="post">
                                <input type="hidden" name="userMembershipId" value="${membership.usermembershipid}">
                                <button type="submit" class="btn btn-danger">환불하기</button>
                            </form>
                        </c:if>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<%@ include file="../footer.jsp" %>
