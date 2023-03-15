package com.iscreammedia.clic.front.controller;

import java.util.Locale;

import javax.servlet.http.HttpSession;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.NoticeList;
import com.iscreammedia.clic.front.service.NoticeService;

import io.swagger.annotations.ApiOperation;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

@Controller
public class NoticeController {

	@Autowired
	private NoticeService noticeService;

	@ResponseBody
	@GetMapping("/notice/list")
	@ApiOperation(value = "알림 데이터 조회")
	public BaseResponse<NoticeList> getNoticeList(
			@RequestParam(name = "offset", defaultValue = "0") int offset,
			@RequestParam(name = "limit", defaultValue = "30") int limit,
			@SessionAttribute(name = "userId") String userId,
			HttpSession session,
			Locale locale
	) {
		String local = locale.toLanguageTag();
		return new BaseResponse<>(noticeService.getNoticeList(locale, userId, offset, limit, local));
	}
}
