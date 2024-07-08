package kr.co.matchday.tickets;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

/**
 * 티켓 정보를 담고 있는 데이터 전송 객체 (DTO)
 */
@Getter
@Setter
@NoArgsConstructor
@ToString
public class TicketsDTO {
    private String reservationid;
    private String matchid;
    private int quantity;
    private int price;
    private String userid;
    private String reservationdate;
    private String paymentmethodcode;
    private String reservationstatus;
    private String collectionmethodcode;
    private String membermembershipid;
    private String methodcode;
    private String couponid;
    private int usedpoints;
    private int finalpaymentamount;
    private String shippingstartdate;
    private String shippingenddate;
    private String shippingstatus;
    private String recipientname;
    private String shippingaddress;
    private String shippingrequest;
}
