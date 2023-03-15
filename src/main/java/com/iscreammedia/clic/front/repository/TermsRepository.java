package com.iscreammedia.clic.front.repository;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Terms;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

@Repository
public interface TermsRepository {
	public Terms getTerms(@Param("language") LanguageCode language, @Param("termsTypeCode") String termsTypeCode);
}
