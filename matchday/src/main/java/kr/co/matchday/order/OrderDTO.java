package kr.co.matchday.order;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class OrderDTO {

	private String orderid; // 주문 ID
    private String userid; // 사용자 ID
    private String goodsid; //굿즈 ID
    private Timestamp orderdate; // 주문 날짜
    /*private Timestamp orderdate; // 주문 날짜*/
    private String orderstatus; // 주문 상태 ('Pending', 'Completed')
    private String couponid; // 쿠폰 ID
    private int usedpoints; // 사용한 포인트
    private int finalpaymentamount; // 최종 결제 금액
    private Timestamp shippingstartdate; // 배송 시작 날짜
    private Timestamp shippingenddate; // 배송 종료 날짜
    /*private Timestamp shippingstartdate; // 배송 시작 날짜
    private Timestamp shippingenddate; // 배송 종료 날짜*/
    private String shippingstatus; // 배송 상태 ('Pending', 'Completed')
    private String recipientname; // 수령인 이름
    private String shippingaddress; // 배송 주소
    private String shippingrequest; // 배송 요청사항
    private String paymentmethodcode; // 결제 방법 코드
    private int price; // 가격
    private int quantity; // 수량
    private String receiptmethodcode; // 수령 방법 코드
	
}//class end
