<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<p class="title d-up-lg">${data.skillName}</p>
<ol class="list">
	<li class="step1 ${step1Class}">
		<span class="state"><spring:message code="evaluate.skill.step1" text="Auto reporte" /></span>
	</li>
	<c:if test="${data.badgeObtainLevelCode == '1502' || data.badgeObtainLevelCode == '1503'}">
		<li class="step2 ${step2Class}">
			<span class="state"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></span>
		</li>
	</c:if>
	<c:if test="${data.badgeObtainLevelCode == '1503' || data.badgeObtainLevelCode == '1504'}">
		<li class="step3 ${step3Class}">
			<span class="state"><spring:message code="evaluate.skill.step3-1" text="Validación" /><br><spring:message code="evaluate.skill.step3-2" text="de pares" /></span>
		</li>
	</c:if>
</ol>
<c:if test="${skillDisabled == 'disabled'}">
	<span class="msg-disabled"><spring:message code="evaluate.alert.cant-continue-1" text="No puede continuar con la" /><br><spring:message code="evaluate.alert.cant-continue-2" text="prueba" /></span>
</c:if>