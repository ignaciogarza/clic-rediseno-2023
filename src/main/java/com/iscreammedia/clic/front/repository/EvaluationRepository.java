package com.iscreammedia.clic.front.repository;

import java.util.Date;
import java.util.List;

import com.iscreammedia.clic.front.domain.Exam;
import com.iscreammedia.clic.front.domain.ExamAnswer;
import com.iscreammedia.clic.front.domain.ExamExample;
import com.iscreammedia.clic.front.domain.ExamMeasure;
import com.iscreammedia.clic.front.domain.ExamProgressStatus;
import com.iscreammedia.clic.front.domain.ExamQuestion;
import com.iscreammedia.clic.front.domain.ExamQuestionCnt;
import com.iscreammedia.clic.front.domain.ExamResult;
import com.iscreammedia.clic.front.domain.ExamResultDetail;
import com.iscreammedia.clic.front.domain.HaveSkill;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.domain.SkillFriendAuth;
import com.iscreammedia.clic.front.domain.SkillProgressStatus;
import com.iscreammedia.clic.front.domain.SkillProgressStatusCode;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface EvaluationRepository {

	public String getSkillName(
			@Param("language") LanguageCode language,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public String getSkillBadgeObtainLevelCode(
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public boolean checkSkillBadgeObtain(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public List<Skill> getSkillList(@Param("language") LanguageCode language, @Param("userId") String userId);

	public Skill getSkill(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public Exam getSelfExam(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public Exam getSkillExam(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	// ===================================================================

	public String confirmSkillProgressStatus(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("currCode") SkillProgressStatusCode currCode,
			@Param("updateCode") SkillProgressStatusCode updateCode
	);

	public void insertSkillProgressStatus(SkillProgressStatus param);

	public void updateSkillProgressStatus(SkillProgressStatus param);

	public void insertSelfExamProgressStatus(ExamProgressStatus param);

	public void updateSelfExamStartTime(int examProgressId);

	public void insertSkillExamProgressStatus(ExamProgressStatus param);

	public void updateSkillExamStartTime(int examProgressId);

	public void insertHaveSkill(HaveSkill param);

	// ===================================================================

	// 자가 시험 문항 확인(count)
	public ExamQuestionCnt confirmSelfExamQuestion(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	// 자가 시험 문항 조회
	public ExamQuestion getSelfExamQuestion(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("no") int no
	);

	// 자가 시험 문항 진행 완료 처리
	public void updateSelfExamQuestionComplete(
			@Param("questionId") int questionId,
			@Param("examProgressId") int examProgressId
	);

	// 자가 시험 문항 답변 조회
	public ExamAnswer getSelfExamAnswer(
			@Param("questionId") int questionId,
			@Param("examProgressId") int examProgressId
	);

	// 자가 시험 문항 답변 조회
	public List<ExamAnswer> getSelfExamAnswerList(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	// 자가 시험 보기 조회
	public List<ExamExample> getSelfExamExampleList(
			@Param("language") LanguageCode language,
			@Param("questionId") int questionId
	);

	// 자가 시험 선긋기 왼쪽 보기 조회
	public List<ExamExample> getSelfExamExampleList2(
			@Param("language") LanguageCode language,
			@Param("questionId") int questionId
	);

	// 자가 시험 답변 등록
	public void insertSelfExamAnswer(ExamAnswer param);

	// 기술 시험 문항 확인(count)
	public ExamQuestionCnt confirmSkillExamQuestion(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	// 기술 시험 문항 조회
	public ExamQuestion getSkillExamQuestion(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("no") int no
	);

	// 스킬 시험 문항 진행 완료 처리
	public void updateSkillExamQuestionComplete(
			@Param("questionId") int questionId,
			@Param("examProgressId") int examProgressId
	);

	// 자가 시험 문항 답변 조회
	public ExamAnswer getSkillExamAnswer(
			@Param("questionId") int questionId,
			@Param("examProgressId") int examProgressId
	);

	// 스킬 시험 보기 조회
	public List<ExamExample> getSkillExamExampleList(
			@Param("language") LanguageCode language,
			@Param("questionId") int questionId
	);

	// 스킬 시험 선긋기 왼쪽 보기 조회
	public List<ExamExample> getSkillExamExampleList2(
			@Param("language") LanguageCode language,
			@Param("questionId") int questionId
	);

	// 스킬 시험 답변 등록
	public void insertSkillExamAnswer(ExamAnswer param);

	// ===================================================================

	// 자가 시험 평가 등록
	public void updateSelfExamEvaluation(ExamProgressStatus param);

	// 기술 시험 평가 등록
	public void updateSkillExamEvaluation(ExamProgressStatus param);

	// ===================================================================

	public List<ExamMeasure> getSelfExamMeasureList(
			@Param("language") LanguageCode language,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public List<String> getSelfExamQuestionRandomList(ExamMeasure param);

	public void insertSelfExamHistory(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public void insertSelfExamQuestion(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("questionIdList") List<String> questionIdList
	);

	public List<ExamMeasure> getSkillExamMeasureList(
			@Param("language") LanguageCode language,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public List<String> getSkillExamQuestionRandomList(ExamMeasure param);

	public void insertSkillExamHistory(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public void insertSkillExamQuestion(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("questionIdList") List<String> questionIdList
	);

	// 시험 결과
	public ExamResult getExamResult(
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public List<ExamResultDetail> getExamResultDetailList(
			@Param("language") LanguageCode language,
			@Param("selfExamProgressId") Integer selfExamProgressId,
			@Param("skillExamProgressId") Integer skillExamProgressId
	);

	// ===================================================================

	// 스킬 인증 요청
	public void insertSkillFriendAuth(SkillFriendAuth param);

	// 스킬 인증 요청 취소
	public void deleteSkillFriendAuth(SkillFriendAuth param);

	// 스킬 인증 완료
	public void completeSkillFriendAuth(SkillFriendAuth param);

	// 스킬 인증 완료
	public void updateSkillFriendAuthCount(SkillProgressStatus param);

	// 스킬 인증 요청 카운트
	public int getAuthRequestCount(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	// 스킬 인증 요청 목록 조회
	public List<SkillFriendAuth> getAuthRequestList(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	public int getFriendCount(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("searchKeyword") String searchKeyword
	);

	public List<SkillFriendAuth> getFriendList(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("searchKeyword") String searchKeyword,
			@Param("offset") int offset,
			@Param("limit") int limit
	);

	public int getMemberCount(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("searchKeyword") String searchKeyword
	);

	public List<SkillFriendAuth> getMemberList(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode,
			@Param("searchKeyword") String searchKeyword,
			@Param("offset") int offset,
			@Param("limit") int limit
	);

	public List<SkillFriendAuth> getReferralMemberList(
			@Param("language") LanguageCode language,
			@Param("userId") String userId,
			@Param("skillCode") String skillCode,
			@Param("examClassCode") String examClassCode
	);

	// ===================================================================
	// ===================================================================
	// ===================================================================

	// 자가 시험 타임아웃 목록
	public List<Exam> getSelfExamTimeoutList();

	// 자가 시험 타임아웃 처리 SPS
	public void updateSelfExamTimeout1(Exam param);

	// 자가 시험 타임아웃 처리 SEPS
	public void updateSelfExamTimeout2(Exam param);

	// 자가 시험 타임아웃 / 불합격 해제 대상 확인
	public List<Exam> getSelfExamWaitList(@Param("progressStatus") String progressStatus);

	// 자가 시험 타임아웃 / 불합격 해제 SPS
	public void updateSelfExamWait1(Exam param);

	// 자가 시험 타임아웃 / 불합격 해제 SEPS
	public void updateSelfExamWait2(Exam param);

	// 자가 시험 할당된 문제 삭제
	public void deleteSelfExamQuestion(@Param("examProgressId") Integer examProgressId);

	// 자가 시험 할당된 문제 답변 삭제
	public void deleteSelfExamAnswer(@Param("examProgressId") Integer examProgressId);

	// 기술 시험 타임아웃 목록
	public List<Exam> getSkillExamTimeoutList();

	// 기술 시험 타임아웃 처리 SPS
	public void updateSkillExamTimeout1(Exam param);

	// 기술 시험 타임아웃 처리 SEPS
	public void updateSkillExamTimeout2(Exam param);

	// 기술 시험 타임아웃 / 불합격 해제 대상 확인
	public List<Exam> getSkillExamWaitList(@Param("progressStatus") String progressStatus);

	// 기술 시험 타임아웃 / 불합격 해제 SPS
	public void updateSkillExamWait1(Exam param);

	// 기술 시험 타임아웃 / 불합격 해제 SEPS
	public void updateSkillExamWait2(Exam param);

	// 기술 시험 할당된 문제 삭제
	public void deleteSkillExamQuestion(@Param("examProgressId") Integer examProgressId);

	// 기술 시험 할당된 문제 답변 삭제
	public void deleteSkillExamAnswer(@Param("examProgressId") Integer examProgressId);
	
	// DB 현재시간 가져오기
	public Date getNowTime();

}