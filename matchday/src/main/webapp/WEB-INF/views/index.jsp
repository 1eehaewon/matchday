<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

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

        .carousel-control-prev,
        .carousel-control-next {
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
            color: black !important;
        }

        .dropdown:hover .dropdown-menu {
            display: block;
            background-color: #003366;
        }
    </style>
</head>

<body>
    <header>
        <div class="container">
            <div class="header-container">
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
                    <li class="nav-item"><a class="nav-link" href="#" style="color: white;">예매</a></li>
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
        <!-- 경기 일정 캐러셀 섹션 -->
        <div id="matchCarousel" class="carousel slide mt-5" data-bs-ride="carousel">
            <div class="carousel-inner">
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
        </div>
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
                </div>
                <div class="col">
                    <a href="https://mydaily.co.kr/page/view/2024062410284896917" class="text-decoration-none text-dark">
                        <div class="card">
                            <img src="https://imgnews.pstatic.net/image/117/2024/06/24/0003843860_001_20240624160011282.jpg?type=w647" class="card-img-top" alt="...">
                            <div class="card-body">
                                <h5 class="card-title">"텐 하흐 잘렸으면 너도 방출이었어!"…'국민 밉상'의 기사회생, "텐 하흐가 그를 정말, 정말 좋아한다"</h5>
                                <p class="card-text">맨유는 올 시즌 리그 우승 경쟁 한 번 해보지 못하고 8위로 추락했다. 리그컵은 조기 탈락. 특히 유럽축구연맹(UEFA) 챔피언스리그(UCL)에서는 조 꼴찌 탈락 수모를 당했다.... </p>
                                <p class="text-muted">2024-06-19 22:58</p>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col">
                    <a href="https://m.sports.naver.com/wfootball/article/413/0000179057" class="text-decoration-none text-dark">
                        <div class="card">
                            <img src="https://imgnews.pstatic.net/image/413/2024/06/24/0000179057_001_20240624154010473.jpg?type=w647" class="card-img-top">
                            <div class="card-body">
                                <h5 class="card-title">김민재는 어쩌다 '매각 불가' 다이어에 밀렸나..."방출 안심 못 해, 뮌헨은 발전 가능성 의심"</h5>
                                <p class="card-text">독일 '키커'는 24일(한국시간) "다이어는 여러 이유로 여름 스쿼드에서 유일하게 팔릴 가능성이 없는 센터백이다. 다이어는 지난 시즌 리더십 자질을 갖춘 센터백이라는 걸 보여줬다...</p>
                                <p class="text-muted">2024-06-12 15:10</p>
                            </div>
                        </div>
                    </a>
                </div>
                <!-- 두 번째 줄 카드들 -->
                <div class="col">
                    <a href="https://m.sports.naver.com/wfootball/article/411/0000047970" class="text-decoration-none text-dark">
                        <div class="card">
                            <img src="https://imgnews.pstatic.net/image/411/2024/06/24/0000047970_001_20240624145508311.jpg?type=w647" class="card-img-top" alt="...">
                            <div class="card-body">
                                <h5 class="card-title">817억에 영입한 맨유, '222억'에 파는 것도 어렵다</h5>
                                <p class="card-text">맨체스터 유나이티드가 아론 완 비사카를 매각하고자 한다. 갈라타사라이가 그에게 관심을 표하고 있지만, 이적료와 관련해 의견 차이가 있다.튀르키예 매체 '파나틱'은 "완 비사카는 갈라타사라이와 구두 합의를 이뤄냈다...</p>
                                <p class="text-muted">2024-06-24 09:52</p>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col">
                    <a href="https://m.sports.naver.com/wfootball/article/076/0004160488" class="text-decoration-none text-dark">
                        <div class="card">
                            <img src="https://imgnews.pstatic.net/image/076/2024/06/24/2024062401001775000244914_20240624135318840.jpg?type=w647" class="card-img-top" alt="...">
                            <div class="card-body">
                                <h5 class="card-title">맨시티, 레알, 바르사, 리버풀, 아스널 아니면 전화 안 받아...월클의 미친 패기 '뮌헨 떠난다"</h5>
                                <p class="card-text">독일 스카이 스포츠의 플로리안 플레텐베르크 기자는 23일(한국시각) 개인 SNS를 통해 "올해 아니면 내년 여름에 바이에른과 키미히의 이별 가능성이 점점 높아지고 있다. 양측 모두 이별에 열려있다"고 밝혔다....</p>
                                <p class="text-muted">2024-06-19 22:58</p>
                            </div>
                        </div>
                    </a>
                </div>
                <div class="col">
                    <a href="https://m.sports.naver.com/wfootball/article/411/0000047969" class="text-decoration-none text-dark">
                        <div class="card">
                            <img src="https://imgnews.pstatic.net/image/411/2024/06/24/0000047969_001_20240624143512969.jpg?type=w647" class="card-img-top" alt="...">
                            <div class="card-body">
                                <h5 class="card-title">'261경기 32골 52AS' 브라이튼에서 전설 찍고, 도르트문트 합류 임박</h5>
                                <p class="card-text">독일 '스카이 스포츠'의 플로리안 플레텐베르크 기자는 "도르트문트는 그로스와의 구두 합의에 매우 임박했다. 그로스는 도르트문트 합류를 원하고 있다. 현재 명확히 해야 할 마지막 세부 사항은 계약 조건이다....</p>
                                <p class="text-muted">2024-06-12 15:10</p>
                            </div>
                        </div>
                    </a>
                </div>
            </div>
        </div>
    </main>

    <footer>
        <div class="footer-content">
            <p>| 대표자: 000 | 전화: 000-0000 | 팩스: 000-0000 | 이메일: info@ulsaniparkfc.co.kr</p>
            <p>Copyright © ULSAN IPARK FOOTBALL CLUB. All rights reserved.</p>
        </div>
    </footer>
</body>

</html>
