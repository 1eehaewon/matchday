package kr.co.matchday.find;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.SimpleMailMessage;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Controller;
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
            return new ResponseEntity<>(HttpStatus.OK);
        }
        return new ResponseEntity<>(HttpStatus.BAD_REQUEST);
    }

    private void senduserID(String email, String userID) {
        SimpleMailMessage simpleMailMessage = new SimpleMailMessage();
        simpleMailMessage.setTo(email);
        simpleMailMessage.setSubject("아이디 찾기");
        simpleMailMessage.setText("가입하신 아이디는 " + userID + " 입니다.");

        new Thread(() -> mailSender.send(simpleMailMessage)).start();
    }
	
	
}//class end
