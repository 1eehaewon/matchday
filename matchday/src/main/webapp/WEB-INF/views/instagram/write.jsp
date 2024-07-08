<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="row">
    <div class="col-6">
        <h1>인스타그램 게시글 등록</h1>
    </div>
    <div class="col-6 text-right">
        <button type="button" class="btn btn-success" onclick="location.href='list'">인스타그램 목록</button>
    </div>
</div><!-- row end -->

<div class="row">
    <div class="col-sm-12 text-center">
        <form name="instagramfrm" id="instagramfrm" method="post" action="insert">
    <table class="table table-hover">
        <tbody style="text-align: left;">
            <tr>
                <td>게시물 이름</td>
                <td><input type="text" name="instagram_name" class="form-control"></td>
            </tr>
            <tr>
                <td>인스타그램 주소</td>
                <td><input type="text" name="instagram_url" class="form-control"></td>
            </tr>
            <tr>
                <td colspan="2" align="center">
                    <input type="submit" value=" 인스타그램 등록" class="btn btn-success">
                </td>
            </tr>
        </tbody>
    </table>
</form>
    </div><!-- col end -->
</div><!-- row end -->

<%@ include file="../footer.jsp" %>
