package kr.co.matchday.cardnews;


import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class CardnewsDAO {

    @Autowired
    SqlSession sqlSession;

    public void insert(CardnewsDTO cardnewsDTO) {
        sqlSession.insert("cardnews.insert", cardnewsDTO);
    }

    public void update(CardnewsDTO cardnewsDTO) {
        sqlSession.update("cardnews.update", cardnewsDTO);
    }

    public void delete(int cardnews_code) {
        sqlSession.delete("cardnews.delete", cardnews_code);
    }

    
    
}//class end
