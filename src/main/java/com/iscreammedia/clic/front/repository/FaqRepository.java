package com.iscreammedia.clic.front.repository;

import java.util.List;

import com.iscreammedia.clic.front.domain.Faq;
import com.iscreammedia.clic.front.domain.LanguageCode;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface FaqRepository {
	public int getFaqCount(@Param("faqTypeCode") String faqTypeCode);

	public List<Faq> getFaqList(
			@Param("language") LanguageCode language,
			@Param("faqTypeCode") String faqTypeCode,
			@Param("offset") int offset,
			@Param("limit") int limit
	);
}
