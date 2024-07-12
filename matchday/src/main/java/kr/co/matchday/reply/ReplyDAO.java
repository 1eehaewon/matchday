package kr.co.matchday.reply;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class ReplyDAO {
	
	public ReplyDAO() {
        System.out.println("-----ReplyDAO()객체생성됨");
    }//end
	
	@Autowired
    SqlSession sqlSession;
	
	public int replyInsert(ReplyDTO replyDto) {
        return sqlSession.insert("reply.insert", replyDto);
    }//commentInsert() end
    
    
    public List<ReplyDTO> replyList(int replyid){
        return sqlSession.selectList("reply.list", replyid);
    }//list() end
    
    
    public int replyDelete(int replyid) throws Exception{
        return sqlSession.delete("reply.delete", replyid);
    }//delete() end
    
    
    public int replyUpdateProc(ReplyDTO replyDto){
        return sqlSession.update("reply.updateproc", replyDto); 
    }//update() end
    

}//class end
