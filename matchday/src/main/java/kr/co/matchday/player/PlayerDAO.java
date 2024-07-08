package kr.co.matchday.player;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.notice.NoticeDTO;

@Repository
public class PlayerDAO {

    @Autowired
    SqlSession sqlSession;
    
    public PlayerDAO() {
        System.out.println("-----PlayerDAO() 객체 생성됨");
    }//TeamDAO() end
    
    
    public void insert(Map<String, Object> map) {
        sqlSession.insert("player.insert", map);
    }//insert() end
    
    
    public List<Map<String, Object>> list(String teamname) {
        return sqlSession.selectList("player.list", teamname);
    }
    
    
    public Map<String, Object> detail(String playerid) {
        return sqlSession.selectOne("player.detail", playerid);
    }

    
    public void update(Map<String, Object> map) {
        sqlSession.update("player.update", map);
    }
    
    
    public void delete(String playerid) {
        sqlSession.delete("player.delete", playerid);
    }//delete() end
    
    
    public String filename(String playerid) {
        return sqlSession.selectOne("player.filename", playerid);
    }//filename() end
    
    
}//class end