<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ include file="../header.jsp" %>

<main>
<div class="container mt-5">
    <!-- 1:1 문의 및 FAQ 링크 메뉴바 -->
    <div class="d-flex justify-content-center mb-4">
        <ul class="nav nav-pills">
            <li class="nav-item">
                <a class="nav-link" href="/CustomerService/CustomerPage">1:1 문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link" href="/CustomerService/CustomerFAQ">FAQ</a>
            </li>
        </ul>
    </div>

    <!-- 상단 메뉴 바 -->
    <div class="d-flex justify-content-center mb-4">
        <ul class="nav nav-tabs" id="categoryTabs">
            <li class="nav-item">
                <a class="nav-link ${category == 'all' ? 'active' : ''}" href="?category=all&page=1" data-category="all">전체</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '1' ? 'active' : ''}" href="?category=1&page=1" data-category="1">상품문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '2' ? 'active' : ''}" href="?category=2&page=1" data-category="2">경기문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '3' ? 'active' : ''}" href="?category=3&page=1" data-category="3">배송문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '4' ? 'active' : ''}" href="?category=4&page=1" data-category="4">주문/결제</a>
            </li>
        </ul>
    </div>

    <!-- 테이블 -->
    <div class="table-responsive">
        <table class="table table-hover table-bordered">
            <thead class="table-light">
                <tr>
                    <th scope="col" class="text-center">번호</th>
                    <th scope="col" class="text-center">카테고리</th>
                    <th scope="col" class="text-center">제목</th>
                    <th scope="col" class="text-center">작성자</th>
                    <th scope="col" class="text-center">등록일</th>
                    <th scope="col" class="text-center">답변처리상태</th>
                </tr>
            </thead>
            <tbody id="inquiryTableBody">
                <c:forEach var="inquiry" items="${inquiryList}">
                    <tr data-category="${inquiry.boardType}">
                        <td class="text-center">${inquiry.inquiryID}</td>
                        <td class="text-center">
                            <c:choose>
                                <c:when test="${inquiry.boardType == 1}">상품문의</c:when>
                                <c:when test="${inquiry.boardType == 2}">경기문의</c:when>
                                <c:when test="${inquiry.boardType == 3}">배송문의</c:when>
                                <c:when test="${inquiry.boardType == 4}">주문/결제</c:when>
                                <c:otherwise>알 수 없음</c:otherwise>
                            </c:choose>
                        </td>
                        <td class="text-center">
                            <a href="#" data-href="CustomerDetail/${inquiry.inquiryID}" data-bs-toggle="modal" data-bs-target="#passwordModal">
                                ${inquiry.title}
                            </a>
                        </td>
                        <td class="text-center">${inquiry.userID}</td>
                        <td class="text-center">${inquiry.formattedCreatedDate}</td>
                        <td class="text-center">${inquiry.isReplyHandled}</td>
                    </tr>
                </c:forEach>
            </tbody>
        </table>
    </div>

    <!-- 페이징 -->
    <nav aria-label="Page navigation example" class="my-4">
        <ul>
            <c:if test="${currentPage > 1}">
                <li class="page-item">
                    <a class="page-link" href="?category=${category}&page=${currentPage - 1}&col=${col}&word=${word}" aria-label="Previous">
                        <span aria-hidden="true">&laquo;</span>
                    </a>
                </li>
            </c:if>
            <c:forEach begin="1" end="${totalPages}" var="i">
                <li class="page-item ${i == currentPage ? 'active' : ''}">
                    <a class="page-link" href="?category=${category}&page=${i}&col=${col}&word=${word}">${i}</a>
                </li>
            </c:forEach>
            <c:if test="${currentPage < totalPages}">
                <li class="page-item">
                    <a class="page-link" href="?category=${category}&page=${currentPage + 1}&col=${col}&word=${word}" aria-label="Next">
                        <span aria-hidden="true">&raquo;</span>
                    </a>
                </li>
            </c:if>
        </ul>
    </nav>

    <!-- 검색폼 시작 -->
    <form class="row g-3 justify-content-center mb-4" action="CustomerPage" method="get" onsubmit="return searchCheck()">
        <div class="col-auto">
            <select name="col" class="form-select">
                <option value="subject_content" ${col == 'subject_content' ? 'selected' : ''}>제목+내용</option>
                <option value="title" ${col == 'title' ? 'selected' : ''}>제목</option>
                <option value="content" ${col == 'content' ? 'selected' : ''}>내용</option>
                <option value="userID" ${col == 'userID' ? 'selected' : ''}>작성자</option>
            </select>
        </div>
        <div class="col-auto">
            <input type="text" name="word" id="word" class="form-control" value="${word}" placeholder="검색어">
        </div>
        <div class="col-auto">
            <button type="submit" class="btn btn-secondary">검색</button>
        </div>
        <div class="col-auto">
            <!-- 글쓰기 버튼, 클릭 시 CustomerForm.jsp로 이동 -->
            <button type="button" class="btn btn-primary" onclick="location.href='CustomerForm'">글쓰기</button>
        </div>
    </form>
    <!-- 검색폼 끝 -->
