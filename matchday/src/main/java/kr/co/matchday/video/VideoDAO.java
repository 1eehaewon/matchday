package kr.co.matchday.video;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class VideoDAO {

    @Autowired
    SqlSession sqlSession;

    public void insert(VideoDTO videoDTO) {
        sqlSession.insert("video.insert", videoDTO);
    }

    public List<VideoDTO> list() {
        return sqlSession.selectList("video.list");
    }

    public VideoDTO detail(int video_code) {
        return sqlSession.selectOne("video.detail", video_code);
    }

    public void update(VideoDTO videoDTO) {
        sqlSession.update("video.update", videoDTO);
    }

    public void delete(int video_code) {
        sqlSession.delete("video.delete", video_code);
    }

    public List<VideoDTO> search(String video_name) {
        return sqlSession.selectList("video.search", "%" + video_name + "%");
    }

    public List<VideoDTO> listWithPaging(Map<String, Integer> params) {
        return sqlSession.selectList("video.listWithPaging", params);
    }

    public int countVideos() {
        return sqlSession.selectOne("video.countVideos");
    }
    
}//class end
