<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>

<style>
.activity-container {
	padding: 20px;
}

.activity-section {
	margin-bottom: 20px;
}

.activity-title {
	font-size: 18px;
	font-weight: bold;
	margin-bottom: 10px;
}

.activity-details {
	list-style-type: none;
	padding: 0;
}

.activity-details li {
	margin-bottom: 5px;
}
</style>

<div class="activity-container">
	<div class="activity-section">
		<div class="activity-title">로그인 정보</div>
		<ul class="activity-details">
			<li>로그인 횟수: ${userActivity.loginCount}</li>
			<li>최근 로그인 날짜: ${userActivity.lastLoginDate}</li>
			<li>최근 로그인 IP: ${userActivity.lastLoginIp}</li>
		</ul>
	</div>

	<div class="activity-section">
		<div class="activity-title">활동 정보</div>
		<ul class="activity-details">
			<li>리뷰 작성 개수: ${userActivity.reviewCount}</li>
			<li>문의 작성 개수: ${userActivity.inquiryCount}</li>
		</ul>
	</div>

	<div class="card mb-4">
		<div class="card-header">
			<i class="fas fa-table me-1"></i> 구매정보
		</div>
		<div class="card-body">
			<ul class="activity-details">
				<li>누적 구매 금액: ${userActivity.totalSpent} 원</li>
				<table id="datatablesSimple">
					<thead>
						<tr>
							<th>유형</th>
							<th>품목</th>
							<th>금액</th>
							<th>날짜</th>
							<th>추가 정보</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="purchase" items="${userActivity.purchaseHistory}">
							<tr>
								<td>${purchase.type}</td>
								<td>${purchase.itemName}</td>
								<td>${purchase.amount}원</td>
								<td>${purchase.date}</td>
								<td><c:choose>
										<c:when test="${purchase.type == 'order'}">
                                        물건 수: ${purchase.quantity}
                                    </c:when>
										<c:when test="${purchase.type == 'ticket'}">
                                        티켓 수: ${purchase.quantity}
                                    </c:when>
										<c:otherwise>
                                        -
                                    </c:otherwise>
									</c:choose></td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</ul>
		</div>
	</div>

	<div class="card mb-4">
		<div class="card-header">
			<i class="fas fa-table me-1"></i>포인트정보
		</div>
		<div class="card-body">
			<ul class="activity-details">
				<li>보유 포인트: ${userActivity.totalpoints} 점</li>
				<table id="pointTable" class="table table-bordered table-hover" style="width:100%">
					<thead>
						<tr>
							<th>적립일</th>
							<th>유형</th>
							<th>포인트</th>
							<th>출처</th>
						</tr>
					</thead>
					<tbody>
						<c:forEach var="history" items="${userActivity.pointHistory}">
							<tr>
								<td>${history.pointcreationdate}</td>
								<td>${history.pointtype}</td>
								<td>${history.pointamount}</td>
								<td>${history.pointsource}</td>
							</tr>
						</c:forEach>
					</tbody>
				</table>
			</ul>
		</div>
	</div>
</div>

<%@ include file="adfooter.jsp"%>
