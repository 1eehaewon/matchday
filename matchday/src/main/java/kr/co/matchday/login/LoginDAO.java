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
}//class end
