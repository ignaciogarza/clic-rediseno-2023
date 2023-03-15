package com.iscreammedia.clic.front.domain;

import lombok.Data;

@Data
public class SurveyDomain {
	
	private String userId; 	
	
	private int exampleId; 						//보기아이디			
	private int joinSurveyId; 					//참여설문아이디
	private int exampleAnswer;				//보기답변
	private String shortAnswer; 				//주관식
	
	private int exampleNumber; 					//보기번호
	private int questionId;						//문항아이디
	
	private String exampleTitleEng; 			//보기제목 영어
	private String exampleTitleSpa; 			//보기제목 스폐인어
	private String exampleTitle; 
	
	private String exampleImagePathEng; 		//보기이미지경로 영어
	private String exampleImagePathSpa;			//보기이미지경로 스폐인어	 		
	private String exampleImagePath;			//보기이미지경로 스폐인어	 	
			
	private int surveyId; 						//문항아이디
	private String questionTitleEng;			//문항제목 영어
	private String questionTitleSpa;			//문항제목 스폐인어
	private String questionTitle;			//문항제목 
	
	private String questionNumber; 				//문항번호
	private String isUse;						//사용유무	
	private String exampleTypeCode;				//보기종류코드
	private String questionImagePathEng;		//문항이미지경로 영어
	private String questionImagePathSpa;		//문항이미지경로 스폐인어
	private String questionImagePath;		//문항이미지경로 
	
	private String surveyNameEng; 				//설문이름 영어
	private String surveyNameSpa; 				//설문이름 스폐인어
	private String surveyName; 				//설문이름 
	
	private String surveyContentsEng; 			//설문설명 영어
	private String surveyContentsSpa;			//설문설명 스폐인어	
	private String surveyContents;			//설문설명 스폐인어	
	
	private String isComplete; 					//여부완료			
	
	private String createdDate; 				//등록일자		
	private String creator; 					//등록자	
	private String updatedDate; 				//수정일자
	private String updater; 					//수정자
	
	

}
