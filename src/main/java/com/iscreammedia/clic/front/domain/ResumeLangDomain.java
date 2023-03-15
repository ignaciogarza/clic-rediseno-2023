package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ResumeLangDomain {

	private int resumeLangId;			//이력서 언어 아이디
	private String langId;				//언어 아이디
	private String langTitle;			//언어
	private String measureTypeCode;		//척도 구분 코드
	private String measureLevel;		//척도 단계
	private String isDelete;			//삭제 여부
	private String createdDate;			//등록일자
	private String updatedDate;			//수정일자
	
	private int resumeId;				//이력서 아이디
	private String userId;				//회원 아이디
	private String langName;
	private String langNameEng;			//언어 영어이름
	private String levelName;
	private String titleEng;			//영어 제목
	
}
