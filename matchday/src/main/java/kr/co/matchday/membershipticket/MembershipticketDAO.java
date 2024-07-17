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

    public void insertUserMembership(String userMembershipId, String userID, String membershipID, String status, String purchaseDate, String impUid, String expirationStatus) {
        Map<String, String> params = new HashMap<>();
        params.put("userMembershipId", userMembershipId);
        params.put("userID", userID);
        params.put("membershipID", membershipID);
        params.put("status", status);
        params.put("purchaseDate", purchaseDate);
        params.put("impUid", impUid);
        params.put("expirationStatus", expirationStatus); // expirationstatus 추가
        sqlSession.insert("kr.co.matchday.membershipticket.MembershipticketDAO.insertUserMembership", params);
    }

    public List<Map<String, Object>> getUserMemberships(String userID) {
        return sqlSession.selectList("kr.co.matchday.membershipticket.MembershipticketDAO.getUserMemberships", userID);
    }

    public List<Map<String, Object>> getUserMembershipDetails(String userID) {
        return sqlSession.selectList("kr.co.matchday.membershipticket.MembershipticketDAO.getUserMembershipDetails", userID);
    }


    public Map<String, Object> getUserMembershipById(String userMembershipId) {
        return sqlSession.selectOne("kr.co.matchday.membershipticket.MembershipticketDAO.getUserMembershipById", userMembershipId);
    }

    public void updateUserMembershipStatus(String impUid, String status) {
        Map<String, String> params = new HashMap<>();
        params.put("impUid", impUid);
        params.put("status", status);
        sqlSession.update("kr.co.matchday.membershipticket.MembershipticketDAO.updateUserMembershipStatusByImpUid", params);
    }

    public void deleteUserMembershipById(String userMembershipId) {
        sqlSession.delete("kr.co.matchday.membershipticket.MembershipticketDAO.deleteUserMembershipById", userMembershipId);
    }
    
    public void updateExpirationStatus() {
        sqlSession.update("kr.co.matchday.membershipticket.MembershipticketDAO.updateExpirationStatus");
    }
    
}
