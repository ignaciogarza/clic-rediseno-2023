package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.DashboardDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;

@Repository
public interface DashboardRepository {
	
	
	/**
	 * 
	 * 코드별 사용자 조회
	 * @return
	 */
	List<DashboardDomain> getStcCodeMemberList(Map<String, Object> param);
	
	/**
	 * 
	 * 스킬 코드별 사용자 조회
	 * @return
	 */
	List<DashboardDomain> getStcCodeSkillList(Map<String, Object> param);
	
	/**
	 * 
	 * 도시 사용자 조회
	 * @return
	 */
	List<DashboardDomain> getCityUserList(Map<String, Object> param);
	
	/**
	 * 
	 * 도시 테스트 조회
	 * @return
	 */
	List<DashboardDomain> getCitySkillList(Map<String, Object> param);
	
	
	/**
	 * 
	 * 설문문항 조회 
	 * @return
	 */
	List<DashboardDomain> getIctResultList(Map<String, Object> param);
	
	
	/**
	 * 
	 * 설문조사 성별/연령/학력/경력/직업 조회
	 * @return
	 */
	List<DashboardDomain> getSurveyCodeList(Map<String, Object> param);
	
	
	/**
	 * 
	 * 설문조사 도시 조회
	 * @return
	 */
	List<DashboardDomain> getSurveyCityIdList(Map<String, Object> param);
	
	/**
	 * 사용자  카운트 조회
	 * */
	public int getUserCount(Map<String, Object> param);
	
	/**
	 * 테스트  카운트 조회
	 * */
	public int getSkillTestCount(Map<String, Object> param);
	
	/**
	 * 이력서/포토폴리오  카운트 조회
	 * */
	public int getDocumentTypeCount(Map<String, Object> param);
	
	
	/**
	 * 
	 * 스킬 조회 
	 * @return
	 */
	List<DashboardDomain> getSkillReportList(Map<String, Object> param);
	
	
	/**
	 * 
	 * 스킬 코드별 조회 
	 * @return
	 */
	List<DashboardDomain> getStcSkillCodeUserList(Map<String, Object> param);
	
	
	/**
	 * 스킬 전체/자기평가/기술테스트/테스트통과  카운트 조회
	 * */
	public int getStcSkillCodeUserCount(Map<String, Object> param);
	
	
	/**
	 * 
	 * 랭킹조회 조회
	 * @return
	 */
	List<DashboardDomain> getRankingList(@Param("language") LanguageCode language, String stcType);
	
	List<DashboardDomain> getRankingList02(@Param("language") LanguageCode language, String stcType);
}
