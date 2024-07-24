<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ include file="../header.jsp" %>

<style>
    .col-centered {
        display: flex;
        justify-content: center;
        align-items: center;
        flex-direction: column;
    }
    .mt-3 {
        margin-top: 1rem !important;
    }
    .mb-5 {
        margin-bottom: 3rem !important;
    }
    .mr-2 {
        margin-right: 0.5rem !important;
    }
    .ml-auto {
        margin-left: auto !important;
    }
</style>

<div class="container">
    <div class="row justify-content-between mb-5">
        <div class="col-6">
            <h1>인스타그램 게시글 목록</h1>
        </div>
        <div class="col-6 mt-3 text-right">
            <button type="button" class="btn btn-success ml-auto mr-2" onclick="location.href='write'">인스타그램 등록</button>
        </div>
    </div>

    <div class="row justify-content-center">
        <c:forEach items="${list}" var="row" varStatus="vs">
            <div class="col-sm-4 col-md-4 mb-4 col-centered">
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
                </div>
                <div style="height: 50px;"></div>
                <div class="row justify-content-center">
            </c:if>
        </c:forEach>
    </div>
</div>

<%@ include file="../footer.jsp" %>
