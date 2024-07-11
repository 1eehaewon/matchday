<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>
<style>
/* 스타일링을 위한 CSS */
.dropdown {
    position: relative;
    display: inline-block;
}

.dropdown-content {
    display: none;
    position: absolute;
    right: 0;
    background-color: #f9f9f9;
    min-width: 160px;
    box-shadow: 0px 8px 16px 0px rgba(0,0,0,0.2);
    z-index: 1;
}

.dropdown-content a {
    color: black;
    padding: 12px 16px;
    text-decoration: none;
    display: block;
}

.dropdown-content a:hover {
    background-color: #f1f1f1;
}

.dropdown:hover .dropdown-content {
    display: block;
}

.dropdown:hover .dropbtn {
    background-color: #3e8e41;
}

.dropbtn {
    background-color: transparent;
    border: 1px solid #ccc;
    cursor: pointer;
    font-size: 16px;
    padding: 5px 10px;
    margin-left: auto;
    display: flex;
    align-items: center;
    justify-content: center;
}

.dropbtn:focus {
    outline: none;
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
                        <tr class="coupon-row"> 
                            <td>${coupon.coupontypeid}</td>
                            <td>${coupon.couponname}</td>
                            <td>${coupon.discountrate}</td>
                            <td>${coupon.issuecount}</td>
                            <td>${coupon.startdate}</td>
                            <td>${coupon.enddate}</td>
                            <td>
                                <div style="display: flex; justify-content: space-between; align-items: center;">
                                    <span>${coupon.applicableproduct}</span>
                                    <div class="dropdown">
                                        <button class="dropbtn" id="dropdownMenuButton${coupon.coupontypeid}">···</button>
                                        <div class="dropdown-content" aria-labelledby="dropdownMenuButton${coupon.coupontypeid}">
                                            <a href="/admin/editCoupon?id=${coupon.coupontypeid}">수정</a>
                                            <a href="/admin/deleteCoupon?id=${coupon.coupontypeid}">삭제</a>
                                        </div>
                                    </div>
                                </div>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="adfooter.jsp"%>

<c:if test="${not empty message}">
    alert('${message}');
</c:if>
