package kr.co.matchday.reply;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/reply")
public class ReplyCont {
	
	@Autowired
	private ReplyDAO replyDao;
	
	public ReplyCont() {
        System.out.println("-----ReplyCont()객체생성됨");
    }//end
	
	
	@PostMapping("/insert")
	@ResponseBody
	public int ReplyServiceInsert(@RequestParam("noticeid") int noticeid,
	                              @RequestParam("content") String content,
	                              HttpSession session) throws Exception {

	    // 세션에서 로그인된 사용자의 ID를 가져옵니다.
	    String userId = (String) session.getAttribute("userID");
	    
	    // 사용자 ID가 세션에 없을 경우 예외를 발생시킵니다.
	    if (userId == null) {
	        throw new Exception("사용자가 로그인되지 않았거나 세션이 만료되었습니다.");
	    }

	    // ReplyDTO 객체를 생성하고, 속성들을 설정합니다.
	    ReplyDTO replyDto = new ReplyDTO();
	    replyDto.setNoticeid(noticeid);
	    replyDto.setContent(content);
	    replyDto.setUserid(userId);  // 로그인된 사용자의 ID를 설정합니다.

	    // DAO를 통해 댓글을 삽입합니다.
	    int cnt = replyDao.replyInsert(replyDto);

	    return cnt;
	}
    
    
    @GetMapping("/list")
    @ResponseBody
    public List<ReplyDTO> replyServiceList(@RequestParam("noticeid") int noticeid) throws Exception {
    	//System.out.println(noticeid);
        List<ReplyDTO> list = replyDao.replyList(noticeid);
        //System.out.println(list.size());
        return list;
    }//replyServiceList() end
    
    
    @PostMapping("/delete")
    @ResponseBody
    public int replyServiceDelete(@RequestParam("replyid") int replyid) throws Exception{
        int cnt = replyDao.replyDelete(replyid);
        return cnt;
    }//replyServiceDelete() end
    
    
    @PostMapping("/updateproc")
    @ResponseBody
    public int replyServiceUpdateProc(@RequestParam("replyid") int replyid, @RequestParam("content") String content) throws Exception {
        
        ReplyDTO replyDto=new ReplyDTO();
        replyDto.setReplyid(replyid);
        replyDto.setContent(content);
        
        int cnt = replyDao.replyUpdateProc(replyDto);
        
        return cnt;
        
    }//replyServiceUpdateProc() end

    
}//class end
