package kr.co.matchday.tickets;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import kr.co.matchday.coupon.CouponDTO;
import kr.co.matchday.matches.MatchesDTO;
import kr.co.matchday.point.PointHistoryDTO;

@Service
public class TicketsService {

    @Autowired
    private TicketsDAO ticketsDao;

    /**
     * 경기 ID로 경기 정보를 가져오는 메서드
     * @param matchid 경기 ID
     * @return MatchesDTO 객체
     */
    public MatchesDTO getMatchById(String matchid) {
        return ticketsDao.getMatchById(matchid);
    }

    /**
     * 경기장 ID와 구역으로 좌석 정보를 가져오는 메서드
     * @param stadiumid 경기장 ID
     * @param section 구역
     * @return 좌석 정보 리스트
     */
    public List<Map<String, Object>> getSeatsByStadiumIdAndSection(String stadiumid, String section) {
        return ticketsDao.getSeatsByStadiumIdAndSection(stadiumid, section);
    }

    /**
     * 사용자 ID로 사용자 정보를 가져오는 메서드
     * @param userID 사용자 ID
     * @return 사용자 정보 맵
     */
    public Map<String, Object> getUserInfo(String userID) {
        return ticketsDao.getUserInfo(userID);
    }
    
    /**
     * 사용자 ID로 쿠폰 목록을 가져오는 메서드
     * @param userId 사용자 ID
     * @return 쿠폰 목록
     */
    public List<CouponDTO> getCouponsByUserId(String userId) {
        return ticketsDao.getCouponsByUserId(userId);
    }

    /**
     * 쿠폰 ID로 할인율을 가져오는 메서드
     * @param couponId 쿠폰 ID
     * @return 할인율
     */
    public int getDiscountRateByCouponId(String couponId) {
        return ticketsDao.getDiscountRateByCouponId(couponId);
    }
    
    /**
     * 쿠폰의 사용 상태를 업데이트하는 메서드
     * @param couponId 쿠폰 ID
     */
    public int updateCouponUsage(String couponId) {
        return ticketsDao.updateCouponUsage(couponId);
    }

    /**
     * 티켓 정보를 데이터베이스에 삽입하는 메서드
     * @param ticket TicketsDTO 객체
     */
    public void insertTicket(TicketsDTO ticket) {
        ticketsDao.insertTicket(ticket);
    }

    /**
     * 티켓 상세 정보를 데이터베이스에 삽입하는 메서드
     * @param ticketsDetail TicketsDetailDTO 객체
     */
    public void insertTicketDetail(TicketsDetailDTO ticketsDetail) {
        ticketsDao.insertTicketDetail(ticketsDetail);
    }

    /**
     * 좌석 ID 존재 여부를 확인하는 메서드
     * @param seatId 좌석 ID
     * @return 존재 여부 (1이면 존재, 0이면 존재하지 않음)
     */
    public int checkSeatId(String seatId) {
        return ticketsDao.checkSeatId(seatId);
    }

    /**
     * 주어진 날짜에 대한 현재 최대 예약 ID를 가져오는 메서드
     * @param date 날짜 문자열 (yyyyMMdd 형식)
     * @return 현재 최대 예약 ID
     */
    public String getMaxReservationId(String date) {
        return ticketsDao.getMaxReservationId(date);
    }

    /**
     * 새로운 예약 ID를 생성하는 메서드 (트랜잭션 내에서 호출되어야 함)
     * @param date 날짜 문자열 (yyyyMMdd 형식)
     * @return 새로 생성된 예약 ID
     */
    @Transactional
    public String generateNewReservationId(String date) {
        return ticketsDao.generateNewReservationId(date);
    }

    /**
     * 좌석 ID로 좌석 정보를 JSON 형식으로 가져오는 메서드
     * @param seatId 좌석 ID
     * @return 좌석 정보 맵
     */
    public Map<String, Object> getSeatInfoByJson(String seatId) {
        return ticketsDao.getSeatInfoByJson(seatId);
    }

