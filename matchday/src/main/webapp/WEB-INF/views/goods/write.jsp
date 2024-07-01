<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<style>
    /* 폼 요소를 가운데 정렬 */
    #goodsfrm {
        margin: 0 auto;
        max-width: 600px; /* 폼 요소의 최대 폭 설정 */
    }

    /* 폼 요소 내의 테이블 폭 조정 */
    .table {
        width: 100%;
    }
</style>

<div class="col-sm-12 text-center">
    <p><h1>상품등록</h1></p>
</div>

<!-- 본문 시작 main.jsp -->
<div>
    <div>
<<<<<<< HEAD
       		<form name="goodsfrm" id="goodsfrm" method="post" action="insert" enctype="multipart/form-data">
            <!-- <form name="goodsfrm" id="goodsfrm" method="post" action="/goods/update" enctype="multipart/form-data"> -->
=======
        <form name="goodsfrm" id="goodsfrm" method="post" action="/goods/insert" enctype="multipart/form-data">
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
            <table class="table table-hover">
                <tbody style="text-align: left;">
                    <tr>
                        <td>카테고리 ID</td>
                        <td>
                            <select name="category" class="form-control" id="category">
                                <option value="">카테고리 선택</option>
                                <option value="Uniform">Uniform</option>
                                <option value="Hairband">Hairband</option>
                                <option value="Stick">Stick</option>
                                <option value="Merplur">Merplur</option>
                                <option value="Keyring">Keyring</option>
                            </select>
                            <span id="categoryMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>굿즈 ID</td>
                        <td>
<<<<<<< HEAD
	                        <input type="text" name="goodsid" id="goodsid" class="form-control">
	                        <%-- <input type="text" name="goodsid" id="goodsid" class="form-control" value="${goods.goodsid}" readonly> --%>
	                        <span id="duplicateMsg" style="color: red;"></span>
	                    </td>
=======
                            <input type="text" name="goodsid" id="goodsid" class="form-control">
                            <span id="duplicateMsg" style="color: red;"></span>
                        </td>
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
                    </tr>
                    <tr>
                        <td>상품명</td>
                        <td>
<<<<<<< HEAD
                        	<input type="text" name="productname" id="productname" class="form-control" id="goodsid">
                            <%-- <input type="text" name="productname" id="productname" class="form-control" value="${goods.productname}"> --%>
=======
                            <input type="text" name="productname" id="productname" class="form-control">
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
                            <span id="productnameMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>상품 사진</td>
                        <td>
                            <input type="file" name="img" id="img"class="form-control">
                            <span id="imgMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>설명</td>
<<<<<<< HEAD
                        <td><textarea rows="5" name="description" id="description" class="form-control"></textarea></td>
                    	<%-- <td><textarea rows="5" name="description" id="description" class="form-control">${goods.description}</textarea></td> --%>
=======
                        <td><textarea rows="5" name="description" id="description" class="form-control summernote"></textarea></td>
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
                    </tr>
                    <tr>
                        <td>사이즈</td>
                        <td>
                            <select name="size" id="size" class="form-control">
                                <option value="">사이즈 선택</option>
                                <option value="FREE">FREE</option>
<<<<<<< HEAD
					            <option value="S">Small</option>
					            <option value="M">Medium</option>
					            <option value="L">Large</option>
					            <option value="XL">XLarge</option>
					            <%-- <option value="FREE" <c:if test="${goods.size == 'FREE'}">selected</c:if>>FREE</option>
                                <option value="S" <c:if test="${goods.size == 'S'}">selected</c:if>>Small</option>
                                <option value="M" <c:if test="${goods.size == 'M'}">selected</c:if>>Medium</option>
                                <option value="L" <c:if test="${goods.size == 'L'}">selected</c:if>>Large</option>
                                <option value="XL" <c:if test="${goods.size == 'XL'}">selected</c:if>>XLarge</option> --%>
=======
                                <option value="S">Small</option>
                                <option value="M">Medium</option>
                                <option value="L">Large</option>
                                <option value="XL">XLarge</option>
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
                            </select>
                            <span id="sizeMsg" style="color: red;"></span>
                        </td>
                    </tr>
                    <tr>
                        <td>가격</td>
                        <td>
<<<<<<< HEAD
                        	<input type="number" name="price" id="price" class="form-control">
                        	<%-- <input type="number" name="price" id="price" class="form-control" value="${goods.price}"> --%>
                        	<span id="priceMsg" style="color: red;"></span>
=======
                            <input type="number" name="price" id="price" class="form-control">
                            <span id="priceMsg" style="color: red;"></span>
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
                        </td>
                    </tr>
                    <tr>
                        <td>재고 수량</td>
                        <td>
