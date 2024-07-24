package kr.co.matchday.coupon;

import java.sql.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class CouponDTO {
	private String couponid;
	private String coupontypeid;
	private String userid;
	private String usage;
	private String couponname;
	private Date startdate;
	private Date enddate;
	private String applicableproduct;
	private int discountrate;
	private boolean isDownloaded;
	
}//class end
