<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../header.jsp" %>

<div class="container text-center" style="margin-top: 50px;"> <!-- 상단 간격 추가 -->
    <div class="row">
        <div class="col-6">
            <h1 style="margin-bottom: 130px; text-align: left;" >멤버쉽 구매🎫</h1>
        </div>
        <c:if test="${sessionScope.grade == 'M'}">
        <div class="col-6 text-right">         
            <button type="button" class="btn btn-success" onclick="location.href='write'">멤버쉽 등록</button>
            <button type="button" class="btn btn-primary" onclick="location.href='list'">멤버쉽 전체 목록</button>               
        </div>
        </c:if>
    </div>
    
    <!-- 검색 시작 -->
    <div class="row justify-content-end mb-3"> <!-- 수정된 부분 -->
        <div class="col-sm-3"> <!-- 수정된 부분 -->
            <form method="get" action="search" class="form-inline">
                <div class="input-group">
                    <input type="text" name="membershipname" id="membershipname" value="${membershipname}" class="form-control" placeholder="멤버쉽명 입력">
                    <div class="input-group-append">
                        <input type="submit" value="검색" class="btn btn-primary">
                    </div>
                </div>
            </form>
        </div>
    </div>
    <!-- 검색 끝 -->
    
    <div class="row">
        <c:forEach items="${list}" var="row">
            <div class="col-sm-4 col-md-4" style="margin-bottom: 30px;">
                <c:choose>
                    <c:when test="${row.filename != '-'}">
                        <a href="detail?membershipid=${row.membershipid}">
                            <img src="/storage/memberships/${row.filename}" class="img-responsive margin" style="width:100%; height:200px; object-fit:cover;">
                        </a>
                    </c:when>
                    <c:otherwise>
                        등록된 팀 로고 없음 !!<br>
                    </c:otherwise>
                </c:choose>
                <br>
                <!-- 간격을 추가하기 위해 여기에 스타일 추가 -->
                <div style="margin-top: 30px;">
                    <a href="detail?membershipid=${row.membershipid}">멤버쉽 : ${row.membershipname}</a>
                </div>
                <br>
                <!-- 가격도 같은 스타일 적용 -->
                <div style="margin-top: 2px;">
                    <a href="detail?membershipid=${row.membershipid}">가격 : <fmt:formatNumber value="${row.price}" pattern="#,###"/> 원</a>
                </div>
            </div>
        </c:forEach>
    </div>
    
    <!-- 페이지 네이션 -->
    <div class="row">
        <div class="col-12">
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li>
                                <a href="?page=${currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="${i == currentPage ? 'active' : ''}">
                                <a href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li>
                                <a href="?page={currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
</div>

<%@ include file="../footer.jsp" %>
