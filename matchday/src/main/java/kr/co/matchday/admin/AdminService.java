package kr.co.matchday.admin;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.List;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminService {
	@Autowired
	AdminDAO adminDao;

	@Autowired
	DataSource dataSource;

	// 회원 정지
	@Transactional
	public void suspendUsers(List<String> userIds) {
		for (String userId : userIds) {
			adminDao.suspendUserById(userId);
		}
	}

	// 회원 정지 해제
	@Transactional
	public void unsuspendUsers(List<String> userIds) {
		for (String userId : userIds) {
			adminDao.unsuspendUserById(userId);
		}
	}

	public boolean hasAdminRole(String userID) {
		try (Connection connection = dataSource.getConnection()) {
			String authoritiesQuery = "SELECT grade AS authority FROM users WHERE userid = ?";

			PreparedStatement authoritiesStmt = connection.prepareStatement(authoritiesQuery);
			authoritiesStmt.setString(1, userID);
			ResultSet authoritiesRs = authoritiesStmt.executeQuery();

			while (authoritiesRs.next()) {
				String authority = authoritiesRs.getString("authority");
				if ("ADMIN".equalsIgnoreCase(authority)) {
					return true; // 사용자가 관리자 역할을 가지고 있음
				}
			}
		} catch (SQLException e) {
			e.printStackTrace();
		}
		return false; // 사용자가 관리자 역할을 가지고 있지 않음
	}	
}// class end
