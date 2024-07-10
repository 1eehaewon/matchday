<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>
<style>
.filter-buttons {
    margin-bottom: 15px;
}

.filter-buttons button {
    margin-right: 10px;
    padding: 5px 10px;
    font-size: 16px;
    cursor: pointer;
}
.filter-buttons button:hover {
    background-color: #f0f0f0;
}
</style>
<div class="container-fluid px-4">
    <h1 class="mt-4">쿠폰 목록 조회</h1>
    <ol class="breadcrumb mb-4">
    </ol>

    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i> 쿠폰 목록
        </div>
        <div class="card-body">
            <div class="filter-buttons">
                <button onclick="filterCoupons('all')">전체</button>
                <button onclick="filterCoupons('waiting')">대기</button>
                <button onclick="filterCoupons('active')">진행중</button>
                <button onclick="filterCoupons('expired')">종료</button>
            </div>
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
                        <tr class="coupon-row" data-startdate="${coupon.startdate}" data-enddate="${coupon.enddate}">
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
    function filterCoupons(status) {
        const rows = document.querySelectorAll('.coupon-row');
        const now = new Date();

        rows.forEach(row => {
            const startdate = new Date(row.getAttribute('data-startdate'));
            const enddate = new Date(row.getAttribute('data-enddate'));

            if (status == 'all') {
                row.style.display = '';
            } else if (status == 'waiting' && startdate > now) {
                row.style.display = '';
            } else if (status == 'active' && startdate <= now && enddate >= now) {
                row.style.display = '';
            } else if (status == 'expired' && enddate < now) {
                row.style.display = '';
            } else {
                row.style.display = 'none';
            }
        });
    }
	
    <c:if test="${not empty message}">
        alert('${message}');
    </c:if>
</script>
