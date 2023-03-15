package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Faq {
	private Integer faqId;
	private String faqTypeCode;
	private String display;
	private String title;
	private String contents;
}
