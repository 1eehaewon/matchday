<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<%@ include file="../header.jsp"%>

<style>
	.carousel-control-prev, .carousel-control-next {
		position: absolute;
		top: 50%;
		transform: translateY(-50%);
		width: 5%;
		z-index: 1; /* 제어 버튼이 이미지 위에 오도록 */
	}
	
	.carousel-control-prev {
		left: 200px; /* 버튼이 좌측에서 10px 떨어져 위치 */
	}
	
	.carousel-control-next {
		right: 200px; /* 버튼이 우측에서 10px 떨어져 위치 */
	}
	
	.carousel-item img {
		width: 100%;
		height: auto;
	}
	
	.carousel-indicators {
		display: none;
	}
	
	/* 왼쪽 카테고리 + 오른쪽 상품들 */  
	.shop-container {
		display: flex;
		/* height: calc(100vh - 400px); /* 최대 높이 설정 */ */
		overflow: hidden; /* 넘치는 부분 숨김 */
	}
	
	.left {
		flex: 0.4; /* 왼쪽 섹션을 더 좁게 만듦 */
		border-right: 1px solid #ccc; /* 오른쪽에 1px 실선 추가 */
		padding: 10px; /* 내부 여백 설정 */
		overflow-y: auto; /* 세로로 넘치는 부분을 스크롤 가능하게 설정 */
		background-color: #f8f9fa; /* 연한 회색 배경색 설정 */
	}
	
	.left ul {
	    list-style-type: none; /* 리스트 스타일 타입 없음 */
	    padding: 0; /* 내부 여백 없음 */
	    margin: 0; /* 외부 여백 없음 */
	}
	
	.left li {
	    padding: 15px; /* 내부 여백 설정 */
	    cursor: pointer; /* 커서를 포인터로 변경 */
	    border-bottom: 1px solid #ddd; /* 아래쪽에 1px 실선 추가 */
	    font-weight: bold; /* 카테고리 텍스트를 굵게 설정 */
	    text-align: center; /* 텍스트를 가운데 정렬 */
	    color: #333; /* 짙은 색 텍스트 */
	    transition: background-color 0.3s ease, color 0.3s ease; /* 배경색과 글자색 전환 효과 설정 */
	}
	
	.left li:hover {
		background-color: #f0f0f0;
		color: #007bff; /* 마우스를 올렸을 때 텍스트 색상을 파란색으로 변경 */
	}
	
	.left li.active {
	    background-color: #007bff; /* 활성화된 카테고리의 배경색을 파란색으로 변경 */
	    color: white; /* 활성화된 카테고리의 텍스트 색상을 흰색으로 변경 */
	}
	
	.centered-button { /* 상품등록 */
	    display: flex; /* 플렉스 박스 레이아웃 사용 */
	    justify-content: center; /* 수평 중앙 정렬 */
	    margin: 10px 0; /* 위아래 여백 설정 */
	}
	
	.right {
		flex: 2;
		padding: 30px;
		display: flex;
		flex-wrap: wrap;
		justify-content: center;
		align-items: center;
	}
	
	.item-card {
		margin: 5px;
		text-align: center;
		padding: 10px;
		border: 1px solid #ccc;
		border-radius: 8px;
		cursor: pointer;
		transition: transform 0.3s ease;
	}
	
	.item-card:hover {
		transform: translateY(-5px);
	}
	
	.item-card img {
		max-width: 100%;
		height: 270px;
		margin-bottom: 10px;
		border-radius: 4px;
	}
	
	.item-card p { /* 상품명,가격 */
		font-size: 20px;
	}
	
	.small-image {
		max-width: 100%; /* 최대 너비 */
		height: auto; /* 높이 자동 조정 */
	}
	
	/* 검색 */
	.product-label { /* 검색 앞 글자 */
		font-size: 20px;
		font-weight: bold;
		padding: 10px;
	}
	
	.search-container {
		margin-top: 20px;
		padding: 10px;
	}
	
	.search-container form {
		display: flex;
		justify-content: center;
		align-items: center;
	}
	
	.search-container input[type="text"] {
		padding: 10px;
		margin-right: 10px;
		border: 1px solid #ccc;
		border-radius: 4px;
		width: 300px;
	}
	
	.search-container input[type="submit"] {
		padding: 10px 20px;
		background-color: #007bff; /* 버튼 배경색 */
		color: #fff; /* 버튼 글자색 */
		border: none;
		border-radius: 4px;
		cursor: pointer;
	}
	
	.search-container input[type="submit"]:hover {
		background-color: #0056b3; /* 호버시 배경색 */
	}
	
	/* 드롭다운 */
	.goods-dropdown {
		margin-right: 3%; /* 원하는 여백 값으로 설정 */
		margin-bottom: 10px;
	}
	
	
	
