package com.iscreammedia.clic.front.repository;

import java.util.List;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Notice;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface NoticeRepository {

	/**
	 * 알림 총 개수
	 * @param userId
	 * @return
	 */
	public int getNoticeCount(@Param("userId") String userId);

	/**
	 * 알림 목록 조회
	 * @param language
	 * @param userId
	 * @param offset
	 * @param limit
	 * @return
	 */
	public List<Notice> getNoticeList(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("offset") int offset,
			@Param("limit") int limit,
			@Param("local") String local
	);

	/**
	 * 신규 알림 확인
	 * @param userId
	 * @return
	 */
	public boolean confirmNewNotice(@Param("userId") String userId);

	/**
	 * 알림 등록
	 * @param param
	 */
	public void insertNotice(Notice param);

	/**
	 * 알림 확인
	 * @param userId
	 */
	public void updateNoticeConfirmation(@Param("userId") String userId);

	/**
	 * 3개월(12주, 84일)된 알림 삭제
	 */
	public void deleteNoticeOlder3Months();
}