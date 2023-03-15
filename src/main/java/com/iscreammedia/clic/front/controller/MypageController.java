package com.iscreammedia.clic.front.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.ExamResult;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.MypageCommunityDomain;
import com.iscreammedia.clic.front.domain.MypageSkillDomain;
import com.iscreammedia.clic.front.domain.MypageUserDomain;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.SkillEducationDomain;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.service.CommunityService;
import com.iscreammedia.clic.front.service.EvaluationService;
import com.iscreammedia.clic.front.service.MypageService;
import com.iscreammedia.clic.front.service.PortfolioService;
import com.iscreammedia.clic.front.service.SkillEducationService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/mypage")
public class MypageController {

	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	MypageService mypageService;
	
	@Autowired
	PortfolioService portfolioService;
	
	@Autowired
	CommunityService communityService;
	
	@Autowired
	SkillEducationService skillEducationService;
	
	@Autowired
	LocaleResolver localeResolver;
	
	@Autowired
	EvaluationService evaluationService;
	
	private static final String USERID = "userId";
	private static final String FRIENDID = "friendId";
	
	/**
	 * 마이페이지 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/mypageMain")
	@ApiOperation(value = "마이페이지 조회 View")
	public String mypageMain() {
		
		return "mypage/mypageMain";
	}
	
	/**
	 * 뱃지 획득 조회<br>
	 * 
	 * @param     locale
	 * @param     request
     * @return MypageSkillDomain
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/badgeList")
	@ApiOperation(value = "뱃지 획득 조회")
	@ResponseBody
	public BaseResponse<MypageSkillDomain> badgeList(Locale locale, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		
		MypageSkillDomain skillDomain = new MypageSkillDomain();
		
		skillDomain.setSkillList(mypageService.selectSkillList(locale, userId));
		skillDomain.setSelfCount(mypageService.selfCount(userId));
		skillDomain.setExamCount(mypageService.examCount(userId));
		skillDomain.setFriendCount(mypageService.friendCount(userId));
		skillDomain.setBadgeGetCount(mypageService.badgeGetCount(userId));
		
		return new BaseResponse<>(skillDomain);
	}
	
	
	/**
	 * 커뮤니티 조회<br>
	 * 
	 * @param     locale
	 * @param     request
     * @return MypageCommunityDomain
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/communityList")
	@ApiOperation(value = "커뮤니티 조회")
	@ResponseBody
	public BaseResponse<MypageCommunityDomain> communityList(Locale locale, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		
		MypageCommunityDomain communityDomain = new MypageCommunityDomain();
		
		//커뮤니티 조회
		HashMap<String, Object> param = new HashMap<>();
		param.put("startIndex", 0);
		param.put("rows", 3);
		param.put(USERID, userId);
		param.put("language", LanguageCode.getLanguage(locale));
		
		communityDomain.setUserId(userId);
		communityDomain.setCommunityList(mypageService.selectCommunityList(param));
		communityDomain.setFriendCheckList(communityService.getFriendCheckList(userId));
		
		return new BaseResponse<>(communityDomain);
	}
	
	
	
	/**
	 * 교육 조회<br>
	 * 
	 * @param     locale
	 * @param     request
	 * @return List
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/eduList")
	@ApiOperation(value = "교육 조회")
	@ResponseBody
	public BaseResponse<List<SkillEducationDomain>> educationList(Locale locale, HttpServletRequest request) {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		int rows = 3;
		List<SkillEducationDomain> educationList = mypageService.selectEduList(locale, userId, rows);
		
		return new BaseResponse<>(educationList);
	}
	
	/**
	 * 포트폴리오 조회<br>
	 * 
	 * @param     locale
	 * @param     request
	 * @return List
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/portfolioList")
	@ApiOperation(value = "포트폴리오 조회")
	@ResponseBody
	public BaseResponse<List<PortfolioDomain>> portfolioList(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String myuserId = (String) session.getAttribute(USERID);
		String userId = (String) session.getAttribute(USERID);
		
		HashMap<String, Object> param = new HashMap<>();
		param.put("myuserId", myuserId);
		param.put(USERID, userId);	
		List<PortfolioDomain> portfolioList = portfolioService.getPortfolioList(param);
		
		return new BaseResponse<>(portfolioList);
	}
	
	/**
	 * 친구 요청 승인<br>
	 * 
	 * @param     userId
	 * @param     friendId
	 * @param     locale
	 * @param     request
     * @return MypageUserDomain
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/approvalFriend")
	@ApiOperation(value = "친구 요청 승인")
	@ResponseBody
	public BaseResponse<MypageUserDomain> approvalFriend(
		@RequestParam("userId") String userId,
		@RequestParam("friendId") String friendId,
		Locale locale, HttpServletRequest request) {
	
		HashMap<String, Object> param = new HashMap<>();
		param.put(FRIENDID, friendId);
		param.put(USERID, userId);			
		communityService.approvalFriend(param);	
		
		//요청 승인 하면서 한번더 friendId userId 바꺼서 등록 한번 해야 함 (확인 필요.)			
		HashMap<String, Object> friendParam = new HashMap<>();
		friendParam.put(FRIENDID, userId);
		friendParam.put(USERID, friendId);
		friendParam.put("friendStatusCode", "1103");			// 1101 친구요청중    1102 친구재요청중  1103친구  1104친구거절			
		communityService.insertFriend(friendParam);

		MypageUserDomain user = mypageService.selectUser(locale, userId);

		return new BaseResponse<>(user);
	}
	
	/**
	 * 친구 요청 거절<br>
	 * 
	 * @param     userId
	 * @param     friendId
	 * @param     locale
     * @return MypageUserDomain
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/rejectFriend")
	@ApiOperation(value = "친구 요청 거절")
	@ResponseBody
	public BaseResponse<MypageUserDomain> rejectFriend(
		@RequestParam("userId") String userId,
		@RequestParam("friendId") String friendId,
		Locale locale) {
		
		HashMap<String, Object> param = new HashMap<>();
		param.put(FRIENDID, friendId);
		param.put(USERID, userId);
		
		communityService.rejectFriend(param);	
		
		MypageUserDomain user = mypageService.selectUser(locale, userId);
				
		return new BaseResponse<>(user);
	}
	
	
	/**
	 * 인증요청 시험결과 조회<br>
	 * 
	 * @param     userId
	 * @param     skillCode
	 * @param     examClassCode
	 * @param     locale
     * @return ExamResult
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/getExamResult")
	@ApiOperation(value = "인증요청 시험결과 조회")
	@ResponseBody
	public BaseResponse<ExamResult>  getExamResult(
			@RequestParam("userId") String userId,
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode,
			@RequestParam("friendId") String friendId,
			Locale locale) {
	  
	  ExamResult result = evaluationService.getExamResult(locale, userId, skillCode, examClassCode);
	  
	  Skill data = evaluationService.getSkill(locale, userId, skillCode, examClassCode);
	  result.setDataSkill(data);
	  
	  UserDomain user = mypageService.selecSkilltUser(locale, userId, skillCode, examClassCode);
	  result.setUser(user);
	  result.setFriendCheckList(communityService.getFriendCheckList(friendId));
	  
      return new BaseResponse<>(result);      
	}
	
}
