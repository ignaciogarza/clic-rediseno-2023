package com.iscreammedia.clic.front.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class MessageFriend {
	@JsonIgnore
	private String friendId;     // 친구 아이디
	private String userId;       // 회원 아이디
	private String countryCode;
	private String name;
	private String firstName;
	private String nickname;
	private String userImagePath;
	private String jobName;

	private Integer messageGroupId; // 메세지 그룹 아이디
	private boolean isConfirmation; // 확인 여부
	private Date    transDate;      // 전송 일자
	// private String isDel; // 삭제 여부

	private int messageCount;

	public MessageFriend(String friendId, String userId) {
		this.friendId = friendId;
		this.userId = userId;
	}
}
