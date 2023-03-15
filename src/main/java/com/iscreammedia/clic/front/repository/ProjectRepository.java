package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.BadgeDomain;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.ProjectDomain;

@Repository
public interface ProjectRepository {
	
	/**
	 * 프로젝트 id 조회 
	 * */
	List<ProjectDomain> getProjectIdList(String portfolioId);
	
	
	/**
	 * 프로젝트 조회 
	 * */
	List<ProjectDomain> getProjectList(@Param("portfolioId") String portfolioId, @Param("local") String local);
	
	
	/**
	 * 프로젝트 상세 조회 
	 * */
	ProjectDomain getProjectDetailInfo(String projectId);
	
	
	/**
	 * 프로젝트 저장
	 * */
	void insertProject(Map<String, String> param);
	
	/**
	 * 프로젝트 수정
	 * */
	void updateProject(Map<String, String> param);
	
	
	/**
	 * 프로젝트 컨텐츠 조회 
	 * */
	List<ProjectDomain> getProjectContentsList(Map<String, String> param);
	
	
	/**
	 * 프로젝트 컨텐츠 상세 조회 
	 * */
	ProjectDomain getProjectContentsInfo(Map<String, String> param);
	
	
	/**
	 * 프로젝트 컨텐츠 저장
	 * */
	void insertProjectContents(Map<String, String> param);
	
	
	/**
	 * 프로젝트 컨텐츠 수정
	 * */
	void updateProjectContents(Map<String, String> param);
	
	
	
	/**
	 * 프로젝트 삭제 
	 * */
	void delProject(Map<String, String> param);
	
	/**
	 * 프로젝트 컨텐츠 삭제 
	 * */
	void delProjectContents(Map<String, String> param);
	
	/**
	 * 뱃지 조회 
	 * */
	List<BadgeDomain> getBadgeList(@Param("language") LanguageCode language,String userId);
	
	/**
	 * 프로젝트 컨텐츠 뱃지 삭제 
	 * */
	void badgeDelete(Map<String, String> param);
	
	
	/**
	 * 프로젝트 컨텐츠 이미지 조회 
	 * */
	List<ProjectDomain> getContentsImageList(Map<String, String> param);
	
	
	
	/**
	 * 프로젝트 좋아요
	 * */
	void projectLikeSave(Map<String, String> param);
	
	
	/**
	 * 포토폴리오 좋아요
	 * */
	void portfolioLikeSave(Map<String, String> param);
	
	
	
	
	/**
	 * 프로젝트 좋아요 히스토리 등록 
	 * */
	void projectLikeHistory(Map<String, String> param);
	
	
	/**
	 * 프로젝트 좋아요 조회 
	 * */
	String getLikeStatus(Map<String, String> param);
	
	
}
