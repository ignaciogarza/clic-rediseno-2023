package com.iscreammedia.clic.front.domain;

import lombok.Data;

@Data
public class AuthNumberDomain {
	
	private String email;		
	private String authNumber;
	private String createdDate;
	private String authDate;
	
	private String password;

}
