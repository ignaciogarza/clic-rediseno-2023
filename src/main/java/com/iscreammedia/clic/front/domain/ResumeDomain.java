package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ResumeDomain {

	private int resumeId;					//이력서 아이디
	private String userId;					//회원 아이디
	private String imagePath;				//이미지 경로
	private String selfIntroduction;		//자기 소개
	private String resumeTemplateCode;		//이력서 템플릿 코드
	private String createdDate;				//등록일자
	private String updatedDate;				//수정일자
	private int qrPortfolioId;				//QR 포트폴리오 아이디
	private String isPictureDisplay;		//사진 노출 여부
	private String isYearmonthdayDisplay;	//년월일 노출 여부
	private String isCountryDisplay;		//국가 노출 여부
	private String isCareerDisplay;			//경력 노출 여부
	private String isEducationDisplay;		//교육 노출 여부
	private String isAboutMeDisplay;		//자기소개 노출 여부
	private String isHaveSkillDisplay;		//보유 스킬 노출 여부
	private String isProgramDisplay;		//프로그램 노출 여뷰
	private String isLangDisplay;			//언어 노출 여부
	private String isQrPortfolioDisplay;	//QR 포트폴리오 노출 여부
	private String isAddressDisplay;		//주소 노출 여부
	private String isSexDisplay;			//성별 노출 여부
	
	private String name;					//이름
	private String firstName;				//성
	private String year;						//년
	private String month;						//월
	private String day;						//일
	private String email;					//이메일
	private String encryptEmail;			//암호화이메일
	private String tell;					//연락처
	
	private String jobName;
	
	private String sex;
	private String nameKor;					//이름 한글(성별)
	private String nameEng;					//이름 영어(성별)
	private String nameSpa;					//이름 스페인어(성별)
	
	private String countryCode;
	private String countryName;
	private String countryNameSpa;			//국가 이름 스페인어
	private String countryNameEng;			//국가 이름 영어
	private String cityName;
	
	private int resumeCareerMattersId;		//이력서 경격 사항 아이디
	
	private String portfolioId;				//포트폴리오 아이디
	private String portfolioName;			//포트폴리오 이름(DB컬럼명 name)
	private String listImagePath;			//리스트 이미지 경로
	private String backgroundImagePath;		//배경화면 이미지 경로
	
	private String userImagePath;			//session에 저장된 userImagePath
	
	private List<ResumeCareerDomain> careerList;
	private List<ResumeEducationDomain> educationList;
	private List<ResumeSkillDomain> skillList;
	private List<ResumeProgramDomain> programList;
	private List<ResumeLangDomain> langList;
	private List<ProgramingDomain> programingList;
	private List<LanguageDomain> languageList;
	private List<PortfolioDomain> portfolioList;

}
