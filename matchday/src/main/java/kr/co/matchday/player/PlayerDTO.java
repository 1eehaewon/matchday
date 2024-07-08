package kr.co.matchday.player;

import java.sql.Timestamp;
import java.util.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class PlayerDTO {
	
	private String playerid;
	private String teamname;
	private String playername;
	private String position;
	private int    backnumber;
	private Date   birthdate;
	private String height;
	private String weight;
	private Date   joiningyear;
	private String birthplace;
	private String filename;
	private long   filesize;

}//class end
