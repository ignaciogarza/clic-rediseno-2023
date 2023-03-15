package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SkillEducationMappingDomain {

	private int skillEducationMappingId;	//스킬 교육 맵핑 아이디
	private int skillEducationId;			//스킬 교육 아이디
	private String skillCode;				//스킬 코드
	private String examClassCode;			//시험 등급 코드
	
	private String skillNameEng;			//영어 이름 (스킬 이름)
	private String skillNameSpa;			//스페인어 이름 (스킬 이름)
	
	private String skillName;

	
}
