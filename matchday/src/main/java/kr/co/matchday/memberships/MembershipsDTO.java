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
       private int price;
       
       @DateTimeFormat(pattern = "yyyy-MM-dd") // 지정된 패턴으로 날짜를 바인딩
       private Date startdate;
       
       @DateTimeFormat(pattern = "yyyy-MM-dd") // 지정된 패턴으로 날짜를 바인딩
       private Date enddate;
       
       private String notes;
       private int discountamount;
       private String filename;
       private long filesize;
   
}//class end
