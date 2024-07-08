<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="row">
    <div class="col-sm-12 text-center">
        <p><h1>상세페이지</h1></p>
        <p>
            <button type="button" class="btn btn-primary" onclick="location.href='/video/list'">하이라이트 전체목록</button>
        </p>
    </div>
</div>

<div class="row">
    <div class="col-sm-12 text-center">
        <form name="videofrm" id="videofrm" method="post" action="/video/updateproc">
            <table class="table table-hover">
                <tbody style="text-align: left;">
                    <tr>
                        <td>하이라이트 이름</td>
                        <td>
                            <input type="text" name="video_name" value="${detail.video_name}" class="form-control">
                        </td>
                    </tr>
                    <tr>
                        <td>하이라이트 주소</td>
                        <td>
                            <input type="text" name="video_url" value="${detail.video_url}" class="form-control">
                        </td>
                    </tr>		    
                    <tr>
                        <td>하이라이트 내용</td>
                        <td>
                            <input type="text" name="description" value="${detail.description}" class="form-control">
                        </td>
                    </tr>								    
                    <tr>
                        <td colspan="2" align="center">
                            <input type="hidden" name="video_code" value="${detail.video_code}">
                            <button type="submit" class="btn btn-primary">수정완료</button>  
                        </td>
                    </tr>   
                </tbody> 
            </table>	
        </form>
    </div>
</div>

<%@ include file="../footer.jsp" %>
