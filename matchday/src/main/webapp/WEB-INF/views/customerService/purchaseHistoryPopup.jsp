<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>구매 내역</title>
    <link rel="stylesheet" href="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/css/bootstrap.min.css">
    <script src="https://code.jquery.com/jquery-3.5.1.min.js"></script>
    <script src="https://stackpath.bootstrapcdn.com/bootstrap/4.5.2/js/bootstrap.min.js"></script>
</head>
<body>
    <div class="container">
        <div class="row justify-content-center">
            <div class="col-lg-8">
                <div class="card shadow-card border-0 rounded-lg mt-5">
                    <div class="card-header custom-card-header">
                        <h2 class="mb-0 fw-bold">구매 내역</h2>
                    </div>
                    <div class="card-body p-5">
                        <table class="table table-bordered">
                            <thead>
                                <tr>
                                    <th>상품명</th>
                                    <th>주문일자</th>
                                    <th>선택</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="item" items="${purchaseList}">
                                    <tr>
                                        <td>${item.reservationid}</td>
                                        <td>${item.reservationdate}</td>
                                        <td>
                                            <button class="btn btn-primary" onclick="selectReservation('${item.reservationid}')">선택</button>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <script>
        function selectReservation(reservationid) {
            window.opener.document.getElementById('referenceID').value = reservationid;
            window.close();
        }
    </script>
</body>
</html>
