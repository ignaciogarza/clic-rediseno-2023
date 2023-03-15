package com.iscreammedia.clic.front.controller;

import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.CertificateResultDomain;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.service.CertificateService;
import com.iscreammedia.clic.front.service.EvaluationService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class CertificateController {

	@Autowired
	private CertificateService certificateService;

	@Autowired
	private EvaluationService evaluationService;

	/**
	 * 증명서 테스트 결과 조회 View<br>
	 * 
	 * @param
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/resultList")
	@ApiOperation(value = "증명서 테스트 결과 목록 조회 View")
	public String resultList() {
		return "certificate/result-list";
	}

	/**
	 * 증명서 테스트 결과 조회 <br>
	 * 
	 * @param session
	 * @param locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/resultList/api")
	@ApiOperation(value = "Lista de resultados de pruebas de certificados")
	@ResponseBody
	public BaseResponse<List<Skill>> resultListApi(@SessionAttribute(name = "userId") String userId, Locale locale) {
		String local = locale.toLanguageTag();
		List<Skill> skillList = certificateService.getHaveSkillList(locale, userId, local);

		for (int i = 0; i < skillList.size(); i++) {
			Date updatedDate = skillList.get(i).getUpdatedDate();
			SimpleDateFormat format = new SimpleDateFormat("dd.MM.yyyy");
			skillList.get(i).setFormateUpdatedDate(format.format(updatedDate));
		}

		return new BaseResponse<>(skillList);
	}

	/**
	 * 증명서 테스트 결과 상세 조회 View<br>
	 * 
	 * @param
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/result")
	@ApiOperation(value = "증명서 테스트 결과 상세 조회 View")
	public String result() {
		return "certificate/result";
	}

	/**
	 * 증명서 테스트 결과 상세 조회<br>
	 * 
	 * @param skillCode
	 * @param examClassCode
	 * @param session
	 * @param locale
	 * @return CertificateResultDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/result/api")
	@ApiOperation(value = "증명서 테스트 결과 상세 조회")
	@ResponseBody
	public BaseResponse<CertificateResultDomain> resultApi(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@SessionAttribute(name = "userId") String userId,
			Locale locale) {
		CertificateResultDomain cert = new CertificateResultDomain();
		cert.setSkill(evaluationService.getSkill(locale, userId, skillCode, examClassCode));
		cert.setExamResult(evaluationService.getExamResult(locale, userId, skillCode, examClassCode));

		return new BaseResponse<>(cert);
	}

	/**
	 * 증명서 뱃지 조회 View<br>
	 * 
	 * @param
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/badgeList")
	@ApiOperation(value = "증명서 뱃지 목록 조회 View")
	public String badgeList() {
		return "certificate/badge-list";
	}

	/**
	 * 증명서 뱃지 조회 <br>
	 * 
	 * @param session
	 * @param locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/badgeList/api")
	@ApiOperation(value = "증명서 뱃지 목록 조회")
	@ResponseBody
	public BaseResponse<List<Skill>> badgeListApi(@SessionAttribute(name = "userId") String userId, Locale locale) {
		List<Skill> skillList = evaluationService.getSkillList(locale, userId);

		return new BaseResponse<>(skillList);
	}

	/**
	 * 증명서 뱃지 상세 조회 View<br>
	 * 
	 * @param
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/badge")
	@ApiOperation(value = "증명서 뱃지 상세 조회 View")
	public String badge() {
		return "certificate/badge";
	}

	/**
	 * 증명서 뱃지 상세 조회 <br>
	 * 
	 * @param skillCode
	 * @param examClassCdoe
	 * @param session
	 * @param locale
	 * @return Skill
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/cert/badge/api")
	@ApiOperation(value = "증명서 뱃지 상세 조회")
	@ResponseBody
	public BaseResponse<Skill> badgeApi(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@SessionAttribute(name = "userId") String userId,
			Locale locale) {
		Skill skill = evaluationService.getSkill(locale, userId, skillCode, examClassCode);

		return new BaseResponse<>(skill);
	}

}
