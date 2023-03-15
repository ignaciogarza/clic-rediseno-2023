package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.CommunityDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.MypageUserDomain;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.SkillEducationDomain;
import com.iscreammedia.clic.front.domain.SkillEducationMappingDomain;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.repository.MypageRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class MypageService {
	
	@Autowired
	private MypageRepository mypageRepository;
	
	/**
	 * 커뮤니티 조회
	 * @param     param
     * @return
	 * @ exception 
	 * 
	 * */
	public List<CommunityDomain> selectCommunityList(Map<String, Object> param) {
		return mypageRepository.selectCommunityList(param);
	}
	
	/**
	 * 뱃지 조회
	 * @param     locale, userId
     * @return
	 * @ exception 
	 * 
	 * */
	public List<Skill> selectSkillList(Locale locale, String userId) {
		return mypageRepository.selectSkillList(LanguageCode.getLanguage(locale), userId);
	}
	
	/**
	 * 자기 인증 완료 수
	 * @param     userId
     * @return
	 * @ exception 
	 * 
	 * */
	public int selfCount(String userId) {
		return mypageRepository.selfCount(userId);
	}
	
	/**
	 * 기술 시험 완료 수
	 * @param     userId
     * @return
	 * @ exception 
	 * 
	 * */
	public int examCount(String userId) {
		return mypageRepository.examCount(userId);
	}
	
	/**
	 * 친구 인증 완료 수
	 * @param     userId
     * @return
	 * @ exception 
	 * 
	 * */
	public int friendCount(String userId) {
		return mypageRepository.friendCount(userId);
	}
	
	/**
	 * 획득한 뱃지 수
	 * @param     userId
     * @return
	 * @ exception 
	 * 
	 * */
	public int badgeGetCount(String userId) {
		return mypageRepository.badgeGetCount(userId);
	}
	
	/**
	 * 교육 조회
	 * @param     locale, userId, rows
     * @return
	 * @ exception 
	 * 
	 * */
	public List<SkillEducationDomain> selectEduList(Locale locale, String userId, int rows) {
		//테스트 진행 내역
		int testCk = mypageRepository.testCk(userId);
		
		log.info("testCk!!!: {}", testCk);
		
		if(testCk == 0) {
			//테스트 진행 내역이 없는 경우 - 교육 조회
			List<SkillEducationDomain> noDatalist = mypageRepository.selectNoDataEduList(LanguageCode.getLanguage(locale), rows);
			
			for(SkillEducationDomain skillEdu : noDatalist) {
				List<SkillEducationMappingDomain> mappingList = mypageRepository.selectEduMappingList(LanguageCode.getLanguage(locale), skillEdu.getSkillEducationId());
				skillEdu.setSkillMapping(mappingList);
			}
			
			return noDatalist;
		} else {
			//테스트 진행 내역이 있는 경우 - 교육 조회
			List<SkillEducationDomain> datalist = mypageRepository.selectDataEduList(LanguageCode.getLanguage(locale), userId, rows);
			
			for(SkillEducationDomain skillEdu : datalist) {
				List<SkillEducationMappingDomain> mappingList = mypageRepository.selectEduMappingList(LanguageCode.getLanguage(locale), skillEdu.getSkillEducationId());
				skillEdu.setSkillMapping(mappingList);
			}
			
			return datalist;
		}
	}
	
	/**
	 * 유저 조회
	 * @param     locale, userId
     * @return
	 * @ exception 
	 * 
	 * */
	public MypageUserDomain selectUser(Locale locale, String userId) {
		return mypageRepository.selectUser(LanguageCode.getLanguage(locale), userId);
	}
	
	/**
	 * 유저 스킬 조회
	 * @param     locale, userId, skillCode, examClassCode
     * @return
	 * @ exception 
	 * 
	 * */
	public UserDomain selecSkilltUser(Locale locale, String userId, String skillCode, String examClassCode) {
		return mypageRepository.selectSkillUser(LanguageCode.getLanguage(locale), userId, skillCode, examClassCode);
	}
	
}
