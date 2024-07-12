package kr.co.matchday.order;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class OrderDAO {

	public OrderDAO() {
		System.out.println("-----OrderDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	// 새로운 주문 정보를 데이터베이스에 삽입하는 메서드
	public void insert(OrderDTO orderDto) {
        sqlSession.insert("order.insert", orderDto);
    }//insert end
	
	// 특정 사용자의 주문 목록을 데이터베이스에서 조회하는 메서드
	public List<OrderDTO> list(String userid) {
        return sqlSession.selectList("order.listByUser", userid);
    }
	
	
	
	
	
	
}//class end
