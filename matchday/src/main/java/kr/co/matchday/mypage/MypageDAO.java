package kr.co.matchday.mypage;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MypageDAO {
	public MypageDAO() {
		System.out.println("MypageDAO() 객체 생성됨");
	}
	
	@Autowired
	SqlSession sqlSession;
	
	//마이페이지 항목 불러오기
	public MypageDTO getUserById(String userID) {
		return sqlSession.selectOne("mypage.getUserById", userID);
	}//getUserById() end
	
	//마이페이지 수정
	public void updateUser(MypageDTO mypageDto) {
		sqlSession.update("mypage.updateUser", mypageDto);
	}
	
	//회원탈퇴
	public void updateUserGradeToF(String userID) {
		sqlSession.update("mypage.updateUserGradeToF", userID);
	}
	
	// 사용자의 총 포인트 조회
    public int getTotalPoints(String userid) {
        return sqlSession.selectOne("mypage.getTotalPoints", userid);
    }
    
}//class end
