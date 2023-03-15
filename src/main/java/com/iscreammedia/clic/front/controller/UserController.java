package com.iscreammedia.clic.front.controller;

import java.io.IOException;
import java.net.URISyntaxException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.mail.MessagingException;
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
import org.springframework.web.multipart.MaxUploadSizeExceededException;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.multipart.MultipartHttpServletRequest;
import org.springframework.web.servlet.LocaleResolver;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.configuration.http.BaseResponseCode;
import com.iscreammedia.clic.front.domain.AuthNumberDomain;
import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.domain.SurveyDomain;
import com.iscreammedia.clic.front.domain.TermsAgreeDomain;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.repository.NoticeRepository;
import com.iscreammedia.clic.front.service.MailSendService;
import com.iscreammedia.clic.front.service.UserService;
import com.iscreammedia.clic.front.util.CommonUtil;
import com.iscreammedia.clic.front.util.CryptoUtil;
import com.microsoft.azure.storage.StorageException;

import io.swagger.annotations.ApiOperation;


@Controller
@RequestMapping("/user")
public class UserController {

	Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private MailSendService mailSendService;
	
	@Autowired
	private LocaleResolver localeResolver;
	
	@Autowired
	private NoticeRepository noticeRepository;
		
	@Autowired
	private CommonUtil commonUtil;
	
	@Value("${SecretKey}")
	private String secretKey;
	
	@Value("${resource.upload.path}")
	private String resourceUploadPath;
	
	@Value("${azure.blob.storage.url}")
	private String azureStorageUrl;
	
	
	private static final String USERID = "userId";	
	private static final String USERIMAGEPATH = "userImagePath";
	
	
	
