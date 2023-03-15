package com.iscreammedia.clic.front.domain;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamQuestion extends Exam {
	private Integer questionId;        // 문항 아이디
	//private Integer examProgressId;    // 자가/기술 시험 진헹 아이디
	private Integer questionNumber;    // 문항 번호
	private String  questionTitle;     // 문항 제목
	private String  questionContents;  // 문항 내용
	private String  questionImagePath; // 문항 이미지 경로

	private ExamQuestionTypeCode questionTypeCode; // 문항 종류 코드

	private Integer displaySequence; // 노출 순서
	private String  isProgress;      // 진행 여부

	private Date examStartTime;   // 시험 시작 시간
	private Date examLimitTime;   // 시험 종료 시간

	private Skill skill;

	private List<ExamExample> exampleList1; // 문항 보기 (선긋기 오른쪽 보기)
	private List<ExamExample> exampleList2; // 선긋기 왼쪽 보기

	private ExamAnswer answer; // 답변

	public String getExamStartTime() {
		return String.valueOf(examStartTime.getTime());
	}

	public String getExamLimitTime() {
		return String.valueOf(examLimitTime.getTime());
	}

	public void setQuestionTypeCode(String questionTypeCode) {
		for(ExamQuestionTypeCode code : ExamQuestionTypeCode.values()) {
			if(code.code().equals(questionTypeCode)) {
				this.questionTypeCode = code;
				break;
			}
		}
	}
}
