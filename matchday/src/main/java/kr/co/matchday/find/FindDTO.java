package kr.co.matchday.find;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class FindDTO {
	private String userID;
	private String password;
	private String email;
	private String name;
	private String token;
}//class end
