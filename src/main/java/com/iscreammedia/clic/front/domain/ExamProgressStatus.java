package com.iscreammedia.clic.front.domain;

import java.util.Date;
import java.util.List;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class ExamProgressStatus {
	private Integer examProgressId;         // 자가/기술 시험 진행 아이디
	private String  userId;                 // 회원 아이디
	private String  examProgressStatusCode; // 시험 진행 상태 코드
	private Date    examStartTime;          // 시험 시작 시간
	private String  isComplete;             // 완료 여부
	private String  isPass;                 // 합격 여부
	private Integer finalScore;             // 최종 점수 (정답률)
	private Integer examEvaluation;         // 시험 평가
	private String  examEvaluationContents; // 시험 평가 내용

	private String  skillCode;     // 스킬 코드
	private String  examClassCode; // 시험 등급 코드
	private Integer examId;        // 시험 아이디

	private List<ExamMeasure> examMeasureList;

	public ExamProgressStatus(String userId, String skillCode, String examClassCode, String examProgressStatusCode) {
		this.userId = userId;
		this.skillCode = skillCode;
		this.examClassCode = examClassCode;
		this.examProgressStatusCode = examProgressStatusCode;
	}

	public ExamProgressStatus(String userId, String skillCode, String examClassCode, SkillProgressStatusCode skillProgressStatusCode) {
		this.userId = userId;
		this.skillCode = skillCode;
		this.examClassCode = examClassCode;
		this.examProgressStatusCode = skillProgressStatusCode.getExamProgressStatusCode();
	}

	public void setExamProgressStatusCode(SkillProgressStatusCode skillProgressStatusCode) {
		this.examProgressStatusCode = skillProgressStatusCode.getExamProgressStatusCode();
	}
}
