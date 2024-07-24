<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>

<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 후기 쓰기</title>
    <!-- 부트스트랩 CSS -->
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
    <script src="/js/jquery-3.7.1.min.js"></script>
    <link href="/css/styles.css" rel="stylesheet" type="text/css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
        }
        .board_write_popup {
            width: 700px;
            max-width: 100%;
            margin: 0 auto;
            background-color: #fff;
            padding: 20px;
            border: 1px solid #ccc;
            box-shadow: 0 0 10px rgba(0,0,0,0.1);
            border-radius: 8px;
        }
        .ly_tit {
            margin-bottom: 20px;
            text-align: center;
        }
        .ly_cont {
            margin-bottom: 20px;
        }
        .top_item_photo_info {
            text-align: center;
            margin-bottom: 20px;
        }
        .productname {
            font-size: 24px;
            font-weight: bold;
            margin-top: 10px;
            margin-bottom: 10px;
        } 
        .board_write_box {
            padding: 20px;
            background-color: #f9f9f9;
            border: 1px solid #ddd;
            border-radius: 8px;
        }
        .board_write_table {
            width: 100%;
            margin-bottom: 0;
        }
        .board_write_table th {
            width: 15%;
            text-align: right;
            vertical-align: top;
        }
        .board_write_table td {
            width: 85%;
            padding-left: 10px;
        }
        .write_editor textarea {
            width: 100%;
            min-width: 100%;
            height: 150px;
            padding: 10px;
            border: 1px solid #ddd;
            border-radius: 4px;
            resize: vertical;
        }
        .btn_center_box {
            text-align: center;
        }
        .btn_ly_cancel, .btn_ly_write_ok {
            display: inline-block;
            padding: 10px 20px;
            font-size: 16px;
            font-weight: bold;
            text-decoration: none;
            color: #fff;
            background-color: #007bff;
            border: 1px solid #007bff;
            border-radius: 4px;
            cursor: pointer;
            transition: background-color 0.3s ease;
        }
        .btn_ly_cancel:hover, .btn_ly_write_ok:hover {
            background-color: #0056b3;
            border-color: #0056b3;
        }
        @media (min-width: 768px) {
            .board_write_table th, .board_write_table td {
                width: auto;
            }
        }
        @media (max-width: 767px) {
            .board_write_table th, .board_write_table td {
                display: block;
                width: 100%;
                text-align: left;
            }
            .write_editor textarea {
                height: 200px;
            }
        }
    </style>
