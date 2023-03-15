package com.iscreammedia.clic.front.scheduler;

import com.iscreammedia.clic.front.repository.NoticeRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

@Profile({ "local", "stage", "production" })
@Component
public class NoticeScheduler {

	@Autowired
	private NoticeRepository noticeRepository;

	/**
	 * 3개월(12주, 84일)된 알림 삭제
	 * </p>
	 * 매일 1시
	 * @throws Exception
	 */
	@Scheduled(cron = "* * 1 * * *")
	public void deleteNotice(){
		noticeRepository.deleteNoticeOlder3Months();
	}
}
