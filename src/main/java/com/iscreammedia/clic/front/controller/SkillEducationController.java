package com.iscreammedia.clic.front.controller;

import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.domain.SkillEducationDomain;
import com.iscreammedia.clic.front.domain.SkillEducationMappingDomain;
import com.iscreammedia.clic.front.service.SkillEducationService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
@RequestMapping("/education")
public class SkillEducationController {

	Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private SkillEducationService skillEducationService;
	
	@Autowired
	LocaleResolver localeResolver;
	
	/**
	 * 스킬 교육 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/list")
	@ApiOperation(value = "스킬 교육 조회 View")
	public String list() {
		
		return "skillEducation/educationList";
	}
	
	/**
	 * 스킬 교육 check<br>
	 * 
	 * @param     
     * @return Integer
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/check")
	@ApiOperation(value = "스킬 교육 등록 확인")
	@ResponseBody
	public BaseResponse<Integer> check() {
		int check = skillEducationService.educationCk();
	
		return new BaseResponse<>(check);
	}
	
	/**
	 * 스킬 이름 검색 List<br>
	 * 
	 * @param     locale
     * @return List
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/skillList")
	@ApiOperation(value = "스킬 이름 검색 목록")
	@ResponseBody
	public BaseResponse<List<SkillEducationMappingDomain>> skillList(Locale locale) {
		List<SkillEducationMappingDomain> skillList = skillEducationService.selectSkillList(locale);
		
		return new BaseResponse<>(skillList);
	}
	
	/**
	 * 스킬 교육 조회(페이징+검색)<br>
	 * 
	 * @param     locale
	 * @param     page
	 * @param     skillCode
	 * @param     examClassCode
     * @return List
	 * @ exception 예외사항
	 * 
	 * */
	@GetMapping("/scrollList")
	@ApiOperation(value = "스킬 교육 조회")
	@ResponseBody
	public BaseResponse<List<SkillEducationDomain>> scrollList(Locale locale, @RequestParam("page") int page, @RequestParam("skillCode") String skillCode, @RequestParam("examClassCode") String examClassCode) {
		int startNum;
		int endNum;
		
		if(page == 1) {
			startNum = 0;
			endNum = 10;
		} else {
			startNum = page+(9*(page-1))-1; //10개씩 가져오고 싶다면 19 -> 9로
			endNum = 10;
		}
		
		List<SkillEducationDomain> list = skillEducationService.selectScrollList(locale, startNum, endNum, skillCode, examClassCode);
		log.info("list: {}", list);
		
		log.info("startNum: {}", startNum);
		log.info("endNum: {}", endNum);
		
		return new BaseResponse<>(list);
	}

}
