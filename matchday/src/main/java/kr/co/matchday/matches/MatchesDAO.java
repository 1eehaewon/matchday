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
    private SqlSession sqlSession;
    
    public void insert(MatchesDTO matchesDTO) {
        sqlSession.insert("kr.co.matchday.matches.MatchesDAO.insert", matchesDTO);
    }

    public List<MatchesDTO> list() {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.list");
    }
    
    public List<Map<String, Object>> getAllTeams() {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.getAllTeams");
    }

    public List<Map<String, Object>> getAllStadiums() {
        return sqlSession.selectList("kr.co.matchday.matches.MatchesDAO.getAllStadiums");
    }

    public String getMaxMatchIdForDate(String matchdate) {
        return sqlSession.selectOne("kr.co.matchday.matches.MatchesDAO.getMaxMatchIdForDate", matchdate);
    }
}
