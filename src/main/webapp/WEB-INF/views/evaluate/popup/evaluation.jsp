<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!-- 문제 평가 -->
<div class="popup-header">
	<div class="inner">
		<div class="img-logo d-up-lg">Clic</div>
		<h2 class="popup-title d-down-md"><spring:message code="evaluate.tutorial.title" /></h2>
	</div>
</div>
<div class="popup-body test-evaluation">
	<div class="evaluation-wrap">
		<div class="evaluation-inner">
			<div class="text-evaluation">
				<p class="main-text"><spring:message code="evaluate.popup.text.1" text="이 테스트에 대해 어떻게 생각하세요?" /></p>
				<p class="sub-text"><spring:message code="evaluate.popup.text.2" text="문제에 대한 의견을 남겨주세요." /></p>
			</div>
			<form id="answerForm">
				<div class="star-rating">
					<input type="radio" name="examEvaluation" id="inputRadio1" value="1">
					<label for="inputRadio1"></label>
					<input type="radio" name="examEvaluation" id="inputRadio2" value="2">
					<label for="inputRadio2"></label>
					<input type="radio" name="examEvaluation" id="inputRadio3" value="3">
					<label for="inputRadio3"></label>
					<input type="radio" name="examEvaluation" id="inputRadio4" value="4">
					<label for="inputRadio4"></label>
					<input type="radio" name="examEvaluation" id="inputRadio5" value="5">
					<label for="inputRadio5"></label>
				</div>
				<textarea cols="30" rows="10" class="form-control full" name="examEvaluationContents" maxlength="600"
				placeholder="<spring:message code="evaluate.popup.text.3" text="내용을 입력하세요(선택)" />"></textarea>
			</form>
		</div>
	<div class="btn-group-default btn-fixed">
		<div class="btn-cell d-down-md">
			<a href="javascript:;" class="btn btn-md btn-primary btn-close-popup" onclick="confirmTestGiveUp()"><spring:message code="button.cancel" text="취소" /></a>
		</div>
		<div class="btn-cell btn-cell-right">
			<button type="button" class="btn btn-md btn-secondary btn-check" id="btnNext" onclick="fnTestResult()" disabled><spring:message code="button.check-result" text="결과 확인" /></button>
		</div>
	</div>
</div>
<script>
$(function() {

	$('[name=examEvaluation]').on('change', function() {
		$('#btnNext').prop('disabled', $('[name=examEvaluation]:checked').length == 0);
	});

	// $('[name=examEvaluationContents]').on('keyup', function() {
	// 	$('#btnNext').prop('disabled', ($(this).val().trim() == '' || $('[name=examEvaluation]:checked').length == 0));
	// });
	//<c:if test="${not empty shortAnswer}">$('[name=shortAnswer]').trigger('keyup');</c:if>
});

function fnTestResult() {
	$.ajax({
		url: '/eval/evaluation/' + popupType,
		method: 'POST',
		dataType: 'json',
		data: 'skill=' + skill + '&class=' + clazz + '&' + $('#answerForm').serialize(),
		success: function(result) {
			let html = '';
			if(result.data == 'Y') {
				html += '<i class="ico ico-check"></i>\n';
				html += '<h2 class="popup-title"><spring:message code="evaluate.popup.pass-title" text="잘했어요!" /></h2>\n';
				html += '<p class="text mt-lg-5 mt-md-2">\n';
				html += '	<spring:message code="evaluate.popup.pass-text1" text="테스트에 합격하셨습니다." /><br>\n';
				html += '	<spring:message code="evaluate.popup.pass-text2" text="자세한 테스트결과를 확인하세요." />\n';
				html += '</p>\n';
				html += '<div class="btn-group-default mt-lg-8 mt-md-8">\n';
				html += '	<a href="/eval/skill?skill=' + skill + '&class=' + clazz + '" class="btn btn-md btn-secondary" id="btnPopupCheck"><spring:message code="button.check" text="확인" /></a>\n';
				html += '</div>\n';
			}
			else if(result.data == 'N') {
				html += '<i class="ico ico-fail"></i>\n';
				html += '<h2 class="popup-title"><spring:message code="evaluate.popup.fail-title" text="안타깝네요!" /></h2>\n';
				html += '<p class="text mt-lg-5 mt-md-2">\n';
				html += '	<spring:message code="evaluate.popup.fail-text1" text="테스트에 통과하지 못하였습니다." /><br>\n';
				html += '	<spring:message code="evaluate.popup.fail-text2-1" text="" />\n';
				html += '	<span class="text-primary text-semibold"><spring:message code="evaluate.popup.fail-text2-2" text="48시간" /></span>\n';
				html += '	<spring:message code="evaluate.popup.fail-text2-3" text="이후에 다시 참여할 수 있습니다." /><br>\n';
				html += '	<spring:message code="evaluate.popup.fail-text3" text="결과를 확인 후 향상 시켜야 하는 부분을 알아보세요." />\n';
				html += '</p>\n';
				html += '<div class="btn-group-default mt-lg-8 mt-md-8">\n';
				html += '	<a href="/eval/list" class="btn btn-md btn-secondary" id="btnPopupCheck"><spring:message code="button.check" text="확인" /></a>\n';
				html += '</div>\n';
			}
			else {
				$(window).off('beforeunload');
				location.href = '/error';
			}
			$(window).off('beforeunload');
			console.log(html)
			$('#layer-result .popup-body').html(html);
			console.log($('#layer-result .popup-body').html())
			openModal('#layer-result');
		},
		error: function() {
			$(window).off('beforeunload');
			location.href = '/error';
		}
	});
}
</script>