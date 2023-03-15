package com.iscreammedia.clic.front.controller;

import java.util.Locale;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.configuration.http.BaseResponseCode;
import com.iscreammedia.clic.front.domain.MessageFriendList;
import com.iscreammedia.clic.front.domain.MessageList;
import com.iscreammedia.clic.front.service.MessageService;

//@Controller
public class MessageController {

	@Autowired
	private MessageService messageService;

	@ResponseBody
	@GetMapping("/message/friend/list")
	public BaseResponse<MessageFriendList> getFriendList(
			@RequestParam(name = "searchKeyword", required = false) String searchKeyword,
			@RequestParam(name = "offset", defaultValue = "0") int offset,
			@RequestParam(name = "limit", defaultValue = "30") int limit,
			@SessionAttribute(name = "userId") String userId,
			HttpSession session,
			Locale locale
	) {
		return new BaseResponse<>(messageService.getFriendList(locale, userId, searchKeyword, offset, limit));
	}

	@ResponseBody
	@GetMapping("/message/list")
	public BaseResponse<MessageList> getMessageList(
			@RequestParam(name = "messageGroupId") int messageGroupId,
			@RequestParam(name = "offset", defaultValue = "0") int offset,
			@RequestParam(name = "limit", defaultValue = "30") int limit,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {

		return new BaseResponse<>(messageService.getMessageList(messageGroupId, userId, offset, limit));
	}

	@ResponseBody
	@PostMapping("/message/confirm")
	public BaseResponse<String> confirm(
			@RequestParam(name = "messageGroupId") int messageGroupId,
			@RequestParam(name = "messageId") int messageId,
			@SessionAttribute(name = "userId") String userId
	) {

		messageService.updateMessageConfirmation(userId, messageGroupId, messageId);
		return new BaseResponse<>(BaseResponseCode.SUCCESS);
	}
}
