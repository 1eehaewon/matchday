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
    }//selectReviewById end
    
    public List<ReviewDTO> getReviewList(String goodsid) {
        return sqlSession.selectList("review.getReviewList", goodsid);
    }//getReviewList end

    public void update(ReviewDTO reviewDto) {
        sqlSession.update("review.update", reviewDto);
    }//update end

    public void reviewdelete(String reviewid) {
        sqlSession.delete("review.reviewdelete", reviewid);
    }//delete end

    public String filename(String reviewid) {
	    return sqlSession.selectOne("review.filename", reviewid);
	}//filename end
    
    // 모든 리뷰 목록 조회
    public List<ReviewDTO> getAllReviews() {
        return sqlSession.selectList("review.getAllReviews");
    }
    
    public List<ReviewDTO> list() {
        return sqlSession.selectList("review.selectAll");
    }
	
	
}//class end
