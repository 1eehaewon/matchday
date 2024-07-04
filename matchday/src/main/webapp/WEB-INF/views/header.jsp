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
                    <li class="nav-item"><a class="nav-link" href="/matches/list" style="color: white;">예매</a></li>
                    <li class="nav-item"><a class="nav-link" href="/video/list" style="color: white;">하이라이트</a></li>
                    <li class="nav-item"><a class="nav-link" href="/goods/list" style="color: white;">SHOP</a></li>
                    <div class="dropdown" data-bs-toggle="dropdown">
	                    <li class="nav-item"><a class="nav-link" href="#" style="color: white;">알림마당</a></li>
	                    <ul class="dropdown-menu">
						    <li><a class="dropdown-item" href="#" style="color: white;">공지사항</a></li>
						    <li><a class="dropdown-item" href="#" style="color: white;">이벤트</a></li>
						</ul>
                     </div>
                    <li class="nav-item"><a class="nav-link" href="/customerService/customerPage">고객센터</a></li>
                </ul>
            </div>
        </nav>
    </header><!-- header end -->

    <main>