<%-- JSP 페이지 설정 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%-- 헤더 파일 포함 --%>
<%@ include file="../header.jsp" %>

<%-- CSS 스타일 정의 --%>
<style>
    /* 커스텀 카드 헤더 스타일 */
    .custom-card-header {
        background-color: #007bff;
        color: white;
        text-align: center;
    }
    /* 커스텀 폼 라벨 스타일 */
    .custom-form-label {
        font-weight: bold;
        color: black;
    }
    /* 커스텀 폼 컨트롤 스타일 */
    .custom-form-control {
        border-radius: 0.25rem;
    }
    /* 커스텀 버튼 스타일 */
    .custom-button {
        border-radius: 0.25rem;
    }
    /* 메인 컨테이너 스타일 */
    .main-container {
        margin-top: 5rem;
    }
    /* 그림자 효과가 있는 카드 스타일 */
    .shadow-card {
        box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
    }
</style>

<%-- JavaScript 코드 위치 (현재 비어 있음) --%>
<script>

</script>

<%-- 메인 컨텐츠 시작 --%>
<main class="main-container">
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <%-- 문의목록 버튼 --%>
                <div class="text-center mb-4">
                    <a href="CustomerPage" class="btn btn-outline-primary btn-lg">문의목록</a>
                </div>
                <%-- 1:1 문의 카드 --%>
                <div class="card shadow-card border-0 rounded-lg">
                    <%-- 카드 헤더 --%>
                    <div class="card-header custom-card-header">
                        <h2 class="mb-0 fw-bold">1:1 문의</h2>
                    </div>
                    <%-- 카드 바디 --%>
                    <div class="card-body p-5">
                        <%-- 구매 내역 선택 --%>
                        <div class="mb-4">
                            <label for="orderSelect" class="form-label custom-form-label">구매 내역</label>
                            <select name="orderSelect" id="orderSelect" class="form-select custom-form-control" >
                                <option value="">구매 내역을 선택하세요</option>
                                <%-- 축구 경기 목록 --%>
                                <optgroup label="축구 경기">
                                    <c:forEach var="match" items="${matchList}">
                                        <option value="match-${match.id}">${match.name} - ${match.date}</option>
                                    </c:forEach>
                                </optgroup>
                                <%-- 구매 상품 목록 --%>
                                <optgroup label="구매 상품">
                                    <c:forEach var="product" items="${productList}">
                                        <option value="product-${product.id}">${product.name} - ${product.date}</option>
                                    </c:forEach>
                                </optgroup>
                            </select>
                        </div>
                        <%-- 문의 폼 시작 --%>
                        <form name="customerForm" id="customerForm" method="post" action="insert" enctype="multipart/form-data">
                            <%-- 참조 ID 입력 필드 --%>
                            <div class="mb-4">
                                <label for="referenceID" class="form-label custom-form-label">주문 / 예매번호</label>
                                <input type="text" name="referenceID" id="referenceID" value="${referenceID}" readonly class="form-control custom-form-control">
                            </div>
                            <%-- 카테고리 선택 추가 --%>
						    <div class="mb-4">
						        <label for="category" class="form-label custom-form-label">문의 카테고리</label>
						        <select name="category" id="category" class="form-select custom-form-control" required>
						            <option value="">카테고리를 선택하세요</option>
						            <option value="goods">상품문의</option> <!--  -->
						            <option value="match">경기문의</option>
						            <option value="delivery">배송문의</option>
						            <option value="patment">주문/결제</option>
						        </select>
						    </div>
                            <%-- 회원 ID 입력 필드 --%>
                            <div class="mb-4">
                                <label for="userID" class="form-label custom-form-label">회원 ID</label>
                                <input type="text" name="userID" id="userID" value="${sessionScope.userID}" readonly class="form-control custom-form-control">
                            </div>
                            <%-- 제목 입력 필드 --%>
                            <div class="mb-4">
                                <label for="title" class="form-label custom-form-label">제목</label>
                                <input type="text" name="title" id="title" maxlength="100" required class="form-control custom-form-control">
                            </div>
                            <%-- 내용 입력 필드 --%>
                            <div class="mb-4">
                                <label for="content" class="form-label custom-form-label">내용</label>
                                <textarea name="content" id="content" class="form-control custom-form-control" required></textarea>
                            </div>
                            <%-- 비밀번호 입력 필드 --%>
                            <div class="mb-4">
                                <label for="inqpasswd" class="form-label custom-form-label">비밀번호</label>
                                <input type="password" name="inqpasswd" id="inqpasswd" maxlength="10" required class="form-control custom-form-control">
                            </div>
                            <%-- 제출 및 취소 버튼 --%>
                            <div class="d-flex justify-content-end mt-5">
                                <button type="submit" class="btn btn-primary btn-lg custom-button me-2">제출하기</button>
                                <a href="CustomerPage" class="btn btn-outline-primary btn-lg custom-button">취소</a>
                            </div>
                        </form>
                    </div>
                </div>
            </div>
        </div>
    </div>
</main>

<script>
$(document).ready(function() {
    $("#orderSelect").change(function() {
        var selectedValue = $(this).val();
        $("#referenceID").val(selectedValue);
    });
});
</script>

<%-- 푸터 파일 포함 --%>
<%@ include file="../footer.jsp" %>