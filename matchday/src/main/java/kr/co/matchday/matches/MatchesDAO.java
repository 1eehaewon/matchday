package kr.co.matchday.matches;

import java.util.Date;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
@Mapper
public class MatchesDAO {

    @Autowired
    private SqlSession sqlSession; // MyBatis의 SqlSession 주입
    
    // 새로운 경기 정보를 삽입하는 메서드
    public void insert(MatchesDTO matchesDTO) {
        sqlSession.insert("kr.co.matchday.matches.MatchesDAO.insert", matchesDTO);
    }

    // 모든 경기 정보를 가져오는 메서드
    public List<MatchesDTO> list() {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.list");
    }
    
    // 모든 팀 정보를 가져오는 메서드
    public List<Map<String, Object>> getAllTeams() {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.getAllTeams");
    }

    // 모든 경기장 정보를 가져오는 메서드
    public List<Map<String, Object>> getAllStadiums() {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.getAllStadiums");
    }

    // 주어진 날짜에 해당하는 최대 matchid를 가져오는 메서드
    public String getMaxMatchIdForDate(String datePrefix) {
        return sqlSession.selectOne("kr.co.matchday.matches.MatchesDAO.getMaxMatchIdForDate", datePrefix);
    }

    // 특정 경기 정보를 가져오는 메서드
    public MatchesDTO getMatchDetail(String matchid) {
        return sqlSession.selectOne("kr.co.matchday.matches.MatchesDAO.getMatchDetail", matchid);
    }

    // 경기 정보를 업데이트하는 메서드
    public void update(MatchesDTO matchesDTO) {
        sqlSession.update("kr.co.matchday.matches.MatchesDAO.update", matchesDTO);
    }

    // 경기 정보를 삭제하는 메서드
    public void delete(String matchid) {
        sqlSession.delete("kr.co.matchday.matches.MatchesDAO.delete", matchid);
    }

    // 특정 경기의 판매 종료일을 가져오는 메서드
    public Date getBookingEndDate(String matchid) {
        return sqlSession.selectOne("kr.co.matchday.matches.MatchesDAO.getBookingEndDate", matchid);
    }

    // 현재 날짜 기준으로 판매종료일이 1일 지난 경기를 필터링하는 메서드
    public List<MatchesDTO> listActiveMatches(Date currentDate) {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.listActiveMatches", currentDate);
    }
    
    // 현재 날짜가 지난 경기를 삭제하는 메서드
    public void deleteOldMatches(String currentDateString) {
        sqlSession.delete("kr.co.matchday.matches.MatchesDAO.deleteOldMatches", currentDateString);
    }
    
    public List<MatchesDTO> searchMatchesByTeamName(String teamname) {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.searchMatchesByTeamName", teamname);
    }

}
