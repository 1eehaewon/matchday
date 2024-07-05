<!-- seatmap.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>좌석 배치도</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <style>
        body {
            background-color: #f8f9fa;
            margin: 0;
            padding: 0;
            overflow-y: scroll;
        }
        .container {
            background-color: #ffffff;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
            padding: 20px;
            min-height: 100vh;
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .header {
            text-align: center;
            margin-bottom: 20px;
        }
        .seat-map-container {
            display: flex;
            justify-content: space-between;
            width: 100%;
            max-width: 1200px;
            gap: 100px;
        }
        .seat-map {
            display: grid;
            grid-template-columns: repeat(20, 1fr);
            gap: 2px;
            width: 60%;
            position: relative;
        }
        .seat {
            width: 20px;
            height: 20px;
            background-color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 0.6rem;
            color: #ffffff;
            border-radius: 2px;
            cursor: pointer;
            transition: background-color 0.3s;
        }
        .seat:hover {
            background-color: #5a6268;
        }
        .seat.selected {
            background-color: #007bff;
            color: #ffffff;
        }
        .ground-direction {
            position: absolute;
            font-size: 1rem;
            font-weight: bold;
            color: #007bff;
        }
        .ground-direction.bottom {
            top: calc(100% + 20px);
            left: 50%;
            transform: translateX(-50%);
        }
        .ground-direction.top {
            bottom: calc(100% + 20px);
            left: 50%;
            transform: translateX(-50%);
        }
        .ground-direction.left {
            top: 50%;
            right: calc(100% + 20px);
            transform: translateY(-50%);
        }
        .ground-direction.right {
            top: 50%;
            left: calc(100% + 20px);
            transform: translateY(-50%);
        }
        .seat-info {
            width: 35%;
            text-align: left;
            padding: 20px;
            background-color: #f8f9fa;
            border-radius: 8px;
            box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
        }
        .seat-info h5 {
            font-weight: bold;
            margin-bottom: 10px;
        }
        .seat-info ul {
            list-style: none;
            padding-left: 0;
        }
        .seat-info li {
            padding: 5px 0;
            border-bottom: 1px solid #ddd;
        }
        .confirm-button {
            margin-top: 20px;
            display: flex;
            justify-content: center;
        }
        .progress-bar {
            display: flex; /* flex를 사용하여 가로로 나열 */
            justify-content: space-between;
            list-style-type: none;
            padding: 0;
            margin: 0 0 20px 0;
            width: 100%;
            background-color: #f8f9fa;
            border: 1px solid #ddd;
            border-radius: 5px;
            overflow: hidden;
        }
        .progress-bar li {
            flex: 1; /* 균등하게 나누기 */
            text-align: center;
            padding: 10px 0;
            color: #fff;
            background-color: #6c757d;
            transition: background-color 0.3s ease;
        }
        .progress-bar li.active {
            background-color: #d9534f;
        }
        .progress-bar li:not(:last-child) {
            border-right: 1px solid #fff;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- Progress Bar -->
        <ul class="progress-bar">
            <li class="active">가격/할인선택</li>
            <li>배송선택/주문자확인</li>
            <li>결제하기</li>
        </ul>

        <div class="header">
            <h2>${section} 구역 좌석 배치도</h2>
            <p>경기 정보: <strong>${match.hometeamid} vs ${match.awayteamid}</strong> @ ${match.stadiumid}</p>
            <p>경기일정: <fmt:formatDate value="${match.matchdate}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></p>
        </div>
        <br><br>
        <div class="seat-map-container">
            <div class="seat-map">
                <div class="ground-direction ${groundDirection}">⚽ 그라운드</div>
                <c:forEach var="row" items="${seats}" varStatus="rowStatus">
                    <c:forEach var="seat" items="${row}" varStatus="colStatus">
                        <div class="seat" data-seat="${seatNumbers[rowStatus.index][colStatus.index]}" data-section="${section}" 
                             data-price="${section == 'north' ? 17000 : section == 'south' ? 14000 : section == 'east' ? 15000 : 16000}">
                            <c:out value="${seatNumbers[rowStatus.index][colStatus.index]}" />
                        </div>
                    </c:forEach>
                </c:forEach>
            </div>
            <div class="seat-info">
                <h5>선택한 좌석 정보</h5>
                <ul id="selectedSeatsList"></ul>
            </div>
        </div>
        <div class="confirm-button">
            <button type="button" class="btn btn-primary btn-sm" id="confirmSeats">확인</button>
        </div>
    </div>
    <script>
        function updateSelectedSeats() {
            var selectedSeats = document.querySelectorAll('.seat.selected');
            var selectedSeatsList = document.getElementById('selectedSeatsList');
            selectedSeatsList.innerHTML = '';

            for (var i = 0; i < selectedSeats.length; i++) {
                var seat = selectedSeats[i];
                var section = seat.getAttribute('data-section');
                var seatNumber = seat.getAttribute('data-seat');
                var price = seat.getAttribute('data-price');
                var listItem = document.createElement('li');
                listItem.innerHTML = section.toUpperCase() + ' 구역 - ' + seatNumber + '번 좌석<br>금액: ' + price + '원';
                selectedSeatsList.appendChild(listItem);
            }
        }

        var seats = document.querySelectorAll('.seat');
        for (var i = 0; i < seats.length; i++) {
            seats[i].addEventListener('click', function() {
                this.classList.toggle('selected');
                updateSelectedSeats();
            });
        }

        document.getElementById('confirmSeats').addEventListener('click', function() {
            var selectedSeats = document.querySelectorAll('.seat.selected');
            var selectedSeatNumbers = [];

            for (var i = 0; i < selectedSeats.length; i++) {
                selectedSeatNumbers.push(selectedSeats[i].getAttribute('data-seat'));
            }

            if (selectedSeatNumbers.length > 0) {
                alert('선택된 좌석: ' + selectedSeatNumbers.join(', '));
            } else {
                alert('좌석을 선택하세요.');
            }
        });
    </script>
</body>
</html>


