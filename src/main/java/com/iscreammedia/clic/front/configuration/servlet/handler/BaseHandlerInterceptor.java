package com.iscreammedia.clic.front.configuration.servlet.handler;

import java.util.Calendar;
import java.util.HashMap;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.ModelAndView;

import com.iscreammedia.clic.front.domain.UserDomain;
import com.iscreammedia.clic.front.repository.MessageRepository;
import com.iscreammedia.clic.front.repository.NoticeRepository;
import com.iscreammedia.clic.front.service.UserService;

public class BaseHandlerInterceptor implements HandlerInterceptor {
	Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private MessageRepository messageRepository;

	@Autowired
	private NoticeRepository noticeRepository;

	@Autowired
	private UserService userService;

	@Value("${SecretKey}")
	private String secretKey;

	private static final String USERID = "userId";
	private static final String LOGINURL = "/login/login";

	@Override
	public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler)
			throws Exception {

		boolean result = true;
		logger.info("************preHandle request URI : {}************", request.getRequestURI());
		logger.info("************preHandle getServletPath URI : {}************", request.getServletPath());
		String url = request.getRequestURI();

		HttpSession session = request.getSession();
		session.getAttribute(USERID);

		// 사용자 메뉴접근 이력 저장
		HashMap<String, Object> paramData = new HashMap<>();

		// 월 세팅
		Calendar cal = Calendar.getInstance();
		int month = cal.get(Calendar.MONTH) + 1;

		// uri 세팅
		// String uri = request.getRequestURI();
		// String[] urlDate = uri.split("/");
		// String frontMenuUri = "/";
		// if (urlDate.length >= 2) {
		// frontMenuUri = "/" + urlDate[1];
		// }
		String uri = request.getRequestURI();
		String[] urlDate = uri.split("/");
		String frontMenuUri = "/" + urlDate[1];

		// os 타입 세팅
		String userAgent = request.getHeader("user-agent");
		boolean mobile1 = userAgent.matches(
				".*(iPhone|iPod|Android|Windows CE|BlackBerry|Symbian|Windows Phone|webOS|Opera Mini|Opera Mobi|POLARIS|IEMobile|lgtelecom|nokia|SonyEricsson).*");
		boolean mobile2 = userAgent.matches(".*(LG|SAMSUNG|Samsung).*");

		String osType = null;
		if (mobile1 || mobile2) {
			osType = "M";
		} else {
			osType = "P";
		}

		paramData.put(USERID, (String) session.getAttribute(USERID));
		paramData.put("frontMenuUri", frontMenuUri);
		paramData.put("month", month);
		paramData.put("osType", osType);
		userService.accessHistoryInsert(paramData);

		/*
		 * 로그인 체크
		 * _USER_INFO
		 */
		if (!"/main".equals(url)
				&& !"/studio/project/portfolioOthersMemberView".equals(url)
				&& !"/studio/project/portfolioOthersMemberList".equals(url)
				&& !"/studio/project/portfolioOthersMemberProjectView".equals(url)
				&& !"/studio/project/portfolioOthersMemberProjectList".equals(url)
				&& !"/studio/project/projectContentsOutImageFrom".equals(url)
				&& !"/studio/project/projectContentsImageList".equals(url)
				&& !"/studio/project/projectContentsList".equals(url)
				&& !"/common/terms-and-conditions".equals(url)
				&& !"/common/privacy-policy".equals(url)
				&& !"/common/contact-us".equals(url)
				&& !"/common/faq".equals(url)) {
			String userId = (String) session.getAttribute(USERID);
			if (userId != null) {

				// 로그인 세션 조회
				UserDomain loginHistory = userService.getLoginHistory(userId);

				if (loginHistory != null) {
					// 세션 30분 체크 해서 로그인 만료 처리 해야 함 만료 되었으면 db 삭제 처리
					if (loginHistory.getLimitDate() >= 30) {
						logger.info("****************************** 세션 만료 **********************************");
						// 삭제 처리
						userService.loginHistoryDelete(loginHistory.getUserId());
						// 세션 삭제
						session.invalidate();

						response.sendRedirect(LOGINURL);
						return false;
					} else {
						// 세션 만료 안되었으면 로그인세션 db 시간 최신 시간으로 업데이트
						userService.loginHistoryUpdate(userId);
						session.setMaxInactiveInterval(1800); // 세션 시간 연장
					}

				} else {
					logger.info("****************************** DB 값이 없으면 **********************************");
					response.sendRedirect(LOGINURL);
					return false;
				}

			} else {
				logger.info("**************** 키값 없을대 **************");
				response.sendRedirect(LOGINURL);
				return false;
			}

		}

		return result;
	}

	@Override
	public void postHandle(HttpServletRequest request, HttpServletResponse response, Object handler, ModelAndView view)
			throws Exception {
		HttpSession session = request.getSession();
		if (session.getAttribute(USERID) != null && view != null) {
			String userId = (String) session.getAttribute(USERID);
			view.addObject("isNewNotice", noticeRepository.confirmNewNotice(userId));
		}
		logger.info("postHandle request URI : {}", request.getRequestURI());
	}

}
