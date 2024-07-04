package kr.co.matchday.cart;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.point.PointHistoryDTO;

@Repository
public class CartDAO {

	public CartDAO() {
		System.out.println("-----CartDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	// Insert into cart
    public int insert(CartDTO cartDto) {
        return sqlSession.insert("Cart.insert", cartDto);
    }
    
	/*
	 * // Retrieve cart list by userid public List<CartDTO> getCartList(String
	 * userid) { return sqlSession.selectList("Cart.getCartList", userid); }
	 */
		
}//class end
