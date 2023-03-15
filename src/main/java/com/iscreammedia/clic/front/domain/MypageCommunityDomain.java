package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class MypageCommunityDomain {

	private String userId;									//회원 아이디
	private List<CommunityDomain> communityList;			//커뮤니티 리스트
	private List<CommunityDomain> friendCheckList;			//친구 리스트
	
}
