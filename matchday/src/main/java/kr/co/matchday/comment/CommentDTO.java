package kr.co.matchday.comment;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString
public class CommentDTO {
    
    private int cno;
    private int video_code;
    private String content;
    private String wname;
    private String regdate;
    
    
  
}//class end
