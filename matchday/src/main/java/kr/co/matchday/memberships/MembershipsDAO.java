package kr.co.matchday.memberships;

import java.util.List;
import java.util.Map;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class MembershipsDAO {

    public MembershipsDAO() {
        System.out.println("-----MembershipsDAO() 객체 생성됨");
    }

    @Autowired
    private SqlSession sqlSession;

    public void insert(MembershipsDTO membershipsDto) {
        sqlSession.insert("memberships.insert", membershipsDto);
    }

    public List<MembershipsDTO> list() {
        return sqlSession.selectList("memberships.list");
    }

    public MembershipsDTO detail(String membershipid) {
        return sqlSession.selectOne("memberships.detail", membershipid);
    }

    public MembershipsDTO read(String membershipid) {
        return sqlSession.selectOne("memberships.detail", membershipid);
    }

    public void delete(String membershipid) {
        sqlSession.delete("memberships.delete", membershipid);
    }

    public void update(MembershipsDTO membershipsDto) {
        sqlSession.update("memberships.update", membershipsDto);
    }

    public String filename(String membershipid) {
        return sqlSession.selectOne("memberships.filename", membershipid);
    }

    // 팀 이름 가져오기
    public List<String> getTeamNames() {
        return sqlSession.selectList("memberships.getTeamNames");
    }

    // 페이징을 위한 메서드 추가
    public List<MembershipsDTO> listWithPaging(Map<String, Object> params) {
        return sqlSession.selectList("memberships.listWithPaging", params);
    }

    public int countMemberships() {
        return sqlSession.selectOne("memberships.countMemberships");
    }

    // 검색 기능을 위한 메서드 추가
    public List<MembershipsDTO> search(Map<String, Object> params) {
        return sqlSession.selectList("memberships.search", params);
    }
}
