package com.iscreammedia.clic.front.domain;

import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

@Getter
@Setter
@ToString
public class CertificateResultDomain {

	private Skill skill;
	private ExamResult examResult;
	private Exam exam;
	
}
