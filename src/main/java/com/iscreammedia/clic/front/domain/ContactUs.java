package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class ContactUs {
	private String name;
	private String lastName;
	private String email;
	private String subject;
	private String contents;
}