	/**
	 * 회원가입 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/userForm")
	@ApiOperation(value = "회원가입 View")
	public String userform(Model model){		
		//이용약관 데이터 조회 해야함 
		List<TermsAgreeDomain> termsList = userService.getTermsList();
		model.addAttribute("termsList", termsList);			
		return "user/userForm";
	}
	
	
	/**
	 * 이용약관 조회 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/termsList")
	@ResponseBody
	@ApiOperation(value = "이용약관 조회")
	public BaseResponse<List<TermsAgreeDomain>> termsList(){		
		//이용약관 데이터 조회 해야함 
		List<TermsAgreeDomain> termsList = userService.getTermsList();
		return new BaseResponse<>(termsList);
	} 
			
	/**
	 * 이메일인증 화면 
	 * @param     email
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/emailCertificationView")
	@ApiOperation(value = "이메일인증 화면")
	public String emailCertificationView(Model model, @RequestParam("email") String email){
		return "user/userEmailCertification";
	}
	
	
	/**
	 * 회원가입 저장
	 * @param     name,firstName,email,password,termsId_01,termsId_02
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/userInsert")
	@ResponseBody
	@ApiOperation(value = "회원가입저장")
	public BaseResponse<Integer> userInsert(
			@RequestParam("name") String name, 
			@RequestParam("firstName") String firstName , 
			@RequestParam("email") String email, 
			@RequestParam("password") String password, 
			@RequestParam("termsId_01") int termsId01, 
			@RequestParam("termsId_02") int termsId02,
			@RequestParam(value="termsId[]", required=false) int[] termsId,
			@RequestParam("osType") String osType ) 
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
						
			UserDomain user = new UserDomain();
			String userId = UUID.randomUUID().toString().replace("-", "");
			String shaPassword = CryptoUtil.sha256(password);
			
			user.setUserId(userId);
			user.setName(name);
			user.setFirstName(firstName);
			user.setUserStatusCode("0201");
			
			//이메일 암호화 처리 	
			user.setEmail(CryptoUtil.encryptAES256(email, secretKey));
			
			user.setPassword(shaPassword); //어떻게 처리할지 확인 필요 컬럼 길이 확인 필요
			user.setOsType(osType);
			
			//회원테이블 등록
			userService.userInsert(user); 
						
			//약관 동의 등록
			String[] termsTypeCode = {"0901","0902"};
			for(int i = 0; i<termsId.length; i++) {
				TermsAgreeDomain termsAgree = new TermsAgreeDomain();
				termsAgree.setUserId(userId);
				termsAgree.setTermsTypeCode(termsTypeCode[i]);
				termsAgree.setTermsId(termsId[i]);
				userService.termsAgreeInsert(termsAgree);
	        }
			
		return new BaseResponse<>(1);
	}
		
	
	
	/**
	 * 회원프로필 수정 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/userProfileForm")
	@ApiOperation(value = "회원프로필 수정 화면")
	public String userProfileForm(Locale locale, Model model, HttpServletRequest request) {
		return "user/userProfileForm";
	}
	
	@PostMapping("/userProfileList")
	@ResponseBody
	@ApiOperation(value = "회원프로필 조회")
	public BaseResponse<UserDomain> userProfileList(Locale locale, HttpServletRequest request)
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		HttpSession session = request.getSession();		
		String email = (String) session.getAttribute("sessionEmail");
		
        UserDomain userDomain = new UserDomain();
		
		//회원정보 조회
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
		userDetail.setEmail(CryptoUtil.decryptAES256(userDetail.getEmail(), secretKey));
		if(userDetail.getTell() != null) {
			userDetail.setTell(CryptoUtil.decryptAES256(userDetail.getTell(), secretKey));
		}
		
		
		userDomain.setUserDetail(userDetail);

		//설문조사 참여 했는지 값 조회 로직 추가 해야함 
		UserDomain surveyInfo = userService.getSurveyInfo(userDetail.getUserId());
		
		if(surveyInfo != null) {
			session.setAttribute("isComplete", surveyInfo.getIsComplete());
			userDomain.setIsComplete(surveyInfo.getIsComplete());
		}else {
			userDomain.setIsComplete("N");
		}
		
		
		//국가 목록 조회 
		List<CommonDomain> countryList = userService.getCountryList(locale);
		userDomain.setCountryList(countryList);
				
		//직업 목록 조회
		List<CommonDomain> jobList = userService.getJobist(locale);
		userDomain.setJobList(jobList);
		
		//학력 조회
		List<CommonDomain> educationList = userService.getCodeTypeList(locale,"04");
		userDomain.setEducationList(educationList);
		
		//경력 조회
		List<CommonDomain> careerList = userService.getCodeTypeList(locale,"06");
		userDomain.setCareerList(careerList);				
		
		//설문조사 문항 	
		List<SurveyDomain> surveyQuestionList = userService.getSurveyQuestionList(locale);		
		
		//설문조사 문항 
		List<Integer> questionIdList = new ArrayList<>();
		for(int i = 0 ; i<surveyQuestionList.size() ; i++) {
			questionIdList.add(surveyQuestionList.get(i).getQuestionId());
		}
				
		userDomain.setQuestionIdList(questionIdList);
		userDomain.setSurveyQuestionList(surveyQuestionList);
		
		List<SurveyDomain> surveyExampleList = userService.getSurveyExampleList(locale);
		userDomain.setSurveyExampleList(surveyExampleList);
		
		return new BaseResponse<>(userDomain);     
	}
	
	
	/**
	 * 도시 목록 조회 
	 * @param     
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getCityList")
	@ResponseBody
	@ApiOperation(value = "도시 목록 조회")
	public BaseResponse<List<CommonDomain>>  getCityList(
			@RequestParam("countryCode") String countryCode, 
			Locale locale,
			HttpServletRequest request) {
		
		//도시 목록 조회 
		List<CommonDomain> cityList = userService.getCityList(locale,countryCode);		
		
		return new BaseResponse<>(cityList);      
	} 
	
	/**
	 * 회원정보 수정 
	 * @param     
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/userUpdate")
	@ResponseBody
	@ApiOperation(value = "회원프로필 수정 ")
	public BaseResponse<Integer> userUpdate(@RequestParam("userId") String userId,
			@RequestParam("email") String email, 
			@RequestParam("name") String name,
			@RequestParam("firstName") String firstName, 
			@RequestParam("year") int year,
			@RequestParam("month") int month, 
			@RequestParam("day") int day,
			@RequestParam("sexCode") String sexCode,
			@RequestParam("tell") String tell,
			@RequestParam("country") String country, 
			@RequestParam("city") String city,
			@RequestParam("educationCode") String educationCode,
			@RequestParam("isStudent") String isStudent,
			@RequestParam(value="jobId", required=false) String jobId, 
			@RequestParam("careerCode") String careerCode,
			@RequestParam(value="surveyId", required=false, defaultValue = "0") int surveyId,			
			@RequestParam(value="exampleId[]", required=false) int[] exampleId, 
			@RequestParam(value="exampleQuestionId[]", required=false) int[] exampleQuestionId,
			HttpServletRequest request) 
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
			  
		
			UserDomain user = new UserDomain();	
			user.setUserId(userId);			
			user.setEmail(CryptoUtil.encryptAES256(email, secretKey));
			user.setName(name);		
	
			user.setUserStatusCode("0204");
			user.setFirstName(firstName);
			user.setYear(year);
			user.setMonth(month);
			user.setDay(day);
			user.setSexCode(sexCode);
			user.setTell(CryptoUtil.encryptAES256(tell, secretKey));
			user.setCountryCode(country);
			user.setCityId(city);
			user.setEducationCode(educationCode);
			user.setIsStudent(isStudent);
			user.setJobId(jobId);
			user.setCareerCode(careerCode);			
			//비밀번호 수정  
			userService.userUpdate(user);	
			
			//수정시 직업명 세션 업데이트
			HttpSession session = request.getSession();
			UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey)); 
			session.setAttribute(USERIMAGEPATH, userDetail.getUserImagePath());
			session.setAttribute("fullName", userDetail.getName()+" "+ userDetail.getFirstName());
			session.setAttribute("countryCode", userDetail.getCountryCode());
			//session.setAttribute("jobNameEng", userDetail.getJobNameEng());
			//session.setAttribute("jobNameSpa", userDetail.getJobNameSpa());
			
			
			//설문조사 응시한거 저장 처리 진행 
			//설문조사 값 있으면 service단가서 setUserTypeCode 값 0204 변경 			
			if(surveyId != 0) {
				//설문참여이력 저장 
				SurveyDomain surveys = new SurveyDomain();
				surveys.setUserId(userId);
				surveys.setSurveyId(surveyId);
				surveys.setIsComplete("Y");
				surveys.setCreator(userId);
				surveys.setUpdater(userId);
				userService.surveyJoinHistoryInsert(surveys);				
				
				for(int i = 0; i<exampleId.length; i++) {
					SurveyDomain survey = new SurveyDomain();	
					survey.setJoinSurveyId(surveys.getJoinSurveyId());		//참여설문 아이디
					survey.setQuestionId(exampleId[i]);			//답변아이디
					survey.setExampleAnswer(exampleQuestionId[i]);		//보기아이디
					survey.setCreator(userId);
					survey.setUpdater(userId);
					userService.surveyAnswerInsert(survey);
		        }	
			}
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 탈퇴사유 화면 
	 * @param     email
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/userSecessionForm")
	@ApiOperation(value = "탈퇴사유화면")
	public String userSecessionForm(Model model, 
			@RequestParam("email") String email, 
			@RequestParam("userId") String userId)
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		//회원정보 조회
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
		model.addAttribute("userDetail", userDetail);	
		
		model.addAttribute("email", CryptoUtil.decryptAES256(userDetail.getEmail(), secretKey));	
		model.addAttribute(USERID, userId);
		return "user/userSecessionForm";
	}
	
	/**
	 * 탈퇴사유 화면 
	 * @param     email
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/userSecessionList")
	@ResponseBody
	@ApiOperation(value = "탈퇴사유 화면")
	public BaseResponse<UserDomain> userSecessionList(
			@RequestParam("email") String email, 
			@RequestParam("userId") String userId)
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		UserDomain userDomain = new UserDomain();
		//회원정보 조회
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
		userDomain.setUserDetail(userDetail);
		
		return new BaseResponse<>(userDomain);
	}
	
	
	/**
	 * 비밀번호 수정 
	 * @param     userId,email,password   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/userPwUpdate")
	@ResponseBody
	@ApiOperation(value = "비밀번호 수정")
	public BaseResponse<String> userPwUpdate(@RequestParam("userId") String userId,			
			@RequestParam("email") String email,
			HttpServletRequest request,
			@RequestParam("password") String password,
			@RequestParam("passwordOld") String passwordOld
			) throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
				
		String result = null;
		
			UserDomain user = new UserDomain();			
			
			String shaPasswordOld = CryptoUtil.sha256(passwordOld);
			UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
			
			if(userDetail.getPassword().equals(shaPasswordOld)) {
				String shaPassword = CryptoUtil.sha256(password);
				
				user.setUserId(userId);	
				user.setPassword(shaPassword); //어떻게 처리할지 확인 필요 컬럼 길이 확인 필요
				user.setUpdater(userId);	
				user.setPasswordIsEarly("N");	
				//비밀번호 수정 
				userService.userPwUpdate(user);		
				
				//수정시 세션 업데이트
				HttpSession session = request.getSession();			
				session.setAttribute("passwordIsEarly", "N");
				result = "1";
			}else {
				result = "0";
			}			
				
		return new BaseResponse<>(result);
	}
	
	
	/**
	 * 탈퇴사유 저장 
	 * @param     userId,email,leverReasonCode
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/userSecessionSave")
	@ResponseBody
	@ApiOperation(value = "탈퇴사유 저장")
	public BaseResponse<Integer> userSecessionSave(@RequestParam("email") String email,
			@RequestParam("userId") String userId,
			@RequestParam("leverReasonCode") String leverReasonCode,
			@RequestParam("osType") String osType,
			HttpServletRequest request) 
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
					
			UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
						
			UserDomain user = new UserDomain();						
			user.setUserId(userId);				//파라미터로 받아야함
			user.setCountryCode(userDetail.getCountryCode());
			user.setCityId(userDetail.getCityId());
			user.setUserStatusCode("0207");
			user.setLeverReasonCode(leverReasonCode);	//탈퇴사유		파라미터로 받아야함
			user.setOsType(osType);
			user.setCreator("");
			
			//회원테이블 상태값 변경 
			//유저 테이블 삭제 처리 해야함 
			userService.userDelete(user);
			
			//회원탈퇴 테이블 저장  
			userService.userSecessionInsert(user);	
			
			//로그인 세션 db 삭제 처리 
			userService.loginHistoryDelete(userId);
			
			//세션 삭제 
			HttpSession session = request.getSession();
			session.invalidate();
						
		return new BaseResponse<>(1);
	}
	
	
	/**
	 * 이메일 전송 및 인증번호 
	 * @param     email
     * @return
	 * @ exception 예외사항  https://moonong.tistory.com/45
	 * 
	 * */
	@PostMapping("/emailSend")
	@ResponseBody
	@ApiOperation(value = "이메일 전송 및 인증번호")
	public BaseResponse<String> emailSend(Locale locale ,@RequestParam("email") String email) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException,
			BadPaddingException,  MessagingException, IOException{
		String authKey;
		
		//이메일 인증 보내기
		//6자리 난수 인증번호 생성
        authKey = commonUtil.getKey(6);	        
		mailSendService.sendMail(email,authKey, "E", locale.getLanguage());			
		
		//이메일인증번호 저장 
		AuthNumberDomain authNumber = new AuthNumberDomain();
		authNumber.setEmail(CryptoUtil.encryptAES256(email, secretKey));
		authNumber.setAuthNumber(authKey);
		userService.emailNoInsert(authNumber);
						
		return new BaseResponse<>(authKey);
	}
	
	
	/**
	 * 이메일 중복체크
	 * @param     email
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getEamilCk")
	@ResponseBody
	@ApiOperation(value = "이메일 중복체크")
	public BaseResponse<Boolean>  getEamilCk(@RequestParam("email") String email) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		
		int emailCount = userService.getEamilCk(CryptoUtil.encryptAES256(email, secretKey)); 
		Boolean result;
		
		if(emailCount > 0) {
			result = false;
		}else {
			result = true;
		}		
		return new BaseResponse<>(result);
	}
	
	/**
	 * 이메일 인증 전 상태 체크
	 * @param     email
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getEamilNoStatusCk")
	@ResponseBody
	@ApiOperation(value = "이메일 인증 전 상태 체크")
	public BaseResponse<Boolean>  getEamilNoStatusCk(@RequestParam("email") String email) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		
		int emailCount = userService.getEamilNoStatusCk(CryptoUtil.encryptAES256(email, secretKey)); 
		Boolean result;
		
		if(emailCount > 0) {
			//유저 테이블 삭제 처리 해야함 
			userService.userEmailDelete(CryptoUtil.encryptAES256(email, secretKey));
			result = false;
		}else {
			result = true;
		}		
		return new BaseResponse<>(result);
	}
	
	
	/**
	 * 이메일 인증번호 확인 
	 * @param     emailNo,email
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/getEmailNoConfirm")
	@ResponseBody
	@ApiOperation(value = "이메일 인증번호 확인")
	public BaseResponse<Boolean>  getEmailNoConfirm(
			@RequestParam("emailNo") String emailNo, 
			@RequestParam("email") String email) 
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		String authNumber = userService.getEamilNo(CryptoUtil.encryptAES256(email, secretKey));
		Boolean result;
				
		if(authNumber.equals(emailNo)) {
			//회원 상태 업데이트
			UserDomain user = new UserDomain();
			user.setEmail(email);
			user.setUserStatusCode("0202");
			userService.userTypeUpdate(user);
			
			result = true;
		}else {
			result = false;
		}		
		return new BaseResponse<>(result);
	} 
	
	
	/**
	 * 비밀번호 확인 
	 * @param     password, passwordOld
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/userPwCheck")
	@ResponseBody
	@ApiOperation(value = "비밀번호 확인")
	public BaseResponse<Boolean>  getUserPwCheck(
			HttpServletRequest request,
			@RequestParam("password") String password
			) throws NoSuchAlgorithmException{
		
		HttpSession session = request.getSession();	
		String passwordOld = (String) session.getAttribute("password");
		
		String shaPassword = CryptoUtil.sha256(password);
		Boolean result;
		
		if(shaPassword.equals(passwordOld)) {
			result = true;
		}else {
			result = false;
		}		
		return new BaseResponse<>(result);
	} 	
	
	/**
	 * 탈퇴사유 저장 
	 * @param     userId,email,leverReasonCode
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/accessHistoryInsert")
	@ResponseBody
	@ApiOperation(value = "탈퇴사유 저장")
	public BaseResponse<Integer> accessHistoryInsert(HttpServletRequest request,
			@RequestParam("frontMenuId") String frontMenuId){
				
		HttpSession session = request.getSession();
		HashMap<String, Object> paramData = new HashMap<>();	
				
			Calendar cal = Calendar.getInstance();
			int month = cal.get(Calendar.MONTH) + 1;
			
			if((String) session.getAttribute(USERID) != null) {
				paramData.put(USERID, (String) session.getAttribute(USERID));			
				paramData.put("frontMenuId", frontMenuId);		
				paramData.put("month", month);				
			}else {
				paramData.put(USERID, "UNKNOWN");			
				paramData.put("frontMenuId", frontMenuId);		
				paramData.put("month", month);			
			}
			userService.accessHistoryInsert(paramData);
			
		return new BaseResponse<>(1);
	}
	
	
	
	/**
	 * 사용자 상세 데이터 조회 
	 * @param   
     * @return
	 * @ exception 
	 * 
	 * */
	@PostMapping("/userDetail")
	@ResponseBody
	@ApiOperation(value = "사용자 상세 데이터 조회")
	public BaseResponse<UserDomain> userDetail(Locale locale, HttpServletRequest request)
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		HttpSession session = request.getSession();		
		String email = (String) session.getAttribute("sessionEmail");
		
