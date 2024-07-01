package kr.co.matchday.join;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class JoinDAO {
	public JoinDAO() {
		System.out.println("JoinDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	public int joinInsert(JoinDTO joinDto) {
		return sqlSession.insert("join.insert", joinDto);
	}//joinInsert() end
	
	public int checkUserId(String userId) {
		return sqlSession.selectOne("join.checkUserId", userId);
	}
}//class end
