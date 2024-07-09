package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MatchesService {

    @Autowired
    private MatchesDAO matchesDAO; // MatchesDAO 주입

    // 모든 팀의 이름을 가져오는 메서드
    public List<String> getAllTeams() {
        return matchesDAO.getAllTeams().stream()
                         .map(team -> (String) team.get("teamname"))
                         .collect(Collectors.toList());
    }

    // 모든 경기장의 ID를 가져오는 메서드
    public List<String> getAllStadiums() {
        return matchesDAO.getAllStadiums().stream()
                         .map(stadium -> (String) stadium.get("stadiumid"))
                         .collect(Collectors.toList());
    }

    // 새로운 경기 정보를 삽입하는 메서드
    public void insertMatch(MatchesDTO matchesDTO) {
        // 경기가 열리는 날짜에 해당하는 최대 matchid 가져오기
        String maxMatchId = matchesDAO.getMaxMatchIdForDate(new SimpleDateFormat("yyyy-MM-dd").format(matchesDTO.getMatchdate()));
        // 새로운 matchid 생성
        String newMatchId = generateMatchId(maxMatchId, matchesDTO.getMatchdate());
        matchesDTO.setMatchid(newMatchId); // 새로 생성한 matchid 설정
        matchesDAO.insert(matchesDTO); // DAO를 통해 경기 정보 삽입
    }

    // 새로운 matchid를 생성하는 메서드
    private String generateMatchId(String maxMatchId, Date matchdate) {
        String datePrefix = new SimpleDateFormat("yyyyMMdd").format(matchdate); // 날짜 접두사 생성
        int serial = (maxMatchId != null && maxMatchId.startsWith("match" + datePrefix))
                     ? Integer.parseInt(maxMatchId.substring(12)) + 1 // 기존 ID가 있는 경우 시리얼 번호 증가
                     : 1; // 기존 ID가 없는 경우 시리얼 번호 1로 설정
        return "match" + datePrefix + String.format("%03d", serial); // 새로운 matchid 반환
    }

    // 모든 경기 정보를 리스트로 반환하는 메서드
    public List<MatchesDTO> list() {
        return matchesDAO.list();
    }
}
