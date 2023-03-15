package com.iscreammedia.clic.front.configuration.http;

import lombok.Data;

@Data
public class BaseResponse<T> {
	private BaseResponseCode code;
	private String message;
	private String messageCode;
	private T data;
	
	public BaseResponse() {
		this.code = BaseResponseCode.SUCCESS;
	}
	
	public BaseResponse(T data) {
		this.code = BaseResponseCode.SUCCESS;
		this.data = data;
	}

	public BaseResponse(BaseResponseCode code, String message) {
		this.code = code;
		this.message = message;
	}

	public BaseResponse(BaseResponseCode code) {
		this.code = code;
	}

}
