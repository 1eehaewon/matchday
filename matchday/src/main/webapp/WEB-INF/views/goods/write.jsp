<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>
<meta name="viewport" content="width=device-width, initial-scale=1.0">

<style>
    /* 폼 요소를 가운데 정렬 */
	#goodsfrm {
        margin: 0 auto;
        max-width: 1200px; /* 폼 요소의 최대 폭 설정 */
        padding: 20px; /* 추가 패딩 */
    }

    /* 기본적인 테이블 스타일 */
    table {
        width: 100%; /* 테이블 전체 너비 설정 */
        border-collapse: collapse; /* 테이블 경계선을 합침 */
        margin-bottom: 20px; /* 테이블 아래 여백 설정 */
    }
    
    th {
        background-color: #f2f2f2; /* 테이블 헤더 배경색 설정 */
        font-size: 18px; /* 헤더 글자 크기 설정 */
        font-weight: bold; /* 헤더 글자 굵기 설정 */
        width: 12%; /* 원하는 너비로 설정 */
    }
    
    /* 작은 화면에 대한 조정 */
	@media (max-width: 768px) {
	    #goodsfrm {
	        padding: 0 10px; /* 패딩을 좌우로 10px씩 추가합니다. */
	    }
	    .table {
	        font-size: 14px; /* 글자 크기를 14px로 줄입니다. */
	    }
	}
    
</style>

<div class="col-sm-12 text-center">
    <p><h1>상품등록</h1></p>
</div>

<!-- 본문 시작 write.jsp -->
<div>
    <div>
        <form name="goodsfrm" id="goodsfrm" method="post" action="/goods/insert" enctype="multipart/form-data">
            <table class="table table-hover">
                <tbody style="text-align: left;">
                    <tr>
                        <th>카테고리 ID</th>
                        <td>
                            <select name="category" class="form-control" id="category">
                                <option value="">카테고리 선택</option>
                                <option value="Uniform">Uniform</option>
                                <option value="Cap">Cap</option>
                                <option value="Bag">Bag</option>
                                <option value="Muffler">Muffler</option>
                                <option value="Keyring">Keyring</option>
                                <option value="Soccerball">Soccerball</option>
                            </select>
                            <span id="categoryMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>굿즈 ID</th>
                        <td>
                            <input type="text" name="goodsid" id="goodsid" class="form-control" readonly>
                            <span id="duplicateMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>상품명</th>
                        <td>
                            <input type="text" name="productname" id="productname" class="form-control">
                            <span id="productnameMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>상품 사진</th>
                        <td>
                            <input type="file" name="img" id="img"class="form-control">
                            <span id="imgMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>설명</th>
                        <td><textarea rows="5" name="description" id="description" class="form-control summernote"></textarea></td>
                    </tr>
                    <tr>
                        <th>상품 주의사항</th>
                        <td><textarea rows="5" name="caution" id="caution" class="form-control summernote"></textarea></td>
                    </tr>
                    <tr>
                        <th>배송/반품/교환</th>
                        <td><textarea rows="5" name="deliveryreturnsexchangesinfo" id="deliveryreturnsexchangesinfo" class="form-control summernote"></textarea></td>
                    </tr>
                    <%-- <tr>
                        <th>사이즈</th>
                        <td>
                            <select name="size" id="size" class="form-control">
<!--                                 <option value="">사이즈 선택</option>
                                <option value="FREE">FREE</option>
                                <option value="S">Small</option>
                                <option value="M">Medium</option>
                                <option value="L">Large</option>
                                <option value="XL">XLarge</option>
                                 -->
                                <option value="">사이즈 선택</option>
                                <option value="FREE" <c:if test="${goodsDto.size == 'FREE'}">selected</c:if>>FREE</option>
                                <option value="S" <c:if test="${goodsDto.size == 'S'}">selected</c:if>>Small</option>
                                <option value="M" <c:if test="${goodsDto.size == 'M'}">selected</c:if>>Medium</option>
                                <option value="L" <c:if test="${goodsDto.size == 'L'}">selected</c:if>>Large</option>
                                <option value="XL" <c:if test="${goodsDto.size == 'XL'}">selected</c:if>>XLarge</option>
                            </select>
                            <span id="sizeMsg" style="color: red;"></span>
                        </td>
                    </tr> --%>
                    <tr>
                        <th>가격</th>
                        <td>
                            <input type="number" name="price" id="price" class="form-control">
                            <span id="priceMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <th>사이즈 / 재고 수량</th>
                        <td>
                        	<a> FREE : </a>
                        	<input type="hidden" name="size1" id="size" class="form-control" value="FREE">
                            <input type="number" name="stockquantity1" id="stockquantity" class="form-control" value="0">
                            <span id="stockquantityMsg" style="color: red;"></span>
                            
                            <a> S : </a>
                        	<input type="hidden" name="size2" id="size" class="form-control" value="S">
                            <input type="number" name="stockquantity2" id="stockquantity" class="form-control" value="0">
                            <span id="stockquantityMsg" style="color: red;"></span>
                            
                            <a> M : </a>
                        	<input type="hidden" name="size3" id="size" class="form-control" value="M">
                            <input type="number" name="stockquantity3" id="stockquantity" class="form-control" value="0">
                            <span id="stockquantityMsg" style="color: red;"></span>
                            
                            <a> L : </a>
                        	<input type="hidden" name="size4" id="size" class="form-control" value="L">
                            <input type="number" name="stockquantity4" id="stockquantity" class="form-control" value="0">
                            <span id="stockquantityMsg" style="color: red;"></span>
                            
                            <a> XL : </a>
                        	<input type="hidden" name="size5" id="size" class="form-control" value="XL">
                            <input type="number" name="stockquantity5" id="stockquantity" class="form-control" value="0">
                            <span id="stockquantityMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <input type="submit" value="상품등록" class="btn btn-success">
                        </td>
                    </tr>
                </tbody>
            </table>
        </form>
    </div>