</style>

<!-- 본문 시작 main.jsp -->
<div id="myCarousel" class="carousel slide" data-bs-ride="carousel">
	<!-- Indicators -->
	<ol class="carousel-indicators">
		<li data-bs-target="#myCarousel" data-bs-slide-to="0" class="active"></li>
		<li data-bs-target="#myCarousel" data-bs-slide-to="1"></li>
		<li data-bs-target="#myCarousel" data-bs-slide-to="2"></li>
	</ol>

	<!-- Wrapper for slides -->
	<div class="carousel-inner">
		<div class="carousel-item active">
			<img
				src="https://www.completesports.com/wp-content/uploads/2019/02/UEFA-Champions-League-1200x676.jpg?ezimgfmt=ngcb6/notWebP"
				class="d-block w-100" alt="New York"
				style="width: 1200px; height: 400px;">
		</div>

		<div class="carousel-item">
			<img
				src="https://dimg.donga.com/wps/SPORTS/IMAGE/2023/12/19/122685296.1.jpg"
				class="d-block w-100" alt="" style="width: 1200px; height: 400px;">
			<div class="carousel-caption d-none d-md-block"></div>
		</div>

		<div class="carousel-item">
			<img
				src="https://www.10wallpaper.com/wallpaper/1366x768/1412/Champions_League-2014_High_quality_HD_Wallpaper_1366x768.jpg"
				class="d-block w-100" alt="" style="width: 1200px; height: 400px;">
		</div>
	</div>

	<!-- Left and right controls -->
	<a class="carousel-control-prev" href="#myCarousel" role="button"
		data-bs-slide="prev"> <span class="carousel-control-prev-icon"
		aria-hidden="true"></span> <span class="visually-hidden">Previous</span>
	</a> <a class="carousel-control-next" href="#myCarousel" role="button"
		data-bs-slide="next"> <span class="carousel-control-next-icon"
		aria-hidden="true"></span> <span class="visually-hidden">Next</span>
	</a>
</div>

<!-- 검색 -->
<div class="container texte-center search-container">
	<div class="col-l-20">
		<form method="get" action="search">
			<br> <span class="product-label">상품명</span> 
			<input type="text" name="productname" value="${productname}" size="30"> 
			<input type="submit" value="검색"> <br>
		</form>
	</div>
</div>
<!-- 검색 -->

<div class="goods-dropdown">
    <div class="row justify-content-end">
        <div class="col-auto">
            <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle custom-dropdown-btn" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">기본상품순</button>
                <div class="dropdown-menu dropdown-menu-end custom-dropdown-menu" aria-labelledby="dropdownMenuButton">
                    <a class="dropdown-item" href="#">기본상품순</a> 
                    <a class="dropdown-item" href="#">최신등록순</a> 
                    <a class="dropdown-item" href="#">높은가격순</a> 
                    <a class="dropdown-item" href="#">낮은가격순</a>
                </div>
            </div>
        </div>
    </div>
</div>

