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
	
	.table-active, .table-hover tbody {
        text-align: center;
        vertical-align: middle;
    }
    
    .table-active th, .table-hover tbody td {
        font-size: 18px;
    }
    .table-active th input[type="checkbox"], .table-hover tbody td input[type="checkbox"] {
        width: 20px;
        height: 20px;
    }
    
    .order_tit {
    	border-bottom: 0.5px solid #000;
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

    .cart_cont {
    	border-bottom: 0.5px solid #000;
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
    
	.quantity-input {
	    width: 50px;
	    height: 40px;
	    text-align: center;
	    font-size: 18px;
	    margin: 0 5px;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	}
	
	.quantity-input:focus {
	    outline: none;
	    border-color: #666;
	}
	
	.수량-button {
	    width: 40px;
	    height: 40px;
	    font-size: 18px;
	    background-color: #f1f1f1;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	    cursor: pointer;
	    margin: 0 5px;
	}
	
	.수량-button:hover {
	    background-color: #e1e1e1;
	}
	
	.수량-button:active {
	    background-color: #d1d1d1;
	    border-color: #999;
	}
	
    .delete-button-container {
	    display: flex;
		justify-content: flex-end;
		margin-top: 0;
	}
	.delete-button {
	    font-size: 18px;
	    padding: 10px 20px;
	    background-color: #f1f1f1;
	    border: 1px solid #ccc;
	    border-radius: 4px;
	    cursor: pointer;
	    margin: 0 5px;
	}
	
	.delete-button:hover {
	    background-color: #e1e1e1;
	}
	
	.delete-button:active {
	    background-color: #d1d1d1;
	    border-color: #999;
	}

    .price_sum {
        background-color: #fff;
        padding: 20px;
        box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
    }

    .price_sum_list {
        display: flex;
        align-items: center;
        justify-content: flex-end;
        gap: 30px;
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
    
    .shopping-buy {
        text-align: right;
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

<div class="container">
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
            <div class="cart_cont">
                <form id="Cartfrm" name="Cartfrm" method="post">
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
                                </tr>                    
                                </thead>
                                <tbody style="text-align: center;">
                                <c:forEach items="${cartList}" var="cart">
                                    <tr>
                                        <td><input type="checkbox" name="selectedItems" value="${cart.cartid}" onchange="calculateTotal()"></td>
                                        <td data-goodsid="${cart.goodsid}">
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
                                        <td data-cartid="${cart.cartid}" style="display :none;"></td>
                                        <td data-size="${cart.size}">${cart.size}</td>
                                        <td data-quantity="${cart.quantity}">
                                            <button type="button" onclick="decrementQuantity(this)" class="수량-button">-</button>
                                            <input type="text" class="quantity-input" value="${cart.quantity}" readonly>
                                            <button type="button" onclick="incrementQuantity(this)" class="수량-button">+</button>
                                        </td>
                                        <td data-price="${cart.unitprice}"><fmt:formatNumber value="${cart.unitprice}" pattern="#,###원" /></td>
                                        <td data-totalprice="${cart.totalprice}"><fmt:formatNumber value="${cart.totalprice}" pattern="#,###원" /></td>
                                    </tr>
                                </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                    <p class="no_data" id="noDataMessage" style="display: none;">장바구니에 담겨있는 상품이 없습니다.</p>
                </form>
                <div class="delete-button-container">
                    <button type="button" id="deleteSelectedButton" class="delete-button">선택한 상품만 삭제하기</button>
                    <button type="button" id="deleteAllButton" class="delete-button">전체 삭제하기</button>
                </div>
            </div>
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
            </div>
            <div class="shopping-buy">
                <a href="/goods/list" class="shop_go_link"><em>&lt; 쇼핑 계속하기</em></a>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
                <button class="buy-button" onclick="proceedToCartPayment()">구매하기</button>
            </div>
        </div>
    </div>
</div>

<script>

	var deliveryCharge = "";
	
	document.addEventListener("DOMContentLoaded", function() {
	    var quantityInputs = document.querySelectorAll('.quantity-input');
	    for (var input of quantityInputs) {
	        input.addEventListener('change', updateTotalPrice);
	    }
	    
	    // 페이지 로드 시 총합 업데이트
	    calculateTotal();
	});
	
	// 전체 선택/해제 기능
    function toggleCheckboxes(checked) {
        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            checkbox.checked = checked;
        }
        calculateTotal();
    }

 	// 수량 증가
    function incrementQuantity(button) {
        var input = button.parentNode.querySelector('.quantity-input');
        var newValue = parseInt(input.value) + 1;
        input.value = newValue;
        updateTotalPrice();
    }

 // 수량 감소
    function decrementQuantity(button) {
        var input = button.parentNode.querySelector('.quantity-input');
        var newValue = parseInt(input.value) - 1;
        if (newValue >= 0) {
            input.value = newValue;
            updateTotalPrice();
        }
    }

 	// 총 가격 업데이트
    function updateTotalPrice() {
        var totalSelectedCount = 0;
        var totalSelectedPrice = 0;

        var checkboxes = document.getElementsByName('selectedItems');
        for (var checkbox of checkboxes) {
            if (checkbox.checked) {
                totalSelectedCount++;
                var row = checkbox.parentNode.parentNode;
                var quantity = parseInt(row.querySelector('.quantity-input').value);
                var unitPriceText = row.querySelector('td[data-price]').dataset.price.replace('원', '').replace(',', '').trim();
                var unitPrice = parseInt(unitPriceText); // Parsing price here
                
                var totalPrice = quantity * unitPrice;
                totalSelectedPrice += totalPrice;
                row.querySelector('td[data-totalprice]').dataset.totalprice = totalPrice;
                row.querySelector('td[data-totalprice]').textContent = totalPrice.toLocaleString() + "원";
            }
        }

        document.getElementById('totalSelectedCount').textContent = totalSelectedCount;
        document.getElementById('totalSelectedPrice').textContent = totalSelectedPrice.toLocaleString();
        
        deliveryCharge = totalSelectedPrice >= 100000 ? 0 : 3500;
        document.getElementById('totalDeliveryCharge').textContent = deliveryCharge.toLocaleString();
        
        var totalSettlePrice = totalSelectedPrice + deliveryCharge;
        document.getElementById('totalSettlePrice').textContent = totalSettlePrice.toLocaleString();
    }

 	// 체크박스 변경 시 총합 업데이트
    function calculateTotal() {
        updateTotalPrice();
 	}
 	
 	// 페이지 로드 시
    document.addEventListener("DOMContentLoaded", function() {
        var quantityInputs = document.querySelectorAll('.quantity-input');
        for (var input of quantityInputs) {
            input.addEventListener('change', updateTotalPrice);
        }
    });

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
        }

        document.getElementById('totalSelectedCount').textContent = totalSelectedCount;
        document.getElementById('totalSelectedPrice').textContent = totalSelectedPrice.toLocaleString();

        deliveryCharge = totalSelectedPrice >= 100000 ? 0 : 3500;
        document.getElementById('totalDeliveryCharge').textContent = deliveryCharge.toLocaleString();
        
        var totalSettlePrice = totalSelectedPrice + deliveryCharge;
        document.getElementById('totalSettlePrice').textContent = totalSettlePrice.toLocaleString();
    }

    document.addEventListener("DOMContentLoaded", function() {
        var cartItems = document.getElementsByName('selectedItems');
        if (cartItems.length === 0) {
            document.getElementById('noDataMessage').style.display = 'block';
        }
    });

 	// 선택된 상품 삭제
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
    }

 	// 전체 상품 삭제
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

    document.addEventListener("DOMContentLoaded", function() {
	    document.getElementById('deleteSelectedButton').addEventListener('click', deleteSelectedItems);
	    document.getElementById('deleteAllButton').addEventListener('click', deleteAllItems);
    });

 	// 구매하기
    function proceedToCartPayment() {
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

        var goodsidList = [];
		var deliveryfee = '';
        var sizeList = [];
        var quantityList = [];
        var priceList = [];
        var cartIdList = [];
        var totalPriceList = [];

        var rows = Array.from(document.querySelectorAll('input[name="selectedItems"]:checked')).map(checkbox => checkbox.closest('tr'));
        rows.forEach(function(row) {
            goodsidList.push(row.querySelector('td[data-goodsid]').dataset.goodsid);
            sizeList.push(row.querySelector('td[data-size]').dataset.size);
            quantityList.push(row.querySelector('td[data-quantity] .quantity-input').value);
            priceList.push(row.querySelector('td[data-price]').dataset.price);
            totalPriceList.push(row.querySelector('td[data-totalprice]').dataset.totalprice);
            cartIdList.push(row.querySelector('td[data-cartid]').dataset.cartid);
        });

        var form = document.createElement('form');
        form.method = 'GET';
        form.action = '${pageContext.request.contextPath}/cart/cartPayment';
        form.target = 'cartPaymentPopup';

        var cartidInput = document.createElement('input');
        cartidInput.type = 'hidden';
        cartidInput.name = 'cartid';
        cartidInput.value = cartIdList.join(',');
        form.appendChild(cartidInput);
        
        var goodsidInput = document.createElement('input');
        goodsidInput.type = 'hidden';
        goodsidInput.name = 'goodsid';
        goodsidInput.value = goodsidList.join(',');
        form.appendChild(goodsidInput);

        var deliveryfeeInput = document.createElement('input');
        deliveryfeeInput.type = 'hidden';
        deliveryfeeInput.name = 'deliveryfee';
        deliveryfeeInput.value = deliveryCharge;
        form.appendChild(deliveryfeeInput);
        
        var sizeInput = document.createElement('input');
        sizeInput.type = 'hidden';
        sizeInput.name = 'size';
        sizeInput.value = sizeList.join(',');
        form.appendChild(sizeInput);

        var quantityInput = document.createElement('input');
        quantityInput.type = 'hidden';
        quantityInput.name = 'quantity';
        quantityInput.value = quantityList.join(',');
        form.appendChild(quantityInput);

        var priceInput = document.createElement('input');
        priceInput.type = 'hidden';
        priceInput.name = 'price';
        priceInput.value = priceList.join(',');
        form.appendChild(priceInput);

        var totalPriceInput = document.createElement('input');
        totalPriceInput.type = 'hidden';
        totalPriceInput.name = 'totalPrice';
        totalPriceInput.value = totalPriceList.join(',');
        form.appendChild(totalPriceInput);

        document.body.appendChild(form);
        var width = 1200;
        var height = 900;
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;
        window.open('', "cartPaymentPopup", "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ",scrollbars=yes");
        form.submit();
    }
 	
 	// 숨겨진 입력 필드 생성
    function createHiddenInput(name, value) {
        var input = document.createElement('input');
        input.type = 'hidden';
        input.name = name;
        input.value = value;
        return input;
    }
</script>

<%@ include file="../footer.jsp" %>