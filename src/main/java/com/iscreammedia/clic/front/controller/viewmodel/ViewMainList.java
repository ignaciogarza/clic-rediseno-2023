package com.iscreammedia.clic.front.controller.viewmodel;

import java.util.List;

import com.iscreammedia.clic.front.domain.CommunityDomain;
import com.iscreammedia.clic.front.domain.PortfolioDomain;
import com.iscreammedia.clic.front.domain.UserDomain;

import lombok.Data;
@Data
public class ViewMainList extends ViewListBase{

	protected List<PortfolioDomain> portfoliolist;
	
	protected List<UserDomain> userlist;
	
	protected List<CommunityDomain> friendCheckList;
	
	private int userTotal;
	
	private int portfolioTotal;
	
	private String type;
}
