<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
    
<%@ include file="../header.jsp" %>

<div class="container text-center">
    <div class="row">
        <div class="col-6">
            <h1>멤버쉽 구매</h1>
        </div>
        <div class="col-6 text-right">         
            <button type="button" class="btn btn-success" onclick="location.href='write'">멤버쉽 등록</button>
            <button type="button" class="btn btn-primary" onclick="location.href='list'">멤버쉽 전체 목록</button>               
        </div>
    </div>
    <div class="row">
        <c:forEach items="${list}" var="row">
            <div class="col-sm-4 col-md-4">
                <c:choose>
                    <c:when test="${row.filename != '-'}">
                        <img src="/storage/memberships/${row.filename}" class="img-responsive margin" style="width:100%">
                    </c:when>
                    <c:otherwise>
                        등록된 팀 로고 없음 !!<br>
                    </c:otherwise>
                </c:choose>
                <br>
                <a href="detail?membershipid=${row.membershipid}">멤버쉽 : ${row.membershipname}</a>
                <br>
                가격 : <fmt:formatNumber value="${row.price}" pattern="#,###"/> 원
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="../footer.jsp" %>
