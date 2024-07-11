<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>좌석 선택</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        .seat {
            width: 25px;
            height: 25px;
            background-color: #cccccc;
            cursor: pointer;
            border: 1px solid #888;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 10px;
            transition: background-color 0.3s ease;
        }
        .seat:hover {
            background-color: #6c757d;
        }
        .selected {
            background-color: #007bff;
            color: white;
        }
        .seat-info {
            margin-top: 20px;
        }
        #seat-map-container {
            position: relative;
            display: flex;
            align-items: center;
            justify-content: center;
            flex-direction: column;
        }
        #seat-map {
            display: grid;
            grid-template-columns: repeat(20, 25px);
            gap: 2px;
            position: relative;
            margin: 20px 0;
        }
        .ground {
            background-color: #008000;
            color: white;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 14px;
            flex-shrink: 0;
        }
        .ground.north, .ground.south {
            width: calc(20 * 25px + 19 * 2px);
            height: 20px;
        }
        .ground.east, .ground.west {
            width: 20px;
            height: calc(20 * 25px + 19 * 2px);
            writing-mode: vertical-rl;
            text-align: center;
            transform: rotate(180deg);
        }
        .spacing {
            margin: 10px;
        }
        .choice {
            border: 1px solid black;
            padding: 10px;
            height: 300px;
            overflow-y: auto;
            background-color: #f8f9fa;
        }
        .choice-header {
            display: flex;
            justify-content: space-between;
            align-items: center;
        }
        .choice-table {
            width: 100%;
            border-collapse: collapse;
        }
        .choice-table th, .choice-table td {
            border: 1px solid black;
            padding: 5px;
            text-align: left;
        }
        .choice-table th {
            background-color: #f2f2f2;
        }
        #total-price {
            margin-top: 20px;
            font-size: 18px;
            font-weight: bold;
        }
        .btn-group {
            display: flex;
            justify-content: space-between;
            margin-top: 10px;
        }
        .btn-group .btn {
            flex: 1;
            margin: 0 5px;
        }
    </style> <!-- CSS 스타일 끝 -->
