package com.iscreammedia.clic.front.controller;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.InvalidKeyException;
import java.util.Arrays;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;

import javax.servlet.http.HttpServletRequest;
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
import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.ProjectDomain;
import com.iscreammedia.clic.front.service.PortfolioService;
import com.iscreammedia.clic.front.service.ProjectService;
import com.iscreammedia.clic.front.service.ResumeService;
import com.iscreammedia.clic.front.service.UserService;
import com.iscreammedia.clic.front.util.CommonUtil;
import com.microsoft.azure.storage.StorageException;

import io.swagger.annotations.ApiOperation;


@Controller
@RequestMapping("/studio/portfolio")
public class PortfolioController {
	
	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private PortfolioService portfolioService;
	
	@Autowired
	private ProjectService projectService;
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private ResumeService resumeService;
	
	@Autowired
	private LocaleResolver localeResolver;
	
	@Autowired
	private CommonUtil commonUtil;
	
		
	@Value("${resource.upload.path}")
	private String resourceUploadPath;
	
	
	@Value("${azure.blob.storage.url}")
	private String azureStorageUrl;
	
	
	private static final String USERID = "userId";
	private static final String PORTFOLIOID = "portfolioId";
	

	/**
	 * 포토폴리오 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/portfolioFrom")
	@ApiOperation(value = "포토폴리오 View")
	public String portfolioFrom(Locale locale, Model model, HttpServletRequest request) {	
		return "portfolio/portfolioList";
	}
	
	
	
	/**
	 * 포토폴리오 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/portfolioList")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 데이터 조회 ")
	public BaseResponse<List<PortfolioDomain>>  portfolioList(		
		@RequestParam(value = "userId", required = false) String userId
		, HttpServletRequest request) {
		
		
		HttpSession session = request.getSession();
		String myuserId = (String) session.getAttribute(USERID);
		
		if(userId == null) {			
			userId = (String) session.getAttribute(USERID);
		}
		
		HashMap<String, Object> param = new HashMap<>();
		param.put("myuserId", myuserId);
		param.put(USERID, userId);
		
		List<PortfolioDomain> portfolioList = portfolioService.getPortfolioList(param);
		return new BaseResponse<>(portfolioList);      
	} 
	
	
	/**
	 * 포토폴리오 상세 데이터 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/portfolioDetail")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 상세 데이터 조회 ")
	public BaseResponse<PortfolioDomain>  getPortfolioDetailInfo(Locale locale,
			@RequestParam(value = "userId", required = false) String userId,
			@RequestParam("portfolioId") String portfolioId,
			HttpServletRequest request) {
		
	  HttpSession session = request.getSession();
	  if(userId.equals("")) {			
		userId = (String) session.getAttribute(USERID);
	  }	
		
	  PortfolioDomain portfolioDomain = new PortfolioDomain();
						
      //포토폴리오 데이터 조회 
	  HashMap<String, String> paramData = new HashMap<>();
	  paramData.put(USERID, userId);
	  paramData.put(PORTFOLIOID, portfolioId); 	
      PortfolioDomain portfolioInfo = portfolioService.getPortfolioDetailInfo(paramData);
      portfolioDomain.setPortfolioInfo(portfolioInfo);
      
      //공개유형 조회
	  List<CommonDomain> publicList = userService.getCodeTypeList(locale,"18");
	  portfolioDomain.setPublicList(publicList);
	  	  
	  //금칙어
	  String concatWords =  portfolioService.getConcatWords();
		
	  String[] concat = concatWords.split(",");		
	  List<String> concatWordsList = Arrays.asList(concat);
	  portfolioDomain.setConcatWordsList(concatWordsList);	  
      
      
      return new BaseResponse<>(portfolioDomain);      
	} 
	
	
	/**
	 * 포토폴리오 삭제 
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/delPortfolio")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 삭제")
	public BaseResponse<Integer> delPortfolio(@RequestParam("userId") String userId, 
			@RequestParam("portfolioId") String portfolioId){
		
			HashMap<String, String> paramData = new HashMap<>();
			paramData.put(USERID, userId);
			paramData.put(PORTFOLIOID, portfolioId); 	
			
			//포토폴리오 테이블 삭제 
			portfolioService.delPortfolio(paramData);
			
			//이력서 포트폴리오 삭제
			int qrCheck = resumeService.portfolioCk(userId, portfolioId);
			if(qrCheck == 1) {
				resumeService.deletePortfolio(userId);
			}
			
			//portfolioId 로 프로젝트 테이블 삭제 처리 
			projectService.delProject(paramData);
			
			//portfolioId 아이디로 조회 후 프로젝트 아이디 가지고 프로젝트 컨텐츠테이블 삭제 처리 해야 함 
			List<ProjectDomain> projectIdList = projectService.getProjectIdList(portfolioId);
			for(int i = 0; i<projectIdList.size(); i++) {
				//프로젝트 컨텐츠 테이블 삭제 처리 
				HashMap<String, String> paramContent = new HashMap<>();
				paramContent.put(USERID, userId);
				paramContent.put("projectId", projectIdList.get(i).getProjectId()); 	
				projectService.delProjectContents(paramContent);
			}		
			
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 포토폴리오 등록 
	 * @param     userId,portfolioId
     * @return
	 * @throws Exception 
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/savePortfolio")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 등록")
	public BaseResponse<Integer> savePortfolio(//@RequestParam("userId") String userId,
			HttpServletRequest request,
			@RequestParam("portfolioName") String portfolioName,
			@RequestParam("publicTypeCode") String publicTypeCode,
			@RequestParam("introduction") String introduction,
			@RequestParam("isUseQr") String isUseQr,
			@RequestParam("tag") String tag,
			@RequestParam("files") MultipartFile[] uploadfiles) 
					throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
			
		HashMap<String, String> paramData = new HashMap<>();
		
		int index =0;
		for (MultipartFile file : Arrays.asList(uploadfiles)) {			 
			 String original = userId+System.currentTimeMillis()+file.getOriginalFilename();			 
			 
			 //Azure Blob storage 업로드 
			 String azureResult = commonUtil.azureFileUtil(file, original);
			 
			 if(azureResult.equals("success")) {
				 if(index == 0) {
		        	 paramData.put("listImagePath", azureStorageUrl+original);			        	 
		         }else {
		        	 paramData.put("backgroundImagePath", azureStorageUrl+original);	      
		         }	
		         index++;
			 }
		}
		
				
			paramData.put(USERID, userId); 
			paramData.put("name", portfolioName); 
			paramData.put("publicTypeCode", publicTypeCode); 
			paramData.put("introduction", introduction); 
			paramData.put("isUseQr", isUseQr); 
			paramData.put("tag", tag); 
		
			portfolioService.insertPortfolio(paramData);
		
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 포토폴리오 수정 
	 * @param     userId,portfolioId
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/updatePortfolio")
	@ResponseBody
	@ApiOperation(value = "포토폴리오 수정")
	public BaseResponse<Integer> updatePortfolio(
			HttpServletRequest request,
			//@RequestParam("userId") String userId,
			@RequestParam("portfolioId") String portfolioId,
			@RequestParam("portfolioName") String portfolioName,
			@RequestParam("publicTypeCode") String publicTypeCode,
			@RequestParam("introduction") String introduction,
			@RequestParam("isUseQr") String isUseQr,
			@RequestParam("tag") String tag,
			@RequestParam("files") MultipartFile[] uploadfiles) 
				throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		
		HashMap<String, String> paramData = new HashMap<>();
		
		int index =0;
		for (MultipartFile file : Arrays.asList(uploadfiles)) {
			String original = userId+System.currentTimeMillis()+file.getOriginalFilename();
			//Azure Blob storage 업로드
			String azureResult = commonUtil.azureFileUtil(file, original);
			 
			 if(azureResult.equals("success")) {
				 if(index == 0) {
					 if(!file.getOriginalFilename().equals("") ) {
			        	 paramData.put("listImagePath", azureStorageUrl+original);	
					 }
		         }else {
		        	 if(!file.getOriginalFilename().equals("") ) {
			        	 paramData.put("backgroundImagePath", azureStorageUrl+original);	
		        	 }
		        	 
		         }
		         index++;
			 }
		}
		
		
		  paramData.put(PORTFOLIOID, portfolioId);		
		  paramData.put(USERID, userId); 
		  paramData.put("name", portfolioName); 
		  paramData.put("publicTypeCode", publicTypeCode); 
		  paramData.put("introduction", introduction); 
		  paramData.put("isUseQr", isUseQr); 
		  paramData.put("tag", tag); 
		  portfolioService.updatePortfolio(paramData);
		  
		  //이력서 포트폴리오 삭제
		  int qrCheck = resumeService.portfolioCk(userId, portfolioId);
			if(qrCheck == 1 && isUseQr.equals("N")) {
				 resumeService.deletePortfolio(userId);
			}			
		
		return new BaseResponse<>(1);
	}
	
}
