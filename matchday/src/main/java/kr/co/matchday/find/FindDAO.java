package kr.co.matchday.find;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FindDAO {
    
    public FindDAO() {
        System.out.println("FindDAO() 객체 생성");
    }

    @Autowired
    SqlSession sqlSession;

    public String findIdByNameAndEmail(String name, String email) {
        Map<String, Object> params = new HashMap<>();
        params.put("name", name);
        params.put("email", email);

        // Select one record from the database
        return sqlSession.selectOne("find.findIdByNameAndEmail", params);
    }
    
 // 사용자 ID로 이메일을 찾는 메서드
    public String findEmailByUserID(String userID) {
        return sqlSession.selectOne("find.findEmailByUserID", userID);
    }

    // 비밀번호 재설정 토큰을 데이터베이스에 저장하는 메서드
    public void savePasswordResetToken(String userID, String token) {
        Map<String, Object> params = new HashMap<>();
        params.put("userID", userID);
        params.put("token", token);

        // MyBatis를 사용하여 데이터베이스에 토큰을 삽입합니다.
        sqlSession.insert("find.savePasswordResetToken", params);
    }

    // 토큰으로 사용자 ID를 찾는 메서드
    public String findUserIDByToken(String token) {
        return sqlSession.selectOne("find.findUserIDByToken", token);
    }

    // 사용자 ID로 비밀번호를 업데이트하는 메서드
    public void updatePassword(String userID, String password) {
        Map<String, Object> params = new HashMap<>();
        params.put("userID", userID);
        params.put("password", password);

        // MyBatis를 사용하여 데이터베이스에서 비밀번호를 업데이트합니다.
        sqlSession.update("find.updatePassword", params);
    }
}
