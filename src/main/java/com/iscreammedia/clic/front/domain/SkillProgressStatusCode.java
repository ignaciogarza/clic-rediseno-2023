package com.iscreammedia.clic.front.domain;

import lombok.Getter;

@Getter
public enum SkillProgressStatusCode {
	NOT_TESTED("1201", ""),
	PASS("1205", ""),
	/* */
	SELF_EXAM_WAIT("1202", "1401"),
	SELF_EXAM_TAKING("1202", "1402"),
	SELF_EXAM_TIME_OUT("1202", "1403"),
	SELF_EXAM_FAILED("1202", "1404"),
	SELF_EXAM_PASS("1202", "1405"),
	/* */
	SKILL_EXAM_WAIT("1203", "1401"),
	SKILL_EXAM_TAKING("1203", "1402"),
	SKILL_EXAM_TIME_OUT("1203", "1403"),
	SKILL_EXAM_FAILED("1203", "1404"),
	SKILL_EXAM_PASS("1203", "1405"),
	/* */
	FRIEND_AUTH_WAIT("1204", "1401"),
	FRIEND_AUTH_TAKING("1204", "1402"),
	FRIEND_AUTH_PASS("1204", "1405"),
	;

	private String skillProgressLevelCode;
	private String examProgressStatusCode;
	private SkillProgressStatusCode(String skillProgressLevelCode, String examProgressStatusCode) {
		this.skillProgressLevelCode = skillProgressLevelCode;
		this.examProgressStatusCode = examProgressStatusCode;
	}
}