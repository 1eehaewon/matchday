<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <title>MatchDayTicket</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/jquery-3.7.1.min.js"></script>
    <link href="/css/styles.css" rel="stylesheet" type="text/css">
    <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
    <script src="/js/script.js"></script>
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
            z-index: 1;
        }
        .carousel-control-prev {
            left: 300px;
        }
        .carousel-control-next {
            right: 300px;
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
            color: white !important;
        }
        .dropdown:hover .dropdown-menu {
            display: block;
            background-color: #003366;
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
            color: black;
            text-decoration: none;
        }
        a:hover {
            color: black;
        }
        .match-schedule {
            background-image: url('/storage/matchimg/backgroundimg.jpg');
            background-size: cover;
            background-position: center;
            position: relative;
            color: white;
        }
        .match-schedule .overlay {
            position: absolute;
            top: 0;
            left: 0;
            width: 100%;
            height: 100%;
            background-color: rgba(0, 0, 0, 0.5);
            z-index: 0;
        }
        .match-schedule .content {
            position: relative;
            z-index: 1;
        }
        .timer-container {
            display: flex;
            justify-content: center;
            align-items: center;
        }
        .timer-box {
            background: none;
            padding: 10px;
            border-radius: 5px;
            color: #fff;
            text-align: center;
        }
        .timer-box .label {
            font-size: 14px;
            margin-bottom: 5px;
        }
        .timer-box .time {
            background: #000;
            padding: 5px 10px;
            border-radius: 5px;
            font-size: 24px;
            font-weight: bold;
            display: inline-block;
            min-width: 50px;
            color: #fff;
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
                    <li class="nav-item"><a class="nav-link" href="/goods/list">SHOP</a></li>
                    <li class="nav-item dropdown">
                        <a class="nav-link dropdown-toggle" href="#" id="navbarDropdown" role="button" data-bs-toggle="dropdown" aria-expanded="false">알림마당</a>
                        <ul class="dropdown-menu" aria-labelledby="navbarDropdown">
                            <li><a class="dropdown-item" href="/notice/list">공지사항</a></li>
                            <li><a class="dropdown-item" href="/notice/evl">이벤트</a></li>
                        </ul>
                    </li>
                    <li class="nav-item"><a class="nav-link" href="/customerService/customerPage">고객센터</a></li>
                    <li class="nav-item"><a class="nav-link" href="/team/list">소개</a></li>
                    <li class="nav-item"><a class="nav-link" href="/memberships/list">멤버쉽</a></li>
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
                <img src="/storage/indeximg_1.png" class="d-block w-100" alt="" style="width: 1000px; height: 600px;">
            </div>

            <div class="carousel-item">
                <img src="/storage/indeximg_2.png" class="d-block w-100" alt="" style="width: 1000px; height: 600px;">
                <div class="carousel-caption d-none d-md-block"></div>
            </div>

            <div class="carousel-item">
                <img src="/storage/indeximg_3.png" class="d-block w-100" alt="" style="width: 1000px; height: 600px;">
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
	        <c:forEach var="match" items="${matchList}" varStatus="status">
			    <div class="carousel-item ${status.index == 0 ? 'active' : ''}">
			        <div class="container">
			            <div class="match-schedule text-center p-4 rounded shadow position-relative" style="background-image: url('/storage/matchimg/backgroundimg.jpg'); background-size: cover; background-position: center;">
			                <div class="overlay" style="position: absolute; top: 0; left: 0; width: 100%; height: 100%; background-color: rgba(0, 0, 0, 0.5);"></div>
			                <div class="content position-relative" style="z-index: 1;">
			                    <h2 class="text-white mb-4">NEXT MATCH</h2>
			                    <div class="countdown-timer mb-4" data-matchdate="${match.matchdate.time}"></div>
			                    <div class="teams d-flex justify-content-around align-items-center my-4">
			                        <div class="team text-center">
			                            <img src="/storage/matchimg/${match.hometeamid}.jpg" alt="${match.hometeamid} 로고" class="team-logo mb-2">
			                            <div class="team-name text-uppercase text-white">${match.hometeamid}</div>
			                        </div>
			                        <div class="vs fs-4 fw-bold text-white">VS</div>
			                        <div class="team text-center">
			                            <img src="/storage/matchimg/${match.awayteamid}.jpg" alt="${match.awayteamid} 로고" class="team-logo mb-2">
			                            <div class="team-name text-uppercase text-white">${match.awayteamid}</div>
			                        </div>
			                    </div>
			                    <div class="match-details text-white">
			                        <div class="match-date mb-2"><i class="bi bi-calendar"></i> <fmt:formatDate value="${match.matchdate}" pattern="yyyy/MM/dd (E) HH:mm"/></div>
			                        <div class="match-location mb-2"><i class="bi bi-geo-alt"></i> ${match.stadiumname}</div>
			                    </div>
			                </div>
			            </div>
			        </div>
			    </div>
			</c:forEach>
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
	</div>

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
        <a href="/instagram/list" class="btn btn-primary">인스타그램 등록</a>
    </c:if>
</main><!-- main end -->

<footer>
    <div class="footer-content">
        <p> | 대표자: 000 | 전화: 000-0000 | 팩스: 000-0000 | 이메일: info@ulsaniparkfc.co.kr</p>
        <p>Copyright © ULSAN IPARK FOOTBALL CLUB. All rights reserved.</p>
    </div>
</footer>
<script>
	$(document).ready(function() {
	    function updateCountdown() {
	        $('.countdown-timer').each(function() {
	            var matchDate = new Date(parseInt($(this).data('matchdate'))); // Ensure the timestamp is parsed correctly
	            var now = new Date().getTime();
	            var distance = matchDate - now;
	
	            console.log('Match Date:', matchDate); // 추가된 콘솔 로그
	            console.log('Distance:', distance); // 추가된 콘솔 로그
	
	            if (distance >= 0) {
	                var days = Math.floor(distance / (1000 * 60 * 60 * 24));
	                var hours = Math.floor((distance % (1000 * 60 * 60 * 24)) / (1000 * 60 * 60));
	                var minutes = Math.floor((distance % (1000 * 60 * 60)) / (1000 * 60));
	                var seconds = Math.floor((distance % (1000 * 60)) / 1000);
	
	                console.log('Days:', days); // 추가된 콘솔 로그
	                console.log('Hours:', hours); // 추가된 콘솔 로그
	                console.log('Minutes:', minutes); // 추가된 콘솔 로그
	                console.log('Seconds:', seconds); // 추가된 콘솔 로그
	
	                $(this).html(`
	                    <div class="d-flex justify-content-center align-items-center timer-container">
	                        <div class="timer-box mx-1 text-center">
	                            <div class="label">DAY</div>
	                            <div class="time">${days < 10 ? '0' + days : days}</div>
	                        </div>
	                        <div class="timer-box mx-1 text-center">
	                            <div class="label">HOUR</div>
	                            <div class="time">${hours < 10 ? '0' + hours : hours}</div>
	                        </div>
	                        <div class="timer-box mx-1 text-center">
	                            <div class="label">MINUTE</div>
	                            <div class="time">${minutes < 10 ? '0' + minutes : minutes}</div>
	                        </div>
	                        <div class="timer-box mx-1 text-center">
	                            <div class="label">SECOND</div>
	                            <div class="time">${seconds < 10 ? '0' + seconds : seconds}</div>
	                        </div>
	                    </div>
	                `);
	            } else {
	                $(this).html("MATCH STARTED");
	            }
	        });
	    }
	
	    setInterval(updateCountdown, 1000);
	    updateCountdown(); // initial call to display immediately
	});

</script>
</body>
</html>
