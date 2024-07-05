package kr.co.matchday.admin;

import java.sql.Timestamp;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class AdminDTO {
	private String userid;
	private String password;
	private String email;
	private String address;
	private String zipcode;
	private String address1;
	private String address2;
	private String number;
	private String grade;
	private int points;
	private Timestamp joinDate;
}//class end