    /**
     * 좌석 ID로 좌석 정보를 가져오는 메서드
     * @param seatId 좌석 ID
     * @return 좌석 정보 맵
     */
    public Map<String, Object> getSeatInfo(String seatId) {
        return ticketsDao.getSeatInfo(seatId);
    }
    
    /**
     * 사용자 ID로 예약 정보 가져오기
     * @param userId 사용자 ID
     * @return 예약 정보 리스트
     */
    public List<Map<String, Object>> getReservationsByUserId(String userId) {
        return ticketsDao.getReservationsByUserId(userId);
    }

    /**
     * 경기 ID로 예약된 좌석 가져오기
     * @param matchid 경기 ID
     * @return 예약된 좌석 리스트
     */
    public List<String> getReservedSeats(String matchid) {
        return ticketsDao.getReservedSeats(matchid);
    }
    
    /**
     * 예약 ID로 예약 정보 조회
     * @param reservationid 예약 ID
     * @return TicketsDTO 객체
     */
    public TicketsDTO getReservationById(String reservationid) {
        return ticketsDao.getReservationById(reservationid);
    }

    /**
     * 예약 ID로 티켓 상세 정보 조회
     * @param reservationid 예약 ID
     * @return TicketsDetailDTO 리스트
     */
    public List<TicketsDetailDTO> getTicketDetailsByReservationId(String reservationid) {
        return ticketsDao.getTicketDetailsByReservationId(reservationid);
    }
    
    /**
     * 사용자 ID로 사용자가 가지고 있는 멤버십 정보를 가져오는 메서드
     * @param userId 사용자 ID
     * @return 멤버십 정보 리스트
     */
    public List<Map<String, Object>> getMembershipsByUserId(String userId) {
        return ticketsDao.getMembershipsByUserId(userId);
    }
    
    /**
     * 예약 상태를 업데이트하는 메서드
     * @param reservationid 예약 ID
     * @param status 업데이트할 상태
     */
    @Transactional
    public void updateReservationStatus(String reservationid, String status) {
        ticketsDao.updateReservationStatus(reservationid, status);
    }
    
    /**
     * 예약 ID로 imp_uid 가져오는 메서드
     * @param reservationid 예약 ID
     * @return imp_uid
     */
    public String getImpUidByReservationId(String reservationid) {
        return ticketsDao.getImpUidByReservationId(reservationid);
    }
    
    /**
     * 쿠폰 사용 상태를 'Not Used'로 업데이트하는 메서드
     * @param couponId 쿠폰 ID
     * @return 업데이트된 행의 수
     */
    public int resetCouponUsage(String couponId) {
        System.out.println("Service: Resetting coupon usage for couponId: " + couponId);
        return ticketsDao.resetCouponUsage(couponId);
    }
    
    /**
     * 포인트 기록 삽입 메서드
     * @param pointHistoryDTO 포인트 기록 DTO
     */
    public void insertPointHistory(PointHistoryDTO pointHistoryDTO) {
        ticketsDao.insertPointHistory(pointHistoryDTO);
    }
    
    /**
     * 카테고리 ID로 적립률 가져오기
     * @param pointcategoryid 포인트 카테고리 ID
     * @return 적립률
     */
    public double getRateByCategoryId(String pointcategoryid) {
        return ticketsDao.getRateByCategoryId(pointcategoryid);
    }
    
    /**
     * 예약 ID로 포인트 기록 조회
     * @param reservationid 예약 ID
     * @return PointHistoryDTO 객체
     */
    public PointHistoryDTO getPointHistoryByReservationId(String reservationid) {
        return ticketsDao.getPointHistoryByReservationId(reservationid);
    }
    
    /**
     * 예약 ID로 포인트 기록 취소
     * @param reservationid 예약 ID
     */
    public void cancelPointHistoryByReservationId(String reservationid) {
        PointHistoryDTO pointHistory = getPointHistoryByReservationId(reservationid);
        if (pointHistory != null) {
            pointHistory.setPointtype("취소");
            ticketsDao.insertPointHistory(pointHistory);
        }
    }
}
