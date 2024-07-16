package kr.co.matchday.order;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.admin.CouponMasterDTO;
import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.point.PointHistoryDTO;

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
	
	//사용자 ID로 사용자 정보를 가져오는 메서드
	public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("order.getUserInfo", userID);
    }
	
	//사용자 ID로 쿠폰 목록을 가져오는 메서드
	public List<CouponDTO> getCouponsByUserId(String userid) {
        Map<String, Object> params = new HashMap<>();
        params.put("userid", userid);
        params.put("applicableProduct", "Goods");
        params.put("usage", "Not Used");
        return sqlSession.selectList("order.getCouponsByUserId", params);
    }
	
	//쿠폰 ID로 할인율을 가져오는 메서드
	public int getDiscountRateByCouponId(String couponid) {
        return sqlSession.selectOne("order.getDiscountRateByCouponId", couponid);
    }
	
	//쿠폰의 사용 상태를 업데이트하는 메서드
	public int updateCouponUsage(String couponid) {
        System.out.println("쿠폰 사용 업데이트 시도: " + couponid);
        int result = sqlSession.update("order.updateCouponUsage", couponid);
        if (result > 0) {
            System.out.println("쿠폰 사용 업데이트 성공: " + couponid);
        } else {
            System.out.println("쿠폰 사용 업데이트 실패: " + couponid);
        }
        return result;
    }
	
	// 쿠폰 타입 ID로 쿠폰 마스터 정보를 가져오는 메서드
    public CouponMasterDTO getCouponMasterById(String coupontypeid) {
        return sqlSession.selectOne("coupon.getCouponMasterById", coupontypeid);
    }
	
    // 사용자의 포인트 이력을 조회하는 메서드
    public List<PointHistoryDTO> getPointByUserId(String userid) {
        return sqlSession.selectList("order.getPointByUserId", userid);
    }

    
    
    
    // 사용자의 포인트 이력을 추가하는 메서드
    public void insertPointHistory(PointHistoryDTO pointHistoryDto) {
        sqlSession.insert("point.insertPointHistory", pointHistoryDto);
    }
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
	
}//class end
