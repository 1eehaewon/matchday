<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>
<div class="container-fluid px-4">
    <h1 class="mt-4">쿠폰 목록 조회</h1>
    <ol class="breadcrumb mb-4">
    </ol>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i> 쿠폰 목록
        </div>
        <div class="card-body">
            <table id="datatablesSimple">
                <thead>
                    <tr>
                        <th>쿠폰 종류 ID</th>
                        <th>쿠폰 이름</th>
                        <th>할인율</th>
                        <th>발행 개수</th>
                        <th>사용 시작 일자</th>
                        <th>사용 만료 일자</th>
                        <th>사용 가능 상품</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="coupon" items="${coupons}">
                        <tr>
                            <td>${coupon.coupontypeid}</td>
                            <td>${coupon.couponname}</td>
                            <td>${coupon.discountrate}</td>
                            <td>${coupon.issuecount}</td>
                            <td>${coupon.startdate}</td>
                            <td>${coupon.enddate}</td>
                            <td>${coupon.applicableproduct}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="adfooter.jsp"%>
<script>
    <c:if test="${not empty message}">
        alert('${message}');
    </c:if>
</script>