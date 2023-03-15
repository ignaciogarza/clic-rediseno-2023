package com.iscreammedia.clic.front.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.URISyntaxException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
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
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.configuration.http.BaseResponseCode;
import com.iscreammedia.clic.front.domain.ResumeCareerDomain;
import com.iscreammedia.clic.front.domain.ResumeDomain;
import com.iscreammedia.clic.front.domain.ResumeEducationDomain;
import com.iscreammedia.clic.front.domain.ResumeLangDomain;
import com.iscreammedia.clic.front.domain.ResumeProgramDomain;
import com.iscreammedia.clic.front.domain.ResumeSkillDomain;
import com.iscreammedia.clic.front.service.LanguageService;
import com.iscreammedia.clic.front.service.ProgramingService;
import com.iscreammedia.clic.front.service.ResumeService;
import com.iscreammedia.clic.front.util.CommonUtil;
import com.iscreammedia.clic.front.util.CryptoUtil;
import com.microsoft.azure.storage.StorageException;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/studio/resume")
public class ResumeController {

	Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private ResumeService resumeService;
	
	@Autowired
	private ProgramingService programingService;
	
	@Autowired
	private LanguageService languageService;
	
	@Autowired
	private CommonUtil commonUtil;
	
	@Value("${SecretKey}")
	private String secretKey;
	
	@Value("${resource.upload.path}")
	private String resourceUploadPath;
	
	@Value("${azure.blob.storage.url}")
	private String azureStorageUrl;
	
	private static final String USERID = "userId";
	
