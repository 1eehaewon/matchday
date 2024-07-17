package kr.co.matchday.point;

import java.time.LocalDate;
import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class UserService {

	@Autowired
	PointHistoryDAO pointHistoryDao;

	@Autowired
	AttendanceDAO attendanceDao;

	public void checkFirstLogin(String userid) {
		boolean isFirstLogin = pointHistoryDao.isFirstLogin(userid);
		if (isFirstLogin) {
			PointHistoryDTO history = new PointHistoryDTO();
			history.setUserid(userid);
			history.setPointtype("적립");
			history.setPointsource("회원가입 축하 포인트");
			history.setPointamount(3000);

			pointHistoryDao.addPointHistory(history);
		}
	}// checkFirstLogin() end

	public void dailyAttendance(String userid) {
		AttendanceDTO lastAttendance = attendanceDao.getLastAttendance(userid);
		LocalDate today = LocalDate.now();

		if (lastAttendance == null || lastAttendance.getLast_attendance().toLocalDate().isBefore(today)) {
			// Update attendance
			attendanceDao.updateLastAttendance(new AttendanceDTO(userid, java.sql.Date.valueOf(today)));

			// Add points
			PointHistoryDTO history = new PointHistoryDTO();
			history.setUserid(userid);
			history.setPointtype("적립");
			history.setPointsource("출석 포인트 지급");
			history.setPointamount(50);

			pointHistoryDao.addPointHistory(history);
		}
	}
	
	//총포인트계산
	public static int calculateTotalPoints(SqlSession sqlSession, String userid) {
        return sqlSession.selectOne("mypage.getTotalPoints", userid);
    }

    public static void updateTotalPoints(SqlSession sqlSession, String userid) {
        int totalPoints = calculateTotalPoints(sqlSession, userid);
        Map<String, Object> params = new HashMap<>();
        params.put("userid", userid);
        params.put("totalpoints", totalPoints);
        sqlSession.update("mypage.updateTotalPoints", params);
    }

}// class end