</div>
<!-- 본문 끝 -->

<script>
	document.addEventListener('DOMContentLoaded', function() {
	    var form = document.getElementById('goodsfrm');

	 // 굿즈 ID 생성 함수
	    function generateUniqueGoodsId() {
	        var prefix = 'goods';
	        var num;
	        var existingIds = []; // 기존 굿즈 아이디 리스트 (실제 사용하시는 데이터를 가져와야 합니다)

	        // 기존 아이디들을 배열에 추가 (실제로는 서버에서 기존 데이터를 가져와야 함)
	        <c:forEach items="${goodsList}" var="goods">
	            existingIds.push('${goods.goodsid}');
	        </c:forEach>

	        // 중복되지 않는 아이디 생성
	        do {
	            num = generateRandomNumber(); // 랜덤 숫자 생성 함수 호출
	            var newId = prefix + num.toString().padStart(3, '0'); // 3자리 숫자로 포맷
	        } while (existingIds.includes(newId)); // 생성된 아이디가 기존 아이디들과 중복되는지 확인

	        return newId;
	    }

	    // 랜덤 숫자 생성 함수
	    function generateRandomNumber() {
	        return Math.floor(Math.random() * 999) + 1;
	    }

	    // 굿즈 ID 설정
	    document.getElementById('goodsid').value = generateUniqueGoodsId();
	    
        function validateForm() {
            var isValid = true;

            // 카테고리 유효성 검사
            var category = document.getElementById('category').value;
            var categoryMsg = document.getElementById('categoryMsg');
            if (category === "") {
                categoryMsg.textContent = '카테고리를 선택해주세요.';
                isValid = false;
            } else {
                categoryMsg.textContent = '';
            }

            // 굿즈 ID 유효성 검사 (중복 검사 포함)
            var goodsid = document.getElementById('goodsid').value;
            var duplicateMsg = document.getElementById('duplicateMsg');
            if (goodsid === "") {
                duplicateMsg.textContent = '굿즈 ID를 입력해주세요.';
                isValid = false;
            } else {
                duplicateMsg.textContent = '';
            }

            // 상품명 유효성 검사
            var productname = document.getElementById('productname').value;
            var productnameMsg = document.getElementById('productnameMsg');
            if (productname.length < 2) {
                productnameMsg.textContent = '상품명은 2글자 이상이어야 합니다.';
                isValid = false;
            } else {
                productnameMsg.textContent = '';
            }

            // 상품 사진 유효성 검사
            var img = document.getElementById('img').value;
            var imgMsg = document.getElementById('imgMsg');
            if (img === "") {
                imgMsg.textContent = '상품 사진을 선택해주세요.';
                isValid = false;
            } else {
                imgMsg.textContent = '';
            }

            // 사이즈 유효성 검사
            /* var size = document.getElementById('size').value;
            var sizeMsg = document.getElementById('sizeMsg');
            if (size === "NO") {
                sizeMsg.textContent = '사이즈를 선택해주세요.';
                isValid = false;
            } else {
                sizeMsg.textContent = '';
            } */

            // 가격 유효성 검사
            var price = document.getElementById('price').value;
            var priceMsg = document.getElementById('priceMsg');
            if (price === "" || price <= 0) {
                priceMsg.textContent = '가격을 입력해주세요 (0 이상).';
                isValid = false;
            } else {
                priceMsg.textContent = '';
            }

            // 재고 수량 유효성 검사
            var stockquantity = document.getElementById('stockquantity').value;
            var stockquantityMsg = document.getElementById('stockquantityMsg');
            if (stockquantity === "" || stockquantity < 0) {
                stockquantityMsg.textContent = '재고 수량을 입력해주세요 (0 이상).';
                isValid = false;
            } else {
                stockquantityMsg.textContent = '';
            }

            // 폼이 유효하지 않으면 제출 방지
            if (!isValid) {
                event.preventDefault();
            }

            return isValid;
        }

        // 폼 제출 이벤트 리스너
        form.addEventListener('submit', function(event) {
            if (!validateForm()) {
                event.preventDefault(); // 유효성 검사 실패 시 제출 방지
            }
        });

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
                url: '/goods/uploadImage',
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
    }); //document.addEventListener('DOMContentLoaded', function() end
    
</script>

<%@ include file="../footer.jsp" %>
