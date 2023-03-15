package com.iscreammedia.clic.front.service;

import java.util.Locale;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Terms;
import com.iscreammedia.clic.front.repository.TermsRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TermsService {

	@Autowired
	private TermsRepository termsRepository;

	public Terms getTerms(Locale locale, String faqTypeCode) {
		return termsRepository.getTerms(LanguageCode.getLanguage(locale), faqTypeCode);
	}
}
