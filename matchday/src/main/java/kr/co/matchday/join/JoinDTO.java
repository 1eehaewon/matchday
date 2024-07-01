package kr.co.matchday.join;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class JoinDTO {
	private String userID;
	private String password;
	private String name;
	private String zipcode;
	private String address1;
	private String address2;
	private String emailID;
	private String emailDomain;
	private String number;
	private String gender;
	private char grade;
	private int points;
	private Timestamp joinDate;

}// class end
