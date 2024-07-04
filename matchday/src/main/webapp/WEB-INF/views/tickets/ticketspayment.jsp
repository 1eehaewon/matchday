<!-- ticketspayment.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>좌석 예매</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/jquery-3.7.1.min.js"></script>
    <style>
        body {
            font-family: Arial, sans-serif;
        }
        .map-container {
            position: relative;
            width: 100%;
            max-width: 600px;
            height: auto;
        }
        .map {
            width: 100%;
            height: auto;
        }
        .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
        }
        .north, .west, .east, .south {
            position: absolute;
            background-color: transparent;
            transition: background-color 0.3s;
        }
        .north {
            top: 10%;
            left: 20%;
            width: 60%;
            height: 15%;
        }
        .west {
            top: 25%;
            left: 10%;
            width: 15%;
            height: 50%;
        }
        .east {
            top: 25%;
            right: 10%;
            width: 15%;
            height: 50%;
        }
        .south {
            bottom: 10%;
            left: 20%;
            width: 60%;
            height: 15%;
        }
        .list-group-item.active, .section-link.active {
            background-color: #d3d3d3 !important;
            border-color: #d3d3d3 !important;
        }
        .section-link {
            display: block;
            padding: 10px;
            margin-bottom: 5px;
            border: 1px solid #ccc;
            border-radius: 5px;
            text-decoration: none;
            color: black;
            cursor: pointer;
        }
    </style>
</head>
<body>
    <div class="container mt-4">
        <div class="row">
            <div class="col-md-8">
                <div class="map-container">
                    <img src="../storage/tickets/stadium.png" alt="좌석 예매 화면" class="map">
                    <div class="overlay">
                        <div class="north"></div>
                        <div class="west"></div>
                        <div class="east"></div>
                        <div class="south"></div>
                    </div>
                </div>
            </div>
            <div class="col-md-4">
                <h1><c:out value="${match.hometeamid}"/> vs <c:out value="${match.awayteamid}"/> (7.8)</h1>
                <p>경기일정: <fmt:formatDate value="${match.matchdate}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></p>
                <div class="list-group mb-3">
                    <a href="#" data-section="north" class="section-link">N 구역</a>
                    <a href="#" data-section="west" class="section-link">W 구역</a>
                    <a href="#" data-section="east" class="section-link">E 구역</a>
                    <a href="#" data-section="south" class="section-link">S 구역</a>
                </div>
                <div class="d-grid gap-2">
                    <button type="button" class="btn btn-secondary" id="autoAssign">자동배정</button>
                    <button type="button" class="btn btn-primary" id="selectSeats">좌석선택</button>
                </div>
            </div>
        </div>
    </div>
    <script src="/js/seatSelection.js"></script>
</body>
</html>
