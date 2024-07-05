package kr.co.matchday.cart;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CartDAO {

	public CartDAO() {
		System.out.println("-----CartDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	// 장바구니에 상품 추가
    public int insert(CartDTO cartDto) {
        return sqlSession.insert("cart.insert", cartDto);
    }//insert end

	// 사용자의 장바구니 목록 조회 
    public List<CartDTO> getCartList(String userid) {
        return sqlSession.selectList("cart.getCartList", userid);
    }//list end
	
    // 장바구니에서 상품 삭제
    public int delete(int cartid) {
        return sqlSession.delete("cart.delete", cartid);
    }//delete end
    
    
    
}//class end
