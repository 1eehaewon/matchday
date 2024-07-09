<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header.jsp" %>

<div class="row">
    <div class="col-6">
        <h1>인스타그램 게시글 목록</h1>
    </div>
    <div class="col-6 text-right">
        <button type="button" class="btn btn-success" onclick="location.href='write'">인스타그램 등록</button>
    </div><!-- col end -->
</div><!-- row end -->

<div class="row">
    <c:forEach items="${list}" var="row" varStatus="vs">
        <div class="col-sm-4 col-md-4 mb-4">
            <c:choose>
                <c:when test="${not empty row.instagram_url}">
                    <div>
                        <a href="<c:url value='/instagram/detail' />?instagram_code=${row.instagram_code}">
                            <h5>${row.instagram_name}</h5>
                        </a>
                    </div>
                    <div>
                        <blockquote class="instagram-media" data-instgrm-permalink="${row.instagram_url}" data-instgrm-version="12"></blockquote>
                        <script async src="//www.instagram.com/embed.js"></script>
                    </div>
                </c:when>
                <c:otherwise>
                    <p>등록된 인스타그램 없음!!</p>
                </c:otherwise>
            </c:choose>
        </div>
        <!-- 한 줄에 3칸씩 -->
        <c:if test="${vs.index % 3 == 2}">
            </div><!-- row end -->
            <div style="height: 50px;"></div>
            <div class="row">
        </c:if>
    </c:forEach>
</div><!-- row end --> 

<%@ include file="../footer.jsp" %>
