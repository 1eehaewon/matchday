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
    
    .table table-bordered{
    	width: 100%;
        table-layout: fixed;
    }
    
    .table table-bordered th, .table table-bordered td{
    	text-align: center;
        vertical-align: middle;
        font-size: 19px; /* 글자 크기 증가 */
    }
    
    .btn-group {
        display: flex;
        justify-content: center;
        gap: 10px;
    }
</style>

<div class="container mt-4">
    <h1 class="mb-4">주문 상세 정보</h1>
    
    <div class="card mb-4">
        <div class="card-header">
            주문 정보
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <tr>
                    <th>회원 ID</th>
                    <td>${order.userid}</td>
                </tr>
                <tr>
                    <th>주문번호</th>
                    <td>${order.orderid}</td>
                </tr>
                <tr>
                    <th>구매일자</th>
                    <td>${order.orderdate}</td>
                </tr>
                <tr>
                    <th>수령인 이름</th>
                    <td>${order.recipientname}</td>
                </tr>
                <tr>
                    <th>수령인 이메일</th>
                    <td>${order.recipientemail}</td>
                </tr>
                <tr>
                    <th>수령인 전화번호</th>
                    <td>${order.recipientphone}</td>
                </tr>
                <tr>
                    <th>배송지</th>
                    <td>${order.shippingaddress}</td>
                </tr>
                <tr>
                    <th>배송 요청사항</th>
                    <td>${order.shippingrequest}</td>
                </tr>
                <tr>
                    <th>배송 시작 일자</th>
                    <td>${order.shippingstartdate}</td>
                </tr>
                <tr>
                    <th>배송 종료 일자</th>
                    <td>${order.shippingenddate}</td>
                </tr>
                <tr>
                    <th>배송 상태</th>
                    <td>
                        <%-- <c:set var="currentDate" value="<%= new java.util.Date() %>" /> --%>
                        <c:choose>
                            <c:when test="${currentDate.after(order.shippingenddate)}">
                                배송완료
                            </c:when>
                            <c:otherwise>
                                배송중
                            </c:otherwise>
                        </c:choose>
                    </td>
                    <%-- <td>
                    	<c:choose>
                            <c:when test="${order.shippingstatus == 'Completed'}">
                                배송완료
                            </c:when>
                            <c:when test="${order.shippingstatus == 'Pending'}">
                                배송중
                            </c:when>
                            <c:otherwise>
                                ${order.shippingstatus}
                            </c:otherwise>
                        </c:choose>
                    </td> --%>
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
                    <th>현재상태</th>
                    <td>
                        <c:choose>
                            <c:when test="${order.orderstatus == 'Completed'}">
                                주문 완료
                            </c:when>
                            <c:when test="${order.orderstatus == 'Cancelled'}">
                                결제 취소
                            </c:when>
                            <c:otherwise>
                                ${order.orderstatus}
                            </c:otherwise>
                        </c:choose>
                    </td>
                </tr>
                <tr>
                    <th>결제수단</th>
                    <td>
	                    <c:choose>
	                       <c:when test="${order.paymentmethodcode == 'pay01'}">
	                           카드
	                       </c:when>
	                       <c:otherwise>
	                           ${order.paymentmethodcode}
	                       </c:otherwise>
	                    </c:choose> 
                    </td>
                </tr>
                <tr>
                    <th>배송료</th>
                    <td><fmt:formatNumber value="${order.deliveryfee}" pattern="#,###원"/></td>
                </tr>
                <tr>
                    <th>사용한 쿠폰 / 할인율</th>
					<td>
					    <c:choose>
					        <c:when test="${order.couponid != null}">
					            <c:forEach items="${couponList}" var="coupon">
				                    ${coupon.couponname} / ${coupon.discountrate}%
					            </c:forEach>
					        </c:when>
					        <c:otherwise>
					            사용 안함
					        </c:otherwise>
					    </c:choose>
					</td>
                </tr>
                <tr>
                    <th>할인액</th>
                    <td><fmt:formatNumber value="${order.discountprice}" pattern="#,###원"/></td>
                </tr>
                <tr>
                    <th>사용한 포인트</th>
                    <td>${order.usedpoints}&nbsp;point</td>
                </tr>
                <tr>
                    <th>총 결제금액</th>
                    <td><fmt:formatNumber value="${order.finalpaymentamount}" pattern="#,###원"/>
                    	<c:forEach items="${order.orderDetails}" var="orderDetail">
                    	<fmt:formatNumber value="${orderDetail.totalamount}" pattern="#,###원"/>
                    	</c:forEach>
                    </td>
                </tr>
            </table>
        </div>
    </div>

    <div class="card mb-4">
        <div class="card-header">
            주문 내역
        </div>
        <div class="card-body">
            <table class="table table-bordered">
                <thead>
                    <tr>
                        <th style="text-align: center; vertical-align: middle;">상품명</th>
                        <th style="text-align: center; vertical-align: middle;">상품 사이즈</th>
                        <th style="text-align: center; vertical-align: middle;">상품 수량</th>
                        <th style="text-align: center; vertical-align: middle;">상품 가격</th>
                        <th style="text-align: center; vertical-align: middle;">상품 총 가격</th>
                    </tr>
                </thead>
                <tbody>
                	<c:forEach items="${orderdetail}" var="orderdetail">
                        <tr>
                        	<td style="text-align: center; vertical-align: middle; font-size: 21px;">
	               			<c:forEach items="${goodsList}" var="goods">
	                            <c:if test="${orderdetail.goodsid eq goods.goodsid}">
	                              <c:if test="${not empty goods.filename}">
	                              	<a href="${pageContext.request.contextPath}/goods/detail?goodsid=${goods.goodsid}">
	                              	<img src="${pageContext.request.contextPath}/storage/goods/${goods.filename}" alt="${goods.productname}" style="width: 50px; height: 50px; object-fit: cover;">
	                              	</a>
	                              </c:if>
	                             <br>
	                            	<span>${goods.productname}</span>
	                            </c:if>
                            </c:forEach>
	                		</td>
                            <td style="text-align: center; vertical-align: middle; font-size: 25px;">${orderdetail.size}</td>
                            <td style="text-align: center; vertical-align: middle; font-size: 25px;">${orderdetail.quantity}개</td>
                            <td style="text-align: center; vertical-align: middle; font-size: 25px;"><fmt:formatNumber value="${orderdetail.price}" pattern="#,###원"/></td>
                            <td style="text-align: center; vertical-align: middle; font-size: 25px;"><fmt:formatNumber value="${orderdetail.totalamount}" pattern="#,###원"/></td>
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
                    <td>~<fmt:formatDate value="${order.cancelDeadline}" pattern="yyyy-MM-dd HH:mm:ss"/></td>
                </tr>
            </table>
            <p class="text-danger mt-3">취소 유의사항을 여기에 추가하세요.</p>
        </div>
    </div>

    <div class="btn-group" align="center">
    	<c:choose>
            <c:when test="${order.orderstatus == 'Cancelled'}">
                <button id="cancel-payment" class="btn btn-danger" disabled>결제 취소</button>
            </c:when>
        	<c:otherwise>
        		<button id="cancel-payment" class="btn btn-danger">결제 취소</button>
        	</c:otherwise>
        </c:choose>
        &nbsp;&nbsp;
        <button id="go-back" class="btn btn-secondary">목록으로</button>
    </div>
    
<script>
$(document).ready(function() {
    $('#cancel-payment').click(function() {
       if (${order.orderstatus == 'Cancelled'}) {
           alert('이미 결제취소 된 건 입니다.');
           return;
        }
        if (confirm('정말로 결제를 취소하시겠습니까?')) {
            $.ajax({
                url: '/order/cancelPayment',
                type: 'POST',
                data: { orderid: '${order.orderid}' },
                success: function(response) {
                    if (response.success) {
                        alert('결제가 취소되었습니다.');
                        window.location.href = '/order/orderList';
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
        window.location.href = '/order/orderList';
    });
});

</script>

<%@ include file="../footer.jsp" %>
