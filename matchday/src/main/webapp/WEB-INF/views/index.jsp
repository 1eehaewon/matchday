<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>MatchDayTicket</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/jquery-3.7.1.min.js"></script>
  <link href="/css/styles.css" rel="stylesheet" type="text/css">
  <style>
        .card img {
            width: 100%;
            height: 300px;
            object-fit: cover;
        }
        .card {
            height: 100%;
        }
        .card-body {
            display: flex;
            flex-direction: column;
            justify-content: space-between;
        }
        .carousel-control-prev, .carousel-control-next {
            position: absolute;
            top: 50%;
            transform: translateY(-50%);
            width: 5%;
            z-index: 1; /* 제어 버튼이 이미지 위에 오도록 */
        }
        .carousel-control-prev {
            left: 300px; /* 버튼이 좌측에서 10px 떨어져 위치 */
        }
        .carousel-control-next {
            right: 300px; /* 버튼이 우측에서 10px 떨어져 위치 */
        }
        .carousel-item img {
            width: 100%;
            height: auto;
        }
        .carousel-indicators {
    		display: none;
		}
		.dropdown:hover .dropdown-menu {
            display: block;
        }
        .dropdown-menu a {
            color: white !important; /* 드롭다운 메뉴의 텍스트 색상을 하얀색으로 설정 */
        }
        .dropdown:hover .dropdown-menu {
            display: block;
            background-color: #003366; /* 드롭다운 배경색 */
        }
  </style>
