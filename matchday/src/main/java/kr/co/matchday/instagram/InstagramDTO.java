package kr.co.matchday.instagram;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@NoArgsConstructor
@Getter
@Setter
@ToString 
public class InstagramDTO {
    private int instagram_code; 
    private String instagram_url;
    private String instagram_name;
}