package kr.co.matchday.matches;

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
    public String getMaxMatchIdForDate(String matchdate) {
        return sqlSession.selectOne("kr.co.matchday.matches.MatchesDAO.getMaxMatchIdForDate", matchdate);
    }
}
