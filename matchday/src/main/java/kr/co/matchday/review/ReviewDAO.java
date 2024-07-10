package kr.co.matchday.review;

import java.util.List;

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
	
	public void insert(ReviewDTO reviewDto) {
        sqlSession.insert("review.insert", reviewDto);
    }//insert end

    public ReviewDTO selectReviewById(String reviewid) {
        return sqlSession.selectOne("selectReviewById", reviewid);
    }
    
    public List<ReviewDTO> getReviewList(String goodsid) {
        return sqlSession.selectList("review.getReviewList", goodsid);
    }
/*
    public void update(ReviewDTO reviewDto) {
        sqlSession.update("review.update", reviewDto);
    }

    public void delete(String reviewid) {
        sqlSession.delete("review.delete", reviewid);
    }
*/
    /*public List<ReviewDTO> list() {
        return sqlSession.selectList("review.list");
    }*/
    public List<ReviewDTO> list() {
        return sqlSession.selectList("review.selectAll");
    }
	
	
}//class end
