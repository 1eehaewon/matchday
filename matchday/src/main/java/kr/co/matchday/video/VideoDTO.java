package kr.co.matchday.video;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString 
public class VideoDTO {
    
    //private String video_name; // 데이터베이스의 video_name 컬럼에 매핑
    //private String description; // 데이터베이스의 description 컬럼에 매핑
    //private String video_url; // 데이터베이스의 video_url 컬럼에 매핑
    
    private int video_code;
    private String video_name;
    private String description;
    private String video_url;
    private String regdate;
    
    // 생성자, Getter, Setter, toString 메소드 생략
    
}//class end

