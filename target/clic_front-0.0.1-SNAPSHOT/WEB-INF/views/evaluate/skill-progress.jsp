<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%--
NOT_TESTED,
PASS,
/* */
SELF_EXAM_WAIT,
SELF_EXAM_TAKING,
SELF_EXAM_TIME_OUT,
SELF_EXAM_FAILED,
SELF_EXAM_PASS,
/* */
SKILL_EXAM_WAIT,
SKILL_EXAM_TAKING,
SKILL_EXAM_TIME_OUT,
SKILL_EXAM_FAILED,
SKILL_EXAM_PASS,
/* */
FRIEND_AUTH_WAIT,
FRIEND_AUTH_TAKING,
FRIEND_AUTH_PASS,
--%>

<c:set var="isView" value="${false}"/>
<c:set var="progress" value="${data.progressStatusCode}"/>
<c:set var="skillDisabled" value="${(data.isUse == 'N' && progress != 'NOT_TESTED') ? 'disabled' : ''}"/>
<c:set var="testEnabled" value="${true}"/>

<%-- side --%>
<c:set var="step1Class" value=""/>
<c:set var="step2Class" value=""/>
<c:set var="step3Class" value=""/>
<c:set var="badgeImage" value=""/>
<c:if test="${progress == 'SELF_EXAM_TAKING'}">
	<c:set var="isView" value="${true}"/>
	<c:set var="step1Class" value="ongoing"/>
	<c:set var="badgeImage" value="/static/assets/images/content/img-step1-ongoing.png"/>
</c:if>
<c:if test="${progress == 'SELF_EXAM_PASS' || progress == 'SKILL_EXAM_WAIT'}">
	<c:set var="isView" value="${true}"/>
	<c:set var="step1Class" value="on"/>
	<c:set var="badgeImage" value="/static/assets/images/content/img-step1-pass.png"/>
</c:if>
<c:if test="${progress == 'SKILL_EXAM_TAKING'}">
	<c:set var="isView" value="${true}"/>
	<c:set var="step1Class" value="on"/>
	<c:set var="step2Class" value="ongoing"/>
	<c:set var="badgeImage" value="/static/assets/images/content/img-step2-ongoing.png"/>
</c:if>
<c:if test="${progress == 'SKILL_EXAM_PASS' || progress == 'FRIEND_AUTH_WAIT'}">
	<c:set var="isView" value="${true}"/>
	<c:set var="step1Class" value="on"/>
	<c:set var="step2Class" value="on"/>
	<c:set var="badgeImage" value="/static/assets/images/content/img-step2-pass.png"/>
</c:if>
<c:if test="${progress == 'FRIEND_AUTH_TAKING'}">
	<c:set var="isView" value="${true}"/>
	<c:set var="step1Class" value="on"/>
	<c:set var="step2Class" value="on"/>
	<c:set var="step3Class" value="ongoing"/>
	<c:set var="badgeImage" value="/static/assets/images/content/img-step3-ongoing.png"/>
</c:if>
<c:if test="${progress == 'PASS'}">
	<c:set var="isView" value="${false}"/>
	<c:set var="badgeImage" value="${data.badgeObtainImagePath}"/>
</c:if>

<c:if test="${progress == 'SELF_EXAM_TIME_OUT' || progress == 'SELF_EXAM_FAILED' || progress == 'SKILL_EXAM_TIME_OUT' || progress == 'SKILL_EXAM_FAILED'}">
	<c:set var="badgeImage" value="/static/assets/images/content/img-skill-disabled.png"/>
	<c:set var="testEnabled" value="${false}"/>
</c:if>

<c:if test="${data.isUse != 'Y' && empty param.skill}"> <%-- 스킬목록에서 side에 노출 시키지 않기 위해 --%>
	<c:set var="isView" value="false"/>
</c:if>

<c:if test="${data.checkSkillBadgeObtain}">
	<c:set var="isView" value="false"/>
	<c:set var="badgeImage" value="${data.badgeObtainImagePath}"/>
</c:if>