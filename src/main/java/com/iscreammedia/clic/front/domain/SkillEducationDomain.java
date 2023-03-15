package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SkillEducationDomain {

	private int skillEducationId;			//스킬 교육 아이디
	private String titleEng;				//제목 영어
	private String titleSpa;				//제목 스페인어
	private String contentsEng;				//설명 영어
	private String contentsSpa;				//설명 스페인어
	private String imagePathEng;			//이미지 경로 영어
	private String imagePathSpa;			//이미지 경로 스페인어
	private String educationPcUrl;			//교육 PC URL
	private String educationMobileUrl;		//교육 Mobile URL
	private String educationOrganization;	//교육 기관
	private String educationPeriod;			//교육 기간
	private String educationCoast;			//교육 비용
	private String isUse;					//사용유무
	private String createdDate;				//등록일자
	private String creator;					//등록자
	private String updatedDate;				//수정일자
	private String updater;					//수정자
	
	private String skillCode;				//스킬 코드
	private String examClassCode;			//시험 등급 코드
	
	private String title;
	private String contents;
	private String imagePath;
	
	private List<SkillEducationMappingDomain> skillMapping;
	
}
