package kr.co.matchday.tickets;

import java.util.Date;
import java.util.List;

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
    private String reservationid; // 예약 ID
    private String matchid; // 경기 ID
    private int quantity; // 수량
    private int price; // 가격
    private String userid; // 사용자 ID
    private String reservationdate; // 예약 날짜
    private String paymentmethodcode; // 결제 방법 코드
    private String reservationstatus; // 예약 상태
    private String collectionmethodcode; // 수령 방법 코드
    private String membershipid; // 회원 ID
    private String methodcode; // 방법 코드
    private String couponid; // 쿠폰 ID
    private int usedpoints; // 사용된 포인트
    private int finalpaymentamount; // 최종 결제 금액
    private String shippingstartdate; // 배송 시작 날짜
    private String shippingenddate; // 배송 종료 날짜
    private String shippingstatus; // 배송 상태
    private String recipientname; // 수령인 이름
    private String shippingaddress; // 배송 주소
    private String shippingrequest; // 배송 요청 사항
    private String impUid; // 결제 UID
    private String userName; // 사용자 이름
    private String stadiumName; // 경기장 이름
    private String location; // 경기장 위치
    private String paymentmethodname; // 결제 방법 이름
    private List<TicketsDetailDTO> details; // 티켓 상세 정보 리스트
    private Date cancelDeadline; // 취소 마감시간
    private Date matchdate; // 경기 날짜
    private String hometeam;
    private String awayteam;
    private int discount;
}
