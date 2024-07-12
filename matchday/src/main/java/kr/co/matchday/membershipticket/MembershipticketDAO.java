package kr.co.matchday.membershipticket;

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

    /**
     * 사용자 ID로 사용자 정보를 가져오는 메서드
     * @param userID 사용자 ID
     * @return 사용자 정보 맵
     */  
    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.membershipticket.MembershipticketDAO.getUserInfo", userID);
    }

    /**
     * 멤버쉽 ID로 멤버쉽 정보를 가져오는 메서드
     * @param membershipID 멤버쉽 ID
     * @return 멤버쉽 정보 맵
     */
    public Map<String, Object> getMembershipInfo(String membershipID) {
        return sqlSession.selectOne("kr.co.matchday.membershipticket.MembershipticketDAO.getMembershipInfo", membershipID);
    }
}
