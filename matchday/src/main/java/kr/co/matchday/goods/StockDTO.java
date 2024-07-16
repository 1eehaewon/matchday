package kr.co.matchday.goods;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class StockDTO {

	private String size;
	private String goodsid;
	private int stockquantity;
	
}//class end
