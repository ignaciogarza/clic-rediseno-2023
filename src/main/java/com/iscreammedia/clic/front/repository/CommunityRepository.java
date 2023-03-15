package com.iscreammedia.clic.front.repository;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.CommunityDomain;

@Repository
public interface CommunityRepository {
	
	/**
	 * 친구 카운트 조회
	 * */
	public int getFriendListCount(Map<String, Object> param);

	/**
	 * 친구 조회
	 * */
	List<CommunityDomain> getFriendList(Map<String, Object> param);
	
	
	/**
	 * 포토폴리오 별 열람 카운트 조회 
	 * */
	CommunityDomain getPortfolioCountList(Map<String, Object> param);
	
	/**
	 * 그래프 데이터 조회 
	 * */
	CommunityDomain getChartDateList();
	
	
	
	
	/**
	 * 요청 보낸 친구 카운트 조회
	 * */
	public int getFriendSendListCount(Map<String, Object> param);
	
	

	/**
	 * 요청 보낸 친구 조회
	 * */
	List<CommunityDomain> getFriendSendList(Map<String, Object> param);
	
	
	/**
	 * 받은 친구 요청 카운트 조회
	 * */
	public int getFriendReceptionListCount(Map<String, Object> param);

	/**
	 * 받은 친구 요청 조회
	 * */
	List<CommunityDomain> getFriendReceptionList(Map<String, Object> param);
	
	List<CommunityDomain> getFriendCheckList(String userId);	
	
	List<CommunityDomain> getFriendCheckList02(String userId);	
	
	
	/**
	 * 추천친구 카운트 조회
	 * */
	public int getRecommendFriendCount(Map<String, Object> param);

	/**
	 * 추천친구 조회
	 * */
	List<CommunityDomain> getRecommendFriendList(Map<String, Object> param);
	
	
	/**
	 * 스킬코드 조회
	 * */
	List<String> getSkillCodeList(Map<String, Object> param);
	
	
	/**
	 * 친구 정보 카운트 조회
	 * */
	CommunityDomain getFriendCount(Map<String, Object> param);
	
	
	/**
	 * 스킬인증 카운트 조회
	 * */
	CommunityDomain getSkillAuthCount(Map<String, Object> param);
	
	
	
	/** 
	 * 친구 추가 저장
	 * */
	void insertFriend(Map<String, Object> param);
	
	
	/**
	 * 친구요청 승인
	 * */
	void approvalFriend(Map<String, Object> param);
	
	
	/**
	 * 친구요청 거절
	 * */
	void rejectFriend(Map<String, Object> param);
	
	
	/**
	 * 친구 삭제
	 * */
	void deleteFriend(Map<String, Object> param);
	
	
	/**
	 * 스킬 인증 카운트 조회
	 * */
	public int getSkillListCount(Map<String, Object> param);
	
	
	/**
	 * 스킬 인증 조회
	 * */
	List<CommunityDomain> getSkillList(Map<String, Object> param);
	
	
	/**
	 * 스킬 받은 인증 카운트 조회
	 * */
	public int getSkillReceptionListCount(Map<String, Object> param);
	
	
	/**
	 * 스킬 받은 인증 조회
	 * */
	List<CommunityDomain> getSkillReceptionList(Map<String, Object> param);
	
	List<CommunityDomain> getSkillReceptionList02(Map<String, Object> param);
	
	
	/**
	 * 스킬 보낸 인증 카운트 조회 
	 * */
	public int getSkillSendListCount(Map<String, Object> param);
	
	
	/**
	 * 스킬 보낸 인증 조회 
	 * */
	List<CommunityDomain> getSkillSendList(Map<String, Object> param);
	
	/**
	 * 친구인증 거부 
	 * */
	void rejectSkillFriendAuth(Map<String, Object> param);

}
