package com.iscreammedia.clic.front.controller;

import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttribute;

import com.iscreammedia.clic.front.configuration.exception.NotFoundException;
import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.configuration.http.BaseResponseCode;
import com.iscreammedia.clic.front.domain.CertificateResultDomain;
import com.iscreammedia.clic.front.domain.ExamAnswer;
import com.iscreammedia.clic.front.domain.ExamProgressStatus;
import com.iscreammedia.clic.front.domain.ExamQuestion;
import com.iscreammedia.clic.front.domain.ExamQuestionTypeCode;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.SkillProgressStatusCode;
import com.iscreammedia.clic.front.service.EvaluationService;

import io.swagger.annotations.ApiOperation;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Controller
public class EvaluationController {

	@Autowired
	private EvaluationService evaluationService;
	
	private static final String SKILL = "skill";

	/**
	 * 평가 테스트 조회 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/eval/list")
	@ApiOperation(value = "평가 테스트 목록 조회 View")
	public String eval() {
		return "evaluate/eval";
	}
	
	/**
	 * 평가 테스트 조회<br>
	 * 
	 * @param     session
	 * @param     locale
	 * @return List
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/eval/list/api")
	@ApiOperation(value = "평가 테스트 목록 조회")
	@ResponseBody
	public BaseResponse<List<Skill>> evalApi(@SessionAttribute(name = "userId") String userId, Locale locale) {
		List<Skill> skillList = evaluationService.getSkillList(locale, userId);
		
		return new BaseResponse<>(skillList);
	}

	/**
	 * 평가 테스트 상세 조회(테스트 안내/테스트 결과) View<br>
	 * 
	 * @param     skillCode
	 * @param     examClassCode
	 * @param     session
	 * @param     locale
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/eval/skill")
	@ApiOperation(value = "평가 테스트 상세 조회 View(테스트 안내/테스트 결과)")
	public String skill(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {

		Skill data = evaluationService.getSkill(locale, userId, skillCode, examClassCode);
		SkillProgressStatusCode progress = data.getProgressStatusCode();
		if(progress == SkillProgressStatusCode.NOT_TESTED || progress == SkillProgressStatusCode.SELF_EXAM_WAIT
				|| progress == SkillProgressStatusCode.SELF_EXAM_TAKING
				|| progress == SkillProgressStatusCode.SELF_EXAM_TIME_OUT
				|| progress == SkillProgressStatusCode.SKILL_EXAM_WAIT
				|| progress == SkillProgressStatusCode.SKILL_EXAM_TAKING
				|| progress == SkillProgressStatusCode.SKILL_EXAM_TIME_OUT
		) {
			if(progress == SkillProgressStatusCode.NOT_TESTED) {
				SkillProgressStatusCode progressStatusCode = SkillProgressStatusCode.SELF_EXAM_WAIT;
				evaluationService.updateStatus(locale, userId, skillCode, examClassCode, progressStatusCode);
				data.setProgressStatusCode(progressStatusCode);
			}
			return "evaluate/skill";
		}
		else {
			return "evaluate/result";
		}
	}
	
	/**
	 * 평가 테스트 상세 조회(테스트 안내/테스트 결과)<br>
	 * 
	 * @param     skillCode
	 * @param     examClassCode
	 * @param     session
	 * @param     locale
	 * @return CertificateResultDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/eval/skill/api")
	@ApiOperation(value = "평가 테스트 상세 조회(테스트 안내/테스트 결과)")
	@ResponseBody
	public BaseResponse<CertificateResultDomain> skillApi(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {

		Skill data = evaluationService.getSkill(locale, userId, skillCode, examClassCode);
		SkillProgressStatusCode progress = data.getProgressStatusCode();
		if(progress == SkillProgressStatusCode.NOT_TESTED || progress == SkillProgressStatusCode.SELF_EXAM_WAIT
				|| progress == SkillProgressStatusCode.SELF_EXAM_TAKING
				|| progress == SkillProgressStatusCode.SELF_EXAM_TIME_OUT
				|| progress == SkillProgressStatusCode.SKILL_EXAM_WAIT
				|| progress == SkillProgressStatusCode.SKILL_EXAM_TAKING
				|| progress == SkillProgressStatusCode.SKILL_EXAM_TIME_OUT
		) {
			if(progress == SkillProgressStatusCode.NOT_TESTED) {
				SkillProgressStatusCode progressStatusCode = SkillProgressStatusCode.SELF_EXAM_WAIT;
				evaluationService.updateStatus(locale, userId, skillCode, examClassCode, progressStatusCode);
				data.setProgressStatusCode(progressStatusCode);
			}
			CertificateResultDomain cert = new CertificateResultDomain();
			cert.setSkill(evaluationService.getSkill(locale, userId, skillCode, examClassCode));
			cert.setExam(evaluationService.getExam(locale, userId, skillCode, examClassCode, data.getProgressStatusCode()));
			return new BaseResponse<>(cert);
		}
		else {
			CertificateResultDomain cert = new CertificateResultDomain();
			cert.setSkill(evaluationService.getSkill(locale, userId, skillCode, examClassCode));
			cert.setExamResult(evaluationService.getExamResult(locale, userId, skillCode, examClassCode));
			return new BaseResponse<>(cert);
		}
	}

	/**
	 * 평가 테스트 결과 pdf 다운로드 View<br>
	 * 
	 * @param     
	 * @return String
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/eval/result-pdf-download")
	@ApiOperation(value = "평가 테스트 결과 PDF 다운로드 View")
	public String resultPdfDownload() {
		return "result/result-pdf-download";
	}
	
	/**
	 * 평가 테스트 결과 pdf 다운로드<br>
	 * 
	 * @param     skillCode
	 * @param     examClassCode
	 * @param     session
	 * @param     locale
	 * @return CertificateResultDomain
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/eval/result-pdf-download/api")
	@ApiOperation(value = "평가 테스트 결과 PDF 다운로드 화면 조회")
	@ResponseBody
	public BaseResponse<CertificateResultDomain> resultPdfDownloadApi(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {
		CertificateResultDomain cert = new CertificateResultDomain();
		cert.setSkill(evaluationService.getSkill(locale, userId, skillCode, examClassCode));
		cert.setExamResult(evaluationService.getExamResult(locale, userId, skillCode, examClassCode));
		
		return new BaseResponse<>(cert);
	}

	/**
	 * 튜토리얼 / 문제 팝업 View<br>
	 * @param type
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param no            문제 번호
	 * @param param
	 * @param session
	 * @return String
	 * @ exception 예외사항
	 */
	@PostMapping("/eval/exam/{type}/popup")
	@ApiOperation(value = "튜토리얼/문제/문제평가 조회 View", notes="type: tutorial, self, skill")
	public String popupExam(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@RequestParam(name = "no", defaultValue = "1") Integer no,
			@PathVariable(name = "type") String type,
			ExamAnswer param,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {
		log.info("popupExam :: param :: {}", param);

		ExamQuestion data = null;
		Skill skill = evaluationService.getSkill(locale, userId, skillCode, examClassCode);

		// 튜토리얼
		if(type.equals("tutorial")) {
			return "evaluate/popup/tutorial";
		}
		// 자가 시험
		else if(type.equals("self")) {
			if(SkillProgressStatusCode.SELF_EXAM_WAIT == skill.getProgressStatusCode()
			|| SkillProgressStatusCode.SELF_EXAM_TAKING == skill.getProgressStatusCode()) {
				data = evaluationService.getSelfExamQuestion(locale, userId, skillCode, examClassCode, type, no, param, skill);
			}
			else {
				return "evaluate/popup/q_msg";
			}

		}
		// 기술 시험
		else if(type.equals(SKILL)) {
			if(SkillProgressStatusCode.SKILL_EXAM_WAIT == skill.getProgressStatusCode()
			|| SkillProgressStatusCode.SKILL_EXAM_TAKING == skill.getProgressStatusCode()) {
				data = evaluationService.getSkillExamQuestion(locale, userId, skillCode, examClassCode, type, no, param, skill);
			}
			else {
				return "evaluate/popup/q_msg";
			}
		}

		if(data == null) {
			return "evaluate/popup/evaluation";
		}
		else {
			if(ExamQuestionTypeCode.ANSWER == data.getQuestionTypeCode()) {
				return "evaluate/popup/q_answer";
			}
			else if(ExamQuestionTypeCode.CHOICE == data.getQuestionTypeCode()) {
				return "evaluate/popup/q_choice";
			}
			else if(ExamQuestionTypeCode.MULTI_CHOICE == data.getQuestionTypeCode()) {
				return "evaluate/popup/q_multi_choice";
			}
			else if(ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {
				return "evaluate/popup/q_line_drawing";
			}
			else if(ExamQuestionTypeCode.SCALE == data.getQuestionTypeCode()) {
				return "evaluate/popup/q_scale";
			}
			else {
				throw new NotFoundException();
			}
		}
	}
	
	/**
	 * 튜토리얼 / 문제 팝업<br>
	 * @param type
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param no            문제 번호
	 * @param param
	 * @param session
	 * @return 
	 * @ exception 예외사항
	 */
	@PostMapping("/eval/exam/{type}/popup/api")
	@ApiOperation(value = "튜토리얼/문제/문제평가 조회", notes="type: tutorial, self, skill")
	@ResponseBody
	public BaseResponse<Object> popupExamApi(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@RequestParam(name = "no", defaultValue = "1") Integer no,
			@PathVariable(name = "type") String type,
			ExamAnswer param,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {
		log.info("popupExam :: param :: {}", param);

		ExamQuestion data = null;
		Skill skill = evaluationService.getSkill(locale, userId, skillCode, examClassCode);

		// 튜토리얼
		if(type.equals("tutorial")) {
			return new BaseResponse<>(skill);
		}
		// 자가 시험
		else if(type.equals("self")) {
			if(SkillProgressStatusCode.SELF_EXAM_WAIT == skill.getProgressStatusCode()
			|| SkillProgressStatusCode.SELF_EXAM_TAKING == skill.getProgressStatusCode()) {
				data = evaluationService.getSelfExamQuestion(locale, userId, skillCode, examClassCode, type, no, param, skill);
			}
			else {
				String msgCode = "error.msg.1";
				return new BaseResponse<>(msgCode);
			}

		}
		// 기술 시험
		else if(type.equals(SKILL)) {
			if(SkillProgressStatusCode.SKILL_EXAM_WAIT == skill.getProgressStatusCode()
			|| SkillProgressStatusCode.SKILL_EXAM_TAKING == skill.getProgressStatusCode()) {
				data = evaluationService.getSkillExamQuestion(locale, userId, skillCode, examClassCode, type, no, param, skill);
			}
			else {
				String msgCode = "error.msg.1";
				return new BaseResponse<>(msgCode);
			}
		}

		if(data == null) {
			return new BaseResponse<>(data);
		}
		else {
			if(ExamQuestionTypeCode.ANSWER == data.getQuestionTypeCode()) {
				return new BaseResponse<>(data);
			}
			else if(ExamQuestionTypeCode.CHOICE == data.getQuestionTypeCode()) {
				return new BaseResponse<>(data);
			}
			else if(ExamQuestionTypeCode.MULTI_CHOICE == data.getQuestionTypeCode()) {
				return new BaseResponse<>(data);
			}
			else if(ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {
				return new BaseResponse<>(data);
			}
			else if(ExamQuestionTypeCode.SCALE == data.getQuestionTypeCode()) {
				return new BaseResponse<>(data);
			}
			else {
				throw new NotFoundException();
			}
		}
	}

	/**
	 * 테스트 대기 상태<br>
	 * @param type
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param session
	 * @return 
	 * @ exception 예외사항
	 */
	@ResponseBody
	@GetMapping("/eval/{type}/status/wait")
	@ApiOperation(value = "테스트 대기 상태", notes="type: self, skill")
	public BaseResponse<Object> updateSkillStatusWait(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@PathVariable(name = "type") String type,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {
		log.info("updateSkillStatus :: skillCode   :: {}", skillCode, examClassCode);

		if(type.equals("self")) {
			evaluationService.updateStatus(locale, userId, skillCode, examClassCode,
					SkillProgressStatusCode.SELF_EXAM_WAIT);
		}
		// 기술 시험
		else if(type.equals(SKILL)) {
			evaluationService.updateStatus(locale, userId, skillCode, examClassCode,
					SkillProgressStatusCode.SKILL_EXAM_WAIT);
		}
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	/**
	 * 테스트 타임아웃 상태<br>
	 * @param type
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param session
	 * @return 
	 * @ exception 예외사항
	 */
	@ResponseBody
	@GetMapping("/eval/{type}/status/timeout")
	@ApiOperation(value = "테스트 타임아웃 상태", notes="type: self, skill")
	public BaseResponse<Object> updateSkillStatusTimeout(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@PathVariable(name = "type") String type,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {
		log.info("updateSkillStatus :: skillCode   :: {}", skillCode, examClassCode);

		evaluationService.confirmPass(locale, userId, skillCode, examClassCode);

		if(type.equals("self")) {
			evaluationService.updateStatus(locale, userId, skillCode, examClassCode,
					SkillProgressStatusCode.SELF_EXAM_TIME_OUT);
		}
		// 기술 시험
		else if(type.equals(SKILL)) {
			evaluationService.updateStatus(locale, userId, skillCode, examClassCode,
					SkillProgressStatusCode.SKILL_EXAM_TIME_OUT);
		}
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	/**
	 * 문제 평가<br>
	 * @param type
	 * @param skillCode              스킬 코드
	 * @param examClassCode          문제 난이도
	 * @param examEvaluation         시험 평가
	 * @param examEvaluationContents 시험 평가 내용
	 * @param session
	 * @return
	 * @ exception 예외사항
	 */
	@ResponseBody
	@PostMapping("/eval/evaluation/{type}")
	@ApiOperation(value = "문제 평가 등록", notes="type: self, skill")
	public BaseResponse<String> examEvaluation(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@RequestParam(name = "examEvaluation") Integer examEvaluation,
			@RequestParam(name = "examEvaluationContents") String examEvaluationContents,
			@PathVariable(name = "type") String type,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {
		ExamProgressStatus param = new ExamProgressStatus();
		param.setUserId(userId);
		param.setSkillCode(skillCode);
		param.setExamClassCode(examClassCode);
		param.setExamEvaluation(examEvaluation);
		param.setExamEvaluationContents(examEvaluationContents);

		// 자가 시험
		if(type.equals("self")) {
			return evaluationService.updateSelfExamEvaluation(locale, param);
		}
		// 기술 시험
		else if(type.equals(SKILL)) {
			return evaluationService.updateSkillExamEvaluation(locale, param);
		}

		return new BaseResponse<>(BaseResponseCode.ERROR, "실패");
	}

	/**
	 * 친구 목록<br>
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param searchKeyword
	 * @param offset
	 * @param limit
	 * @param session
	 * @return
	 * @ exception 예외사항
	 */
	@ResponseBody
	@GetMapping("/eval/friend/list")
	@ApiOperation(value = "친구 목록 조회")
	public BaseResponse<Object> examEvaluation(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@RequestParam(name = "searchKeyword") String searchKeyword,
			@RequestParam(name = "offset", defaultValue = "0") int offset,
			@RequestParam(name = "limit", defaultValue = "30") int limit,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {

		return new BaseResponse<>(evaluationService.getFriendList(locale, userId, skillCode, examClassCode,
				searchKeyword, offset, limit));
	}

	/**
	 * 인증 요청<br>
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param friendId
	 * @param session
	 * @return
	 * @ exception 예외사항
	 */
	@ResponseBody
	@PostMapping("/eval/auth/request")
	@ApiOperation(value = "스킬 인증 요청")
	public BaseResponse<Object> authRequest(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@RequestParam(name = "friendId") String friendId,
			@SessionAttribute(name = "userId") String userId,
			Locale locale
	) {

		evaluationService.insertSkillFriendAuth(locale, userId, friendId, skillCode, examClassCode);
		return new BaseResponse<>();
	}

	/**
	 * 인증 요청 취소<br>
	 * @param locale
	 * @param skillCode     스킬 코드
	 * @param examClassCode 문제 난이도
	 * @param friendId
	 * @param session
	 * @return
	 * @ exception 예외사항
	 */
	@ResponseBody
	@PostMapping("/eval/auth/cancel")
	@ApiOperation(value = "스킬 인증 요청 취소")
	public BaseResponse<Object> authCancel(
			@RequestParam(name = "skill") String skillCode,
			@RequestParam(name = "class") String examClassCode,
			@RequestParam(name = "friendId") String friendId,
			@SessionAttribute(name = "userId") String userId
	) {

		evaluationService.deleteSkillFriendAuth(userId, friendId, skillCode, examClassCode);
		return new BaseResponse<>();
	}
	
	/**
	 * DB 현재시간 가져오기<br>
	 * @return
	 * @ exception 예외사항
	 */
	@ResponseBody
	@GetMapping("/eval/now")
	@ApiOperation(value = "DB 현재시간 가져오기")
	public BaseResponse<Date> getNowTime() {
		Date nowTime = evaluationService.getNowTime();
		return new BaseResponse<>(nowTime);
	}
	
}
