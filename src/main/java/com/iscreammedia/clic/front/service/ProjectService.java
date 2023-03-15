package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.BadgeDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.ProjectDomain;
import com.iscreammedia.clic.front.repository.ProjectRepository;

@Service
public class ProjectService {
	
	@Autowired
	private ProjectRepository projectRepository;
	
	
	/**
	 * 프로젝트 id 조회 
	 * @param     termsAgree
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ProjectDomain> getProjectIdList(String portfolioId){
		return projectRepository.getProjectIdList(portfolioId);
	}
	
	/**
	 * 프로젝트 조회 
	 * @param     portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ProjectDomain> getProjectList(String portfolioId, String local){		
		return projectRepository.getProjectList(portfolioId, local);
	}
	
	/**
	 * 프로젝트 상세 조회 
	 * @param     projectId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ProjectDomain getProjectDetailInfo(String projectId){		
		return projectRepository.getProjectDetailInfo(projectId);
	}
	
	
	/**
	 * 프로젝트 저장
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertProject(Map<String, String> param) {		
		projectRepository.insertProject(param);
		
	}
	
	/**
	 * 프로젝트 수정
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateProject(Map<String, String> param){
		projectRepository.updateProject(param);		
	}
	
	
	/**
	 * 프로젝트 컨텐츠 조회 
	 * @param     portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ProjectDomain> getProjectContentsList(Map<String, String> param){		
		return projectRepository.getProjectContentsList(param);
	}
	
	
	
	/**
	 * 프로젝트 컨텐츠 상세 조회 
	 * @param     portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public ProjectDomain getProjectContentsInfo(Map<String, String> param){		
		return projectRepository.getProjectContentsInfo(param);
	}
	
	
	
	/**
	 * 프로젝트 컨텐츠 저장
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertProjectContents(Map<String, String> param) {		
		projectRepository.insertProjectContents(param);
		
	}
	
	/**
	 * 프로젝트 수정
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updateProjectContents(Map<String, String> param) {		
		projectRepository.updateProjectContents(param);
		
	}
	
	
	/**
	 * 프로젝트 저장
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void delProject(Map<String, String> param) {		
		projectRepository.delProject(param);
		
	}
		
	
	
	/**
	 * 프로젝트 컨텐츠 삭제
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void delProjectContents(Map<String, String> param) {		
		projectRepository.delProjectContents(param);		
	}
	
	/**
	 * 뱃지 조회 
	 * @param     portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<BadgeDomain> getBadgeList(Locale locale,String userId){		
		return projectRepository.getBadgeList(LanguageCode.getLanguage(locale),userId);
	}
	
	/**
	 * 프로젝트 컨텐츠 뱃지 삭제 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void badgeDelete(Map<String, String> param) {		
		projectRepository.badgeDelete(param);
		
	}
	
	
	/**
	 * 프로젝트 컨텐츠 이미지 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ProjectDomain> getContentsImageList(Map<String, String> param){		
		return projectRepository.getContentsImageList(param);
	}
	
	
	/**
	 * 프로젝트 좋아요 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public String getLikeStatus(Map<String, String> param) {
		return projectRepository.getLikeStatus(param);
	}
	
	/**
	 * 프로젝트 좋아요 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void projectLikeSave(Map<String, String> param) {		
		projectRepository.projectLikeSave(param);
		
	}
	
	
	/**
	 * 포토폴리오 좋아요
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void portfolioLikeSave(Map<String, String> param) {		
		projectRepository.portfolioLikeSave(param);
		
	}
	
	
	
	/**
	 * 프로젝트 좋아요 히스토리 등록 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void projectLikeHistory(Map<String, String> param) {		
		projectRepository.projectLikeHistory(param);		
	}	

}
