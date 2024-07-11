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
  <!-- Bootstrap Icons CDN 추가 -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/jquery-3.7.1.min.js"></script>
  <link href="/css/styles.css" rel="stylesheet" type="text/css">
  <!-- Summernote CSS -->
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
  <!-- Summernote JS -->
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
  <script src="/js/script.js"></script>
  <!-- Summernote 한국어 설정 -->
  <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>
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
        .footer-content {
            background-color: #000;
            color: white;
            text-align: center;
            padding: 20px 0;
            font-size: 14px;
            width: 100%;
            position: relative;
            bottom: 0;
            margin-top: auto;
        }
        .footer-content p {
            margin: 5px 0;
        }
        a {
            color: black; /* 링크 색상을 검정색으로 설정 */
            text-decoration: none; /* 밑줄 제거 */
        }
        a:hover {
            color: black; /* 링크를 호버할 때 색상 유지 */
        }
  </style>
</head>
<body>
<header>
    <div class="container">
        <div class="row align-items-center py-3">
            <div class="col-6 col-md-3">
                <h1 class="logo">
                    <a href="/home.do" style="text-decoration: none; color: inherit;">MatchDay Ticket</a>
                </h1>
            </div>
            <div class="col-6 col-md-9 text-end">
                 <c:choose>
        <c:when test="${not empty sessionScope.userID}">
            <a class="btn btn-outline-light btn-sm" href="/member/logout">LOGOUT</a>
            <c:choose>
                <c:when test="${sessionScope.grade == 'M'}">
                    <a class="btn btn-outline-light btn-sm" href="/admin/dashboard">관리자 페이지</a>
                </c:when>
                <c:otherwise>
                    <a class="btn btn-outline-light btn-sm" href="/member/mypage">MYPAGE</a>
                </c:otherwise>
            </c:choose>
        </c:when>
        <c:otherwise>
            <a class="btn btn-outline-light btn-sm" href="/member/login">LOGIN</a>
            <a class="btn btn-outline-light btn-sm" href="/member/join">JOIN</a>
        </c:otherwise>
    </c:choose>
            </div>
        </div>
    </div>
    <nav class="navbar navbar-expand-lg navbar-dark bg-dark">
        <div class="container">
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav" aria-controls="navbarNav" aria-expanded="false" aria-label="Toggle navigation">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="/matches/list">예매</a></li>
                    <li class="nav-item"><a class="nav-link" href="/video/list">하이라이트</a></li>
                    <li class="nav-item"><a class="nav-link" href="/goods/list">쇼핑몰</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">알림마당</a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="/notice/list">공지사항</a></li>
                            <li><a class="dropdown-item" href="/notice/evl">이벤트</a></li>
                        </ul>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="/customerService/customerPage">고객센터</a></li>
                    <li class="nav-item"><a class="nav-link" href="/team/list">소개</a></li>
                </ul>
            </div>
        </div>
    </nav>
