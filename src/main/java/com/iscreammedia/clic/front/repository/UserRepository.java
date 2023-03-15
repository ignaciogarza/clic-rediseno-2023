package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.AuthNumberDomain;
import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.SurveyDomain;
import com.iscreammedia.clic.front.domain.TermsAgreeDomain;
import com.iscreammedia.clic.front.domain.UserDomain;

@Repository
public interface UserRepository {

	/**
	 * 회원가입 저장
	 * */
	void userInsert(UserDomain user);
	
	/**
	 * 회원탈퇴 저장
	 * */
	void userSecessionInsert(UserDomain user);
	
	
	/**
	 * 회원탈퇴시 회원삭제
	 * */
	void userDelete(UserDomain user);
	
	void userEmailDelete(String email);
	
	
	/**
	 * 이용약관 저장
	 * */
	void termsAgreeInsert(TermsAgreeDomain termsAgree);
	
	
	/**
	 * 이용약관 조회
	 * */
	List<TermsAgreeDomain> getTermsList();
	
	
	/**
	 * 회원정보 조회
	 * */
	UserDomain getUserDetail(String email);
	
	
	
	UserDomain getSurveyInfo(String userId);
	
	
	
	/**
	 * 회원가입 수정	
	 * */
	void userUpdate(UserDomain user);
	
	/**
	 * 회원상태값 수정	
	 * */
	void userTypeUpdate(UserDomain user);
	
	
	/**
	 * 로그인 시간 업데이트 	
	 * */
	void loginDateUpdate(String userId);
	
	
	/**
	 * 비밀번호 수정	
	 * */
	void userPwUpdate(UserDomain user);
	
	/**
	 * 이메일 중복체크
	 * */
	int getEamilCk(String email);
	
	
	/**
	 * 이메일 인증 전 상태 체크
	 * */
	int getEamilNoStatusCk(String email);
	
	/**
	 * 이메일 인증번호 조회 
	 * */
	String getEamilNo(String email);
		
	
	/**
	 * 이메일 인증번호 저장
	 * */
	void emailNoInsert(AuthNumberDomain authNumberDomain);
	
	/**
	 * 이메일 인증번호 수정
	 * */
	void emailNoUpdate(AuthNumberDomain authNumberDomain);
	
	/**
	 * 국가 조회
	 * */
	List<CommonDomain> getCountryList(@Param("language") LanguageCode language);
		
	
	/**
	 * 도시 조회
	 * */
	List<CommonDomain> getCityList(@Param("language") LanguageCode language, String countryCode);
	
	
	/**
	 * 직업 조회
	 * */
	List<CommonDomain> getJobist(@Param("language") LanguageCode language);
	
	/**
	 * 설문조사 문항 조회
	 * */
	List<SurveyDomain> getSurveyQuestionList(@Param("language") LanguageCode language);
	
	
	/**
	 * 설문조사 보기 조회
	 * */
	List<SurveyDomain> getSurveyExampleList(@Param("language") LanguageCode language);
	
	
	/**
	 * 코드 조회
	 * */
	List<CommonDomain> getCodeTypeList(@Param("language") LanguageCode language, String codeType);
		
	
	/**
	 * 설문답변 저장
	 * */
	void surveyAnswerInsert(SurveyDomain survey);
	
	
	/**
	 * 설문 참여이력 저장
	 * */
	void surveyJoinHistoryInsert(SurveyDomain survey);
	
	/**
	 * 사용자 이미지 저장 
	 * */
	void userImageUpdate(Map<String, Object> param);
	
	/**
	 * 사용자 메뉴접근 이력 저장  
	 * */
	void accessHistoryInsert(Map<String, Object> param);
	
	/**
	 * 회원 마지막 로그인 날짜 체크
	 * */
	int lastLoginDateCk(String userId);
	
	
	/**
	 * 로그인 세션 조회
	 * */
	UserDomain getLoginHistory(String userId);
	
	
	/**
	 * 로그인 세션 저장
	 * */
	void loginHistoryInsert(Map<String, Object> param);
	
	
	/**
	 * 로그인 세션 삭제 
	 * */
	void loginHistoryDelete(String userId);
	
	
	/**
	 * 로그인 세션 업데이트
	 * */
	void loginHistoryUpdate(String userId);
}
