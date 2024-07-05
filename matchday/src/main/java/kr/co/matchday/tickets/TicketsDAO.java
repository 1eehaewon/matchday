package kr.co.matchday.tickets;

import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import kr.co.matchday.matches.MatchesDTO;

@Repository
public class TicketsDAO {

	@Autowired
	private SqlSession sqlSession;
	
	public MatchesDTO getMatchById(String matchid) {
        System.out.println("Fetching match with matchid: " + matchid);
        MatchesDTO match = sqlSession.selectOne("tickets.getMatchById", matchid);
        if (match == null) {
            System.out.println("No match found with matchid: " + matchid);
        } else {
            System.out.println("Match found: " + match.toString());
        }
        return match;
    }
	
	private List<TicketsDTO> seats; // 좌석 정보를 포함하는 리스트
	
}
