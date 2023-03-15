package com.iscreammedia.clic.front.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.CommonDomain;

@Repository
public interface EducationRepository {
	
	List<CommonDomain> getCountryListss(@Param("startNum") int startNum, @Param("endNum") int endNum, @Param("countryCode") String countryCode);
	

}
