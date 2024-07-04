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
		return sqlSession.selectList("point.getPointHistoryList", userid);
	}
}// class end
