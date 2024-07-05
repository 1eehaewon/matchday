package kr.co.matchday.admin;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AdminDAO {
	public AdminDAO() {
		System.out.println("AdminDAO() 객체 생성됨");
	}
	
	@Autowired
	SqlSession sqlSession;
	
	//회원정보 전체 불러오기
	public List<AdminDTO> selectAllUsers() {
        return sqlSession.selectList("mypage.selectAllUsers"); //mypage.xml의 메서드
    }
}//class end
