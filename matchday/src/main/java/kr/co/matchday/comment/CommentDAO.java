package kr.co.matchday.comment;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository // 이 어노테이션을 추가하여 Spring이 이 클래스를 빈으로 인식하게 합니다.
public class CommentDAO {

    @Autowired
    private SqlSession sqlSession;

    public int commentInsert(CommentDTO commentDto) {
        return sqlSession.insert("vcomment.insert", commentDto);
    }

    public List<CommentDTO> commentList(int video_code) {
        return sqlSession.selectList("vcomment.list", video_code);
    }

    public int commentDelete(int cno) {
        return sqlSession.delete("vcomment.delete", cno);
    }

    public int commentUpdateProc(CommentDTO commentDto) {
        return sqlSession.update("vcomment.updateproc", commentDto);
    }
    
  
}//class end
