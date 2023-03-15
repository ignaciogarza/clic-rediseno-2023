package com.iscreammedia.clic.front.domain;

import java.util.Date;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class Skill {
	private String skillCode;               // 스킬 코드
	private String examClassCode;           // 시험 등급 코드
	private String skillName;               // 스킬 이름
	private String skillContents;           // 스킬 설명
	private String skillImagePath;          // 스킬 이미지 경로
	private String isUse;                   // 사용 여부
	private int    minRecommendFriendCount; // 최소 추천 친구 수

	private String badgeName;             // 뱃지 이름
	private String badgeDefaultImagePath; // 뱃지 기본 이미지 경로
	private String badgeObtainImagePath;  // 뱃지 획득 이미지 경로
	private String badgeContents;         // 뱃지 내용

	private String  isComplete;             // 완료 여부
	private String  isPass;                 // 합격 여부

	/**
	 * 뱃지 획득 단계 코드
	 * <ul>
	 * <li>1501 : 자가 시험만으로 획득
	 * <li>1502 : 자가 시험 + 기술 시험
	 * <li>1503 : 자가 시험 + 기술 시험 + 친구 추천
	 * <li>1504 : 자가 시험 + 친구 추천
	 */
	private String badgeObtainLevelCode;

	/**
	 * 스킬 진행 단계 코드
	 * <ul>
	 * <li>1201 : 미진행 단계
	 * <li>1202 : 자가 시험 단계
	 * <li>1203 : 기술 시험 단계
	 * <li>1204 : 친구 추천 단계
	 * <li>1205 : 완료 단계
	 */
	private String skillProgressLevelCode;

	private SkillProgressStatusCode progressStatusCode;

	// 뱃지 획득 확인
	private boolean checkSkillBadgeObtain;

	private Integer selfFinalScore;       // 자가 시험 점수
	private Integer skillFinalScore;      // 스킬 시험 점수
	private Integer friendRecommendCount; // 친구 추천수
	private Date    updatedDate;
	private String  formateUpdatedDate;
}
