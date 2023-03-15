package com.iscreammedia.clic.front.repository;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Skill;

@Repository
public interface CertificateRepository {

	public List<Skill> getHaveSkillList(@Param("language") LanguageCode language, @Param("userId") String userId, @Param("local") String local);
	
}
