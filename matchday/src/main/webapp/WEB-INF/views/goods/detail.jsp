<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

 <style>
		.container {
            max-width: 1500px;
            margin: 20px auto;
            padding: 0 15px;
        }

        .product-section {
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            margin-bottom: 30px;
            padding: 20px;
        }

        .product-image {
            flex: 1;
            text-align: center;
        }

        .product-image img {
            max-width: 100%;
            height: auto;
            margin-bottom: 20px;
            border: 1px solid #ccc;
            border-radius: 4px;
        }

        .product-info {
            flex: 2;
            padding: 0 20px;
        }

        .product-title {
            font-size: 24px;
            font-weight: bold;
            margin-bottom: 10px;
        }

        .product-price {
            font-size: 20px;
            color: #f00; /* Red color for price */
            margin-bottom: 10px;
        }

        .product-description {
            line-height: 1.6;
        }
		
		.product-description dl {
	        display: flex;
	        flex-wrap: wrap;
	        margin: 0;
		    padding: 0;
	    }
	
	    .product-description dt {
		    flex: 1 0 15%; /* dt 요소의 넓이를 작게 설정 */
		    font-weight: bold; /* dt 요소에 글자 굵기 적용 */
		    margin-bottom: 5px; /* dt 요소 사이의 간격 설정 */
		}
		
		.product-description dd {
		    flex: 2 0 85%; /* dd 요소의 넓이를 크게 설정 */
		    margin-bottom: 10px; /* dd 요소 사이의 간격 설정 */
		}
	    
	
	    .product-description dt {
	        font-weight: bold;
	    }
		
		
		/* 주문 수량 */
	    .quantity-control {
	        display: flex;
	        align-items: center;
	    }
	
	    .quantity-control button {
	        padding: 5px 15px;
	        font-size: 20px;
	        background-color: #007bff; /* Blue color for button */
	        color: #fff;
	        border: none;
	        cursor: pointer;
	        border-radius: 4px;
	    }
	
	    .quantity-control button:hover {
	        background-color: #0056b3; /* Darker blue on hover */
	    }
	
	    .quantity-control input {
	        width: 50px;
	        height: 45px;
	        text-align: center;
	        margin: 0 5px;
	        padding: 5px;
	        border: 1px solid #ccc;
	        border-radius: 4px;
	    }
		
		
		/* 구매하기 장바구니 */
        .product-action {
            margin-top: 20px;
        }

        .product-action button {
            padding: 10px 20px;
            font-size: 16px;
            background-color: #007bff; /* Blue color for button */
            color: #fff;
            border: none;
            cursor: pointer;
            border-radius: 4px;
        }

        .product-action button:hover {
            background-color: #0056b3; /* Darker blue on hover */
        }
        
        /* 상세보기 */
        .info-container {
		    
		    background-color: #fff;
		    padding: 20px;
		    margin-top: 20px;
		}
		
        /* 상세보기 탭 */
        .info-tab {
		    display: flex;
		    list-style-type: none;
		    padding: 0;
		    margin: 0;	
		}
		
		.info-tab li {
		    flex: 1;
		    text-align: center;
		    cursor: pointer;
	        padding: 10px 15px;
	        background-color: #f0f0f0;
	        border-top-left-radius: 4px;
	        border-top-right-radius: 4px;
	        transition: background-color 0.3s ease;
		}
		
		.info-tab li.on {
	        background-color: #007bff;
	        color: #fff;
	    }

	    .info-tab li:hover {
	        background-color: #ccc;
	    }
	
	    #info-content {
	        border: 1px solid #ccc;
	        border-top: none;
	        padding: 20px;
	        border-radius: 0 0 4px 4px;
	        background-color: #fff;
	    }
	
	    .tabcont {
	        display: none;
	    }
	
	    .tabcont.on {
	        display: block;
	    }
    
    /* 장바구니 모달 */
	.modal {
	    display: none; /* 기본적으로 숨기기 */
	    position: fixed; /* 위치 고정 */
	    z-index: 1; /* 가장 위에 위치 */
	    left: 0;
	    top: 0;
	    width: 100%; /* 전체 너비 */
	    height: 100%; /* 전체 높이 */
	    overflow: auto; /* 스크롤 필요 시 활성화 */
	    background-color: rgba(0, 0, 0, 0.4); /* 불투명 검정색 배경 */
	}
	
	.modal-content {
	    background-color: #fff;
	    margin: 15% auto; /* 상단에서 15%, 가운데 정렬 */
	    padding: 20px;
	    border: 1px solid #888;
	    width: 40%; /* 화면 크기에 따라 조절 가능 */
	    border-radius: 4px;
	    text-align: center;
	}
	
	.close {
	    color: #aaa;
	    float: right;
	    font-size: 30px;
	    font-weight: bold;
	}
	
	.close:hover,
	.close:focus {
	    color: black;
	    text-decoration: none;
	    cursor: pointer;
	}
	
	.modal-actions button {
	    padding: 10px 20px;
	    font-size: 16px;
	    margin: 10px;
	    border: none;
	    cursor: pointer;
	    border-radius: 4px;
	    background-color: #007bff; /* 버튼 색상: 파란색 */
	    color: #fff;
	}
	
	.modal-actions button:hover {
	    background-color: #0056b3; /* 호버 시 어두운 파란색 */
	}

    
  </style>