<div class="shop-container">
	<div class="left">
		<!-- 왼쪽 카테고리 -->
		<ul>
			<li data-name="전체" data-category="All">전체</li>
			<li data-name="키링" data-category="Keyring">키링</li>
			<li data-name="유니폼" data-category="Uniform">유니폼</li>
			<li data-name="헤어밴드" data-category="Hairband">헤어밴드</li>
			<li data-name="머플러" data-category="Muffler">머플러</li>
			<li data-name="응원봉" data-category="Lightstick">응원봉</li>
		</ul>
		<br>
		<p class="centered-button"> <!-- 관리자용 상품등록 -->
			<button type="button" onclick="location.href='write'" class="btn btn-success">상품등록</button>
		</p>
		<%-- <c:if test="${userGrade == 'M'}">
			<p class="centered-button"> <!-- 관리자용 상품등록 -->
				<button type="button" onclick="location.href='write'" class="btn btn-success">상품등록</button>
			</p>
		</c:if> --%>
	</div>
	<!-- 왼쪽 카테고리 -->

	<div class="right" id="right-container">
		<div class="row">
			<!-- 상품 정보 -->
			<c:forEach items="${list}" var="row" varStatus="vs">
				<div class="col-sm-3 col-md-3">
					<div class="item-card" data-category="${row.category}">
						<c:choose>
							<c:when test="${not empty row.filename && row.filename != '-'}">
								<%--<a href="${pageContext.request.contextPath}/goods/detail/${row.goodsid}"> --%>
								<a href="${pageContext.request.contextPath}/goods/detail?goodsid=${row.goodsid}">
									<img src="${pageContext.request.contextPath}/storage/${row.filename}" class="img-responsive margin" style="width: 1200px"> 
								</a>
							</c:when>
							<c:otherwise>
								<%--<a href="${pageContext.request.contextPath}/goods/detail/${row.goodsid}"> --%>
								<a href="${pageContext.request.contextPath}/goods/detail?goodsid=${row.goodsid}">
									<img src="${pageContext.request.contextPath}/images/default_product_image.jpg" alt="등록된 사진 없음" class="small-image">
								</a>
							</c:otherwise>
						</c:choose>
						<%--<p><a href="${pageContext.request.contextPath}/goods/detail/${row.goodsid}">${row.productname}</a></p>--%>
						<p>
							<a href="${pageContext.request.contextPath}/goods/detail?goodsid=${row.goodsid}">${row.productname}</a>
						</p>
						<p> <fmt:formatNumber value="${row.price}" pattern="#,###원" /> </p>
					</div>
				</div>
				<!-- 행의 4번째 항목인지 확인하여 닫고 새 행을 시작하세요 -->
				<c:if test="${vs.count % 4 == 0}">
					<!-- </div>이전 행 닫기 -->
					<div style="height: 50px;"></div>
					<!-- 행 사이의 공백 -->
					<!-- <div class="row">새 행 시작 -->
				</c:if>
			</c:forEach>
		</div>
		<!-- 상품 정보 -->
	</div>
	<!-- right container end -->
</div>
<!-- shop container end -->

	<!-- 페이지 네이션 -->
    <div class="row">
        <div class="col-12">
            <c:if test="${totalPages > 1}">
                <nav aria-label="Page navigation">
                    <ul class="pagination">
                        <c:if test="${currentPage > 1}">
                            <li>
                                <a href="?page=${currentPage - 1}" aria-label="Previous">
                                    <span aria-hidden="true">&laquo;</span>
                                </a>
                            </li>
                        </c:if>
                        <c:forEach var="i" begin="1" end="${totalPages}">
                            <li class="${i == currentPage ? 'active' : ''}">
                                <a href="?page=${i}">${i}</a>
                            </li>
                        </c:forEach>
                        <c:if test="${currentPage < totalPages}">
                            <li>
                                <a href="?page=${currentPage + 1}" aria-label="Next">
                                    <span aria-hidden="true">&raquo;</span>
                                </a>
                            </li>
                        </c:if>
                    </ul>
                </nav>
            </c:if>
        </div>
    </div>
    <!-- 페이지 네이션 -->
<!-- 본문 끝 -->

