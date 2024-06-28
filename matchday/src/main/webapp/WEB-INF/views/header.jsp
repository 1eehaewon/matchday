<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html lang="ko">
<head>
  <title>MatchDay</title>
  <meta charset="utf-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/jquery-3.7.1.min.js"></script>
  <link href="/css/styles.css" rel="stylesheet" type="text/css">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.2.0/dist/css/bootstrap.min.css"
  integrity="sha256-7ZWbZUAi97rkirk4DcEp4GWDPkWpRMcNaEyXGsNXjLg=" crossorigin="anonymous">
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/summernote@0.8.20/dist/summernote-lite.min.css"
  integrity="sha256-IKhQVXDfwbVELwiR0ke6dX+pJt0RSmWky3WB2pNx9Hg=" crossorigin="anonymous">
  
  <style>
        
		.dropdown:hover .dropdown-menu {
            display: block;
        }
        .dropdown-menu a {
            color: black !important; /* 드롭다운 메뉴의 텍스트 색상을 검정색으로 설정 */
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
                    <a class="btn btn-outline-light btn-sm" href="#">LOGIN</a>
                    <a class="btn btn-outline-light btn-sm" href="#">JOIN</a>
                </div>
            </div>
        </div>
        <nav>
            <div class="container">
                <ul class="nav justify-content-center">
                    <li class="nav-item"><a class="nav-link" href="EX2.html" style="color: white;">예매</a></li>
                    <li class="nav-item"><a class="nav-link" href="#" style="color: white;">하이라이트</a></li>
                    <li class="nav-item"><a class="nav-link" href="#" style="color: white;">쇼핑몰</a></li>
                    <div class="dropdown" data-bs-toggle="dropdown">
                    <li class="nav-item"><a class="nav-link" href="#" style="color: white;">알림마당</a></li>
                    <ul class="dropdown-menu">
					    <li><a class="dropdown-item" href="#" style="color: white;">공지사항</a></li>
					    <li><a class="dropdown-item" href="#" style="color: white;">이벤트</a></li>
					</ul>
                     </div>
                    <li class="nav-item"><a class="nav-link" href="/CustomerService/CustomerPage">고객센터</a></li>
                </ul>
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
                    <div class="carousel-caption d-none d-md-block">
                    </div>
                </div>

                <div class="carousel-item">
                    <img src="https://www.10wallpaper.com/wallpaper/1366x768/1412/Champions_League-2014_High_quality_HD_Wallpaper_1366x768.jpg" class="d-block w-100" alt="" style="width: 1200px; height: 700px;">
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
    </main>
   
    