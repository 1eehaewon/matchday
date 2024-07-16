package kr.co.matchday.mypage;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class MypageDTO {

	private String userID;
	private String password;
	private String email;
	private String address;
	private String zipcode;
	private String address1;
	private String address2;
	private String number;
	private String grade;
	private int totalpoints;

}// class end
