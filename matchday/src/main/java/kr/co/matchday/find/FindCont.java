package kr.co.matchday.find;


import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@Component
@RequestMapping("/member")
public class FindCont {
	public FindCont() {
		System.out.println("FindCont() 객체 생성됨");
	}//end
	
	@Autowired
	FindDAO findDao;
	
	@Autowired
	JavaMailSender mailSender; //메일 스프링프레임워크 도구
	
	
	@GetMapping("/findID")
	public String findID() {
		return "/member/findID"; //findID.jsp 반환
	}
	
	// 메일로 아이디 보내기
    @PostMapping("/findID.do")
    public ResponseEntity<Object> sendEmail(@RequestParam String name, @RequestParam String email) {
        String userID = findDao.findIdByNameAndEmail(name, email);
        if (userID != null) {
            senduserID(email, userID);
            return ResponseEntity.ok("{\"message\": \"메일이 성공적으로 발송되었습니다.\"}");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                             .body("{\"message\": \"유효한 사용자 정보가 없습니다.\"}");
    }

    private void senduserID(String email, String userID) {
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        simpleMailMessage.setTo(email);
        simpleMailMessage.setSubject("아이디 찾기");
        simpleMailMessage.setText("가입하신 아이디는 " + userID + " 입니다.");

        new Thread(() -> mailSender.send(simpleMailMessage)).start();
    }
	
    @GetMapping("/findPassword")
    public String findPassword() {
        return "/member/findPassword";
    }
	
 // 비밀번호 재설정 이메일을 전송하는 메서드
    @PostMapping("/findPassword.do")
    public ResponseEntity<Object> sendPasswordResetEmail(@RequestParam String userID, @RequestParam String email) {
        // 입력된 userID로 이메일을 조회
        String userEmail = findDao.findEmailByUserID(userID);
        // 조회된 이메일과 입력된 이메일이 일치하는지 확인
        if (userEmail != null && userEmail.equals(email)) {
            // 비밀번호 재설정을 위한 토큰 생성
            String token = UUID.randomUUID().toString();
            // 토큰을 데이터베이스에 저장
            findDao.savePasswordResetToken(userID, token);
            // 비밀번호 재설정 이메일 전송
            sendPasswordResetEmailAsync(email, token);
            return ResponseEntity.ok("{\"message\": \"비밀번호 재설정 링크가 이메일로 전송되었습니다.\"}");
        }
        // 유효하지 않은 사용자 정보인 경우 오류 응답 반환
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                             .body("{\"message\": \"유효한 사용자 정보가 없습니다.\"}");
    }

 // 비밀번호 재설정 이메일을 비동기로 전송하는 메서드
    private void sendPasswordResetEmailAsync(String email, String token) {
        // 비밀번호 재설정 URL 생성
        String resetUrl = "http://localhost:9095/member/resetPassword?token=" + token;
        // 이메일 내용 설정
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        simpleMailMessage.setTo(email);
        simpleMailMessage.setSubject("비밀번호 재설정");
        simpleMailMessage.setText("비밀번호를 재설정하려면 다음 링크를 클릭하세요: " + resetUrl);

        // 메일 전송을 비동기로 처리합니다.
        new Thread(() -> mailSender.send(simpleMailMessage)).start();
    }

    // 비밀번호 재설정 페이지로 이동
    @GetMapping("/resetPassword")
    public String resetPassword(@RequestParam("token") String token, Model model) {
        String userID = findDao.findUserIDByToken(token);
        if (userID != null) {
            model.addAttribute("token", token);  // 토큰을 모델에 추가합니다.
            return "/member/resetPassword";  // resetPassword.jsp를 반환합니다.
        }
        return "redirect:/error";  // 토큰이 유효하지 않으면 에러 페이지로 리디렉션합니다.
    }

    // 비밀번호를 실제로 재설정하는 메서드
    @PostMapping("/resetPassword")
    public ResponseEntity<Object> resetPassword(@RequestParam("token") String token, @RequestParam("password") String password) {
        String userID = findDao.findUserIDByToken(token);
        if (userID != null) {
            findDao.updatePassword(userID, password);  // 비밀번호를 업데이트합니다.
            return ResponseEntity.ok("{\"message\": \"비밀번호가 성공적으로 변경되었습니다.\"}");
        }
        return ResponseEntity.status(HttpStatus.BAD_REQUEST)
                             .body("{\"message\": \"유효하지 않은 요청입니다.\"}");
    }
}//class end
