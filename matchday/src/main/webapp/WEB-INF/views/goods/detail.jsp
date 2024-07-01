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
	        text-align: center;
	        margin: 0 10px;
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
		    border: 1px solid #ccc;
		    border-radius: 4px;
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
		}
		
		.info-tab li a {
		    display: block;
		    padding: 10px 15px;
		    text-decoration: none;
		    color: #333;
		    font-weight: bold;
		    border: 1px solid transparent;
		    border-radius: 4px 4px 0 0;
		    transition: background-color 0.3s ease, color 0.3s ease, border-color 0.3s ease; /* Added transition */
		}
		
		.info-tab li a:hover {
		    background-color: #007bff;
		    color: #fff;
		    border-color: #007bff;
		}
		
		#content {
		    padding: 20px;
		    box-sizing: border-box;
		    border: 1px solid #ccc;
		    border-top: none;
		    border-radius: 0 0 4px 4px;
		    background-color: #fff;
		}
    
  </style>
<!-- 본문 시작 main.jsp -->

<body>
    <div class="container">
        <c:if test="${not empty goods}">
            <div class="product-section"> <!-- 사진+글 -->
                <div class="product-image">
                    <c:if test="${not empty goods.filename}">
                        <img src="${pageContext.request.contextPath}/storage/${goods.filename}" alt="${goods.productname}" />
                    </c:if>                  
                </div>
                
                <div class="product-info"> <!-- 글 -->
                    <div class="product-title">${goods.productname}</div>
                    	
                    <div class="product-price">
                        <fmt:formatNumber value="${goods.price}" pattern="#,###원"/>
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
						       <%--  <option value="S" <c:if test="${goods.size == 'S'}"></c:if>>S</option>
						        <option value="M" <c:if test="${goods.size == 'M'}"></c:if>>M</option>
						        <option value="L" <c:if test="${goods.size == 'L'}"></c:if>>L</option>
						        <option value="XL" <c:if test="${goods.size == 'XL'}"></c:if>>XL</option> --%>     
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
                                    <input type="text" id="quantity-input" name="quantity" value="1" />
                                    <button type="button" onclick="updateQuantity(1)">+</button>
                                </div>
                            </dd>

                            <dt>재고 수량</dt>
                            <dd>${goods.stockquantity}개</dd>
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
                    	<button>구매하기</button>
                        <button>장바구니에 추가</button>
                    </div>
                    
                    <!-- 관리자용 상품 수정, 상품 삭제 -->
                    <br>
                    <form name="goodsfrm" method="post" enctype="multipart/form-data">
		                <input type="hidden" name="goodsid" value="${goodsid}">
			            <input type="submit" value="상품수정" onclick="goods_update()">
			            <input type="button" value="상품삭제" onclick="goods_delete()">
	                </form>
	                    	
                </div> <!-- 글 -->
            </div> <!-- 사진+글 -->
            
            <div class="info-container"> <!-- 상세보기 -->

	            <ul class="info-tab"> <!-- 상세보기 탭 -->
	            	<li class="on" data-tab="info01">
	            		<a href="#" onclick="loadContent('detail')">상세정보</a>
	            	</li>
	            	<li data-tab="info02">
	            		<a href="#" onclick="loadContent('notice')">상품 주의사항</a>
					</li>
	            	<li data-tab="info03">
	            		<a href="#" onclick="loadContent('delivery')">배송/반품/교환</a>
	            	</li>
	            	<li data-tab="info04">
				       	<a href="#" onclick="loadContent('review')">구매후기</a>
				    </li>
	            </ul> <!-- 상세보기 탭 -->
	            
	            <div id="inf-content"> <!-- 상세보기 내용 -->
				    	<div id="info01" class="tabcont on">
				    	(설명)
                            ${goods.description}
				    	
				    	</div>
				    	<div id="info02" class="tabcont">
				    	2
				    	</div>
				    	<div id="info03" class="tabcont">
				    	3
				    	</div>
				    	<div id="info04" class="tabcont">
				    	4
				    	</div>
				</div> <!-- 상세보기 내용 -->
				
            </div> <!-- 상세보기 -->

        </c:if>
    </div>
    
</body>
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
	
	function updateTotalPrice() {
        var quantity = parseInt(document.getElementById('quantity-input').value);
        var price = ${goods.price};
        var totalPrice = quantity * price;

        document.getElementById('order-quantity').innerText = quantity;
        document.getElementById('total-price').innerText = totalPrice.toLocaleString();
    }
	
	// 초기 로드 시 총 상품 금액 계산
    document.addEventListener('DOMContentLoaded', function() {
        updateTotalPrice();
    });

    function loadContent(tab) { //상세보기
        $.ajax({
            url: 'https://www.fcseoul.com/fcshop/productView',
            method: 'GET',
            data: { menu_b: 'UNI', goods_id: 'PT3FS24M021', tab: tab },
            success: function(response) {
                var content;

                if (tab === 'detail') {
                    content = $(response).find('.detail-content').html();
                } else if (tab === 'notice') {
                    content = $(response).find('.notice-content').html();
                } else if (tab === 'delivery') {
                    content = $(response).find('.delivery-content').html();
                } else if (tab === 'review') {
                    content = $(response).find('.review-content').html(); // Adjust with actual selector for reviews
                }
                
                $('#content').html(content);
            },
            error: function() {
                alert('Failed to load content.');
            }
        });
    }

    function goods_update(){
        // document.goodsfrm refers to the <form name="goodsfrm"> in the HTML
        document.goodsfrm.action = "/goods/update";
        document.goodsfrm.submit();
    } // goods_update() end

    function goods_delete(){
        if(confirm("상품은 영구히 삭제됩니다\n진행할까요?")){
            document.goodsfrm.action = "/goods/delete";
            document.goodsfrm.submit();
        } // if end
    } // goods_delete() end

 

</script>

<%@ include file="../footer.jsp" %>