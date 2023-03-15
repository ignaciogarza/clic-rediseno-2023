package com.iscreammedia.clic.front.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonAlias;

import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class MessageSocket {
	private static final long serialVersionUID = 7418513284447329786L;

	@JsonAlias({ "gId" })
	private int     messageGroupId; // 메세지 그룹 아이디
	@JsonAlias({ "mId" })
	private Integer messageId;      // 메세지 그룹 아이디
	@JsonAlias({ "fId" })
	private String  fromId;
	@JsonAlias({ "tId" })
	private String  toId;
	@JsonAlias({ "m" })
	private String  message;        // 메세지 내용
	private Date    trans;          // 전송 일자
	// private MessageType type; // 메세지 타입

	public enum MessageType {
		IN, OUT
	}
}
