package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.repository.MainRepository;

@Service
public class MainService {
	
	@Autowired
	private MainRepository mainRepository;
	
	/**
	 * 회원 카운트 조회
	 * @param param
	 * @return
	 */
	public int getUserSearchCount(Map<String, Object> param) {
		return mainRepository.getUserSearchCount(param);
	}
	
	/**
	 * 회원 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<UserDomain> getUserSearchList(Map<String, Object> param){
		return mainRepository.getUserSearchList(param);
	}
	
	
	/**
	 * 포토폴리오 카운트 조회
	 * @param param
	 * @return
	 */
	public int getPortfolioSearchCount(Map<String, Object> param) {
		return mainRepository.getPortfolioSearchCount(param);
	}
	
	/**
	 * 포토폴리오 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<PortfolioDomain> getPortfolioSearchList(Map<String, Object> param){
		return mainRepository.getPortfolioSearchList(param);
	}
	
	/**
	 * 회원 설문조사 참여조회
	 * @param     userId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public String getUserSurveyInfo(String userId) { 
		
		String isComplete = "";
		UserDomain user = mainRepository.getUserSurveyInfo(userId);
		if(user == null) {
			isComplete = "noUser";
		} else {
			if(user.getIsComplete() == null || user.getIsComplete().isEmpty()) {
				isComplete = "yesUser";
			} else {
				isComplete = user.getIsComplete();
			}
		}
		
		return isComplete;
	}

}
