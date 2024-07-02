package net.utility;

import javax.mail.*;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import java.util.Properties;

public class MailUtil {

    public static void sendMail(String recipient, String subject, String content) throws MessagingException {
        // SMTP 서버 정보 설정
        Properties props = new Properties();
        props.put("mail.smtp.host", "smtp.cafe24.com"); // 카페24 SMTP 서버 주소
        props.put("mail.smtp.port", "587"); // SMTP 포트 (TLS)
        props.put("mail.smtp.auth", "true");
        props.put("mail.smtp.starttls.enable", "true"); // TLS 사용
        props.put("mail.smtp.ssl.protocols", "TLSv1.2 TLSv1.1 TLSv1"); // TLS 버전 명시

        // 인증 정보 설정
        Session session = Session.getInstance(props, new MyAuthenticator());

        // 메일 작성
        Message message = new MimeMessage(session);
        message.setFrom(new InternetAddress("soldesk@pretyimo.cafe24.com")); // 발신자 이메일
        message.setRecipients(Message.RecipientType.TO, InternetAddress.parse(recipient));
        message.setSubject(subject);
        message.setContent(content, "text/html; charset=UTF-8");

        // 메일 전송
        Transport.send(message);
    }
}
