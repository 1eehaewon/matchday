<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<style>

    .cart-container {
        background-color: #fff;
        padding: 50px;   
    }
	
    .order_wrap {
        max-width: 1500px;
        margin: 0 auto;
    }
	
	/* 장바구니 라인 */
    .order_tit {
    	border-bottom: 0.5px solid #000; /* 아래쪽 선 */
        margin-bottom: 30px;
    }

    .order_tit h2 {
        font-size: 30px;
        font-weight: bold;
        color: #333;
        margin-bottom: 10px;
    }

    .order_tit ol {
        list-style: none;
        display: flex;
        justify-content: right;
    }

    .order_tit ol li {
        display: flex;
        align-items: center;
        margin-right: 30px;
        font-size: 20px;
        color: #666;
    }

    .order_tit ol li.page_on span {
        font-weight: bold;
        color: #333;
    }

    .order_tit ol li img {
        margin-left: 5px;
        vertical-align: middle;
    }
    /* 장바구니 라인 end */

    /* 장바구니 상품 공간 */
    .cart_cont {
    	border-bottom: 0.5px solid #000; /* 아래쪽 선 */
        background-color: #fff;
        padding: 20px;
        margin-bottom: 50px;
        
    }

    .no_data {
        text-align: center;
        font-size: 20px;
        color: #666;
        margin-top: 20px;
    }

	/* 쇼핑계속하기 */
    .btn_left_box {
        text-align: left;
        margin-top: 20px;
    }

    .shop_go_link {
        font-size: 20px;
        color: #333;
        text-decoration: none;
    }

    .shop_go_link em {
        font-style: normal;
        font-weight: bold;
    }
	/* 쇼핑계속하기 end */

	/* 총 금액 계산하는 곳 */
    .price_sum {
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .price_sum_list {
        display: flex;
        align-items: center;
        justify-content: space-between;
    }

    .price_sum_list dl {
        margin-bottom: 10px;
    }

    .price_sum_list dl dt {
        font-size: 16px;
        font-weight: bold;
        color: #333;
    }

    .price_sum_list dl dd {
        font-size: 16px;
        color: #333;
    }

    .price_sum_list span img {
        margin: 0 10px;
    }

    .price_sum_list dl.price_total {
        font-size: 18px;
    }

    .price_sum_list dl.price_total dt {
        color: #333;
        font-weight: bold;
    }

    .price_sum_list dl.price_total dd {
        font-size: 18px;
        color: #333;
        font-weight: bold;
    }
    /* 총 금액 계산하는 곳 end */
    
</style>
<!-- 본문 시작 list.jsp -->
<div class="cart-container">
	<div class="content_box">
	    <div class="order_wrap">
	    
	        <div class="order_tit">
	            <h2>장바구니</h2>
	            <ol>
	                <li class="page_on"><span>01</span> 장바구니 <span><img src="https://cdn-pro-web-210-60.cdn-nhncommerce.com/difkorea4_godomall_com/data/skin/front/TOPSKIN/img/member/icon_join_step_on.png" alt="장바구니진행 중"></span></li>
	                <li><span>02</span> 주문서작성/결제<span><img src="https://cdn-pro-web-210-60.cdn-nhncommerce.com/difkorea4_godomall_com/data/skin/front/TOPSKIN/img/member/icon_join_step_off.png" alt="주문서작성/결제대기"></span></li>
	                <li><span>03</span> 주문완료</li>
	            </ol>
	        </div>
	        <!-- //order_tit -->
	
	        <div class="cart_cont">
	            <form id="Cartfrm" name="Cartfrm" method="post">
	            <!-- 장바구니 상품리스트 시작 -->
				<div class="row">
					<div class="col-sm-12">
						<table class="table table-hover">
							<thead class="table-active">
								<tr>
									<th><input type="checkbox" id="selectAllCheckbox" onchange="toggleCheckboxes(this.checked)"></th>
									<th>상품 정보</th>	
									<th>수량</th>
									<th>가격</th>
									<th>총 가격</th>	
									<th>삭제</th>
								</tr>					
							</thead>
							<tbody>
							    <c:forEach items="${cartList}" var="cart">
							        <tr>
							            <td><input type="checkbox" name="selectedItems" value="${cart.cartid}" onchange="calculateTotal()"></td>
							            <td>
                                            <c:set var="goodsItem" value="${goodsMap[cart.goodsid]}" />
                                            <c:choose>
                                                <c:when test="${goodsItem ne null}">
                                                    <img src="/storage/goods/${cart.goodsid}.jpg" alt="${goodsItem.productname}" style="width: 50px; height: 50px; object-fit: cover;">
                                                    <span>${goodsItem.productname}</span>
                                                </c:when>
                                                <c:otherwise>
                                                    <span>상품 정보 없음</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
							            <td>${cart.quantity}</td>
							            <td>${cart.unitprice}</td>
							            <td>${cart.totalprice}</td>
							            <td><button type="button" onclick="deleteItem(${cart.cartid})">삭제하기</button></td>
							        </tr>
							    </c:forEach>
							</tbody>
						</table>
					</div><!-- col end -->
				</div><!-- row end -->
	                <!-- cart_cont_list -->
	                <!-- 장바구니 상품리스트 끝 -->
	
	                <p class="no_data" id="noDataMessage" style="display: none;">장바구니에 담겨있는 상품이 없습니다.</p>
	            </form>
	        </div>
	        <!-- //cart_cont -->
	        
	        <div class="price_sum">
	        	<div class="price_sum_cont">
		            <div class="price_sum_list">
		            	<dl>
                            <dt>총 <strong id="totalSelectedCount">0</strong> 개의 상품금액 </dt>
                            <dd><strong id="totalSelectedPrice">0</strong>원</dd>
                        </dl>
                        <span><img src="https://cdn-pro-web-210-60.cdn-nhncommerce.com/difkorea4_godomall_com/data/skin/front/TOPSKIN/img/order/order_price_plus.png" alt="더하기" /></span>
                        <dl>
                            <dt>배송비</dt>
                            <dd><strong id="totalDeliveryCharge">0</strong>원</dd>
                        </dl>
                        <span><img src="https://cdn-pro-web-210-60.cdn-nhncommerce.com/difkorea4_godomall_com/data/skin/front/TOPSKIN/img/order/order_price_total.png" alt="합계" /></span>
                        <dl class="price_total">
                            <dt>합계</dt>
                            <dd><strong id="totalSettlePrice">0</strong>원</dd>
                        </dl>
		            </div>
	            	<em id="deliveryChargeText" class="tobe_mileage"></em>
		        </div>
		        <!-- price_sum_cont end-->
	    	</div>
	        <!-- price_sum end -->
	        <div class="btn_left_box">
	        	<a href="/goods/list" class="shop_go_link"><em>&lt; 쇼핑 계속하기</em></a>
	        </div>
	    </div>
	    <!-- order_wrap end-->
	</div>
	<!-- content_box end-->
</div> <!-- carts-container end -->

<!-- 본문 끝 -->

<script>
    // 전체 선택 체크박스 클릭 시 모든 체크박스를 선택 또는 해제하는 함수
    function toggleCheckboxes(checked) {
        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            checkbox.checked = checked;
        }
        calculateTotal();
    }

    // 선택된 상품의 개수와 총 가격을 계산하여 표시하는 함수
    function calculateTotal() {
        var totalSelectedCount = 0;
        var totalSelectedPrice = 0;

        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                totalSelectedCount++;
                var row = checkbox.parentNode.parentNode;
                var totalPriceCell = row.cells[4];
                totalSelectedPrice += parseInt(totalPriceCell.textContent);
            }
        }

     	// 상품금액 표시
        document.getElementById('totalSelectedCount').textContent = totalSelectedCount;
        document.getElementById('totalSelectedPrice').textContent = totalSelectedPrice.toLocaleString(); // 콤마(,) 표시 추가

        // 배송비 계산
        var deliveryCharge = totalSelectedPrice >= 100000 ? 0 : 3500;
        document.getElementById('totalDeliveryCharge').textContent = deliveryCharge.toLocaleString();
        
        // 합계 계산
        var totalSettlePrice = totalSelectedPrice + deliveryCharge;
        document.getElementById('totalSettlePrice').textContent = totalSettlePrice.toLocaleString();
    }
    
 	// 문서 로드 시 장바구니에 상품이 없는 경우 메시지 표시
    document.addEventListener("DOMContentLoaded", function() {
        var cartItems = document.getElementsByName('selectedItems');
        if (cartItems.length === 0) {
            document.getElementById('noDataMessage').style.display = 'block';
        }
    });
 	
    function deleteItem(cartid){
		if(confirm("장바구니에서 해당 상품을 삭제할까요?")){
			location.href='/cart/delete?cartid=' + cartid; 
		}//if end
	}//deleteItem() end
 	
 	
 	
 	
 	
 	
 	
 	
 	

 	
</script>

<%@ include file="../footer.jsp" %>