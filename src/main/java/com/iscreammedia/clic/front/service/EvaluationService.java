package com.iscreammedia.clic.front.service;

import java.util.ArrayList;
import java.util.Collections;
import java.util.Date;
import java.util.List;
import java.util.Locale;

import org.apache.commons.lang3.StringUtils;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.MessageSource;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.iscreammedia.clic.front.configuration.exception.DataException;
import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.configuration.http.BaseResponseCode;
import com.iscreammedia.clic.front.domain.Exam;
import com.iscreammedia.clic.front.domain.ExamAnswer;
import com.iscreammedia.clic.front.domain.ExamExample;
import com.iscreammedia.clic.front.domain.ExamMeasure;
import com.iscreammedia.clic.front.domain.ExamProgressStatus;
import com.iscreammedia.clic.front.domain.ExamQuestion;
import com.iscreammedia.clic.front.domain.ExamQuestionCnt;
import com.iscreammedia.clic.front.domain.ExamQuestionTypeCode;
import com.iscreammedia.clic.front.domain.ExamResult;
import com.iscreammedia.clic.front.domain.HaveSkill;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.SkillFriendAuth;
import com.iscreammedia.clic.front.domain.SkillFriendList;
import com.iscreammedia.clic.front.domain.SkillProgressStatus;
import com.iscreammedia.clic.front.domain.SkillProgressStatusCode;
import com.iscreammedia.clic.front.repository.EvaluationRepository;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class EvaluationService {

	@Autowired
	private EvaluationRepository evaluationRepository;

	@Autowired
	private NoticeService noticeService;

	@Autowired
	private MessageSource messageSource;
	
	private static final String ISNULL = ") is null";

	/**
	 * 스킬 목록 조회
	 * </p>
	 * 개인이 획득한 합격/뱃지 정보 포함
	 * @param locale
	 * @param userId
	 * @return
	 */
	public List<Skill> getSkillList(Locale locale, String userId) {

		return evaluationRepository.getSkillList(LanguageCode.getLanguage(locale), userId);
	}

	/**
	 * 스킬 상세 조회
	 * </p>
	 * 개인이 획득한 합격/뱃지 정보 포함
	 * @param locale
	 * @param userId
	 * @param skillCode
	 * @return
	 */
	public Skill getSkill(Locale locale, String userId, String skillCode, String examClassCode) {

		Skill data = evaluationRepository.getSkill(LanguageCode.getLanguage(locale), userId, skillCode, examClassCode);
		if(data == null) {
			throw new NullPointerException("skill(" + skillCode + ISNULL);
		}
		data.setCheckSkillBadgeObtain(
				checkSkillBadgeObtain(data.getBadgeObtainLevelCode(), data.getProgressStatusCode()));
		log.info("@@ progress : {}", data.getProgressStatusCode());

		return data;
	}

	/**
	 * 시험 결과 조회
	 * </p>
	 * @param locale
	 * @param userId
	 * @param skillCode
	 * @return
	 */
	public ExamResult getExamResult(Locale locale, String userId, String skillCode, String examClassCode) {
		LanguageCode language = LanguageCode.getLanguage(locale);

		ExamResult data = evaluationRepository.getExamResult(userId, skillCode, examClassCode);
		data.setDetailList(evaluationRepository.getExamResultDetailList(language, data.getSelfExamProgressId(),
				data.getSkillExamProgressId()));
		data.setAuthList(evaluationRepository.getAuthRequestList(language, userId, skillCode, examClassCode));
		return data;
	}

	/**
	 * 시험 정보 조회
	 * </p>
	 * @param locale
	 * @param userId
	 * @param skillCode
	 * @return
	 */
	public Exam getExam(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode,
			SkillProgressStatusCode progressStatusCode
	) {
		LanguageCode language = LanguageCode.getLanguage(locale);
		String progressLevel = progressStatusCode.getSkillProgressLevelCode();
		Exam data = null;
		if(SkillProgressStatusCode.SKILL_EXAM_WAIT.getSkillProgressLevelCode().equals(progressLevel)
				|| SkillProgressStatusCode.SELF_EXAM_PASS == progressStatusCode) {
			data = evaluationRepository.getSkillExam(language, userId, skillCode, examClassCode);
			if(data == null) {
				throw new NullPointerException("skill exam(" + skillCode + ISNULL);
			}
		}
		else if(SkillProgressStatusCode.SELF_EXAM_WAIT.getSkillProgressLevelCode().equals(progressLevel)) {
			data = evaluationRepository.getSelfExam(language, userId, skillCode, examClassCode);
			if(data == null) {
				throw new NullPointerException("self exam(" + skillCode + ISNULL);
			}
		}

		return data;
	}

	/**
	 * 자가 시험 문제 조회
	 * </p>
	 * @param locale
	 * @param userId
	 * @param skillCode
	 * @param type
	 * @param no
	 * @param answerParam
	 * @param skill
	 * @return
	 */
	@Transactional
	public ExamQuestion getSelfExamQuestion(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode,
			String type,
			int no,
			ExamAnswer answerParam,
			Skill skill
	) {
		LanguageCode language = LanguageCode.getLanguage(locale);

		ExamQuestionCnt questionCnt = evaluationRepository.confirmSelfExamQuestion(userId, skillCode, examClassCode);

		if(
				skill.getProgressStatusCode().getExamProgressStatusCode().equals("1401")
				&& questionCnt != null && questionCnt.getQuestionCnt() > 0
		) {
			// 문제 삭제
			evaluationRepository.deleteSelfExamQuestion(questionCnt.getExamProgressId());
			evaluationRepository.deleteSelfExamAnswer(questionCnt.getExamProgressId());

			questionCnt.setQuestionCnt(0);
		}

		// 시험 문항이 없을 경우 문제 랜덤 선택
		if(questionCnt == null || questionCnt.getQuestionCnt() == 0) {
			List<String> questionIdList = new ArrayList<>();

			List<ExamMeasure> examMeasureList = evaluationRepository.getSelfExamMeasureList(language, skillCode,
					examClassCode);
			if(!examMeasureList.isEmpty()) {
				for(ExamMeasure examMeasure : examMeasureList) {
					examMeasure.setSkillCode(skillCode);
					examMeasure.setExamClassCode(examClassCode);

					// 척도별 문제 랜덤 추출
					List<String> randomList = evaluationRepository.getSelfExamQuestionRandomList(examMeasure);
					if(examMeasure.getQuestionCount() == randomList.size()) {
						questionIdList.addAll(randomList); // 랜덤 추출
					}
					else {
						throw new DataException("척도 필수 문항 수 부족");
					}
				}

				if(!questionIdList.isEmpty()) {
					evaluationRepository.insertSelfExamQuestion(userId, skillCode, examClassCode, questionIdList);
					// 시험 응시 내역 저장
					evaluationRepository.insertSelfExamHistory(userId, skillCode, examClassCode);
				}
			}
			else {
				throw new DataException("척도 조회 불가");
			}
		}

		// 문제 풀기 시작
		if(no == 1 && questionCnt == null || questionCnt.getQuestionCnt() == 0) {
			updateSelfExamStart(locale, userId, skillCode, examClassCode);
		}

		/*
		 * 이전 번호 문제 답변 등록
		 * ================================================================
		 */
		if(no > 1 && answerParam.getQuestionId() != null) {
			answerParam.setUserId(userId);
			// 문제 조회
			ExamQuestion data = evaluationRepository.getSelfExamQuestion(language, userId, skillCode, examClassCode,
					no - 1);
			List<ExamExample> examExampleList = evaluationRepository.getSelfExamExampleList(language,
					answerParam.getQuestionId());

			// 주관식
			if(ExamQuestionTypeCode.ANSWER == data.getQuestionTypeCode()) {
				answerParam.setIsAnswer("N");
				if(answerParam.getShortAnswer().equals(examExampleList.get(0).getExampleContents())) {
					answerParam.setIsAnswer("Y");
				}
			}
			// 1개 선택 / 다중 선택 / 척도 선택 / 선긋기
			else if(ExamQuestionTypeCode.CHOICE == data.getQuestionTypeCode()
					|| ExamQuestionTypeCode.MULTI_CHOICE == data.getQuestionTypeCode()
					|| ExamQuestionTypeCode.SCALE == data.getQuestionTypeCode()
					|| ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {

				// 답변
				List<Integer> choiceList = new ArrayList<>();
				for(Integer e : answerParam.getExampleAnswer()) {
					if(e != null) {
						choiceList.add(e);
					}
				}

				// 정답
				List<Integer> answerList = new ArrayList<>();
				if(ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {
					for(ExamExample example : examExampleList) {
						answerList.add(example.getLineDrawingAnswerNumber());
					}
					// 선긋기는 순서가 중요함으로 정렬을 하지 않음
				}
				else {
					for(ExamExample example : examExampleList) {
						if(example.getIsAnswer().equals("Y")) {
							answerList.add(example.getExampleNumber());
						}
					}

					// 비교를 위해 정렬
					Collections.sort(answerList);
					Collections.sort(choiceList);
				}

				// 정답 확인
				log.info("answerList : {}", answerList);
				log.info("choiceList : {}", choiceList);
				answerParam.setIsAnswer("Y");
				if(answerList.size() == choiceList.size()) {
					for(int i = 0; i < answerList.size(); i++) {
						if(!answerList.get(i).equals(choiceList.get(i))) {
							answerParam.setIsAnswer("N");
						}
					}
				}
				else {
					answerParam.setIsAnswer("N");
				}

			}
			evaluationRepository.insertSelfExamAnswer(answerParam);
			evaluationRepository.updateSelfExamQuestionComplete(answerParam.getQuestionId(),
					answerParam.getExamProgressId());
		}
		/*
		 * 이전 번호 문제 답변 등록
		 * ================================================================
		 */

		// 문제 번호에 맞는 문제 조회
		ExamQuestion data = evaluationRepository.getSelfExamQuestion(language, userId, skillCode, examClassCode, no);
		if(data != null) {
			int questionId = data.getQuestionId();
			int examProgressId = data.getExamProgressId();

			// 문제를 푼 문항일 경우 답변 조회
			if(data.getIsProgress().equals("Y")) {
				data.setAnswer(evaluationRepository.getSelfExamAnswer(questionId, examProgressId));
			}

			// 문제 보기 조회
			// 주관식이 아닐경우
			if(ExamQuestionTypeCode.ANSWER != data.getQuestionTypeCode()) {
				data.setExampleList1(evaluationRepository.getSelfExamExampleList(language, questionId));
			}
			// 선긋기일 경우 추가 보기 조회
			if(ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {
				data.setExampleList2(evaluationRepository.getSelfExamExampleList2(language, questionId));
			}

			// 스킬 정보 조회
			data.setSkill(skill);
		}
		return data;
	}

	/**
	 * 기술 시험 문제 조회
	 * </p>
	 * @param locale
	 * @param userId
	 * @param skillCode
	 * @param type
	 * @param no
	 * @param answerParam
	 * @param skill
	 * @return
	 */
	@Transactional
	public ExamQuestion getSkillExamQuestion(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode,
			String type,
			int no,
			ExamAnswer answerParam,
			Skill skill
	) {
		LanguageCode language = LanguageCode.getLanguage(locale);

		ExamQuestionCnt questionCnt = evaluationRepository.confirmSkillExamQuestion(userId, skillCode, examClassCode);

		if(
				skill.getProgressStatusCode().getExamProgressStatusCode().equals("1401")
				&& questionCnt != null && questionCnt.getQuestionCnt() > 0
		) {
			// 문제 삭제
			evaluationRepository.deleteSkillExamQuestion(questionCnt.getExamProgressId());
			evaluationRepository.deleteSkillExamAnswer(questionCnt.getExamProgressId());

			questionCnt.setQuestionCnt(0);
		}

		// 시험 문항이 없을 경우 문제 랜덤 선택
		if(questionCnt == null || questionCnt.getQuestionCnt() == 0) {
			List<String> questionIdList = new ArrayList<>();

			List<ExamMeasure> examMeasureList = evaluationRepository.getSkillExamMeasureList(language, skillCode,
					examClassCode);
			if(!examMeasureList.isEmpty()) {
				for(ExamMeasure examMeasure : examMeasureList) {
					examMeasure.setSkillCode(skillCode);
					examMeasure.setExamClassCode(examClassCode);

					// 척도별 문제 랜덤 추출
					List<String> randomList = evaluationRepository.getSkillExamQuestionRandomList(examMeasure);
					if(examMeasure.getQuestionCount() == randomList.size()) {
						questionIdList.addAll(randomList); // 랜덤 추출
					}
					else {
						throw new DataException("척도 필수 문항 수 부족");
					}
				}

				if(!questionIdList.isEmpty()) {
					evaluationRepository.insertSkillExamQuestion(userId, skillCode, examClassCode, questionIdList);
					// 시험 응시 내역 저장
					evaluationRepository.insertSkillExamHistory(userId, skillCode, examClassCode);
				}
			}
			else {
				throw new DataException("척도 조회 불가");
			}
		}

		// 문제 풀기 시작
		if(no == 1 && questionCnt == null || questionCnt.getQuestionCnt() == 0) {
			updateSkillExamStart(locale, userId, skillCode, examClassCode);
		}

		/*
		 * 이전 번호 문제 답변 등록
		 * ================================================================
		 */
		if(no > 1 && answerParam.getQuestionId() != null) {
			answerParam.setUserId(userId);
			// 문제 조회
			ExamQuestion data = evaluationRepository.getSkillExamQuestion(language, userId, skillCode, examClassCode,
					no - 1);
			List<ExamExample> examExampleList = evaluationRepository.getSkillExamExampleList(language,
					answerParam.getQuestionId());

			// 주관식
			if(ExamQuestionTypeCode.ANSWER == data.getQuestionTypeCode()) {
				answerParam.setIsAnswer("N");
				if(answerParam.getShortAnswer().equals(examExampleList.get(0).getExampleContents())) {
					answerParam.setIsAnswer("Y");
				}
			}
			// 1개 선택 / 다중 선택 / 척도 선택 / 선긋기
			else if(ExamQuestionTypeCode.CHOICE == data.getQuestionTypeCode()
					|| ExamQuestionTypeCode.MULTI_CHOICE == data.getQuestionTypeCode()
					|| ExamQuestionTypeCode.SCALE == data.getQuestionTypeCode()
					|| ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {

				// 답변
				List<Integer> choiceList = new ArrayList<>();
				for(Integer e : answerParam.getExampleAnswer()) {
					if(e != null) {
						choiceList.add(e);
					}
				}

				// 정답
				List<Integer> answerList = new ArrayList<>();
				if(ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {
					for(ExamExample example : examExampleList) {
						answerList.add(example.getLineDrawingAnswerNumber());
					}
					// 선긋기는 순서가 중요함으로 정렬을 하지 않음
				}
				else {
					for(ExamExample example : examExampleList) {
						if(example.getIsAnswer().equals("Y")) {
							answerList.add(example.getExampleNumber());
						}
					}

					// 비교를 위해 정렬
					Collections.sort(answerList);
					Collections.sort(choiceList);
				}

				// 정답 확인
				log.info("answerList : {}", answerList);
				log.info("choiceList : {}", choiceList);
				answerParam.setIsAnswer("Y");
				if(answerList.size() == choiceList.size()) {
					for(int i = 0; i < answerList.size(); i++) {
						if(!answerList.get(i).equals(choiceList.get(i))) {
							answerParam.setIsAnswer("N");
						}
					}
				}
				else {
					answerParam.setIsAnswer("N");
				}

			}
			evaluationRepository.insertSkillExamAnswer(answerParam);
			evaluationRepository.updateSkillExamQuestionComplete(answerParam.getQuestionId(),
					answerParam.getExamProgressId());
		}
		/*
		 * 이전 번호 문제 답변 등록
		 * ================================================================
		 */

		// 문제 번호에 맞는 문제 조회
		ExamQuestion data = evaluationRepository.getSkillExamQuestion(language, userId, skillCode, examClassCode, no);
		if(data != null) {
			int questionId = data.getQuestionId();
			int examProgressId = data.getExamProgressId();

			// 문제를 푼 문항일 경우 답변 조회
			if(data.getIsProgress().equals("Y")) {
				data.setAnswer(evaluationRepository.getSkillExamAnswer(questionId, examProgressId));
			}

			// 문제 보기 조회
			// 주관식이 아닐경우
			if(ExamQuestionTypeCode.ANSWER != data.getQuestionTypeCode()) {
				data.setExampleList1(evaluationRepository.getSkillExamExampleList(language, questionId));
			}
			// 선긋기일 경우 추가 보기 조회
			if(ExamQuestionTypeCode.LINE_DRAWING == data.getQuestionTypeCode()) {
				data.setExampleList2(evaluationRepository.getSkillExamExampleList2(language, questionId));
			}

			// 스킬 정보 조회
			data.setSkill(skill);
		}
		return data;
	}

	// 자가 시험 평가 정보 저장
	@Transactional
	public BaseResponse<String> updateSelfExamEvaluation(Locale locale, ExamProgressStatus param) {
		evaluationRepository.updateSelfExamEvaluation(param);

		if(param.getIsPass().equals("Y")) {
			updateStatus(locale, param.getUserId(), param.getSkillCode(), param.getExamClassCode(), SkillProgressStatusCode.SELF_EXAM_TAKING, SkillProgressStatusCode.SELF_EXAM_PASS);
		}
		else {
			updateStatus(locale, param.getUserId(), param.getSkillCode(), param.getExamClassCode(), SkillProgressStatusCode.SELF_EXAM_TAKING, SkillProgressStatusCode.SELF_EXAM_FAILED);
		}
		return new BaseResponse<>(param.getIsPass());
	}

	// 기술 시험 평가 정보 저장
	@Transactional
	public BaseResponse<String> updateSkillExamEvaluation(Locale locale, ExamProgressStatus param) {
		evaluationRepository.updateSkillExamEvaluation(param);

		if(param.getIsPass().equals("Y")) {
			updateStatus(locale, param.getUserId(), param.getSkillCode(), param.getExamClassCode(), SkillProgressStatusCode.SKILL_EXAM_TAKING, SkillProgressStatusCode.SKILL_EXAM_PASS);
		}
		else {
			updateStatus(locale, param.getUserId(), param.getSkillCode(), param.getExamClassCode(), SkillProgressStatusCode.SKILL_EXAM_TAKING, SkillProgressStatusCode.SKILL_EXAM_FAILED);
		}
		return new BaseResponse<>(param.getIsPass());
	}

	@Transactional
	public BaseResponse<String> updateSelfExamStart(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode
	) {
		updateStatus(locale, userId, skillCode, examClassCode, SkillProgressStatusCode.SELF_EXAM_WAIT,
				SkillProgressStatusCode.SELF_EXAM_TAKING);
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	@Transactional
	public BaseResponse<String> updateSelfExamTimeOut(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode
	) {
		updateStatus(locale, userId, skillCode, examClassCode, SkillProgressStatusCode.SELF_EXAM_TAKING,
				SkillProgressStatusCode.SELF_EXAM_TIME_OUT);
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	@Transactional
	public BaseResponse<String> updateSkillExamStart(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode
	) {
		updateStatus(locale, userId, skillCode, examClassCode, SkillProgressStatusCode.SKILL_EXAM_WAIT,
				SkillProgressStatusCode.SKILL_EXAM_TAKING);
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	@Transactional
	public BaseResponse<String> updateSkillExamTimeOut(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode
	) {
		updateStatus(locale, userId, skillCode, examClassCode, SkillProgressStatusCode.SKILL_EXAM_TAKING,
				SkillProgressStatusCode.SKILL_EXAM_TIME_OUT);
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	@Transactional
	public BaseResponse<String> updateFriendAuthStart(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode
	) {
		updateStatus(locale, userId, skillCode, examClassCode, SkillProgressStatusCode.FRIEND_AUTH_TAKING);
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	@Transactional
	public BaseResponse<String> updateFriendAuthPass(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode
	) {
		updateStatus(locale, userId, skillCode, examClassCode, SkillProgressStatusCode.FRIEND_AUTH_TAKING,
				SkillProgressStatusCode.FRIEND_AUTH_PASS);
		return new BaseResponse<>(BaseResponseCode.SUCCESS, "성공");
	}

	@Transactional
	public void updateStatus(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode,
			SkillProgressStatusCode currCode,
			SkillProgressStatusCode updateCode
	) {
		if(StringUtils.isNotEmpty(evaluationRepository.confirmSkillProgressStatus(userId, skillCode, examClassCode,
				currCode, updateCode))) {
			updateStatus(locale, userId, skillCode, examClassCode, updateCode);
		}
		else {
			throw new NullPointerException("skill(" + skillCode + ") : status(" + currCode + ")");
		}
	}

	
	public void updateStatus(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode,
			SkillProgressStatusCode updateCode
	) {

		// 자가 시험
		if(updateCode.getSkillProgressLevelCode().equals("1202")) {
			ExamProgressStatus param = new ExamProgressStatus(userId, skillCode, examClassCode, updateCode);
			evaluationRepository.insertSelfExamProgressStatus(param);
			if(SkillProgressStatusCode.SELF_EXAM_TAKING == updateCode) {
				evaluationRepository.updateSelfExamStartTime(param.getExamProgressId());
			}
		}
		// 기술 시험
		else if(updateCode.getSkillProgressLevelCode().equals("1203")) {
			ExamProgressStatus param = new ExamProgressStatus(userId, skillCode, examClassCode, updateCode);
			evaluationRepository.insertSkillExamProgressStatus(param);
			if(SkillProgressStatusCode.SKILL_EXAM_TAKING == updateCode) {
				evaluationRepository.updateSkillExamStartTime(param.getExamProgressId());
			}
		}
		// 친구 추천
		else if(updateCode.getSkillProgressLevelCode().equals("1204")) {
			log.info("skillProgressLevelCode: 1204");
		}
		evaluationRepository
				.insertSkillProgressStatus(new SkillProgressStatus(userId, skillCode, examClassCode, updateCode));

		String badgeObtainLevelCode = evaluationRepository.getSkillBadgeObtainLevelCode(skillCode, examClassCode);

		// 뱃지 획득시
		if(checkSkillBadgeObtain(badgeObtainLevelCode, updateCode)) {
			evaluationRepository
					.insertHaveSkill(new HaveSkill(userId, skillCode, examClassCode, SkillProgressStatusCode.PASS));
			noticeService.insertBadgeObtain(locale, getSkillName(locale, skillCode, examClassCode), skillCode,
					examClassCode, userId);
		}
		// 뱃지 획득 전
		else {
			evaluationRepository.insertHaveSkill(new HaveSkill(userId, skillCode, examClassCode, updateCode));
		}
	}

	public void updateStatus(
			Locale locale,
			Skill skill,
			String userId,
			String skillCode,
			String examClassCode,
			SkillProgressStatusCode updateCode
	) {

		if(updateCode == SkillProgressStatusCode.SELF_EXAM_FAILED
				|| updateCode == SkillProgressStatusCode.SELF_EXAM_TIME_OUT
				|| updateCode == SkillProgressStatusCode.SKILL_EXAM_FAILED
				|| updateCode == SkillProgressStatusCode.SKILL_EXAM_TIME_OUT) {
			boolean isPass = skill.getProgressStatusCode().toString().endsWith("PASS");
			if((updateCode.toString().startsWith("SELF_") && isPass)
					|| (updateCode.toString().startsWith("SKILL_") && isPass)) {
				log.info("updateStatus method -> error");
			}
		}
		updateStatus(locale, userId, skillCode, examClassCode, updateCode);
	}

	public void confirmPass(Skill skill) {

		boolean isPass = skill.getProgressStatusCode().toString().endsWith("PASS");
		if(isPass) {
			log.info("confirmPass method -> error");
		}
	}

	public void confirmPass(Locale locale, String userId, String skillCode, String examClassCode) {
		confirmPass(getSkill(locale, userId, skillCode, examClassCode));
	}

	// 친구 목록 조회
	public SkillFriendList getFriendList(
			Locale locale,
			String userId,
			String skillCode,
			String examClassCode,
			String searchKeyword,
			int offset,
			int limit
	) {
		LanguageCode language = LanguageCode.getLanguage(locale);
		boolean isSarch = StringUtils.isNotEmpty(searchKeyword);
		SkillFriendList res = new SkillFriendList();

		if(!isSarch || offset == 0) {
			res.setFriendCount(
					evaluationRepository.getFriendCount(language, userId, skillCode, examClassCode, searchKeyword));
			res.setFriendList(evaluationRepository.getFriendList(language, userId, skillCode, examClassCode,
					searchKeyword, offset, limit));
		}

		if(isSarch) {
			res.setMemberCount(
					evaluationRepository.getMemberCount(language, userId, skillCode, examClassCode, searchKeyword));
			res.setMemberList(evaluationRepository.getMemberList(language, userId, skillCode, examClassCode,
					searchKeyword, offset, limit));

			if(res.getFriendCount() == 0 && res.getMemberCount() == 0) {
				res.setReferralMemberList(
						evaluationRepository.getReferralMemberList(language, userId, skillCode, examClassCode));
			}
		}

		return res;
	}

	// 친구 인증 요청
	@Transactional
	public void insertSkillFriendAuth(
			Locale locale,
			String userId,
			String friendId,
			String skillCode,
			String examClassCode
	) {
		updateFriendAuthStart(locale, userId, skillCode, examClassCode);

		SkillFriendAuth param = new SkillFriendAuth();
		param.setUserId(userId);
		param.setFriendId(friendId);
		param.setSkillCode(skillCode);
		param.setExamClassCode(examClassCode);
		evaluationRepository.insertSkillFriendAuth(param);
		noticeService.insertSkillAuthRequest(locale,
				getSkillName(LanguageCode.getLanguage(locale), skillCode, examClassCode), friendId, userId);
	}

	// 친구 인증 요청 취소
	public void deleteSkillFriendAuth(String userId, String friendId, String skillCode, String examClassCode) {
		SkillFriendAuth param = new SkillFriendAuth();
		param.setUserId(userId);
		param.setFriendId(friendId);
		param.setSkillCode(skillCode);
		param.setExamClassCode(examClassCode);
		evaluationRepository.deleteSkillFriendAuth(param);
	}

	// 친구 인증 완료
	@Transactional
	public void completeSkillFriendAuth(
			Locale locale,
			String userId,
			String friendId,
			String skillCode,
			String examClassCode,
			String authContents
	) {
		// 인증 완료 상태값 수정
		SkillFriendAuth param = new SkillFriendAuth();
		param.setUserId(userId);
		param.setFriendId(friendId);
		param.setSkillCode(skillCode);
		param.setExamClassCode(examClassCode);
		param.setAuthContents(authContents);
		evaluationRepository.completeSkillFriendAuth(param);

		// 추천 친구 수 업데이트
		SkillProgressStatus param2 = new SkillProgressStatus();
		param2.setUserId(userId);
		param2.setSkillCode(skillCode);
		param2.setExamClassCode(examClassCode);
		evaluationRepository.updateSkillFriendAuthCount(param2);

		// 친구 인증 통과
		if(param2.getFriendRecommendCount() == 3) {
			updateFriendAuthPass(locale, userId, skillCode, examClassCode);
		}

		// 알람 발송
		noticeService.insertSkillAuthComplete(locale, getSkillName(locale, skillCode, examClassCode), skillCode,
				examClassCode, friendId, userId);
	}

	public String getSkillName(LanguageCode language, String skillCode, String examClassCode) {
		return evaluationRepository.getSkillName(language, skillCode, examClassCode);
	}

	public String getSkillName(Locale locale, String skillCode, String examClassCode) {
		return getSkillName(LanguageCode.getLanguage(locale), skillCode, examClassCode);
	}

	private boolean checkSkillBadgeObtain(
			String badgeObtainLevelCode,
			SkillProgressStatusCode skillProgressStatusCode
	) {
		// @formatter:off
		return (badgeObtainLevelCode.equals("1501") && SkillProgressStatusCode.SELF_EXAM_PASS   == skillProgressStatusCode)
			|| (badgeObtainLevelCode.equals("1502") && SkillProgressStatusCode.SKILL_EXAM_PASS  == skillProgressStatusCode)
			|| (badgeObtainLevelCode.equals("1503") && SkillProgressStatusCode.FRIEND_AUTH_PASS == skillProgressStatusCode)
			|| (badgeObtainLevelCode.equals("1504") && SkillProgressStatusCode.FRIEND_AUTH_PASS == skillProgressStatusCode);
		//@formatter:on
	}
	
	// DB 현재시간 가져오기
	public Date getNowTime() {
		return evaluationRepository.getNowTime();
	}
}
