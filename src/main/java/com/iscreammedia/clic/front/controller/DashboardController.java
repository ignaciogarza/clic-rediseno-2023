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
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.DashboardDomain;
import com.iscreammedia.clic.front.service.DashboardService;

import io.swagger.annotations.ApiOperation;

@Controller
@RequestMapping("/dashboard")
public class DashboardController {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private DashboardService dashboardService;	
	
	private static final String SESSIONEMAIL = "sessionEmail";
	private static final String USERID = "userId";
	private static final String LANGUAGE = "language";
	private static final String STCTYPE = "stcType";
	private static final String SKILLSTCCODE = "skillStcCode";	
	private static final String TOTAL = "TOTAL";
	private static final String RESUME = "RESUME";
	private static final String PORTFOLIO = "PORTFOLIO";
	private static final String USER = "USER";
	private static final String PASS = "PASS";
	private static final String SEARCHDATE = "searchDate";
	private static final String CITYID = "cityId";
	private static final String MAJOR = "major";
	private static final String JOBCODE = "jobCode";
	private static final String SKILLCODE = "skillCode";
	
	private static final String SELF = "SELF";
	private static final String SKILL = "SKILL";
	
	
	
	
	 
	
	
	/**
	 * 대시보드 메인 View 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardMainView")
	@ApiOperation(value = "대시보드 메인 View")
	public String dashboardMainView(){
		return "dashboard/dashboardMain";
	}
	
	/**
	 * 대시보드 메인조회
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/dashboardMainList")
	@ApiOperation(value = "대시보드 메인조회")
	public BaseResponse<DashboardDomain> dashboardMainList(Locale locale, HttpServletRequest request) {	
		
		HttpSession session = request.getSession();		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		

		DashboardDomain dashboardDomain = new DashboardDomain();		
		dashboardDomain.setUserId(userId);
		dashboardDomain.setEmail(email);

		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put(LANGUAGE, locale.getLanguage()); 
		  
		//회원수
		paramData.put(STCTYPE, USER);
		dashboardDomain.setUserCnt(dashboardService.getDocumentTypeCount(paramData));
		  
		//테스트응시 
		paramData.put(SKILLSTCCODE, TOTAL);
		dashboardDomain.setSkillStcTotalCnt(dashboardService.getSkillTestCount(paramData));
		
		//테스트통과
		paramData.put(SKILLSTCCODE, PASS);
		dashboardDomain.setSkillStcPassCnt(dashboardService.getSkillTestCount(paramData));
		  
		//이력서
		paramData.put(STCTYPE, RESUME);  
		dashboardDomain.setResumeCnt(dashboardService.getDocumentTypeCount(paramData));
		  
		//포토폴리오
		paramData.put(STCTYPE, PORTFOLIO);
		dashboardDomain.setPortfolioCnt(dashboardService.getDocumentTypeCount(paramData));
		return new BaseResponse<>(dashboardDomain);
	}
	
	
	/**
	 * 대시보드 회원 View 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardOverview")
	@ApiOperation(value = "대시보드 회원 View ")
	public String dashboardOverview(){
		return "dashboard/dashboardOverview";
	}
	
	
	
	/**
	 * 포토폴리오 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getStcCodeMemberList")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 데이터 조회 ")
	public BaseResponse<DashboardDomain>  getStcCodeMemberList(Locale locale, HttpServletRequest request,			
			@RequestParam(value = "searchDate", required = false) String searchDate,//기간			
			@RequestParam(value = "tabMenuVal", required = false) String tabMenuVal,//상단 탭 별 타입 			
			@RequestParam(value = "cityId", required = false) String cityId		//도시
			) {
	  HttpSession session = request.getSession();
	  String local = locale.toLanguageTag();
		
	  DashboardDomain dashboardDomain = new DashboardDomain();
	  String userId = (String) session.getAttribute(USERID);
	  String email = (String) session.getAttribute(SESSIONEMAIL);
	 
		
	  dashboardDomain.setUserId(userId);
	  dashboardDomain.setEmail(email);
	  dashboardDomain.setMenuType("vi");
	  
	  dashboardDomain.setLanguage(local);
	 
	  HashMap<String, Object> paramData = new HashMap<>();	
	  paramData.put(LANGUAGE, locale.getLanguage()); 
	  paramData.put(SEARCHDATE, searchDate);
	  paramData.put(CITYID, cityId);
	  
	  //회원수
	  paramData.put(STCTYPE, USER);
	  dashboardDomain.setUserCnt(dashboardService.getDocumentTypeCount(paramData));
	  
	  
	  //테스트응시 
	  paramData.put(SKILLSTCCODE, TOTAL);
	  dashboardDomain.setSkillStcTotalCnt(dashboardService.getSkillTestCount(paramData));
	  
	  //테스트통과
	  paramData.put(SKILLSTCCODE, PASS);
	  dashboardDomain.setSkillStcPassCnt(dashboardService.getSkillTestCount(paramData));
	  
	  //이력서
	  paramData.put(STCTYPE, RESUME);
	  dashboardDomain.setResumeCnt(dashboardService.getDocumentTypeCount(paramData));
	  
	  //포토폴리오
	  paramData.put(STCTYPE, PORTFOLIO);
	  dashboardDomain.setPortfolioCnt(dashboardService.getDocumentTypeCount(paramData));
	  
	  
	  //차트영역 조회
	  if(tabMenuVal.equals("M")) {		//user
		  paramData.put(STCTYPE, USER);	  
		  
		  //성별조회
		  paramData.put(MAJOR, "03");	 
		  dashboardDomain.setSexDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //연령 조회
		  paramData.put(MAJOR, "22");
		  dashboardDomain.setAgeDateList(dashboardService.getStcCodeMemberList(paramData));
		
		  
		  //학력조회
		  paramData.put(MAJOR, "04");	  
		  dashboardDomain.setEducationDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //경력 조회
		  paramData.put(MAJOR, "06");	 	  
		  dashboardDomain.setTaskDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //직업 현황 조회 
		  paramData.put(MAJOR, JOBCODE);	 
		  dashboardDomain.setJobDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //도시별 카운트 조회
		  dashboardDomain.setCityDateList(dashboardService.getCityUserList(paramData));
		  
	  }else if(tabMenuVal.equals("T")) {	//TOTAL
		  paramData.put(SKILLSTCCODE, TOTAL);
		  
		  //성별조회 
		  paramData.put(MAJOR, "03");	 
		  dashboardDomain.setSexDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //연령 조회 
		  paramData.put(MAJOR, "22");
		  dashboardDomain.setAgeDateList(dashboardService.getStcCodeSkillList(paramData));
		
		  
		  //학력조회 
		  paramData.put(MAJOR, "04");	  
		  dashboardDomain.setEducationDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //경력 조회 
		  paramData.put(MAJOR, "06");	 	  
		  dashboardDomain.setTaskDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //직업 현황 조회 
		  paramData.put(MAJOR, JOBCODE);	 
		  dashboardDomain.setJobDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //도시별 카운트 조회
		  dashboardDomain.setCityDateList(dashboardService.getCitySkillList(paramData));
	  }else if(tabMenuVal.equals("A")) {	//PASS
		  paramData.put(SKILLSTCCODE, PASS);	 
		  
		  //성별조회
		  paramData.put(MAJOR, "03");	 
		  dashboardDomain.setSexDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //연령 조회
		  paramData.put(MAJOR, "22");
		  dashboardDomain.setAgeDateList(dashboardService.getStcCodeSkillList(paramData));
		
		  
		  //학력조회 
		  paramData.put(MAJOR, "04");	  
		  dashboardDomain.setEducationDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //경력 조회 
		  paramData.put(MAJOR, "06");	 	  
		  dashboardDomain.setTaskDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //직업 현황 조회 
		  paramData.put(MAJOR, JOBCODE);	 
		  dashboardDomain.setJobDateList(dashboardService.getStcCodeSkillList(paramData));
		  
		  //도시별 카운트 조회
		  dashboardDomain.setCityDateList(dashboardService.getCitySkillList(paramData));
	  }else if(tabMenuVal.equals("R")) {	//RESUME
		  paramData.put(STCTYPE, RESUME);	  
		  
		  //성별조회  
		  paramData.put(MAJOR, "03");	 
		  dashboardDomain.setSexDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //연령 조회 
		  paramData.put(MAJOR, "22");
		  dashboardDomain.setAgeDateList(dashboardService.getStcCodeMemberList(paramData));
		
		  
		  //학력조회 
		  paramData.put(MAJOR, "04");	  
		  dashboardDomain.setEducationDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //경력 조회 
		  paramData.put(MAJOR, "06");	 	  
		  dashboardDomain.setTaskDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //직업 현황 조회 
		  paramData.put(MAJOR, JOBCODE);	 
		  dashboardDomain.setJobDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //도시별 카운트 조회
		  dashboardDomain.setCityDateList(dashboardService.getCityUserList(paramData));
	  }else if(tabMenuVal.equals("P")) {	//PORTFOLIO
		  paramData.put(STCTYPE, PORTFOLIO);	  
		  
		  //성별조회 
		  paramData.put(MAJOR, "03");	 
		  dashboardDomain.setSexDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //연령 조회
		  paramData.put(MAJOR, "22");
		  dashboardDomain.setAgeDateList(dashboardService.getStcCodeMemberList(paramData));
		
		  
		  //학력조회 
		  paramData.put(MAJOR, "04");	  
		  dashboardDomain.setEducationDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //경력 조회
		  paramData.put(MAJOR, "06");	 	  
		  dashboardDomain.setTaskDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //직업 현황 조회 
		  paramData.put(MAJOR, JOBCODE);	 
		  dashboardDomain.setJobDateList(dashboardService.getStcCodeMemberList(paramData));
		  
		  //도시별 카운트 조회
		  dashboardDomain.setCityDateList(dashboardService.getCityUserList(paramData));
	  }
	  
      return new BaseResponse<>(dashboardDomain);      
	}
	
	
	/**
	 * 설문참여 응답화면  View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardSurveyView")	
	@ApiOperation(value = "설문참여 응답화면  View")
	public String dashboardSurveyView() {
		return "dashboard/dashboardSurvey";
	}
	
	/**
	 * 설문참여 응답화면조회
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/dashboardSurveyList")
	@ResponseBody
	@ApiOperation(value = "설문참여 응답화면조회")
	public BaseResponse<DashboardDomain> dashboardSurveyList(Locale locale, HttpServletRequest request){	
		HttpSession session = request.getSession();		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		DashboardDomain dashboardDomain = new DashboardDomain();
		dashboardDomain.setUserId(userId);
		dashboardDomain.setEmail(email);
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put(LANGUAGE, locale.getLanguage()); 
		paramData.put(SEARCHDATE, "0");	
		  
		List<DashboardDomain> resultList = dashboardService.getIctResultList( paramData);
		dashboardDomain.setResultList(resultList);
        dashboardDomain.setMenuType("en");
        
        return new BaseResponse<>(dashboardDomain);
	}
	
	/**
	 * 설문참여 응답 상세화면  View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardSurveyDetailView")
	@ApiOperation(value = "설문참여 응답 상세화면  View")
	public String dashboardSurveyDetailView(Locale locale, Model model, HttpServletRequest request,	
			@RequestParam("questionId") String questionId,
			@RequestParam(value = "searchDate", required = false) String searchDate,//기간			
			@RequestParam(value = "tabMenuVal", required = false) String tabMenuVal,//상단 탭 별 타입 			
			@RequestParam(value = "cityId", required = false) String cityId		//도시
			){	
		return "dashboard/dashboardSurveyDetail";
	}
	
	/**
	 * 설문참여 응답 상세화면  조회
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/dashboardSurveyDetailViewList")
	@ResponseBody
	@ApiOperation(value = "설문참여 응답 상세 조회")
	public BaseResponse<DashboardDomain> dashboardSurveyDetailViewList(Locale locale, Model model, HttpServletRequest request,	
			@RequestParam("questionId") String questionId,
			@RequestParam(value = "searchDate", required = false) String searchDate,//기간			
			@RequestParam(value = "tabMenuVal", required = false) String tabMenuVal,//상단 탭 별 타입 			
			@RequestParam(value = "cityId", required = false) String cityId		//도시
			){	
		DashboardDomain dashboardDomain = new DashboardDomain();		

		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put(LANGUAGE, locale.getLanguage()); 
		paramData.put(SEARCHDATE, "0");	
		
		//설문문항 답변 조회 
		List<DashboardDomain> resultList = dashboardService.getIctResultList(paramData);
		dashboardDomain.setResultList(resultList);
		
		return new BaseResponse<>(dashboardDomain);   
	}
	
	
	/**
	 * 설문참여 응답 상세화면 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/dashboardSurveyDetailList")
	@ResponseBody
	@ApiOperation(value = "설문참여 응답 상세화면  조회")
	public BaseResponse<DashboardDomain>  dashboardSurveyDetailList(Locale locale, HttpServletRequest request,			
			@RequestParam("questionId") String questionId,
			@RequestParam(value = "exampleId", required = false) String exampleId,	
			@RequestParam(value = "searchDate", required = false) String searchDate,//기간
			@RequestParam(value = "cityId", required = false) String cityId		//도시
			) {
	  HttpSession session = request.getSession();
		
	  DashboardDomain dashboardDomain = new DashboardDomain();
	  String userId = (String) session.getAttribute(USERID);
	  String email = (String) session.getAttribute(SESSIONEMAIL);
	  
	  dashboardDomain.setUserId(userId);
	  dashboardDomain.setEmail(email);
	  
	  String local = locale.toLanguageTag();
	  dashboardDomain.setLanguage(local);
	  
	  HashMap<String, Object> paramData = new HashMap<>();	
	  paramData.put(LANGUAGE, locale.getLanguage()); 
	  paramData.put("questionId", questionId);
	  paramData.put("exampleId", exampleId);
	  paramData.put(CITYID, cityId); 
	  paramData.put(SEARCHDATE, searchDate);	
	  
	  
	  //설문문항 답변 조회 
	  dashboardDomain.setResultList(dashboardService.getIctResultList(paramData));
	    
	  
	  //성별조회
	  paramData.put(MAJOR, "03");	 
	  dashboardDomain.setSexDateList(dashboardService.getSurveyCodeList(paramData));
	  
	  //연령 조회
	  paramData.put(MAJOR, "22");
	  dashboardDomain.setAgeDateList(dashboardService.getSurveyCodeList(paramData));
	
	  
	  //학력조회
	  paramData.put(MAJOR, "04");	  
	  dashboardDomain.setEducationDateList(dashboardService.getSurveyCodeList(paramData));
	  
	  //경력 조회
	  paramData.put(MAJOR, "06");	 	  
	  dashboardDomain.setTaskDateList(dashboardService.getSurveyCodeList(paramData));
	  
	  //직업 현황 조회 
	  paramData.put(MAJOR, JOBCODE);	 
	  dashboardDomain.setJobDateList(dashboardService.getSurveyCodeList(paramData));
	  
	  //도시별 카운트 조회
	  dashboardDomain.setCityDateList(dashboardService.getSurveyCityIdList(paramData));
	  
	  dashboardDomain.setMenuType("en");
	  
      return new BaseResponse<>(dashboardDomain);      
	}
	
	
	
	/**
	 * 대시보드 스킬 View 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardSkillsView")
	@ApiOperation(value = "대시보드 스킬 View ")
	public String dashboardSkillsView(Locale locale, Model model, HttpServletRequest request){	    
		return "dashboard/dashboardSkills";
	}
	
	@ResponseBody
	@PostMapping("/dashboardSkillsList")
	@ApiOperation(value = "대시보드 스킬 조회 ")
	public BaseResponse<DashboardDomain> dashboardSkillsList(Locale locale , HttpServletRequest request){	
		HttpSession session = request.getSession();		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		DashboardDomain dashboardDomain = new DashboardDomain();
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put(LANGUAGE, locale.getLanguage()); 		
		List<DashboardDomain> skillReportList = dashboardService.getSkillReportList(paramData);		
		
		dashboardDomain.setSkillReportList(skillReportList);
		dashboardDomain.setUserId(userId);
		dashboardDomain.setEmail(email);
		dashboardDomain.setMenuType("pr");

        return new BaseResponse<>(dashboardDomain);
	}
	
	/**
	 * 대시보드 스킬 View 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardSkillsDetailView")	
	@ApiOperation(value = "대시보드 스킬 화면 ")
	public String dashboardSkillsDetail(Locale locale, Model model, HttpServletRequest request,
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode) {	
		return "dashboard/dashboardSkillsDetail";
	}
	
	/**
	 * 대시보드 스킬 상세 조회
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/dashboardSkillsDetailViewList")	    
	@ResponseBody
	@ApiOperation(value = "대시보드 스킬 상세 조회")
	public BaseResponse<DashboardDomain> dashboardSkillsDetailViewList(Locale locale, Model model, HttpServletRequest request,
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode) {	
		HttpSession session = request.getSession();		
		String email = (String) session.getAttribute(SESSIONEMAIL);
		String userId = (String) session.getAttribute(USERID);
		
		DashboardDomain dashboardDomain = new DashboardDomain();
		
		HashMap<String, Object> paramData = new HashMap<>();	
		paramData.put(LANGUAGE, locale.getLanguage()); 		
		List<DashboardDomain> skillReportList = dashboardService.getSkillReportList(paramData);
		
        dashboardDomain.setSkillReportList(skillReportList);
        dashboardDomain.setUserId(userId);
        dashboardDomain.setEmail(email);
        dashboardDomain.setMenuType("pr");
        
        dashboardDomain.setSkillCode(skillCode);
        dashboardDomain.setExamClassCode(examClassCode);
        
        return new BaseResponse<>(dashboardDomain);
	}
	
	
	/**
	 * 설문참여 응답 상세화면 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/dashboardSkillsDetailList")
	@ResponseBody
	@ApiOperation(value = "설문참여 응답 상세화면 데이터 조회 ")
	public BaseResponse<DashboardDomain>  dashboardSkillsDetailList(Locale locale, HttpServletRequest request,			
			@RequestParam("skillCode") String skillCode,
			@RequestParam("examClassCode") String examClassCode,
			@RequestParam(value = "tabMenuVal", required = false) String tabMenuVal,
			@RequestParam(value = "searchDate", required = false) String searchDate,//기간
			@RequestParam(value = "cityId", required = false) String cityId		//도시
			){
	  HttpSession session = request.getSession();
		
	  DashboardDomain dashboardDomain = new DashboardDomain();
	  String userId = (String) session.getAttribute(USERID);
	  String email = (String) session.getAttribute(SESSIONEMAIL);
	  
	  dashboardDomain.setUserId(userId);
      dashboardDomain.setEmail(email);
      dashboardDomain.setMenuType("pr");
      
      String local = locale.toLanguageTag();
	  dashboardDomain.setLanguage(local);
	  
	  HashMap<String, Object> paramData = new HashMap<>();	
	  paramData.put(LANGUAGE, locale.getLanguage()); 
	  paramData.put(SEARCHDATE, searchDate);
	  paramData.put(CITYID, cityId);
	  paramData.put(SKILLCODE, skillCode);
	  paramData.put("examClassCode", examClassCode);
	  
	  	  
	  
	  //스킬 전체 
	  paramData.put(SKILLSTCCODE, TOTAL);
	  dashboardDomain.setTotalCnt(dashboardService.getStcSkillCodeUserCount(paramData));
	  
	  //자기평가
	  paramData.put(SKILLSTCCODE, SELF);
	  dashboardDomain.setSelfCnt(dashboardService.getStcSkillCodeUserCount(paramData));
	  
	  //기술테스트
	  paramData.put(SKILLSTCCODE, SKILL);
	  dashboardDomain.setSkillCnt(dashboardService.getStcSkillCodeUserCount(paramData));
	  
	  //테스트통과
	  paramData.put(SKILLSTCCODE, PASS);
	  dashboardDomain.setPassCnt(dashboardService.getStcSkillCodeUserCount(paramData));
	  
	  
	  //차트영역 조회
	  if(tabMenuVal.equals("T")) {		
		  paramData.put(SKILLSTCCODE, TOTAL); 
	  }else if(tabMenuVal.equals("S")) {	
		  paramData.put(SKILLSTCCODE, SELF);
		  
	  }else if(tabMenuVal.equals("B")) {	
		  paramData.put(SKILLSTCCODE, SKILL);
		  
	  }else if(tabMenuVal.equals("A")) {
		  paramData.put(SKILLSTCCODE, PASS);		 
	  }
	  
	  //성별조회  
	  paramData.put(MAJOR, "03");	 
	  dashboardDomain.setSexDateList(dashboardService.getStcSkillCodeUserList(paramData));
	  
	  //연령 조회 
	  paramData.put(MAJOR, "22");
	  dashboardDomain.setAgeDateList(dashboardService.getStcSkillCodeUserList(paramData));
	
	  
	  //학력조회 
	  paramData.put(MAJOR, "04");	  
	  dashboardDomain.setEducationDateList(dashboardService.getStcSkillCodeUserList(paramData));
	  
	  //경력 조회 
	  paramData.put(MAJOR, "06");	 	  
	  dashboardDomain.setTaskDateList(dashboardService.getStcSkillCodeUserList(paramData));
	  
	  //직업 현황 조회 
	  paramData.put(MAJOR, JOBCODE);	 
	  dashboardDomain.setJobDateList(dashboardService.getStcSkillCodeUserList(paramData));
	  
	  //도시별 카운트 조회
	  dashboardDomain.setCityDateList(dashboardService.getCitySkillList(paramData));
	  
      return new BaseResponse<>(dashboardDomain);      
	}
	
	
	
	/**
	 * 대시보드 랭킹 View 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/dashboardRankingView")
	@ApiOperation(value = "대시보드 랭킹 View ")
	public String dashboardRankingView(){		
		return "dashboard/dashboardRanking";
	}
	
	/**
	 * 대시보드 랭킹 조회 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/dashboardRankingList")
	@ResponseBody
	@ApiOperation(value = "대시보드 랭킹 조회 ")
	public BaseResponse<DashboardDomain> dashboardRankingList(Locale locale,HttpServletRequest request){
		DashboardDomain dashboardDomain = new DashboardDomain();
				
		//스킬 		
		List<DashboardDomain> skillRankingList = null;
		skillRankingList = dashboardService.getRankingList(locale, SKILL);
		if(skillRankingList.size() == 0) {
			skillRankingList = dashboardService.getRankingList02(locale, SKILL);
		}
		dashboardDomain.setSkillRankingList(skillRankingList);
		
		//프로그래밍
		List<DashboardDomain> programRankingList = null;
		programRankingList = dashboardService.getRankingList(locale, "PROGRAM");
		if(programRankingList.size() == 0) {
			programRankingList = dashboardService.getRankingList02(locale, "PROGRAM");
		}
		dashboardDomain.setProgramRankingList(programRankingList);
		
		//언어 
		List<DashboardDomain> langRankingList = null;
		langRankingList = dashboardService.getRankingList(locale, "LANG");
		if(langRankingList.size() == 0) {
			langRankingList = dashboardService.getRankingList02(locale, "LANG");
		}
		dashboardDomain.setLangRankingList(langRankingList);
		
		//포토폴리오
		List<DashboardDomain> portfolioRankingList = null;
		portfolioRankingList = dashboardService.getRankingList(locale, PORTFOLIO);
		if(portfolioRankingList.size() == 0) {
			portfolioRankingList = dashboardService.getRankingList02(locale, PORTFOLIO);
		}
		dashboardDomain.setPortfolioRankingList(portfolioRankingList);
		
		dashboardDomain.setMenuType("ra");
		
		return new BaseResponse<>(dashboardDomain);  
	}
	
	
}
