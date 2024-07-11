<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>

<script>
// alert 창 띄우기
<c:if test="${not empty message}">
    alert('${message}');
</c:if>
</script>

<div class="container-fluid px-4">
    <h1 class="mt-4">쿠폰 수정</h1>
    <ol class="breadcrumb mb-4"></ol>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i> 쿠폰 수정 폼
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/editCoupon" method="post">
                <input type="hidden" name="coupontypeid" value="${coupon.coupontypeid}">
                
                <div class="form-group">
                    <label for="couponname">쿠폰 이름</label>
                    <input type="text" class="form-control" id="couponname" name="couponname" value="${coupon.couponname}" required>
                </div>
                
                <div class="form-group">
                    <label for="discountrate">쿠폰 할인율</label>
                    <input type="number" class="form-control" id="discountrate" name="discountrate" value="${coupon.discountrate}" required>
                </div>
                
                <div class="form-group">
                    <label for="issuecount">발행 개수</label>
                    <input type="number" class="form-control" id="issuecount" name="issuecount" value="${coupon.issuecount}" required>
                </div>
                
                <div class="form-group">
                    <label for="startdate">사용 시작 일자</label>
                    <input type="date" class="form-control" id="startdate" name="startdate" value="${coupon.startdate}" required>
                </div>
                
                <div class="form-group">
                    <label for="enddate">사용 만료 일자</label>
                    <input type="date" class="form-control" id="enddate" name="enddate" value="${coupon.enddate}" required>
                </div>
                
                <div class="form-group">
                    <label for="applicableproduct">사용 가능 상품</label>
                    <select class="form-control" id="applicableproduct" name="applicableproduct" required>
                        <option value="">선택하세요</option>
                        <option value="Goods" ${coupon.applicableproduct == 'Goods' ? 'selected' : ''}>Goods</option>
                        <option value="Ticket" ${coupon.applicableproduct == 'Ticket' ? 'selected' : ''}>Ticket</option>
                    </select>
                </div>

                <button type="submit" class="btn btn-primary">수정</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="adfooter.jsp"%>
