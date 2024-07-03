package kr.co.matchday.find;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

@Repository
public class FindDAO {
    
    public FindDAO() {
        System.out.println("FindDAO() 객체 생성");
    }

    @Autowired
    SqlSession sqlSession;

    public String findIdByNameAndEmail(String name, String email) {
        Map<String, Object> params = new HashMap<>();
        params.put("name", name);
        params.put("email", email);

        // Select one record from the database
        return sqlSession.selectOne("find.findIdByNameAndEmail", params);
    }
}
