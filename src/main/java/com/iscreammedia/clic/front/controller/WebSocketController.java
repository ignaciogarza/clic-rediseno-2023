package com.iscreammedia.clic.front.controller;

import java.util.Date;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.Payload;
import org.springframework.messaging.simp.SimpMessageHeaderAccessor;
import org.springframework.stereotype.Controller;

import com.iscreammedia.clic.front.configuration.exception.AccessDeniedException;
import com.iscreammedia.clic.front.domain.MessageSocket;
import com.iscreammedia.clic.front.service.MessageService;
import com.iscreammedia.clic.front.service.WebSocketService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class WebSocketController {

	@Autowired
	private MessageService messageService;

	@Autowired
	private WebSocketService webSocketService;
	
	private static final String USERID = "userId";	

	@MessageMapping("/message")
	public void sendMessage(@Payload MessageSocket message, SimpMessageHeaderAccessor headerAccessor) {
		if(headerAccessor.getSessionAttributes().get(USERID) == null) {
			throw new AccessDeniedException();
		}
		String userId = (String) headerAccessor.getSessionAttributes().get(USERID);

		message.setTrans(new Date());
		messageService.insertMessage(userId, message);

		log.info("@@ message : {}", message);
		//webSocketService.publish();
	}

	@MessageMapping("/enter")
	public void enter(@Payload MessageSocket message, SimpMessageHeaderAccessor headerAccessor){
		if(headerAccessor.getSessionAttributes().get(USERID) == null) {
			throw new AccessDeniedException();
		}
		
	}
}
