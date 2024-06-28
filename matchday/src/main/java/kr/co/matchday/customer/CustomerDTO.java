package kr.co.matchday.customer;

import java.text.SimpleDateFormat;
import java.util.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class CustomerDTO {
	
	public Integer inquiryID; 			//글번호
	public String title;			//제
	public String content;			//내용
	public String referenceID;		//참조ID (예매번호 / 주문번호 / 팀ID)
	public String userID;			//회원ID
	public Date createdDate;		//작성일
	private String formattedCreatedDate; // 포맷된 날짜를 저장할 필드 추가
	public String inquiryReply;		//문의 답변
	public String isReplyHandled = "답변처리중";	//답변 처리 여부
	public int BoardType;			//게시판 구분
	public int inqpasswd;			// 문의글 비밀번호
	private Date replyDate;  		// 관리자 답변 시간
	private String formattedReplyDate; //관리자 답변 시간 형식
	
	public void setReplyDate(Date replyDate) {
        this.replyDate = replyDate;
        if (replyDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            this.formattedReplyDate = sdf.format(replyDate);
        }
    }
	
}//class end
