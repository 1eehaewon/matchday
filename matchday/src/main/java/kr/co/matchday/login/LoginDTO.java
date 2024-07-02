package kr.co.matchday.login;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Setter
@Getter
@ToString
@NoArgsConstructor
public class LoginDTO {
	private String userID;
    private String password;
    private char grade; //등급
}//class end
