package kr.co.matchday.reply;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class ReplyDTO {
	
	private int replyid;
	private int noticeid;
	private String content;
	private String userid;
	private String createddate;

}//class end
