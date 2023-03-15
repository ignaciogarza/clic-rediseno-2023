package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.PortfolioDomain;

@Repository
public interface PortfolioRepository {
	
	/**
	 * 포토폴리오 조회
	 * */
	List<PortfolioDomain> getPortfolioList(Map<String, Object> param);
	
	
	/**
	 * 포토폴리오 상세 조회
	 * */
	PortfolioDomain getPortfolioDetailInfo(Map<String, String> param);
	
	
	/**
	 * 포토폴리오 삭제 조회
	 * */
	void delPortfolio(Map<String, String> param);
	
	/**
	 * 포토폴리오 프로젝트 카운트 조회
	 * */
	String getProjectCount(Map<String, String> param);
	
	
	/**
	 * 포토폴리오 프로젝트 카운트 증가 수정
	 * */
	void updateProjectCount(Map<String, String> param);
	
	
	/**
	 * 포토폴리오 저장
	 * */
	void insertPortfolio(Map<String, String> param);
	
	
	/**
	 * 포토폴리오 열람 히스토리 저장
	 * */
	void insertPortfolioVisitHistory(Map<String, String> param);
	
	
	/**
	 * 포토폴리오 수정
	 * */
	void updatePortfolio(Map<String, String> param);
	
	
	/**
	 * 코드데이터 조회
	 * */
	List<CommonDomain> getCodeList(String major);
	
	String getConcatWords();

}
