package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.ProgramingDomain;
import com.iscreammedia.clic.front.repository.ProgramingRepository;

@Service
public class ProgramingService {
	
	@Autowired
	private ProgramingRepository programingRepository;
	
	/**
	 * 프로그래밍 조회
	 * @param    
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<ProgramingDomain> selectProgramingList(Locale locale) {
		return programingRepository.selectProgramingList(LanguageCode.getLanguage(locale));
	}
	
}
