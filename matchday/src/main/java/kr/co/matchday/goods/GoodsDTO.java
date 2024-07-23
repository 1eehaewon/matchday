package kr.co.matchday.goods;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class GoodsDTO {

	private String goodsid; // 굿즈 ID
	private String category; // 굿즈 카테고리
	private String productname; // 상품명
	private String description; // 설명
	//private String size; // 사이즈
	private int price; // 가격
	//private int stockquantity; // 재고 수량
	/* private char issoldout; */
	private String issoldout; // 품절 여부	
	private String filename; // 파일 이름
	private long filesize; // 파일 크기	
	private Timestamp regdate; // 등록일
    private String caution; // 주의사항
    private String deliveryreturnsexchangesinfo; // 배송/환불/교환안내

}//class end
