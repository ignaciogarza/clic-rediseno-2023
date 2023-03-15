package com.iscreammedia.clic.front.controller;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.LocaleResolver;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.BadgeDomain;
import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.ProjectDomain;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.service.NoticeService;
import com.iscreammedia.clic.front.service.PortfolioService;
import com.iscreammedia.clic.front.service.ProjectService;
import com.iscreammedia.clic.front.service.UserService;
import com.iscreammedia.clic.front.util.CommonUtil;
import com.microsoft.azure.storage.StorageException;

import io.swagger.annotations.ApiOperation;

@Controller
@RequestMapping("/studio/project")
public class ProjectController {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private PortfolioService portfolioService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private NoticeService noticeService;
	
	@Autowired 
	private LocaleResolver localeResolver;
	
	@Autowired
	private CommonUtil commonUtil;	
	
	
	@Value("${resource.upload.path}")
	private String resourceUploadPath;
	
	@Value("${SecretKey}")
	private String secretKey;
	
	@Value("${azure.blob.storage.url}")
	private String azureStorageUrl;
	
	
	private static final String USERID = "userId";
	private static final String PORTFOLIOID = "portfolioId";
	private static final String SUCCESS = "success";
	private static final String IMAGPATH = "imagPath";
	private static final String PROJECTID = "projectId";
	private static final String PROJECTCONTENTSID = "projectContentsId";
	private static final String CONTENTSPATH = "contentsPath";
	private static final String CONTENTSURL = "contentsUrl";
	private static final String CONTENTSNAME = "contentsName";
	private static final String OTHERS = "others";
	private static final String OUT = "out";
	
