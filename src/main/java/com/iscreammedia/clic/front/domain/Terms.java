package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Terms {
	private int    termsId;
	private String termsTypeCode;
	private String termsTitle;
	private String termsContents;
	private String contentsStatusCode;
	private String isMandatory;
	private String createdDate;
	private String creator;
	private String updatedDate;
	private String updater;
	private String code;
}
