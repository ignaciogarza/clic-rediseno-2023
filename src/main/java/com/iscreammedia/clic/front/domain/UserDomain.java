package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Data;

@Data
public class UserDomain {

	private int no;
	private String userId;					//회원 아이디
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
	private String createdDate;
	private String creator;
	private String updatedDate;
	private String updater;
	
	private String skillName;
	
	private String osType;
	
	//설문조사
	private String isComplete;				//설문조사 완료여부
	
	//회원탈퇴
	private String leverReasonCode;			//탈퇴사유 코드
	private String leaveReason;
	
	private UserDomain userDetail;
	
	private List<CommonDomain> countryList;
	private List<CommonDomain> jobList;
	private List<CommonDomain> educationList;
	private List<CommonDomain> careerList;
	
	private List<SurveyDomain> surveyQuestionList;
	private List<SurveyDomain> surveyExampleList;
	private List<Integer> questionIdList;
	
	private String isNewNotice;
	private String language;
	
	private String sessionData;
	private int limitDate;
	
}
