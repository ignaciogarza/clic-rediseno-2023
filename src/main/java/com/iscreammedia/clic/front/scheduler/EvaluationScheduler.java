package com.iscreammedia.clic.front.scheduler;

import java.util.List;

import com.iscreammedia.clic.front.domain.Exam;
import com.iscreammedia.clic.front.domain.SkillProgressStatusCode;
import com.iscreammedia.clic.front.repository.EvaluationRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Profile;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;
import org.springframework.transaction.annotation.Transactional;

@Profile({"local", "stage", "production"})
@Component
public class EvaluationScheduler {

	@Autowired
	private EvaluationRepository evaluationRepository;
	
	private static final long DELAY1 = 1000L * 0;
	private static final long DELAY2 = 1000L * 60;

	// 자가 시험 타임아웃 처리
	@Scheduled(initialDelay = DELAY1, fixedDelay = DELAY2)

	public void updateSelfExamTimeout() {
		List<Exam> list = evaluationRepository.getSelfExamTimeoutList();
		for(Exam data : list) {
			evaluationRepository.updateSelfExamTimeout1(data);
			evaluationRepository.updateSelfExamTimeout2(data);
		}
	}

	// 기술 시험 타임아웃 처리
	@Scheduled(initialDelay = DELAY1, fixedDelay = DELAY2)
	public void updateSkillExamTimeout() {
		List<Exam> list = evaluationRepository.getSkillExamTimeoutList();
		for(Exam data : list) {
			evaluationRepository.updateSkillExamTimeout1(data);
			evaluationRepository.updateSkillExamTimeout2(data);
		}
	}

	// 자가 시험 타임아웃 / 불합격 해제
	@Scheduled(initialDelay = DELAY1, fixedDelay = DELAY2)
	@Transactional
	public void updateSelfExamWait() {
		updateSelfExamWait(SkillProgressStatusCode.SELF_EXAM_TIME_OUT.getExamProgressStatusCode());
		updateSelfExamWait(SkillProgressStatusCode.SELF_EXAM_FAILED.getExamProgressStatusCode());
	}

	// 기술 시험 타임아웃 / 불합격 해제
	@Scheduled(initialDelay = DELAY1, fixedDelay = DELAY2)
	@Transactional
	public void updateSkillExamWait() {
		updateSkillExamWait(SkillProgressStatusCode.SKILL_EXAM_TIME_OUT.getExamProgressStatusCode());
		updateSkillExamWait(SkillProgressStatusCode.SKILL_EXAM_FAILED.getExamProgressStatusCode());
	}

	@Transactional
	public void updateSelfExamWait(String statusCode) {
		// 타겟 목록 조회
		List<Exam> targetList = evaluationRepository.getSelfExamWaitList(statusCode);

		for(Exam target : targetList) {
			// 타임아웃 / 불합격 해제 처리
			evaluationRepository.updateSelfExamWait1(target);
			evaluationRepository.updateSelfExamWait2(target);

			// 할당된 문제 / 답변 삭제
			evaluationRepository.deleteSelfExamQuestion(target.getExamProgressId());
			evaluationRepository.deleteSelfExamAnswer(target.getExamProgressId());
		}
	}

	@Transactional
	public void updateSkillExamWait(String statusCode)  {
		// 타겟 목록 조회
		List<Exam> targetList = evaluationRepository.getSkillExamWaitList(statusCode);

		for(Exam target : targetList) {
			// 타임아웃 / 불합격 해제 처리
			evaluationRepository.updateSkillExamWait1(target);
			evaluationRepository.updateSkillExamWait2(target);

			// 할당된 문제 / 답변 삭제
			evaluationRepository.deleteSkillExamQuestion(target.getExamProgressId());
			evaluationRepository.deleteSkillExamAnswer(target.getExamProgressId());
		}
	}
}
