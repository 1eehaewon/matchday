package kr.co.matchday.point;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class PointHistoryDTO {
	private int pointhistoryid;
	private String userid;
	private String pointcategoryid;
	private String pointtype; //Accumulage or Use
	private String reviewid;
	private String pointsource;
	private int pointamount;
	private Timestamp pointcreationdate;
	private Timestamp pointusedate;
	private String reservationid;
}//class end
