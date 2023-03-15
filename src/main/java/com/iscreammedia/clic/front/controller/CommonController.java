package com.iscreammedia.clic.front.controller;

import java.io.IOException;
import java.util.Locale;

import javax.mail.MessagingException;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.ApiList;
import com.iscreammedia.clic.front.domain.ContactUs;
import com.iscreammedia.clic.front.domain.Faq;
import com.iscreammedia.clic.front.domain.Terms;
import com.iscreammedia.clic.front.service.FaqService;
import com.iscreammedia.clic.front.service.MailSendService;
import com.iscreammedia.clic.front.service.TemplateMailService;
import com.iscreammedia.clic.front.service.TermsService;

import io.swagger.annotations.ApiOperation;

@Controller
public class CommonController {

	@Autowired
	private FaqService          faqService;
	@Autowired
	private TermsService        termsService;
	@Autowired
	private TemplateMailService templateMailService;
	
	@Autowired
	private MailSendService mailSendService;	


	/**
	 * 이용약관 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/common/terms-and-conditions")
	@ApiOperation(value = "이용약관 상세 조회 View")
	public String termsAndConditions() {

		return "main/terms";
	}
	
	/**
	 * 이용약관 조회 <br>
	 * 
	 * @param     locale
	 * @return Terms
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/common/terms-and-conditions/api")
	@ApiOperation(value = "이용약관 상세 조회")
	@ResponseBody
	public BaseResponse<Terms> termsAndConditionsApi(Locale locale) {
		String code = "0901";
		Terms terms = termsService.getTerms(locale, code);
		terms.setCode(code);
		return new BaseResponse<> (terms);
	}

	/**
	 * 개인정보 취급 방침 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/common/privacy-policy")
	@ApiOperation(value = "개인정보 취급 방침 상세 조회 View")
	public String privacyPolicy() {
		
		return "main/terms";
	}
	
	/**
	 * 개인정보 취급 방침 조회<br>
	 * 
	 * @param     locale
	 * @return Terms
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/common/privacy-policy/api")
	@ApiOperation(value = "개인정보 취급 방침 상세 조회")
	@ResponseBody
	public BaseResponse<Terms> privacyPolicyApi(Locale locale) {
		String code = "0902";
		Terms terms = termsService.getTerms(locale, code);
		terms.setCode(code);
		
		return new BaseResponse<>(terms);
	}

	
	/**
	 * contact-us 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/common/contact-us")
	@ApiOperation(value = "contact-us 조회 View")
	public String contactUs() {
		
		return "main/contact-us";
	}

	/**
	 * contact-us 메일 보내기<br>
	 * 
	 * @param     param
	 * @param     locale
	 * @return 
	 * @ exception 예외사항
	 * 
	 */
	@ResponseBody
	@PostMapping("/common/contact-us/send")
	@ApiOperation(value = "contact-us 메일 전송")
	public BaseResponse<Integer> contactUs(ContactUs param, Locale locale) throws IOException, MessagingException{
		String fromName = param.getName() + " " + param.getLastName();
		String fromEmail = param.getEmail();
		String subject = param.getSubject();
		String contents = param.getContents();
		
		mailSendService.sendMailContact(fromName, fromEmail, subject, contents);
		return new BaseResponse<>(1);
	}

	/**
	 * FAQ 조회 View<br>
	 * 
	 * @param     code
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/common/faq")
	@ApiOperation(value = "FAQ 목록 조회 View")
	public String faq(@RequestParam(name = "code", defaultValue = "2501") String code) {
	
		return "main/faq";
	}

	/**
	 * FAQ 조회<br>
	 * 
	 * @param     code
	 * @param     offset
	 * @param     limit
	 * @param     locale
	 * @return 
	 * @ exception 예외사항
	 * 
	 */
	@ResponseBody
	@GetMapping("/common/faq/list")
	@ApiOperation(value = "FAQ 목록 조회")
	public BaseResponse<ApiList<Faq>> faq(
			@RequestParam(name = "code", defaultValue = "2501") String code,
			@RequestParam(name = "offset", defaultValue = "0") int offset,
			@RequestParam(name = "limit", defaultValue = "20") int limit,
			Locale locale
	) {
		
		return new BaseResponse<>(faqService.getFaqList(locale, code, offset, limit));
	}
}
