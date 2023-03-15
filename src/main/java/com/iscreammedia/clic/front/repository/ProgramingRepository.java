package com.iscreammedia.clic.front.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.ProgramingDomain;


@Repository
public interface ProgramingRepository {
	
	/**
	 * 프로그래밍 조회
	 * */
	List<ProgramingDomain> selectProgramingList(@Param("language") LanguageCode language);
	
}
