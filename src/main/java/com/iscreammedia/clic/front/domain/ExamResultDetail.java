package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamResultDetail {
	private Integer measureLevel;
	private String  title;
	private String  contents;
	private Integer selfQuestionCount;
	private Integer selfAnswerCount;
	private Integer selfScore;
	private Integer skillQuestionCount;
	private Integer skillAnswerCount;
	private Integer skillScore;
}
