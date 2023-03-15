package com.iscreammedia.clic.front.domain;

import java.util.Locale;

import org.apache.commons.lang3.StringUtils;

public enum LanguageCode implements BaseCodeLabelEnum {
	EN("영어", "ENG"), ES("스페인어", "SPA"),
	KO("영어", "ENG") // 삭제 예정
	;


	private String labels;
	private String codes;

	private LanguageCode(String label, String code) {
		this.labels = label;
		this.codes = code;
	}

	@Override
	public String code() {
		return this.codes;
	}

	@Override
	public String label() {
		return this.labels;
	}

	public static LanguageCode getLanguage(Locale locale) {
		if(locale == null) {
			locale = Locale.ENGLISH;
		}
		return LanguageCode.valueOf(StringUtils.substring(String.valueOf(locale), 0, 3).toUpperCase());
	}
}