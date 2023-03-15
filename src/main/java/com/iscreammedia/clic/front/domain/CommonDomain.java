package com.iscreammedia.clic.front.domain;

import lombok.Data;

@Data
public class CommonDomain {

	//국가
	private String countryCode;
	private String countryNameSpa;
	private String countryNameEng;
	private String countryName;
	
	//도시
	private String cityId;
	private String cityNameEng;
	private String cityNameSpa;
	private String cityName;
	
	//직업
	private String jobId;
	private String jobNameEng;
	private String jobNameSpa;
	private String jobName;
	
	//코드
	private String major;
	private String minor; 
	private String nameKor; 
	private String nameEng; 
	private String nameSpa;
	private String name;
	
	
	
}
