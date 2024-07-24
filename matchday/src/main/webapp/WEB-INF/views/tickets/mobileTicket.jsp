<%@ page language="java" contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>모바일 티켓</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .ticket-container {
            max-width: 400px;
            margin: 50px auto;
            padding: 20px;
            border: 1px solid #ccc;
            border-radius: 10px;
            text-align: center;
        }
        .ticket-header {
            font-size: 1.5em;
            margin-bottom: 20px;
        }
        .team-name {
            display: block;
        }
        .vs-text {
            display: block;
            margin: 10px 0;
        }
        .ticket-barcode img {
            width: 100%;
            height: auto;
        }
        .ticket-info {
            margin-top: 20px;
            text-align: left;
        }
        .ticket-info th, .ticket-info td {
            padding: 5px;
        }
    </style>
</head>
<body>
    <div class="ticket-container">
        <div class="ticket-header">
            <span class="team-name">${reservation.hometeam}</span>
            <span class="vs-text">vs</span>
            <span class="team-name">${reservation.awayteam}</span>
        </div>
        <div class="ticket-barcode">
            <img src="/tickets/generateQRCode?reservationid=${reservation.reservationid}" alt="QR Code">
        </div>
        <table class="ticket-info table">
            <tr>
                <th>예매자</th>
                <td>${reservation.userName}</td>
            </tr>
            <tr>
                <th>예매번호</th>
                <td>${reservation.reservationid}</td>
            </tr>
            <tr>
                <th>예매일</th>
                <td id="reservationDate">${reservation.reservationdate}</td>
            </tr>
            <tr>
                <th>관람일시</th>
                <td id="matchDate">${reservation.matchdate}</td>
            </tr>
            <tr>
                <th>장소</th>
                <td>${reservation.stadiumName}</td>
            </tr>
        </table>
    </div>

    <script>
        function formatDate(dateString) {
            const date = new Date(dateString);
            const options = {
                year: 'numeric', month: 'numeric', day: 'numeric',
                hour: 'numeric', minute: 'numeric',
                hour12: true
            };
            return new Intl.DateTimeFormat('ko-KR', options).format(date);
        }

        document.getElementById('reservationDate').textContent = formatDate('${reservation.reservationdate}');
        document.getElementById('matchDate').textContent = formatDate('${reservation.matchdate}');
    </script>
</body>
</html>
