package kr.co.matchday.comment;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/comment")
public class CommentCont {

    @Autowired
    private CommentDAO commentDao;

    @PostMapping("/insert")
    @ResponseBody
    public int vCommentServiceInsert(@RequestParam("video_code") int video_code, @RequestParam("content") String content, HttpSession session) throws Exception {
        CommentDTO commentDto = new CommentDTO();
        commentDto.setVideo_code(video_code);
        commentDto.setContent(content);
        commentDto.setWname("test"); // 수정이 필요한 부분

        return commentDao.commentInsert(commentDto);
    }//insert() end

    @GetMapping("/list")
    @ResponseBody
    public List<CommentDTO> pCommentServiceList(@RequestParam("video_code") int video_code) throws Exception {
        return commentDao.commentList(video_code);
    }//list() end

    @PostMapping("/delete")
    @ResponseBody
    public int vCommentServiceDelete(@RequestParam("cno") int cno) throws Exception {
        return commentDao.commentDelete(cno);
    }//delete() end

    @PostMapping("/updateproc")
    @ResponseBody
    public int vCommentServiceUpdate(@RequestParam("cno") int cno, @RequestParam("content") String content) throws Exception {
        CommentDTO commentDto = new CommentDTO();
        commentDto.setCno(cno);
        commentDto.setContent(content);
        return commentDao.commentUpdateProc(commentDto);
    }//updateproc() end
    
    
   
}//class end
