package kr.co.matchday.order;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class OrderdetailDTO {

	private int orderdetailid;	//주문 상세 ID
    private String orderid;	// 주문 ID
    private String goodsid; //굿즈 ID
    private int quantity;	// 수량
    private int price;	// 가격
    private int totalamount;	// 총 결제 금액
    private boolean iscanceled;	// 취소 여부
    private boolean isrefunded;	// 환불 여부
    private boolean isexchanged;	// 교환 여부
    private String canceldate;	// 취소 일자
    private String exchangedate;	// 교환 일자
    private String refunddate;	// 환불 일자
    /*
    private Timestamp cancelDate;
    private Timestamp exchangeDate;
    private Timestamp refundDate;
	*/
}//class end
