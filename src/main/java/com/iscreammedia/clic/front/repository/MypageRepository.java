package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.CommunityDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.MypageUserDomain;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.SkillEducationDomain;
import com.iscreammedia.clic.front.domain.SkillEducationMappingDomain;
import com.iscreammedia.clic.front.domain.UserDomain;

@Repository
public interface MypageRepository {
	
	/**
	 * 커뮤니티 조회
	 * */
	List<CommunityDomain> selectCommunityList(Map<String, Object> param);
	
	/**
	 * 뱃지 조회
	 * */
	List<Skill> selectSkillList(@Param("language") LanguageCode language, @Param("userId") String userId);
	
	/**
	 * 자기 인증 완료 수
	 * */
	int selfCount(String userId);
	
	/**
	 * 기술 테스트 완료 수
	 * */
	int examCount(String userId);
	
	/**
	 * 친구 인증 완료 수
	 * */
	int friendCount(String userId);
	
	/**
	 * 획득한 뱃지 수
	 * */
	int badgeGetCount(String userId);
	
	/**
	 * 테스트 진행 내역 체크
	 * */
	int testCk(String userId);
	
	/**
	 * 테스트 진행 내역이 없는 경우 - 교육 조회
	 * */
	List<SkillEducationDomain> selectNoDataEduList(@Param("language") LanguageCode language, int rows);
	
	/**
	 * 테스트 진행 내역이 있는 경우 - 교육 조회
	 * */
	List<SkillEducationDomain> selectDataEduList(@Param("language") LanguageCode language, String userId, int rows);
	
	/**
	 * 스킬 교육 매핑 조회
	 * */
	List<SkillEducationMappingDomain> selectEduMappingList(@Param("language") LanguageCode language, int skillEducationId);
	
	/**
	 * 유저 조회
	 * */
	MypageUserDomain selectUser(@Param("language") LanguageCode language, String userId);
	
	/**
	 * 유저 스킬 조회
	 * */
	UserDomain selectSkillUser(@Param("language") LanguageCode language, String userId, String skillCode, String examClassCode);

}
