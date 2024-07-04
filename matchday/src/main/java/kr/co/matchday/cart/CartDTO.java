package kr.co.matchday.cart;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class CartDTO {

	private int cartid; //장바구니 번호
    private String userid;	//회원 아이디
    private String goodsid;	// 굿즈 아이디
    private int quantity;	// 수량
    private int unitprice;	// 가격
    private int totalprice; // 총 금액
    
}//class end
