<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 테스트 가이드 -->
<div class="popup-header">
	<div class="inner">
		<div class="img-logo d-up-lg">Clic</div>
		<h2 class="popup-title d-down-md"><spring:message code="evaluate.tutorial.title" /></h2>
	</div>
</div>
<div class="popup-body test-guide">
	<div class="inner">
		<p class="title d-up-lg"><spring:message code="evaluate.tutorial.title" /></p>
		<div class="guide-wrap">
			<ol class="list">
				<li>
					<strong><spring:message code="evaluate.tutorial.text1-1" /></strong>
					<spring:message code="evaluate.tutorial.text1-2" />
				</li>
				<li>
					<strong><spring:message code="evaluate.tutorial.text2-1" /></strong>
					<spring:message code="evaluate.tutorial.text2-2" />
				</li>
				<li>
					<strong><spring:message code="evaluate.tutorial.text3-1" /></strong>
					<spring:message code="evaluate.tutorial.text3-2" />
				</li>
			</ol>
			<div class="img-area">
			</div>
		</div>
	</div>
	<div class="btn-group-default btn-fixed">
		<div class="inner">
			<div class="btn-cell btn-cell-left">
				<button type="button" class="btn btn-md btn-primary btn-close-popup" onclick="fnTestPopupClose()"><spring:message code="button.cancel" text="취소" /></button>
			</div>
			<div class="btn-cell btn-cell-right">
				<button type="button" class="btn btn-md btn-secondary btn-next" onclick="fnTestStart()"><spring:message code="button.next" text="다음" /></button>
			</div>
		</div>
	</div>
</div>
<script>
$(function() {
	getPopupTutorial();

	//튜토리얼 가이드 이미지(영어, 스페인어)
	var pcImg = '<spring:message code="evaluate.tutorial.img1" text="/static/assets/images/content/img-turoial.png" />';
	var mobileImg = '<spring:message code="evaluate.tutorial.img2" text="/static/assets/images/content/img-turoial-m.png" />';
	var tutorialImg = '';
		tutorialImg += '<img src="'+pcImg+'" class="d-up-lg" alt="">';
		tutorialImg += '<img src="'+mobileImg+'" class="d-down-md" alt="">';
		$('div.img-area').append(tutorialImg);
});

function fnTestStart() {
	$.ajax({
		url: '/eval/exam/' + popupType + '/popup',
		method: 'POST',
		dataType: 'html',
		data: {
			skill: skill,
			class: clazz,
			no: '1'
		},
		complete: function(jqXHR) {
			$('#layer-test .test-popup').html(jqXHR.responseText);
		}
	});
}
//튜토리얼 popup api
function getPopupTutorial() {
	$.ajax({
		url: '/eval/exam/tutorial/popup/api',
		type: 'POST',
		dataType: 'json',
		data: {
			skill: skill,
			class: clazz
		},
		success: function(response) {
			var result = response.data;
			console.log(result);
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}

</script>