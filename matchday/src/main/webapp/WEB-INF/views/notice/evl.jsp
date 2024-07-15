<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt"%>

<%@ include file="../header.jsp"%>

<!-- 본문 시작 main.jsp -->
<main>
<hr style="width: 65%; margin-left: auto; margin-right: auto;">
    <div class="row">
        <div class="col-sm-12">
            <h3 style="margin-left: 18%;">이벤트</h3>
            <hr style="width: 65%; margin-left: auto; margin-right: auto;">
        </div>
    </div>

    <div class="row justify-content-end mb-3" style="margin-right: 16%;">
        <div class="col-auto">
            <form method="get" action="searching">
                제목 : <input type="text" name="title" value="${title}">
                <input type="submit" value="검색" class="btn btn-primary d-inline-block">
            </form>
        </div>
    </div>

    <c:if test="${not empty evl}">
        <div class="row justify-content-center">
            <div class="col-sm-8">
                <table class="table table-hover shadow rounded">
                    <thead class="table-success">
                        <tr>
                            <th>제목</th>
                            <th style="width: 20%;">작성자</th>
                            <th style="width: 20%;">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach items="${evl}" var="row" varStatus="vs">
                            <tr onclick="location.href='detail?noticeid=${row.noticeid}'" style="cursor: pointer;">
                                <td>${row.title}</td>
                                <td>${row.userid}</td>
                                <td><fmt:formatDate value="${row.createddate}" pattern="yyyy-MM-dd"/></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>

    <c:if test="${empty evl}">
        <div class="row justify-content-center">
            <div class="col-sm-8">
                <table class="table table-hover shadow rounded">
                    <thead class="table-success">
                        <tr>
                            <th>제목</th>
                            <th style="width: 20%;">작성자</th>
                            <th style="width: 20%;">작성일</th>
                        </tr>
                    </thead>
                    <tbody>
                        <tr>
                            <td colspan="4" style="text-align: center;">공지사항 글 없음</td>
                        </tr>
                    </tbody>
                </table>
            </div>
        </div>
    </c:if>
  
  <c:if test="${sessionScope.grade == 'M'}">
    <div class="row justify-content-center">
        <div class="col-auto">
            <input type="button" value="글쓰기" class="btn btn-success" onclick="location.href='write'">
        </div>
    </div>
  </c:if>
    <div class="spacing"></div>

    <!-- 페이지 리스트 시작 -->
    <div style="text-align: center;">
    <c:if test="${not empty evl}">
        <div class="content">
            <c:if test="${evlEndPage > totalPage}">
                <c:set var="evlEndPage" value="${totalPage + 1}" />
            </c:if>

            <c:if test="${startPage > 0}">
                <a href="evl?pageNum=${startPage}">[이전]</a>
            </c:if>

            <c:if test="${endPage > startPage}">
               <c:forEach var="i" begin="${startPage + 1}" end="${endPage - 1}">
                  <c:choose>
                     <c:when test="${evlPageNum == i}">
                        <span style="font-weight: bold">${i}</span>
                     </c:when>
                     <c:otherwise>
                        <a href="evl?pageNum=${i}">${i}</a>
                     </c:otherwise>
                  </c:choose>
               </c:forEach>
             </c:if>


            <c:if test="${endPage < totalPage}">
                <a href="evl?pageNum=${startPage + 11}">[다음]</a>
            </c:if>
        </div>
    </c:if>
</div>
    
    
    <div class="spacing"></div>
    
    
    <!-- 페이지 리스트 끝 -->

</main>

<style>
.spacing {
    height: 20px;
}
</style>

<%@ include file="../footer.jsp"%>