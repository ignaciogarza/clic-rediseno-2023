package com.iscreammedia.clic.front.controller;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.security.InvalidAlgorithmParameterException;
import java.security.InvalidKeyException;
import java.security.NoSuchAlgorithmException;
import java.util.Calendar;
import java.util.HashMap;
import java.util.Locale;
import java.util.UUID;

import javax.crypto.BadPaddingException;
import javax.crypto.IllegalBlockSizeException;
import javax.crypto.NoSuchPaddingException;
import javax.mail.MessagingException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;
import org.json.simple.parser.ParseException;
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

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.service.MailSendService;
import com.iscreammedia.clic.front.service.UserService;
import com.iscreammedia.clic.front.util.CryptoUtil;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/login")
public class LoginController {
	
Logger logger = LoggerFactory.getLogger(getClass());
	
	@Autowired
	private UserService userService;
	
	@Autowired
	private MailSendService mailSendService;	
	
	
	//@Value("${spring.redis.sessionTime}")
	//private int sessionTime;
	
	@Value("${SecretKey}")
	private String secretKey;
	
	private static final String LOGINURL = "login/login";
	private static final String USERID = "userId";
	private static final String SESSIONEMAIL = "sessionEmail";
	private static final String SESSIONDATA = "sessionData";
	
	/**
	 * 로그인 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/login")
	@ApiOperation(value = "로그인 View")
	public String login(Model model){
		return LOGINURL;
	}
			
	/**
	 * 로그인 처리
	 * @param   
     * @return
	 * @throws ParseException 
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/signIn")
	@ResponseBody
	@ApiOperation(value = "로그인 처리")
	public BaseResponse<String>  signInSubmit(@RequestParam("email") String email, @RequestParam("password") String password, 
			HttpServletResponse response, HttpServletRequest request)	
					throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException, UnsupportedEncodingException, ParseException{
		
		HttpSession session = request.getSession();
		String result = null;
		
			//회원정보 조회 			
			UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
			
			
			if(userDetail != null) {
				//오늘날짜에 회원이 로그인 했는지 여부
				int lastLoginCk = userService.lastLoginDateCk(userDetail.getUserId());
				
				log.info("@@@@@마지막 로그인 체크: {}", lastLoginCk);
				
				//오늘날짜에 회원이 로그인 안했으면 로그인 했다는 접근 이력 데이터 추가
				if(lastLoginCk == 0) {
					//사용자 메뉴접근 이력 저장  
					HashMap<String, Object> paramData = new HashMap<>();	
					
					//월 세팅 
					Calendar cal = Calendar.getInstance();
					int month = cal.get(Calendar.MONTH) + 1;				
					
					//uri 세팅 
					String uri = request.getRequestURI();
					String[] urlDate = uri.split("/");
					String frontMenuUri = "/"+urlDate[1];
					
					//os 타입 세팅 
					String userAgent = request.getHeader("user-agent");
					boolean mobile1 = userAgent.matches( ".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
					boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*"); 

					String osType = null;
					if (mobile1 || mobile2) {
					    osType = "M";
					} else {
					    osType = "P";
					}
					
					paramData.put(USERID, userDetail.getUserId());	
					paramData.put("frontMenuUri", frontMenuUri);
					paramData.put("month", month);			
					paramData.put("osType", osType);
					
					log.info("@@@@@paramData: {}", paramData);
					
					userService.accessHistoryInsert(paramData);
				}
				
				//로그인 시간 업데이트
				userService.loginDateUpdate(userDetail.getUserId());
				userDetail.setJobId(CryptoUtil.encryptAES256(userDetail.getJobId(), secretKey));
				userDetail.setJobNameEng(CryptoUtil.encryptAES256(userDetail.getJobNameEng(), secretKey));
				userDetail.setJobNameSpa(CryptoUtil.encryptAES256(userDetail.getJobNameSpa(), secretKey));	
				
				
				String userId = userDetail.getUserId();
				String sessionEmail = userDetail.getEmail();				
				String countryCode = userDetail.getCountryCode();
				String userImagePath = userDetail.getUserImagePath();				
				String passwordIsEarly = userDetail.getPasswordIsEarly();
				String userTypeCode = userDetail.getUserTypeCode();
				String fullName = userDetail.getName() + " "+userDetail.getFirstName();		
				String passwords = userDetail.getPassword();				
				//String jobNameEng = CryptoUtil.encryptAES256(userDetail.getJobNameEng(), secretKey);
				//String jobNameSpa = CryptoUtil.encryptAES256(userDetail.getJobNameSpa(), secretKey);
				//String jobId = userDetail.getJobId();
			
//				String sessionJson = "{\"userId\" : \""+userId+"\", \"email\" : \""+sessionEmail+"\", \"fullName\" : \""+fullName+"\" , "
//						+ "\"jobNameEng\" : \""+jobNameEng+"\" , \"jobNameSpa\" : \""+jobNameSpa+"\" , \"countryCode\" : \""+countryCode+"\" , "
//						+ "\"userImagePath\" : \""+userImagePath+"\" , \"jobId\" : \""+jobId+"\" , \"passwordIsEarly\" : \""+passwordIsEarly+"\" , "
//						+ "\"userTypeCode\" : \""+userTypeCode+"\"}"; 
				
				String sessionJson = "{\"userId\" : \""+userId+"\", \"email\" : \""+sessionEmail+"\", \"fullName\" : \""+fullName+"\" , "
						+ "\"countryCode\" : \""+countryCode+"\" , \"userImagePath\" : \""+userImagePath+"\" , "
						+ "\"passwordIsEarly\" : \""+passwordIsEarly+"\" , \"userTypeCode\" : \""+userTypeCode+"\" , \"password\" : \""+passwords+"\"}";
					
				//세션 db 삭제 처리 
				userService.loginHistoryDelete(userId);
				
				//세션 정보 db 저장 	
				HashMap<String, Object> paramData = new HashMap<>();
				paramData.put(USERID, userId);	
				paramData.put(SESSIONDATA, sessionJson);				
				userService.loginHistoryInsert(paramData);
				
				//세션 정보 db 조회 
				UserDomain loginHistory = userService.getLoginHistory(userId);
				String sessionData = loginHistory.getSessionData();
				
				// JSONParser로 JSONObject로 변환        
				JSONParser parser = new JSONParser();        
				JSONObject jsonObject = (JSONObject) parser.parse(sessionData);         
				
				//세션 정보 저장 
				session.setMaxInactiveInterval(1800);	//30분					
				session.setAttribute(USERID, (String) jsonObject.get(USERID));
				session.setAttribute(SESSIONEMAIL, CryptoUtil.decryptAES256((String) jsonObject.get("email"), secretKey));
				session.setAttribute("fullName", (String) jsonObject.get("fullName"));
				session.setAttribute("password", (String) jsonObject.get("password"));				
				session.setAttribute("countryCode", (String) jsonObject.get("countryCode"));
				session.setAttribute("userImagePath", (String) jsonObject.get("userImagePath"));				
				session.setAttribute("passwordIsEarly", (String) jsonObject.get("passwordIsEarly"));
				session.setAttribute("userTypeCode", (String) jsonObject.get("userTypeCode"));
				
				//session.setAttribute("jobNameEng", CryptoUtil.decryptAES256((String) jsonObject.get("jobNameEng"), secretKey));
				//session.setAttribute("jobNameSpa", CryptoUtil.decryptAES256((String) jsonObject.get("jobNameSpa"), secretKey));
				//session.setAttribute("jobId", CryptoUtil.decryptAES256((String) jsonObject.get("jobId"), secretKey));
				
				UserDomain surveyInfo = userService.getSurveyInfo(userDetail.getUserId());
				if(surveyInfo != null) {					
					session.setAttribute("isComplete", surveyInfo.getIsComplete());
				}else {	
					session.setAttribute("isComplete", "N");
				}
				
				
				String shaPassword = CryptoUtil.sha256(password);
				if(shaPassword.equals(userDetail.getPassword())) {
					result = "1";
					
					if(userDetail.getUserStatusCode().equals("0204")) {
						result = "2";
					}				
					//정부 관계자 회원 일대 데시보드 화면으로 이동 
					if(userDetail.getUserTypeCode().equals("0102")) {
						result = "4";
					}
				}				
				
			}else {
				userService.userEmailDelete(CryptoUtil.encryptAES256(email, secretKey));
				result = "5";
			}		
		
		return new BaseResponse<>(result);
	}
	
	/**
	 * 로그아웃 처리
	 * @param   
     * @return
	 * @throws IOException 
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/signOut")	
	@ApiOperation(value = "로그아웃 처리")
	public String  signOut(HttpServletRequest request, HttpServletResponse response, @RequestParam("email") String email) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException, IOException{
		
		//회원정보 조회 
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
		
		//세션 db 삭제 처리 
		userService.loginHistoryDelete(userDetail.getUserId());
								
		//세션 삭제 
		HttpSession session = request.getSession();
		session.invalidate();		
		
		return LOGINURL;
	}
	
	
	@PostMapping("/signOutDash")
	@ResponseBody
	@ApiOperation(value = "로그아웃 처리")
	public BaseResponse<String>  signOutDash(HttpServletRequest request, 
			HttpServletResponse response, @RequestParam("email") String email) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,IllegalBlockSizeException, BadPaddingException{
		
		//회원정보 조회 
		UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));
		
		//세션 db 삭제 처리 
		userService.loginHistoryDelete(userDetail.getUserId());
		
		//세션 삭제 
		HttpSession session = request.getSession();
		session.invalidate();
		
		return new BaseResponse<>("1");
	}
	
	/**
	 * 비밀번호찾기 View
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/passwordFindView")
	@ApiOperation(value = "비밀번호찾기 View")
	public String passwordFindView(Model model){		
		return "login/passwordFind";
	}
	
	
	/**
	 * 비밀번호찾기 이메일 전송 
	 * @param   
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	@PostMapping("/emailPasswordSend")
	@ResponseBody
	@ApiOperation(value = "비밀번호찾기 이메일 전송 ")
	public BaseResponse<String> emailPasswordSend(Locale locale , @RequestParam("email") String email) 
			throws NoSuchAlgorithmException, NoSuchPaddingException, InvalidKeyException, InvalidAlgorithmParameterException,
			IllegalBlockSizeException, BadPaddingException, MessagingException, IOException{
		String shaPassword = null;
		
			//임시
			String password = UUID.randomUUID().toString().replace("-", ""); 
			password = password.substring(0, 10); //uuid를 앞에서부터 10자리 잘라줌.	
			
			shaPassword = CryptoUtil.sha256(password);
			mailSendService.sendMail(email,password,"P", locale.getLanguage());
			
			//임시 비밀번호 업데이트 
            UserDomain userDetail = userService.getUserDetail(CryptoUtil.encryptAES256(email, secretKey));  
			userDetail.setPassword(shaPassword);
			userDetail.setPasswordIsEarly("Y");
			userService.userPwUpdate(userDetail);
		
		return new BaseResponse<>(shaPassword);
	}
}
