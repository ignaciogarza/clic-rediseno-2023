package com.iscreammedia.clic.front.framework.data.domain;

import com.fasterxml.jackson.annotation.JsonIgnore;

import lombok.Data;

@Data
public class MySqlPageRequest {
	
	private int page;
	private int size;
	
	@JsonIgnore
	private int limit;
	
	@JsonIgnore
	private int offset;
	
	public MySqlPageRequest(int page, int size, int limit, int offset) {
		this.page = page;
		this.size = size;
		this.limit = limit;
		this.offset = offset;
	}
	
	

}
