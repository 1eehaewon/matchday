<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>이미지 공간 비우기</title>
    <style>
        .container {
            display: flex;
            flex-direction: column;
            align-items: center;
        }
        .image-placeholder {
            width: 494px; /* 2번째 이미지의 너비 */
            height: 630px; /* 2번째 이미지의 높이 */
            background-color: #f0f0f0;
            display: flex;
            align-items: center;
            justify-content: center;
            border: 1px solid #ccc;
            margin-top: 20px;
        }
        .image-placeholder a {
            text-decoration: none;
            color: #333;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <div class="container">
        <!-- 첫 번째 이미지 표시 -->
        <img src="image1.png" alt="첫 번째 이미지">

        <!-- 두 번째 이미지를 위한 공간 -->
        <div class="image-placeholder">
            <a href="다른페이지.jsp">다른 페이지로 이동</a>
        </div>
    </div>
</body>
</html>
