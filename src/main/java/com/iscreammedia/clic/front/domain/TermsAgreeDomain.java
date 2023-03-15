package com.iscreammedia.clic.front.domain;

import lombok.Data;

@Data
public class TermsAgreeDomain {
	
	private int termsId; 				
	private String termsTypeCode; 		
	private String termsTitleEng; 		
	private String termsTitleSpa; 		
	private String termsContnetsEng;	
	private String termsContnetsSpa; 	
	private String contentsStatusCode; 	
	private String isMandatory; 			
	private String createdDate; 			
	private String creator; 				
	private String updatedDate; 			
	private String updater; 	
	
	private int termsAgreeId;
	private String userId;				

}
