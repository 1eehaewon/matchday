package kr.co.matchday.carts;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CartsDAO {

	public CartsDAO() {
		System.out.println("-----CartsDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
}//class end
