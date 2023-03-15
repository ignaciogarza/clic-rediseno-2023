package com.iscreammedia.clic.front.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.SkillEducationDomain;
import com.iscreammedia.clic.front.domain.SkillEducationMappingDomain;


@Repository
public interface SkillEducationRepository {
	
	/**
	 * 스킬 교육 조회(페이징+검색)
	 * */
	List<SkillEducationDomain> selectScrollList(@Param("language") LanguageCode language, @Param("startNum") int startNum, @Param("endNum") int endNum, @Param("skillCode") String skillCode,  @Param("examClassCode") String examClassCode);
	
	/**
	 * 스킬 교육 매핑 조회
	 * */
	List<SkillEducationMappingDomain> selectSkillMappingList(@Param("language") LanguageCode language, int skillEducationId);
	
	/**
	 * 스킬 이름 조회
	 * */
	List<SkillEducationMappingDomain> selectSkillList(@Param("language") LanguageCode language);
	
	/**
	 * 스킬 교육 등록 체크
	 * */
	int educationCk();
}
