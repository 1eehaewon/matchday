<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>

<div class="container">
    <div class="row">
        <div class="col-6">
            <h1>멤버쉽 등록</h1>
        </div>
        <div class="col-6 text-right">         
            <button type="button" class="btn btn-primary" onclick="location.href='list'">멤버쉽 전체 목록</button>               
        </div>
    </div>
    
    <div class="row">
        <div class="col-sm-12"> 
            <form name="membershipsfrm" id="membershipsfrm" method="post" action="/memberships/insert" enctype="multipart/form-data">
                <table class="table table-hover">
                    <tbody style="text-align: left;">
                        <tr>
                            <td>멤버쉽 이름</td>
                            <td><input type="text" name="membershipname" class="form-control"></td>
                        </tr>
                        <tr>
                            <td>멤버쉽 가격</td>
                            <td><input type="number" name="price" class="form-control"></td>
                        </tr>                    
                        <tr>
                            <td>멤버쉽 사용 시작 기간</td>
                            <td><input type="date" name="startdate" class="form-control" placeholder="yyyy-MM-dd"></td>
                        </tr>
                        <tr>
                            <td>멤버쉽 사용 종료 기간</td>
                            <td><input type="date" name="enddate" class="form-control" placeholder="yyyy-MM-dd"></td>
                        </tr>
                        <tr>
                            <td>멤버쉽 팀 로고</td>
                            <td><input type="file" name="img" class="form-control"></td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <input type="submit" value="멤버쉽 등록" class="btn btn-success"> 
                            </td>
                        </tr>   
                    </tbody> 
                </table>      
            </form>  
        </div><!-- col end -->
    </div><!-- row end -->
</div><!-- container end -->

<%@ include file="../footer.jsp" %>
