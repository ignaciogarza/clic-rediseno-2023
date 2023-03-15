package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ExamResult {
	private String  skillCode;
	private Integer selfExamProgressId;
	private boolean selfComplete;
	private boolean selfPass;
	private Integer selfFinalScore;
	private Integer skillExamProgressId;
	private boolean skillComplete;
	private boolean skillPass;
	private Integer skillFinalScore;
	private Integer friendRecommendCount;   // 친구 추천수

	private List<ExamResultDetail> detailList;

	private List<SkillFriendAuth> authList;
	
	private Skill dataSkill;
	
	private UserDomain user;
	private List<CommunityDomain> friendCheckList;
}
