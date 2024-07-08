<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>


<div class="row">
    <div class="col-sm-12 text-center">
        <p><h1>상세페이지</h1></p>
        <p>
            <button type="button" class="btn btn-primary" onclick="location.href='/instagram/list'">인스타그램 전체목록</button>
        </p>
    </div>
</div>

<div class="row">
    <div class="col-sm-12 text-center">
        <form name="instagramfrm" id="instagramfrm" method="post" action="/instagram/update">
            <table class="table table-hover">
                <tbody style="text-align: left;">
                   <tr>
                    <td>게시물 이름</td>
                    <td> <input type="text" name="instagram_name" value="${detail.instagram_name}" class="form-control"> </td>
                </tr>
                <tr>
                    <td>인스타그램 주소</td>
                    <td>
                        <input type="text" name="instagram_url" value="${detail.instagram_url}" class="form-control">
                    </td>
                </tr>       	                       							    
                    <tr>
                    <td colspan="2" align="center">
                        <input type="hidden" name="instagram_code" value="${detail.instagram_code}">
                        <button type="submit" class="btn btn-primary">수정완료</button>
                    </td>
                </tr>
                </tbody> 
            </table>	
        </form>
    </div>
</div>

<%@ include file="../footer.jsp" %>
