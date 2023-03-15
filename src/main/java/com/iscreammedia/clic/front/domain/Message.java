package com.iscreammedia.clic.front.domain;

import java.util.Date;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class Message {
	private Integer messageId;       // 메세지 아이디
	private Integer messageGroupId;  // 메세지 그룹 아이디
	private String  messageContents; // 메세지 내용
	private Date    transDate;       // 전송 일자
	private String  creator;         // 등록자
	private boolean isFrom;          // 본인 작성 여부

	public Message(Integer messageGroupId, String messageContents, Date transDate, String creator) {
		this.messageGroupId = messageGroupId;
		this.messageContents = messageContents;
		this.transDate = transDate;
		this.creator = creator;
	}
}
