package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class SkillFriendList {
	private int friendCount;
	private List<SkillFriendAuth> friendList;
	
	private int memberCount;
	private List<SkillFriendAuth> memberList;
	
	private List<SkillFriendAuth> referralMemberList;
}
