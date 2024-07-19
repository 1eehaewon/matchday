package kr.co.matchday.review;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.order.OrderDTO;

@Repository
public class ReviewDAO {

    public ReviewDAO() {
        System.out.println("-----ReviewDAO() 객체 생성됨");
    }

    @Autowired
    SqlSession sqlSession;

    public void insert(ReviewDTO reviewDto) {
        sqlSession.insert("review.insert", reviewDto);
    }

    public ReviewDTO selectReviewById(String reviewid) {
        return sqlSession.selectOne("selectReviewById", reviewid);
    }

    public List<ReviewDTO> getReviewList(String goodsid) {
        return sqlSession.selectList("review.getReviewList", goodsid);
    }

    public void reviewdelete(String reviewid) {
        sqlSession.delete("review.reviewdelete", reviewid);
    }

    public String filename(String reviewid) {
        return sqlSession.selectOne("review.filename", reviewid);
    }

    // 모든 리뷰 목록 조회
    public List<ReviewDTO> getAllReviews() {
        return sqlSession.selectList("review.getAllReviews");
    }

    public List<ReviewDTO> list() {
        return sqlSession.selectList("review.selectAll");
    }
    
    public void insertPointHistory(String userid, int pointAmount, String pointSource) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("userid", userid);
        paramMap.put("pointAmount", pointAmount);
        paramMap.put("pointSource", pointSource);
        sqlSession.insert("review.insertPointHistory", paramMap);
    }
    
    public List<OrderDTO> getOrderListByGoodsId(String goodsid, String userid) {
        Map<String, Object> paramMap = new HashMap<>();
        paramMap.put("goodsid", goodsid);
        paramMap.put("userid", userid);
        return sqlSession.selectList("review.getOrderListByGoodsId", paramMap);
    }

    public boolean hasReviewForOrder(String orderid) {
        int count = sqlSession.selectOne("review.countReviewByOrderId", orderid);
        return count > 0;
    }
}
