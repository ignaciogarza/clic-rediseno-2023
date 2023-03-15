package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ResumeCareerDomain {

	private int resumeCareerMattersId;		//이력서 경력 사항 아이디
	private String company;					//회사
	private String position;				//직급
	private String isWork;					//근무 여부
	private String isCareerDisplay;			//경력 노출 여부
	private String jobContents;				//업무 내용
	private String isDelete;				//삭제 여부
	private String joinYear;				//입사 년
	private String joinMonth;				//입사 월
	private String leaveYear;				//퇴사 년
	private String leaveMonth;				//퇴사 월
	private String createdDate;				//등록일자
	private String updatedDate;				//수정일자
	
	private int resumeId;					//이력서 아이디
	private String userId;					//회원 아이디
	
}
