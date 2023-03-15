package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MypageSkillDomain {

	private int selfCount;			//자가 시험 수
	private int examCount;			//기술 시험 수
	private int friendCount;		//친구 스킬 인증 수
	private int badgeGetCount;		//벳지 획득 수
	
	private List<Skill> skillList;			//벳지 리스트
	
}
