package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class LanguageDomain {

	private String langId;			//언어 아이디
	private String langName;
	private String langNameEng;		//언어 영어 이름
	private String langNameSpa;		//언어 스펜인어 이름
	
}
