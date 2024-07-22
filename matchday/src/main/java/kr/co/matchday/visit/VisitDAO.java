package kr.co.matchday.visit;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VisitDAO {

	@Autowired
	SqlSession sqlSession;
	
	public void recordVisit(String sessionId) {
		sqlSession.insert("visit.recordVisit", sessionId);
	}
	
	public int getTodayVisitors() {
		return sqlSession.selectOne("visit.getTodayVisitors");
	}
	
	public int getTotalVisitors() {
		return sqlSession.selectOne("visit.getTotalVisitors");
	}
}//class end
