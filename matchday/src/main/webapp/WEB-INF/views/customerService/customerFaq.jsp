<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <!-- 1:1 문의 및 FAQ 링크 메뉴바 -->
    <div class="d-flex justify-content-center mb-4">
        <ul class="nav nav-pills">
            <li class="nav-item">
                <a class="nav-link" href="/customerService/customerPage">1:1 문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/customerService/customerFaq">FAQ</a>
            </li>
        </ul>
    </div>      

    <div class="d-flex justify-content-between mb-4">
        <h2 class="text-center">FAQ</h2>
        <button type="button" class="btn btn-primary" onclick="location.href='/customerService/customerFaqForm'">FAQ 글쓰기</button>
    </div>

    <div class="accordion" id="faqAccordion">
        <c:forEach var="faq" items="${faqList}">
            <div class="accordion-item">
                <h2 class="accordion-header" id="heading${faq.inquiryID}">
                    <button class="accordion-button collapsed" type="button" data-bs-toggle="collapse" data-bs-target="#collapse${faq.inquiryID}" aria-expanded="false" aria-controls="collapse${faq.inquiryID}">
                        ${faq.title}
                    </button>
                </h2>
                <div id="collapse${faq.inquiryID}" class="accordion-collapse collapse" aria-labelledby="heading${faq.inquiryID}" data-bs-parent="#faqAccordion">
                    <div class="accordion-body">
                        ${faq.content}
                        <a href="/customerService/customerFaqDetail/${faq.inquiryID}" class="btn btn-link">자세히 보기</a>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<%@ include file="../footer.jsp" %>
