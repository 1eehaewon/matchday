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
    .btn-group {
        display: flex;
        justify-content: center;
        gap: 10px;
    }
    /* 모달 스타일 */
    .modal {
        display: none;
        position: fixed;
        z-index: 1;
        left: 0;
        top: 0;
        width: 100%;
        height: 100%;
        overflow: auto;
        background-color: rgb(0,0,0);
        background-color: rgba(0,0,0,0.4);
    }
    .modal-content {
        background-color: #fefefe;
        margin: 5% auto;
        padding: 20px;
        border: 1px solid #888;
        width: 90%;
        max-width: 450px; /* 티켓 페이지와 맞게 조정 */
        height: 800px;
        max-height: 90%;
        overflow-y: auto; /* 모달 내용이 길어질 경우 스크롤 */
    }
    .close {
        color: #aaa;
        float: right;
        font-size: 28px;
        font-weight: bold;
    }
    .close:hover,
    .close:focus {
        color: black;
        text-decoration: none;
        cursor: pointer;
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
                    <th>이름</th>
                    <td>${reservation.userName}</td>
                </tr>
                <tr>
                    <th>예매번호</th>
                    <td>${reservation.reservationid}</td>
                </tr>
                <tr>
                    <th>경기일자</th>
                    <td id="match-date"><fmt:formatDate value="${reservation.matchdate}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>
                <tr>
                    <th>경기장</th>
                    <td>${reservation.stadiumName}</td>
                </tr>
                <tr>
                    <th>위치</th>
                    <td>${reservation.location}</td>
                </tr>
            </table>
        </div>
    </div>

    <!-- 모바일 티켓 확인 버튼 추가 -->
    <c:if test="${reservation.collectionmethodcode == 'receiving03'}">
        <div class="card mb-4">
            <div class="card-header">
                모바일 티켓
            </div>
            <div class="card-body text-center">
                <button id="showMobileTicket" class="btn btn-primary" <c:if test="${reservation.reservationstatus == 'Cancelled'}">disabled</c:if>>모바일 티켓 확인</button>
            </div>
        </div>
    </c:if>

    <div class="card mb-4">
        <div class="card-header">
            결제 내역
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>예매일</th>
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
				    <th>총 금액</th>
				    <td>${totalPrice}원</td>
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
				    <td>${reservation.discount}원</td>
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
            예약 취소 유의사항
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>취소 마감시간</th>
                    <td id="cancelDeadline"></td>
                </tr>
            </table>
            <p class="text-danger mt-3">결제하신 경기 관람일 3일전 오후 12시가 되면 결제취소가 불가능 합니다.</p>
        </div>
    </div>

    <div class="btn-group" align="center">
        <c:choose>
            <c:when test="${reservation.reservationstatus == 'Cancelled'}">
                <button id="cancel-payment" class="btn btn-danger" disabled>결제 취소</button>
            </c:when>
            <c:otherwise>
                <button id="cancel-payment" class="btn btn-danger">결제 취소</button>
            </c:otherwise>
        </c:choose>
        &nbsp;&nbsp;
        <button id="go-back" class="btn btn-secondary">목록으로</button>
    </div>
</div>

<!-- 모달 -->
<div id="mobileTicketModal" class="modal">
    <div class="modal-content">
        <span class="close">&times;</span>
        <iframe id="mobileTicketIframe" src="" style="width:100%; height:100%;"></iframe>
    </div>
</div>

<script>
    $(document).ready(function() {
        var modal = document.getElementById("mobileTicketModal");
        var btn = document.getElementById("showMobileTicket");
        var span = document.getElementsByClassName("close")[0];
        var iframe = document.getElementById("mobileTicketIframe");
        var cancelPaymentButton = document.getElementById('cancel-payment');
        var cancelDeadline;

        btn.onclick = function() {
            if (!btn.disabled) {
                iframe.src = '/tickets/mobileTicket?reservationid=${reservation.reservationid}';
                modal.style.display = "block";
            }
        }

        span.onclick = function() {
            modal.style.display = "none";
            iframe.src = "";
        }

        window.onclick = function(event) {
            if (event.target == modal) {
                modal.style.display = "none";
                iframe.src = "";
            }
        }

        function updateCancellationDeadline(matchDateStr) {
            var matchDateParts = matchDateStr.split(' ');
            var dateParts = matchDateParts[0].split('-');
            var timeParts = matchDateParts[1].split(':');
            var matchDate = new Date(dateParts[0], dateParts[1] - 1, dateParts[2], timeParts[0], timeParts[1], timeParts[2]);
            if (!isNaN(matchDate)) {
                matchDate.setDate(matchDate.getDate() - 3);
                matchDate.setHours(12, 0, 0, 0);
                cancelDeadline = matchDate;
                var options = { year: 'numeric', month: '2-digit', day: '2-digit', hour: '2-digit', minute: '2-digit', hour12: false };
                var formattedDate = new Intl.DateTimeFormat('ko-KR', options).format(matchDate);
                document.getElementById('cancelDeadline').textContent = formattedDate + ' 까지 취소가능';
            } else {
                document.getElementById('cancelDeadline').textContent = '날짜 오류';
            }
        }

        var matchDate = document.getElementById('match-date').textContent;
        updateCancellationDeadline(matchDate);

        $('#cancel-payment').click(function() {
            var now = new Date();
            if (now > cancelDeadline) {
                alert('결제취소 가능기간이 지났습니다.');
                return;
            }
            if ('${reservation.reservationstatus}' === 'Cancelled') {
                alert('이미 결제취소 된 건 입니다.');
                return;
            }
            if (confirm('정말로 결제를 취소하시겠습니까?')) {
                $.ajax({
                    url: '/tickets/cancelPayment',
                    type: 'POST',
                    data: { reservationid: '${reservation.reservationid}' },
                    success: function(response) {
                        if (response.success) {
                            alert('결제가 취소되었습니다.');
                            window.location.href = '/tickets/reservationList';
                        } else {
                            alert('결제 취소에 실패했습니다: ' + response.message);
                        }
                    },
                    error: function(error) {
                        alert('결제 취소 요청 중 오류가 발생했습니다.');
                    }
                });
            }
        });

        $('#go-back').click(function() {
            window.location.href = '/tickets/reservationList';
        });
    });
</script>

<%@ include file="../footer.jsp" %>
