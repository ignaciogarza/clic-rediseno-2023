package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.UserDomain;

@Repository
public interface MainRepository {
	
	
	/**
	 * 회원 카운트 조회
	 * */
	public int getUserSearchCount(Map<String, Object> param);

	/**
	 * 회원 조회
	 * */
	List<UserDomain> getUserSearchList(Map<String, Object> param);
	
	
	/**
	 * 포토폴리오 카운트 조회
	 * */
	public int getPortfolioSearchCount(Map<String, Object> param);

	/**
	 * 포토폴리오 조회
	 * */
	List<PortfolioDomain> getPortfolioSearchList(Map<String, Object> param);
	
	/**
	 * 회원 설문조사 참여조회
	 * */
	UserDomain getUserSurveyInfo(String userId);
}
