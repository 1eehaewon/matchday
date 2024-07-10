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
    
  </style>
<!-- 본문 시작 detail.jsp -->

    <div class="container">
        <c:if test="${not empty goodsDto}">
            <div class="product-section"> <!-- 사진+글 -->
                <div class="product-image">
                    <c:if test="${not empty goodsDto.filename}"> <!-- 메인 이미지 -->
                        <img src="${pageContext.request.contextPath}/storage/${goodsDto.filename}" alt="${goodsDto.productname}" />
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
                    	<button>구매하기</button>
                        <button>장바구니에 추가</button>
                    </div>
                    
                    <!-- 관리자용 상품 수정, 상품 삭제 -->
                    <br>
                    <form name="goodsfrm" method="post">
		                <input type="hidden" name="goodsid" value="${goodsDto.goodsid}">
			            <input type="button" value="상품수정" onclick="goods_update()">
			            <input type="button" value="상품삭제" onclick="goods_delete()">
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
				    	상세보기 내용
                            ${goodsDto.description}
				    	
				    	</div>
				    	<div id="info02" class="tabcont"> <!-- 상품 주의사항 내용 -->
				    	상품 주의사항 내용
				    	
				    	현장 수령 장소
						홈경기일 : 북측광장 FC서울 현장수령처
						** 현장수령은 홈경기일에 북측광장 현장수령처에서 수령 가능합니다 (비경기일 수령불가)
						
						
						
						* 현장수령 상품의 경우 '상품준비완료' 상태에서만 수령이 가능합니다. 
						
						(결제완료 또는 PRE오더1 상태일 시 수령불가)
						
						 
						
						FC서울 팬파크 운영시간
						
						평일) 10:00 ~ 20:00
						
						주말, 공휴일) 10:00 ~ 20:00
						
						
						
						FC서울 팬파크 고객센터
						
						070-4101-7710
						
						
						
						평일) 10:00 ~ 18:00
						
						
						
						 * 주말 및 공휴일, 홈경기일은 고객센터를 운영하지 않습니다.
				    	</div>
				    	<div id="info03" class="tabcont"> <!-- 배송/반품/교환 내용 -->
				    	배송/반품/교환 내용
				    	
				    	배송 안내
						방법
						CJ대한통운
						배송 지역
						전국 배송
						배송비
						10만원 이상 구매 시 무료배송
						
						※ 제주도를 포함한 도서, 산간지역은 배송비(항공료 또는 도선료) 3,500원이 추가되며 착불로 발송
						기간
						결제 후 2~5일 이내에 배송 완료
						반품/교환 안내
						반품/교환
						구입 후 7일 이내에 동일 제품으로 교환 가능하며 운송비는 구매자 부담
						
						주문제작 유니폼이나, 공동구매 제작상품, 마킹된 유니폼의 경우 소량 제작된 상품의 특성상 제품에 이상이 있을 시를 제외하고 교환 및 환불 불가
						
						다른 제품으로 교환, 또는 이상이 없는 제품과 함께 교환하실 경우 운송비는 구매자 부담
						
						착불 배송비 초과금액(3,500원) 발생시 초과된 금액은 구매자 부담
						
						선불 배송 또는 3500원을 동봉하여 착불로 배송 (운송사 : CJ대한통운 택배 이용)
						
						반품/교환 주소 : 서울시 마포구 월드컵로 240 월드컵경기장역 2번 출구 앞 FC서울 팬파크 (TEL 070-4101-7710)
						제품에 이상이 있을 경우
						색상, 사이즈, 다른 상품 교환
						
						구입후 7일이내 교환 가능하며 운송비는 구매자 부담
						주의사항
						비닐포장 및 Tag 폐기 또는 훼손 등으로 상품 가치가 멸실된 경우, 제한 반품 시에 해당 사은품이 있을 경우 같이 배송
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

        document.getElementById('order-quantity').innerText = quantity;
        document.getElementById('total-price').innerText = totalPrice.toLocaleString();
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