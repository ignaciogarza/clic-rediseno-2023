package com.iscreammedia.clic.front.domain;

public enum ExamQuestionTypeCode implements BaseCodeLabelEnum {
	CHOICE("0501"),
	MULTI_CHOICE("0502"),
	ANSWER("0503"),
	LINE_DRAWING("0504"),
	SCALE("0505"),
	;

	private String codes;

	private ExamQuestionTypeCode(String code) {
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
