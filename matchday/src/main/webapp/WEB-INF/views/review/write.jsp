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
  <!-- Bootstrap Icons CDN 추가 -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-icons/1.8.1/font/bootstrap-icons.min.css" rel="stylesheet">
  <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons/font/bootstrap-icons.css" rel="stylesheet">
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"></script>
  <script src="/js/jquery-3.7.1.min.js"></script>
  <link href="/css/styles.css" rel="stylesheet" type="text/css">
  <!-- Summernote CSS
  <link href="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.css" rel="stylesheet">
   Summernote JS
  <script src="https://cdn.jsdelivr.net/npm/summernote@0.8.18/dist/summernote.min.js"></script>
  <script src="/js/script.js"></script>
   Summernote 한국어 설정 
  <script src="https://cdnjs.cloudflare.com/ajax/libs/summernote/0.8.18/lang/summernote-ko-KR.min.js"></script>-->
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
        
        /* 이미지 및 상품명 센터 정렬 */
	    .top_item_photo_info {
	        text-align: center;
	        margin-bottom: 20px;
	    }

	    /* 상품명 스타일 */
	    .productname {
	        font-size: 24px; /* 원하는 크기로 조정 */
	        font-weight: bold; /* 굵게 설정 */
	        margin-top: 10px; /* 필요에 따라 조정 */
	        margin-bottom: 10px; /* 필요에 따라 조정 */
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
        
        /* Responsive adjustments */
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
            <form name="reviewfrm" id="reviewfrm" action="/review/insert" method="post" enctype="multipart/form-data">
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
                    <!-- //top_item_photo_info -->

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
                               <!--  <tr>
                                    <th scope="row">비밀번호</th>
                                    <td>
                                        <input type="password" name="password" id="password" class="form-control" placeholder="비밀번호 입력">
                                    </td>
                                </tr> -->
                                <tr>
                                    <th scope="row">제목</th>
                                    <td>
                                        <input type="text" name="title" id="title" class="form-control write_title" placeholder="제목 입력">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">내용</th>
                                    <td class="write_editor">
                                        <!-- <div class="form_element">
                                            <input type="checkbox" name="isSecret" value="y" id="secret">
                                            <label for="secret" class="check_s">비밀글</label>
                                        </div> -->
                                        <!-- <textarea title="내용 입력" class="form-control summernote" name="content" id="content" rows="5" placeholder="내용을 입력하세요"></textarea> -->
                                    	<textarea title="내용 입력" class="form-control" name="content" id="content" rows="5" placeholder="내용을 입력하세요"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">파일</th>
                                    <td id="uploadBox">
	                                    <div class="file_upload_sec" id="uploadSection">
										    <input type="file" id="img" name="img" class="form-control" title="찾아보기">
										    <div class="btn_upload_box">
										        <button type="button" id="addUploadBtn" class="btn btn-outline-secondary btn_gray_big"><span>+ 추가</span></button>
										    </div>
										</div>
                                    </td>
                                    
                                     <!--<td id="uploadBox">
                                        <div class="file_upload_sec">
                                            <label for="img"><input type="text" class="file_text form-control" readonly="readonly" placeholder="파일 첨부하기"></label>
                                            <div class="btn_upload_box">
                                                <button type="button" class="btn btn-outline-secondary btn_upload" title="찾아보기"><em>찾아보기</em></button>
                                                <input type="file" id="img" name="upfiles[]" class="file" title="찾아보기">
                                                <span class="btn_gray_list">
                                                    <button type="button" id="addUploadBtn" class="btn btn-outline-secondary btn_gray_big"><span>+ 추가</span></button>
                                                </span>
                                            </div>
                                        </div>
                                    </td> -->
                                </tr>
                                <tr>
								    <th scope="row">평점</th>
								    <td>
								  
									    <label> <input type="radio" name="rating" value="1"> 1점 </label>
									    <label> <input type="radio" name="rating" value="2"> 2점 </label>
										<label> <input type="radio" name="rating" value="3"> 3점 </label>
										<label> <input type="radio" name="rating" value="4"> 4점 </label>
										<label> <input type="radio" name="rating" value="5"> 5점 </label>
									
								<br>
								        <small class="text-muted">1점부터 5점까지의 점수 중 하나를 선택해주세요.</small>
								</td>
								</tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //board_write_box -->
                </div>
                <!-- //scroll_box -->
                <br>
                <div class="btn_center_box">
                <input type="submit" value="등록" onclick="return validateForm()" class="btn btn-primary btn_ly_write_ok">
                <a href="javascript:window.close()" class="btn btn-secondary btn_ly_cancel"><strong>취소</strong></a>
                <!-- <a href="" class="btn btn-primary btn_ly_write_ok"><strong>등록</strong></a> -->
       
 	           </div>
            </form>  
        </div>
        <!-- //ly_cont -->
    </div>
    <!-- //board_write_popup -->
</body>

<script>

function validateForm() { //유효성 검사
    var title = document.getElementById('title').value.trim();
    var content = document.getElementById('content').value.trim();
    var radios = document.getElementsByName('rating');
    var ratingChecked = false;

    // Validate title
    if (title.length < 2) {
        alert('제목은 두 글자 이상이어야 합니다.');
        return false;
    }

    // Validate content
    if (content === '') {
        alert('내용을 입력해주세요.');
        return false;
    }

    // Validate rating
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
	
    alert("리뷰가 작성 되었습니다.");
    window.close();
    
    return true;
    
}//validateForm() end

document.addEventListener('DOMContentLoaded', function() {
    var reviewId = generateUniqueReviewId(); // 리뷰 아이디 생성 함수 호출
    document.getElementById('reviewid').value = reviewId; // 리뷰 아이디 입력란에 설정
});

function generateUniqueReviewId() {
    var prefix = 'review';
    var num;
    var existingIds = []; // 기존 리뷰 아이디 리스트 (실제 사용하시는 데이터를 가져와야 합니다)

    // 기존 아이디들을 배열에 추가 (실제로는 서버에서 기존 데이터를 가져와야 함)
    <c:forEach items="${reviewList}" var="review">
        existingIds.push('${review.reviewid}');
    </c:forEach>

    // 중복되지 않는 아이디 생성vu
    do {
        num = generateRandomNumber(); // 랜덤 숫자 생성 함수 호출
        var newId = prefix + num.toString().padStart(3, '0'); // 3자리 숫자로 포맷
    } while (existingIds.includes(newId)); // 생성된 아이디가 기존 아이디들과 중복되는지 확인

    return newId;
}

function generateRandomNumber() { //reviewid = review뒤 숫자들 랜덤으로 생성
    return Math.floor(Math.random() * 999) + 1;
}

//평점 클릭 처리 함수
function handleRatingClick(rating) {
    var radios = document.getElementsByName('rating');
    for (var i = 0; i < radios.length; i++) {
        if (radios[i].value == rating) {
            radios[i].checked = true;
        } else {
            radios[i].checked = false;
        }
    }
}////평점 클릭 처리 함수 end

//파일 선택란에 추가 버튼 누를시 파일선택 버튼과 삭제버튼 생성
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
        this.parentNode.previousSibling.remove(); // 파일 입력란 제거
        this.parentNode.remove(); // 삭제 버튼 제거
    });

    span.appendChild(deleteBtn);

    uploadSection.appendChild(newInput);
    uploadSection.appendChild(span);

    uploadCount++;
});




/*
document.addEventListener('DOMContentLoaded', function() { 
	// Summernote 초기화
    $('.summernote').summernote({
        height: 300,
        lang: 'ko-KR',
        toolbar: [
            ['style', ['style']],
            ['font', ['bold', 'underline', 'clear']],
            ['color', ['color']],
            ['para', ['ul', 'ol', 'paragraph']],
            ['table', ['table']],
            ['insert', ['link', 'picture', 'video']],
            ['view', ['fullscreen', 'codeview', 'help']]
        ],
        callbacks: {
            onImageUpload: function(files) {
                sendFile(files[0]);
            }
        }
    }); //summernote end

    function sendFile(file) {
        var data = new FormData();
        data.append("file", file);
        $.ajax({
            url: '/review/uploadImage',
            method: 'POST',
            data: data,
            contentType: false,
            processData: false,
            success: function(url) {
                $('.summernote').summernote('insertImage', url);
            },
            error: function() {
                alert('이미지 업로드 중 오류가 발생하였습니다.');
            }
        });
    }// sendFile end
});
*/


</script>

</html>
