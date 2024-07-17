<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<%@ include file="../header.jsp" %>
<script>
    function membership_update(membershipid) {
        location.href = "/memberships/update?membershipid=" + membershipid;
    }

    function membership_delete_confirm(membershipid) {
        if (confirm("해당 멤버쉽을 삭제합니다. 진행할까요?")) {
            location.href = "/memberships/delete?membershipid=" + membershipid;
        }
    }

    function openPaymentPopup(membershipID) {
        window.open('/membershipticket/payment?membershipID=' + membershipID, '결제 페이지', 'width=900,height=600,scrollbars=yes');
    }
</script>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0; /* 여백을 없앰 */
    }
    .container1 {
        display: flex;
        margin-left: 390px; /* 왼쪽에 마진 추가 */
        margin-top: 50px; /* 헤더와의 간격 추가 */
    }
    .membership-image {
        flex: 1;
        text-align: center;
    }
    .membership-image img {
        width: 80%;
        max-width: 300px;
    }
    .membership-info {
        flex: 2;
        padding-left: 20px;
    }
    .membership-title {
        font-size: 24px;
        font-weight: bold;
        margin-bottom: 10px;
    }
    .rating {
        font-size: 16px;
        color: #FFA500;
        margin-bottom: 20px;
    }
    .rating span {
        color: #000;
        font-weight: bold;
    }
    .info-list dt {
        font-weight: bold;
        margin-top: 10px;
    }
    .info-list dd {
        margin: 0;
        margin-left: 20px;
    }
    .price-info {
        font-weight: bold;
        color: #d9534f;
    }
    .benefits {
        color: #5bc0de;
        font-weight: bold;
        margin-top: 20px;
    }
    .benefits a {
        color: #5bc0de;
        text-decoration: none;
        display: block;
    }
    .footer {
        display: flex;
        align-items: center;
        margin-top: 20px;
    }
    .footer span {
        margin-left: 10px;
        font-size: 14px;
        color: #888;
    }
    .footer img {
        width: 20px;
        height: 20px;
        margin-right: 10px;
    }
    .btn {
        padding: 8px 16px;
        border-radius: 4px;
        cursor: pointer;
    }
    .btn.btn-primary {
        background-color: #007bff;
        color: #fff;
        border: none;
        margin-right: 10px;
    }
    .btn.btn-danger {
        background-color: #dc3545;
        color: #fff;
        border: none;
    }
    .notice-section {
        margin-top: 250px;
        margin-left: auto;
        margin-right: auto;
        text-align: center;
        max-width: 600px;
    }
    .notice-section h2 {
        margin-bottom: 20px;
        font-size: 42px;
        font-weight: bold;
    }
    .notice-section li {
        margin-bottom: 20px;
        font-size: 24px;
    }
    .notice-section img {
        margin-top: 20px;
        width: 100%;
        max-width: 600px;
    }
</style>
</head>
<body>
    <div class="container1" >
        <div class="membership-image">
            <img src="/storage/memberships/${memberships.filename}" alt="멤버쉽 클럽 로고">
        </div>
        <div class="membership-info">
            <div class="membership-title">${memberships.membershipname}</div>
            <dl class="info-list">
                <dt>기간</dt>
                <dd>${memberships.startdate} ~ ${memberships.enddate}</dd>
                
                <dt>이용연령</dt>
                <dd>전체관람가</dd>
                
                <dt>가격</dt>
                <dd><fmt:formatNumber value="${memberships.price}" pattern="#,###"/> 원</dd>
            </dl>
            <c:if test="${sessionScope.grade == 'M'}">
                <button type="button" class="btn btn-primary" onclick="membership_update('${memberships.membershipid}')">수정</button>
                <button type="button" class="btn btn-danger" onclick="membership_delete_confirm('${memberships.membershipid}')">삭제</button>
            </c:if>
            <button type="button" class="btn btn-info" onclick="openPaymentPopup('${memberships.membershipid}')">멤버쉽 가입하기</button>
        </div>
    </div>
    
    <div class="notice-section">
        <h2>공지사항🔊</h2>
        <li>아래의 이미지를 참고하시기 바랍니다.</li>
        <img src="/storage/images/Frame 2.png" alt="공지사항 이미지">
    </div>
      
</body>

<%@ include file="../footer.jsp" %>
