<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container mt-5">
    <!-- 1:1 문의 및 FAQ 링크 메뉴바 -->
	<div class="d-flex justify-content-center mb-4">
	    <div class="btn-group" role="group">
	        <a class="btn btn-outline-primary d-flex align-items-center" href="/customerService/customerPage">
	            <i class="bi bi-envelope-fill me-2"></i> 1:1 문의
	        </a>
	        <a class="btn btn-outline-primary d-flex align-items-center" href="/customerService/customerFaq">
	            <i class="bi bi-question-circle-fill me-2"></i> FAQ
	        </a>
	    </div>
	</div>

    <div class="d-flex justify-content-between mb-4 align-items-center">
        <h2 class="text-center m-0">FAQ</h2>
        <c:if test="${sessionScope.grade == 'M'}">
            <button type="button" class="btn btn-primary" onclick="location.href='/customerService/customerFaqForm'">
                <i class="bi bi-pencil-fill me-2"></i> FAQ 글쓰기
            </button>
        </c:if>
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
                        <c:out value="${faq.content}" escapeXml="false"/>
                        <c:if test="${sessionScope.grade == 'M'}">
                            <a href="/customerService/customerFaqDetail/${faq.inquiryID}" class="btn btn-link">
                                <i class="bi bi-eye-fill me-2"></i> 자세히 보기
                            </a>
                        </c:if>
                    </div>
                </div>
            </div>
        </c:forEach>
    </div>
</div>

<script>
    console.log("sessionScope.grade: ${sessionScope.grade}");  // 디버깅을 위해 추가
</script>

<%@ include file="../footer.jsp" %>
