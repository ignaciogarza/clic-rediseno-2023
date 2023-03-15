package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@NoArgsConstructor
public class HaveSkill {
	private String userId;                // 회원 아이디
	private String skillCode;             // 스킬 코드
	private String examClassCode;         // 시험 등급 코드
	/**
	 * 스킬 진행 단계 코드
	 * <ul>
	 * <li>1201 : 미진행 단계
	 * <li>1202 : 자가 시험 단계
	 * <li>1203 : 기술 시험 단계
	 * <li>1204 : 친구 추천 단계
	 * <li>1205 : 완료 단계
	 */
	private String skillProgressLevelCode;

	public HaveSkill(String userId, String skillCode, String examClassCode, String skillProgressLevelCode) {
		this.userId = userId;
		this.skillCode = skillCode;
		this.examClassCode = examClassCode;
		this.skillProgressLevelCode = skillProgressLevelCode;
	}

	public HaveSkill(
			String userId, String skillCode, String examClassCode, SkillProgressStatusCode skillProgressStatusCode
	) {
		this.userId = userId;
		this.skillCode = skillCode;
		this.examClassCode = examClassCode;
		this.skillProgressLevelCode = skillProgressStatusCode.getSkillProgressLevelCode();
	}

	public void setSkillProgressLevelCode(SkillProgressStatusCode skillProgressStatusCode) {
		this.skillProgressLevelCode = skillProgressStatusCode.getExamProgressStatusCode();
	}
}
