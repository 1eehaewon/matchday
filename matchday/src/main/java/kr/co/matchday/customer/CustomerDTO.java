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
    
    private Integer inquiryID;           // 글번호
    private String title;                // 제목
    private String content;              // 내용
    private String referenceID;          // 참조ID (예매번호 / 주문번호 / 팀ID)
    private String userID;               // 회원ID
    private Date createdDate;            // 작성일
    private String formattedCreatedDate; // 포맷된 날짜를 저장할 필드 추가
    private String inquiryReply;         // 문의 답변
    private String isReplyHandled = "답변처리중";    // 답변 처리 여부
    private String boardType;            // 게시판 구분
    private int inqpasswd;               // 문의글 비밀번호
    private Date replyDate;              // 관리자 답변 시간
    private String formattedReplyDate;   // 관리자 답변 시간 형식
    private String category;             // 카테고리 필드 추가
    private int start;                   // 시작 필드 추가
    private int pageSize;                // 페이지 사이즈 필드 추가
    private String col;              	// 검색 컬럼
    private String word;             	// 검색어
    private Integer id;//임의의 경기, 상품 가져오기 위해.
    private String name;
    private String date;

    public void setReplyDate(Date replyDate) {
        this.replyDate = replyDate;
        if (replyDate != null) {
            SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");
            this.formattedReplyDate = sdf.format(replyDate);
        }
    }
}
