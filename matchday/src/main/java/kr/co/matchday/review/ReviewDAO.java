package kr.co.matchday.review;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;


@Repository
public class ReviewDAO {

	public ReviewDAO() {
		System.out.println("-----ReviewDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	
	
	
	
}//class end