</head>
<body class="body-board body-popup-goods-board-write pc">
    <div class="board_write_popup">
        <div class="ly_tit">
            <h2>상품 후기 쓰기</h2>
        </div>

        <div class="ly_cont">
            <form name="reviewfrm" id="reviewfrm" method="post" enctype="multipart/form-data">
                <input type="hidden" name="goodsid" id="goodsid" value="${param.goodsid}">
                <input type="hidden" name="reviewid" id="reviewid" value="">
                <input type="hidden" name="grantedpoints" id="grantedpoints" value="100">
                <div class="scroll_box">
                    <div class="top_item_photo_info">
                        <c:forEach items="${goodsList}" var="goods">
                        <c:if test="${goods.goodsid eq param.goodsid}">
                            <img src="${pageContext.request.contextPath}/storage/goods/${goods.filename}" width="300" alt="${param.goodsid} 상품 이미지" title="${param.goodsid} 상품 이미지" class="middle">
                            <br> 
                            <h5 class="productname">${goods.productname}</h5>
                        </c:if>
                        </c:forEach>    
                    </div>
                    <div class="board_write_box">
                        <table class="board_write_table">
                            <colgroup>
                                <col style="width:15%">
                                <col style="width:85%">
                            </colgroup>
                            <tbody>
                                <tr>
                                    <th scope="row">작성자</th>
                                    <td>
                                        <input type="text" name="userid" id="userid" value="${userID}" class="form-control" readonly>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">주문 ID</th>
                                    <td>
                                        <select name="orderid" id="orderid" class="form-control">
                                            <option value="">주문 번호를 선택해주세요.</option>
                                            <c:forEach items="${orderList}" var="order">
                                                	<option value="${order.orderid}">${order.orderid}</option>
                                            </c:forEach>
                                        </select>
                                    </td>
                                </tr>              
                                <tr>
                                    <th scope="row">제목</th>
                                    <td>
                                        <input type="text" name="title" id="title" class="form-control write_title" placeholder="제목 입력">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">내용</th>
                                    <td class="write_editor">                                       
                                        <textarea title="내용 입력" class="form-control" name="content" id="content" rows="5" placeholder="내용을 입력하세요"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">파일</th>
                                    <td id="uploadBox">
                                        <div class="file_upload_sec" id="uploadSection">
                                            <input type="file" id="img" name="img" class="form-control" title="찾아보기">
                                            <!-- <div class="btn_upload_box">
                                                <button type="button" id="addUploadBtn" class="btn btn-outline-secondary btn_gray_big"><span>+ 추가</span></button>
                                            </div> -->
                                        </div>
                                    </td>                                   
                                </tr>
                                <tr>
                                    <th scope="row">평점</th>
                                    <td>
                                        <label><input type="radio" name="rating" value="1"> 1점</label>
                                        <label><input type="radio" name="rating" value="2"> 2점</label>
                                        <label><input type="radio" name="rating" value="3"> 3점</label>
                                        <label><input type="radio" name="rating" value="4"> 4점</label>
                                        <label><input type="radio" name="rating" value="5"> 5점</label>
                                        <br>
                                        <small class="text-muted">1점부터 5점까지의 점수 중 하나를 선택해주세요.</small>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                </div>
                <br>
                <div class="btn_center_box">
                    <input type="button" value="등록" onclick="submitReviewForm()" class="btn btn-primary btn_ly_write_ok">
                    <a href="javascript:window.close()" class="btn btn-secondary btn_ly_cancel"><strong>취소</strong></a>
                </div>
            </form>  
        </div>
    </div>

    <script>
        function submitReviewForm() {
            if (validateForm()) {
                var formData = new FormData(document.getElementById('reviewfrm'));
                
                $.ajax({
                    url: '/review/insert',
                    type: 'POST',
                    data: formData,
                    processData: false,
                    contentType: false,
                    success: function(response) {
                        if (response === "success") {
                            alert('리뷰가 작성되었습니다.');
                            window.close(); // 리뷰 작성 후 창 닫기
                        } else if (response === "duplicate") {
                            alert('해당 주문에 대해 이미 리뷰가 작성되었습니다.');
                        }
                    },
                    error: function(xhr, status, error) {
                        alert('리뷰 작성에 실패했습니다. 다시 시도해주세요.');
                    }
                });
            }
        }

        function validateForm() {
        	var orderid = document.getElementById('orderid').value.trim();
            var title = document.getElementById('title').value.trim();
            var content = document.getElementById('content').value.trim();
            var radios = document.getElementsByName('rating');
            var ratingChecked = false;

            if (orderid === "") {
            	alert('주문 번호를 선택 해주세요.');
                return false;
            }
            
            if (title.length < 2) {
                alert('제목은 두 글자 이상이어야 합니다.');
                return false;
            }

            if (content === '') {
                alert('내용을 입력해주세요.');
                return false;
            }

            for (var i = 0; i < radios.length; i++) {
                if (radios[i].checked) {
                    ratingChecked = true;
                    break;
                }
            }

            if (!ratingChecked) {
                alert('평점을 선택해주세요.');
                return false;
            }
            
            return true;
        }

        document.addEventListener('DOMContentLoaded', function() {
            var reviewId = generateUniqueReviewId();
            document.getElementById('reviewid').value = reviewId;
        });

        function generateUniqueReviewId() {
            var prefix = 'review';
            var num;
            var existingIds = [];

            <c:forEach items="${reviewList}" var="review">
                existingIds.push('${review.reviewid}');
            </c:forEach>

            do {
                num = generateRandomNumber();
                var newId = prefix + num.toString().padStart(3, '0');
            } while (existingIds.includes(newId));

            return newId;
        }

        function generateRandomNumber() {
            return Math.floor(Math.random() * 999) + 1;
        }

        function handleRatingClick(rating) {
            var radios = document.getElementsByName('rating');
            for (var i = 0; i < radios.length; i++) {
                if (radios[i].value == rating) {
                    radios[i].checked = true;
                } else {
                    radios[i].checked = false;
                }
            }
        }

        var uploadSection = document.getElementById('uploadSection');
        var addUploadBtn = document.getElementById('addUploadBtn');
        var uploadCount = 1;

        addUploadBtn.addEventListener('click', function() {
            var newInput = document.createElement('input');
            newInput.type = 'file';
            newInput.id = 'img' + uploadCount;
            newInput.name = 'img';
            newInput.className = 'file';
            newInput.title = '찾아보기';

            var span = document.createElement('span');
            span.className = 'btn_gray_list';
            var deleteBtn = document.createElement('button');
            deleteBtn.type = 'button';
            deleteBtn.className = 'btn btn-outline-secondary btn_gray_big';
            deleteBtn.innerHTML = '<span>- 삭제</span>';
            deleteBtn.addEventListener('click', function() {
                this.parentNode.previousSibling.remove();
                this.parentNode.remove();
            });

            span.appendChild(deleteBtn);

            uploadSection.appendChild(newInput);
            uploadSection.appendChild(span);

            uploadCount++;
        });
    </script>
</body>
</html>