	/**
	 * 이력서 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/detail")
	@ApiOperation(value = "이력서 조회 View")
	public String resumeDetail() { 

		return "resume/resumeDetail";
	}
	
	
	/**
	 * 이력서 조회 <br>
	 * 
	 * @param     locale
	 * @param     request
	 * @return ResumeDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/detail/main")
	@ApiOperation(value = "이력서 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeDomain> resumeDetailMain(Locale locale, HttpServletRequest request) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException{
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		String userImagePath = (String) session.getAttribute("userImagePath");
		
		ResumeDomain resumeDomain = new ResumeDomain();
		resumeDomain.setUserId(userId);
		resumeDomain.setImagePath(userImagePath);
		
		int check = resumeService.resumeCk(userId);
		
		//이력서 등록 체크 후 등록 안했으면 등록
		if(check == 0) {
			resumeService.insertResume(resumeDomain);
		} 
		
		ResumeDomain resumeDetail = resumeService.resumeDetail(locale, userId);
		int resumeId = resumeDetail.getResumeId();
		
		//이메일, 전화번호 복호화
		resumeDetail.setEmail(CryptoUtil.decryptAES256(resumeDetail.getEmail(), secretKey));
		resumeDetail.setTell(CryptoUtil.decryptAES256(resumeDetail.getTell(), secretKey));
		
		resumeDetail.setUserImagePath(userImagePath);
		
		resumeDetail.setCareerList(resumeService.selectCareerList(resumeId));
		resumeDetail.setEducationList(resumeService.selectEducationList(resumeId));
		resumeDetail.setSkillList(resumeService.selectSkillList(locale, resumeId));
		resumeDetail.setProgramList(resumeService.selectProgramList(locale, resumeId));
		resumeDetail.setProgramingList(programingService.selectProgramingList(locale));
		resumeDetail.setLangList(resumeService.selectLangList(locale, resumeId));
		resumeDetail.setLanguageList(languageService.selectLanguageList(locale));
		resumeDetail.setPortfolioList(resumeService.selectPortfolioList(userId));
		
		log.info("check : {}", check);
		
		return new BaseResponse<>(resumeDetail);
	}
	
	
	/**
	 * 이력서 템플릿(Modal)<br>
	 * 
	 * @param     locale
	 * @param     request
	 * @return ResumeDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/template")
	@ApiOperation(value = "이력서 템플릿 조회")
	@ResponseBody
	public BaseResponse<ResumeDomain> template(Locale locale, HttpServletRequest request)
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		//로그인한 유저
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		String userImagePath = (String) session.getAttribute("userImagePath");
		
		ResumeDomain resume = resumeService.resumeDetail(locale, userId);
		//이메일, 전화번호 복호화
		resume.setEmail(CryptoUtil.decryptAES256(resume.getEmail(), secretKey));
		resume.setTell(CryptoUtil.decryptAES256(resume.getTell(), secretKey));
		int resumeId = resume.getResumeId();
		
		resume.setUserImagePath(userImagePath);
		
		resume.setCareerList(resumeService.selectCareerList(resumeId));
		resume.setEducationList(resumeService.selectEducationList(resumeId));
		resume.setSkillList(resumeService.selectSkillList(locale, resumeId));
		resume.setProgramList(resumeService.selectProgramList(locale, resumeId));
		resume.setLangList(resumeService.selectLangList(locale, resumeId));
		
		return new BaseResponse<>(resume);
	}
	
	/**
	 * 프로필 이미지 업로드<br>
	 * 
	 * @param     mre
	 * @param     req
     * @return String
	 * @throws StorageException 
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/imgUpload")
	@ApiOperation(value = "프로필 이미지 업로드")
	@ResponseBody
    public BaseResponse<String> uploadTest(MultipartHttpServletRequest mre, HttpServletRequest req) 
    		throws StorageException, IOException, URISyntaxException, InvalidKeyException{
		HttpSession session = req.getSession();
		String userId = (String) session.getAttribute(USERID);
		
		int resumeId = Integer.parseInt(req.getParameter("resumeId")); // jsp text name mapping
        
        String imgURL = "";
        try {
	        MultipartFile mf = mre.getFile("filename"); // jsp file name mapping
	        
	      
	        String original = userId+System.currentTimeMillis()+mf.getOriginalFilename();
			//Azure Blob storage 업로드
			String azureResult = commonUtil.azureFileUtil(mf, original);
            if(azureResult.equals("success")) {
           	 imgURL = azureStorageUrl+original;
            }else {
           	 imgURL = null;
            }
	        
	        ResumeDomain resumeDomain = new ResumeDomain();
	        resumeDomain.setResumeId(resumeId);
	        resumeDomain.setImagePath(imgURL);
	        resumeService.updateResumeImg(resumeDomain);
	        
        } catch (IllegalStateException | IOException e) {
            log.info("exception: {}", e);
        }catch (MaxUploadSizeExceededException e) {
            // 파일사이즈초과되어도 에러메시지를 위해서 request 리턴하여 컨트롤러 메서드 호출되도록 한다.
        	return new BaseResponse<>(BaseResponseCode.ERROR, imgURL);
        }        
        return new BaseResponse<>(imgURL);
    }
	
	/**
	 * 이력서 정보 여부 수정<br>
	 * 
	 * @param     isPictureDisplay
	 * @param     isYearmonthdayDisplay
	 * @param     isCountryDisplay
	 * @param     isSexDisplay
	 * @param     isAboutMeDisplay
	 * @param     isCareerDisplay
	 * @param     isEducationDisplay
	 * @param     isHaveSkillDisplay
	 * @param     isProgramDisplay
	 * @param     isLangDisplay
	 * @param     isQrPortfolioDisplay
	 * @param     resumeId
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/infoEdit")
	@ApiOperation(value = "이력서 정보 노출 여부")
	@ResponseBody
	public BaseResponse<Integer> infoUpdate(@RequestParam("isPictureDisplay") String isPictureDisplay, @RequestParam("isYearmonthdayDisplay") String isYearmonthdayDisplay, 
			@RequestParam("isCountryDisplay") String isCountryDisplay, @RequestParam("isSexDisplay") String isSexDisplay,
			@RequestParam("isAboutMeDisplay") String isAboutMeDisplay, @RequestParam("isCareerDisplay") String isCareerDisplay,
			@RequestParam("isEducationDisplay") String isEducationDisplay,@RequestParam("isHaveSkillDisplay") String isHaveSkillDisplay, 
			@RequestParam("isProgramDisplay") String isProgramDisplay, @RequestParam("isLangDisplay") String isLangDisplay,
			@RequestParam("isQrPortfolioDisplay") String isQrPortfolioDisplay, @RequestParam("resumeId") int resumeId) {

		ResumeDomain resumeDomain = new ResumeDomain();
		resumeDomain.setIsPictureDisplay(isPictureDisplay);
		resumeDomain.setIsYearmonthdayDisplay(isYearmonthdayDisplay);
		resumeDomain.setIsSexDisplay(isSexDisplay);
		resumeDomain.setIsCountryDisplay(isCountryDisplay);
		resumeDomain.setIsAboutMeDisplay(isAboutMeDisplay);
		resumeDomain.setIsCareerDisplay(isCareerDisplay);
		resumeDomain.setIsEducationDisplay(isEducationDisplay);
		resumeDomain.setIsHaveSkillDisplay(isHaveSkillDisplay);
		resumeDomain.setIsProgramDisplay(isProgramDisplay);
		resumeDomain.setIsLangDisplay(isLangDisplay);
		resumeDomain.setIsQrPortfolioDisplay(isQrPortfolioDisplay);
		resumeDomain.setResumeId(resumeId);
		
		resumeService.updateInfoCk(resumeDomain);
		
		return new BaseResponse<>(1);
	}
	
	/**
	 * 이력서 템플릿 수정<br>
	 * 
	 * @param     resumeTemplateCode
	 * @param     resumeId
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/templateEdit")
	@ApiOperation(value = "이력서 템플릿 선택")
	@ResponseBody
	public BaseResponse<Integer> templateUpdate(@RequestParam("resumeTemplateCode") String resumeTemplateCode, @RequestParam("resumeId") int resumeId) {

		ResumeDomain resumeDomain = new ResumeDomain();
		resumeDomain.setResumeTemplateCode(resumeTemplateCode);
		resumeDomain.setResumeId(resumeId);
		
		resumeService.updateTemplateCk(resumeDomain);
		
		return new BaseResponse<>(1);
	}
	
	/**
	 * 이력서 자기소개 수정(Modal)<br>
	 * 
	 * @param     resumeId
	 * @return ResumeDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/selfEditView")
	@ApiOperation(value = "이력서 자기소개 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeDomain> selfDetail(@RequestParam("resumeId") int resumeId) {
		
		ResumeDomain selfDetail = resumeService.selfDetail(resumeId);
		selfDetail.setResumeId(resumeId);
		
		log.info("selfDetail: {}", selfDetail);
		
		return new BaseResponse<>(selfDetail);
	}
	
	/**
	 * 이력서 자기소개 수정<br>
	 * 
	 * @param     selfIntroduction
	 * @param     resumeId
	 * @param     locale
	 * @param     request
	 * @return ResumeDomain
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/selfEdit")
	@ApiOperation(value = "이력서 자기소개 수정")
	@ResponseBody
	public BaseResponse<ResumeDomain> selfUpdate(@RequestParam("selfIntroduction") String selfIntroduction, @RequestParam("resumeId") int resumeId, Locale locale, HttpServletRequest request) {
		
		ResumeDomain resumeDomain = new ResumeDomain();
		resumeDomain.setSelfIntroduction(selfIntroduction);
		resumeDomain.setResumeId(resumeId);
		
		resumeService.updateSelf(resumeDomain);
		
		//로그인한 유저
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		ResumeDomain resume = resumeService.resumeDetail(locale, userId);

		return new BaseResponse<>(resume);
	}
	
	/**
	 * 이력서 자기소개 삭제<br>
	 * 
	 * @param     resumeId
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/selfDelete")
	@ApiOperation(value = "이력서 자기소개 삭제")
	@ResponseBody
	public BaseResponse<Integer> selfDelete(@RequestParam("resumeId") int resumeId) {
		
		ResumeDomain resumeDomain = new ResumeDomain();
		resumeDomain.setResumeId(resumeId);
		
		resumeService.deleteSelf(resumeDomain);
			
		return new BaseResponse<>(1);
	}
	
	/**
	 * 이력서 경력 사항 포함 여부<br>
	 * 
	 * @param     resumeCareerMattersId
	 * @param     isCareerDisplay
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/isCareer")
	@ApiOperation(value = "이력서 경력사항 포함 여부")
	@ResponseBody
	public BaseResponse<Integer> updateIsCareer(@RequestParam("resumeCareerMattersId") int resumeCareerMattersId, @RequestParam("isCareerDisplay") String isCareerDisplay) {
		
		ResumeCareerDomain resumeCareerDomain = new ResumeCareerDomain();
		resumeCareerDomain.setResumeCareerMattersId(resumeCareerMattersId);
		resumeCareerDomain.setIsCareerDisplay(isCareerDisplay);
		
		resumeService.updateIsCareer(resumeCareerDomain);
			
		return new BaseResponse<>(1);
	}
	
	/**
	 * 이력서 경력 사항 등록<br>
	 * 
	 * @param     company
	 * @param     position
	 * @param     isWork
	 * @param     jobContents
	 * @param     joinYear
	 * @param     joinMonth
	 * @param     leaveYear
	 * @param     leaveMonth
	 * @param     resumeId
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/careerCreate")
	@ApiOperation(value = "이력서 경력사항 등록")
	@ResponseBody
	public BaseResponse<List<ResumeCareerDomain>> careerInsert(@RequestParam("company") String company, @RequestParam("position") String position, 
			@RequestParam("isWork") String isWork, @RequestParam("jobContents") String jobContents, 
			@RequestParam("joinYear") String joinYear, @RequestParam("joinMonth") String joinMonth,
			@RequestParam("leaveYear") String leaveYear, @RequestParam("leaveMonth") String leaveMonth, 
			@RequestParam("resumeId") int resumeId) {
		
		ResumeCareerDomain resumeCareerDomain = new ResumeCareerDomain();
		resumeCareerDomain.setCompany(company);
		resumeCareerDomain.setPosition(position);
		resumeCareerDomain.setIsWork(isWork);
		resumeCareerDomain.setJobContents(jobContents);
		resumeCareerDomain.setJoinYear(joinYear);
		resumeCareerDomain.setJoinMonth(joinMonth);
		if(leaveYear.isEmpty()) {
			resumeCareerDomain.setLeaveYear("0");
		} else {
			resumeCareerDomain.setLeaveYear(leaveYear);
		}
		if(leaveMonth.isEmpty()) {
			resumeCareerDomain.setLeaveMonth("0");
		} else {
			resumeCareerDomain.setLeaveMonth(leaveMonth);
		}
		resumeCareerDomain.setResumeId(resumeId);
		
		resumeService.insertCareer(resumeCareerDomain);
		
		List<ResumeCareerDomain> list = resumeService.selectCareerList(resumeId);

		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 경력 사항 수정(Modal)<br>
	 * 
	 * @param     resumeCareerMattersId
	 * @return ResumeCareerDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/careerEditView")
	@ApiOperation(value = "이력서 경력사항 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeCareerDomain> careerDetail(@RequestParam("resumeCareerMattersId") int resumeCareerMattersId) {
		
		ResumeCareerDomain careerDetail = resumeService.careerDetail(resumeCareerMattersId);
		careerDetail.setResumeCareerMattersId(resumeCareerMattersId);
		
		log.info("careerDetail: {}",careerDetail);
		
		return new BaseResponse<>(careerDetail);
	}
	
	/**
	 * 이력서 경력 사항 수정<br>
	 * 
	 * @param     company
	 * @param     position
	 * @param     isWork
	 * @param     jobContents
	 * @param     joinYear
	 * @param     joinMonth
	 * @param     leaveYear
	 * @param     leaveMonth
	 * @param     resumeCareerMattersId
	 * @param     resumeId
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/careerEdit")
	@ApiOperation(value = "이력서 경력사항 수정")
	@ResponseBody
	public BaseResponse<List<ResumeCareerDomain>> careerUpdate(@RequestParam("company") String company, @RequestParam("position") String position, 
			@RequestParam("isWork") String isWork, @RequestParam("jobContents") String jobContents, 
			@RequestParam("joinYear") String joinYear, @RequestParam("joinMonth") String joinMonth,
			@RequestParam("leaveYear") String leaveYear, @RequestParam("leaveMonth") String leaveMonth, 
			@RequestParam("resumeCareerMattersId") int resumeCareerMattersId, @RequestParam("resumeId") int resumeId) {
		
		ResumeCareerDomain resumeCareerDomain = new ResumeCareerDomain();
		resumeCareerDomain.setCompany(company);
		resumeCareerDomain.setPosition(position);
		resumeCareerDomain.setIsWork(isWork);
		resumeCareerDomain.setJobContents(jobContents);
		resumeCareerDomain.setJoinYear(joinYear);
		resumeCareerDomain.setJoinMonth(joinMonth);
		if(leaveYear.isEmpty()) {
			resumeCareerDomain.setLeaveYear("0");
		} else {
			resumeCareerDomain.setLeaveYear(leaveYear);
		}
		if(leaveMonth.isEmpty()) {
			resumeCareerDomain.setLeaveMonth("0");
		} else {
			resumeCareerDomain.setLeaveMonth(leaveMonth);
		}
		resumeCareerDomain.setResumeCareerMattersId(resumeCareerMattersId);
		
		resumeService.updateCareer(resumeCareerDomain);
		
		List<ResumeCareerDomain> list = resumeService.selectCareerList(resumeId);

		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 경력 사항 삭제<br>
	 * 
	 * @param     resumeCareerMattersId
	 * @param     resumeId
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/careerDelete")
	@ApiOperation(value = "이력서 경력사항 삭제")
	@ResponseBody
	public BaseResponse<List<ResumeCareerDomain>> careerDelete(@RequestParam("resumeCareerMattersId") int resumeCareerMattersId, @RequestParam("resumeId") int resumeId) {
		
		ResumeCareerDomain resumeCareerDomain = new ResumeCareerDomain();
		resumeCareerDomain.setResumeCareerMattersId(resumeCareerMattersId);
		
		resumeService.deleteCareer(resumeCareerDomain);
		
		List<ResumeCareerDomain> list = resumeService.selectCareerList(resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 교육 포함 여부<br>
	 * 
	 * @param     resumeEducationId
	 * @param     isEducationDisplay
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/isEducation")
	@ApiOperation(value = "이력서 교육 포함 여부")
	@ResponseBody
	public BaseResponse<Integer> updateIsEducation(@RequestParam("resumeEducationId") int resumeEducationId, @RequestParam("isEducationDisplay") String isEducationDisplay) {
		
		ResumeEducationDomain resumeEducationDomain = new ResumeEducationDomain();
		resumeEducationDomain.setResumeEducationId(resumeEducationId);
		resumeEducationDomain.setIsEducationDisplay(isEducationDisplay);
		
		resumeService.updateIsEducation(resumeEducationDomain);
			
		return new BaseResponse<>(1);
	}
	
	/**
	 * 이력서 교육 등록<br>
	 * 
	 * @param     school
	 * @param     major
	 * @param     isWork
	 * @param     admissionYear
	 * @param     admissionMonth
	 * @param     graduatedYear
	 * @param     graduatedMonth
	 * @param     resumeId
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/educationCreate")
	@ApiOperation(value = "이력서 교육 등록")
	@ResponseBody
	public BaseResponse<List<ResumeEducationDomain>> educationInsert(@RequestParam("school") String school, @RequestParam("major") String major, 
			@RequestParam("isWork") String isWork, @RequestParam("admissionYear") String admissionYear, @RequestParam("admissionMonth") String admissionMonth,
			@RequestParam("graduatedYear") String graduatedYear, @RequestParam("graduatedMonth") String graduatedMonth, 
			@RequestParam("resumeId") int resumeId) {
		
		ResumeEducationDomain resumeEducationDomain = new ResumeEducationDomain();
		resumeEducationDomain.setSchool(school);
		resumeEducationDomain.setMajor(major);
		resumeEducationDomain.setIsWork(isWork);
		resumeEducationDomain.setAdmissionYear(admissionYear);
		resumeEducationDomain.setAdmissionMonth(admissionMonth);
		if(graduatedYear.isEmpty()) {
			resumeEducationDomain.setGraduatedYear("0");
		} else {
			resumeEducationDomain.setGraduatedYear(graduatedYear);	
		}
		if(graduatedMonth.isEmpty()) {
			resumeEducationDomain.setGraduatedMonth("0");
		} else {
			resumeEducationDomain.setGraduatedMonth(graduatedMonth);
		}
		resumeEducationDomain.setResumeId(resumeId);
		
		resumeService.insertEducation(resumeEducationDomain);
		
		List<ResumeEducationDomain> list = resumeService.selectEducationList(resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 교육 수정(Modal)<br>
	 * 
	 * @param     resumeEducationId
	 * @return ResumeEducationDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/educationEditView")
	@ApiOperation(value = "이력서 교육 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeEducationDomain> educationDetail(@RequestParam("resumeEducationId") int resumeEducationId) {
		
		ResumeEducationDomain educationDetail = resumeService.educationDetail(resumeEducationId);
		educationDetail.setResumeEducationId(resumeEducationId);
		
		log.info("educationDetail: {}",educationDetail);
		
		return new BaseResponse<>(educationDetail);
	}
	
	/**
	 * 이력서 교육 수정<br>
	 * 
	 * @param     school
	 * @param     major
	 * @param     isWork
	 * @param     admissionYear
	 * @param     admissionMonth
	 * @param     graduatedYear
	 * @param     graduatedMonth
	 * @param     resumeEducationId
	 * @param     resumeId
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/educationEdit")
	@ApiOperation(value = "이력서 교육 수정")
	@ResponseBody
	public BaseResponse<List<ResumeEducationDomain>> educationUpdate(@RequestParam("school") String school, @RequestParam("major") String major, 
			@RequestParam("isWork") String isWork, @RequestParam("admissionYear") String admissionYear, @RequestParam("admissionMonth") String admissionMonth,
			@RequestParam("graduatedYear") String graduatedYear, @RequestParam("graduatedMonth") String graduatedMonth, 
			@RequestParam("resumeEducationId") int resumeEducationId, @RequestParam("resumeId") int resumeId) {
		
		ResumeEducationDomain resumeEducationDomain = new ResumeEducationDomain();
		resumeEducationDomain.setSchool(school);
		resumeEducationDomain.setMajor(major);
		resumeEducationDomain.setIsWork(isWork);
		resumeEducationDomain.setAdmissionYear(admissionYear);
		resumeEducationDomain.setAdmissionMonth(admissionMonth);
		if(graduatedYear.isEmpty()) {
			resumeEducationDomain.setGraduatedYear("0");
		} else {
			resumeEducationDomain.setGraduatedYear(graduatedYear);	
		}
		if(graduatedMonth.isEmpty()) {
			resumeEducationDomain.setGraduatedMonth("0");
		} else {
			resumeEducationDomain.setGraduatedMonth(graduatedMonth);
		}
		resumeEducationDomain.setResumeEducationId(resumeEducationId);
		
		resumeService.updateEducation(resumeEducationDomain);
		
		List<ResumeEducationDomain> list = resumeService.selectEducationList(resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 교육 삭제<br>
	 * 
	 * @param     resumeEducationId
	 * @param     resumeId
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/educationDelete")
	@ApiOperation(value = "이력서 교육 삭제")
	@ResponseBody
	public BaseResponse<List<ResumeEducationDomain>> educationDelete(@RequestParam("resumeEducationId") int resumeEducationId, @RequestParam("resumeId") int resumeId) {
		
		ResumeEducationDomain resumeEducationDomain = new ResumeEducationDomain();
		resumeEducationDomain.setResumeEducationId(resumeEducationId);
		
		resumeService.deleteEducation(resumeEducationDomain);
		
		List<ResumeEducationDomain> list = resumeService.selectEducationList(resumeId);

		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 스킬 제한 체크<br>
	 * 
	 * @param     resumeId
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/skillCk")
	@ApiOperation(value = "이력서 보유스킬 등록 제한 확인")
	@ResponseBody
	public BaseResponse<Integer> skillCk(@RequestParam("resumeId") int resumeId) {
		
		int skillCk = resumeService.skillCk(resumeId);
		
		log.info("===skillCk: {}", skillCk);
		
		return new BaseResponse<>(skillCk);
	}
	
	/**
	 * 이력서 스킬 등록<br>
	 * 
	 * @param     skillName
	 * @param     measureTypeCode
	 * @param     measureLevel
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/skillCreate")
	@ApiOperation(value = "이력서 보유스킬 등록")
	@ResponseBody
	public BaseResponse<List<ResumeSkillDomain>> skillInsert(@RequestParam("skillName") String skillName, @RequestParam("measureTypeCode") String measureTypeCode,
			 @RequestParam("measureLevel") String measureLevel, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeSkillDomain resumeSkillDomain = new ResumeSkillDomain();
		resumeSkillDomain.setSkillName(skillName);
		resumeSkillDomain.setMeasureTypeCode(measureTypeCode);
		resumeSkillDomain.setMeasureLevel(measureLevel);
		resumeSkillDomain.setResumeId(resumeId);
		
		resumeService.insertSkill(resumeSkillDomain);
		
		List<ResumeSkillDomain> list = resumeService.selectSkillList(locale, resumeId);
		
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 스킬 수정(Modal)<br>
	 * 
	 * @param     resumeHaveSkillId
	 * @return ResumeSkillDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/skillEditView")
	@ApiOperation(value = "이력서 보유스킬 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeSkillDomain> skillDetail(@RequestParam("resumeHaveSkillId") int resumeHaveSkillId) {
		
		ResumeSkillDomain skillDetail = resumeService.skillDetail(resumeHaveSkillId);
		skillDetail.setResumeHaveSkillId(resumeHaveSkillId);
		
		log.info("skillDetail: {}",skillDetail);
		
		return new BaseResponse<>(skillDetail);
	}
	
	/**
	 * 이력서 스킬 수정<br>
	 * 
	 * @param     skillName
	 * @param     measureTypeCode
	 * @param     measureLevel
	 * @param     resumeHaveSkillId
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/skillEdit")
	@ApiOperation(value = "이력서 보유스킬 수정")
	@ResponseBody
	public BaseResponse<List<ResumeSkillDomain>> skillUpdate(@RequestParam("skillName") String skillName, @RequestParam("measureTypeCode") String measureTypeCode
			, @RequestParam("measureLevel") String measureLevel, @RequestParam("resumeHaveSkillId") int resumeHaveSkillId
			, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeSkillDomain resumeSkillDomain = new ResumeSkillDomain();
		resumeSkillDomain.setSkillName(skillName);
		resumeSkillDomain.setMeasureTypeCode(measureTypeCode);
		resumeSkillDomain.setMeasureLevel(measureLevel);
		resumeSkillDomain.setResumeHaveSkillId(resumeHaveSkillId);
		
		resumeService.updateSkill(resumeSkillDomain);
		
		List<ResumeSkillDomain> list = resumeService.selectSkillList(locale, resumeId);
		
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 스킬 삭제<br>
	 * 
	 * @param     resumeHaveSkillId
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/skillDelete")
	@ApiOperation(value = "이력서 보유스킬 삭제")
	@ResponseBody
	public BaseResponse<List<ResumeSkillDomain>> skillDelete(@RequestParam("resumeHaveSkillId") int resumeHaveSkillId, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeSkillDomain resumeSkillDomain = new ResumeSkillDomain();
		resumeSkillDomain.setResumeHaveSkillId(resumeHaveSkillId);
		
		resumeService.deleteSkill(resumeSkillDomain);
		
		List<ResumeSkillDomain> list = resumeService.selectSkillList(locale, resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 프로그램 중복체크<br>
	 * 
	 * @param     resumeId
	 * @param     programingId
	 * @param     program
	 * @param     isDelete
	 * @return Boolean
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/programCk")
	@ApiOperation(value = "이력서 프로그램 중복 확인")
	@ResponseBody
	public BaseResponse<Boolean> programCk(@RequestParam("resumeId") int resumeId, @RequestParam("programingId") String programingId, 
			@RequestParam("program") String program, @RequestParam("isDelete") String isDelete) {
		
		ResumeProgramDomain resumeProgramDomain = new ResumeProgramDomain();
		resumeProgramDomain.setResumeId(resumeId);
		resumeProgramDomain.setProgramingId(programingId);
		resumeProgramDomain.setProgram(program);
		resumeProgramDomain.setIsDelete(isDelete);
		
		int checkCount = resumeService.programCk(resumeProgramDomain);
		Boolean result = null;
		
		if(checkCount > 0) {
			result = false;
		} else {
			result = true;
		}
		log.info("checkCount!!!!! : {}", checkCount);
		log.info("result!!!!! : {}", result);
		
		return new BaseResponse<>(result);
	}
	
	/**
	 * 이력서 프로그램 등록<br>
	 * 
	 * @param     programingId
	 * @param     program
	 * @param     measureTypeCode
	 * @param     measureLevel
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/programCreate")
	@ApiOperation(value = "이력서 프로그램 등록")
	@ResponseBody
	public BaseResponse<List<ResumeProgramDomain>> programInsert(@RequestParam("programingId") String programingId, @RequestParam("program") String program
			, @RequestParam("measureTypeCode") String measureTypeCode, @RequestParam("measureLevel") String measureLevel
			, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeProgramDomain resumeProgramDomain = new ResumeProgramDomain();
		resumeProgramDomain.setProgramingId(programingId);
		resumeProgramDomain.setProgram(program);
		resumeProgramDomain.setMeasureTypeCode(measureTypeCode);
		resumeProgramDomain.setMeasureLevel(measureLevel);
		resumeProgramDomain.setResumeId(resumeId);
		
		resumeService.insertProgram(resumeProgramDomain);
		
		List<ResumeProgramDomain> list = resumeService.selectProgramList(locale, resumeId);
		
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 프로그램 수정(Modal)<br>
	 * 
	 * @param     resumeProgramId
	 * @param     locale
	 * @return ResumeProgramDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/programEditView")
	@ApiOperation(value = "이력서 프로그램 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeProgramDomain> programDetail(@RequestParam("resumeProgramId") int resumeProgramId, Locale locale) {
		
		ResumeProgramDomain programDetail = resumeService.programDetail(locale, resumeProgramId);
		programDetail.setResumeProgramId(resumeProgramId);
		
		log.info("programDetail: {}",programDetail);
		
		return new BaseResponse<>(programDetail);
	}
	
	/**
	 * 이력서 프로그램 수정<br>
	 * 
	 * @param     programingId
	 * @param     program
	 * @param     measureTypeCode
	 * @param     measureLevel
	 * @param     resumeProgramId
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/programEdit")
	@ApiOperation(value = "이력서 프로그램 수정")
	@ResponseBody
	public BaseResponse<List<ResumeProgramDomain>> programUpdate(@RequestParam("programingId") String programingId, @RequestParam("program") String program, 
			@RequestParam("measureTypeCode") String measureTypeCode, @RequestParam("measureLevel") String measureLevel, 
			@RequestParam("resumeProgramId") int resumeProgramId, @RequestParam("resumeId") int resumeId
			, Locale locale) {
		
		ResumeProgramDomain resumeProgramDomain = new ResumeProgramDomain();
		resumeProgramDomain.setProgramingId(programingId);
		resumeProgramDomain.setProgram(program);
		resumeProgramDomain.setMeasureTypeCode(measureTypeCode);
		resumeProgramDomain.setMeasureLevel(measureLevel);
		resumeProgramDomain.setResumeProgramId(resumeProgramId);
		
		resumeService.updateProgram(resumeProgramDomain);
		
		List<ResumeProgramDomain> list = resumeService.selectProgramList(locale, resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 프로그램 삭제<br>
	 * 
	 * @param     resumeProgramId
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/programDelete")
	@ApiOperation(value = "이력서 프로그램 삭제")
	@ResponseBody
	public BaseResponse<List<ResumeProgramDomain>> programDelete(@RequestParam("resumeProgramId") int resumeProgramId, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeProgramDomain resumeProgramDomain = new ResumeProgramDomain();
		resumeProgramDomain.setResumeProgramId(resumeProgramId);
		
		resumeService.deleteProgram(resumeProgramDomain);
		
		List<ResumeProgramDomain> list = resumeService.selectProgramList(locale, resumeId);
	
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 언어 중복체크<br>
	 * 
	 * @param     resumeId
	 * @param     langId
	 * @param     langTitle
	 * @param     isDelete
	 * @return Boolean
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/langCk")
	@ApiOperation(value = "이력서 언어 중복 확인")
	@ResponseBody
	public BaseResponse<Boolean> langCk(@RequestParam("resumeId") int resumeId, @RequestParam("langId") String langId, 
			@RequestParam("langTitle") String langTitle, @RequestParam("isDelete") String isDelete) {
		
		ResumeLangDomain resumeLangDomain = new ResumeLangDomain();
		resumeLangDomain.setResumeId(resumeId);
		resumeLangDomain.setLangId(langId);
		resumeLangDomain.setLangTitle(langTitle);
		resumeLangDomain.setIsDelete(isDelete);
		
		int checkCount = resumeService.langCk(resumeLangDomain);
		Boolean result = null;
		
		if(checkCount > 0) {
			result = false;
		} else {
			result = true;
		}
		log.info("checkCount!!!!! : {}", checkCount);
		log.info("result!!!!! : {}", result);
		
		return new BaseResponse<>(result);
	}
	
	/**
	 * 이력서 언어 등록<br>
	 * 
	 * @param     langId
	 * @param     langTitle
	 * @param     measureTypeCode
	 * @param     measureLevel
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/langCreate")
	@ApiOperation(value = "이력서 언어 등록")
	@ResponseBody
	public BaseResponse<List<ResumeLangDomain>> langInsert(@RequestParam("langId") String langId, @RequestParam("langTitle") String langTitle
			, @RequestParam("measureTypeCode") String measureTypeCode, @RequestParam("measureLevel") String measureLevel
			, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeLangDomain resumeLangDomain = new ResumeLangDomain();
		resumeLangDomain.setLangId(langId);
		resumeLangDomain.setLangTitle(langTitle);
		resumeLangDomain.setMeasureTypeCode(measureTypeCode);
		resumeLangDomain.setMeasureLevel(measureLevel);
		resumeLangDomain.setResumeId(resumeId);
		
		resumeService.insertLang(resumeLangDomain);
		
		List<ResumeLangDomain> list = resumeService.selectLangList(locale, resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 언어 수정(Modal)<br>
	 * 
	 * @param     resumeLangId
	 * @param     locale
	 * @return ResumeLangDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/langEditView")
	@ApiOperation(value = "이력서 언어 상세 조회")
	@ResponseBody
	public BaseResponse<ResumeLangDomain> langDetail(@RequestParam("resumeLangId") int resumeLangId, Locale locale) {
		
		ResumeLangDomain langDetail = resumeService.langDetail(locale, resumeLangId);
		langDetail.setResumeLangId(resumeLangId);
		
		log.info("langDetail: {}",langDetail);
		
		return new BaseResponse<>(langDetail);
	}
	
	/**
	 * 이력서 언어 수정<br>
	 * 
	 * @param     langId
	 * @param     langTitle
	 * @param     measureTypeCode
	 * @param     measureLevel
	 * @param     resumeLangId
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 * 
	 */
	@PostMapping("/langEdit")
	@ApiOperation(value = "이력서 언어 수정")
	@ResponseBody
	public BaseResponse<List<ResumeLangDomain>> langUpdate(@RequestParam("langId") String langId, @RequestParam("langTitle") String langTitle, 
			@RequestParam("measureTypeCode") String measureTypeCode, @RequestParam("measureLevel") String measureLevel,
			@RequestParam("resumeLangId") int resumeLangId, @RequestParam("resumeId") int resumeId, Locale locale) {
		
		ResumeLangDomain resumeLangDomain = new ResumeLangDomain();
		resumeLangDomain.setLangId(langId);
		resumeLangDomain.setLangTitle(langTitle);
		resumeLangDomain.setMeasureTypeCode(measureTypeCode);
		resumeLangDomain.setMeasureLevel(measureLevel);
		resumeLangDomain.setResumeLangId(resumeLangId);
		
		resumeService.updateLang(resumeLangDomain);
		
		List<ResumeLangDomain> list = resumeService.selectLangList(locale, resumeId);
			
		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 언어 삭제<br>
	 * 
	 * @param     resumeLangId
	 * @param     resumeId
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/langDelete")
	@ApiOperation(value = "이력서 언어 삭제")
	@ResponseBody
	public BaseResponse<List<ResumeLangDomain>> langDelete(@RequestParam("resumeLangId") int resumeLangId, @RequestParam("resumeId") int resumeId, Locale locale) {

		ResumeLangDomain resumeLangDomain = new ResumeLangDomain();
		resumeLangDomain.setResumeLangId(resumeLangId);
		
		resumeService.deleteLang(resumeLangDomain);
		
		List<ResumeLangDomain> list = resumeService.selectLangList(locale, resumeId);

		return new BaseResponse<>(list);
	}
	
	/**
	 * 이력서 포트폴리오 수정<br>
	 * 
	 * @param     qrPortfolioId
	 * @param     resumeId
	 * @return Integer
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/portfolioEdit")
	@ApiOperation(value = "이력서 포트폴리오 수정")
	@ResponseBody
	public BaseResponse<Integer> portfolioUpdate(@RequestParam("qrPortfolioId") int qrPortfolioId, @RequestParam("resumeId") int resumeId) {

		ResumeDomain resumeDomain = new ResumeDomain();
		resumeDomain.setQrPortfolioId(qrPortfolioId);
		resumeDomain.setResumeId(resumeId);
		
		resumeService.updatePortfolio(resumeDomain);
		
		return new BaseResponse<>(1);
	}

}
