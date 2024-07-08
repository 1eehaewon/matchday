package kr.co.matchday.instagram;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.video.VideoDTO;

import java.util.List;

@Repository
public class InstagramDAO {

    @Autowired
    private SqlSession sqlSession;

    public List<InstagramDTO> list() {
        return sqlSession.selectList("instagram.list");
    }//list() end

    public void insert(InstagramDTO instagramDTO) {
        sqlSession.insert("instagram.insert", instagramDTO);
    }//insert() end

    public InstagramDTO getInstagram(int instagram_code) {
        return sqlSession.selectOne("instagram.getInstagram", instagram_code);
    }// getInstagram() end
 
    public InstagramDTO detail(int instagram_code) {
        return sqlSession.selectOne("instagram.detail", instagram_code);
    }//detail() end

    public void update(InstagramDTO instagramDTO) {
        sqlSession.update("instagram.update", instagramDTO);
    }//update() end

    public void delete(int instagram_code) {
        sqlSession.delete("instagram.delete", instagram_code);
    }//delete() end
           
}//class end
