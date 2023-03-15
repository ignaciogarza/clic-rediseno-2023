<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<div class="popup-header">
	<div class="inner">
		<div class="img-logo d-up-lg">Clic</div>
		<h2 class="popup-title d-down-md skillName"></h2>
	</div>
</div>
<div class="popup-body test-question">
	<div class="inner">
		<div class="question-wrap">
			<div class="question-info infoQuestion">
				<div class="title">
					<p class="skill-name d-up-lg skillName"></p>
					<p class="test-title skillTitle">
						<%-- <c:if test="${data.skill.skillProgressLevelCode == '1202'}"><!-- 자가 시험 --><spring:message code="evaluate.skill.step1" text="Auto reporte" /></c:if>
						<c:if test="${data.skill.skillProgressLevelCode == '1203'}"><!-- 기술 시험 --><spring:message code="evaluate.skill.step2" text="Comportamiento" /></c:if> --%>
					</p>
				</div>
				<dl class="time">
					<dt><spring:message code="evaluate.question.remain-time" text="Tiempo restante" /></dt>
					<dd><!--40:00--></dd>
				</dl>
			</div>
			<%-- <div class="question-progress q${data.totalQuestionCount}">
				<div class="bar p${data.displaySequence}">
					<span class="fill"><span class="number">${data.displaySequence}/${data.totalQuestionCount}</span></span>
				</div>
			</div> --%>
			<div class="question-area">
				<!-- 기술테스트 문제 출력 -->
				<div class="item questionContents">
					<%-- <p class="text-purpose">${data.questionContents}</p>
					<c:if test="${not empty data.questionImagePath}">
						<div class="img-area">
							<img src="${data.questionImagePath}" alt="">
						</div>
					</c:if> --%>
				</div>
				<div class="item">
					<p class="text-question questionTitle"></p>
					<form id="answerForm">
						<input type="hidden" name="questionId" value="">
						<input type="hidden" name="examProgressId" value="">