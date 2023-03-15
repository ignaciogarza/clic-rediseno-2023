<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- <c:if test="${(data.badgeObtainLevelCode == '1503' && progress == 'SKILL_EXAM_PASS') || (data.badgeObtainLevelCode == '1504' && progress == 'SELF_EXAM_PASS') || (fn:length(result.authList) > 0)}">
	<h3 class="title1"><spring:message code="evaluate.friend.text1" text="References" /></h3>
	<div class="skill-certificate">
		<c:forEach items="${result.authList}" var="item">
			<div class="item">
				<div class="community-list">
					<div class="profile-area">
						<div class="profile-frame">
							<div class="photo">
								<img
									src="${item.userImagePath}" alt=""
									onerror="this.src='/static/assets/images/common/img-profile-default2.png';"
								>
							</div>
							<div class="country">
								<img
									src="https://flagcdn.com/w640/<c:out value='${fn:toLowerCase(item.countryCode)}'/>.png"
									alt="${item.countryCode}"
									title="${item.countryCode}"
								>
							</div>
							<c:if test="${item.isAuth eq 'Y'}">
								<div class="stat">
									<i class="ico ico-connect"></i>
								</div>
							</c:if>
						</div>
						<div class="profile-info">
							<span class="name">${item.name} ${item.firstName}</span>
							<c:if test="${not empty item.jobName}">
								<span class="career">${item.jobName}</span>
							</c:if>
						</div>
					</div>
				</div>
				<c:if test="${item.isAuth eq 'R'}">
					<div class="state">
						<button type="button" class="btn btn-md btn-outline-gray btn-cancle" data-friend-id="${item.userId}">
							<spring:message code="evaluate.friend.text3-1" text="요청 취소" />
						</button>
					</div>
					<div class="content">
						<p class="text text-darkgray"><spring:message code="evaluate.friend.text3-2" /></p>
					</div>
				</c:if>
				<c:if test="${item.isAuth eq 'Y'}">
					<div class="state">
						<p class="text-complete"><spring:message code="community.text11" text="인증 완료" /></p>
					</div>
					<div class="content">
						<p class="text">${item.authContents}</p>
					</div>
				</c:if>
			</div>
		</c:forEach>
		<c:forEach begin="${fn:length(result.authList)}" end="2" var="i">
			<div class="item">
				<div class="community-list">
					<div class="profile-area">
						<div class="profile-frame">
							<div class="photo">
								<img src="/static/assets/images/common/img-profile-default2.png" alt="">
							</div>
						</div>
					</div>
				</div>
				<div class="state">
					<button type="button" class="btn btn-md btn-secondary btn-request">
						<spring:message code="evaluate.friend.text2-1" text="인증 요청" />
					</button>
				</div>
				<div class="content">
					<p class="text text-darkgray"><spring:message code="evaluate.friend.text2-2" /></p>
				</div>
			</div>
		</c:forEach>
	</div>
</c:if> --%>