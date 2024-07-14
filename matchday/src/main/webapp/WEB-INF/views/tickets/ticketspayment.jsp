<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>좌석 예매</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/jquery-3.7.1.min.js"></script>
    <script src="/js/seatSelection.js"></script>
    <style>
        body {
            font-family: 'Noto Sans KR', sans-serif;
            background-color: #f0f2f5;
            color: #333;
        }
        .container {
            margin-top: 50px;
        }
        .map-container {
            position: relative;
            max-width: 100%;
            border-radius: 10px;
            overflow: hidden;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
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
            border-radius: 5px;
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
        .section-link {
            display: block;
            padding: 10px;
            margin-bottom: 5px;
            border: 1px solid #dee2e6;
            border-radius: 5px;
            text-decoration: none;
            color: #333;
            transition: all 0.3s;
            text-align: center;
        }
        .section-link:hover {
            background-color: #e9ecef;
        }
        .section-link.active {
            background-color: #007bff;
            color: #fff;
        }
        .seat-map {
            display: grid;
            grid-template-columns: repeat(10, 1fr);
            gap: 10px;
            margin-top: 20px;
        }
        .seat {
            width: 40px;
            height: 40px;
            background-color: #6c757d;
            display: flex;
            align-items: center;
            justify-content: center;
            cursor: pointer;
            border-radius: 5px;
            transition: background-color 0.3s;
        }
        .seat.selected {
            background-color: #007bff;
            color: #fff;
        }
        .seat:hover {
            background-color: #5a6268;
        }
        .btn-primary {
            background-color: #007bff;
            border-color: #007bff;
            transition: background-color 0.3s, border-color 0.3s;
        }
        .btn-primary:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        .btn-primary:focus, .btn-primary.focus {
            box-shadow: 0 0 0 0.2rem rgba(0, 123, 255, 0.25);
        }
        .btn-primary:disabled {
            background-color: #007bff;
            border-color: #007bff;
        }
        .steps {
            text-align: center;
            margin-bottom: 20px;
        }
        .steps span {
            margin: 0 10px;
            font-size: 1.2rem;
        }
        .steps .active {
            color: red;
            font-weight: bold;
        }
    </style>
</head>
<body>
    <div class="steps">
        <span class="active">1. 구역선택</span> -> 
        <span>2. 좌석선택</span> -> 
        <span>3. 결제정보확인</span>
    </div>
    <input type="hidden" id="matchid" value="${match.matchid}"/>
    <input type="hidden" id="stadiumid" value="${match.stadiumid}"/>
    <div class="container">
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
            <div class="col-md-4 text-center">
                <h1><c:out value="${match.hometeamid}"/> <br> <small>vs</small> <br> <c:out value="${match.awayteamid}"/></h1>
                <p class="mb-4">경기일정: <fmt:formatDate value="${match.matchdate}" pattern="yyyy년 MM월 dd일 (E) HH:mm"/></p>
                <div class="list-group mb-3">
                    <a href="#" data-section="N" class="section-link">N 구역</a>
                    <a href="#" data-section="W" class="section-link">W 구역</a>
                    <a href="#" data-section="E" class="section-link">E 구역</a>
                    <a href="#" data-section="S" class="section-link">S 구역</a>
                </div>
                <button type="button" class="btn btn-primary btn-lg" id="selectSeats">좌석선택</button>
                <div class="seat-map mt-4"></div>
            </div>
        </div>
    </div>
    <script>
        $(document).ready(function() {
            let selectedSection = null;

            $('.section-link').click(function() {
                selectedSection = $(this).data('section');
                $('.section-link').removeClass('active');
                $(this).addClass('active');

                $('.north, .west, .east, .south').css('background-color', 'transparent');

                switch (selectedSection) {
                    case 'N':
                        $('.north').css('background-color', 'rgba(255, 0, 0, 0.5)');
                        break;
                    case 'W':
                        $('.west').css('background-color', 'rgba(0, 0, 255, 0.5)');
                        break;
                    case 'E':
                        $('.east').css('background-color', 'rgba(0, 128, 0, 0.5)');
                        break;
                    case 'S':
                        $('.south').css('background-color', 'rgba(255, 255, 0, 0.5)');
                        break;
                }
            });

            $('#selectSeats').click(function() {
                if (selectedSection) {
                    var matchId = $('#matchid').val();
                    var stadiumId = $('#stadiumid').val();
                    window.location.href = '/tickets/seatmap?matchid=' + matchId + '&section=' + selectedSection + '&stadiumid=' + stadiumId;
                } else {
                    alert('구역을 선택하세요.');
                }
            });
        });
    </script>
</body>
</html>
