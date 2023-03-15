package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.SkillEducationDomain;
import com.iscreammedia.clic.front.domain.SkillEducationMappingDomain;
import com.iscreammedia.clic.front.repository.SkillEducationRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class SkillEducationService {
	
	@Autowired
	private SkillEducationRepository skillEducationRepository;
	
	/**
	 * 스킬 교육 조회(페이징+검색)
	 * @param     locale, startNum, endNum, skillCode, examClassCode
     * @return
	 * @ exception 
	 * 
	 * */
	public List<SkillEducationDomain> selectScrollList(Locale locale, int startNum, int endNum, String skillCode, String examClassCode) {
		List<SkillEducationDomain> list = skillEducationRepository.selectScrollList(LanguageCode.getLanguage(locale), startNum, endNum, skillCode, examClassCode);
		
		for(SkillEducationDomain skillEdu : list) {
			//스킬 교육 매핑 조회
			List<SkillEducationMappingDomain> mappingList = skillEducationRepository.selectSkillMappingList(LanguageCode.getLanguage(locale), skillEdu.getSkillEducationId());
			skillEdu.setSkillMapping(mappingList);
			
			log.info("mappingList!!!: {}", mappingList);
			
		}
		
		return list;
	}
	
	/**
	 * 스킬 이름 조회
	 * @param     locale
     * @return
	 * @ exception 
	 * 
	 * */
	public List<SkillEducationMappingDomain> selectSkillList(Locale locale) {
		return skillEducationRepository.selectSkillList(LanguageCode.getLanguage(locale));
	}
	
	/**
	 * 스킬 교육 등록 체크
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	public int educationCk() {
		return skillEducationRepository.educationCk();
	}
	
}
