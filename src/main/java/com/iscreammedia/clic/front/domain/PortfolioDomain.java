package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Data;

@Data
public class PortfolioDomain {
	
	private String portfolioId;				//포토폴리오 아이디
	private String userId; 					//회원아이디
	private String sequence; 					//순서
	private String name; 						//이름
	private String publicTypeCode; 			//공개유형코드
	private String introduction; 				//소개
	private String listImagePath; 			//리스트 이미지경로
	private String backgroundImagePath;		//배경화면 이미지 경로
	private String isUseQr; 					//사용여부
	private String tag; 						//태그
	private String isDelete;					//여부삭제
	private String likeCount; 					//종아요 수
	private String projectCount; 				//프로젝트 수
	private String createdDate; 				//등록일자
	private String updatedDate; 				//수정일자
	private String countryCode;				//국가코드
	
	private String email;
	
	private String userName;
	private String firstName;
	private String jobNameEng;				//직업 영어
	private String jobNameSpa;				//직업 스폐인어
	private String userImagePath;			//회원이미지경로
	
	private String friendStatusCode;
	
	protected PortfolioDomain  portfolioInfo;
	protected List<CommonDomain>  publicList;
	protected List<String> concatWordsList;

}
