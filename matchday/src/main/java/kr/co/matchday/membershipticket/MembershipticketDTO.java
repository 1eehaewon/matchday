package kr.co.matchday.membershipticket;



import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString 
public class MembershipticketDTO {

		private int price; // 가격
		private String userid; // 사용자 ID
		private int finalpaymentamount; // 최종 결제 금액
	    private String shippingstartdate; // 배송 시작 날짜
	    private String shippingenddate; // 배송 종료 날짜
	    private String shippingstatus; // 배송 상태
	    private String recipientname; // 수령인 이름
	    private String shippingaddress; // 배송 주소
	    private String shippingrequest; // 배송 요청 사항
	    private String impUid; // 결제 UID (추가된 필드)
	    
	
}