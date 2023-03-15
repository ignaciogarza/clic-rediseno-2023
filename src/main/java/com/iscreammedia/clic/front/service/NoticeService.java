package com.iscreammedia.clic.front.service;

import java.util.Locale;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Notice;
import com.iscreammedia.clic.front.domain.NoticeList;
import com.iscreammedia.clic.front.domain.NoticeTypeCode;
import com.iscreammedia.clic.front.repository.NoticeRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;

@Service
public class NoticeService {

	@Autowired
	private NoticeRepository noticeRepository;

	@Autowired
	private MessageSource messageSource;

	public NoticeList getNoticeList(Locale locale, String userId, int offset, int limit, String local) {
		noticeRepository.updateNoticeConfirmation(userId);
		return new NoticeList(noticeRepository.getNoticeCount(userId),
				noticeRepository.getNoticeList(LanguageCode.getLanguage(locale), userId, offset, limit, local));
	}

	public void insertSkillAuthRequest(Locale locale, String skillName, String friendId, String userId) {
		Notice param = new Notice();
		param.setUserId(friendId);
		param.setNoticeUserId(userId);
		param.setNoticeTypeCode(NoticeTypeCode.SKILL_AUTH_REQUEST);
		param.setParameter1(skillName);
		param.setNoticeMessage(messageSource.getMessage("notice.message2", null, locale));

		noticeRepository.insertNotice(param);
	}

	public void insertSkillAuthComplete(
			Locale locale,
			String skillName,
			String skillCode,
			String examClassCode,
			String friendId,
			String userId
	) {
		Notice param = new Notice();
		param.setUserId(userId);
		param.setNoticeUserId(friendId);
		param.setNoticeTypeCode(NoticeTypeCode.SKILL_AUTH_COMPLETE);
		param.setParameter1(skillName);
		param.setParameter2(skillCode);
		param.setParameter3(examClassCode);
		param.setNoticeMessage(messageSource.getMessage("notice.message3", new String[] { skillName }, locale));

		noticeRepository.insertNotice(param);
	}

	public void insertBadgeObtain(
			Locale locale,
			String skillName,
			String skillCode,
			String examClassCode,
			String userId
	) {
		Notice param = new Notice();
		param.setUserId(userId);
		param.setNoticeUserId(userId);
		param.setNoticeTypeCode(NoticeTypeCode.BADGE_OBTAIN);
		param.setParameter1(skillName);
		param.setParameter2(skillCode);
		param.setParameter3(examClassCode);
		param.setNoticeMessage(messageSource.getMessage("notice.message4", null, locale));

		noticeRepository.insertNotice(param);
	}

	public void insertFriendRequest(Locale locale, String userId, String friendId) {
		Notice param = new Notice();
		param.setUserId(friendId);
		param.setNoticeUserId(userId);
		param.setNoticeTypeCode(NoticeTypeCode.FRIEND_REQUEST);
		param.setNoticeMessage(messageSource.getMessage("notice.message1", null, locale));

		noticeRepository.insertNotice(param);
	}
	
	
	public void insertProjectLikeRequest(Locale locale, String userId, String friendId, String portfolioId, String projectId) {
		Notice param = new Notice();
		param.setUserId(friendId);
		param.setNoticeUserId(userId);
		param.setParameter1(portfolioId);
		param.setParameter2(projectId);
		param.setNoticeTypeCode(NoticeTypeCode.PROJECT_LIKE);
		param.setNoticeMessage(messageSource.getMessage("notice.message5", null, locale));

		noticeRepository.insertNotice(param);
	}
}
