<!-- list.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp"%>

<style>
    /* 기존 스타일 유지 */
    .shop-container {
        display: flex;
        flex-wrap: wrap; 
    }
    
    .left {
        flex: 0.4; 
        max-width: 30%; 
        border-right: 1px solid #ccc; 
        padding: 10px; 
        overflow-y: auto; 
        background-color: #f8f9fa;
    }
    
    .left ul {
        list-style-type: none; 
        padding: 0;
        margin: 0;
    }
    
    .left li {
        padding: 15px; 
        cursor: pointer;
        border-bottom: 1px solid #ddd; 
        font-weight: bold; 
        text-align: center;
        color: #333;
        transition: background-color 0.3s ease, color 0.3s ease;
    }
    
    .left li:hover {
        background-color: #f0f0f0;
        color: #007bff;
    }
    
    .left li.active {
        background-color: #007bff;
        color: white;
    }
    
    .centered-button {
        display: flex;
        justify-content: center;
        margin: 10px 0;
    }
    
    .right {
        flex: 2;
        padding: 30px;
        display: flex;
        flex-wrap: wrap;
        justify-content: left;
        align-items: center;
    }
    
    .goodsItem {
        flex: 0 0 auto;
        width: 380px;
     }
    
    .item-card {
        position: relative;
        margin: 5px;
        margin-bottom: 20px;
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
    
    .item-card p {
        font-size: 20px;
    }
    
    .small-image {
        max-width: 100%;
        height: auto;
    }
    
    .product-label {
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
        background-color: #007bff;
        color: #fff;
        border: none;
        border-radius: 4px;
        cursor: pointer;
    }
    
    .search-container input[type="submit"]:hover {
        background-color: #0056b3;
    }
    
    .goods-dropdown {
        margin-right: 3%;
        margin-bottom: 10px;
    }
    
    .category-list {
        list-style: none;
        padding: 0;
        margin: 0;
    }
    
    @media (max-width: 768px) {
        .left {
            flex: 1 0 100%;
            max-width: 100%;
            border-right: none;
            border-bottom: 1px solid #ccc;
        }
        
        .right {
            flex: 1 0 100%;
            max-width: 100%;
            padding: 15px;
        }
    }
    
    @media (max-width: 480px) {
        .right {
            padding: 10px;
        }
    
        .item-card {
            margin: 5px 0;
        }
    }
    .custom-margin {
        margin-right: 65px; /* 원하는 여백 값으로 조절 */
    }
</style>

<!-- 본문 시작 main.jsp -->
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
                <button class="btn btn-secondary dropdown-toggle custom-dropdown-btn" type="button" id="goodsDropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">최신등록순</button>
                <div class="dropdown-menu dropdown-menu-end custom-dropdown-menu" aria-labelledby="goodsDropdownMenuButton">
                    <a class="dropdown-item goods-dropdown-item" href="#" id="latestItems">최신등록순</a> 
                    <a class="dropdown-item goods-dropdown-item" href="#">높은가격순</a> 
                    <a class="dropdown-item goods-dropdown-item" href="#">낮은가격순</a>
                </div>
            </div>
        </div>
    </div>
</div>

<!-- 장바구니 버튼 -->
<div class="row justify-content-end mb-3">
    <div class="col-auto custom-margin">
        <button type="button" onclick="location.href='${pageContext.request.contextPath}/cart/list'" class="btn btn-primary">장바구니로 이동~🛒</button>
    </div>
</div>

<div class="shop-container">
    <div class="left">
        <!-- 왼쪽 카테고리 -->
        <ul class="category-list">
            <li data-name="전체" data-category="All">전체</li>
            <li data-name="키링" data-category="Keyring">키링</li>
            <li data-name="유니폼" data-category="Uniform">유니폼</li>
            <li data-name="헤어밴드" data-category="Hairband">헤어밴드</li>
            <li data-name="머플러" data-category="Muffler">머플러</li>
            <li data-name="응원봉" data-category="Lightstick">응원봉</li>
            <li data-name="축구공" data-category="Soccerball">축구공</li>
        </ul>
        <br>
        
        <p class="centered-button"> <!-- 관리자용 상품등록 -->
         <c:if test="${sessionScope.grade == 'M'}">
            <button type="button" onclick="location.href='write'" class="btn btn-success">상품등록</button>
         </c:if>
        </p>
        
    </div>
    <!-- 왼쪽 카테고리 -->

    <div class="right" id="right-container">
        <div class="row">
            <!-- 상품 정보 -->
            <c:forEach items="${list}" var="row" varStatus="vs">
                <div class="goodsItem">
                    <div class="item-card" data-category="${row.category}">
                        <c:choose>
                            <c:when test="${not empty row.filename && row.filename != '-'}">
                                <a href="${pageContext.request.contextPath}/goods/detail?goodsid=${row.goodsid}">
                                    <img src="${pageContext.request.contextPath}/storage/goods/${row.filename}" class="img-responsive margin">
                                </a>
                            </c:when>
                            <c:otherwise>
                                <a href="${pageContext.request.contextPath}/goods/detail?goodsid=${row.goodsid}">
                                    <img src="${pageContext.request.contextPath}/images/default_product_image.jpg" alt="등록된 사진 없음" class="small-image">
                                </a>
                            </c:otherwise>
                        </c:choose>
                        <p style="height: 53px; align-content: center;">
                            <a href="${pageContext.request.contextPath}/goods/detail?goodsid=${row.goodsid}">${row.productname}</a>
                        </p>
                        <p>
                            <fmt:formatNumber value="${row.price}" pattern="#,###원" />
                        </p>
                    </div>
                </div>

                <!-- 행의 4번째 항목인지 확인하여 닫고 새 행을 시작하세요 -->
                <c:if test="${vs.count % 4 == 0}">
                    <!-- </div>이전 행 닫기 -->
                    <!-- <div style="height: 50px;"></div> -->
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

<script>
document.addEventListener('DOMContentLoaded', function() {
    
    const categoryItems = document.querySelectorAll('.left li');
    const shopItems = document.querySelectorAll('.goodsItem');
    
    const dropdownItems = document.querySelectorAll('.goods-dropdown-item');
    const shopContainer = document.querySelector('.right');
    const dropdownButton = document.getElementById('goodsDropdownMenuButton');
    
    function filterItems(category) {
        const filterItems = Array.from(shopItems);
        const filterList = [];
        
        const nowShopItems = document.querySelectorAll('.goodsItem')
        
        filterItems.forEach((item, idx) => {
            const itemCategory = item.firstElementChild.getAttribute('data-category');
            
            if (category === 'All' || itemCategory === category) {
                filterList.push(filterItems[idx]);
            }
        });
        
        nowShopItems.forEach(item => item.parentNode.removeChild(item));
        filterList.forEach(item => shopContainer.firstElementChild.appendChild(item));
    }

    categoryItems.forEach(item => {
        item.addEventListener('click', function() {
            const selectedCategory = this.getAttribute('data-category');
            filterItems(selectedCategory);
        });
    });

    filterItems('All');
    
    dropdownItems.forEach(item => {
        item.addEventListener('click', function(e) {
            e.preventDefault();
            const sortType = this.textContent.trim();
            const selectedText = this.textContent.trim();
            
            if (sortType === '최신등록순') {
                sortItemsByRegistration();
            } else if (sortType === '높은가격순') {
                sortItemsByPrice('desc');
            } else if (sortType === '낮은가격순') {
                sortItemsByPrice('asc');
            } else {
                showAllItems();
            }
            
            dropdownButton.textContent = selectedText;
            
            if (selectedText === '최신등록순') {
                // 최신 등록순을 선택했을 때의 추가 동작
            } else if (selectedText === '높은가격순') {
                // 높은 가격순을 선택했을 때의 추가 동작
            } else if (selectedText === '낮은가격순') {
                // 낮은 가격순을 선택했을 때의 추가 동작
            } else {
                // 기본상품순을 선택했을 때의 추가 동작
            }
        });
    });

    function sortItemsByPrice(order) {
        const items = Array.from(shopItems);

        items.sort(function(a, b) {
            const priceA = parseFloat(a.querySelector('p:nth-child(3)').textContent.replace(/[^\d]/g, ''));
            const priceB = parseFloat(b.querySelector('p:nth-child(3)').textContent.replace(/[^\d]/g, ''));

            if (order === 'desc') {
                return priceB - priceA;
            } else {
                return priceA - priceB;
            }
        });
        
        shopItems.forEach(item => item.parentNode.removeChild(item));
        items.forEach(item => shopContainer.firstElementChild.appendChild(item));
    }

    function sortItemsByRegistration() {
        const items = Array.from(shopItems);

        items.sort(function(a, b) {
            const dateA = new Date(a.getAttribute('data-registration'));
            const dateB = new Date(b.getAttribute('data-registration'));

            return dateB - dateA;
        });

        shopItems.forEach(item => item.parentNode.removeChild(item));
        items.forEach(item => shopContainer.firstElementChild.appendChild(item));
    }

    function showAllItems() {
        shopItems.forEach(item => {
            item.style.display = 'block';
        });
    }
      
});
</script>

<%@ include file="../footer.jsp"%>
