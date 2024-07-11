package kr.co.matchday.tickets;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.matches.MatchesDTO;

@Mapper
@Repository
public class TicketsDAO {

    @Autowired
    private SqlSession sqlSession;

    /**
     * 경기 ID로 경기 정보를 가져오는 메서드
     * @param matchid 경기 ID
     * @return MatchesDTO 객체
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
     * 경기장 ID와 구역으로 좌석 정보를 가져오는 메서드
     * @param stadiumid 경기장 ID
     * @param section 구역
     * @return 좌석 정보 리스트
     */
    public List<Map<String, Object>> getSeatsByStadiumIdAndSection(String stadiumid, String section) {
        Map<String, Object> params = new HashMap<>();
        params.put("stadiumid", stadiumid);
        params.put("section", section);
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getSeatsByStadiumIdAndSection", params);
    }

    /**
     * 사용자 ID로 사용자 정보를 가져오는 메서드
     * @param userID 사용자 ID
     * @return 사용자 정보 맵
     */
    public Map<String, Object> getUserInfo(String userID) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getUserInfo", userID);
    }
    
    /**
     * 사용자 ID로 쿠폰 목록을 가져오는 메서드
     * @param userId 사용자 ID
     * @return 쿠폰 목록
     */
    public List<CouponDTO> getCouponsByUserId(String userId) {
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getCouponsByUserId", userId);
    }

    /**
     * 쿠폰 ID로 할인율을 가져오는 메서드
     * @param couponId 쿠폰 ID
     * @return 할인율
     */
    public int getDiscountRateByCouponId(String couponId) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getDiscountRateByCouponId", couponId);
    }
    
    /**
     * 쿠폰의 사용 상태를 업데이트하는 메서드
     * @param couponId 쿠폰 ID
     */
    public int updateCouponUsage(String couponId) {
        System.out.println("쿠폰 사용 업데이트 시도: " + couponId);
        int result = sqlSession.update("kr.co.matchday.tickets.TicketsDAO.updateCouponUsage", couponId);
        if (result > 0) {
            System.out.println("쿠폰 사용 업데이트 성공: " + couponId);
        } else {
            System.out.println("쿠폰 사용 업데이트 실패: " + couponId);
        }
        return result;
    }

    /**
     * 티켓 정보를 데이터베이스에 삽입하는 메서드
     * @param ticket TicketsDTO 객체
     */
    public void insertTicket(TicketsDTO ticket) {
        System.out.println("Inserting ticket: " + ticket);
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertTicket", ticket);
        System.out.println("Ticket inserted: " + ticket.getReservationid());
    }

    /**
     * 티켓 상세 정보를 데이터베이스에 삽입하는 메서드
     * @param ticketsDetail TicketsDetailDTO 객체
     */
    public void insertTicketDetail(TicketsDetailDTO ticketsDetail) {
        System.out.println("Inserting ticket detail: " + ticketsDetail);
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertTicketDetail", ticketsDetail);
        System.out.println("Ticket detail inserted: " + ticketsDetail.getTicketdetailid());
    }

    /**
     * 좌석 ID 존재 여부를 확인하는 메서드
     * @param seatId 좌석 ID
     * @return 존재 여부 (1이면 존재, 0이면 존재하지 않음)
     */
    public int checkSeatId(String seatId) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.checkSeatId", seatId);
    }

    /**
     * 주어진 날짜에 대한 현재 최대 예약 ID를 가져오는 메서드
     * @param date 날짜 문자열 (yyyyMMdd 형식)
     * @return 현재 최대 예약 ID
     */
    public String getMaxReservationId(String date) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getMaxReservationId", date);
    }

    /**
     * 새로운 예약 ID를 생성하는 메서드 (트랜잭션 내에서 호출되어야 함)
     * @param date 날짜 문자열 (yyyyMMdd 형식)
     * @return 새로 생성된 예약 ID
     */
    @Transactional
    public String generateNewReservationId(String date) {
        String prefix = "reservation";
        String maxReservationId = getMaxReservationId(date);
        int nextSuffix = 1;
        if (maxReservationId != null) {
            // 예약 ID의 숫자 부분을 추출하여 다음 순번을 계산
            nextSuffix = Integer.parseInt(maxReservationId.substring(maxReservationId.length() - 6)) + 1;
        }
        // 새로운 예약 ID를 생성하여 반환
        return String.format("%s%s%06d", prefix, date, nextSuffix);
    }

    /**
     * 좌석 ID로 좌석 정보를 JSON 형식으로 가져오는 메서드
     * @param seatId 좌석 ID
     * @return 좌석 정보 맵
     */
    public Map<String, Object> getSeatInfoByJson(String seatId) {
        Map<String, Object> params = new HashMap<>();
        params.put("seatId", seatId);
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getSeatInfoByJson", params);
    }

    /**
     * 좌석 ID로 좌석 정보를 가져오는 메서드
     * @param seatId 좌석 ID
     * @return 좌석 정보 맵
     */
    public Map<String, Object> getSeatInfo(String seatId) {
        Map<String, Object> params = new HashMap<>();
        params.put("seatId", seatId);
        System.out.println("Fetching seat info for seatId: " + seatId);
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getSeatInfoByJson", params);
    }
}
