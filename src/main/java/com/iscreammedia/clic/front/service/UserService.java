package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.AuthNumberDomain;
import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.SurveyDomain;
import com.iscreammedia.clic.front.domain.TermsAgreeDomain;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.repository.UserRepository;


@Service
public class UserService {
	
	@Autowired
	private UserRepository userRepository;
	
	
	/**
	 * 이메일중복체크
	 * @param    email
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int getEamilCk(String email) {
		return userRepository.getEamilCk(email);
	}
	
	/**
	 * 이메일 인증 전 상태 체크
	 * @param    email
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int getEamilNoStatusCk(String email) {
		return userRepository.getEamilNoStatusCk(email);
	}
	
	
	/**
	 * 회원가입 저장
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userInsert(UserDomain user) {		
		userRepository.userInsert(user);
		
	}
		
	
	/**
	 * 회원탈퇴 저장
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userSecessionInsert(UserDomain user) {		
		userRepository.userSecessionInsert(user);
		
	}
	
	/**
	 * 회원탈퇴시 회원삭제
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userDelete(UserDomain user) {		
		userRepository.userDelete(user);
		
	}
	
	
	public void userEmailDelete(String email) {		
		userRepository.userEmailDelete(email);
		
	}
	
	/**
	 * 이용약관 저장
	 * @param     termsAgree
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<TermsAgreeDomain> getTermsList(){
		return userRepository.getTermsList();
	}
	
	
	/**
	 * 국가 조회 
	 * @param     CommonDomain
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommonDomain> getCountryList(Locale locale){
		return userRepository.getCountryList(LanguageCode.getLanguage(locale));
	}
	
	
	/**
	 * 도시 조회 
	 * @param     CommonDomain
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommonDomain> getCityList(Locale locale, String countryCode){
		return userRepository.getCityList(LanguageCode.getLanguage(locale), countryCode);
	}
	
	
	
	/**
	 * 직업 조회 
	 * @param     CommonDomain
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommonDomain> getJobist(Locale locale){
		return userRepository.getJobist(LanguageCode.getLanguage(locale));
	}
	
	
	/**
	 * 코드 조회 
	 * @param     CommonDomain
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommonDomain> getCodeTypeList(Locale locale, String codeType){
		return userRepository.getCodeTypeList(LanguageCode.getLanguage(locale), codeType);
	}
	
	/**
	 * 이용약관 저장
	 * @param     termsAgree
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void termsAgreeInsert(TermsAgreeDomain termsAgree) {		
		userRepository.termsAgreeInsert(termsAgree);		
	}
	
	/**
	 * 회원정보 조회
	 * @param    email 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public UserDomain getUserDetail(String email){
		return userRepository.getUserDetail(email);
	}
	
	/**
	 * 회원가입 수정
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userUpdate(UserDomain user) {
		userRepository.userUpdate(user);
	}
	
	/**
	 * 회원상태값 수정	
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userTypeUpdate(UserDomain user) {
		userRepository.userTypeUpdate(user);
	}
	
	/**
	 * 로그인 시간 업데이트 
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void loginDateUpdate(String userId) {
		userRepository.loginDateUpdate(userId);
	}
	
		
	
	/**
	 * 비밀번호 수정
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userPwUpdate(UserDomain user) {
		userRepository.userPwUpdate(user);
	}
	
	
	/**
	 * 이메일 인증번호 조회 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public String getEamilNo(String email) {
		return userRepository.getEamilNo(email);
	}
	
	/**
	 * 이메일 인증번호 저장 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void emailNoInsert(AuthNumberDomain authNumberDomain) {
		userRepository.emailNoInsert(authNumberDomain);
	}
	
	/**
	 * 이메일 인증번호 수정 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void emailNoUpdate(AuthNumberDomain authNumberDomain) {
		userRepository.emailNoUpdate(authNumberDomain);
	}
	
	/**
	 * 설문조사 참여 이력 조회 
	 * @param    email 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public UserDomain getSurveyInfo(String userId){
		return userRepository.getSurveyInfo(userId);
	}
	
	
	/**
	 * 설문조사 문항 조회 
	 * @param     SurveyDomain
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<SurveyDomain> getSurveyQuestionList(Locale locale){
		return userRepository.getSurveyQuestionList(LanguageCode.getLanguage(locale));
	}
	
	/**
	 * 설문조사 보기 조회
	 * @param     SurveyDomain
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<SurveyDomain> getSurveyExampleList(Locale locale){
		return userRepository.getSurveyExampleList(LanguageCode.getLanguage(locale));
	}
	
	/**
	 * 설문답변 저장
	 * @param     survey
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void surveyAnswerInsert(SurveyDomain survey) {		
		userRepository.surveyAnswerInsert(survey);		
	}
	
	/**
	 * 설문 참여이력 저장
	 * @param     survey
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void surveyJoinHistoryInsert(SurveyDomain survey) {		
		userRepository.surveyJoinHistoryInsert(survey);		
	}
	
	
	/**
	 * 사용자 이미지 저장 
	 * @param     survey
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void userImageUpdate(Map<String, Object> param) {		
		userRepository.userImageUpdate(param);		
	}
	
	
	/**
	 * 사용자 메뉴접근 이력 저장  
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void accessHistoryInsert(Map<String, Object> param) {		
		userRepository.accessHistoryInsert(param);		
	}
	
	
	/**
	 * 회원 마지막 로그인 날짜 체크  
	 * @param     userId, date
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int lastLoginDateCk(String userId) {
		return userRepository.lastLoginDateCk(userId);
	}
	
	
	/**
	 * 로그인 세션 조회   
	 * @param     userId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public UserDomain getLoginHistory(String userId){
		return userRepository.getLoginHistory(userId);
	}
	
	
	/**
	 * 로그인 세션 저장 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void loginHistoryInsert(Map<String, Object> param) {		
		userRepository.loginHistoryInsert(param);		
	}
	
	/**
	 * 로그인 세션 삭제
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void loginHistoryDelete(String userId) {		
		userRepository.loginHistoryDelete(userId);		
	}
	
	/**
	 * 로그인 세션 업데이트 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void loginHistoryUpdate(String userId) {
		userRepository.loginHistoryUpdate(userId);
	}
}