        UserDomain userDomain = new UserDomain();
		
		//회원정보 조회
        UserDomain userDetail = null;
		userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
        if(email != null) {
        	userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
    		userDetail.setEmail(CryptoUtil.decryptAES256(userDetail.getEmail(), secretKey));
    		userDetail.setTell(CryptoUtil.decryptAES256(userDetail.getTell(), secretKey));
        }
        
        //설문조사 참여 여부 
        UserDomain surveyInfo = userService.getSurveyInfo(userDetail.getUserId());
		if(surveyInfo != null) {					
			userDetail.setIsComplete(surveyInfo.getIsComplete());
		}else {
			userDetail.setIsComplete("N");
		}
		
		//신규 알림 여부
		boolean isNewNotice = noticeRepository.confirmNewNotice(userDetail.getUserId());
		if(isNewNotice) {
			userDomain.setIsNewNotice("Y");
		}else {
			userDomain.setIsNewNotice("N");
		}
		
		userDomain.setUserDetail(userDetail);
		
		return new BaseResponse<>(userDomain);     
	}
	
	/**
	 * 파일 업로드 
	 * @param   
     * @return
	 * @throws StorageException 
	 * @ exception 
	 * 
	 * */
	@PostMapping("/upload")
	@ResponseBody
    public BaseResponse<String> uploadTest(MultipartHttpServletRequest mre, HttpServletRequest req) 
    		throws StorageException, IOException, URISyntaxException, InvalidKeyException{       
		 HttpSession session = req.getSession();
		 String userId = (String) session.getAttribute(USERID);
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
            
             HashMap<String, Object> paramData = new HashMap<>();
             paramData.put(USERID, userId);
             paramData.put(USERIMAGEPATH, imgURL);
             userService.userImageUpdate(paramData);
            
             //이미지 경로 url 저장 
             session.setAttribute(USERIMAGEPATH, imgURL);            
            
        } catch (MaxUploadSizeExceededException e) {
            // 파일사이즈초과되어도 에러메시지를 위해서 request 리턴하여 컨트롤러 메서드 호출되도록 한다.
        	return new BaseResponse<>(BaseResponseCode.ERROR, imgURL);
        }        
        return new BaseResponse<>(imgURL);
    }


	
}
