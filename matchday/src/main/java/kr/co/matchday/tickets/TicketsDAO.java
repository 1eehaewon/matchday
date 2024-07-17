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
import kr.co.matchday.point.PointHistoryDTO;

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
        Map<String, Object> params = new HashMap<>();
        params.put("userId", userId);
        params.put("applicableProduct", "Ticket");
        params.put("usage", "Not Used");
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getCouponsByUserId", params);
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
    
    /**
     * 사용자 ID로 예약 정보 가져오기
     * @param userId 사용자 ID
     * @return 예약 정보 리스트
     */
    public List<Map<String, Object>> getReservationsByUserId(String userId) {
        List<Map<String, Object>> reservations = sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getReservationsByUserId", userId);
        if (reservations == null || reservations.isEmpty()) {
            System.out.println("No reservations found for userId: " + userId);
        } else {
            System.out.println("Reservations found: " + reservations.size());
        }
        return reservations;
    }

    /**
     * 경기 ID로 예약된 좌석 가져오기
     * @param matchid 경기 ID
     * @return 예약된 좌석 리스트
     */
    public List<String> getReservedSeats(String matchid) {
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getReservedSeats", matchid);
    }
    
    /**
     * 예약 ID로 예약 정보 조회
     * @param reservationid 예약 ID
     * @return TicketsDTO 객체
     */
    public TicketsDTO getReservationById(String reservationid) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getReservationById", reservationid);
    }

    /**
     * 예약 ID로 티켓 상세 정보 조회
     * @param reservationid 예약 ID
     * @return TicketsDetailDTO 리스트
     */
    public List<TicketsDetailDTO> getTicketDetailsByReservationId(String reservationid) {
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getTicketDetailsByReservationId", reservationid);
    }
    
    /**
     * 사용자 ID로 사용자가 가지고 있는 멤버십 정보를 가져오는 메서드
     * @param userId 사용자 ID
     * @return 멤버십 정보 리스트
     */
    public List<Map<String, Object>> getMembershipsByUserId(String userId) {
        return sqlSession.selectList("kr.co.matchday.tickets.TicketsDAO.getMembershipsByUserId", userId);
    }
    
    /**
     * 예약 상태를 업데이트하는 메서드
     * @param reservationid 예약 ID
     * @param status 업데이트할 상태
     */
    public void updateReservationStatus(String reservationid, String status) {
        Map<String, String> params = new HashMap<>();
        params.put("reservationid", reservationid);
        params.put("status", status);
        sqlSession.update("kr.co.matchday.tickets.TicketsDAO.updateReservationStatus", params);
    }
    
    /**
     * 예약 ID로 imp_uid 가져오는 메서드
     * @param reservationid 예약 ID
     * @return imp_uid
     */
    public String getImpUidByReservationId(String reservationid) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getImpUidByReservationId", reservationid);
    }
    
    /**
     * 쿠폰 사용 상태를 'Not Used'로 업데이트하는 메서드
     * @param couponId 쿠폰 ID
     * @return 업데이트된 행의 수
     */
    public int resetCouponUsage(String couponId) {
        System.out.println("Updating coupon usage to 'Not Used' for couponId: " + couponId);
        int result = sqlSession.update("kr.co.matchday.tickets.TicketsDAO.resetCouponUsage", couponId);
        System.out.println("Update result (Not Used): " + result);
        return result;
    }
    
    /**
     * 포인트 적립 정보를 데이터베이스에 삽입하는 메서드
     * @param pointHistoryDTO PointHistoryDTO 객체
     */
    public void insertPointHistory(PointHistoryDTO pointHistoryDTO) {
        sqlSession.insert("kr.co.matchday.tickets.TicketsDAO.insertPointHistory", pointHistoryDTO);
    }
    
    public double getRateByCategoryId(String pointcategoryid) {
        return sqlSession.selectOne("kr.co.matchday.tickets.TicketsDAO.getRateByCategoryId", pointcategoryid);
    }


}