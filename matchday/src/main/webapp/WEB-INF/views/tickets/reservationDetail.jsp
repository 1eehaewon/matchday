<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
    <style>
        .card-header {
            background-color: #f8f9fa;
            font-weight: bold;
        }
        .info-title {
            font-weight: bold;
        }
        .info-content {
            margin-bottom: 0.5rem;
        }
        .table {
            width: 100%;
            table-layout: fixed;
        }
        .table th, .table td {
            word-wrap: break-word;
        }
    </style>
<div class="container mt-4">
    <h1 class="mb-4">예약 상세 정보</h1>

    <div class="card mb-4">
        <div class="card-header">
            예매정보
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>예약자</th>
                    <td>${reservation.userName}</td>
                </tr>
                <tr>
                    <th>예약번호</th>
                    <td>${reservation.reservationid}</td>
                </tr>
                <tr>
                    <th>이용기간</th>
                    <td><fmt:formatDate value="${reservation.matchdate}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/></td>
                </tr>
                <tr>
                    <th>장소</th>
                    <td>${reservation.stadiumName}</td>
                </tr>
                <tr>
                    <th>위치</th>
                    <td>${reservation.location}</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            결제 내역
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>예약일</th>
                    <td>${reservation.reservationdate}</td>
                </tr>
                <tr>
                    <th>현재상태</th>
                    <td>${reservation.reservationstatus}</td>
                </tr>
                <tr>
                    <th>결제수단</th>
                    <td>${reservation.paymentmethodname}</td>
                </tr>
                <tr>
                    <th>결제상태</th>
                    <td>빈칸</td>
                </tr>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            예약 내역
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th>좌석 ID</th>
                        <th>가격</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="detail" items="${reservation.details}">
                        <tr>
                            <td>${detail.seatid}</td>
                            <td>${detail.price}원</td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            예약 취소 유의사항
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>취소 마감시간</th>
                    <td><fmt:formatDate value="${reservation.cancelDeadline}" pattern="yyyy년 MM월 dd일 HH:mm:ss"/></td>
                </tr>
            </table>
            <p class="text-danger mt-3">취소 유의사항을 여기에 추가하세요.</p>
        </div>
    </div>
</div>
<%@ include file="../footer.jsp" %>