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
    private String matchid; // 경기 ID
    private String hometeamid; // 홈팀 ID
    private String awayteamid; // 원정팀 ID
    private String stadiumid; // 경기장 ID
    private Date matchdate; // 경기 날짜 및 시간
    private String referee; // 심판 이름
    private Date bookingstartdate; // 예매 시작 날짜 및 시간
    private Date bookingenddate; // 예매 종료 날짜 및 시간
    private String teamname; // 팀 이름 (추가 속성)
    private String stadiumname; // 경기장 이름 (추가 속성)
    private Date cancellationDeadline; // 경기 취소 마감일 (추가 속성)
}
