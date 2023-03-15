package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.CommunityDomain;
import com.iscreammedia.clic.front.repository.CommunityRepository;

@Service
public class CommunityService {
	
	@Autowired
	private CommunityRepository communityRepository;
	
	/**
	 * 친구 카운트 조회 
	 * @param param
	 * @return
	 */
	public int getFriendListCount(Map<String, Object> param){
		return communityRepository.getFriendListCount(param);
	}
	
	/**
	 * 친구 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getFriendList(Map<String, Object> param){
		return communityRepository.getFriendList(param);
	}
	
	
	
	/**
	 * 포토폴리오 별 열람 카운트 조회 
	 * */
	public CommunityDomain getPortfolioCountList(Map<String, Object> param){
		return communityRepository.getPortfolioCountList(param);
	}
	
	
	public CommunityDomain getChartDateList(){
		return communityRepository.getChartDateList();
	}
	
	
	/**
	 * 요청 보낸 친구 카운트 조회 
	 * @param param
	 * @return
	 */
	public int getFriendSendListCount(Map<String, Object> param)  {
		return communityRepository.getFriendSendListCount(param);
	}
	
	/**
	 * 요청 보낸 친구 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getFriendSendList(Map<String, Object> param){
		return communityRepository.getFriendSendList(param);
	}
	
	
	/**
	 * 받은 친구 요청 카운트 조회 
	 * @param param
	 * @return
	 */
	public int getFriendReceptionListCount(Map<String, Object> param)  {
		return communityRepository.getFriendReceptionListCount(param);
	}
	
	/**
	 * 받은 친구 요청 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getFriendReceptionList(Map<String, Object> param){
		return communityRepository.getFriendReceptionList(param);
	}
	
	/**
	 * 친구 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getFriendCheckList(String userId){
		return communityRepository.getFriendCheckList(userId);
	}
	
	public List<CommunityDomain> getFriendCheckList02(String userId){
		return communityRepository.getFriendCheckList02(userId);
	}
	
		
	
	/**
	 * 추천친구 카운트 조회 
	 * @param param
	 * @return
	 */
	public int getRecommendFriendCount(Map<String, Object> param) {		
		return communityRepository.getRecommendFriendCount(param);
	}
	
	/**
	 * 추천친구 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getRecommendFriendList(Map<String, Object> param){
		return communityRepository.getRecommendFriendList(param);
	}
	
	
	/**
	 * 스킬코드 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<String> getSkillCodeList(Map<String, Object> param){
		return communityRepository.getSkillCodeList(param);
	}

	
	
	/**
	 * 친구 정보 카운트 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public CommunityDomain getFriendCount(Map<String, Object> param){
		return communityRepository.getFriendCount(param);
	}
	
	/**
	 * 스킬인증 카운트 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public CommunityDomain getSkillAuthCount(Map<String, Object> param){
		return communityRepository.getSkillAuthCount(param);
	}
	
	
	/**
	 * 친구 추가  저장
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void insertFriend(Map<String, Object> param) {		
		communityRepository.insertFriend(param);		
	}
	
	
	/**
	 * 친구요청 승인
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void approvalFriend(Map<String, Object> param) {
		communityRepository.approvalFriend(param);
	}
	
	
	/**
	 * 친구요청 거절
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void rejectFriend(Map<String, Object> param) {
		communityRepository.rejectFriend(param);
	}

	/**
	 * 친구 삭제
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void deleteFriend(Map<String, Object> param) {		
		communityRepository.deleteFriend(param);		
	}
	
	/**
	 * 스킬 인증 카운트 조회 
	 * @param param
	 * @return
	 */
	public int getSkillListCount(Map<String, Object> param) {
		return communityRepository.getSkillListCount(param);
	}
	
	/**
	 * 스킬 인증 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getSkillList(Map<String, Object> param){
		return communityRepository.getSkillList(param);
	}
	
	
	/**
	 * 스킬 받은 인증 카운트 조회
	 * @param param
	 * @return
	 */
	public int getSkillReceptionListCount(Map<String, Object> param)  {
		return communityRepository.getSkillReceptionListCount(param);
	}
	
	/**
	 * 스킬 받은 인증 조회
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getSkillReceptionList(Map<String, Object> param){
		return communityRepository.getSkillReceptionList(param);
	}
	
	public List<CommunityDomain> getSkillReceptionList02(Map<String, Object> param){
		return communityRepository.getSkillReceptionList02(param);
	}
	
	/**
	 * 스킬 보낸 인증 카운트 조회 
	 * @param param
	 * @return
	 */
	public int getSkillSendListCount(Map<String, Object> param)  {
		return communityRepository.getSkillSendListCount(param);
	}
	
	/**
	 * 스킬 보낸 인증 조회 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<CommunityDomain> getSkillSendList(Map<String, Object> param){
		return communityRepository.getSkillSendList(param);
	}
	
	
	/**
	 * 친구인증 거부 
	 * @param     param
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public void rejectSkillFriendAuth(Map<String, Object> param) {		
		communityRepository.rejectSkillFriendAuth(param);		
	}
	
}
