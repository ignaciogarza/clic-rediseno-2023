package com.iscreammedia.clic.front.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.LanguageDomain;


@Repository
public interface LanguageRepository {
	
	/**
	 * 언어 조회
	 * */
	List<LanguageDomain> selectLanguageList(@Param("language") LanguageCode language);
	
}
