package kr.co.matchday.join;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

@Controller
@RequestMapping("/member")
public class JoinCont {
	public JoinCont() {
		System.out.println("JoinCont() 객체 생성됨");
	}// end
	
	@Autowired
	JoinDAO joinDao;
	
	@GetMapping("/join")
	public String join() {
        return "/member/join"; // join.jsp를 반환
    }
	
	@PostMapping("/join/insert") // join.jsp 폼의 action="/member/join/insert"
    @ResponseBody
    public String joinInsert(@ModelAttribute JoinDTO joinDto) {
        try {
            joinDao.joinInsert(joinDto);
            return "회원가입 성공";
        } catch (Exception e) {
            e.printStackTrace();
            return "회원가입 실패";
        }
    }//joinInsert end
	
	//아이디 중복체크
	@GetMapping("/checkUserId")
	@ResponseBody //이게 중요함 response
    public String checkUserId(@RequestParam String userId) {
        int count = joinDao.checkUserId(userId);
        return count == 0 ? "사용 가능한 아이디입니다." : "이미 사용 중인 아이디입니다. 다른 아이디를 입력해주세요.";
    }
}//class end