	private static final String LOGINURL = "login/login";
	
	
	/**
	 * 프로젝트 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/projectListForm")
	@ApiOperation(value = "프로젝트 View")
	public String projectListForm(Locale locale, Model model, HttpServletRequest request,
			@RequestParam("portfolioId") String portfolioId){	
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		 
		HashMap<String, String> param = new HashMap<>();
		param.put(USERID, userId);
		param.put(PORTFOLIOID, portfolioId);
	      
	    portfolioService.insertPortfolioVisitHistory(param);
		
	    return "portfolio/portfolioProjectList";
	}
	
	
	/**
	 * 프로젝트 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/projectList")
	@ResponseBody
	@ApiOperation(value = "프로젝트 데이터 조회")
	public BaseResponse<List<ProjectDomain>>  portfolioList(HttpServletRequest request, @RequestParam("portfolioId") String portfolioId, Locale locale) {
	  String local = locale.toLanguageTag();
      List<ProjectDomain> projectList = projectService.getProjectList(portfolioId, local);
      return new BaseResponse<>(projectList);      
	} 
	
	
	/**
	 * 프로젝트 상세 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getProjectDetail")
	@ResponseBody
	@ApiOperation(value = "프로젝트 상세 데이터 조회")
	public BaseResponse<ProjectDomain>  getProjectDetailInfo(@RequestParam("projectId") String projectId){						
      //프로젝트 데이터 조회 	  
	  ProjectDomain projectInfo = projectService.getProjectDetailInfo(projectId);
      return new BaseResponse<>(projectInfo);      
	} 
	
	
	
	/**
	 * 프로젝트 등록 
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/saveProject")
	@ResponseBody
	@ApiOperation(value = "프로젝트 등록")
	public BaseResponse<Boolean> saveProject(
			HttpServletRequest request, 
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("projectName") String projectName, 
			@RequestParam("projectIntroduction") String projectIntroduction,
			@RequestParam("projectFile") MultipartFile[] uploadfiles) throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		Boolean result;
		
			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute(USERID);
			
			//프로젝트 카운트수
			HashMap<String, String> countData = new HashMap<>();
			countData.put(USERID, userId);
			countData.put(PORTFOLIOID, portfolioId);
			
			int projectCount = Integer.parseInt(portfolioService.getProjectCount(countData));		
			if(projectCount > 50) {
				//50개 이상 등록시 등록 못하게 처리 
				result = false;
			}else {
				//프로젝트 저장 
				HashMap<String, String> projectData = new HashMap<>();
				
				for (MultipartFile file : Arrays.asList(uploadfiles)) {
					String original = userId+System.currentTimeMillis()+file.getOriginalFilename();
					//Azure Blob storage 업로드
					String azureResult = commonUtil.azureFileUtil(file, original);
					 
					 if(azureResult.equals(SUCCESS)) {
						 String fileName = file.getOriginalFilename();
						 if(!fileName.equals("") ) {							
							 projectData.put(IMAGPATH, azureStorageUrl+original);
							
						 }else {
							 projectData.put(IMAGPATH, null);
						 }	 
					 }					     
				}				
				
				projectData.put(PORTFOLIOID, portfolioId);
				projectData.put("name", projectName);
				projectData.put("introduction", projectIntroduction);
				//저장 로직 작업 필요
				projectService.insertProject(projectData);
				
				//포토폴리오 프로젝트 카운트 증가 수정 
				HashMap<String, String> paramData = new HashMap<>();
				paramData.put(USERID, userId);
				paramData.put(PORTFOLIOID, portfolioId); 
				paramData.put("type","Y");
				portfolioService.updateProjectCount(paramData);
				
				result = true;
			}	
			
		
		return new BaseResponse<>(result);
	}
	
	
	
	/**
	 * 프로젝트 수정   
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/modifyProject")
	@ResponseBody
	@ApiOperation(value = "프로젝트 수정")
	public BaseResponse<Integer> modifyProject(
			HttpServletRequest request, 
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("projectName") String projectName, 
			@RequestParam("projectIntroduction") String projectIntroduction,
			@RequestParam("projectId") String projectId, 
			@RequestParam("projectFileUrl") String projectFileUrl, 			
			@RequestParam("projectFile") MultipartFile[] uploadfiles) throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		
		
			HttpSession session = request.getSession();
			String userId = (String) session.getAttribute(USERID);
			
			//프로젝트 저장 
			HashMap<String, String> projectData = new HashMap<>();
			
			//파일 업로드 및 경로 데이터 세팅 			
			for (MultipartFile file : Arrays.asList(uploadfiles)) {
				String original = userId+System.currentTimeMillis()+file.getOriginalFilename();
				//Azure Blob storage 업로드
				String azureResult = commonUtil.azureFileUtil(file, original);
				 
				 if(azureResult.equals(SUCCESS)) {
					 String fileName = file.getOriginalFilename();
					 if(!fileName.equals("") ) {
						 projectData.put(IMAGPATH, azureStorageUrl+original);
					 }else {
						 projectData.put(IMAGPATH, projectFileUrl);
					 }	 
				 }  
			}			
			
			projectData.put(PROJECTID, projectId);
			projectData.put("name", projectName);
			projectData.put("introduction", projectIntroduction);		
			projectService.updateProject(projectData);			
			
		
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 프로젝트 삭제  
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/delProject")
	@ResponseBody
	@ApiOperation(value = "프로젝트 삭제")
	public BaseResponse<Integer> delProject(
			@RequestParam("userId") String userId, 
			@RequestParam("projectId") String projectId,
			@RequestParam("portfolioId") String portfolioId){
		
		
			//프로젝트 삭제 
			HashMap<String, String> projectData = new HashMap<>();
			projectData.put(USERID, userId);
			projectData.put(PROJECTID, projectId);
			//portfolioId 로 프로젝트 테이블 삭제 처리 
			projectService.delProject(projectData);			
			
			//프로젝트 컨텐츠 테이블 삭제 처리 
			HashMap<String, String> paramContent = new HashMap<>();
			paramContent.put(USERID, userId);
			paramContent.put(PROJECTID, projectId); 	
			projectService.delProjectContents(paramContent);			
			
			//포토폴리오 프로젝트 카운트 증가 수정 
			HashMap<String, String> paramData = new HashMap<>();
			paramData.put(USERID, userId);
			paramData.put(PORTFOLIOID, portfolioId);
			paramData.put("type","N");
			portfolioService.updateProjectCount(paramData);			
		
		return new BaseResponse<>(1);
	}
	
	/**
	 * 프로젝트 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/projectForm")
	@ApiOperation(value = "프로젝트 View")
	public String projectForm(Locale locale,Model model, HttpServletRequest request,
			@RequestParam("portfolioId") String portfolioId, 
			@RequestParam("projectId") String projectId) {			
		return "portfolio/portfolioProjectForm";
	}
	
	
	/**
	 * 프로젝트 컨텐츠 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/projectContentsList")
	@ResponseBody
	@ApiOperation(value = "프로젝트 컨텐츠 데이터 조회")
	public BaseResponse<ProjectDomain>  projectContentsList(Locale locale,
			HttpServletRequest request,
			@RequestParam(value = "userId", required = false) String userId,
			@RequestParam("projectId") String projectId) {
		
	  HttpSession session = request.getSession();
	  if(userId == null) {			
		userId = (String) session.getAttribute(USERID);
	  }	
	  
      String local = locale.toLanguageTag();
	  
	  ProjectDomain projectDomain = new ProjectDomain();
		
	  HashMap<String, String> countData = new HashMap<>();
	  countData.put(USERID, userId);
	  countData.put(PROJECTID, projectId);
	  countData.put(local, local);
      List<ProjectDomain> projectList = projectService.getProjectContentsList(countData);
      projectDomain.setProjectList(projectList);
      
      List<CommonDomain> contentList = userService.getCodeTypeList(locale,"19");
      projectDomain.setContentList(contentList);
      
      return new BaseResponse<>(projectDomain);      
	} 
	
	/**
	 * 프로젝트 컨텐츠 상세 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getProjectContentsDetail")
	@ResponseBody
	@ApiOperation(value = "프로젝트 컨텐츠 상세데이터 조회")
	public BaseResponse<ProjectDomain>  getProjectContentsInfo(
			HttpServletRequest request,
			@RequestParam(value = "userId", required = false) String userId,
			@RequestParam("projectId") String projectId,
			@RequestParam("projectContentsId") String projectContentsId){
		
	  HttpSession session = request.getSession();
	  if(userId == null) {			
		userId = (String) session.getAttribute(USERID);
	  }		
						
      //포토폴리오 데이터 조회 	
	  HashMap<String, String> countData = new HashMap<>();
	  countData.put(USERID, userId);
	  countData.put(PROJECTID, projectId);
	  countData.put(PROJECTCONTENTSID, projectContentsId);
	  
	  ProjectDomain portfolioInfo = projectService.getProjectContentsInfo(countData);
      return new BaseResponse<>(portfolioInfo);      
	} 
	
	
	/**
	 * 프로젝트 컨텐츠 등록 
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/saveProjectContents")
	@ResponseBody
	@ApiOperation(value = "프로젝트 컨텐츠 등록")
	public BaseResponse<Integer> saveProjectContents( 
			HttpServletRequest request, 
			@RequestParam("projectId") String projectId,			
			@RequestParam(value="contentsTypeCode", required=false) String contentsTypeCode,
			@RequestParam(value="contentsName", required=false) String contentsName,
			@RequestParam(value="contentsUrl", required=false) String contentsUrl,	
			@RequestParam(value="contentFile", required=false) MultipartFile[] uploadfiles,
			@RequestParam(value="chk_arr", required=false) String[] chkArr,
			@RequestParam(value="chk_path", required=false) String[] chkPath,
			@RequestParam(value="chk_name", required=false) String[] chkName) 
					throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		
			//프로젝트 컨텐츠 저장
			HashMap<String, String> countData = new HashMap<>();			
			
			for (MultipartFile file : Arrays.asList(uploadfiles)) {
				String original = userId+System.currentTimeMillis()+file.getOriginalFilename();
				//Azure Blob storage 업로드
				String azureResult = commonUtil.azureFileUtil(file, original);
				 
				 if(azureResult.equals(SUCCESS)) {
					 String fileName = file.getOriginalFilename();
					 if(!fileName.equals("") ) {
						 countData.put(CONTENTSPATH, azureStorageUrl+original);
			         
					 }else {
						 countData.put(CONTENTSPATH, null);
					 }
				 }     
			}			
			
			countData.put(USERID, userId);
			countData.put(PROJECTID, projectId);
			countData.put("contentsTypeCode", contentsTypeCode);
			
			
			if(!contentsUrl.equals("")) {
				countData.put(CONTENTSURL, contentsUrl);
			}else {
				countData.put(CONTENTSURL, null);
			}
			
			if(chkArr.length != 0) {
				//뱃지 삭제 
				projectService.badgeDelete(countData);
				for(int i = 0; i<chkArr.length; i++) {					
					countData.put("skillCode", chkArr[i]);
					countData.put(CONTENTSPATH, chkPath[i]);					
					countData.put(CONTENTSNAME, chkName[i]);
					projectService.insertProjectContents(countData);
				}
			}else {
				countData.put(CONTENTSNAME, contentsName);
				projectService.insertProjectContents(countData);
			}			
		
		return new BaseResponse<>(1);
	}
	
	/**
	 * 프로젝트 컨텐츠 수정
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/updateProjectContents")
	@ResponseBody
	@ApiOperation(value = "프로젝트 컨텐츠 수정")
	public BaseResponse<Integer> updateProjectContents(HttpServletRequest request,
			@RequestParam("projectContentsId") String projectContentsId, 
			@RequestParam(value="contentsName", required=false) String contentsName,
			@RequestParam(value="contentsUrl", required=false) String contentsUrl,	
			@RequestParam(value="contentFile", required=false) MultipartFile[] uploadfiles) 
					throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		
		
			HttpSession session = request.getSession();
						
			String userId = (String) session.getAttribute(USERID);
			
			//프로젝트 컨텐츠 저장
			HashMap<String, String> countData = new HashMap<>();
			
			if(uploadfiles != null) {
				for (MultipartFile file : Arrays.asList(uploadfiles)) {					  
					String original = userId+System.currentTimeMillis()+file.getOriginalFilename();
					//Azure Blob storage 업로드
					String azureResult = commonUtil.azureFileUtil(file, original);
					 
					 if(azureResult.equals(SUCCESS)) {
						 String fileName = file.getOriginalFilename();
						 if(!fileName.equals("") ) {
							 countData.put(CONTENTSPATH, azureStorageUrl+original);
				         
						 }else {
							 countData.put(CONTENTSPATH, null);
						 }
					 }   
				}
			}else {
				countData.put(CONTENTSPATH, null);
			}
			
			
			if(!contentsUrl.equals("")) {
				countData.put(CONTENTSURL, contentsUrl);
			}else {
				countData.put(CONTENTSURL, null);
			}
			
			countData.put(PROJECTCONTENTSID, projectContentsId);
			countData.put(CONTENTSNAME, contentsName);
			projectService.updateProjectContents(countData);
		
		return new BaseResponse<>(1);
	}
	
	/**
	 * 프로젝트 삭제  
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/delProjectContents")
	@ResponseBody
	@ApiOperation(value = "프로젝트 컨텐츠 삭제")
	public BaseResponse<Integer> delProjectContents(
			@RequestParam("userId") String userId, 
			@RequestParam("projectContentsId") String projectContentsId){
		
			//프로젝트 컨텐츠 테이블 삭제 처리 
			HashMap<String, String> paramContent = new HashMap<>();
			paramContent.put(USERID, userId);
			paramContent.put(PROJECTCONTENTSID, projectContentsId); 	
			projectService.delProjectContents(paramContent);
		
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 프로젝트 컨텐츠 이미지 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/projectContentsImageFrom")
	@ApiOperation(value = "프로젝트 컨텐츠 이미지 View")
	public String projectContentsImageFrom(
			Model model, 
			HttpServletRequest request, 
			@RequestParam("projectId") String projectId){
		return "portfolio/portfolioProjectImageView";
	}
	
	/**
	 * 프로젝트 컨텐츠 이미지 조회
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/projectContentsImageList")
	@ResponseBody
	@ApiOperation(value = "프로젝트 컨텐츠 이미지 조회")
	public BaseResponse<ProjectDomain> projectContentsImageList(
			HttpServletRequest request,
			@RequestParam(value = "otherUserId", required = false) String otherUserId,
			@RequestParam("projectId") String projectId){	
		
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		if(userId == null) {
					
				userId = otherUserId;
			
		}
		
		if(!otherUserId.equals("")) {
			userId = otherUserId;
		}
		
		ProjectDomain projectDomain = new ProjectDomain();
		
		HashMap<String, String> paramContent = new HashMap<>();
		paramContent.put(USERID, userId);
		paramContent.put(PROJECTID, projectId);
		List<ProjectDomain> contentsImageList = projectService.getContentsImageList(paramContent);
		projectDomain.setContentsImageList(contentsImageList);
		
		return new BaseResponse<>(projectDomain);    
	}
	
	/**
	 * 컨텐츠 이미지 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/contentsImageList")
	@ResponseBody
	@ApiOperation(value = "컨텐츠 이미지 조회")
	public BaseResponse<List<ProjectDomain>>  getContentsImageList(@RequestParam("userId") String userId) {
	  HashMap<String, String> paramContent = new HashMap<>();
	  paramContent.put(USERID, userId);
	  List<ProjectDomain> projectList = projectService.getContentsImageList(paramContent);
      return new BaseResponse<>(projectList);      
	} 
	
	
	/**
	 * 뱃지 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getBadgeList")
	@ResponseBody
	@ApiOperation(value = "뱃지 조회")
	public BaseResponse<List<BadgeDomain>>  getBadgeList(Locale locale,HttpServletRequest request){	
	  HttpSession session = request.getSession();
	  String userId = (String) session.getAttribute(USERID);		
      List<BadgeDomain> badgeList = projectService.getBadgeList(locale,userId);
      return new BaseResponse<>(badgeList);      
	} 
	
	
	
	/**
	 * 포토폴리오 프로젝트 다른회원 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/portfolioOthersMemberView")
	@ApiOperation(value = "포토폴리오 프로젝트 다른회원 View")
	public String portfolioOthersMemberView(Model model, HttpServletRequest request,
			@RequestParam("otherUserId") String otherUserId, 
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("otherEmail") String otherEmail, 
			@RequestParam("type") String type	){	
		
		HashMap<String, String> param = new HashMap<>();
		param.put(USERID, otherUserId);
		param.put(PORTFOLIOID, portfolioId);
	      
	    portfolioService.insertPortfolioVisitHistory(param);
				
		String pageView = null;
		if(type.equals(OTHERS)) {
			pageView =  "portfolio/portfolioOthersMemberView";
		}else if(type.equals(OUT)) {
			pageView = "portfolio/portfolioOutView";
		}
		
		return pageView;
	}
	
	/**
	 * 포토폴리오 프로젝트 다른회원 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/portfolioOthersMemberList")
	@ApiOperation(value = "포토폴리오 프로젝트 다른회원 View")
	public BaseResponse<ProjectDomain> portfolioOthersMemberList(
			HttpServletRequest request,
			@RequestParam("otherUserId") String otherUserId, 
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("otherEmail") String otherEmail, 
			@RequestParam("type") String type,
			Locale locale) {	
		
		ProjectDomain projectDomain = new ProjectDomain();
		String local = locale.toLanguageTag();
		
		//다른 회원정보 조회 
		UserDomain userDetail = userService.getUserDetail(otherEmail);
		userDetail.setLanguage(local);
		projectDomain.setUserDetail(userDetail);
		
		//포토폴리오 정보 조회 		
		HashMap<String, String> paramData = new HashMap<>();
		paramData.put(USERID, otherUserId);
		paramData.put(PORTFOLIOID, portfolioId); 	
		PortfolioDomain  portfolioInfo = portfolioService.getPortfolioDetailInfo(paramData);
		projectDomain.setPortfolioInfo(portfolioInfo);
				
		
		
		//프로젝트 정보 조회 		
		List<ProjectDomain> projectList = projectService.getProjectList(portfolioId,local);
		projectDomain.setProjectList(projectList);
				
		return new BaseResponse<>(projectDomain);
	}
	
	
	/**
	 * 포토폴리오 프로젝트 다른회원 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/portfolioOthersMemberProjectView")
	@ApiOperation(value = "포토폴리오 프로젝트 다른회원 View")
	public String portfolioOthersMemberProjectView(Model model, 
			HttpServletRequest request, 
			HttpServletResponse response,
			@RequestParam("otherUserId") String otherUserId, 
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("projectId") String projectId,
			@RequestParam("otherEmail") String otherEmail, 
			@RequestParam("type") String type) {	
		
		String pageView = null;	
		if(type.equals(OTHERS)) {
			pageView =  "portfolio/portfolioOthersMemberProjectView";
		}else if(type.equals(OUT)) {
			pageView = "portfolio/portfolioOutProjectView";
		}		
		return pageView;
	}
	
	/**
	 * 포토폴리오 프로젝트 다른회원 View
	 * @param   
     * @return
	 * @throws IOException 
	 * @ exception 예외사항
	 * 
	 * */
	@ResponseBody
	@PostMapping("/portfolioOthersMemberProjectList")
	@ApiOperation(value = "포토폴리오 프로젝트 다른회원 View")
	public BaseResponse<ProjectDomain> portfolioOthersMemberProjectList(HttpServletRequest request, HttpServletResponse response,
			@RequestParam("otherUserId") String otherUserId, 
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("projectId") String projectId,
			@RequestParam("otherEmail") String otherEmail, 
			@RequestParam("type") String type) throws IOException {	
		
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		
		ProjectDomain projectDomain = new ProjectDomain();		
		
		if(otherUserId != null) {						
			//다른 회원정보 조회 
			UserDomain userDetail = userService.getUserDetail(otherEmail);
			projectDomain.setUserId(userId);
			projectDomain.setUserDetail(userDetail);
			
			//프로젝트 상세 데이터 조회 	  
			ProjectDomain projectInfo = projectService.getProjectDetailInfo(projectId);
			projectDomain.setProjectInfo(projectInfo);
			
			//프로젝트 컨텐츠조회 
			HashMap<String, String> countData = new HashMap<>();
			countData.put(USERID, otherUserId);
			countData.put(PROJECTID, projectId);
		    List<ProjectDomain> projectList = projectService.getProjectContentsList(countData);
		    projectDomain.setProjectList(projectList);
		    
		    if(type.equals(OTHERS)) {
		    	//좋아요 여부 조회  
			    HashMap<String, String> likeData = new HashMap<>();
			    likeData.put(PROJECTID, projectId);
			    likeData.put(USERID, userId);
			    likeData.put("likeUserId", otherUserId);
			    String likeStatus = projectService.getLikeStatus(likeData);
			    projectDomain.setLikeStatus(likeStatus);
		    }
		}else {
			response.sendRedirect(LOGINURL);
		}		
		return new BaseResponse<>(projectDomain);
	}
	
	
	/**
	 * 프로젝트 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/projectContentsOutImageFrom")
	@ApiOperation(value = "포토폴리오 프로젝트 다른회원 View")
	public String projectContentsOutImageFrom(Model model, HttpServletRequest request,
			@RequestParam("otherUserId") String otherUserId, 
			@RequestParam(PROJECTID) String projectId) {
		
		HashMap<String, String> paramContent = new HashMap<>();
		paramContent.put(USERID, otherUserId);
		paramContent.put(PROJECTID, projectId);
		List<ProjectDomain> contentsImageList = projectService.getContentsImageList(paramContent);
		model.addAttribute("contentsImageList", contentsImageList);
		
		return "portfolio/portfolioProjectImageView";
	}
	
	
	
	/**
	 * 프로젝트 좋아요
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/projectLikeSave")
	@ResponseBody
	@ApiOperation(value = "프로젝트 좋아요")
	public BaseResponse<Integer> projectLikeSave(HttpServletRequest request,
			@RequestParam("friendId") String friendId,	
			@RequestParam("portfolioId") String portfolioId,			
			@RequestParam("projectId") String projectId,
			@RequestParam("likeStatus") String likeStatus,
			Locale locale) {
		
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		
		//프로젝트 저장 
		HashMap<String, String> projectData = new HashMap<>();
		
		projectData.put(USERID, userId);	
		projectData.put("likeUserId", friendId);	
		projectData.put(PROJECTID, projectId);	
		projectData.put("likeStatus", likeStatus);	
		projectData.put(PORTFOLIOID, portfolioId);	
		projectService.projectLikeSave(projectData);	
		
		//포토폴리오 좋아요
		projectService.portfolioLikeSave(projectData);	
		
		//좋아요 히스토리
		projectService.projectLikeHistory(projectData);
		
		if(likeStatus.equals("Y")) {
			// 알람 발송 
			noticeService.insertProjectLikeRequest(locale, userId, friendId, portfolioId, projectId);
		}	
		
		return new BaseResponse<>(1);
	}
	
}
