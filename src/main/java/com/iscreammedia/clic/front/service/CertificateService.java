package com.iscreammedia.clic.front.service;

import java.util.List;
import java.util.Locale;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.iscreammedia.clic.front.domain.LanguageCode;
import com.iscreammedia.clic.front.domain.Skill;
import com.iscreammedia.clic.front.repository.CertificateRepository;

@Service
public class CertificateService {

	@Autowired
	private CertificateRepository certificateRepository;

	/**
	 * 보유 스킬 목록 조회
	 * </p>
	 * 개인이 획득한 합격/뱃지 정보
	 * @param locale
	 * @param userId
	 * @return
	 */
	public List<Skill> getHaveSkillList(Locale locale, String userId, String local) {
		return certificateRepository.getHaveSkillList(LanguageCode.getLanguage(locale), userId, local);
	}
}
