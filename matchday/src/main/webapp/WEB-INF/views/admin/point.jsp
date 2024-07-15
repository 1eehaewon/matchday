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
	box-shadow: 0px 8px 16px 0px rgba(0, 0, 0, 0.2);
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
<script>
	function toggleInputFields() { //적립금 / 적립비율 선택
		var mode = document
				.querySelector('input[name="accumulationMode"]:checked').value;
		if (mode === 'points') {
			document.getElementById('pointsField').style.display = 'block';
			document.getElementById('rateField').style.display = 'none';
		} else {
			document.getElementById('pointsField').style.display = 'none';
			document.getElementById('rateField').style.display = 'block';
		}
	}
	<c:if test="${not empty message}">
	alert('${message}');
	</c:if>
</script>
<div class="container-fluid px-4">
	<h1>포인트 설정</h1>

	<!-- 포인트 유형 목록 및 추가 폼 -->
	<ol class="breadcrumb mb-4"></ol>

	<div class="card mb-4">
		<div class="card-header">
			<i class="fas fa-table me-1"></i> 포인트 유형 목록
		</div>
		<div class="card-body">
			<table id="datatablesSimple">
				<thead>
					<tr>
						<th>포인트 유형</th>
						<th>적립 비율</th>
						<th>적립 포인트</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="point" items="${points}">
						<tr>
							<td>${point.pointcategoryname}</td>
							<td>${point.rate}</td>
							<td>
								<div
									style="display: flex; justify-content: space-between; align-items: center;">
									<span>${point.accumulatedpoints}</span>
									<div class="dropdown">
										<button class="dropbtn"
											id="dropdownMenuButton${point.pointcategoryid}">···</button>
										<div class="dropdown-content"
											aria-labelledby="dropdownMenuButton${point.pointcategoryid}">
											<a href="/admin/deletePoint?id=${point.pointcategoryid}">삭제</a>
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
	<!-- 새로운 포인트 유형 추가 폼 -->
	<h2>포인트 유형 추가</h2>
	<form action="/admin/point/add" method="post">
		<div class="form-group">
			<label for="pointcategoryname">포인트 유형</label> <input type="text"
				class="form-control" id="pointcategoryname" name="pointcategoryname"
				required>
		</div>
		<div class="form-group">
			<label>적립 방식</label>
			<div>
				<label> <input type="radio" name="accumulationMode"
					value="points" checked onclick="toggleInputFields()"> 적립
					포인트
				</label> <label> <input type="radio" name="accumulationMode"
					value="rate" onclick="toggleInputFields()"> 결제금액 비율
				</label>
			</div>
		</div>
		<div class="form-group" id="pointsField">
			<label for="accumulatedpoints">적립 포인트</label> <input type="number"
				class="form-control" id="accumulatedpoints" name="accumulatedpoints">
		</div>
		<div class="form-group" id="rateField" style="display: none;">
			<label for="rate">적립 비율 (%)</label> <input type="number" step="0.01"
				class="form-control" id="rate" name="rate">
		</div>
		<button type="submit" class="btn btn-success">추가</button>
	</form>
</div>

<%@ include file="adfooter.jsp"%>