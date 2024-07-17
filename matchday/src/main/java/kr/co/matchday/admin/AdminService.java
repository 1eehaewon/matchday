package kr.co.matchday.admin;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class AdminService {
	@Autowired
	AdminDAO adminDao;

	@Transactional
	public void deleteUsers(List<String> userIds) {
		for (String userId : userIds) {
			adminDao.deleteUserById(userId);
		}
	}
}// class end
