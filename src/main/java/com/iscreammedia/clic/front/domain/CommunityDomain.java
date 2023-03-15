 package com.iscreammedia.clic.front.domain;

import java.util.List;

import com.iscreammedia.clic.front.controller.viewmodel.ViewCommunityList;

import lombok.Data;

@Data
public class CommunityDomain extends ViewCommunityList{
	
	protected CommunityDomain  portfolioCountList1;
	protected CommunityDomain  portfolioCountList2;		
	protected CommunityDomain  portfolioCountList3;	
	
	protected List<CommunityDomain>  chartDateList;	
	
	private String chartDate;
	private String chartDate1;
	private String chartDate2;
	private String chartDate3;
	private String chartDate4;
	private String chartDate5;
	private String chartDate6;
	private String chartDate7;
	
	private String chart1;
	private String chart2;
	private String chart3;
	private String chart4;
	private String chart5;
	private String chart6;
	private String chart7;
	
	
	private String friendId;
	private String userId;
	private String friendStatusCode;
	private String createdDate;
	private String creator;
	private String updatedDate;
	private String updater;
	private String portfolioId;
	private String portfolioHistory;
	
	private String friendAll;
	private String friendSend;
	private String friendReception;
	
	
	private String authComplete;
	private String authSend;
	private String authReception;
	
	//스킬친구인증 	
	private String skillCode;
	private String authContents;
	private String isAuth;
	private String authRequestDate;
	
	private String examClassCode;
	
	private String skillNameEng;
	private String skillNameSpa;
	private String skillName;
	
	private String skillProgressLevelCode;
	
	
	private String cityId;					//도시 아이디
	private String countryCode;				//국가코드
	private String jobId;					//직업 아이디
	private String jobNameEng;				//직업 영어
	private String jobNameSpa;				//직업 스폐인어
	private String jobName;
	
	private String email;					//이메일
	private String password;				//비밀번호
	private String userStatusCode;			//회원상태 코드
	private String passwordIsEarly;			//비밀번호 초기화여부
	private String userTypeCode;			//회원구분 코드
	private String name;					//이름
	private String firstName;				//성
	private int year;						//년
	private int month;						//월
	private int day;						//일
	private String sexCode;					//성별코드
	private String educationCode;			//학력코드
	private String isStudent;				//학생여부
	private String careerCode;				//경력코드
	private String tell;					//연락처
	private String userImagePath;			//회원이미지경로
	private String userBackgroundImagePath;	//화면배경이미지경로
	private String lastLoginDate;			//마지막 로그인일자
	
	//대시보드에서 사용
	private String useIf;
	
	private String authDateCheck;
	private String timeCheck;
	
	
	protected List<CommunityDomain>  friendCheckList;	
	
	private String noSearchType;
	
	private int allTotal;
	private int sendTotal;
	private int receptionTotal;
	
	protected CommunityDomain  friendCount;	
	protected CommunityDomain  skillAuthCount;	
	
	protected List<CommunityDomain>  friendReceptionList;
	
	protected List<CommunityDomain>  recommendFriendList;
	
	protected List<CommunityDomain>  skillList;
	protected List<CommunityDomain>  skillSendList;
	protected List<CommunityDomain>  skillReceptionList;


}
