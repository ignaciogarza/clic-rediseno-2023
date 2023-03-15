package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@AllArgsConstructor
public class MessageFriendList {
	private int                 friendCount;
	private List<MessageFriend> friendList;
}
