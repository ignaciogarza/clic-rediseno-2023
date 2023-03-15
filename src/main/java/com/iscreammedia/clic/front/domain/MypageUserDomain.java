package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MypageUserDomain {

	private String userId;									//회원 아이디
	private String userImagePath;							//회원 이미지 path
	private String countryCode;								//국가 코드
	private String name;									//이름
	private String firstName;								//성
	private String jobName;									//직업 이름
	private List<CommunityDomain> communityList;			//커뮤니티 리스트
	
}