</head>
<body>

    <header>
        <div class="container">
            <div class="header-container">
                <div class="social-icons">
                    <!-- 소셜 아이콘 추가 가능 -->
                </div>
                <div class="logo-container">
                    <h1 class="logo">
					    <a href="/home.do" style="text-decoration: none; color: inherit;">MatchDay Ticket</a>
					</h1>
                </div>
                <div class="user-options">
                    <c:choose>
                        <c:when test="${not empty sessionScope.userID}">
                            <a class="btn btn-outline-light btn-sm" href="/member/logout">LOGOUT</a>
                            <a class="btn btn-outline-light btn-sm" href="/member/mypage">MYPAGE</a>
                        </c:when>
                        <c:otherwise>
                            <a class="btn btn-outline-light btn-sm" href="/member/login">LOGIN</a>
                            <a class="btn btn-outline-light btn-sm" href="/member/join">JOIN</a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
        </div>
        <nav>
            <div class="container">
                <ul class="nav justify-content-center">
                    <li class="nav-item"><a class="nav-link" href="EX2.html" style="color: white;">예매</a></li>
                    <li class="nav-item"><a class="nav-link" href="/video/list" style="color: white;">하이라이트</a></li>
                    <li class="nav-item"><a class="nav-link" href="/goods/list" style="color: white;">쇼핑몰</a></li>
                    <div class="dropdown" data-bs-toggle="dropdown">
	                    <li class="nav-item"><a class="nav-link" href="#" style="color: white;">알림마당</a></li>
	                    <ul class="dropdown-menu">
						    <li><a class="dropdown-item" href="#" style="color: white;">공지사항</a></li>
						    <li><a class="dropdown-item" href="#" style="color: white;">이벤트</a></li>
						</ul>
                     </div>
                    <li class="nav-item"><a class="nav-link" href="customerService/customerPage">고객센터</a></li>
                </ul>
            </div>
        </nav>
    </header><!-- header end -->

    <main>
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
		        <img src="https://www.completesports.com/wp-content/uploads/2019/02/UEFA-Champions-League-1200x676.jpg?ezimgfmt=ngcb6/notWebP" class="d-block w-100" alt="New York" style="width: 1200px; height: 700px;">
		      </div>
		
		      <div class="carousel-item">
		        <img src="https://dimg.donga.com/wps/SPORTS/IMAGE/2023/12/19/122685296.1.jpg" class="d-block w-100" alt="" style="width: 1200px; height: 700px;">
		        <div class="carousel-caption d-none d-md-block"></div>      
		      </div>
		    
		      <div class="carousel-item">
		        <img src="https://www.10wallpaper.com/wallpaper/1366x768/1412/Champions_League-2014_High_quality_HD_Wallpaper_1366x768.jpg" class="d-block w-100" alt="" style="width: 1200px; height: 700px;">
		      </div>
		    </div><!-- end -->
		
		    <!-- Left and right controls -->
		    <a class="carousel-control-prev" href="#myCarousel" role="button" data-bs-slide="prev">
		      <span class="carousel-control-prev-icon" aria-hidden="true"></span>
		      <span class="visually-hidden">Previous</span>
		    </a>
		    <a class="carousel-control-next" href="#myCarousel" role="button" data-bs-slide="next">
		      <span class="carousel-control-next-icon" aria-hidden="true"></span>
		      <span class="visually-hidden">Next</span>
		    </a>
		</div><!-- div id="myCarousel" end -->
		
		<!-- 경기 일정 캐러셀 섹션 -->
		<div id="matchCarousel" class="carousel slide mt-5" data-bs-ride="carousel">
		    <div class="carousel-inner">
		    	<!-- 섯 번째 경기 일정 -->
		        <div class="carousel-item active">
		            <div class="container">
		                <div class="match-schedule text-center p-4 rounded shadow">
		                    <h2 class="text-white mb-4">NEXT MATCH</h2>
		                    <div class="teams d-flex justify-content-around align-items-center my-4">
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/FZnTSH2rbHFos4BnlWAItw_64x64.png" alt="Ulsan" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">도르트문트</div>
		                        </div>
		                        <div class="vs fs-4 fw-bold">VS</div>
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/Th4fAVAZeCJWRcKoLW7koA_64x64.png" alt="Pohang" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">레알 마드리드</div>
		                        </div>
		                    </div>
		                    <div class="match-details text-white">
		                        <div class="league-name mb-2">챔피언스리그 2024</div>
		                        <div class="match-date mb-2"><i class="bi bi-calendar"></i> 2024/08/18 (일) 19:00</div>
		                        <div class="match-location"><i class="bi bi-geo-alt"></i> 울산문수축구경기장</div>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <!-- 두 번째 경기 일정 -->
		        <div class="carousel-item">
		            <div class="container">
		                <div class="match-schedule text-center p-4 rounded shadow">
		                    <h2 class="text-white mb-4">NEXT MATCH</h2>
		                    <div class="teams d-flex justify-content-around align-items-center my-4">
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/FZnTSH2rbHFos4BnlWAItw_64x64.png" alt="Ulsan" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">울산</div>
		                        </div>
		                        <div class="vs fs-4 fw-bold">VS</div>
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/Th4fAVAZeCJWRcKoLW7koA_64x64.png" alt="Pohang" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">포항</div>
		                        </div>
		                    </div>
		                    <div class="match-details text-white">
		                        <div class="league-name mb-2">하나은행 K리그1 2024</div>
		                        <div class="match-date mb-2"><i class="bi bi-calendar"></i> 2024/08/25 (일) 19:00</div>
		                        <div class="match-location"><i class="bi bi-geo-alt"></i> 서울월드컵경기장</div>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <!-- 세 번째 경기 일정 -->
		        <div class="carousel-item">
		            <div class="container">
		                <div class="match-schedule text-center p-4 rounded shadow">
		                    <h2 class="text-white mb-4">NEXT MATCH</h2>
		                    <div class="teams d-flex justify-content-around align-items-center my-4">
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/FZnTSH2rbHFos4BnlWAItw_64x64.png" alt="Ulsan" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">울산</div>
		                        </div>
		                        <div class="vs fs-4 fw-bold">VS</div>
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/Th4fAVAZeCJWRcKoLW7koA_64x64.png" alt="Pohang" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">포항</div>
		                        </div>
		                    </div>
		                    <div class="match-details text-white">
		                        <div class="league-name mb-2">하나은행 K리그1 2024</div>
		                        <div class="match-date mb-2"><i class="bi bi-calendar"></i> 2024/09/01 (일) 19:00</div>
		                        <div class="match-location"><i class="bi bi-geo-alt"></i> 부산아시아드주경기장</div>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <!-- 네 번째 경기 일정 -->
		        <div class="carousel-item">
		            <div class="container">
		                <div class="match-schedule text-center p-4 rounded shadow">
		                    <h2 class="text-white mb-4">NEXT MATCH</h2>
		                    <div class="teams d-flex justify-content-around align-items-center my-4">
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/FZnTSH2rbHFos4BnlWAItw_64x64.png" alt="Ulsan" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">울산</div>
		                        </div>
		                        <div class="vs fs-4 fw-bold">VS</div>
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/Th4fAVAZeCJWRcKoLW7koA_64x64.png" alt="Pohang" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">포항</div>
		                        </div>
		                    </div>
		                    <div class="match-details text-white">
		                        <div class="league-name mb-2">하나은행 K리그1 2024</div>
		                        <div class="match-date mb-2"><i class="bi bi-calendar"></i> 2024/09/08 (일) 19:00</div>
		                        <div class="match-location"><i class="bi bi-geo-alt"></i> 대구스타디움</div>
		                    </div>
		                </div>
		            </div>
		        </div>
		        <!-- 다섯 번째 경기 일정 -->
		        <div class="carousel-item">
		            <div class="container">
		                <div class="match-schedule text-center p-4 rounded shadow">
		                    <h2 class="text-white mb-4">NEXT MATCH</h2>
		                    <div class="teams d-flex justify-content-around align-items-center my-4">
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/FZnTSH2rbHFos4BnlWAItw_64x64.png" alt="Ulsan" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">울산</div>
		                        </div>
		                        <div class="vs fs-4 fw-bold">VS</div>
		                        <div class="team text-center">
		                            <img src="https://ssl.gstatic.com/onebox/media/sports/logos/Th4fAVAZeCJWRcKoLW7koA_64x64.png" alt="Pohang" class="team-logo mb-2">
		                            <div class="team-name text-uppercase">포항</div>
		                        </div>
		                    </div>
		                    <div class="match-details text-white">
		                        <div class="league-name mb-2">하나은행 K리그1 2024</div>
		                        <div class="match-date mb-2"><i class="bi bi-calendar"></i> 2024/09/15 (일) 19:00</div>
		                        <div class="match-location"><i class="bi bi-geo-alt"></i> 인천축구전용경기장</div>
		                    </div>
		                </div>
		            </div>
		        </div>
		    </div>
		    <!-- 캐러셀 제어 버튼 -->
	        <a class="carousel-control-prev" href="#matchCarousel" role="button" data-bs-slide="prev">
	            <span class="carousel-control-prev-icon" aria-hidden="true"></span>
	            <span class="visually-hidden">Previous</span>
	        </a>
	        <a class="carousel-control-next" href="#matchCarousel" role="button" data-bs-slide="next">
	            <span class="carousel-control-next-icon" aria-hidden="true"></span>
	            <span class="visually-hidden">Next</span>
	        </a>
		</div><!-- div id="matchCarousel" end -->
		
		
		<!-- 뉴스 카드 섹션 -->
		<div class="container mt-5">
		    <div class="row row-cols-1 row-cols-md-3 g-4">
		        <div class="col">
			         <a href="https://www.spotvnews.co.kr/news/articleView.html?idxno=687186" class="text-decoration-none text-dark">
			            <div class="card">
			                <img src="https://imgnews.pstatic.net/image/477/2024/06/24/0000497679_001_20240624154112694.jpg?type=w647" class="card-img-top" alt="...">
			                <div class="card-body">
			                    <h5 class="card-title">이것이 바로 '벤탄쿠르 효과'...토트넘, 눈치 좀 챙겨 제발! '손흥민 인종차별' 벤탄쿠르가 골 넣은 것도 아닌데...</h5>
			                    <p class="card-text">우루과이 축구대표팀은 24일(한국시간) 미국 하드록 스타디움에서 열린 2024 코파 아메리카 C조 1차전에서 파나마에 3-1 승리를 거뒀다...</p>
			                    <p class="text-muted">2024-06-24 09:52</p>
			                </div>
			            </div>
		            </a>
		        </div><!-- div class="col" end -->
		        <div class="col">
			         <a href="https://www.spotvnews.co.kr/news/articleView.html?idxno=687186" class="text-decoration-none text-dark">
			            <div class="card">
			                <img src="https://imgnews.pstatic.net/image/477/2024/06/24/0000497679_001_20240624154112694.jpg?type=w647" class="card-img-top" alt="...">
			                <div class="card-body">
			                    <h5 class="card-title">이것이 바로 '벤탄쿠르 효과'...토트넘, 눈치 좀 챙겨 제발! '손흥민 인종차별' 벤탄쿠르가 골 넣은 것도 아닌데...</h5>
			                    <p class="card-text">우루과이 축구대표팀은 24일(한국시간) 미국 하드록 스타디움에서 열린 2024 코파 아메리카 C조 1차전에서 파나마에 3-1 승리를 거뒀다...</p>
			                    <p class="text-muted">2024-06-24 09:52</p>
			                </div>
			            </div>
		            </a>
		        </div><!-- div class="col" end -->
		        <div class="col">
			         <a href="https://www.spotvnews.co.kr/news/articleView.html?idxno=687186" class="text-decoration-none text-dark">
			            <div class="card">
			                <img src="https://imgnews.pstatic.net/image/477/2024/06/24/0000497679_001_20240624154112694.jpg?type=w647" class="card-img-top" alt="...">
			                <div class="card-body">
			                    <h5 class="card-title">이것이 바로 '벤탄쿠르 효과'...토트넘, 눈치 좀 챙겨 제발! '손흥민 인종차별' 벤탄쿠르가 골 넣은 것도 아닌데...</h5>
			                    <p class="card-text">우루과이 축구대표팀은 24일(한국시간) 미국 하드록 스타디움에서 열린 2024 코파 아메리카 C조 1차전에서 파나마에 3-1 승리를 거뒀다...</p>
			                    <p class="text-muted">2024-06-24 09:52</p>
			                </div>
			            </div>
		            </a>
		        </div><!-- div class="col" end -->
		    </div>
		</div><!-- div class="container mt-5" end -->
    </main><!-- main end -->

    <footer>
        <div class="footer-content">
            <p> | 대표자: 000 | 전화: 000-0000 | 팩스: 000-0000 | 이메일: info@ulsaniparkfc.co.kr</p>
            <p>Copyright © ULSAN IPARK FOOTBALL CLUB. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
