<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>

<div class="container-fluid px-4">
    <h1 class="mt-4">쿠폰 생성</h1>
    <ol class="breadcrumb mb-4"></ol>
    <div class="card mb-4">
        <div class="card-header">
            <i class="fas fa-table me-1"></i> 쿠폰 생성 폼
        </div>
        <div class="card-body">
            <form action="${pageContext.request.contextPath}/admin/coupon/create" method="post">
                <div class="form-group">
                    <label for="coupontypeid">쿠폰 종류 ID</label>
                    <input type="text" class="form-control" id="coupontypeid" name="coupontypeid" required>
                </div>
                <div class="form-group">
                    <label for="couponname">쿠폰 이름</label>
                    <input type="text" class="form-control" id="couponname" name="couponname" required>
                </div>
                <div class="form-group">
                    <label for="discountrate">쿠폰 할인율</label>
                    <input type="number" class="form-control" id="discountrate" name="discountrate" required>
                </div>
                <div class="form-group">
                    <label for="issuecount">발행 개수</label>
                    <input type="number" class="form-control" id="issuecount" name="issuecount" required>
                </div>
                <div class="form-group">
                    <label for="startdate">사용 시작 일자</label>
                    <input type="date" class="form-control" id="startdate" name="startdate" required>
                </div>
                <div class="form-group">
                    <label for="enddate">사용 만료 일자</label>
                    <input type="date" class="form-control" id="enddate" name="enddate" required>
                </div>
                <div class="form-group">
                    <label for="applicableproduct">사용 가능 상품</label>
                    <input type="text" class="form-control" id="applicableproduct" name="applicableproduct" required>
                </div>
                <button type="submit" class="btn btn-primary">생성</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="adfooter.jsp"%>
