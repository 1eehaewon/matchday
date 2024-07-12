package kr.co.matchday.memberships;

import java.sql.Timestamp;
import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString 
public class MembershipsDTO {
     
    private String membershipid;
    private String membershipname;
    private String teamname; // 팀 이름 필드 추가
    private int price;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date startdate;
    
    @DateTimeFormat(pattern = "yyyy-MM-dd")
    private Date enddate;
    
    private String notes;
    private int discountamount;
    private String filename;
    private long filesize;
}
