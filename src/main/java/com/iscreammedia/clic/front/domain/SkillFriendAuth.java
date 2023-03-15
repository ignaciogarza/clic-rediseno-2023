package com.iscreammedia.clic.front.domain;

import java.util.Date;

import com.fasterxml.jackson.annotation.JsonInclude;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
@JsonInclude(JsonInclude.Include.NON_NULL)
public class SkillFriendAuth {

	private String friendId;        // 친구아이디
	private String userId;          // 회원아이디
	private String authContents;    // 인증 내용
	private String isAuth;          // 인증 여부
	private Date   authRequestDate; // 인증 요청 날짜
	// private Date updateDate; // 수정 날짜

	private String countryCode;   // 국가코드
	private String email;         // 이메일
	private String name;          // 이름
	private String firstName;     // 성
	private String jobName;       // 직업
	private String userImagePath; // 회원이미지경로

	/**
	 * <ul>
	 * 친구 상태 코드
	 * <li>1101 친구 요청중
	 * <li>1102 친구 재요청중
	 * <li>1103 친구
	 * <li>1104 친구 거절
	 */
	private String friendStatusCode;

	private String skillCode;
	private String examClassCode;
}
