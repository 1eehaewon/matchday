package kr.co.matchday.matches;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import java.util.Date;

@NoArgsConstructor
@Getter
@Setter
@ToString 
public class MatchesDTO {
	
    private String matchid;
    private String hometeamid;
    private String awayteamid;
    private String stadiumid;
    private Date matchdate;
    private int matchtime;
    private String referee;
    private Date bookingstartdate;
    private Date bookingenddate;
    
}//class end

