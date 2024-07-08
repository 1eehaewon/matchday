package kr.co.matchday.team;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class TeamDTO {
	
	private String teamname;
	private String koreanname;
	private String stadiumid;
	private String foundingyear;
	private String coach;
	private String city;
	private String introduction;
	private String leaguecategory;
	private String filename;
	private long   filesize;

}//class end
