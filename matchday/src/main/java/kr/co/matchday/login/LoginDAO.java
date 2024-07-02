package kr.co.matchday.login;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class LoginDAO {
	
	public LoginDAO() {
		System.out.println("LoginDAO() 객체 생성됨");
	}
	
	@Autowired
    SqlSession sqlSession;

	//로그인
    public boolean validateUser(String userID, String password) {
        LoginDTO loginDTO = new LoginDTO();
        loginDTO.setUserID(userID);
        loginDTO.setPassword(password);

        int count = sqlSession.selectOne("login.validateUser", loginDTO);
        return count == 1;
    }
    
    //탈퇴한회원 로그인
    public String getUserGrade(String userID) {
        return sqlSession.selectOne("login.getUserGrade", userID);
    }
    
    /**
     * 이메일을 통해 사용자 ID를 찾는 메서드
     *
     * @param email 사용자 이메일
     * @return 사용자 ID
     */
    public String findIDByEmail(String email) {
        return sqlSession.selectOne("login.findIDByEmail", email);
    }

    
    /**
     * 사용자 ID와 이메일을 통해 비밀번호를 찾는 메서드
     *
     * @param userID 사용자 ID
     * @param email 사용자 이메일
     * @return 사용자 비밀번호
     */
    public String findPasswordByIDAndEmail(String userID, String email) {
        LoginDTO loginDTO = new LoginDTO();
        loginDTO.setUserID(userID);
        loginDTO.setEmail(email);
        return sqlSession.selectOne("login.findPasswordByIDAndEmail", loginDTO);
    }
}//class end
