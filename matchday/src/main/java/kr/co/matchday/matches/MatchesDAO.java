package kr.co.matchday.matches;


import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.video.VideoDTO;

@Repository
public class MatchesDAO {

    @Autowired
    SqlSession sqlSession;
    
    public void insert(MatchesDTO matchesDTO) {
        sqlSession.insert("matches.insert", matchesDTO);
    }

    public List<MatchesDTO> list() {
        return sqlSession.selectList("matches.list");
    }

    
    
}//class end
