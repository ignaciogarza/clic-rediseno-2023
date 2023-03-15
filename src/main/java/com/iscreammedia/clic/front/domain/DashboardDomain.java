package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Data;

@Data
public class DashboardDomain {
	
	private String userId;
	private String email;
	private String menuType;
	
	private int stcId;
	private String createDate; 
	private String sumType;
	private String countryCode;
	private String cityId;
	private int regUserCnt;
	private int regPcUserCnt;
	private int regMUserCnt;
	private int delUserCnt;
	private int delPcUserCnt;
	private int delMUserCnt;
	private String stcType;
	private String major;
	private String minor;
	
	private String questionId;
	private String exampleId;
	private String skillStcCode;
	private String skillCode;
	private String searchDate;
	
	private String language;
	
	private int userCnt;			//회원수
	private int skillStcTotalCnt;	//테스트 응시
	private int skillStcPassCnt;	//테스트 패스
	
	private int resumeCnt; 			//이력서
	private int portfolioCnt; 		//포토폴리오 
	
	protected List<DashboardDomain>  cityDateList;			//도시별 
	
	protected List<DashboardDomain>  sexDateList;			//성별
	private int men;		//남자
	private int women;		//여자 
	private int etc;		//기타
	
	private String label;
	private String value;
	
	protected List<DashboardDomain>  ageDateList;			//연령	
	private int tenAge;
	private int twentyAge;
	private int thirtyAge;
	private int fortyAge;
	private int fiftyAge;
	private int sixtyAge;
	
	protected List<DashboardDomain>  educationDateList;		//교육
	
	protected List<DashboardDomain>  taskDateList;			//업무
	
	protected List<DashboardDomain>  jobDateList;			//직업
	
    private String joinSurveyId;
    private String surveyId;
   
   
    private String questionTitleEng;
    private String questionTitleSpa;

    private String isUse;
    private String exampleTypeCode;
    private String questionImagePathEng;
    private String questionImagePathSpa;
    private int totalAnwerCnt;   
    private int questionNumber;
    private int exampleNumber;
   
    private int[] exampleNum;
   
    private String[] delExamples;
    private String[] questionSortKey;
    private String[] exampleTitleEngs;
    private String[] exampleTitleSpas;


   private List<DashboardDomain> exampleList;   
   

   private String exampleImagePathEng;
   private String exampleImagePathSpa;
   private int answerRate;
   
   
   private int answerCnt;
   
  
   
   private String exampleTitleEng;
   private String exampleTitleSpa;

   
	
   protected List<DashboardDomain>  resultList;	
   
   
   private String examClassCode;
   private String skillCodeNm;
   
   private String totalUserCnt;
   private String selfUserCnt;
   private String skillUserCnt;
   private String passUserCnt;
   
   
   private int totalCnt;
   private int selfCnt;
   private int skillCnt;
   private int passCnt;
   
   
   private String stcRank;
   private String title;
   
   protected List<DashboardDomain> skillReportList;
   
   protected List<DashboardDomain> skillRankingList;
   
   protected List<DashboardDomain> programRankingList;
   
   protected List<DashboardDomain> langRankingList;
   
   protected List<DashboardDomain> portfolioRankingList;

}
