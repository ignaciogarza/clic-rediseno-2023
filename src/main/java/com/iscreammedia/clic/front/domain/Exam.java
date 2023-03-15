package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Exam {
	protected Integer examId;             // 시험 아이디
	protected String  skillCode;          // 스킬 코드
	protected String  examClassCode;      // 시험 등급 코드
	protected String  examTitle;          // 시험 제목
	protected String  examContents;       // 시험 설명
	protected Integer limitTime;          // 제한 시간
	protected Integer totalQuestionCount; // 총 문항 수
	protected Integer passCriteria;       // 합격 기준

	protected String userId;
	protected Integer examProgressId;
	
	protected Integer selfExamId;              // 자가 시험 아이디
	protected Integer skillExamId;             // 기술 시험 아이디
}
