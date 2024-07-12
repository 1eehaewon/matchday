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
    public int ReplyServiceInsert(@RequestParam("noticeid") int noticeid
                                    ,@RequestParam("content") String content
                                    ,HttpSession session) throws Exception {
                                    //HttpServletRequest req
                                    //@ModelAttribute CommentDTO commentDto
        
        ReplyDTO replyDto = new ReplyDTO();
        replyDto.setNoticeid(noticeid);
        replyDto.setContent(content);        
        replyDto.setUserid("webmaster");
        //->로그인 기능을 구현했거나 따로 댓글 작성자를 입력받는 폼이 있다면 입력 받아온 값으로 사용하면 된다.
        //->예) session.getAttribute("s_id") 활용
        //->여기서는 따로 폼을 구현하지 않았기 때문에 임시로 "test" 라 한다
        
        int cnt = replyDao.replyInsert(replyDto);
        
        return cnt;
    }//replyServiceInsert() end
    
    
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
