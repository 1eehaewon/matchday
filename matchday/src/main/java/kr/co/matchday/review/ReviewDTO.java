package kr.co.matchday.review;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString

public class ReviewDTO {

    private String reviewid; // 리뷰 ID
    private String userid;   // 회원 ID
    private String matchid;  // 경기 ID
    private String goodsid;  // 굿즈 ID
    private String orderid;  // 주문 ID 추가
    private Timestamp reviewdate; // 리뷰 작성 날짜
    private String title;    // 리뷰 제목
    private String content;  // 리뷰 내용
    private int rating;      // 평점
    private int grantedpoints; // 지급된 포인트
    private String filename; // 리뷰 사진 이름
    private long filesize;   // 리뷰 사진 크기
    
}//class end
