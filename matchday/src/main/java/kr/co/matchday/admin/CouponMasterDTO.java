package kr.co.matchday.admin;

import java.sql.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class CouponMasterDTO {
	private String coupontypeid;
	private String couponname;
	private int discountrate;
	private int issuecount;
	private Date startdate;
	private Date enddate;
	private boolean downloaded;
	private String applicableproduct;
}
