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
    private int ticketdetailid;
    private String reservationid;
    private String matchid;
    private String seatid;
    private int price;
    private int membershipdiscountamount;
    private int coupondiscountamount;
    private int totalamount;
    private boolean iscanceled;
    private boolean isrefunded;
    private String canceldate;
}
