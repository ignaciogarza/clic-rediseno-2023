package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.DashboardDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.repository.DashboardRepository;

@Service
public class DashboardService {
	
	@Autowired
	private DashboardRepository dashboardRepository;
	
	/**
	 * 코드별 사용자 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getStcCodeMemberList(Map<String, Object> param){
		return dashboardRepository.getStcCodeMemberList(param);
	}
	
	
	/**
	 * 스킬 코드별 사용자 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getStcCodeSkillList(Map<String, Object> param){
		return dashboardRepository.getStcCodeSkillList(param);
	}
	
	/**
	 * 도시 사용자 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getCityUserList(Map<String, Object> param){
		return dashboardRepository.getCityUserList(param);
	}
	
	/**
	 * 도시 테스트 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getCitySkillList(Map<String, Object> param){
		return dashboardRepository.getCitySkillList(param);
	}
	
	
	/**
	 * 설문문항 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getIctResultList(Map<String, Object> param) {
	    return dashboardRepository.getIctResultList(param);
	}
	
	
	/**
	 * 설문조사 성별/연령/학력/경력/직업 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getSurveyCodeList(Map<String, Object> param){
		return dashboardRepository.getSurveyCodeList(param);
	}
	
	
	/**
	 * 설문조사 도시 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getSurveyCityIdList(Map<String, Object> param){
		return dashboardRepository.getSurveyCityIdList(param);
	}
	
	
	/**
	 * 사용자  카운트 조회
	 * @param param
	 * @return
	 */
	public int getUserCount(Map<String, Object> param) {
		return dashboardRepository.getUserCount(param);
	}
	
	/**
	 * 테스트  카운트 조회
	 * @param param
	 * @return
	 */
	public int getSkillTestCount(Map<String, Object> param)  {
		return dashboardRepository.getSkillTestCount(param);
	}
	
	/**
	 * 이력서/포토폴리오  카운트 조회
	 * @param param
	 * @return
	 */
	public int getDocumentTypeCount(Map<String, Object> param) {
		return dashboardRepository.getDocumentTypeCount(param);
	}
	
	
	/**
	 * 스킬 전체/자기평가/기술테스트/테스트통과  카운트 조회
	 * @param param
	 * @return
	 */
	public int getStcSkillCodeUserCount(Map<String, Object> param)  {
		return dashboardRepository.getStcSkillCodeUserCount(param);
	}
	
	
	/**
	 * 스킬 코드별 사용자 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getSkillReportList(Map<String, Object> param){
		return dashboardRepository.getSkillReportList(param);
	}
	
	/**
	 * 스킬 코드별 사용자 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getStcSkillCodeUserList(Map<String, Object> param){
		return dashboardRepository.getStcSkillCodeUserList(param);
	}
	
	/**
	 * 랭킹 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<DashboardDomain> getRankingList(Locale locale, String stcType){
		return dashboardRepository.getRankingList(LanguageCode.getLanguage(locale), stcType);
	}
	
	public List<DashboardDomain> getRankingList02(Locale locale, String stcType){
		return dashboardRepository.getRankingList02(LanguageCode.getLanguage(locale), stcType);
	}

}