</head>
<body>
    <div class="container mt-4">
        <h1 class="mb-4">좌석 선택</h1>
        <input type="hidden" id="matchid" value="${param.matchid}"/>
        <input type="hidden" id="stadiumid" value="${param.stadiumid}"/>
        <input type="hidden" id="section" value="${param.section}"/>
        <div class="row">
            <div class="col-md-8">
                <div id="seat-map-container">
                    <div id="ground" class="ground spacing"></div>
                    <div id="seat-map" class="spacing"></div>
                </div> <!-- seat-map-container 끝 -->
            </div>
            <div class="col-md-4">
                <div id="selected-seats-info" class="seat-info">
                    <div class="choice">
                        <div class="choice-header">
                            <strong>선택좌석</strong>
                            <span id="selected-seat-count">총 0석 선택되었습니다.</span>
                        </div>
                        <table class="choice-table">
                            <colgroup>
                                <col width="75px">
                                <col width="*">
                                <col width="75px">
                            </colgroup>
                            <thead>
                                <tr>
                                    <th>좌석등급</th>
                                    <th>좌석번호</th>
                                    <th>금액</th>
                                </tr>
                            </thead>
                            <tbody>
                            </tbody>
                        </table>
                    </div> <!-- choice 끝 -->
                </div> <!-- selected-seats-info 끝 -->
                <div id="total-price">총 금액: 0원</div>
                <div class="btn-group mt-3">
                    <button type="button" class="btn btn-secondary" id="prev-step">이전단계</button>
                    <button type="button" class="btn btn-secondary" id="reset-seats">좌석 다시 선택</button>
                    <button type="button" class="btn btn-danger" id="complete-selection">좌석선택완료</button>
                </div> <!-- btn-group 끝 -->
            </div> <!-- col-md-4 끝 -->
        </div> <!-- row 끝 -->
    </div> <!-- container 끝 -->
    <script>
        document.addEventListener('DOMContentLoaded', function() {
            // 경기장 바닥 위치를 지정하는 객체
            var groundPositions = {
                'N': 'north', // 북쪽은 북쪽에 위치
                'S': 'south', // 남쪽은 남쪽에 위치
                'E': 'west',  // 동쪽은 서쪽에 위치
                'W': 'east'   // 서쪽은 동쪽에 위치
            };

            // JSP에서 전달된 좌석 JSON 데이터를 파싱하여 자바스크립트 객체로 변환
            var seats = JSON.parse('<c:out value="${seatsJson}" escapeXml="false"/>');
            var section = document.getElementById('section').value;
            var matchId = document.getElementById('matchid').value;
            var stadiumId = document.getElementById('stadiumid').value;
            var groundPosition = groundPositions[section];

            // 디버깅을 위한 콘솔 로그
            console.log("matchId:", matchId);
            console.log("stadiumId:", stadiumId);
            console.log("section:", section);

            var seatMap = document.getElementById('seat-map');
            var ground = document.getElementById('ground');

            // 좌석 배치도를 생성
            if (seatMap && seats.length > 0) {
                // 각 좌석에 대해 div 요소를 생성하고 배치
                seats.forEach(function(seat) {
                    var seatElement = document.createElement('div');
                    seatElement.className = 'seat';
                    seatElement.dataset.seatId = seat.seatid;  // 좌석 ID 설정
                    seatElement.dataset.price = seat.price;    // 좌석 가격 설정
                    seatElement.textContent = seat.seatnumber; // 좌석 번호 설정

                    // 좌석 클릭 이벤트 리스너 추가
                    seatElement.addEventListener('click', function() {
                        // 선택된 좌석의 클래스를 토글
                        if (this.classList.contains('selected')) {
                            this.classList.remove('selected');
                        } else {
                            // 선택된 좌석이 5개 이하인 경우에만 선택 가능
                            if (document.querySelectorAll('.seat.selected').length < 5) {
                                this.classList.add('selected');
                            } else {
                                alert('5개의 좌석까지 구매 가능합니다.');
                            }
                        }
                        updateSelectedSeats(); // 선택된 좌석 정보 업데이트
                    });
                    seatMap.appendChild(seatElement); // 좌석 요소를 좌석 배치도에 추가
                });

                // 경기장 바닥의 위치와 방향을 설정
                ground.className = 'ground ' + groundPosition;
                ground.textContent = 'GROUND';
                var seatMapContainer = document.getElementById('seat-map-container');
                seatMapContainer.style.flexDirection = (groundPosition === 'south' || groundPosition === 'north') ? 'column' : 'row';

                // 경기장 바닥을 좌석 배치도의 적절한 위치에 추가
                if (groundPosition === 'north' || groundPosition === 'west') {
                    seatMapContainer.insertBefore(ground, seatMap);
                } else {
                    seatMapContainer.appendChild(ground);
                }
            }

            /**
             * 선택된 좌석 정보를 업데이트하는 함수
             */
            function updateSelectedSeats() {
                var selectedSeats = document.querySelectorAll('.seat.selected');
                var tbody = document.querySelector('.choice-table tbody');
                var seatCount = document.getElementById('selected-seat-count');
                var totalPriceElement = document.getElementById('total-price');
                var totalPrice = 0;
                tbody.innerHTML = '';

                // 선택된 각 좌석에 대해 테이블에 정보를 추가
                selectedSeats.forEach(function(seat) {
                    var price = parseInt(seat.dataset.price, 10); // 좌석 가격
                    totalPrice += price; // 총 가격에 추가
                    var row = document.createElement('tr');
                    var cell1 = document.createElement('th');
                    cell1.innerHTML = '<span>일반석</span>'; // 좌석 등급 정보
                    var cell2 = document.createElement('td');
                    cell2.textContent = seat.dataset.seatId; // 좌석 ID 정보
                    var cell3 = document.createElement('td');
                    cell3.textContent = price.toLocaleString() + '원'; // 좌석 가격 정보
                    row.appendChild(cell1);
                    row.appendChild(cell2);
                    row.appendChild(cell3);
                    tbody.appendChild(row); // 테이블에 행 추가
                });

                // 선택된 좌석 수와 총 금액을 업데이트
                seatCount.textContent = '총 ' + selectedSeats.length + '석 선택되었습니다.';
                totalPriceElement.textContent = '총 금액: ' + totalPrice.toLocaleString() + '원';
            }

            // 이전 단계 버튼 클릭 이벤트 리스너 추가
            document.getElementById('prev-step').addEventListener('click', function() {
                window.history.back(); // 이전 페이지로 이동
            });

            // 좌석 다시 선택 버튼 클릭 이벤트 리스너 추가
            document.getElementById('reset-seats').addEventListener('click', function() {
                document.querySelectorAll('.seat.selected').forEach(function(seat) {
                    seat.classList.remove('selected'); // 선택된 좌석 해제
                });
                updateSelectedSeats(); // 선택된 좌석 정보 업데이트
            });

            // 좌석 선택 완료 버튼 클릭 이벤트 리스너 추가
            document.getElementById('complete-selection').addEventListener('click', function() {
                var selectedSeats = document.querySelectorAll('.seat.selected');
                if (selectedSeats.length === 0) {
                    alert('좌석을 선택해 주세요.'); // 좌석이 선택되지 않았을 경우 경고
                    return;
                }
                var seats = [];
                var totalPrice = 0;
                selectedSeats.forEach(function(seat) {
                    seats.push(seat.dataset.seatId); // 선택된 좌석 ID 저장
                    totalPrice += parseInt(seat.dataset.price, 10); // 총 가격 계산
                });

                // 매치 ID, 경기장 ID, 구역 정보를 인코딩하여 URL로 이동
                var matchId = encodeURIComponent(document.getElementById('matchid').value);
                var stadiumId = encodeURIComponent(document.getElementById('stadiumid').value);
                var section = encodeURIComponent(document.getElementById('section').value);
																								/* 안전하게 사용할 수 있는 문자열로 변환 */
                window.location.href = '/tickets/reservation?matchid=' + matchId + '&seats=' + encodeURIComponent(JSON.stringify(seats)) + '&totalPrice=' + totalPrice + '&section=' + section + '&stadiumid=' + stadiumId;
            });
        });
    </script> <!-- 스크립트 끝 -->
</body>
</html>
