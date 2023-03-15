package com.iscreammedia.clic.front.service;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Message;
import com.iscreammedia.clic.front.domain.MessageFriend;
import com.iscreammedia.clic.front.domain.MessageFriendList;
import com.iscreammedia.clic.front.domain.MessageList;
import com.iscreammedia.clic.front.domain.MessageSocket;
import com.iscreammedia.clic.front.repository.MessageRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class MessageService {

	@Autowired
	private MessageRepository messageRepository;

	/**
	 * 메세지 팝업에서 노출되는 친구 목록
	 * @param language
	 * @param userId
	 * @param searchKeyword
	 * @param offset
	 * @param limit
	 * @return
	 */
	public MessageFriendList getFriendList(Locale locale, String userId, String searchKeyword, int offset, int limit) {

		int totalCount = messageRepository.getFriendCount(LanguageCode.getLanguage(locale), userId, searchKeyword);
		List<MessageFriend> friendList = messageRepository.getFriendList(LanguageCode.getLanguage(locale), userId,
				searchKeyword, offset, limit);

		MessageFriend param = null;
		for(MessageFriend friend : friendList) {
			// 메세지 그룹이 없을 경우 생성
			if(friend.getMessageGroupId() == null) {
				param = new MessageFriend();
				messageRepository.insertMessageGroup(param);

				// 메세지 참여 등록
				param.setFriendId(friend.getUserId());
				param.setUserId(userId);
				messageRepository.insertMessageJoinUser(param);

				// 메세지 참여 등록
				param.setFriendId(userId);
				param.setUserId(friend.getUserId());
				messageRepository.insertMessageJoinUser(param);

				friend.setMessageGroupId(param.getMessageGroupId());
			}
		}
		return new MessageFriendList(totalCount, friendList);
	}

	/**
	 * 메세지 목록
	 * @param messageGroupId
	 * @param userId
	 * @param offset
	 * @param limit
	 * @return
	 */
	public MessageList getMessageList(int messageGroupId, String userId, int offset, int limit) {
		int totalCount = messageRepository.getMessageCount(messageGroupId, userId);
		int totalPage = (int) ((float) totalCount / limit) + (totalCount % limit > 0 ? 1 : 0);

		if(totalCount > 0) {
			messageRepository.updateMessageConfirmationAll(userId, messageGroupId);

			return new MessageList(totalPage, totalCount,
					messageRepository.getMessageList(messageGroupId, userId, offset, limit));
		}
		return new MessageList(totalPage, totalCount, new ArrayList<>());
	}

	public void insertMessage(String userId, MessageSocket messageSocket) {
		Message param = new Message(messageSocket.getMessageGroupId(), messageSocket.getMessage(), messageSocket.getTrans(), userId);
		messageRepository.insertMessage(param);

		messageSocket.setMessageId(param.getMessageId());
	}

	public void updateMessageConfirmation(String userId, int messageGroupId, int messageId) {
		messageRepository.updateMessageConfirmation(userId, messageGroupId, messageId);
	}
}
