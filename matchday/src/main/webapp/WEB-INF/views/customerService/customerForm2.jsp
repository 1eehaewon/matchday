<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<!-- 추가된 코드 시작 -->
<c:if test="${not empty msg}">
  <div class="alert alert-info">
    ${msg}
  </div>
</c:if>
<!-- 추가된 코드 끝 -->
<style>
  .custom-card-header {
    background-color: #007bff;
    color: white;
    text-align: center;
  }
  .custom-form-label {
    font-weight: bold;
    color: black;
  }
  .custom-form-control {
    border-radius: 0.25rem;
  }
  .custom-button {
    border-radius: 0.25rem;
  }
  .main-container {
    margin-top: 5rem;
  }
  .shadow-card {
    box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
  }
</style>

<main class="main-container">
  <div class="container">
    <div class="row justify-content-center">
      <div class="col-lg-8">
        <div class="text-center mb-4">
          <a href="CustomerPage" class="btn btn-outline-primary btn-lg">문의목록</a>
        </div>
        <div class="card shadow-card border-0 rounded-lg">
          <div class="card-header custom-card-header">
            <h2 class="mb-0 fw-bold">1:1 문의</h2>
          </div>
          <div class="card-body p-5">
            <div class="mb-4">
              <label for="orderSelect" class="form-label custom-form-label">구매 내역</label>
              <select name="orderSelect" id="orderSelect" class="form-select custom-form-control">
                <option value="">구매 내역을 선택하세요</option>
                <optgroup label="축구 경기">
                  <c:forEach var="match" items="${matchList}">
                    <option value="match-${match.id}">${match.name} - ${match.date}</option>
                  </c:forEach>
                </optgroup>
                <optgroup label="구매 상품">
                  <c:forEach var="product" items="${productList}">
                    <option value="product-${product.id}">${product.name} - ${product.date}</option>
                  </c:forEach>
                </optgroup>
              </select>
            </div>
            <form name="customerForm" id="customerForm" method="post" action="insert" enctype="multipart/form-data">
              <div class="mb-4">
                <label for="UserID" class="form-label custom-form-label">회원 ID</label>
                <input type="text" name="UserID" id="UserID" value="${sessionScope.UserID}" readonly class="form-control custom-form-control">
              </div>
              <div class="mb-4">
                <label for="title" class="form-label custom-form-label">제목</label>
                <input type="text" name="title" id="title" maxlength="100" required class="form-control custom-form-control">
              </div>
              <div class="mb-4">
                <label for="summernote" class="form-label custom-form-label">내용</label>
                <div id="summernote" class="form-control custom-form-control" style="min-height: 200px;">내용을 입력하세요</div>
              </div>
              <div class="mb-4">
                <label for="Inqpasswd" class="form-label custom-form-label">비밀번호</label>
                <input type="password" name="Inqpasswd" id="Inqpasswd" maxlength="10" required class="form-control custom-form-control">
              </div>
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

<%@ include file="../footer.jsp" %>
