package kr.co.matchday.matches;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Collections;
import java.util.Comparator;
import java.util.Date;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

@Service
public class MatchesService {

    @Autowired
    private MatchesDAO matchesDAO; // MatchesDAO 주입

    /**
     * 모든 팀의 이름을 가져오는 메서드
     * @return 모든 팀 이름 목록
     */
    public List<String> getAllTeams() {
        List<Map<String, Object>> teamsList = matchesDAO.getAllTeams();
        List<String> teamNames = new ArrayList<String>();
        for (Map<String, Object> team : teamsList) {
            teamNames.add((String) team.get("teamname"));
        }
        return teamNames;
    }

    /**
     * 모든 경기장의 ID를 가져오는 메서드
     * @return 모든 경기장 ID 목록
     */
    public List<String> getAllStadiums() {
        return matchesDAO.getAllStadiums().stream()
                         .map(stadium -> (String) stadium.get("stadiumid"))
                         .collect(Collectors.toList());
    }

    /**
     * 새로운 경기 정보를 삽입하는 메서드
     * @param matchesDTO 삽입할 경기 정보
     */
    public void insertMatch(MatchesDTO matchesDTO) {
        // 경기가 열리는 날짜에 해당하는 최대 matchid 가져오기
        String datePrefix = new SimpleDateFormat("yyyyMMdd").format(matchesDTO.getMatchdate());
        String maxMatchId = matchesDAO.getMaxMatchIdForDate(datePrefix);
        // 새로운 matchid 생성
        String newMatchId = generateMatchId(maxMatchId, datePrefix);
        matchesDTO.setMatchid(newMatchId); // 새로 생성한 matchid 설정
        matchesDAO.insert(matchesDTO); // DAO를 통해 경기 정보 삽입
    }

    /**
     * 새로운 matchid를 생성하는 메서드
     * @param maxMatchId 해당 날짜의 최대 matchid
     * @param datePrefix 날짜 접두사 (yyyyMMdd 형식)
     * @return 새로운 matchid
     */
    private String generateMatchId(String maxMatchId, String datePrefix) {
        int serial = (maxMatchId != null && maxMatchId.startsWith("match" + datePrefix))
                     ? Integer.parseInt(maxMatchId.substring(12)) + 1 // 기존 ID가 있는 경우 시리얼 번호 증가
                     : 1; // 기존 ID가 없는 경우 시리얼 번호 1로 설정
        return "match" + datePrefix + String.format("%03d", serial); // 새로운 matchid 반환
    }

    /**
     * 모든 경기 정보를 리스트로 반환하는 메서드
     * @return 모든 경기 정보 목록
     */
    public List<MatchesDTO> list() {
        return matchesDAO.list();
    }

    /**
     * 특정 경기 정보를 반환하는 메서드
     * @param matchid 경기 ID
     * @return 경기 정보
     */
    public MatchesDTO getMatchDetail(String matchid) {
        return matchesDAO.getMatchDetail(matchid);
    }

    /**
     * 경기 정보를 업데이트하는 메서드
     * @param matchesDTO 업데이트할 경기 정보
     */
    public void updateMatch(MatchesDTO matchesDTO) {
        matchesDAO.update(matchesDTO);
    }

    /**
     * 경기 정보를 삭제하는 메서드
     * @param matchid 삭제할 경기 ID
     */
    public void deleteMatch(String matchid) {
        matchesDAO.delete(matchid);
    }

    /**
     * 특정 경기의 판매 종료일을 반환하는 메서드
     * @param matchid 경기 ID
     * @return 판매 종료일
     */
    public Date getBookingEndDate(String matchid) {
        return matchesDAO.getBookingEndDate(matchid);
    }

    /**
     * 현재 날짜 기준으로 판매종료일이 1일 지난 경기를 필터링하여 반환하는 메서드
     * @return 판매종료일이 지난 경기 목록
     */
    public List<MatchesDTO> listActiveMatches() {
        Date currentDate = new Date();
        return matchesDAO.listActiveMatches(currentDate);
    }
    
    /**
     * 현재 날짜가 지난 경기를 삭제하는 메서드
     */
    public void deleteOldMatches() {
        Date currentDate = new Date();
        SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
        String currentDateString = dateFormat.format(currentDate);
        matchesDAO.deleteOldMatches(currentDateString);
    }
    
    public List<MatchesDTO> searchMatchesByTeamName(String teamname) {
        return matchesDAO.searchMatchesByTeamName(teamname);
    }
    
    /**
     * 오늘 날짜부터 5일 후까지의 경기 정보를 반환하는 메서드
     * @return 경기 정보 목록
     */
    public List<MatchesDTO> getMatchesWithinFiveDays() {
        Date today = new Date();
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(today);
        calendar.add(Calendar.DATE, 5);
        Date fiveDaysLater = calendar.getTime();

        List<MatchesDTO> allMatches = matchesDAO.list();
        List<MatchesDTO> filteredMatches = new ArrayList<>();

        for (MatchesDTO match : allMatches) {
            if (!match.getMatchdate().before(today) && !match.getMatchdate().after(fiveDaysLater)) {
                filteredMatches.add(match);
            }
        }

        // 데이터 로그 출력
        System.out.println("Filtered Matches: " + filteredMatches);

        // 날짜 순으로 정렬
        Collections.sort(filteredMatches, new Comparator<MatchesDTO>() {
            public int compare(MatchesDTO m1, MatchesDTO m2) {
                return m1.getMatchdate().compareTo(m2.getMatchdate());
            }
        });

        return filteredMatches;
    }



}
