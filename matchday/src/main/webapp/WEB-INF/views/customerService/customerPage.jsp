<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div>
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

    <!-- 상단 메뉴 바 -->
    <div class="d-flex justify-content-center mb-4">
        <ul class="nav nav-tabs" id="categoryTabs">
            <li class="nav-item">
                <a class="nav-link ${category == 'all' ? 'active' : ''}" href="?category=all&page=1" data-category="all">전체</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '상품문의' ? 'active' : ''}" href="?category=상품문의&page=1" data-category="상품문의">상품문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '경기문의' ? 'active' : ''}" href="?category=경기문의&page=1" data-category="경기문의">경기문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '배송문의' ? 'active' : ''}" href="?category=배송문의&page=1" data-category="배송문의">배송문의</a>
            </li>
            <li class="nav-item">
                <a class="nav-link ${category == '주문/결제' ? 'active' : ''}" href="?category=주문/결제&page=1" data-category="주문/결제">주문/결제</a>
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
                    <c:if test="${inquiry.boardType != 'FAQ'}">
                        <tr data-category="${inquiry.boardType}">
                            <td class="text-center">${inquiry.inquiryID}</td>
                            <td class="text-center">
                                <c:choose>
                                    <c:when test="${inquiry.boardType == '상품문의'}">상품문의</c:when>
                                    <c:when test="${inquiry.boardType == '경기문의'}">경기문의</c:when>
                                    <c:when test="${inquiry.boardType == '배송문의'}">배송문의</c:when>
                                    <c:when test="${inquiry.boardType == '주문/결제'}">주문/결제</c:when>
                                    <c:otherwise>알 수 없음</c:otherwise>
                                </c:choose>
                            </td>
                            <td class="text-center">
                                <a href="#" data-href="customerDetail/${inquiry.inquiryID}" data-bs-toggle="modal" data-bs-target="#passwordModal">
                                    ${inquiry.title}
                                </a>
                            </td>
                            <td class="text-center">${inquiry.userID}</td>
                            <td class="text-center">${inquiry.formattedCreatedDate}</td>
                            <td class="text-center">${inquiry.isReplyHandled}</td>
                        </tr>
                    </c:if>
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
    <form class="row g-3 justify-content-center mb-4" action="customerPage" method="get" onsubmit="return searchCheck()">
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
            <!-- 글쓰기 버튼, 클릭 시 customerForm.jsp로 이동 -->
            <button type="button" class="btn btn-primary" onclick="location.href='customerForm'">글쓰기</button>
        </div>
    </form>
    <!-- 검색폼 끝 -->
</div>
</div>

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
//DOMContentLoaded 이벤트가 발생하면 이 함수가 실행됩니다.
//즉, HTML 문서가 완전히 로드되고 파싱되었을 때 실행됩니다.
document.addEventListener('DOMContentLoaded', function() {
 // categoryTabs 요소를 선택합니다. 이는 카테고리 탭을 포함한 HTML 요소입니다.
 const categoryTabs = document.getElementById('categoryTabs');
 
 // inquiryTableBody 요소를 선택합니다. 이는 문의 테이블의 본문을 포함한 HTML 요소입니다.
 const inquiryTableBody = document.getElementById('inquiryTableBody');
 
 // targetUrl 변수는 비밀번호 모달에서 사용자가 클릭한 URL을 저장합니다.
 let targetUrl = '';

 // categoryTabs의 각 탭에 클릭 이벤트를 추가합니다.
 categoryTabs.addEventListener('click', function(e) {
     // 클릭된 요소가 <a> 태그인 경우
     if (e.target.tagName === 'A') {
         e.preventDefault(); // 기본 동작(페이지 이동)을 막습니다.
         
         // 클릭된 탭의 data-category 속성 값을 가져옵니다.
         const category = e.target.getAttribute('data-category');

         // 모든 탭에서 active 클래스를 제거합니다.
         categoryTabs.querySelectorAll('a').forEach(a => a.classList.remove('active'));
         
         // 클릭된 탭에 active 클래스를 추가합니다.
         e.target.classList.add('active');

         // URLSearchParams 객체를 사용하여 현재 URL의 쿼리 매개변수를 설정합니다.
         const urlParams = new URLSearchParams(window.location.search);
         urlParams.set('category', category); // 선택된 카테고리를 설정합니다.
         urlParams.set('page', 1); // 페이지 번호를 1로 설정합니다.
         
         // 변경된 쿼리 매개변수를 사용하여 페이지를 다시 로드합니다.
         window.location.search = urlParams.toString();
     }
 });

 // 페이지 위치 저장 및 복원 기능을 구현합니다.
 // 이전에 저장된 scrollPos가 있으면 해당 위치로 스크롤합니다.
 if (sessionStorage.scrollPos) {
     window.scrollTo(0, sessionStorage.scrollPos);
 }
 
 // 페이지가 언로드(새로고침 또는 닫기)되기 전에 현재 스크롤 위치를 저장합니다.
 window.addEventListener('beforeunload', function() {
     sessionStorage.scrollPos = window.scrollY;
 });

 // 비밀번호 모달 관련 기능을 구현합니다.
 // 모달이 표시될 때 실행되는 이벤트 핸들러입니다.
 $('#passwordModal').on('show.bs.modal', function(event) {
     // 클릭된 버튼 요소를 가져옵니다.
     const button = $(event.relatedTarget);
     
     // 클릭된 버튼의 data-href 속성 값을 targetUrl에 저장합니다.
     targetUrl = button.data('href');
 });

 // 비밀번호 모달의 폼이 제출될 때 실행되는 이벤트 핸들러입니다.
 $('#passwordForm').on('submit', function(event) {
     event.preventDefault(); // 폼의 기본 제출 동작을 막습니다.
     
     // 사용자가 입력한 비밀번호를 가져옵니다.
     const password = $('#modalPassword').val();
     
     // 비밀번호 검증을 위한 AJAX 요청을 보냅니다.
     $.ajax({
         type: 'POST', // HTTP 메서드는 POST입니다.
         url: '${pageContext.request.contextPath}/customerService/checkPassword', // 비밀번호 검증 요청을 보낼 URL입니다.
         data: {
             // URL에서 inquiryID를 추출하여 데이터로 보냅니다.
             inquiryID: targetUrl.split('/').pop(),
             password: password // 입력한 비밀번호를 보냅니다.
         },
         success: function(response) {
             // 응답이 성공적이고 valid 속성이 true인 경우
             if (response.valid) {
                 // targetUrl로 페이지를 이동합니다.
                 window.location.href = targetUrl;
             } else {
                 // 비밀번호가 틀린 경우 경고 메시지를 표시합니다.
                 alert('비밀번호가 틀렸습니다.');
             }
         },
         error: function(jqXHR, textStatus, errorThrown) {
             // AJAX 요청 중 오류가 발생한 경우 콘솔에 오류를 출력하고 경고 메시지를 표시합니다.
             console.error('비밀번호 검증 중 오류 발생:', textStatus, errorThrown);
             alert('비밀번호 검증에 실패하였습니다.');
         }
     });
 });
});

//검색어가 비어있는 경우 검색어 입력 필드를 비활성화하는 함수입니다.
function searchCheck() {
 var word = document.getElementById('word').value; // 검색어 입력 필드의 값을 가져옵니다.
 if (word.trim() === '') { // 검색어가 비어있는지 확인합니다.
     document.getElementById('word').disabled = true; // 검색어 입력 필드를 비활성화합니다.
 }
 return true; // 폼 제출을 계속 진행합니다.
}

</script>

<%@ include file="../footer.jsp" %>
