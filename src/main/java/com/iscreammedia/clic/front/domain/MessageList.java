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
public class MessageList {
	private int           messageTotalPage;
	private int           messageCount;
	private List<Message> messageLists;
}
