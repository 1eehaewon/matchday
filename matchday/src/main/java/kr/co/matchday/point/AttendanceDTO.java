package kr.co.matchday.point;

import java.sql.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class AttendanceDTO {
	private String userid;
	private Date last_attendance;
	
	// 생성자 추가
    public AttendanceDTO(String userid, Date last_attendance) {
        this.userid = userid;
        this.last_attendance = last_attendance;
    }
}
