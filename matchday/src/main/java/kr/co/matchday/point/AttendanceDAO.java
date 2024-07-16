package kr.co.matchday.point;


import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class AttendanceDAO {

	@Autowired
	SqlSession sqlSession;
	
	
	public AttendanceDTO getLastAttendance(String userid) {
        return sqlSession.selectOne("point.getLastAttendance", userid);
    }

    public void updateLastAttendance(AttendanceDTO attendance) {
        sqlSession.update("point.updateLastAttendance", attendance);
    }
}//class end
