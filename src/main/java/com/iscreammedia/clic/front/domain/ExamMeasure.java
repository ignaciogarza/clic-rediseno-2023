package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamMeasure {
	private String measureId;
	private String title;
	private String contents;
	private int    questionCount;

	private String skillCode;     // 스킬 코드
	private String examClassCode; // 시험 등급 코드

	private Integer answerCount;  // 정답 수
	private Integer measureScore; // 평가 항목별 점수 (정답률)
}