<!-- 본문 시작 detail.jsp -->

    <div class="container">
        <c:if test="${not empty goodsDto}">
            <div class="product-section"> <!-- 사진+글 -->
                <div class="product-image">
                    <c:if test="${not empty goodsDto.filename}"> <!-- 메인 이미지 -->
                        <img src="${pageContext.request.contextPath}/storage/goods/${goodsDto.filename}" alt="${goodsDto.productname}" />
                    </c:if>                  
                </div>
                
                <div class="product-info"> <!-- 글 -->
                    <div class="product-title">${goodsDto.productname}</div>
                    	
                    <div class="product-price">
                        <fmt:formatNumber value="${goodsDto.price}" pattern="#,###원"/>
                    </div>
                    
                    <div class="product-description">
                        <dl>
                            
                            <dt>사이즈</dt>
                            <dd>
                                <select name="size">
                                    <option value="">선택하세요.</option>
                                    <option value="S">S</option>
                                    <option value="M">M</option>
                                    <option value="L">L</option>
                                    <option value="XL">XL</option>
						    </select>
                            </dd>

                            <dt>배송비</dt>
                            <dd>
                                3,500원 (100,000원 이상 구매시 무료) 
                                <br>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;제주 및 도서 산간 3,000원 추가
                            </dd>

                            <dt>주문 수량</dt>
                            <dd>
                                <div class="quantity-control">
                                    <button type="button" onclick="updateQuantity(-1)">-</button>
                                    <input type="text" id="quantity-input" name="quantity" value="1" readonly/>
                                    <button type="button" onclick="updateQuantity(1)">+</button>
                                </div>
                            </dd>

                           <%--  <dt>재고 수량</dt>
                            <dd>${goodsDto.stockquantity}개</dd> --%>
                        </dl>
                    </div>
                    <hr>
                    
                    <div class="product-description">
                    	<dl>
	                    	<dt>총 주문 수량</dt>
	                    	<dd><span id="order-quantity">1</span>개</dd>
	                    	<dt>총 상품 금액</dt>
	                    	<dd><span id="total-price"></span>원</dd>
                    	</dl>
                    </div>
                    
                    <div class="product-action">
					    <button onclick="purchase()">구매하기</button>
					    <input type="button" value="장바구니에 추가" onclick="addToCart()" class="btn btn-info">
					</div>
					<!-- 장바구니 모달창 -->
					<div id="cartModal" class="modal">
					    <div class="modal-content">
					        <span class="close">&times;</span>
					        <p>장바구니에 추가 하였습니다.</p>
					        <p>쇼핑을 계속 하시겠습니까?</p>
					        <div class="modal-actions">
					            <button onclick="continueShopping()">쇼핑 계속하기</button>
					            <button onclick="goToCart()">장바구니로 이동</button>
					        </div>
					    </div>
					</div><form id="addToCartForm" method="post" action="${pageContext.request.contextPath}/cart/insert">
    <p>현재 로그인된 사용자: ${sessionScope.userID}</p>
    <input  name="userid" value="${sessionScope.userID}">
    <input name="goodsid" value="${goodsDto.goodsid}">
    <input  name="quantity" id="form-quantity" value="">
    <input  name="unitprice" id="form-unitprice">
    <input  name="totalprice" id="form-totalprice">
