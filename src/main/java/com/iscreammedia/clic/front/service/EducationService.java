package com.iscreammedia.clic.front.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.CommonDomain;
import com.iscreammedia.clic.front.repository.EducationRepository;

@Service
public class EducationService {
	
	@Autowired
	private EducationRepository educationRepository;
	
	public List<CommonDomain> getCountryListss(int startNum, int endNum, String countryCode){
		return educationRepository.getCountryListss(startNum, endNum, countryCode);
	}
	

}
