package com.iscreammedia.clic.front.controller.viewmodel;

import java.util.List;

import com.iscreammedia.clic.front.domain.CommunityDomain;

import lombok.Data;

@Data
public class ViewCommunityList extends ViewListBase{
	
	protected List<CommunityDomain> list;

}
