<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ include file="../header.jsp" %>

<div class="container">
    <div class="row">
        <div class="col-6">
            <h1>멤버쉽 수정</h1>
        </div>
        <div class="col-6 text-right">
            <button type="button" class="btn btn-primary" onclick="location.href='list'">멤버쉽 전체 목록</button>
        </div>
    </div>
    
    <div class="row">
        <div class="col-sm-12">
            <form name="membershipsfrm" id="membershipsfrm" method="post" action="/memberships/updateproc" enctype="multipart/form-data">
                <input type="hidden" name="membershipid" value="${memberships.membershipid}" />
                <table class="table table-hover">
                    <tbody style="text-align: left;">
                        <tr>
                            <td>멤버쉽 이름</td>
                            <td><input type="text" name="membershipname" class="form-control" value="${memberships.membershipname}"></td>
                        </tr>
                        <tr>
                            <td>멤버쉽 가격</td>
                            <td><input type="text" name="price" class="form-control" value="${memberships.price}"></td>
                        </tr>                      
                        <tr>
                            <td>멤버쉽 사용 시작 기간</td>
                            <td><input type="date" name="startdate" class="form-control" value="<fmt:formatDate value='${memberships.startdate}' pattern='yyyy-MM-dd' />"></td>
                        </tr>
                        <tr>
                            <td>멤버쉽 사용 종료 기간</td>
                            <td><input type="date" name="enddate" class="form-control" value="<fmt:formatDate value='${memberships.enddate}' pattern='yyyy-MM-dd' />"></td>
                        </tr>
                        <tr>
                            <td>멤버쉽 팀 로고</td>
                            <td>
                                <input type="file" name="img" class="form-control">
                                <c:if test="${memberships.filename != '-'}">
                                    <img src="../storage/memberships/${memberships.filename}" class="img-responsive margin" style="width:100%">
                                </c:if>
                            </td>
                        </tr>
                        <tr>
                            <td colspan="2" align="center">
                                <input type="submit" value="수정" class="btn btn-success">
                            </td>
                        </tr>
                    </tbody>
                </table>
            </form>
        </div><!-- col end -->
    </div><!-- row end -->
</div><!-- container end -->

<%@ include file="../footer.jsp" %>
