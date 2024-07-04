package kr.co.matchday.carts;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class CartsDTO {

	private Integer cartID; //장바구니 번호
    private String userID;	//회원 아아디
    private String goodsID;	// 굿즈 아이디
    private Integer quantity;	// 수량
    private Integer unitPrice;	// 가격
    private Integer totalPrice; // 총 금액
    
}//class end
