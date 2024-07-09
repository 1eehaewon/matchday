package kr.co.matchday.tickets;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 티켓 상세 정보를 담고 있는 데이터 전송 객체 (DTO)
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class TicketsDetailDTO {
    private int ticketdetailid; // 티켓 상세 ID
    private String reservationid; // 예약 ID
    private String matchid; // 경기 ID
    private String seatid; // 좌석 ID
    private int price; // 가격
    private int membershipdiscountamount; // 회원 할인 금액
    private int coupondiscountamount; // 쿠폰 할인 금액
    private int totalamount; // 총 금액
    private boolean iscanceled; // 취소 여부
    private boolean isrefunded; // 환불 여부
    private String canceldate; // 취소 날짜
}
