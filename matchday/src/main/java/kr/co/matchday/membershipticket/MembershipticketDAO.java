package kr.co.matchday.membershipticket;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MembershipticketDAO {

    public MembershipticketDAO() {
        System.out.println("-----MembershipticketDAO() 객체 생성됨");
    }

    @Autowired
    private SqlSession sqlSession;

    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.membershipticket.MembershipticketDAO.getUserInfo", userID);
    }

    public Map<String, Object> getMembershipInfo(String membershipID) {
        return sqlSession.selectOne("kr.co.matchday.membershipticket.MembershipticketDAO.getMembershipInfo", membershipID);
    }

    public void insertUserMembership(String userMembershipId, String userID, String membershipID, String status, String purchaseDate) {
        Map<String, String> params = new HashMap<>();
        params.put("userMembershipId", userMembershipId);
        params.put("userID", userID);
        params.put("membershipID", membershipID);
        params.put("status", status);
        params.put("purchaseDate", purchaseDate);
        sqlSession.insert("kr.co.matchday.membershipticket.MembershipticketDAO.insertUserMembership", params);
    }

    public List<Map<String, Object>> getUserMemberships(String userID) {
        return sqlSession.selectList("kr.co.matchday.membershipticket.MembershipticketDAO.getUserMemberships", userID);
    }
    

    
}//end