</header>
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
		
		<div class="container-fluid py-5" style="height: 200px;">
		<h2 class="text-center font-weight-bold">Matches🥅</h2>
		</div>
		
		
		
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
		
		<div class="container-fluid py-5" style="height: 200px;">
		<h2 class="text-center">Instagram📷</h2>	
		</div>
		
			<div class="container">
			    <div class="row justify-content-center">
			        <c:forEach items="${instagramList}" var="row" varStatus="vs">
			            <div class="col-sm-4 col-md-4 mb-4">
			                <c:choose>
			                    <c:when test="${not empty row.instagram_url}">
			                        <div>
			                            <a href="<c:url value='/instagram/detail' />?instagram_code=${row.instagram_code}">
			                            </a>
			                        </div>
			                        <div>
			                            <blockquote class="instagram-media" data-instgrm-permalink="${row.instagram_url}" data-instgrm-version="12"></blockquote>
			                            <script async src="//www.instagram.com/embed.js"></script>
			                        </div>
			                    </c:when>
			                    <c:otherwise>
			                        <p>등록된 인스타그램 없음!!</p>
			                    </c:otherwise>
			                </c:choose>
			            </div>
			            <!-- 한 줄에 3칸씩 -->
			            <c:if test="${vs.index % 3 == 2 || vs.last}">
			                </div><!-- row end -->
			                <div style="height: 50px;"></div>
			                <div class="row justify-content-center">
			            </c:if>
			        </c:forEach>
	    </div><!-- row end -->
	</div><!-- container end -->
			
		<div class="container-fluid py-5" style="height: 200px;">
		<h2 class="text-center">Highlight⚽</h2>	
		</div>

	<div class="container">
    <div class="row justify-content-center">
        <c:forEach items="${videoList}" var="row" varStatus="vs">
            <div class="col-sm-4 col-md-4 mb-4">
                <c:choose>
                    <c:when test="${row.video_name != '-'}">
                        <a href="detail?video_code=${row.video_code}">
                            <iframe width="100%" height="230" src="${row.video_url}" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture; web-share" referrerpolicy="strict-origin-when-cross-origin" allowfullscreen></iframe>
                        </a>
                    </c:when>
                    <c:otherwise>
                        등록된 영상 없음!!<br>
                    </c:otherwise>
                </c:choose>
                <br>
                경기 :
                <a href="detail?video_code=${row.video_code}">${row.video_name}</a>
            </div>

            <!-- 한 줄에 3칸씩 -->
            <c:if test="${vs.count % 3 == 0}">
                </div><!-- row end -->
                <div style="height: 20px;"></div> <!-- 간격을 줄 div 추가 -->
                <div class="row justify-content-center">
            </c:if>
        </c:forEach>
    </div><!-- row end -->
</div><!-- container end -->

<hr style="border-top: 4px solid #ccc; width: 100%; margin: 20px 0;">    

<div class="container-fluid py-5" style="height: 10px;">
    <h2 class="text-center">챔피언스리그의 더 많은 소식을 SNS를 통해 만나보세요 </h2>
</div>
		
	<div class="container">
    <div class="row g-0">
        <div class="col-md-4 px-1">
            <section class="instagram-section mt-5 p-4 text-center">
                <h2 class="mb-4">Instagram</h2>
                <a href="https://www.instagram.com/championsleague/" target="_blank">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <img src="https://img.freepik.com/premium-psd/instagram-application-logo_23-2151544088.jpg?w=826" class="img-fluid" alt="Instagram Image">
                        </div>
                    </div>
                </a>
            </section>
        </div>
        <div class="col-md-4 px-1">
            <section class="youtube-section mt-5 p-1 text-center">
                <h2 class="mb-4">Youtube</h2>
                <a href="https://www.youtube.com/user/UEFA" target="_blank">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <img src="https://img.freepik.com/premium-vector/social-media-icon-illustration-youtube-youtube-icon-vector-illustration_561158-2132.jpg?w=826" class="img-fluid" alt="YouTube Image">
                        </div>
                    </div>
                </a>
            </section>
        </div>
        <div class="col-md-4 px-1">
            <section class="facebook-section mt-5 p-1 text-center">
                <h2 class="mb-4">Facebook</h2>
                <a href="https://www.facebook.com/ChampionsLeague/" target="_blank">
                    <div class="row justify-content-center">
                        <div class="col-md-8">
                            <img src="https://img.freepik.com/premium-vector/facebook-app-icon-social-media-logo-meta_277909-586.jpg?w=826" class="img-fluid" alt="Facebook Image">
                        </div>
                    </div>
                </a>
            </section>
        </div>
    </div>
</div>

	
		  <c:if test="${sessionScope.grade == 'M'}">
		  <a href="/instagram/list"class="btn btn-primary">인스타그램 등록</a>
		  </c:if>
    </main><!-- main end -->

    <footer>
        <div class="footer-content">
            <p> | 대표자: 000 | 전화: 000-0000 | 팩스: 000-0000 | 이메일: info@ulsaniparkfc.co.kr</p>
            <p>Copyright © ULSAN IPARK FOOTBALL CLUB. All rights reserved.</p>
        </div>
    </footer>
</body>
</html>
