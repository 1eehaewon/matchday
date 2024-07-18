package kr.co.matchday.order;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.coupon.CouponDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class OrderDAO {

    @Autowired
    private SqlSession sqlSession;

    // 주문 삽입 메소드
    public void insert(OrderDTO orderDto) {
        System.out.println("Preparing to insert order: " + orderDto.toString());
        sqlSession.insert("kr.co.matchday.order.OrderDAO.insert", orderDto);
        System.out.println("Order inserted in database.");
    }


    // 사용자의 주문 목록 가져오는 메소드
    public List<OrderDTO> list(String userid) {
        return sqlSession.selectList("kr.co.matchday.order.OrderDAO.listByUser", userid);
    }

    // 사용자의 정보 가져오는 메소드
    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getUserInfo", userID);
    }

    // 사용자 ID로 쿠폰 목록 가져오는 메소드 (적용 구분이 Goods인 쿠폰만)
    public List<CouponDTO> getCouponsByUserId(String userid) {
        Map<String, Object> params = new HashMap<>();
        params.put("userid", userid);
        params.put("applicableProduct", "Goods");
        params.put("usage", "Not Used"); // usage 값도 추가
        return sqlSession.selectList("kr.co.matchday.order.OrderDAO.getCouponsByUserId", params);
    }

    // 쿠폰 ID로 할인율 가져오는 메소드
    public int getDiscountRateByCouponId(String couponid) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getDiscountRateByCouponId", couponid);
    }

    // 쿠폰 사용 업데이트 메소드
    public int updateCouponUsage(String couponid) {
        return sqlSession.update("kr.co.matchday.order.OrderDAO.updateCouponUsage", couponid);
    }

    // 주어진 날짜에 대한 최대 주문 ID 가져오는 메소드
    public String getMaxOrderId(String date) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getMaxOrderId", date);
    }
}
