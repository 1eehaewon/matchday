<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-4"> <!-- mt-4 클래스 추가하여 위쪽 여백 추가 -->
    <div class="row">
        <div class="col-6">
            <h1>하이라이트</h1>
        </div>
        <div class="col-6 text-right">
            <c:if test="${sessionScope.grade == 'M'}">
                <button type="button" class="btn btn-success" onclick="location.href='write'">하이라이트 등록</button>
            </c:if>
        </div>
    </div>
    
    <!-- 검색 시작-->
    <div class="row justify-content-end mb-3"> <!-- 수정된 부분 -->
        <div class="col-sm-3"> <!-- 수정된 부분 -->
            <form method="get" action="search" class="form-inline">
                <div class="input-group">
                    <input type="text" name="video_name" id="video_name" value="${video_name}" class="form-control" placeholder="하이라이트명 입력">
                    <div class="input-group-append">
                        <input type="submit" value="검색" class="btn btn-primary">
                    </div>
                </div>
            </form>
        </div>
    </div> 
      <!-- 검색 끝 -->
      
    <div class="row">
        <c:forEach items="${list}" var="row" varStatus="vs">
            <div class="col-sm-4 col-md-4 mb-4">
                <c:choose>
                    <c:when test="${row.video_name != '-'}">
                        <a href="detail?video_code=${row.video_code}">
                            <iframe width="100%" height="315" src="${row.video_url}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                        </a> 
                    </c:when>
                    <c:otherwise>
                        등록된 영상 없음!!<br>
                    </c:otherwise>
                </c:choose>
                <br>        
                경기 : 
                <a href="detail?video_code=${row.video_code}">${row.video_name}</a> 
                <br>
                경기 내용 : 
                <p>${row.description}</p>               
            </div>
                                   
            <!-- 한줄에 3칸씩 -->
            <c:if test="${vs.count mod 3 == 0}">
                </div><!-- row end -->
                <div style="height: 50px;"></div>
                <div class="row">
            </c:if>
        </c:forEach> 
    </div><!-- row end -->

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
                                <a href="?page=${currentPage + 1}" aria-label="Next">
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

<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.1/js/bootstrap.min.js"></script>

<%@ include file="../footer.jsp" %>
