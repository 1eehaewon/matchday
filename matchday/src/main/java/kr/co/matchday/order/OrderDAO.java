package kr.co.matchday.order;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.tickets.TicketsDetailDTO;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Repository
public class OrderDAO {

    @Autowired
    private SqlSession sqlSession;

    public void insert(OrderDTO orderDto) {
        System.out.println("Preparing to insert order: " + orderDto.toString());
        sqlSession.insert("kr.co.matchday.order.OrderDAO.insert", orderDto);
        System.out.println("Order inserted in database.");

        // 주문 상세 정보 삽입
        for (OrderdetailDTO orderDetail : orderDto.getOrderDetails()) {
            orderDetail.setOrderid(orderDto.getOrderid());
            insertOrderDetail(orderDetail);
        }
    }

    public void insertOrderDetail(OrderdetailDTO orderDetailDto) {
        System.out.println("Preparing to insert order detail: " + orderDetailDto.toString());
        sqlSession.insert("kr.co.matchday.order.OrderDAO.insertOrderDetail", orderDetailDto);
        System.out.println("Order detail inserted in database.");
    }

    public List<OrderDTO> list(String userid) {
        return sqlSession.selectList("kr.co.matchday.order.OrderDAO.listByUser", userid);
    }

    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getUserInfo", userID);
    }

    public List<CouponDTO> getCouponsByUserId(String userid) {
        Map<String, Object> params = new HashMap<>();
        params.put("userid", userid);
        params.put("applicableProduct", "Goods");
        params.put("usage", "Not Used");
        return sqlSession.selectList("kr.co.matchday.order.OrderDAO.getCouponsByUserId", params);
    }

    public int getDiscountRateByCouponId(String couponid) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getDiscountRateByCouponId", couponid);
    }

    public int updateCouponUsage(String couponid) {
        return sqlSession.update("kr.co.matchday.order.OrderDAO.updateCouponUsage", couponid);
    }

    public String getMaxOrderId(String date) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getMaxOrderId", date);
    }
    
    /*
    //사용자 ID로 주문 정보 가져오기
    public List<Map<String, Object>> getOrderByUserId(String userid) {
        List<Map<String, Object>> order = sqlSession.selectList("kr.co.matchday.order.OrderDAO.getOrderByUserId", userid);
        if (order == null || order.isEmpty()) {
            System.out.println("No order found for userId: " + userid);
        } else {
            System.out.println("order found: " + order.size());
        }
        return order;
    }
*/
 // OrderDAO.java
    public List<OrderDTO> getOrderByUserId(String userid) {
        return sqlSession.selectList("kr.co.matchday.order.OrderDAO.getOrderByUserId", userid);
    }

    //주문 ID로 주문 정보 가져오기
    public OrderDTO getOrderById(String orderid) {
        return sqlSession.selectOne("kr.co.matchday.order.OrderDAO.getOrderById", orderid);
    }
    
    //주문 ID로 주문 상세 정보 가져오기
    public List<OrderdetailDTO> getOrderDetailByOrderId(String orderid) {
        return sqlSession.selectList("kr.co.matchday.order.OrderDAO.getOrderDetailByOrderId", orderid);
    }
}
