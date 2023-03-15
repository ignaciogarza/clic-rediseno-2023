package com.iscreammedia.clic.front.service;

import java.util.Locale;

import com.iscreammedia.clic.front.domain.ApiList;
import com.iscreammedia.clic.front.domain.Faq;
import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.repository.FaqRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class FaqService {

	@Autowired
	private FaqRepository faqRepository;

	public ApiList<Faq> getFaqList(Locale locale, String faqTypeCode, int offset, int limit) {
		return new ApiList<>(faqRepository.getFaqCount(faqTypeCode),
				faqRepository.getFaqList(LanguageCode.getLanguage(locale), faqTypeCode, offset, limit));
	}
}
