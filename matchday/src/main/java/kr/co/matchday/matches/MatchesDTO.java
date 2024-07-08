package kr.co.matchday.matches;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;
import java.util.Date;

/**
 * 경기 정보를 담고 있는 데이터 전송 객체 (DTO)
 */
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
    private String referee;
    private Date bookingstartdate;
    private Date bookingenddate;
    private String teamname;
    private String stadiumname;
    private Date cancellationDeadline; // 새로운 속성 추가
}
