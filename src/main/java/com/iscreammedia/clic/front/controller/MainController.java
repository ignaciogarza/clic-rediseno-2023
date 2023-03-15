package com.iscreammedia.clic.front.controller;

import java.util.HashMap;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.LocaleResolver;

import com.iscreammedia.clic.front.configuration.http.BaseResponse;
import com.iscreammedia.clic.front.controller.viewmodel.PageInfo;
import com.iscreammedia.clic.front.controller.viewmodel.ViewMainList;
import com.iscreammedia.clic.front.domain.CommunityDomain;
import com.iscreammedia.clic.front.service.CommunityService;
import com.iscreammedia.clic.front.service.MainService;

import io.swagger.annotations.ApiOperation;

@Controller
@RequestMapping("/main")
public class MainController {

	Logger logger = LoggerFactory.getLogger(getClass());

	@Autowired
	private MainService mainService;

	@Autowired
	private CommunityService communityService;

	@Autowired
	private LocaleResolver localeResolver;

	private static final String USERID = "userId";
	private static final String PORTFOLIO = "portfolio";
	private static final String SEARCHVALUE = "searchValue";

	@GetMapping("")
	@ApiOperation(value = "CLIC 메인 View")
	public String mainView() {
		return "main/main";
	}

	/**
	 * 회원 설문조사 참여조회
	 * 
	 * @param
	 * @return
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("")
	@ResponseBody
	@ApiOperation(value = "CLIC 메인, 회원 설문조사 참여조회")
	public BaseResponse<String> main(HttpServletRequest request) {
		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);
		String isComplete = mainService.getUserSurveyInfo(userId);

		return new BaseResponse<>(isComplete);
	}

	/**
	 * 메인 검색 (사람/포토폴리오)
	 * 
	 * @param
	 * @return
	 * @ exception 예외사항
	 * 
	 */
	@GetMapping("/mainSearchView")
	@ApiOperation(value = "메인 검색 (사람/포토폴리오) ")
	public String mainSearchView(Model model, HttpServletRequest request,
			@ModelAttribute("view") ViewMainList view,
			@RequestParam(value = "mainPage", required = false, defaultValue = "1") int page,
			@RequestParam(value = "mainRows", required = false, defaultValue = "15") int rows,
			@RequestParam(value = "type", required = false, defaultValue = "user") String type,
			@RequestParam(value = "madinSearchValue", required = false) String searchValue) {

		String pageView = null;
		if (type.equals("user")) {
			// 회원 조회 페이지
			pageView = "main/mainUserSearchView";
		} else if (type.equals(PORTFOLIO)) {
			// 포토폴리오 조회 페이지
			pageView = "main/mainPortfolioSearchView";
		}
		return pageView;
	}

	/**
	 * 메인 검색 (사람/포토폴리오)
	 * 
	 * @param
	 * @return
	 * @ exception 예외사항
	 * 
	 */
	@PostMapping("/mainSearchList")
	@ResponseBody
	@ApiOperation(value = "메인 검색 조회")
	public BaseResponse<ViewMainList> mainSearchList(HttpServletRequest request,
			@RequestParam(value = "mainPage", required = false, defaultValue = "1") int page,
			@RequestParam(value = "mainRows", required = false, defaultValue = "15") int rows,
			@RequestParam(value = "type", required = false, defaultValue = "user") String type,
			@RequestParam(value = "madinSearchValue", required = false) String searchValue) {

		HttpSession session = request.getSession();
		String userId = (String) session.getAttribute(USERID);

		ViewMainList view = new ViewMainList();

		HashMap<String, Object> paramData = new HashMap<>();
		paramData.put("page", page);
		paramData.put("rows", rows);
		paramData.put(SEARCHVALUE, searchValue);

		paramData.put(USERID, userId);

		view.setPage(page);
		view.setRows(rows);

		view.setType(type);

		// 친구 조회
		List<CommunityDomain> friendCheckList = communityService.getFriendCheckList(userId);
		view.setFriendCheckList(friendCheckList);

		int userTotal = 0;
		int portfolioTotal = 0;

		String[] splited = searchValue.split("\\s+");
		for (int i = 0; i < splited.length; i++) {
			paramData.put(SEARCHVALUE, splited[i]);
			// 회원 조회 카운트
			userTotal = mainService.getUserSearchCount(paramData);
			view.setUserTotal(userTotal);

			// 포토폴리오 조회 카운트
			portfolioTotal = mainService.getPortfolioSearchCount(paramData);
			view.setPortfolioTotal(portfolioTotal);
		}

		int startIndex = 0;

		if (type.equals("user") && userTotal != 0) {
			startIndex = (page - 1) * rows;
			paramData.put("startIndex", startIndex);

			for (int i = 0; i < splited.length; i++) {
				paramData.put(SEARCHVALUE, splited[i]);
				view.setUserlist(mainService.getUserSearchList(paramData));
			}

			PageInfo pi = new PageInfo(userTotal, rows, 10, page);
			view.setTotalCount(userTotal);
			view.setTotalPage(pi.getTotalPage());
		}

		if (type.equals(PORTFOLIO) && portfolioTotal != 0) {
			startIndex = (page - 1) * rows;
			paramData.put("startIndex", startIndex);

			view.setPortfoliolist(mainService.getPortfolioSearchList(paramData));

			PageInfo pi = new PageInfo(portfolioTotal, rows, 10, page);
			view.setTotalCount(portfolioTotal);
			view.setTotalPage(pi.getTotalPage());
		}
		return new BaseResponse<>(view);
	}

}
