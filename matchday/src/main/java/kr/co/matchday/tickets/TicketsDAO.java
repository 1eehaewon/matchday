package kr.co.matchday.tickets;

import java.util.HashMap;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import kr.co.matchday.matches.MatchesDTO;

@Mapper
@Repository
public class TicketsDAO {

    @Autowired
    private SqlSession sqlSession;

    /**
     * 주어진 matchid에 해당하는 경기 정보를 가져오는 메서드.
     * @param matchid 경기 ID
     * @return MatchesDTO 경기 정보
     */
    public MatchesDTO getMatchById(String matchid) {
        System.out.println("Fetching match with matchid: " + matchid);
        MatchesDTO match = sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getMatchById", matchid);
        if (match == null) {
            System.out.println("No match found with matchid: " + matchid);
        } else {
            System.out.println("Match found: " + match.toString());
        }
        return match;
    }

    /**
     * 주어진 userID에 해당하는 사용자 정보를 가져오는 메서드.
     * @param userID 사용자 ID
     * @return Map<String, Object> 사용자 정보
     */
    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getUserInfo", userID);
    }
    
    // 티켓 예약 정보를 삽입하는 메서드
    public void insertTicket(TicketsDTO ticket) {
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertTicket", ticket);
    }

    // 티켓 상세 정보를 삽입하는 메서드
    public void insertTicketDetail(TicketsDetailDTO ticketsDetail) {
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertTicketDetail", ticketsDetail);
    }
    
    // 예약 ID의 다음 suffix를 가져오는 메서드
    public String getNextReservationIdSuffix(String date) {
        Map<String, Object> params = new HashMap<>();
        params.put("date", date);
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getNextReservationIdSuffix", params);
    }
    
}
