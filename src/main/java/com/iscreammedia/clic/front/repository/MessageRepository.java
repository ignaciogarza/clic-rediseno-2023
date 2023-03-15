package com.iscreammedia.clic.front.repository;

import java.util.List;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Message;
import com.iscreammedia.clic.front.domain.MessageFriend;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface MessageRepository {

	/**
	 * 메세지 등록
	 * @param param
	 */
	public void insertMessage(Message param);

	/**
	 * 메세지 그룹 등록
	 * @param param
	 */
	public void insertMessageGroup(MessageFriend param);

	/**
	 * 메세지 참여 회원 등록
	 * @param param
	 */
	public void insertMessageJoinUser(MessageFriend param);

	/**
	 * 메세지 확인
	 * @param userId
	 * @param messageGroupId
	 * @param messageId
	 */
	public void updateMessageConfirmation(
			@Param("userId") String userId,
			@Param("messageGroupId") int messageGroupId,
			@Param("messageId") int messageId
	);

	/**
	 * 메세지 전체
	 * @param userId
	 * @param messageGroupId
	 */
	public void updateMessageConfirmationAll(
			@Param("userId") String userId,
			@Param("messageGroupId") int messageGroupId
	);

	/**
	 * 메세지 그룹 아이디 조회
	 * @param friendId
	 * @param userId
	 * @return
	 */
	public int getMessageGroupId(@Param("friendId") String friendId, @Param("userId") String userId);

	/**
	 * 메세지 팝업에서 노출되는 친구 수
	 * @param language
	 * @param userId
	 * @param searchKeyword
	 * @return
	 */
	public int getFriendCount(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("searchKeyword") String searchKeyword
	);

	/**
	 * 메세지 팝업에서 노출되는 친구 목록
	 * @param language
	 * @param userId
	 * @param searchKeyword
	 * @param offset
	 * @param limit
	 * @return
	 */
	public List<MessageFriend> getFriendList(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("searchKeyword") String searchKeyword,
			@Param("offset") int offset,
			@Param("limit") int limit
	);

	/**
	 * 메세지 수
	 * @param messageGroupId
	 * @param userId
	 * @return
	 */
	public int getMessageCount(@Param("messageGroupId") int messageGroupId, @Param("userId") String userId);

	/**
	 * 메세지 목록
	 * @param messageGroupId
	 * @param userId
	 * @param offset
	 * @param limit
	 * @return
	 */
	public List<Message> getMessageList(
			@Param("messageGroupId") int messageGroupId,
			@Param("userId") String userId,
			@Param("offset") int offset,
			@Param("limit") int limit
	);

	/**
	 * 신규 메시지 확인
	 * @param userId
	 * @return
	 */
	public boolean confirmNewMessage(@Param("userId") String userId);
}