<<<<<<< HEAD
                        	<input type="number" name="stockquantity" id="stockquantity" class="form-control">
                        	<%-- <input type="number" name="stockquantity" id="stockquantity" class="form-control" value="${goods.stockquantity}"> --%>
                        	<span id="stockquantityMsg" style="color: red;"></span>
=======
                            <input type="number" name="stockquantity" id="stockquantity" class="form-control">
                            <span id="stockquantityMsg" style="color: red;"></span>
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
                        </td>
                    </tr>
                    <tr>
                        <td>품절 여부</td>
                        <td>
                            <label><input type="radio" name="issoldout" value="N"> 재고 있음</label>
                            <label><input type="radio" name="issoldout" value="Y"> 품절</label>
                            <%-- <label><input type="radio" name="issoldout" value="N" <c:if test="${goods.issoldout == 'N'}">checked</c:if>> 재고 있음</label>
                            <label><input type="radio" name="issoldout" value="Y" <c:if test="${goods.issoldout == 'Y'}">checked</c:if>> 품절</label> --%>
                            <span id="issoldoutMsg" style="color: red;"></span>
                    </tr>
                    <tr>
                        <td colspan="2" style="text-align: center;">
                            <input type="submit" value="상품등록">
                            <input type="submit" value="상품수정">
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

        function validateForm() {
            var isValid = true;

            // Category validation
            var category = document.getElementById('category').value;
            var categoryMsg = document.getElementById('categoryMsg');
            if (category === "") {
                categoryMsg.textContent = '카테고리를 선택해주세요.';
                isValid = false;
            } else {
                categoryMsg.textContent = '';
            }

            // Goods ID validation (including duplicate check)
            var goodsid = document.getElementById('goodsid').value;
            var duplicateMsg = document.getElementById('duplicateMsg');
            if (goodsid === "") {
                duplicateMsg.textContent = '굿즈 ID를 입력해주세요.';
                isValid = false;
            } else {
                duplicateMsg.textContent = '';
            }

            // Product name validation
            var productname = document.getElementById('productname').value;
            var productnameMsg = document.getElementById('productnameMsg');
            if (productname.length < 2) {
                productnameMsg.textContent = '상품명은 2글자 이상이어야 합니다.';
                isValid = false;
            } else {
                productnameMsg.textContent = '';
            }

            // Image validation
            var img = document.getElementById('img').value;
            var imgMsg = document.getElementById('imgMsg');
            if (img === "") {
                imgMsg.textContent = '상품 사진을 선택해주세요.';
                isValid = false;
            } else {
                imgMsg.textContent = '';
            }

<<<<<<< HEAD
	    // Event listener for goods ID blur (to check for duplicates)
	    document.getElementById('goodsid').addEventListener('blur', function() {
	        var goodsid = this.value.trim(); // Trim to remove leading/trailing whitespace
	        if (goodsid !== "") {
	            checkDuplicateGoodsId(goodsid);
	        }
	    });
});
	
=======
            // Size validation
            var size = document.getElementById('size').value;
            var sizeMsg = document.getElementById('sizeMsg');
            if (size === "") {
                sizeMsg.textContent = '사이즈를 선택해주세요.';
                isValid = false;
            } else {
                sizeMsg.textContent = '';
            }

            // Price validation
            var price = document.getElementById('price').value;
            var priceMsg = document.getElementById('priceMsg');
            if (price === "" || price <= 0) {
                priceMsg.textContent = '가격을 입력해주세요 (0 이상).';
                isValid = false;
            } else {
                priceMsg.textContent = '';
            }

            // Stock quantity validation
            var stockquantity = document.getElementById('stockquantity').value;
            var stockquantityMsg = document.getElementById('stockquantityMsg');
            if (stockquantity === "" || stockquantity < 0) {
                stockquantityMsg.textContent = '재고 수량을 입력해주세요 (0 이상).';
                isValid = false;
            } else {
                stockquantityMsg.textContent = '';
            }

            // Radio button validation
            var issoldoutChecked = document.querySelector('input[name="issoldout"]:checked');
            var issoldoutMsg = document.getElementById('issoldoutMsg');
            if (!issoldoutChecked) {
                issoldoutMsg.textContent = '품절 여부를 선택해주세요.';
                isValid = false;
            } else {
                issoldoutMsg.textContent = '';
            }

            // If form is not valid, prevent submission
            if (!isValid) {
                event.preventDefault();
            }

            return isValid;
        }

        // Event listener for form submission
        form.addEventListener('submit', function(event) {
            if (!validateForm()) {
                event.preventDefault(); // Prevent form submission if validation fails
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
        });

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
        }
    });
>>>>>>> branch 'master' of https://github.com/seungyeon829/matchday-project.git
</script>

<%@ include file="../footer.jsp" %>
