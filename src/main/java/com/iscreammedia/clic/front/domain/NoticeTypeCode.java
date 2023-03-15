package com.iscreammedia.clic.front.domain;

public enum NoticeTypeCode implements BaseCodeLabelEnum {
	FRIEND_REQUEST("0801"),
	SKILL_AUTH_REQUEST("0802"),
	SKILL_AUTH_COMPLETE("0803"),
	BADGE_OBTAIN("0804"),
	PROJECT_LIKE("0805"),
	;

	private String codes;

	private NoticeTypeCode(String code) {
		this.codes = code;
	}

	@Override
	public String code() {
		return this.codes;
	}

	@Override
	public String label() {
		return name();
	}
}