</div>
</main>

<!-- 비밀번호 입력 모달 -->
<div class="modal fade" id="passwordModal" tabindex="-1" aria-labelledby="passwordModalLabel" aria-hidden="true">
    <div class="modal-dialog">
        <div class="modal-content">
            <div class="modal-header">
                <h5 class="modal-title" id="passwordModalLabel">비밀번호 입력</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
            </div>
            <div class="modal-body">
                <form id="passwordForm">
                    <div class="mb-3">
                        <label for="modalPassword" class="form-label">비밀번호</label>
                        <input type="password" class="form-control" id="modalPassword" required>
                    </div>
                    <button type="submit" class="btn btn-primary">확인</button>
                </form>
            </div>
        </div>
    </div>
</div>

<script>
document.addEventListener('DOMContentLoaded', function() {
    const categoryTabs = document.getElementById('categoryTabs');
    const inquiryTableBody = document.getElementById('inquiryTableBody');
    let targetUrl = '';

    categoryTabs.addEventListener('click', function(e) {
        if (e.target.tagName === 'A') {
            e.preventDefault();
            const category = e.target.getAttribute('data-category');

            categoryTabs.querySelectorAll('a').forEach(a => a.classList.remove('active'));
            e.target.classList.add('active');

            const urlParams = new URLSearchParams(window.location.search);
            urlParams.set('category', category);
            urlParams.set('page', 1);
            window.location.search = urlParams.toString();
        }
    });

    // 페이지 위치 저장 및 복원
    if (sessionStorage.scrollPos) {
        window.scrollTo(0, sessionStorage.scrollPos);
    }
    window.addEventListener('beforeunload', function() {
        sessionStorage.scrollPos = window.scrollY;
    });

    // 비밀번호 모달 관련
    $('#passwordModal').on('show.bs.modal', function(event) {
        const button = $(event.relatedTarget);
        targetUrl = button.data('href');
    });

    $('#passwordForm').on('submit', function(event) {
        event.preventDefault();
        const password = $('#modalPassword').val();
        
        // 비밀번호 검증 AJAX 요청
        $.ajax({
            type: 'POST',
            url: '${pageContext.request.contextPath}/CustomerService/checkPassword',
            data: {
                inquiryID: targetUrl.split('/').pop(), // URL에서 inquiryID 추출
                password: password
            },
            success: function(response) {
                if (response.valid) {
                    window.location.href = targetUrl;
                } else {
                    alert('비밀번호가 틀렸습니다.');
                }
            },
            error: function(jqXHR, textStatus, errorThrown) {
                console.error('비밀번호 검증 중 오류 발생:', textStatus, errorThrown);
                alert('비밀번호 검증에 실패하였습니다.');
            }
        });
    });
});

function searchCheck() {
    var word = document.getElementById('word').value;
    if (word.trim() === '') {
        document.getElementById('word').disabled = true; // 검색어가 비어있으면 검색어 입력 필드를 비활성화
    }
    return true;
}
</script>

<%@ include file="../footer.jsp" %>