</form>
					
                    
                    <%-- <div class="product-action">
					    <button onclick="addToCart()">구매하기</button>
					    <!--
					    <form action="/carts/list" method="get" style="display: inline;">
					        <button type="submit">장바구니에 추가</button>
					    </form>
					    -->
					    <form onsubmit="${pageContext.request.contextPath}/cart/list/insert" method="get" style="display: inline;">
						    <input type="hidden" name="userID" value="${userID}">
						    <button type="submit">장바구니에 추가</button>
						</form>
					    <input type="button" value="장바구니에 추가" onclick="goToCart()" class="btn btn-info">
					</div>
 --%>
                    <!-- 관리자용 상품 수정, 상품 삭제 -->
                    <br>
                    <form name="goodsfrm" method="post">
						<c:if test="${sessionScope.grade == 'M'}">
		                     <input type="hidden" name="goodsid" value="${goodsDto.goodsid}">
		                     <input type="button" value="상품수정" onclick="goods_update()" class="btn btn-success">
		                     <input type="button" value="상품삭제" onclick="goods_delete()" class="btn btn-danger">
						</c:if>
                   </form>
	                    	
                </div> <!-- 글 -->
            </div> <!-- 사진+글 -->
            
            <div class="info-container"> <!-- 상세보기 -->
	            <ul class="info-tab"> <!-- 상세보기 탭 -->
			        <li class="on" data-tab="info01" onclick="loadContent('info01')">상세정보</li>
			        <li data-tab="info02" onclick="loadContent('info02')">상품 주의사항</li>
			        <li data-tab="info03" onclick="loadContent('info03')">배송/반품/교환</li>
			        <li data-tab="info04" onclick="loadContent('info04')">구매후기</li>
			    </ul> <!-- 상세보기 탭 -->
	            
	            <div id="info-content"> <!-- 상세보기 내용 -->
				    	<div id="info01" class="tabcont on"> <!-- 상세정보 내용 -->
                            ${goodsDto.description}
				    	</div>
				    	<div id="info02" class="tabcont"> <!-- 상품 주의사항 내용 -->
							${goodsDto.caution}
				    	</div>
				    	<div id="info03" class="tabcont"> <!-- 배송/반품/교환 내용 -->
				   			${goodsDto.deliveryreturnsexchangesinfo}	    	
				   		</div>
				    	<div id="info04" class="tabcont"> <!-- 구매후기 내용 -->
				    	구매후기 내용
				    	</div>
				</div> <!-- 상세보기 내용 -->
				
            </div> <!-- 상세보기 -->

        </c:if>
    </div>
    

<!-- 본문 끝 -->

