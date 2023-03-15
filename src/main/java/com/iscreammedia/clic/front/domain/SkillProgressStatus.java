package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class SkillProgressStatus {
	private String  userId;                 // 회원 아이디
	private String  skillCode;              // 스킬 코드
	private String  examClassCode;          // 시험 등급 코드
	private Integer examId;                 // 시험 아이디
	private String  examProgressStatusCode; // 시험 진행 상태 코드
	private Integer friendRecommendCount;   // 친구 추천수

	public SkillProgressStatus(String userId, String skillCode, String examClassCode, String examProgressStatusCode) {
		this.userId = userId;
		this.skillCode = skillCode;
		this.examClassCode = examClassCode;
		this.examProgressStatusCode = examProgressStatusCode;
	}

	public SkillProgressStatus(String userId, String skillCode, String examClassCode, SkillProgressStatusCode skillProgressStatusCode) {
		this.userId = userId;
		this.skillCode = skillCode;
		this.examClassCode = examClassCode;
		this.examProgressStatusCode = skillProgressStatusCode.getExamProgressStatusCode();
	}

	public void setExamProgressStatusCode(SkillProgressStatusCode skillProgressStatusCode) {
		this.examProgressStatusCode = skillProgressStatusCode.getExamProgressStatusCode();
	}
}
