package kr.co.matchday.tickets;

import java.util.HashMap;
import java.util.List;
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
    
    public List<Map<String, Object>> getSeatsByStadiumIdAndSection(String stadiumid, String section) {
        Map<String, Object> params = new HashMap<>();
        params.put("stadiumid", stadiumid);
        params.put("section", section);
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getSeatsByStadiumIdAndSection", params);
    }

    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getUserInfo", userID);
    }
    
    public void insertTicket(TicketsDTO ticket) {
        System.out.println("Inserting ticket: " + ticket);
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertTicket", ticket);
        System.out.println("Ticket inserted: " + ticket.getReservationid());
    }

    public void insertTicketDetail(TicketsDetailDTO ticketsDetail) {
        System.out.println("Inserting ticket detail: " + ticketsDetail);
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertTicketDetail", ticketsDetail);
        System.out.println("Ticket detail inserted: " + ticketsDetail.getTicketdetailid());
    }
    
    public boolean checkSeatId(String seatId) {
        Integer count = sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.checkSeatId", seatId);
        return count != null && count > 0;
    }
    
    public String getNextReservationIdSuffix(String date) {
        Map<String, Object> params = new HashMap<>();
        params.put("date", date);
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getNextReservationIdSuffix", params);
    }
}
