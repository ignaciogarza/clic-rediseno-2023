package com.iscreammedia.clic.front.domain;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Notice {
	private Integer noticeId;
	private String userId;
	private String noticeUserId;
	private NoticeTypeCode noticeTypeCode;
	private String noticeMessage;
	private String parameter1;
	private String parameter2;
	private String parameter3;
	private String parameter4;
	private String parameter5;
	private Date createdDate;

	private String name;
	private String firstName;

	private String badgeName;
}
