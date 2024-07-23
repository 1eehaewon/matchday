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
                <th>유효기간</th>
                <th>환불</th>
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
                            <c:when test="${membership.status == 'completed'}">
                                결제 완료
                            </c:when>
                            <c:when test="${membership.status == '환불완료'}">
                                환불 완료
                            </c:when>
                            <c:otherwise>
                                ${membership.status}
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <td>${membership.expirationstatus}</td> <!-- 유효기간 추가 -->
                    <td>
                        <c:choose>
                            <c:when test="${membership.status == '환불완료'}">
                                <button class="btn btn-danger" disabled>환불 완료</button>
                            </c:when>
                            <c:otherwise>
                                <button class="btn btn-danger" onclick="refund('${membership.usermembershipid}')">환불하기</button>
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>
<script>
function refund(userMembershipId) {
    $.ajax({
        type: "POST",
        url: "/membershipticket/refund",
        data: { usermembershipid: userMembershipId },
        success: function(response) {
            alert(response);
            location.reload(); // 현재 페이지를 다시 로드합니다.
        },
        error: function(error) {
            alert("환불 실패: " + error.responseText);
        }
    });
}
</script>

<%@ include file="../footer.jsp" %>