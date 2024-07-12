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
	
	/* 테이블 헤더와 바디의 내용 가운데 정렬 */
    .table-active, .table-hover tbody {
        text-align: center;
        vertical-align: middle;
    }
    
    /* 체크박스 및 텍스트 크기 */
    .table-active th, .table-hover tbody td {
        font-size: 18px;
    }
    .table-active th input[type="checkbox"], .table-hover tbody td input[type="checkbox"] {
        width: 20px;
        height: 20px;
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
    
    /* 수량 입력 텍스트 박스 및 버튼 스타일 */
	.quantity-input {
	    width: 50px; /* 텍스트 박스 너비 */
	    height: 40px; /* 텍스트 박스 높이 */
	    text-align: center; /* 텍스트 가운데 정렬 */
	    font-size: 18px; /* 텍스트 크기 */
	    margin: 0 5px; /* 텍스트 박스 좌우 여백 */
	    border: 1px solid #ccc; /* 테두리 */
	    border-radius: 4px; /* 모서리 둥글게 */
	}
	
	.quantity-input:focus {
	    outline: none; /* 포커스 시 외곽선 제거 */
	    border-color: #666; /* 포커스 시 테두리 색상 */
	}
	
	.수량-button {
	    width: 40px; /* 버튼 너비 */
	    height: 40px; /* 버튼 높이 */
	    font-size: 18px; /* 버튼 텍스트 크기 */
	    background-color: #f1f1f1; /* 버튼 배경 색상 */
	    border: 1px solid #ccc; /* 버튼 테두리 */
	    border-radius: 4px; /* 모서리 둥글게 */
	    cursor: pointer; /* 마우스 커서 변경 */
	    margin: 0 5px; /* 버튼 좌우 여백 */
	}
	
	.수량-button:hover {
	    background-color: #e1e1e1; /* 버튼 호버 시 배경 색상 */
	}
	
	.수량-button:active {
	    background-color: #d1d1d1; /* 버튼 클릭 시 배경 색상 */
	    border-color: #999; /* 버튼 클릭 시 테두리 색상 */
	}
	
    /* 삭제 버튼 크기 */
    .delete-button-container {
	    display: flex;
		justify-content: flex-end; /* 항목을 오른쪽으로 정렬 */
		margin-top: 0; /* 필요에 따라 마진 조정 */
	}
	.delete-button {
	    font-size: 18px;
	    padding: 10px 20px; /* padding으로 크기 조정 */
	    background-color: #f1f1f1; /* 버튼 배경 색상 */
	    border: 1px solid #ccc; /* 버튼 테두리 */
	    border-radius: 4px; /* 모서리 둥글게 */
	    cursor: pointer; /* 마우스 커서 변경 */
	    margin: 0 5px; /* 버튼 좌우 여백 */
	}
	
	.delete-button:hover {
	    background-color: #e1e1e1; /* 버튼 호버 시 배경 색상 */
	}
	
	.delete-button:active {
	    background-color: #d1d1d1; /* 버튼 클릭 시 배경 색상 */
	    border-color: #999; /* 버튼 클릭 시 테두리 색상 */
	}

	/* 총 금액 계산하는 곳 */
    .price_sum {
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .price_sum_list {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 30px; /* 요소들 사이의 간격 */
    }

    .price_sum_list dl {
        margin-bottom: 10px;
    }

    .price_sum_list dl dt {
        font-size: 20px;
        font-weight: bold;
        color: #333;
    }

    .price_sum_list dl dd {
        font-size: 20px;
        color: #333;
    }

    .price_sum_list span img {
        margin: 0 10px;
    }

    .price_sum_list dl.price_total {
        font-size: 20px;
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
    
    /* 쇼핑계속하기/구매하기 */
    .shopping-buy {
        text-align: right;
        margin-top: 20px;
    }
    
	/* 쇼핑 계속하기 */
    .shop_go_link {
        font-size: 20px;
        color: #333;
        text-decoration: none;
    }

    .shop_go_link em {
        font-style: normal;
        font-weight: bold;
    }
	
	/* 구매하기 */
  	.buy-button {
    padding: 12px 24px;
    font-size: 20px;
    background-color: #4CAF50;
    color: white;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    transition: background-color 0.3s;
	}
	
	.buy-button:hover {
	    background-color: #45a049;
	}
	
	.buy-button:active {
	    background-color: #3e8e41;
	}

  
</style>
<!-- 본문 시작 cart/list.jsp -->
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
									<th>사이즈</th>	
									<th>수량</th>
									<th>가격</th>
									<th>총 가격</th>	
									<!-- <th>삭제</th> -->
								</tr>					
							</thead>
							<tbody style="text-align: center;">
							    <c:forEach items="${cartList}" var="cart">
							        <tr>
							            <td><input type="checkbox" name="selectedItems" value="${cart.cartid}" onchange="calculateTotal()"></td>
							            <td>
                                        <c:forEach items="${goodsList}" var="goods">
	                                        <c:if test="${cart.goodsid eq goods.goodsid}">
		                                        <div class="product-image">
			                                        <c:if test="${not empty goods.filename}">
			                                        	<a href="${pageContext.request.contextPath}/goods/detail?goodsid=${goods.goodsid}">
			                                        	<img src="${pageContext.request.contextPath}/storage/goods/${goods.filename}" alt="${goods.productname}" style="width: 100px; height: 100px; object-fit: cover;">
			                                        	</a>
			                                        </c:if>
		                                        </div>
		                                        <br>
	                                        	<span>${goods.productname}</span>
	                                        </c:if>
                                        </c:forEach>
                                        </td>
                                        <td>
                                        	<c:forEach items="${goodsList}" var="goods">
                                        	<c:if test="${cart.goodsid eq goods.goodsid}">
                                        	${goods.size}
                                        	</c:if>
                                        	</c:forEach>
                                        </td>
							            <td>
										    <button type="button" onclick="decrementQuantity(this)" class="수량-button">-</button>
										    <input type="text" class="quantity-input" value="${cart.quantity}" readonly>
										    <button type="button" onclick="incrementQuantity(this)" class="수량-button">+</button>
										</td>
							            <td><fmt:formatNumber value="${cart.unitprice}" pattern="#,###원" /></td>
							            <td><fmt:formatNumber value="${cart.totalprice}" pattern="#,###원" /></td>
							            <%-- <td><button type="button" onclick="deleteItem(${cart.cartid})" class="delete-button">삭제하기</button></td> --%>
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
	            <div class="delete-button-container">
			        <!-- 선택한 상품 삭제 버튼 -->
					<button type="button" id="deleteSelectedButton" class="delete-button">선택한 상품만 삭제하기</button>
					<!-- 전체 삭제 버튼 -->
					<button type="button" id="deleteAllButton" class="delete-button">전체 삭제하기</button>
	        	</div>
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
	        <div class="shopping-buy">
	        	<a href="/goods/list" class="shop_go_link"><em>&lt; 쇼핑 계속하기</em></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
	        	<!-- <button type="button" class="buy-button" onclick="openPopup('/order/payment')">구매하기</button> 자바스크립트에 url -->
	        	<%-- <a href="/order/payment?goodsid=${goodsDto.goodsid}"><button>구매하기</button></a> --%>
	        	<button type="button" class="buy-button" onclick="proceedToPayment()">구매하기</button>
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

 	// 수량 증가 함수
    function incrementQuantity(button) {
        var input = button.parentNode.querySelector('.quantity-input');
        var newValue = parseInt(input.value) + 1;
        input.value = newValue;
        updateTotalPrice();
    }

    // 수량 감소 함수
    function decrementQuantity(button) {
        var input = button.parentNode.querySelector('.quantity-input');
        var newValue = parseInt(input.value) - 1;
        if (newValue >= 0) {
            input.value = newValue;
            updateTotalPrice();
        }
    }

    // 수량 변경에 따른 총 가격 업데이트 함수
    function updateTotalPrice() {
        var totalSelectedCount = 0;
        var totalSelectedPrice = 0;

        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                totalSelectedCount++;
                var row = checkbox.parentNode.parentNode;
                var quantity = parseInt(row.querySelector('.quantity-input').value);
                var unitPrice = parseInt(row.cells[4].textContent.replace('원', '').replace(',', '')); // 단가가 표시된 셀 인덱스를 가정
                var totalPrice = quantity * unitPrice;
                totalSelectedPrice += totalPrice;
                row.cells[5].textContent = totalPrice.toLocaleString() + ("원"); // 총 가격 열 업데이트
            }
        }

        // 화면에 표시되는 총합 업데이트
        document.getElementById('totalSelectedCount').textContent = totalSelectedCount;
        document.getElementById('totalSelectedPrice').textContent = totalSelectedPrice.toLocaleString();
        
        // 배송비 계산 및 총 결제 가격 업데이트
        var deliveryCharge = totalSelectedPrice >= 100000 ? 0 : 3500;
        document.getElementById('totalDeliveryCharge').textContent = deliveryCharge.toLocaleString();
        
        var totalSettlePrice = totalSelectedPrice + deliveryCharge;
        document.getElementById('totalSettlePrice').textContent = totalSettlePrice.toLocaleString();
    }// updateTotalPrice() end

    // 수량 입력 변경 이벤트 리스너
    document.addEventListener("DOMContentLoaded", function() {
        var quantityInputs = document.querySelectorAll('.quantity-input');
        for (var input of quantityInputs) {
            input.addEventListener('change', updateTotalPrice);
        }
    });
 
    // 선택된 상품의 개수와 총 가격을 계산하여 표시하는 함수
    function calculateTotal() {
        var totalSelectedCount = 0;
        var totalSelectedPrice = 0;

        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                totalSelectedCount++;
                var row = checkbox.parentNode.parentNode;
                var totalPriceCell = row.cells[5];
                totalSelectedPrice += parseInt(totalPriceCell.textContent.replace('원', '').replace(',', ''));
            }
        }//for end

     	// 상품금액 표시
        document.getElementById('totalSelectedCount').textContent = totalSelectedCount;
        document.getElementById('totalSelectedPrice').textContent = totalSelectedPrice.toLocaleString(); // 콤마(,) 표시 추가

        // 배송비 계산
        var deliveryCharge = totalSelectedPrice >= 100000 ? 0 : 3500;
        document.getElementById('totalDeliveryCharge').textContent = deliveryCharge.toLocaleString();
        
        // 합계 계산
        var totalSettlePrice = totalSelectedPrice + deliveryCharge;
        document.getElementById('totalSettlePrice').textContent = totalSettlePrice.toLocaleString();
    }//calculateTotal() end
    
 	// 문서 로드 시 장바구니에 상품이 없는 경우 메시지 표시
    document.addEventListener("DOMContentLoaded", function() {
        var cartItems = document.getElementsByName('selectedItems');
        if (cartItems.length === 0) {
            document.getElementById('noDataMessage').style.display = 'block';
        }
    });
 	
 	// 선택된 상품 삭제 함수
    function deleteSelectedItems() {
        var selectedItems = [];
        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                selectedItems.push(checkbox.value);
            }
        }

        if (selectedItems.length === 0) {
            alert("삭제할 상품을 선택해주세요.");
            return;
        }

        if (confirm("선택한 상품을 삭제하시겠습니까?")) {
            var url = '/cart/delete?cartid=' + selectedItems.join(',');
            location.href = url;
        }
    }//deleteSelectedItems() end

    // 전체 상품 삭제 함수
    function deleteAllItems() {
        if (confirm("전체 상품을 삭제하시겠습니까?")) {
            var checkboxes = document.getElementsByName('selectedItems');
            for (var checkbox of checkboxes) {
                checkbox.checked = true;
            }
            var selectedItems = [];
            for (var checkbox of checkboxes) {
                selectedItems.push(checkbox.value);
            }
            var url = '/cart/delete?cartid=' + selectedItems.join(',');
            location.href = url;
        }
    }

	 	// 버튼에 기능을 첨부합니다
	    document.addEventListener("DOMContentLoaded", function() {
	    document.getElementById('deleteSelectedButton').addEventListener('click', deleteSelectedItems);
	    document.getElementById('deleteAllButton').addEventListener('click', deleteAllItems);
    }); //deleteSelectedItems() end

    
 	// 결제 진행 함수
    function proceedToPayment() {
        var selectedItems = []; // 선택된 상품 배열 생성
        var checkboxes = document.getElementsByName('selectedItems'); // 'selectedItems' 이름을 가진 모든 체크박스를 가져옴
        // 각 체크박스를 확인하여 선택된 경우 배열에 추가
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                selectedItems.push(checkbox.value); // 체크박스의 값을 배열에 추가
            }
        }
        // 선택된 상품이 없는 경우 알림을 표시하고 함수 종료
        if (selectedItems.length === 0) {
            alert("상품을 선택해주세요."); // 경고창 표시
            return; // 함수 종료
        }

        // 선택된 상품의 ID를 URL에 추가하여 페이지 이동
        var url = '/order/payment?goodsid=' + selectedItems.join(','); // 선택된 상품 ID를 ','로 구분하여 문자열 생성
        location.href = url;
    }//proceedToPayment() end

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
/*     function openPopup(url) {
        var selectedItems = [];
        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                selectedItems.push(checkbox.value);
            }
        }

        if (selectedItems.length === 0) {
            alert("상품을 선택해주세요.");
            return;
        }

        var queryString = selectedItems.join(',');
        var popupUrl = url + '?goodsid=' + queryString;
        /* var popupUrl = url + '?cartid=' + queryString; */
        
       // window.open(popupUrl, "popupWindow", "width=1200,height=800,scrollbars=yes");
    //}// openPopup(url) end */
 	
 	
 	
 	
 	
 	
 	
 	
 	

 	
</script>

<%@ include file="../footer.jsp" %>