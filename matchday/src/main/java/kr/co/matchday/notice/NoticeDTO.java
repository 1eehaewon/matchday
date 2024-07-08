package kr.co.matchday.notice;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class NoticeDTO {
	
	private int noticeid;
	private String title;
	private String content;
	private String userid;
	private Timestamp createddate;
	private Timestamp modifieddate;
	private String category;

}//class end
