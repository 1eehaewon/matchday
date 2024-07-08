package kr.co.matchday.notice;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class NoticeDAO {

    @Autowired
    SqlSession sqlSession;

    public NoticeDAO() {
        System.out.println("-----NoticeDAO() 객체 생성됨");
    }

    
    public void insert(NoticeDTO noticeDto) {
        sqlSession.insert("notice.insert", noticeDto);
    }
    

    public List<NoticeDTO> list() {
        return sqlSession.selectList("notice.list");
    }

    
    public List<NoticeDTO> evl() {
        return sqlSession.selectList("notice.evl");
    }

    
    public List<NoticeDTO> search(String title) {
        return sqlSession.selectList("notice.search", "%" + title + "%");
    }

    
    public List<NoticeDTO> searching(String title) {
        return sqlSession.selectList("notice.searching", "%" + title + "%");
    }

    
    public NoticeDTO detail(int noticeid) {
        return sqlSession.selectOne("notice.detail", noticeid);
    }

    
    public void delete(int noticeid) {
        sqlSession.delete("notice.delete", noticeid);
    }

    
    public void update(NoticeDTO noticeDto) {
        sqlSession.update("notice.update", noticeDto);
    }

    
    public List<NoticeDTO> list2(int start, int end) {
        Map<String, Object> params = new HashMap<>();
        params.put("startRow", start - 1);
        params.put("endRow", end - start + 1);
        return sqlSession.selectList("notice.list2", params);
    }

    
    public int totalRowCount() {
        return sqlSession.selectOne("notice.totalRowCount");
    }
    
    
    public List<NoticeDTO> evl2(int start, int end) {
        Map<String, Object> params = new HashMap<>();
        params.put("startRow", start - 1);
        params.put("endRow", end - start + 1);
        return sqlSession.selectList("notice.evl2", params);
    }

    
    public int totalRowCount2() {
        return sqlSession.selectOne("notice.totalRowCount2");
    }


}