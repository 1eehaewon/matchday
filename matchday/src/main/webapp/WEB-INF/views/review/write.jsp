<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html lang="ko">
<head>
    <meta charset="UTF-8">
    <title>상품 후기 쓰기</title>
    <!-- 부트스트랩 CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f2f2f2;
            padding: 20px;
        }
        .board_write_popup {
            max-width: 800px;
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
    </style>
</head>
<body class="body-board body-popup-goods-board-write pc">
    <div class="board_write_popup">
        <div class="ly_tit">
            <h4>상품 후기 쓰기</h4>
        </div>
        <div class="ly_cont">
            <form name="frmWrite" id="frmWrite" action="../board/board_ps.php" method="post" enctype="multipart/form-data">
                <input type="hidden" name="gboard" value="y"/>
                <input type="hidden" name="windowType" value="popup"/>
                <input type="hidden" name="bdId" value="goodsreview"/>
                <input type="hidden" name="sno" value=""/>
                <input type="hidden" name="mode" value="write"/>
                <input type="hidden" name="goodsNo" value="1000000296"/>
                <input type="hidden" name="returnUrl" value="bdId=goodsreview&goodsNo=1000000296&orderGoodsNo=0"/>

                <div class="scroll_box">
                    <div class="top_item_photo_info">
                        <div class="item_photo_box">
                            <img src="https://godomall.speedycdn.net/3a69e4757b9ebccf29e8a5d1f2a70610/goods/1000000296/image/detail/1000000296_detail_080.png" width="500" alt="2024 스틸러스 원정 유니폼" title="2024 스틸러스 원정 유니폼" class="middle">
                        </div>
                        <br>
                        <div class="item_info_box">
                            <h5>2024 스틸러스 원정 유니폼</h5>
                        </div>
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
                                        <input type="text" name="writerNm" class="form-control" placeholder="작성자 입력">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">비밀번호</th>
                                    <td>
                                        <input type="password" name="writerPw" class="form-control" placeholder="비밀번호 입력">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">제목</th>
                                    <td>
                                        <input type="text" name="subject" class="form-control write_title" placeholder="제목 입력">
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">내용</th>
                                    <td class="write_editor">
                                        <div class="form_element">
                                            <input type="checkbox" name="isSecret" value="y" id="secret">
                                            <label for="secret" class="check_s">비밀글</label>
                                        </div>
                                        <textarea title="내용 입력" id="editor" class="form-control" name="contents" rows="5" placeholder="내용을 입력하세요"></textarea>
                                    </td>
                                </tr>
                                <tr>
                                    <th scope="row">파일</th>
                                    <td id="uploadBox">
                                        <div class="file_upload_sec">
                                            <label for="attach"><input type="text" class="file_text form-control" readonly="readonly" placeholder="파일 첨부하기"></label>
                                            <div class="btn_upload_box">
                                                <button type="button" class="btn btn-outline-secondary btn_upload" title="찾아보기"><em>찾아보기</em></button>
                                                <input type="file" id="attach" name="upfiles[]" class="file" title="찾아보기">
                                                <span class="btn_gray_list">
                                                    <button type="button" id="addUploadBtn" class="btn btn-outline-secondary btn_gray_big"><span>+ 추가</span></button>
                                                </span>
                                            </div>
                                        </div>
                                    </td>
                                </tr>
                            </tbody>
                        </table>
                    </div>
                    <!-- //board_write_box -->
                </div>
                <!-- //scroll_box -->
            </form>
            <div class="btn_center_box">
                <a href="javascript:window.close()" class="btn btn-secondary btn_ly_cancel"><strong>취소</strong></a>
                <a href="javascript:save()" class="btn btn-primary btn_ly_write_ok"><strong>등록</strong></a>
            </div>
        </div>
        <!-- //ly_cont -->
    </div>
    <!-- //board_write_popup -->
</body>
</html>
