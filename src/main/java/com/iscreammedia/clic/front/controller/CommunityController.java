package com.iscreammedia.clic.front.controller;

import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.text.DateFormat;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.controller.viewmodel.PageInfo;
import com.iscreammedia.clic.front.domain.CommunityDomain;
import com.iscreammedia.clic.front.domain.ExamResult;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.service.CommunityService;
import com.iscreammedia.clic.front.service.EvaluationService;
import com.iscreammedia.clic.front.service.MypageService;
import com.iscreammedia.clic.front.service.NoticeService;
import com.iscreammedia.clic.front.service.PortfolioService;
import com.iscreammedia.clic.front.service.UserService;
import com.iscreammedia.clic.front.util.CryptoUtil;

import io.swagger.annotations.ApiOperation;


@Controller
@RequestMapping("/community")
public class CommunityController {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private CommunityService communityService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private EvaluationService evaluationService;
	
	@Autowired
	private PortfolioService portfolioService;
	
	@Autowired
	private NoticeService noticeService;
		
	
	@Autowired
	private MypageService mypageService;
	
	@Autowired
	private LocaleResolver localeResolver;
	
	@Value("${SecretKey}")
	private String secretKey;
	
	private static final String SESSIONEMAIL = "sessionEmail";
	private static final String USERID = "userId";
	private static final String STARTINDEX = "startIndex";
	private static final String SKILLCODE = "skillCode";
	private static final String PORTFOLIOID = "portfolioId";
	private static final String SEARCHVALUE = "searchValue";
	private static final String FRIENDID = "friendId";
	private static final String LOCAL = "local";
	
	
	/**
	 * 커뮤니티 메인 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communityMainView")
	@ApiOperation(value = "커뮤니티 메인 View ")
	public String communityMainView(){	
		
		return "community/communityMainView";
	}
	
	
	/**
	 * 커뮤니티 메인 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communityMainList")
	@ApiOperation(value = "커뮤니티 메인 조회 ")
	public BaseResponse<CommunityDomain> communityMainList(HttpServletRequest request, Locale locale)
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{	
		HttpSession session = request.getSession();
		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();		
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);
		
		String local = locale.toLanguageTag(); 
		
		//회원정보 조회 
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));  	
				
		
		HashMap<String, Object> paramData = new HashMap<>();		
		paramData.put(STARTINDEX, 0);		
		paramData.put("rows", 3);
		paramData.put(USERID, userId);
		paramData.put(LOCAL, local);
		
		//요청받은 친구 목록 
		List<CommunityDomain> friendReceptionList = communityService.getFriendReceptionList(paramData);	
		communityDomain.setFriendReceptionList(friendReceptionList);
		
		//추천 친구 목록
		//보유스킬 코드 조회 
		List<String> skillCodeList = communityService.getSkillCodeList(paramData);	
		paramData.put("countryCode", userDetail.getCountryCode());
		paramData.put("jobId", userDetail.getJobId());
		
		if(skillCodeList.isEmpty()) {
			paramData.put(SKILLCODE, null);
		}else {
			paramData.put(SKILLCODE, skillCodeList);
		}		
		
		List<CommunityDomain> recommendFriendList = communityService.getRecommendFriendList(paramData);	
		communityDomain.setRecommendFriendList(recommendFriendList);
		
		//친구 조회
		List<CommunityDomain> friendCheckList = communityService.getFriendCheckList(userId);
		communityDomain.setFriendCheckList(friendCheckList);
		
		HashMap<String, Object> paramSkill = new HashMap<>();		
		paramSkill.put(STARTINDEX, 0);		
		paramSkill.put("rows", 1); 
		paramSkill.put(USERID, userId);
		paramSkill.put(LOCAL, local);
		
		//스킬 완료 조회 
		List<CommunityDomain> skillList = communityService.getSkillList(paramSkill);
		communityDomain.setSkillList(skillList);
		
		//스킬 보낸 인증 
		List<CommunityDomain> skillSendList = communityService. getSkillSendList(paramSkill);
		communityDomain.setSkillSendList(skillSendList);
		
		//스킬 받은 인증 
		List<CommunityDomain> skillReceptionList = communityService.getSkillReceptionList02(paramSkill);
		communityDomain.setSkillReceptionList(skillReceptionList);
		
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);		
		
		return new BaseResponse<>(communityDomain);
	}
	
	
	/**
	 * 포토폴리오 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/portfolioChart")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 데이터 조회 ")
	public BaseResponse<CommunityDomain>  portfolioChart(HttpServletRequest request) {
	  HttpSession session = request.getSession();
		
     
	  String userId = (String) session.getAttribute(USERID);
      
	  //포토폴리오 조회 
	  HashMap<String, Object> param = new HashMap<>();
	  param.put("myuserId", userId);
	  param.put(USERID, userId);	
	  List<PortfolioDomain> portfolioList = portfolioService.getPortfolioList(param);
      
	  CommunityDomain community = new CommunityDomain();
	  
	  //차트 날짜 데이트 
	  CommunityDomain chartDate = communityService.getChartDateList();
	  community.setChartDate1(chartDate.getChartDate1());
	  community.setChartDate2(chartDate.getChartDate2());
	  community.setChartDate3(chartDate.getChartDate3());
	  community.setChartDate4(chartDate.getChartDate4());
	  community.setChartDate5(chartDate.getChartDate5());
	  community.setChartDate6(chartDate.getChartDate6());
	  community.setChartDate7(chartDate.getChartDate7());
	  
	  if(portfolioList.size() == 1) {
		  HashMap<String, Object> paramData1 = new HashMap<>();		
          paramData1.put(USERID, userId);
          paramData1.put(PORTFOLIOID, portfolioList.get(0).getPortfolioId());
          community.setPortfolioCountList1(communityService.getPortfolioCountList(paramData1));		  
	  }else if(portfolioList.size() == 2){
		  HashMap<String, Object> paramData1 = new HashMap<>();		
          paramData1.put(USERID, userId);
          paramData1.put(PORTFOLIOID, portfolioList.get(0).getPortfolioId());	
          community.setPortfolioCountList1(communityService.getPortfolioCountList(paramData1));
          
          HashMap<String, Object> paramData2 = new HashMap<>();		
	      paramData2.put(USERID, userId);
	      paramData2.put(PORTFOLIOID, portfolioList.get(1).getPortfolioId());	
	      community.setPortfolioCountList2(communityService.getPortfolioCountList(paramData2));
	  }else if(portfolioList.size() == 3){
		  HashMap<String, Object> paramData1 = new HashMap<>();		
          paramData1.put(USERID, userId);
          paramData1.put(PORTFOLIOID, portfolioList.get(0).getPortfolioId());	
          community.setPortfolioCountList1(communityService.getPortfolioCountList(paramData1));
          
          HashMap<String, Object> paramData2 = new HashMap<>();		
	      paramData2.put(USERID, userId);
	      paramData2.put(PORTFOLIOID, portfolioList.get(1).getPortfolioId());	
	      community.setPortfolioCountList2(communityService.getPortfolioCountList(paramData2));
	      
	      HashMap<String, Object> paramData3 = new HashMap<>();		
	      paramData3.put(USERID, userId);
	      paramData3.put(PORTFOLIOID, portfolioList.get(2).getPortfolioId());	
	      community.setPortfolioCountList3(communityService.getPortfolioCountList(paramData3));
	  }
	  
      return new BaseResponse<>(community);      
	}
	
	
	/**
	 * 커뮤니티 전체친구정보 리스트 VIEW
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communityFriendAllView")
	@ApiOperation(value = "커뮤니티 전체친구정보 리스트 VIEW")
	public String communityFriendView(){	
		
		return "community/communityFriendAllView";
	}	
	
	
	/**
	 * 커뮤니티 전체친구정보 리스트 조회
	 * @param page
	 * @param rows
	 * @param searchValue
     * @return CommunityDomain
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communityFriendAllList")
	@ApiOperation(value = "커뮤니티 전체친구정보 리스트 조회")
	public BaseResponse<CommunityDomain> communityFriendAllList(HttpServletRequest request,			
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows,
			@RequestParam(value = "searchValue", required = false) String searchValue) {	
		HttpSession session = request.getSession();
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();		
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);		
		
		//친구 조회
		List<CommunityDomain> friendCheckList = communityService.getFriendCheckList(userId);
		communityDomain.setFriendCheckList(friendCheckList);
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put("page", page);
		paramData.put("rows", rows);
		//paramData.put(SEARCHVALUE, searchValue);
		paramData.put(USERID, userId);	
			
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		communityDomain.setSearchValue(searchValue);
		
		if(searchValue == null) {
			communityDomain.setNoSearchType("Y");
		}else {
			communityDomain.setNoSearchType("N");
		}		
		
		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);			
		
		//검색어  
		String[] splited = searchValue.split("\\s+");
		for(int i = 0 ; i<splited.length ; i++) {
			paramData.put(SEARCHVALUE, splited[i]);
			communityDomain.setList(communityService.getFriendList(paramData));
		}
		//communityDomain.setList(communityService.getFriendList(paramData));
		
		int total = communityService.getFriendListCount(paramData);	
		int sendTotal = communityService.getFriendSendListCount(paramData);		
		int receptionTotal = communityService.getFriendReceptionListCount(paramData);	
		
		communityDomain.setAllTotal(total);
		communityDomain.setSendTotal(sendTotal);
		communityDomain.setReceptionTotal(receptionTotal);
			
		PageInfo pi = new PageInfo(total, rows, 10, page);		
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);
		
		return new BaseResponse<>(communityDomain);
	}	
	
	
	
	
	
	/**
	 * 커뮤니티 받은친구정보 리스트 VIEW
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communityFriendReceptionView")
	@ApiOperation(value = "커뮤니티 받은친구정보 리스트 VIEW")
	public String communityFriendReceptionView(){			
		return "community/communityFriendReceptionView";
	}
	
	
	/**
	 * 커뮤니티 받은친구정보 리스트 조회
	 * @param page
	 * @param rows
	 * @param  searchValue 
     * @return CommunityDomain
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communityFriendReceptionList")
	@ApiOperation(value = "커뮤니티 받은친구정보 리스트 조회")
	public BaseResponse<CommunityDomain> communityFriendReceptionList(HttpServletRequest request,			
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows,
			@RequestParam(value = "searchValue", required = false) String searchValue,
			Locale locale) {	
		HttpSession session = request.getSession();
		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);
		
		String local = locale.toLanguageTag(); 
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put("page", page);
		paramData.put("rows", rows);
		//paramData.put(SEARCHVALUE, searchValue);
		paramData.put(USERID, userId);
		paramData.put(LOCAL, local);		
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		communityDomain.setSearchValue(searchValue);
		
		if(searchValue == null) {
			communityDomain.setNoSearchType("Y");
		}else {
			communityDomain.setNoSearchType("N");
		}		
		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);
		
		String[] splited = searchValue.split("\\s+");
		for(int i = 0 ; i<splited.length ; i++) {
			paramData.put(SEARCHVALUE, splited[i]);
			communityDomain.setList(communityService.getFriendReceptionList(paramData));
		}
		//communityDomain.setList(communityService.getFriendReceptionList(paramData));
		
		int allTotal = communityService.getFriendListCount(paramData);	
		int sendTotal = communityService.getFriendSendListCount(paramData);	
		int total = communityService.getFriendReceptionListCount(paramData);	
		
		communityDomain.setAllTotal(allTotal);
		communityDomain.setSendTotal(sendTotal);
		communityDomain.setReceptionTotal(total);
			
		PageInfo pi = new PageInfo(total, rows, 10, page);		
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());
		
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);		
		
		return new BaseResponse<>(communityDomain);
	}
	
	
	/**
	 * 커뮤니티 추천친구찾기 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communityRecommendFriendView")
	@ApiOperation(value = "커뮤니티 추천친구찾기 View")
	public String communityRecommendFriendView(){					
		return "community/communityRecommendFriendView";
	}
	
	/**
	 * 커뮤니티 추천친구찾기 조회
	 * @param   page
	 * @param   rows
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/communityRecommendFriendList")
	@ResponseBody
	@ApiOperation(value = " 커뮤니티 추천친구찾기 조회")
	public BaseResponse<CommunityDomain> communityRecommendFriendList(HttpServletRequest request,			
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows)
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{	
		HttpSession session = request.getSession();
		CommunityDomain communityDomain = new CommunityDomain();		
		
		communityDomain.setEmail((String) session.getAttribute(SESSIONEMAIL));
		communityDomain.setUserId((String) session.getAttribute(USERID));		
		
		String userId = (String) session.getAttribute(USERID);
		String email = (String) session.getAttribute(SESSIONEMAIL);
		
		//회원정보 조회 
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));  	
			
		HashMap<String, Object> paramData = new HashMap<>();
		paramData.put("page", page);
		paramData.put("rows", rows);
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		
		paramData.put(USERID, userId);
		paramData.put("countryCode", userDetail.getCountryCode());
		paramData.put("cityId", userDetail.getCityId());
		paramData.put("jobId", userDetail.getJobId());	  
		
		//보유스킬 코드 조회 
		List<String> skillCodeList = communityService.getSkillCodeList(paramData);	
		if(skillCodeList.isEmpty()) {
			paramData.put(SKILLCODE, null);
		}else {
			paramData.put(SKILLCODE, skillCodeList);
		}
		
		int total = communityService.getRecommendFriendCount(paramData);		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);
		
		List<CommunityDomain> getRecommendFriendList = communityService.getRecommendFriendList(paramData);
		communityDomain.setList(getRecommendFriendList);
			
		PageInfo pi = new PageInfo(total, rows, 10, page);
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());		
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);
				
		return new BaseResponse<>(communityDomain);
	}
	
	/**
	 * 커뮤니티 보낸친구정보 리스트 VIEW
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communityFriendSendView")
	@ApiOperation(value = "커뮤니티 보낸친구정보 리스트 VIEW")
	public String communityFriendSendView(){	
		
		return "community/communityFriendSendView";
	}
	
	/**
	 * 커뮤니티 보낸친구정보 리스트 조회
	 * @param page
	 * @param rows
	 * @param searchValue
     * @return CommunityDomain
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communityFriendSendList")
	@ApiOperation(value = "커뮤니티 보낸친구정보 리스트 조회")
	public BaseResponse<CommunityDomain> communityFriendSendList(HttpServletRequest request,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows,
			@RequestParam(value = "searchValue", required = false) String searchValue){	
		HttpSession session = request.getSession();
		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);
		
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put("page", page);
		paramData.put("rows", rows);
		//paramData.put(SEARCHVALUE, searchValue);		
		paramData.put(USERID, userId);
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		communityDomain.setSearchValue(searchValue);
		
		if(searchValue == null) {
			communityDomain.setNoSearchType("Y");
		}else {
			communityDomain.setNoSearchType("N");
		}		
		
		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);
		
		String[] splited = searchValue.split("\\s+");
		for(int i = 0 ; i<splited.length ; i++) {
			paramData.put(SEARCHVALUE, splited[i]);
			communityDomain.setList(communityService.getFriendSendList(paramData));
		}
		//communityDomain.setList(communityService.getFriendSendList(paramData));
		
		int allTotal = communityService.getFriendListCount(paramData);	
		int total = communityService.getFriendSendListCount(paramData);		
		int receptionTotal = communityService.getFriendReceptionListCount(paramData);
		
		communityDomain.setAllTotal(allTotal);
		communityDomain.setSendTotal(total);
		communityDomain.setReceptionTotal(receptionTotal);
			
		PageInfo pi = new PageInfo(total, rows, 10, page);
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());
		
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);	
				
		return new BaseResponse<>(communityDomain);
	}
	
	/**
	 * 친구요청
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/friendRequestSave")
	@ResponseBody
	@ApiOperation(value = "친구요청")
	public BaseResponse<Integer> friendRequestSave(
			@RequestParam("userId") String userId,
			@RequestParam("friendId") String friendId,
			Locale locale){
		
			//친구 테이블에 요청 저장
			HashMap<String, Object> param = new HashMap<>();
			param.put(FRIENDID, friendId);
			param.put(USERID, userId);
			param.put("friendStatusCode", "1101");			// 1101 친구요청중    1102 친구재요청중  1103친구  1104친구거절			
			communityService.insertFriend(param);
						
			// 알람 발송  Locale locale, String userId, String friendId
			noticeService.insertFriendRequest(locale, userId, friendId);
			
		return new BaseResponse<>(1);
	}
	
	/**
	 * 친구 삭제 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/deleteFriend")
	@ResponseBody
	@ApiOperation(value = "친구삭제")
	public BaseResponse<Integer> deleteFriend(
			@RequestParam("userId") String userId,
			@RequestParam("friendId") String friendId){			  
		
			HashMap<String, Object> param = new HashMap<>();
			param.put(FRIENDID, friendId);
			param.put(USERID, userId);
			
			communityService.deleteFriend(param);	
		
		return new BaseResponse<>(1);
	}
	
	/**
	 * 친구 요청 승인 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/approvalFriend")
	@ResponseBody
	@ApiOperation(value = "친구 요청 승인")
	public BaseResponse<Integer> approvalFriend(
			@RequestParam("userId") String userId,
			@RequestParam("friendId") String friendId){
			
			HashMap<String, Object> param = new HashMap<>();
			param.put(FRIENDID, userId);
			param.put(USERID, friendId);	
			communityService.approvalFriend(param);	
			
			
			//요청 승인 하면서 한번더 friendId userId 바꺼서 등록 한번 해야 함 (확인 필요.)			
			HashMap<String, Object> friendParam = new HashMap<>();
			friendParam.put(FRIENDID, friendId);
			friendParam.put(USERID, userId);
			friendParam.put("friendStatusCode", "1103");			// 1101 친구요청중    1102 친구재요청중  1103친구  1104친구거절			
			communityService.insertFriend(friendParam);
					
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 친구 요청 거절
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/rejectFriend")
	@ResponseBody
	@ApiOperation(value = "친구 요청 거절")
	public BaseResponse<Integer> rejectFriend(
			@RequestParam("userId") String userId,
			@RequestParam("friendId") String friendId){			  
				
			HashMap<String, Object> param = new HashMap<>();
			param.put(FRIENDID, userId);
			param.put(USERID, friendId);
			communityService.rejectFriend(param);
			
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 전체 스킬 인증 조회 VIEW
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communitySkillAllView")
	@ApiOperation(value = "전체 스킬 인증 조회 VIEW")
	public String communitySkillAllView(){	
		
		return "community/communitySkillAllView";
	}
	
	/**
	 * 전체 스킬 인증 조회 
	 * @param page
	 * @param  rows
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communitySkillAllList")
	@ApiOperation(value = "전체 스킬 인증 조회")
	public BaseResponse<CommunityDomain> communitySkillAllList(HttpServletRequest request,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows,
			Locale locale ){	
		HttpSession session = request.getSession();
		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);
		
		//친구 조회
		List<CommunityDomain> friendCheckList = communityService.getFriendCheckList(userId);
		communityDomain.setFriendCheckList(friendCheckList);
		
		String local = locale.toLanguageTag();
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put("page", page);
		paramData.put("rows", rows);
		paramData.put(USERID, userId);
		paramData.put(local, local);	
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		
		int total = communityService.getSkillListCount(paramData);			
		int receptionTotal = communityService.getSkillReceptionListCount(paramData);	
		int sendTotal = communityService.getSkillSendListCount(paramData);		
		
		communityDomain.setAllTotal(total);		
		communityDomain.setReceptionTotal(receptionTotal);
		communityDomain.setSendTotal(sendTotal);
		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);
			
		
		communityDomain.setList(communityService.getSkillList(paramData));
			
		PageInfo pi = new PageInfo(total, rows, 10, page);
		
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);		
		
		return new BaseResponse<>(communityDomain);
	}
	
	
	/**
	 * 스킬 받은 인증조회 VIEW
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communitySkillReceptionView")
	@ApiOperation(value = "스킬 받은 인증조회 VIEW")
	public String communitySkillReceptionView(){
		return "community/communitySkillReceptionView";
	}
	
	/**
	 * 스킬 받은 인증조회 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communitySkillReceptionList")
	@ApiOperation(value = "스킬 받은 인증조회")
	public BaseResponse<CommunityDomain> communitySkillReceptionList(HttpServletRequest request,
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows,
			Locale locale ){	
		HttpSession session = request.getSession();
		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);
		
		String local = locale.toLanguageTag();
		
		//친구 조회
		List<CommunityDomain> friendCheckList = communityService.getFriendCheckList(userId);
		communityDomain.setFriendCheckList(friendCheckList);
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put("page", page);
		paramData.put("rows", rows);
		paramData.put(USERID, userId);
		paramData.put(LOCAL, local);	
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		
		int allTotal = communityService.getSkillListCount(paramData);	
		int total = communityService.getSkillReceptionListCount(paramData);		
		int sendTotal = communityService.getSkillSendListCount(paramData);
		communityDomain.setAllTotal(allTotal);		
		communityDomain.setReceptionTotal(total);
		communityDomain.setSendTotal(sendTotal);
		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);
			
		communityDomain.setList(communityService.getSkillReceptionList(paramData));
			
		PageInfo pi = new PageInfo(total, rows, 10, page);
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());
		
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);	
		
		return new BaseResponse<>(communityDomain);
	}
	
	
	/**
	 * 스킬 보낸 인증조회 VIEW
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communitySkillSendView")
	@ApiOperation(value = "스킬 보낸 인증조회 VIEW")
	public String communitySkillSendView() {
		return "community/communitySkillSendView";
	}
	
	/**
	 * 스킬 보낸 인증조회 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/communitySkillSendList")
	@ApiOperation(value = "스킬 보낸 인증조회")
	public BaseResponse<CommunityDomain> communitySkillSendList(HttpServletRequest request,			
			@RequestParam(value = "page", required = false, defaultValue = "1") int page,
			@RequestParam(value = "rows", required = false, defaultValue = "10") int rows,
			Locale locale )throws ParseException {	
		HttpSession session = request.getSession();
		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		CommunityDomain communityDomain = new CommunityDomain();
		communityDomain.setUserId(userId);
		communityDomain.setEmail(email);
		
		String local = locale.toLanguageTag();
		
		//친구 조회
		List<CommunityDomain> friendCheckList = communityService.getFriendCheckList(userId);
		communityDomain.setFriendCheckList(friendCheckList);
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put("page", page);
		paramData.put("rows", rows);
		paramData.put(USERID, userId);
		paramData.put(LOCAL, local);	
		
		communityDomain.setPage(page);
		communityDomain.setRows(rows);
		
		int allTotal = communityService.getSkillListCount(paramData);	
		int receptionTotal = communityService.getSkillReceptionListCount(paramData);		
		int total = communityService.getSkillSendListCount(paramData);			
				
		communityDomain.setAllTotal(allTotal);		
		communityDomain.setReceptionTotal(receptionTotal);
		communityDomain.setSendTotal(total);
		
		int startIndex = (page - 1) * rows;
		paramData.put(STARTINDEX, startIndex);
	
		List<CommunityDomain> skillSendList = communityService.getSkillSendList(paramData);
		
		//인증요청 일자 72시간 체크 
		for(int i = 0 ; i<skillSendList.size() ; i++) {			
			
	        DateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");	        
	        String dateStart = skillSendList.get(i).getAuthDateCheck(); 
	        
	        Date currentTime = new Date();
			String dateStop = format.format(currentTime);
	       
	        Date d1 = null;
	        Date d2 = null;
	        
	        d1 = format.parse(dateStart);
	        d2 = format.parse(dateStop);
	          

	        // Get msec from each, and subtract.
	        long diff = d2.getTime() - d1.getTime();	        
	        long diffHours = diff / (60 * 60 * 1000); 
	        
	        
	        if(diffHours >= 63) {  // utc -9 하면됨
	        	skillSendList.get(i).setTimeCheck("N");
	        }else {
	        	skillSendList.get(i).setTimeCheck("Y");
	        }
		}		
		communityDomain.setList(skillSendList);
		
			
		PageInfo pi = new PageInfo(total, rows, 10, page);		
		communityDomain.setTotalCount(total);
		communityDomain.setTotalPage(pi.getTotalPage());
		
		
		//친구정보 카운트 조회 
		CommunityDomain friendCount = communityService.getFriendCount(paramData);
		communityDomain.setFriendCount(friendCount);
		
		//스킬인증 카운트 조회 
		CommunityDomain skillAuthCount = communityService.getSkillAuthCount(paramData);
		communityDomain.setSkillAuthCount(skillAuthCount);
		
		return new BaseResponse<>(communityDomain);
	}
	
	
	/**
	 * 인증요청 시험결과 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getExamResult")
	@ResponseBody
	@ApiOperation(value = "인증요청 시험결과 조회 ")
	public BaseResponse<ExamResult>  getExamResult(
			@RequestParam("userId") String userId,
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode,
			Locale locale){
	  
	  ExamResult result = evaluationService.getExamResult(locale, userId, skillCode, examClassCode);
	  
	  Skill data = evaluationService.getSkill(locale, userId, skillCode, examClassCode);
	  result.setDataSkill(data);
	  
	  UserDomain user = mypageService.selecSkilltUser(locale, userId, skillCode, examClassCode);
	  result.setUser(user);
	  
      return new BaseResponse<>(result);      
	} 
	
	
	
	/**
	 * 스킬 인증 완료 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/completeSkillFriendAuth")
	@ResponseBody
	@ApiOperation(value = "스킬 인증 완료 ")
	public BaseResponse<Integer> completeSkillFriendAuth(Locale locale,
			@RequestParam("userId") String userId,	
			@RequestParam("friendId") String friendId,
			@RequestParam("skillCode") String skillCode, 
			@RequestParam("authContents") String authContents,
			@RequestParam("examClassCode") String examClassCode){
			  
		
			HashMap<String, Object> paramData = new HashMap<>();	
			paramData.put(SKILLCODE, skillCode);
			paramData.put("examClassCode", examClassCode);
			paramData.put(USERID, userId);
			paramData.put(FRIENDID, friendId);
			
			evaluationService.completeSkillFriendAuth(locale, friendId, userId, skillCode, examClassCode, authContents);
			
		return new BaseResponse<>(1);
	}
	
	/**
	 * 스킬 인증 거절 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/completeSkillDel")
	@ResponseBody
	@ApiOperation(value = "스킬 인증 거절 ")
	public BaseResponse<Integer> completeSkillDel(Locale locale,
			@RequestParam("userId") String userId,	
			@RequestParam("friendId") String friendId,
			@RequestParam("skillCode") String skillCode, 
			@RequestParam("authContents") String authContents,
			@RequestParam("examClassCode") String examClassCode){
		
			HashMap<String, Object> paramData = new HashMap<>();	
			paramData.put(SKILLCODE, skillCode);
			paramData.put("examClassCode", examClassCode);
			paramData.put(USERID, userId);
			paramData.put(FRIENDID, friendId);
			
			//스킬인증 거절 상태값 변경 
			communityService.rejectSkillFriendAuth(paramData);						
			
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 스킬 인증 요청
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/againSkillFriendAuth")
	@ResponseBody
	@ApiOperation(value = "스킬 인증 요청")
	public BaseResponse<Integer> againSkillFriendAuth(Locale locale, 
			@RequestParam("userId") String userId,	
			@RequestParam("friendId") String friendId,	
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode){
		
			evaluationService.insertSkillFriendAuth(locale, userId, friendId, skillCode, examClassCode);
			
			// 알람 발송 이거 확인 필요.
			noticeService.insertSkillAuthComplete(locale, evaluationService.getSkillName(locale, skillCode, examClassCode), skillCode,
					examClassCode, friendId, userId);
		
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 스킬 인증 요청취소 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/deleteSkillFriendAuth")
	@ResponseBody
	@ApiOperation(value = "스킬 인증 요청취소")
	public BaseResponse<Integer> deleteSkillFriendAuth(@RequestParam("userId") String userId,	
			@RequestParam("friendId") String friendId,	
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode){
		
		evaluationService.deleteSkillFriendAuth(userId, friendId, skillCode, examClassCode);			
			
		return new BaseResponse<>(1);
	}
	
	

}
