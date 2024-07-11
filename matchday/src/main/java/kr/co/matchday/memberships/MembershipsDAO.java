package kr.co.matchday.memberships;

import java.util.List;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.goods.GoodsDTO;
import kr.co.matchday.video.VideoDTO;


@Repository
public class MembershipsDAO {

   public MembershipsDAO() {
      System.out.println("-----MembershipsDAO() 객체 생성됨");
   }//end
      
    @Autowired
    SqlSession sqlSession;
    
    public void insert(MembershipsDTO membershipsDto) {
       sqlSession.insert("memberships.insert", membershipsDto);
   }//insert end
      
    public List<MembershipsDTO> list() {
       return sqlSession.selectList("memberships.list");
   }//list end
    
    public MembershipsDTO detail(String membershipid) {
        return sqlSession.selectOne("memberships.detail", membershipid);
    }//detail end
    

    public void delete(String membershipid) {
        sqlSession.delete("memberships.delete", membershipid);
    }//delete end
    
    public void update(MembershipsDTO membershipsDto) {
        sqlSession.update("memberships.update", membershipsDto);
    }//update end
    
    public String filename(String membershipid) {
        return sqlSession.selectOne("memberships.filename", membershipid);
    }//filename end
    
    
}//class end
