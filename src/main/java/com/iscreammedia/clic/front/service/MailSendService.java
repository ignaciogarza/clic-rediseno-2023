package com.iscreammedia.clic.front.service;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Properties;

import javax.mail.Message;
import javax.mail.MessagingException;
import javax.mail.Session;
import javax.mail.Transport;
import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

@Service
public class MailSendService {

	@Value("${spring.mail.host}")
	private String mailHost;
	
	@Value("${MailUsername}")
	private String mailUsername;
	
	@Value("${MailPass1}")
	private String mailPassword;
	
	@Value("${spring.mail.port}")
	private int mailPort;
	
	public String sendMail(String email, String key,String type, String locale) throws  MessagingException, IOException {
		
		
		String host = mailHost;		//smtp.gmail.com
		final String username = mailUsername; 
		final String password = mailPassword; 
		int port= mailPort; //포트번호 	
		
		// 메일 내용 
		String recipient = email; //받는 사람의 메일주소를 입력해주세요. 
		String subject = null; //메일 제목 입력해주세요. 	
		
		String fileName = null;
		
		Map<String, String> replaceMap = new HashMap<>();
		replaceMap.put("${key}", key);
		
		if(type.equals("E")) { 			
			if(locale.equals("en")) {
				subject = "Email verification number";  //     
				fileName = "emailNo.html";
			}else {
				subject = "Código de verificación de correo";  
				fileName = "emailNoSPA.html";
			}			
			
		}else if(type.equals("P")) {			
			if(locale.equals("en")) {
				subject = "Temporary password information";  
				fileName = "emailPassword.html";
			}else {
				subject = "Su contraseña temporal";  
				fileName = "emailPasswordSPA.html";
			}			
		}		
		Properties props = System.getProperties(); // 정보를 담기 위한 객체 생성 
		
		// SMTP 서버 정보 설정 
		props.put("mail.smtp.host", host); 
		props.put("mail.smtp.port", port); 
		props.put("mail.smtp.auth", "true"); 
		props.put("mail.smtp.ssl.enable", "true"); 
		props.put("mail.smtp.ssl.trust", host); 
		
		//Session 생성 
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() { 
			String un=username; 
			String pw=password; 
			@Override
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() { 
				return new javax.mail.PasswordAuthentication(un, pw); 
			} 
		}); 
		session.setDebug(true); //for debug 
		
		// 메일 템플릿 가져오기
		StringBuilder sb = new StringBuilder();		
		for(Object text : FileUtils.readLines(ResourceUtils.getFile("classpath:mail-template/" + fileName))) {
			sb.append(text);
		}		

		String html = sb.toString();
		for(Entry<String, String> entry : replaceMap.entrySet()) {  //keySet
			final String keys = entry.getKey();
			
			html = StringUtils.replace(html, keys, replaceMap.get(keys));
		}
		 
		Message mimeMessage = new MimeMessage(session); //MimeMessage 생성 		
		mimeMessage.setFrom(new InternetAddress(mailUsername)); //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요. 
		mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient)); //수신자셋팅 //.TO 외에 .CC(참조) .BCC(숨은참조) 도 있음 
		mimeMessage.setSubject(subject); //제목셋팅		
		//mimeMessage.setContent(bodyText,"text/html; charset=UTF-8"); // HTML 형식
		mimeMessage.setContent(html,"text/html; charset=UTF-8"); // HTML 형식		
		Transport.send(mimeMessage); //javax.mail.Transport.send() 이용 
				
		return "ok";
	}
	
	public String sendMailContact(String fromName, 
			String fromEmail,String subject,String contents) throws  MessagingException, IOException {
		String host = mailHost;		//smtp.gmail.com
		final String username = mailUsername; 
		final String password = mailPassword; 
		int port= mailPort; //포트번호 	
		
		// 메일 내용 
		String recipient = username; //받는 사람의 메일주소를 입력해주세요. 
		String fileName = "contact-us.html";
		
		Map<String, String> replaceMap = new HashMap<>();
		replaceMap.put("${fromName}", fromName);
		replaceMap.put("${fromEmail}", fromEmail);
		replaceMap.put("${subject}", subject);
		replaceMap.put("${contents}", contents);
		
		Properties props = System.getProperties(); // 정보를 담기 위한 객체 생성 
		// SMTP 서버 정보 설정 
		props.put("mail.smtp.host", host); 
		props.put("mail.smtp.port", port); 
		props.put("mail.smtp.auth", "true"); 
		props.put("mail.smtp.ssl.enable", "true"); 
		props.put("mail.smtp.ssl.trust", host); 
		
		//Session 생성 
		Session session = Session.getDefaultInstance(props, new javax.mail.Authenticator() { 
			String un=username; 
			String pw=password; 
			@Override
			protected javax.mail.PasswordAuthentication getPasswordAuthentication() { 
				return new javax.mail.PasswordAuthentication(un, pw); 
			} 
		}); 
		session.setDebug(true); //for debug 
		
		// 메일 템플릿 가져오기
		StringBuilder sb = new StringBuilder();
		for(Object text : FileUtils.readLines(ResourceUtils.getFile("classpath:mail-template/" + fileName))) {
			sb.append(text);
		}

		String html = sb.toString();
		for(Entry<String, String> entry : replaceMap.entrySet()) {  //keySet
			final String keys = entry.getKey();
			
			html = StringUtils.replace(html, keys, replaceMap.get(keys));
		}	
		 
		Message mimeMessage = new MimeMessage(session); //MimeMessage 생성 		
		mimeMessage.setFrom(new InternetAddress(mailUsername)); //발신자 셋팅 , 보내는 사람의 이메일주소를 한번 더 입력합니다. 이때는 이메일 풀 주소를 다 작성해주세요. 
		mimeMessage.setRecipient(Message.RecipientType.TO, new InternetAddress(recipient)); //수신자셋팅 //.TO 외에 .CC(참조) .BCC(숨은참조) 도 있음 
		mimeMessage.setSubject(subject); //제목셋팅		
		//mimeMessage.setContent(bodyText,"text/html; charset=UTF-8"); // HTML 형식
		mimeMessage.setContent(html,"text/html; charset=UTF-8"); // HTML 형식		
		Transport.send(mimeMessage); //javax.mail.Transport.send() 이용 
				
		return "ok";
	}
	
}
