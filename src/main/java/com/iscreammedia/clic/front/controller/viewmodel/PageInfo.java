package com.iscreammedia.clic.front.controller.viewmodel;

public class PageInfo {
	private static final String CHANGEPAGE = "<a href='#' onclick='changePage(";
	private static final String FUNCTIONPAGE = "\"<a href='#' onclick='\"";
	
	private int totalItem;
	private final int pageItemSize;
	private final int groupSize;
	
	private int currentPage;
	private int[] currentPageGroup;
	private int totalPage;
	
	private boolean havePrev;
	private boolean haveNext;
	
	public PageInfo(int totalItem, int pageItemSize)
	{
		this(totalItem, pageItemSize, 10, 1);
	}
	
	public PageInfo(int totalItem, int pageItemSize, int groupSize)
	{
		this(totalItem, pageItemSize, groupSize, 1);
	}
	
	public PageInfo(int totalItem, int pageSize, int groupSize, int currentPage)
	{
		this.totalItem = totalItem;
		this.pageItemSize = pageSize;
		this.groupSize = groupSize;
		havePrev = false;
		haveNext = false;
		
		/**
		 * 20201027 ynjoung added.
		 * item 수가 없는 경우(total==0)를 그대로 인자로 받아서 페이징 처리하는 경우,
		 * 그 값을 그대로 사용해서 Paging 처리하는 경우 오류가 발생하므로
		 * item 수를 보정한다 
		 */
		if(this.totalItem == 0) this.totalItem = 1;
		if(this.currentPage == 0) this.currentPage = 1;
		
		setCurrentPage(currentPage);
	}
	
	public void setCurrentPage(int page)
	{
		if(page < 1)
			this.currentPage = 1;
		else
			this.currentPage = page;
		
		calculate();
	}
	
	public void setCurrentPage(int totalItem, int page)
	{
		this.totalItem = totalItem;
		setCurrentPage(page);
	}
	
	public int getTotalItem() {
		return totalItem;
	}

	public int getPageItemSize() {
		return pageItemSize;
	}

	public int getGroupSize() {
		return groupSize;
	}

	public int getCurrentPage() {
		return currentPage;
	}

	public int[] getCurrentPageGroup() {
		return currentPageGroup;
	}

	public int getTotalPage() {
		return totalPage;
	}

	public boolean isHavePrev() {
		return havePrev;
	}

	public boolean isHaveNext() {
		return haveNext;
	}
	
	private void calculate()
	{
		int mod = pageItemSize == 0 ? 0 : totalItem % pageItemSize;
		int quotient = pageItemSize == 0 ? 0 : (totalItem - mod) / pageItemSize;

		this.totalPage = quotient + (mod == 0 ? 0 : 1);

		if (this.totalPage < this.currentPage)
			this.currentPage = this.totalPage;

		int sg = (this.currentPage / this.groupSize);

		int sIdx = sg * groupSize + 1;
		int eIdx = sIdx + groupSize - 1;

		if (eIdx > totalPage)
			eIdx = totalPage;

		int pgCount = eIdx - sIdx + 1;

		this.currentPageGroup = new int[pgCount];
		for (int i = 0; i < this.currentPageGroup.length; ++i)
		{
			currentPageGroup[i] = sIdx + i;
		}

		if (pgCount == 0)
		{
			havePrev = haveNext = false;
		} else
		{
			havePrev = currentPageGroup[0] > groupSize;
			haveNext = currentPageGroup[currentPageGroup.length - 1] < totalPage;
		}
	}

	public int getStartItemIndex(int pageNumber)
	{
		if (pageNumber < 0)
			pageNumber = 1;

		return ((pageNumber - 1) * pageItemSize) + 1;
	}

	public int getEndItenIndex(int pageNumber, int recCnt)
	{
		if (pageNumber <= 0)
			pageNumber = 1;

		return recCnt - ((pageNumber - 1) * pageItemSize);
	}
	
	public String htmlPage(){
	   String page = "";
	   if(havePrev){
	      page += CHANGEPAGE+(currentPageGroup[0]-1)+");' class='prev-page'>이전페이지</a>";
	   }
	   
	   StringBuilder bld = new StringBuilder();
	   for(int i = 0; i < currentPageGroup.length; i++){
	      if(currentPageGroup[i] == currentPage){
	    	 bld.append(CHANGEPAGE+currentPageGroup[i]+");' class='num on'>"+currentPageGroup[i]+"</a>");
	      }else{
	    	 bld.append(CHANGEPAGE+currentPageGroup[i]+");' class='num'>"+currentPageGroup[i]+"</a>"); 
	      }
	   }
	   page += bld.toString();
	   
	   if(haveNext){
	      page += CHANGEPAGE+(currentPageGroup[groupSize-1]+1)+");' class='next-page'>다음페이지</a>";
	   }	   
	   return page;
	}
	public String htmlPage(String funcName){
      String page = "";
      if(havePrev){
         page += FUNCTIONPAGE+funcName+"("+(currentPageGroup[0]-1)+");' class='prev-page'>이전페이지</a>";
      }
      
      StringBuilder bld = new StringBuilder();
      for(int i = 0; i < currentPageGroup.length; i++){
         if(currentPageGroup[i] == currentPage){
        	 bld.append(FUNCTIONPAGE+funcName+"("+currentPageGroup[i]+");' class='num on'>"+currentPageGroup[i]+"</a>");
         }else{
        	 bld.append(FUNCTIONPAGE+funcName+"("+currentPageGroup[i]+");' class='num'>"+currentPageGroup[i]+"</a>");
         }
      }
      page += bld.toString();
      
      if(haveNext){
         page += FUNCTIONPAGE+funcName+"("+(currentPageGroup[groupSize-1]+1)+");' class='next-page'>다음페이지</a>";
      }     
      return page;
   }
}
