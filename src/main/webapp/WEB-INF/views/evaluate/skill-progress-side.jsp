<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<c:if test="${isView}">
	<div class="skill-progress ${skillDisabled}">
		<%@ include file="skill-progress-side-list.jsp" %>
	</div>
	<div class="division-line mt-4 mb-4"></div>
</c:if>