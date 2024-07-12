package kr.co.matchday.memberships;

import java.util.List;
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
}
