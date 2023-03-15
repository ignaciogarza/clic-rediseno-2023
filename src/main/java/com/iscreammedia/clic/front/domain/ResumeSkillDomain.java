package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ResumeSkillDomain {

	private int resumeHaveSkillId;		//이력서 스킬 아이디
	private String skillName;			//스킬 이름
	private String measureTypeCode;		//척도구분코드
	private String measureLevel;			//척도 단계
	private String isDelete;			//삭제 여부
	private String createdDate;			//등록일자
	private String updatedDate;			//수정일자
	
	private int resumeId;				//이력서 아이디
	private String userId;				//회원 아이디
	private String levelName;
	private String titleEng;			//영어 제목
	
}
