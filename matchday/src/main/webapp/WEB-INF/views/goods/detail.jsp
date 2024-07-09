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
		
		
		/* 구매하기 */
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
        
        /* 장바구니에 추가 버튼 */
        .product-action-btn {
		    padding: 10px 20px;
		    font-size: 16px;
		    background-color: #007bff; /* Blue color for button */
		    color: #fff;
		    border: none;
		    cursor: pointer;
		    border-radius: 4px;
		    margin-left: 10px; /* Optional: Add margin to separate buttons */
		}
		
		.product-action-btn:hover {
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
.review {
    font-family: Arial, sans-serif;
    background-color: #f9f9f9;
    padding: 20px;
}

.review-tabs {
    display: flex;
    justify-content: flex-start;
    margin-bottom: 20px;
}

.tab-button {
    background-color: #f1f1f1;
    border: 1px solid #ddd;
    padding: 10px 20px;
    cursor: pointer;
    margin-right: 10px;
    border-radius: 5px;
    font-size: 16px;
}

.tab-button.active {
    background-color: #fff;
    border-bottom: 2px solid #007bff;
    color: #007bff;
}

.tab-content {
    background-color: #fff;
    border: 1px solid #ddd;
    padding: 20px;
    border-radius: 10px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

.review-list {
    margin-top: 20px;
}

.review-summary {
    display: flex;
    justify-content: space-between;
    align-items: center;
    background-color: #f1f1f1;
    padding: 10px;
    border-radius: 5px;
    cursor: pointer;
    margin-bottom: 10px;
}

.review-summary:hover {
    background-color: #e1e1e1;
}

.review-rating, .review-title, .review-author, .review-date {
    flex: 1;
    text-align: center;
}

.review-details {
    display: none;
    padding: 10px;
    border: 1px solid #ddd;
    border-radius: 5px;
    background-color: #fff;
    margin-bottom: 10px;
}

.review-content {
    margin-bottom: 10px;
}

.review-image {
    max-width: 100%;
    height: auto;
    margin-bottom: 10px;
}

.review-comments {
    margin-top: 10px;
}

.comment {
    background-color: #f9f9f9;
    
  </style>
<!-- 본문 시작 goods/detail.jsp -->

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
                                    <option value="FREE">FREE ${goodsDto.stockquantity}개</option>
                                    <option value="S">S ${goodsDto.stockquantity}개</option>
                                    <option value="M">M ${goodsDto.stockquantity}개</option>
                                    <option value="L">L ${goodsDto.stockquantity}개</option>
                                    <option value="XL">XL ${goodsDto.stockquantity}개</option>
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
	                    	<dd><span id="order-quantity">1</span></dd>
	                    	<dt>총 상품 금액</dt>
	                    	<dd><span id="total-price"></span></dd>
                    	</dl>
                    </div>
                    
                    <div class="product-action">
					    <button onclick="purchase()">구매하기</button>
					    <input type="button" value="장바구니에 추가" onclick="addToCart()" class="product-action-btn">
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
					</div>
					<form id="addToCartForm" method="post" action="${pageContext.request.contextPath}/cart/insert">
						<input type="hidden" name="userid" value="${sessionScope.userID}">
						<input type="hidden" name="goodsid" value="${goodsDto.goodsid}">
						<input type="hidden" name="quantity" id="form-quantity" value="">
						<input type="hidden" name="unitprice" id="form-unitprice">
						<input type="hidden" name="totalprice" id="form-totalprice">
					</form>

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
			        <li data-tab="info04" onclick="loadContent('info04')"><!-- <a class="nav-link" href="/review/list"> -->리뷰</a></li>
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
				    	<div id="info04" class="tabcont"> <!-- 리뷰 내용 -->
				    		<!-- <div class="reviews_cont">
					            <h3>상품후기</h3>
					            
					            <div class="btn_reviews_box">
					                <a href="../board/list.php?bdId=goodsreview" class="btn_reviews_more">상품후기 전체보기</a>
					                <a href="javascript:gd_open_write_popup('goodsreview', '1000000296')" class="btn_reviews_write">상품후기 글쓰기</a>
					            </div>
					            btn_reviews_box
					            <div>
					            	리뷰리스트
					            </div> -->
					            
					            <div class="review">
    <div class="review-tabs">
        <button class="tab-button active" onclick="showTab('review')">상품후기</button>
        <button class="tab-button" onclick="showTab('all-reviews')">상품전체보기(리뷰리스트로 이동?)</button>
        <button class="tab-button" onclick="openPopup('/review/write?goodsid=${goodsDto.goodsid}')">상품 글쓰기</button>
    </div>

    <div id="review" class="tab-content">
        <div class="review-list">
            <div class="review-summary" onclick="toggleReviewDetails('review1')">
                <div class="review-rating">★★★★☆</div>
                <div class="review-title">좋은 상품입니다</div>
                <div class="review-author">사용자 이름</div>
                <div class="review-date">2024-07-09</div>
            </div>
            <div id="review1" class="review-details">
                <div class="review-content">
                    여기에 사용자의 후기가 들어갑니다. 상품이 정말 좋습니다!
                </div>
                <img src="path_to_image.jpg" alt="Review Image" class="review-image">
                <div class="review-comments">
                    <div class="comment">댓글 1: 정말 좋은 리뷰네요!</div>
                    <div class="comment">댓글 2: 저도 같은 경험을 했습니다.</div>
                </div>
            </div>

            <div class="review-summary" onclick="toggleReviewDetails('review2')">
                <div class="review-rating">★★★☆☆</div>
                <div class="review-title">보통입니다</div>
                <div class="review-author">다른 사용자</div>
                <div class="review-date">2024-07-08</div>
            </div>
            <div id="review2" class="review-details">
                <div class="review-content">
                    상품이 보통입니다.
                </div>
                <img src="path_to_image2.jpg" alt="Review Image" class="review-image">
                <div class="review-comments">
                    <div class="comment">댓글 1: 동의합니다.</div>
                </div>
            </div>
        </div>
    </div>

    <div id="all-reviews" class="tab-content" style="display: none;">
        상품 전체 보기 내용
    </div>

    <div id="write-review" class="tab-content" style="display: none;">
        상품 글쓰기 내용
    </div>
    </div>
					            
					        </div> <!-- 리뷰 내용 -->
				    	</div> <!-- 상세보기 내용 -->
				
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
	    updateTotalPrice(); // 총 가격 업데이트
	}
	
	// 총 가격 업데이트 함수
	function updateTotalPrice() { 
        var quantity = parseInt(document.getElementById('quantity-input').value);
        var price = ${goodsDto.price};
        var totalPrice = quantity * price;

     	// 업데이트된 값들을 화면에 표시합니다
        document.getElementById('order-quantity').innerText = quantity + '개';
        document.getElementById('total-price').innerText = totalPrice.toLocaleString() + '원';

        // 숨겨진 입력 필드를 업데이트합니다
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
            console.error('loadContent 함수에서 오류 발생:', error);
            alert('콘텐츠를 로드하는 데 실패했습니다. 나중에 다시 시도해주세요.');
        }
    }

    function purchase() {
        // 구매하기 버튼을 눌렀을 때 수행할 동작
        // 예를 들어, Ajax를 사용하여 서버로 상품 추가 요청을 보낼 수 있습니다.
        alert('상품을 구매합니다.');
    }

    // 장바구니에 추가 버튼 클릭 시 모달 열기
    function addToCart() {
	    // 수량 입력 요소 확인
	    var quantityInput = document.getElementById('quantity-input');
	    if (!quantityInput) {
	        console.error('수량 입력 요소를 찾을 수 없습니다');
	        return;
	    }
	 	// 수량 값 가져오기
	    var quantity = parseInt(quantityInput.value); // 수량을 정수로 변환
	
	    // 총 가격 요소 확인
	    var totalPriceElement = document.getElementById('total-price');
	    if (!totalPriceElement) {
	        console.error('총 가격 요소를 찾을 수 없습니다');
	        return;
	    }
	
	    var totalPriceText = totalPriceElement.innerText;
	    var totalPrice = parseInt(totalPriceText.replace(/[^0-9]/g, '')); // 숫자 이외의 문자 제거 후 정수로 변환
	    /* var totalPrice = parseInt(totalPriceText.replace(/,/g, '')); // 쉼표 제거 후 정수로 변환 */
	
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

	 	// 모달 창 띄우기
	    showCartModal();
	}// addToCart() end
    
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
    	document.getElementById('addToCartForm').submit(); // 폼 제출 후 장바구니 목록 페이지 URL로 이동
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

    //상품 리뷰
    function showTab(tabId) {
        var tabs = document.getElementsByClassName('tab-content');
        for (var i = 0; i < tabs.length; i++) {
            tabs[i].style.display = 'none';
        }
        document.getElementById(tabId).style.display = 'block';

        var buttons = document.getElementsByClassName('tab-button');
        for (var i = 0; i < buttons.length; i++) {
            buttons[i].classList.remove('active');
        }
        event.currentTarget.classList.add('active');
    }

    function toggleReviewDetails(reviewId) {
        var details = document.getElementById(reviewId);
        if (details.style.display === 'none' || details.style.display === '') {
            details.style.display = 'block';
        } else {
            details.style.display = 'none';
        }
    }
    
    function openPopup(url) { // 상품 글쓰기
    	var width = 1000;
        var height = 900;

        // 화면의 중앙에 위치시키기 위한 좌표 계산
        var left = (screen.width - width) / 2;
        var top = (screen.height - height) / 2;

        // 창을 중앙에 띄우기
        window.open(url, "popupWindow", "width=" + width + ",height=" + height + ",left=" + left + ",top=" + top + ",scrollbars=yes");
    }// openPopup(url) end
    
    
    
    
</script>

<%@ include file="../footer.jsp" %>