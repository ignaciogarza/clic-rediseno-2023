package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ResumeEducationDomain {

	private int resumeEducationId;		//이력서 교육 아이디
	private String school;				//학교
	private String major;				//전공
	private String isWork;				//근무 여부
	private String isEducationDisplay;	//교육 노출 여부
	private String isDelete;			//삭제 여부
	private String admissionYear;		//입학 년
	private String admissionMonth;		//입학 월
	private String graduatedYear;		//졸업 년
	private String graduatedMonth;		//졸업 월
	private String createdDate;			//등록일자
	private String updatedDate;			//수정일자
	
	private int resumeId;				//이력서 아이디
	private String userId;				//회원 아이디
	
}
