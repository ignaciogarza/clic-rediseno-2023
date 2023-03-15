package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.ResumeCareerDomain;
import com.iscreammedia.clic.front.domain.ResumeDomain;
import com.iscreammedia.clic.front.domain.ResumeEducationDomain;
import com.iscreammedia.clic.front.domain.ResumeLangDomain;
import com.iscreammedia.clic.front.domain.ResumeProgramDomain;
import com.iscreammedia.clic.front.domain.ResumeSkillDomain;
import com.iscreammedia.clic.front.repository.ResumeRepository;

@Service
public class ResumeService {
	
	@Autowired
	private ResumeRepository resumeRepository;
	
	/**
	 * 이력서 등록 체크
	 * @param    userId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int resumeCk(String userId) {
		return resumeRepository.resumeCk(userId);
	}
	
	/**
	 * 이력서 등록
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertResume(ResumeDomain resumeDomain) {
		resumeRepository.insertResume(resumeDomain);
	}
	
	/**
	 * 이력서 조회
	 * @param    userId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeDomain resumeDetail(Locale locale,String userId) {
		return resumeRepository.resumeDetail(LanguageCode.getLanguage(locale), userId);
	}
	
	/**
	 * 이력서 프로필 이미지 수정 
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateResumeImg(ResumeDomain resumeDomain) {
		resumeRepository.updateResumeImg(resumeDomain);
	}
	
	/**
	 * 이력서 정보 여부 수정
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateInfoCk(ResumeDomain resumeDomain) {
		resumeRepository.updateInfoCk(resumeDomain);
	}
	
	/**
	 * 이력서 템플릿 수정
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateTemplateCk(ResumeDomain resumeDomain) {
		resumeRepository.updateTemplateCk(resumeDomain);
	}
	
	/**
	 * 이력서 정보 여부 수정(팝업)
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateInfoCkPopup(ResumeDomain resumeDomain) {
		resumeRepository.updateInfoCkPopup(resumeDomain);
	}
	
	/**
	 * 이력서 자기소개 수정 페이지
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeDomain selfDetail(int resumeId)  {
		return resumeRepository.selfDetail(resumeId);
	}
	
	/**
	 * 이력서 자기소개 수정
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateSelf(ResumeDomain resumeDomain) {
		resumeRepository.updateSelf(resumeDomain);
	}
	
	/**
	 * 이력서 자기소개 삭제
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteSelf(ResumeDomain resumeDomain) {
		resumeRepository.deleteSelf(resumeDomain);
	}
	
	/**
	 * 이력서 경력 사항 조회
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ResumeCareerDomain> selectCareerList(int resumeId) {
		return resumeRepository.selectCareerList(resumeId);
	}
	
	/**
	 * 이력서 경력 사항 포함 여부
	 * @param    resumeCareerDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateIsCareer(ResumeCareerDomain resumeCareerDomain) {
		resumeRepository.updateIsCareer(resumeCareerDomain);
	}
	
	/**
	 * 이력서 경력 사항 등록
	 * @param    resumeCareerDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertCareer(ResumeCareerDomain resumeCareerDomain) {
		resumeRepository.insertCareer(resumeCareerDomain);
	}
	
	/**
	 * 이력서 경력 사항 수정 페이지
	 * @param    resumeCraeerMattersId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeCareerDomain careerDetail(int resumeCraeerMattersId) {
		return resumeRepository.careerDetail(resumeCraeerMattersId);
	}
	
	/**
	 * 이력서 경력 사항 수정
	 * @param    resumeCareerDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateCareer(ResumeCareerDomain resumeCareerDomain) {
		resumeRepository.updateCareer(resumeCareerDomain);
	}
	
	/**
	 * 이력서 경력 사항 삭제
	 * @param    resumeCareerDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteCareer(ResumeCareerDomain resumeCareerDomain) {
		resumeRepository.deleteCareer(resumeCareerDomain);
	}
	
	/**
	 * 이력서 교육  조회
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ResumeEducationDomain> selectEducationList(int resumeId) {
		return resumeRepository.selectEducationList(resumeId);
	}
	
	/**
	 * 이력서 교육 포함 여부
	 * @param    resumeEducationDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateIsEducation(ResumeEducationDomain resumeEducationDomain) {
		resumeRepository.updateIsEducation(resumeEducationDomain);
	}
	
	/**
	 * 이력서 교육 등록
	 * @param    resumeEducationDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertEducation(ResumeEducationDomain resumeEducationDomain) {
		resumeRepository.insertEducation(resumeEducationDomain);
	}
	
	/**
	 * 이력서 교육 수정 페이지
	 * @param    resumeEducationId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeEducationDomain educationDetail(int resumeEducationId) {
		return resumeRepository.educationDetail(resumeEducationId);
	}
	/**
	 * 이력서 교육 수정
	 * @param    resumeEducationDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateEducation(ResumeEducationDomain resumeEducationDomain) {
		resumeRepository.updateEducation(resumeEducationDomain);
	}
	
	/**
	 * 이력서 교육 삭제
	 * @param    resumeEducationDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteEducation(ResumeEducationDomain resumeEducationDomain) {
		resumeRepository.deleteEducation(resumeEducationDomain);
	}
	
	/**
	 * 이력서 스킬  조회
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ResumeSkillDomain> selectSkillList(Locale locale, int resumeId) {
		return resumeRepository.selectSkillList(LanguageCode.getLanguage(locale), resumeId);
	}
	
	/**
	 * 이력서 스킬 제한 체크
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int skillCk(int resumeId) {
		return resumeRepository.skillCk(resumeId);
	}
	
	/**
	 * 이력서 스킬 등록
	 * @param    resumeSkillDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertSkill(ResumeSkillDomain resumeSkillDomain) {
		resumeRepository.insertSkill(resumeSkillDomain);
	}
	
	/**
	 * 이력서 스킬 수정 페이지
	 * @param    resumeHaveSkillId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeSkillDomain skillDetail(int resumeHaveSkillId) {
		return resumeRepository.skillDetail(resumeHaveSkillId);
	}
	/**
	 * 이력서 스킬 수정
	 * @param    resumeSkillDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateSkill(ResumeSkillDomain resumeSkillDomain) {
		resumeRepository.updateSkill(resumeSkillDomain);
	}
	
	/**
	 * 이력서 스킬 삭제
	 * @param    resumeSkillDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteSkill(ResumeSkillDomain resumeSkillDomain) {
		resumeRepository.deleteSkill(resumeSkillDomain);
	}
	
	/**
	 * 이력서 프로그램  조회
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ResumeProgramDomain> selectProgramList(Locale locale, int resumeId) {
		return resumeRepository.selectProgramList(LanguageCode.getLanguage(locale), resumeId);
	}
	
	/**
	 * 이력서 프로그램 중복체크
	 * @param    resumeProgramDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int programCk(ResumeProgramDomain resumeProgramDomain) {
		return resumeRepository.programCk(resumeProgramDomain);
	}
	
	/**
	 * 이력서 프로그램 등록
	 * @param    resumeProgramDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertProgram(ResumeProgramDomain resumeProgramDomain) {
		resumeRepository.insertProgram(resumeProgramDomain);
	}
	
	/**
	 * 이력서 프로그램 수정 페이지
	 * @param    resumeProgramId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeProgramDomain programDetail(Locale locale, int resumeProgramId) {
		return resumeRepository.programDetail(LanguageCode.getLanguage(locale), resumeProgramId);
	}
	/**
	 * 이력서 프로그램 수정
	 * @param    resumeProgramDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateProgram(ResumeProgramDomain resumeProgramDomain) {
		resumeRepository.updateProgram(resumeProgramDomain);
	}
	
	/**
	 * 이력서 프로그램 삭제
	 * @param    resumeProgramDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteProgram(ResumeProgramDomain resumeProgramDomain) {
		resumeRepository.deleteProgram(resumeProgramDomain);
	}
	
	/**
	 * 이력서 언어  조회
	 * @param    resumeId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ResumeLangDomain> selectLangList(Locale locale, int resumeId) {
		return resumeRepository.selectLangList(LanguageCode.getLanguage(locale), resumeId);
	}
	
	/**
	 * 이력서 언어 중복체크
	 * @param    resumeLangDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int langCk(ResumeLangDomain resumeLangDomain) {
		return resumeRepository.langCk(resumeLangDomain);
	}
	
	/**
	 * 이력서 언어 등록
	 * @param    resumeLangDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertLang(ResumeLangDomain resumeLangDomain) {
		resumeRepository.insertLang(resumeLangDomain);
	}
	
	/**
	 * 이력서 언어 수정 페이지
	 * @param    resumeLangId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ResumeLangDomain langDetail(Locale locale, int resumeLangId) {
		return resumeRepository.langDetail(LanguageCode.getLanguage(locale), resumeLangId);
	}
	
	/**
	 * 이력서 언어 수정
	 * @param    resumeLangDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateLang(ResumeLangDomain resumeLangDomain) {
		resumeRepository.updateLang(resumeLangDomain);
	}
	
	/**
	 * 이력서 언어 삭제
	 * @param    resumeLangDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteLang(ResumeLangDomain resumeLangDomain) {
		resumeRepository.deleteLang(resumeLangDomain);
	}
	
	/**
	 * 이력서 포트폴리오  조회
	 * @param    userId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<PortfolioDomain> selectPortfolioList(String userId) {
		return resumeRepository.selectPortfolioList(userId);
	}
	
	/**
	 * 이력서 포트폴리오 수정
	 * @param    resumeDomain 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updatePortfolio(ResumeDomain resumeDomain) {
		resumeRepository.updatePortfolio(resumeDomain);
	}
	
	/**
	 * 이력서 포트폴리오 중복체크
	 * @param    userId ,qrPortfolioId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public int portfolioCk(String userId, String portfolioId) {
		return resumeRepository.portfolioCk(userId ,portfolioId);
	}
	
	/**
	 * 이력서 포트폴리오 삭제
	 * @param    userId 
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deletePortfolio(String userId) {
		resumeRepository.deletePortfolio(userId);
	}
	
}
