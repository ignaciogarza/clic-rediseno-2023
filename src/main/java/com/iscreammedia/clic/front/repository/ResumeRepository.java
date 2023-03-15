package com.iscreammedia.clic.front.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.ResumeCareerDomain;
import com.iscreammedia.clic.front.domain.ResumeDomain;
import com.iscreammedia.clic.front.domain.ResumeEducationDomain;
import com.iscreammedia.clic.front.domain.ResumeLangDomain;
import com.iscreammedia.clic.front.domain.ResumeProgramDomain;
import com.iscreammedia.clic.front.domain.ResumeSkillDomain;


@Repository
public interface ResumeRepository {
	
	/**
	 * 이력서 등록 체크
	 * */
	int resumeCk(String userId);
	
	/**
	 * 이력서 등록
	 * */
	void insertResume(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 조회
	 * */
	ResumeDomain resumeDetail(@Param("language") LanguageCode language, String userId);
	
	/**
	 * 이력서 프로필 이미지 수정 
	 * */
	void updateResumeImg(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 정보 여부 수정
	 * */
	void updateInfoCk(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 템플릿 수정 
	 * */
	void updateTemplateCk(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 정보 여부 수정 (팝업)
	 * */
	void updateInfoCkPopup(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 자기소개 수정 페이지
	 * */
	ResumeDomain selfDetail(int resumeId);
	
	/**
	 * 이력서 자기소개 수정
	 * */
	void updateSelf(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 자기소개 삭제
	 * */
	void deleteSelf(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 경력 사항 조회
	 * */
	List<ResumeCareerDomain> selectCareerList(int resumeId);
	
	/**
	 * 이력서 경력 사항 포함 여부
	 * */
	void updateIsCareer(ResumeCareerDomain resumeCareerDomain);
	
	/**
	 * 이력서 경력 사항 등록
	 * */
	void insertCareer(ResumeCareerDomain resumeCareerDomain);
	
	/**
	 * 이력서 경력 사항 수정 페이지
	 * */
	ResumeCareerDomain careerDetail(int resumeCraeerMattersId);
	
	/**
	 * 이력서 경력 사항 수정 
	 * */
	void updateCareer(ResumeCareerDomain resumeCareerDomain);
	
	/**
	 * 이력서 경력 사항 삭제
	 * */
	void deleteCareer(ResumeCareerDomain resumeCareerDomain);
	
	/**
	 * 이력서 교육 조회
	 * */
	List<ResumeEducationDomain> selectEducationList(int resumeId);
	
	/**
	 * 이력서 교육 포함 여부
	 * */
	void updateIsEducation(ResumeEducationDomain resumeEducationDomain);
	
	/**
	 * 이력서 교육 등록
	 * */
	void insertEducation(ResumeEducationDomain resumeEducationDomain);
	
	/**
	 * 이력서 교육 수정 페이지
	 * */
	ResumeEducationDomain educationDetail(int resumeEducationId);
	
	/**
	 * 이력서 교육 수정 
	 * */
	void updateEducation(ResumeEducationDomain resumeEducationDomain);
	
	/**
	 * 이력서 교육 삭제
	 * */
	void deleteEducation(ResumeEducationDomain resumeEducationDomain);
	
	/**
	 * 이력서 스킬 조회
	 * */
	List<ResumeSkillDomain> selectSkillList(@Param("language") LanguageCode language, int resumeId);
	
	/**
	 * 이력서 스킬 제한 체크
	 * */
	int skillCk(int resumeId);
	
	/**
	 * 이력서 스킬 등록
	 * */
	void insertSkill(ResumeSkillDomain resumeSkillDomain);
	
	/**
	 * 이력서 스킬 수정 페이지
	 * */
	ResumeSkillDomain skillDetail(int resumeHaveSkillId);
	
	/**
	 * 이력서 스킬 수정 
	 * */
	void updateSkill(ResumeSkillDomain resumeSkillDomain);
	
	/**
	 * 이력서 스킬 삭제
	 * */
	void deleteSkill(ResumeSkillDomain resumeSkillDomain);
	
	/**
	 * 이력서 프로그램 조회
	 * */
	List<ResumeProgramDomain> selectProgramList(@Param("language") LanguageCode language, int resumeId);
	
	/**
	 * 이력서 프로그램 중복체크
	 * */
	int programCk(ResumeProgramDomain resumeProgramDomain);
	
	/**
	 * 이력서 프로그램 등록
	 * */
	void insertProgram(ResumeProgramDomain resumeProgramDomain);
	
	/**
	 * 이력서 프로그램 수정 페이지
	 * */
	ResumeProgramDomain programDetail(@Param("language") LanguageCode language, int resumeProgramId);
	
	/**
	 * 이력서 프로그램 수정 
	 * */
	void updateProgram(ResumeProgramDomain resumeProgramDomain);
	
	/**
	 * 이력서 프로그램 삭제
	 * */
	void deleteProgram(ResumeProgramDomain resumeProgramDomain);
	
	/**
	 * 이력서 언어 조회
	 * */
	List<ResumeLangDomain> selectLangList(@Param("language") LanguageCode language, int resumeId);
	
	/**
	 * 이력서 언어 중복체크
	 * */
	int langCk(ResumeLangDomain resumeLangDomain);
	
	/**
	 * 이력서 언어 등록
	 * */
	void insertLang(ResumeLangDomain resumeLangDomain);
	
	/**
	 * 이력서 언어 수정 페이지
	 * */
	ResumeLangDomain langDetail(@Param("language") LanguageCode language, int resumeLangId);
	
	/**
	 * 이력서 언어 수정 
	 * */
	void updateLang(ResumeLangDomain resumeLangDomain);
	
	/**
	 * 이력서 언어 삭제
	 * */
	void deleteLang(ResumeLangDomain resumeLangDomain);
	
	/**
	 * 이력서 포트폴리오 조회
	 * */
	List<PortfolioDomain> selectPortfolioList(String userId);
	
	/**
	 * 이력서 포트폴리오 수정
	 * */
	void updatePortfolio(ResumeDomain resumeDomain);
	
	/**
	 * 이력서 포트폴리오 중복체크
	 * */
	int portfolioCk(String userId, String portfolioId);
	
	/**
	 * 이력서 포트폴리오 삭제
	 * */
	void deletePortfolio(String userId);
}
