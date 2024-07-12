<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<%@ include file="../header.jsp" %>
<style>
        /* Reset CSS */
* {
    margin: 0;
    padding: 0;
    box-sizing: border-box;
}

body {
    font-family: Arial, sans-serif;
    background-color: #f0f0f0;
    padding: 20px;
}

.container {
    max-width: 800px;
    margin: 0 auto;
    background-color: #fff;
    padding: 20px;
    border-radius: 8px;
    box-shadow: 0 0 10px rgba(0, 0, 0, 0.1);
}

h1, h2 {
    font-size: 24px;
    margin-bottom: 20px;
}

.order-section,
.customer-section,
.shipping-section,
.payment-section,
.payment-method-section {
    border-top: 1px solid #ddd;
    padding-top: 20px;
    margin-top: 20px;
}

.order-details {
    margin-bottom: 20px;
}

.product-info {
    margin-bottom: 10px;
}

.product-name {
    font-weight: bold;
}

.product-options {
    color: #666;
}

.quantity,
.price,
.discount,
.total,
.shipping {
    margin-bottom: 10px;
}

.total-amount {
    text-align: right;
    font-weight: bold;
    font-size: 18px;
    margin-bottom: 20px;
}

form {
    margin-bottom: 20px;
}

form label {
    display: block;
    margin-bottom: 5px;
}

form input[type="text"],
form input[type="email"],
form input[type="tel"],
form textarea,
form input[type="radio"] {
    width: 100%;
    padding: 10px;
    font-size: 16px;
    border: 1px solid #ddd;
    border-radius: 4px;
    margin-bottom: 10px;
}

form input[type="radio"] {
    margin-right: 10px;
}

.checkout-button {
    text-align: center;
}

.checkout-button button {
    padding: 10px 20px;
    background-color: #4CAF50;
    color: #fff;
    border: none;
    border-radius: 4px;
    cursor: pointer;
    font-size: 16px;
}

.checkout-button button:hover {
    background-color: #45a049;
}

    </style>
<!-- 본문 시작 payment.jsp -->
<div class="container">
        <h1>주문 및 결제</h1>

        <!-- 주문상세내역 -->
        <section class="order-section">
            <h2>주문상세내역</h2>
            <div class="order-details">
                <div class="product-info">
                    <p class="product-name">2024 스틸러스 원정 유니폼</p>
                    <p class="product-options">사이즈: L (100)</p>
                </div>
                <div class="quantity">
                    <p>수량: 1개</p>
                </div>
                <div class="price">
                    <p>상품금액: 99,000원</p>
                </div>
                <div class="discount">
                    <p>할인/적립: -</p>
                </div>
                <div class="total">
                    <p>합계금액: 99,000원</p>
                </div>
                <div class="shipping">
                    <p>배송비: 3,000원</p>
                </div>
            </div>
            <div class="total-amount">
                <p>총 결제 금액: 102,000원</p>
            </div>
        </section>

        <!-- 주문자 정보 -->
        <section class="customer-section">
            <h2>주문자 정보</h2>
            <form action="">
                <label for="name">이름</label>
                <input type="text" id="name" name="name" required>
                <label for="email">이메일</label>
                <input type="email" id="email" name="email" required>
                <label for="phone">전화번호</label>
                <input type="tel" id="phone" name="phone" required>
            </form>
        </section>

        <!-- 배송 정보 -->
        <section class="shipping-section">
            <h2>배송 정보</h2>
            <form action="">
                <label for="address">배송 주소</label>
                <input type="text" id="address" name="address" required>
                <label for="notes">배송 시 요청 사항</label>
                <textarea id="notes" name="notes" rows="4"></textarea>
            </form>
        </section>

        <!-- 결제 정보 -->
        <section class="payment-section">
            <h2>결제 정보</h2>
            <form action="">
                <label for="card-number">카드 번호</label>
                <input type="text" id="card-number" name="card-number" required>
                <label for="expiry-date">만료 일자</label>
                <input type="text" id="expiry-date" name="expiry-date" required>
                <label for="cvv">CVV</label>
                <input type="text" id="cvv" name="cvv" required>
            </form>
        </section>

        <!-- 결제 방법 선택 -->
        <section class="payment-method-section">
            <h2>결제 방법 선택</h2>
            <form action="">
                <input type="radio" id="credit-card" name="payment-method" value="credit-card" checked>
                <label for="credit-card">신용카드 결제</label><br>
                <input type="radio" id="bank-transfer" name="payment-method" value="bank-transfer">
                <label for="bank-transfer">계좌 이체</label><br>
                <input type="radio" id="paypal" name="payment-method" value="paypal">
                <label for="paypal">페이팔</label>
            </form>
        </section>

        <!-- 결제하기 버튼 -->
        <div class="checkout-button">
            <button type="button">결제하기</button>
        </div>
    </div>
<!-- 본문 끝 -->

<%@ include file="../footer.jsp" %>