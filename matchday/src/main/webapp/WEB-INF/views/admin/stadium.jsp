<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="adheader.jsp"%>

<!-- 본문시작 -->
<div class="container">
    <h2>경기장 등록</h2>
    <form action="/admin/stadium/register" method="post" enctype="multipart/form-data">
        <div class="form-group">
            <label for="stadiumName">경기장 이름:</label>
            <input type="text" class="form-control" id="stadiumName" name="stadiumName" required>
        </div>
        <div class="form-group">
            <label for="location">위치:</label>
            <input type="text" class="form-control" id="location" name="location" required>
        </div>
        <div class="form-group">
            <label for="capacity">수용 인원:</label>
            <input type="number" class="form-control" id="capacity" name="capacity" required>
        </div>
        <div class="form-group">
            <label for="usageStatus">사용 상태:</label>
            <select class="form-control" id="usageStatus" name="usageStatus" required>
                <option value="Y">사용</option>
                <option value="N">미사용</option>
            </select>
        </div>
        <div class="form-group">
            <label for="parkingSpaces">주차 공간:</label>
            <input type="number" class="form-control" id="parkingSpaces" name="parkingSpaces" required>
        </div>
        <div class="form-group">
            <label for="stadiumImage">경기장 이미지:</label>
            <input type="file" class="form-control" id="stadiumImage" name="stadiumImageFile">
        </div>
        <div class="form-group">
            <label for="contactNumber">연락처:</label>
            <input type="text" class="form-control" id="contactNumber" name="contactNumber" required>
        </div>
        <button type="submit" class="btn btn-primary">등록</button>
    </form>

    <h2>등록된 경기장</h2>
    <table class="table">
        <thead>
            <tr>
                <th>경기장 ID</th>
                <th>경기장 이름</th>
                <th>위치</th>
                <th>수용 인원</th>
                <th>사용 상태</th>
                <th>주차 공간</th>
                <th>연락처</th>
            </tr>
        </thead>
        <tbody>
            <c:forEach var="stadium" items="${stadiumList}">
                <tr>
                    <td>${stadium.stadiumId}</td>
                    <td>${stadium.stadiumName}</td>
                    <td>${stadium.location}</td>
                    <td>${stadium.capacity}</td>
                    <td>${stadium.usageStatus}</td>
                    <td>${stadium.parkingSpaces}</td>
                    <td>${stadium.contactNumber}</td>
                </tr>
            </c:forEach>
        </tbody>
    </table>
</div>
<!-- 본문 끝 -->

<%@ include file="adfooter.jsp"%>
