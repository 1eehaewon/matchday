package kr.co.matchday.team;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.notice.NoticeDTO;

@Repository
public class TeamDAO {

    @Autowired
    SqlSession sqlSession;
    
    public TeamDAO() {
        System.out.println("-----TeamDAO() 객체 생성됨");
    }//TeamDAO() end
    
    
    public void insert(Map<String, Object> map) {
        sqlSession.insert("team.insert", map);
    }//insert() end
    
    
    public List<Map<String, Object>> list(){
        return sqlSession.selectList("team.list");
    }//list() end
    
    
    public List<TeamDTO> search(String teamname) {
        return sqlSession.selectList("team.search", "%" + teamname + "%");
    }
    
    
    public Map<String, Object> detail(String teamname){
        return sqlSession.selectOne("team.detail", teamname);
    }//detail() end
    
    
    public void update(Map<String, Object> map) {
        sqlSession.update("team.update", map);
    }
    
    
    public void delete(String teamname) {
        sqlSession.delete("team.delete", teamname);
    }//delete() end
    
    
    public String filename(String teamname) {
        return sqlSession.selectOne("team.filename", teamname);
    }//filename() end
    
    
}