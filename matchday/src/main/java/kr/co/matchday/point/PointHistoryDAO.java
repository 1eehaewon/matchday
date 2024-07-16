package kr.co.matchday.point;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class PointHistoryDAO {
	public PointHistoryDAO() {
		System.out.println("PointHistoryDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	//포인트내역 불러오기
	public List<PointHistoryDTO> getPointHistoryList(String userid){
		return sqlSession.selectList("mypage.getPointHistoryList", userid); //namespace.메서드이름
	}
	
	//회원가입 후 첫 로그인 포인트 지급
	 public boolean isFirstLogin(String userid) {
	        Integer count = sqlSession.selectOne("point.isFirstLogin", userid);
	        return count == null || count == 0;
	    }
	 
	 //포인트 지급
	 public void addPointHistory(PointHistoryDTO pointHistory) {
	        sqlSession.insert("point.addPointHistory", pointHistory);
	    }
}// class end