<script>
	function updateQuantity(change) { // 주문수량
	    var input = document.getElementById('quantity-input');
	    var currentValue = parseInt(input.value);
	    var newValue = currentValue + change;
	    
	    if (newValue < 1) {
	        newValue = 1; // 최소 수량은 1로 설정
	    }
	    
	    input.value = newValue;
	    updateTotalPrice();
	}
	
	// 총 가격 업데이트 함수
	function updateTotalPrice() { 
        var quantity = parseInt(document.getElementById('quantity-input').value);
        var price = ${goodsDto.price};
        var totalPrice = quantity * price;

     // Display updated values
        document.getElementById('order-quantity').innerText = quantity + '개';
        document.getElementById('total-price').innerText = totalPrice.toLocaleString() + '원';

        // Update hidden input fields
        document.getElementById('form-quantity').value = quantity;
        document.getElementById('form-unitprice').value = price;
        document.getElementById('form-totalprice').value = totalPrice;
    }
	
	// 초기 로드 시 총 상품 금액 계산
    document.addEventListener('DOMContentLoaded', function() {
        updateTotalPrice();
    });

    function loadContent(tabId) {//상세보기
        try {
            // 모든 탭 콘텐츠 숨기기
            var tabContents = document.querySelectorAll('.tabcont');
            tabContents.forEach(function(content) {
                content.style.display = 'none'; // 모든 탭 숨기기
            });

            // 클릭된 탭 콘텐츠 보이기
            var selectedTabContent = document.getElementById(tabId);
            selectedTabContent.style.display = 'block'; // 클릭된 탭 보이기

            // 모든 탭 메뉴에서 활성화 클래스 제거
            var tabMenuItems = document.querySelectorAll('.info-tab li');
            tabMenuItems.forEach(function(item) {
                item.classList.remove('on');
            });

            // 클릭된 탭 메뉴에 활성화 클래스 추가
            var selectedTabMenuItem = document.querySelector('.info-tab li[data-tab="' + tabId + '"]');
            selectedTabMenuItem.classList.add('on');
        } catch (error) {
            console.error('Error in loadContent function:', error);
            alert('Failed to load content. Please try again later.');
        }
    }

    function purchase() {
        // 구매하기 버튼을 눌렀을 때 수행할 동작
        // 예를 들어, Ajax를 사용하여 서버로 상품 추가 요청을 보낼 수 있습니다.
        alert('상품을 구매합니다.');
    }

    
 	// 장바구니 모달 가져오기
    var modal = document.getElementById("cartModal");
    // <span> 요소를 가져와서 모달을 닫기
    var span = document.getElementsByClassName("close")[0];
    // 사용자가 버튼을 클릭하면 모달 열기
    function showCartModal() {
        modal.style.display = "block";
    }
    // 사용자가 <span> (x)을 클릭하면 모달 닫기
    span.onclick = function() {
        modal.style.display = "none";
    }
    // 사용자가 모달 밖을 클릭하면 모달 닫기
    window.onclick = function(event) {
        if (event.target == modal) {
            modal.style.display = "none";
        }
    }
    // 쇼핑 계속하기 버튼 클릭 시 동작
    function continueShopping() {
        modal.style.display = "none";
        window.location.href = '/goods/list'; // 쇼핑 계속하기 페이지 URL로 이동
    }
    // 장바구니로 이동 버튼 클릭 시 동작
    function goToCart() {
        window.location.href = '/cart/list'; // 장바구니 목록 페이지 URL로 이동
    }
    // 장바구니에 추가 버튼 클릭 시 모달 열기
    function addToCart() {
    	showCartModal();
    // 수량 입력 요소 확인
    var quantityInput = document.getElementById('quantity-input');
    if (!quantityInput) {
        console.error('수량 입력 요소를 찾을 수 없습니다');
        return;
    }

    var quantity = parseInt(quantityInput.value); // 수량을 정수로 변환

    // 총 가격 요소 확인
    var totalPriceElement = document.getElementById('total-price');
    if (!totalPriceElement) {
        console.error('총 가격 요소를 찾을 수 없습니다');
        return;
    }

    var totalPriceText = totalPriceElement.innerText;
    var totalPrice = parseInt(totalPriceText.replace(/,/g, '')); // 쉼표 제거 후 정수로 변환

    // formQuantity 입력 요소 확인
    var formQuantity = document.getElementById('form-quantity');
    if (!formQuantity) {
        console.error('장바구니 수량 입력 필드를 찾을 수 없습니다');
        return;
    }

    // formTotalPrice 입력 요소 확인
    var formTotalPrice = document.getElementById('form-totalprice');
    if (!formTotalPrice) {
        console.error('장바구니 총 가격 입력 필드를 찾을 수 없습니다');
        return;
    }

	// 세션 스코프에서 userid 가져오기
    var userId = '${sessionScope.userID}';
    console.log('사용자 아이디:', userId);
    
    // 폼 필드에 값 설정
    formQuantity.value = quantity;
    formTotalPrice.value = totalPrice;

    // 디버깅을 위한 콘솔 출력
    console.log('수량:', quantity);
    console.log('총 가격:', totalPrice);

    // 폼 제출
    document.getElementById('addToCartForm').submit();
}


    
    
 	// 상품 수정 함수
    function goods_update(){
        document.goodsfrm.action = "/goods/updateform";
        document.goodsfrm.submit();
    } // goods_update() end

 	// 상품 삭제 함수
    function goods_delete(){
        if(confirm("상품은 영구히 삭제됩니다\n진행할까요?")){
            document.goodsfrm.action = "/goods/delete";
            document.goodsfrm.submit();
        } // if end
    } // goods_delete() end

    
 

   



</script>

<%@ include file="../footer.jsp" %>