<script>
document.addEventListener('DOMContentLoaded', function() {
    const categoryItems = document.querySelectorAll('.left li');  // 왼쪽 카테고리 메뉴의 각 항목들을 선택합니다.
    const shopItems = document.querySelectorAll('.item-card');  // 오른쪽 상품 카드들을 선택합니다.

    // 선택된 카테고리에 따라 상품을 필터링하는 함수입니다.
    function filterItems(category) {
        shopItems.forEach(item => {  // 모든 상품 카드에 대해 반복합니다.
            const itemCategory = item.getAttribute('data-category');  // 각 상품 카드의 data-category 속성 값을 가져옵니다.
            if (category === 'All' || itemCategory === category) {  // 선택된 카테고리가 '전체'이거나 상품의 카테고리와 일치하는 경우,
                item.style.display = 'block';  // 해당 상품을 화면에 보이게 설정합니다.
            } else {  // 그렇지 않으면,
                item.style.display = 'none';  // 해당 상품을 화면에서 숨깁니다.
            }
        });
    }//filterItems(category) end

    // 카테고리 메뉴의 각 항목에 클릭 이벤트 리스너를 추가합니다.
    categoryItems.forEach(item => {
        item.addEventListener('click', function() {
            const selectedCategory = this.getAttribute('data-category');  // 클릭된 항목의 data-category 속성 값을 가져옵니다.
            filterItems(selectedCategory);  // 선택된 카테고리에 따라 상품을 필터링합니다.
        });
    });//categoryItems.forEach(item => end

    // 페이지 로드 시 초기 상태로 모든 상품을 보이도록 설정합니다.
    filterItems('All');
    
    
    
    /* 드롭다운 기본상품순 */
    const dropdownItems = document.querySelectorAll('.dropdown-item'); // 드롭다운 메뉴의 각 항목을 선택합니다.
    const shopContainer = document.querySelector('.right'); // 오른쪽 상품 목록을 감싸는 컨테이너를 선택합니다.

    dropdownItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault(); // 기본 이벤트 동작을 막습니다.

            const sortType = this.textContent.trim(); // 클릭된 항목의 텍스트 콘텐츠를 가져옵니다.

            // 상품을 가격에 따라 정렬합니다.
            if (sortType === '높은가격순') {
                sortItemsByPrice('desc');
            } else if (sortType === '낮은가격순') {
                sortItemsByPrice('asc');
            } else {
                showAllItems(); // 기본상품순일 경우 모든 상품을 보여줍니다.
            }
        }); //item.addEventListener('click', function(e) end
    });//dropdownItems.forEach(item => end

    // 가격에 따라 상품을 정렬하는 함수
    function sortItemsByPrice(order) {
        const items = Array.from(shopContainer.querySelectorAll('.item-card'));

        items.sort(function(a, b) {
            const priceA = parseFloat(a.querySelector('p:nth-child(3)').textContent.replace(/[^\d]/g, ''));
            const priceB = parseFloat(b.querySelector('p:nth-child(3)').textContent.replace(/[^\d]/g, ''));

            if (order === 'desc') {
                return priceB - priceA; // 높은 가격순으로 정렬
            } else {
                return priceA - priceB; // 낮은 가격순으로 정렬
            }
        });//items.sort(function(a, b) end

        // 정렬된 상품을 다시 컨테이너에 추가합니다.
        shopContainer.innerHTML = '';
        items.forEach(item => {
            shopContainer.appendChild(item);
        });
    }

    // 모든 상품을 보여주는 함수
    function showAllItems() {
        const items = Array.from(shopContainer.querySelectorAll('.item-card'));

        items.forEach(item => {
            item.style.display = 'block'; // 모든 상품을 보이도록 설정합니다.
        });
    }//showAllItems()end
    
    
    
    
    
    
    
}); //document.addEventListener('DOMContentLoaded', function() end



/* document.addEventListener('DOMContentLoaded', function() {
    const categoryItems = document.querySelectorAll('.left ul li');
    const productItems = document.querySelectorAll('.item-card');

    categoryItems.forEach(item => {
        item.addEventListener('click', function() {
            const category = this.getAttribute('data-category');
            filterProducts(category);
        });
    });

    function filterProducts(category) {
        productItems.forEach(product => {
            if (category === 'All' || product.getAttribute('data-category') === category) {
                product.style.display = 'block';
            } else {
                product.style.display = 'none';
            }
        });
    }
}); */

</script>

<%@ include file="../footer.jsp"%>