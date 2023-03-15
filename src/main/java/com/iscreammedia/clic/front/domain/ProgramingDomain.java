package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ProgramingDomain {

	private String programingId;			//프로그래밍 아이디
	private String programingName;
	private String programingNameEng;		//프로그래밍 영어 이름
	private String programingNameSpa;		//프로그래밍 스펜인어 이름
	
}
