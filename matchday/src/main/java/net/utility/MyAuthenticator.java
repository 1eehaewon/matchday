package net.utility;

import javax.mail.Authenticator;
import javax.mail.PasswordAuthentication;

public class MyAuthenticator extends Authenticator{
	// 사용하고자 하는 메일서버(SMTP, POP3)에서 인증받은 계정 + 비번 등록
	
	private PasswordAuthentication pa;
	
	public MyAuthenticator () { //기본생성자 함수 default constructor
		pa = new PasswordAuthentication("soldesk@pretyimo.cafe24.com", "soldesk6901"); //이름, 비번
	}// end
	
	@Override
	protected PasswordAuthentication getPasswordAuthentication() {
		return pa;
	}
	
}//class end
