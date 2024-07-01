<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ include file="../header.jsp" %>

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
            flex: 1;
            border-right: 1px solid #ccc;
            padding: 10px;
            overflow-y: auto;
        }

        .left ul {
            list-style-type: none;
            padding: 0;
            margin: 0;
        }

        .left li {
            padding: 10px;
            cursor: pointer;
            border-bottom: 1px solid #ddd;
        }

        .left li:hover {
            background-color: #f0f0f0;
        }

        .right {
            flex: 2;
            padding: 20px;
            display: flex;
            flex-wrap: wrap;
            justify-content: center;
            align-items: center;
        }

        .item-card {
            margin: 10px;
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
            height: auto;
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
	        <img src="https://www.completesports.com/wp-content/uploads/2019/02/UEFA-Champions-League-1200x676.jpg?ezimgfmt=ngcb6/notWebP" class="d-block w-100" alt="New York" style="width: 1200px; height: 400px;">
	      </div>
	
	      <div class="carousel-item">
	        <img src="https://dimg.donga.com/wps/SPORTS/IMAGE/2023/12/19/122685296.1.jpg" class="d-block w-100" alt="" style="width: 1200px; height: 400px;">
	        <div class="carousel-caption d-none d-md-block">
	        </div>      
	      </div>
	    
	      <div class="carousel-item">
	        <img src="https://www.10wallpaper.com/wallpaper/1366x768/1412/Champions_League-2014_High_quality_HD_Wallpaper_1366x768.jpg" class="d-block w-100" alt="" style="width: 1200px; height: 400px;">
	      </div>
	    </div>
	
	    <!-- Left and right controls -->
	    <a class="carousel-control-prev" href="#myCarousel" role="button" data-bs-slide="prev">
	      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	      <span class="visually-hidden">Previous</span>
	    </a>
	    <a class="carousel-control-next" href="#myCarousel" role="button" data-bs-slide="next">
	      <span class="carousel-control-next-icon" aria-hidden="true"></span>
	      <span class="visually-hidden">Next</span>
	    </a>
	</div>
	
	    <div class="container text-center"> <!-- 검색 -->
	    <div class="col-l-20">
	        <form method="get" action="search">
	            <br> 
	            상품명: <input type="text" name="productname" value="${productname}" size="30">
	            		<input type="submit" value="검색">
	            <br> 
	        </form>
	    </div>
		</div>  <!-- 검색 -->
    
   <div class="container mt-4">
   <div class="row justify-content-end">
        <div class="col-auto">
            <div class="dropdown">
                <button class="btn btn-secondary dropdown-toggle" type="button" id="dropdownMenuButton" data-toggle="dropdown" aria-haspopup="true" aria-expanded="false">
                    기본상품순
                </button>
                <div class="dropdown-menu dropdown-menu-end" aria-labelledby="dropdownMenuButton">
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
    <div class="left"> <!-- 왼쪽 카테고리 -->
        <ul>
            <li data-name="전체" data-category="all">전체</li>
            <li data-name="키링" data-category="keyring">키링</li>
            <li data-name="유니폼" data-category="uniform">유니폼</li>
            <li data-name="헤어밴드" data-category="hairband">헤어밴드</li>
            <li data-name="머플러" data-category="muffler">머플러</li>
            <li data-name="응원봉" data-category="lightstick">응원봉</li>        
        </ul>
        <br>
        <p><button type="button" onclick="location.href='write'">상품등록</button></p>
    </div> <!-- 왼쪽 카테고리 -->
    
    <div class="right" id="right-container">
	    <div class="row"> <!-- 상품 정보 -->
	        <c:forEach items="${list}" var="row" varStatus="vs">
	            <div class="col-sm-3 col-md-3">
	            	<div class="item-card">
		                <c:choose>
		                    <c:when test="${not empty row.filename && row.filename != '-'}">
		                        <a href="${pageContext.request.contextPath}/goods/detail/${row.goodsid}">
		                            <img src="${pageContext.request.contextPath}/storage/${row.filename}" class="img-responsive margin" style="width:100%">
		                        </a>
		                    </c:when>
		                    <c:otherwise>
		                        <a href="${pageContext.request.contextPath}/goods/detail/${row.goodsid}">
		                        	<img src="${pageContext.request.contextPath}/images/default_product_image.jpg" alt="등록된 사진 없음" class="small-image">
		                    	</a>
		                    </c:otherwise>
		                </c:choose>
			                <p><a href="${pageContext.request.contextPath}/goods/detail/${row.goodsid}">${row.productname}</a></p>
			                <p><fmt:formatNumber value="${row.price}" pattern="#,###원"/></p>
	            	</div>
	            </div>
	            <!-- 행의 4번째 항목인지 확인하여 닫고 새 행을 시작하세요 -->
	            <c:if test="${vs.count % 4 == 0}">
		<!-- </div>이전 행 닫기 -->
	                <div style="height: 50px;"></div><!-- 행 사이의 공백 -->
	    <!-- <div class="row">새 행 시작 -->
	            </c:if>
	        </c:forEach>
	    </div> <!-- 상품 정보 -->
	</div> <!-- right container end -->
	</div> <!-- shop container end -->
<!-- 본문 끝 -->

<%@ include file="../footer.jsp" %>