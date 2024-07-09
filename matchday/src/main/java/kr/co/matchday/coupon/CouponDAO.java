package kr.co.matchday.coupon;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CouponDAO {
	public CouponDAO() {
		System.out.println("CouponDAO() 객체 생성됨");
	}//end
	
	@Autowired
	SqlSession sqlSession;
	
	//쿠폰내역 불러오기
	public List<CouponDTO> selectCouponList(String userid){
		return sqlSession.selectList("mypage.selectCouponList", userid);
	}
	
}//class end
