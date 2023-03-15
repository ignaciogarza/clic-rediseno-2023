<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div id="references" class="pdf-area">
	<div class="total-rate">
		<%-- <div class="item">
			<p class="title"><spring:message code="evaluate.skill.step1" text="Auto-reporte" /></p>
			<c:set var="score" value="${result.selfComplete ? result.selfFinalScore : 0}"/>
			<div class="donut-widget ${score eq 0 ? 'darkblue' : ''}"
				data-chart-size="large"
				data-chart-max="100"
				data-chart-value="${score}"
				data-chart-primary="#88386d"
				data-chart-background="#edf0f5">
			</div>
		</div>
		<c:if test="${data.badgeObtainLevelCode == '1502' || data.badgeObtainLevelCode == '1503'}">
			<div class="item">
				<p class="title"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></p>
				<c:set var="score" value="${result.skillComplete ? result.skillFinalScore : 0}"/>
				<div class="donut-widget ${score eq 0 ? 'darkblue' : ''}"
					data-chart-size="large"
					data-chart-max="100"
					data-chart-value="${score}"
					data-chart-primary="#167e87"
					data-chart-background="#edf0f5">
				</div>
			</div>
		</c:if>
		<c:if test="${data.badgeObtainLevelCode == '1503' || data.badgeObtainLevelCode == '1504'}">
			<div class="item">
				<p class="title">
					<spring:message code="evaluate.skill.step3-1" text="Validación" />
					<br class="d-down-sm"><spring:message code="evaluate.skill.step3-2" text="de pares" />
				</p>
				<c:set var="score" value="${result.friendRecommendCount}"/>
				<div class="donut-widget ${score eq 0 ? 'darkblue' : ''}"
					data-chart-size="large"
					data-chart-max="3"
					data-chart-value="${score}"
					data-chart-text="${score}/3"
					data-chart-primary="#81BA26"
					data-chart-background="#edf0f5">
				</div>
			</div>
		</c:if> --%>
	</div>
	<div class="detail-rate">
		<%-- <c:forEach items="${result.detailList}" var="item">
			<dl class="item">
				<dt>${item.title}</dt>
				<dd>
					<div class="bar-percent purple">
						<div class="bar p${result.selfComplete ? item.selfScore : 0}">
							<span class="fill"><span class="number">${result.selfComplete ? item.selfScore : 0}%</span></span>
						</div>
					</div>
					<div class="bar-percent blue-green">
						<div class="bar p${result.skillComplete ? item.skillScore : 0}">
							<span class="fill"><span class="number">${result.skillComplete ? item.skillScore : 0}%</span></span>
						</div>
					</div>
					<p class="content">${item.contents}</p>
				</dd>
			</dl>
		</c:forEach> --%>
	</div>
</div>