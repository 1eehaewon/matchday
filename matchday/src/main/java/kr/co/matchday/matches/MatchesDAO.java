package kr.co.matchday.matches;


import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MatchesDAO {

    @Autowired
    SqlSession sqlSession;

    
    
}//class end
