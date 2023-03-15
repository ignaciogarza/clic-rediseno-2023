package com.iscreammedia.clic.front.controller.viewmodel;




import lombok.Data;

@Data

public class ViewListBase { 

	//@ApiModelProperty(required = false,value="페이지번호")
	protected int page;
	
	//@ApiModelProperty(required = false,value="리스트개수")
	protected int rows;
	
	//@ApiModelProperty(required = false,value="리스트 총 수")
	protected int totalCount;
	
	//@ApiModelProperty(required = false,value="페이지 총 수")
	protected int totalPage;

	//@ApiModelProperty(required = false,value="언어")
	protected String language;
	
	//@ApiModelProperty(required = false,value="검색어")
	protected String searchValue;
	
	//@ApiModelProperty(required = false,value="검색유형")
	protected String searchType;
	
	//@ApiModelProperty(required = false,value="검색기간시작")
	protected String periodBegin;
	
	//@ApiModelProperty(required = false,value="검색기간종료")
	protected String periodEnd;
	
	protected ViewListBase() {
        this.page = 1;
        this.rows = 10;
    }
	
}
