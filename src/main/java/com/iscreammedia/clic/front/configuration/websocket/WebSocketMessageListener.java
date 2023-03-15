package com.iscreammedia.clic.front.configuration.websocket;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.fasterxml.jackson.databind.ObjectMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Component
public class WebSocketMessageListener {
	
	Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private ObjectMapper objectMapper;
	

	/**
	 * Redis에서 메세지가 전송되면 onMessage가 해당 메세지를 받아 처리한다.
	 */
	public void onMessage() {
		try {
			log.info("onMessage");
		}
		catch(Exception e) {
			log.error(e.getMessage());
		}
	}

}
