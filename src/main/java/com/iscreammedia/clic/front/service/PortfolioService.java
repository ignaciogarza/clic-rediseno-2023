package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.repository.PortfolioRepository;

@Service
public class PortfolioService {
	
	@Autowired
	private PortfolioRepository portfolioRepository;
	
	
	/**
	 * 포토폴리오 데이터 조회 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<PortfolioDomain> getPortfolioList(Map<String, Object> param){
		return portfolioRepository.getPortfolioList(param);
	}
	
	
	
	/**
	 * 포토폴리오 상세 조회 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public PortfolioDomain getPortfolioDetailInfo(Map<String, String> param){
		return portfolioRepository.getPortfolioDetailInfo(param);
	}	
	
	
	/**
	 * 포토폴리오 삭제 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@Transactional
	public void delPortfolio(Map<String, String> param) {		
		portfolioRepository.delPortfolio(param);		
	}
	
	/**
	 * 포토폴리오 저장
	 * @param     user
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertPortfolio(Map<String, String> param) {		
		portfolioRepository.insertPortfolio(param);
		
	}
	
	/**
	 * 포토폴리오 열람 히스토리 저장
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertPortfolioVisitHistory(Map<String, String> param) {		
		portfolioRepository.insertPortfolioVisitHistory(param);
		
	}
	
	
	/**
	 * 포토폴리오 수정
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void updatePortfolio(Map<String, String> param) {		
		portfolioRepository.updatePortfolio(param);
		
	}
	
	/**
	 * 포토폴리오 프로젝트 카운트
	 * @param    
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public String getProjectCount(Map<String, String> param) {
		return portfolioRepository.getProjectCount(param);
	}
	
	/**
	 * 포토폴리오 프로젝트 카운트 증가 수정 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	
	public void updateProjectCount(Map<String, String> param) {		
		portfolioRepository.updateProjectCount(param);		
	}
	
	
	/**
	 * 코드 데이터 조회 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommonDomain> getCodeList(String major){
		return portfolioRepository.getCodeList(major);
	}
	
	
	public String getConcatWords() {
		return portfolioRepository.getConcatWords();
	}
}
