package com.iscreammedia.clic.front.service;

import java.io.IOException;
import java.util.Map;
import java.util.Map.Entry;

import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.util.ResourceUtils;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class TemplateMailService {

	@Autowired
	private JavaMailSender mailSender;

	@Async(value = "mailSenderExecutor")
	public void mailSendWithAsync(String to, String from, String subject, Map<String, String> replaceMap, String fileName) 
			throws IOException, MessagingException{
		mailSend(to, from, subject, replaceMap, fileName);
	}

	public void mailSend(String to, String from, String subject, Map<String, String> replaceMap, String fileName) 
			throws IOException, MessagingException{
		
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

			MimeMessage message = mailSender.createMimeMessage();
			MimeMessageHelper messageHelper = new MimeMessageHelper(message, true, "UTF-8");
			messageHelper.setTo(to);
			messageHelper.setFrom(from);
			messageHelper.setSubject(subject);
			messageHelper.setText(html, true);
			mailSender.send(message);
		

	}
}
