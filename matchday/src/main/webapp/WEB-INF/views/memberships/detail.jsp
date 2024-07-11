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
</script>
<style>
    body {
        font-family: Arial, sans-serif;
        margin: 0; /* 여백을 없앰 */
    }
    .container {
        display: flex;
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
    /* 추가한 버튼 스타일 */
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
</style>
</head>
<body>
    <div class="container">
        <div class="membership-image">
            <img src="/storage/memberships/${membership.filename}" alt="멤버쉽 클럽 로고">
        </div>
        <div class="membership-info">
            <div class="membership-title">${membership.membershipname}</div>
            <dl class="info-list">
                <dt>기간</dt>
                <dd>${membership.startdate} ~ ${membership.enddate}</dd>
                
                <dt>이용연령</dt>
                <dd>전체관람가</dd>
                
                <dt>가격</dt>
                <dd><fmt:formatNumber value="${membership.price}" pattern="#,###"/> 원</dd>
            </dl>
           <button type="button" class="btn btn-primary" onclick="membership_update('${detail.membershipid}')">수정</button>
		  <button type="button" class="btn btn-danger" onclick="membership_delete_confirm('${membership.membershipid}')">삭제</button>
        </div>
    </div>
    
   <div class="col-10" style="margin-top: 250px; margin-left: 290px;">
    <h2 style="margin-bottom: 5px;">공지사항</h2>
</div>
      
</body>

<%@ include file="../footer.jsp" %>