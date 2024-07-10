<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<style>
    .mypage-container {
        display: flex;
        min-height: 100vh;
        background-color: #f8f9fa;
        padding: 30px 10px;
    }
    .mypage-sidebar {
        width: 200px; /* 사이드바 너비 */
        padding: 20px;
        background-color: #ffffff;
        border: 1px solid #ccc;
        border-radius: 10px;
        margin-right: 20px;
    }
    .mypage-form {
        flex: 1;
        padding: 30px;
        border: 1px solid #ccc;
        border-radius: 10px;
        background-color: #fff;
    }
    .mypage-title {
        text-align: center;
        margin-bottom: 20px;
        font-size: 24px;
        font-weight: bold;
        color: #333;
    }
    .tab-container {
        display: flex;
        justify-content: center;
        margin-bottom: 20px;
    }
    .tab {
        padding: 10px 20px;
        cursor: pointer;
        border: 1px solid #ccc;
        border-radius: 5px 5px 0 0;
        background-color: #f0f0f0;
        margin-right: 5px;
    }
    .tab.active {
        background-color: #fff;
        border-bottom: none;
    }
    .form-table {
        width: 100%;
    }
    .form-table th, .form-table td {
        padding: 8px;
        vertical-align: middle;
        border: 1px solid #ccc;
    }
    .form-table th {
        text-align: left;
        background-color: #f0f0f0;
    }
</style>
<div class="mypage-container">
    <div class="mypage-sidebar">
        <ul class="list-group">
            <li class="list-group-item"><a href="/member/mypage">회원 정보</a></li>
            <c:choose>
                <c:when test="${user.grade == 'M'}">
                    <li class="list-group-item"><a href="/member/mypage/point">포인트 관리</a></li>
                    <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰 관리</a></li>
                </c:when>
                <c:otherwise>
                    <li class="list-group-item"><a href="/member/mypage/point">포인트 내역</a></li>
                    <li class="list-group-item"><a href="/member/mypage/coupon">쿠폰함</a></li>
                </c:otherwise>
            </c:choose>
        </ul>
    </div>
    <div class="mypage-form">
        <h2 class="mypage-title">쿠폰함</h2>
        <!-- 탭 기능 구현 -->
        <div class="tab-container">
            <div id="tab-received" class="tab active" onclick="showTab('received')">보유 쿠폰</div>
            <div id="tab-available" class="tab" onclick="showTab('available')">쿠폰 받기</div>
        </div>
        <!-- 보유 쿠폰 탭 -->
        <div id="received" class="tab-content">
            <table class="form-table">
                <thead>
                    <tr>
                        <th>쿠폰번호</th>
                        <th>쿠폰명</th>
                        <th>사용여부</th>
                        <th>사용시작일자</th>
                        <th>사용만료일자</th>
                        <th>적용구분</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="coupon" items="${receivedCoupons}">
                        <tr>
                            <td>${coupon.couponid}</td>
                            <td>${coupon.couponname}</td>
                            <td>${coupon.usage}</td>
                            <td>${coupon.startdate}</td>
                            <td>${coupon.enddate}</td>
                            <td>${coupon.applicableproduct}</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
        <!-- 쿠폰 받기 탭 -->
        <div id="available" class="tab-content" style="display:none;">
            <table class="form-table">
                <thead>
                    <tr>
                        <th>쿠폰번호</th>
                        <th>쿠폰명</th>
                        <th>사용시작일자</th>
                        <th>사용만료일자</th>
                        <th>적용구분</th>
                        <th>다운로드</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="coupon" items="${availableCoupons}">
                        <tr>
                            <td>${coupon.coupontypeid}</td>
                            <td>${coupon.couponname}</td>
                            <td>${coupon.startdate}</td>
                            <td>${coupon.enddate}</td>
                            <td>${coupon.applicableproduct}</td>
                            <td><button onclick="downloadCoupon('${coupon.coupontypeid}')">다운로드</button></td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>
</div>
<%@ include file="../footer.jsp" %>
<script>
    // 탭 전환 함수
    function showTab(tabName) {
        document.getElementById('received').style.display = tabName === 'received' ? 'block' : 'none';
        document.getElementById('available').style.display = tabName === 'available' ? 'block' : 'none';
        document.getElementById('tab-received').classList.toggle('active', tabName === 'received');
        document.getElementById('tab-available').classList.toggle('active', tabName === 'available');
    }

    // 쿠폰 다운로드 함수
    function downloadCoupon(couponid) {
        fetch('/member/mypage/coupon/download', {
            method: 'POST',
            headers: {
                'Content-Type': 'application/json'
            },
            body: JSON.stringify({ action: 'download', couponid: couponid })
        })
        .then(response => response.json())
        .then(data => {
            alert(data.message);
            if (data.success) {
                location.reload();
            }
        })
        .catch(error => {
            console.error('Error:', error);
            alert('다운로드 중 오류가 발생했습니다.');
        });
    }
</script>
