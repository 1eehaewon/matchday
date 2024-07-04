package kr.co.matchday.cardnews;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString 
public class CardnewsDTO {
    

	private int    cardnewsid;
    private String cardnewstitle;
    private String description;
    private String cardnewsurl;
    private String regdate;
    
	
	
	
}//class end

