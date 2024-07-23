package kr.co.matchday.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminService {
	@Autowired
	AdminDAO adminDao;

	//회원 정지
	@Transactional
	public void suspendUsers(List<String> userIds) {
		for (String userId : userIds) {
			adminDao.suspendUserById(userId);
		}
	}
	
	//회원 정지 해제
		@Transactional
		public void unsuspendUsers(List<String> userIds) {
			for (String userId : userIds) {
				adminDao.unsuspendUserById(userId);
			}
		}
}// class end
