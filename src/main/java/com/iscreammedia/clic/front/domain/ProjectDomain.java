package com.iscreammedia.clic.front.domain;

import java.util.List;

import lombok.Data;

@Data
public class ProjectDomain {
	
	private String userId;					//회원아이디
	
	private String projectId;				//프로젝트 아이디
	private String sequence;				//순서
	private String name;					//이름
	private String isDelete;				//삭제여부
	private String introduction;			//소개
	private String imagPath;				//이미지경로
	private String portfolioId;				//포토폴리오 아이디
	private String likeCount;				//좋아요 수	
	
	private String projectContentsId;		//프로젝트컨텐츠 아이디	
	private String skillCode;				//스킬코드
	private String contentsTypeCode;		//컨텐츠 종류코드
	private String contentsName;			//컨텐츠 이름
	private String contentsUrl;				//컨텐츠 URL
	private String contentsPath;			//컨텐츠 경로
	private String contents;				//컨텐츠설명	
	private String createdDate;				//등록일자
	private String updatedDate;				//수정일자
	
	private List<ProjectDomain> projectList;
	
	private List<CommonDomain> contentList;
	
	private List<ProjectDomain> contentsImageList;
	
	private UserDomain userDetail;
	
	private PortfolioDomain  portfolioInfo;
	
	private ProjectDomain projectInfo;
	
	private String likeStatus;

}
