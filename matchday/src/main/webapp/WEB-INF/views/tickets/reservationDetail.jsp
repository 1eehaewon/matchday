<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
                    <td>
                        <c:choose>
                            <c:when test="${reservation.reservationstatus == 'Confirmed'}">
                                예매완료
                            </c:when>
                            <c:when test="${reservation.reservationstatus == 'Cancelled'}">
                                결제취소
                            </c:when>
                            <c:otherwise>
                                ${reservation.reservationstatus}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>결제수단</th>
                    <td>
                        <c:choose>
                            <c:when test="${reservation.paymentmethodname == 'card'}">
                                카드
                            </c:when>
                            <c:otherwise>
                                ${reservation.paymentmethodname}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>수수료</th>
                    <td>${serviceFee}원</td>
                </tr>
                <tr>
                    <th>배송료</th>
                    <td>${deliveryFee}원</td>
                </tr>
                <tr>
                    <th>사용한 쿠폰</th>
                    <td>${couponName}</td>
                </tr>
                <tr>
                    <th>사용한 멤버십</th>
                    <td>${membershipName}</td>
                </tr>
                <tr>
                    <th>총 할인액</th>
                    <td>${totalDiscount}원</td>
                </tr>
                <tr>
                    <th>총 결제금액</th>
                    <td>${totalPaymentAmount}원</td>
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
