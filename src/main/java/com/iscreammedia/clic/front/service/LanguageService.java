package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.LanguageDomain;
import com.iscreammedia.clic.front.repository.LanguageRepository;

@Service
public class LanguageService {
	
	@Autowired
	private LanguageRepository languageRepository;
	
	/**
	 * 언어 조회
	 * @param    
     * @return
	 * @ exception 예외사항
	 * 
	 * */
	public List<LanguageDomain> selectLanguageList(Locale locale) {
		return languageRepository.selectLanguageList(LanguageCode.getLanguage(locale));
	}
	
}
