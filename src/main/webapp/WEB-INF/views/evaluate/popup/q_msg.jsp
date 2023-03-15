<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!-- 주관식 -->
<%-- <%@ include file="common/q-header.jsp" %> --%>
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
							<script>
							$(function() {
								alert('<spring:message code="error.msg.1.content" />');
								location.href = '/eval/list';
							});
							</script>
					</form>
				</div>
				<!-- // 기술테스트 문제 출력 -->
			</div>
		</div>
	</div>
	<div class="btn-group-default btn-fixed">
		<div class="inner">
			<div class="btn-cell btn-cell-left">
				<a href="javascript:;" class="btn btn-md btn-primary btn-close-popup" onclick="confirmTestGiveUp()"><spring:message code="button.cancel" text="취소" /></a>
			</div>
			<div class="btn-cell btn-cell-right">
				<%-- <c:if test="${data.displaySequence ne 1}">
					<button type="button" class="btn btn-md btn-outline-gray btn-prev" onclick="fnTestPrev()"><spring:message code="button.prev" text="이전" /></button>
				</c:if> --%>
				<button type="button" class="btn btn-md btn-secondary btn-next" id="btnNext" onclick="fnTestNext()" disabled><spring:message code="button.next" text="다음" /></button>
			</div>
		</div>
	</div>
</div>
<script>
fnExamTimeCountdown(examStartTime, examEndTime);
$(window).trigger('load');
var prevNumber;
var nextNumber;

var giveupMsg = '<spring:message code="evaluate.alert.giveup" javaScriptEscape="true" text="취소 하시겠습니까?" />';
$(function() {
	console.log(displayNumber);
	if(displayNumber == 1) {
		getStartPopupTest();  //시험 첫 페이지
	}
	prevNumber = displayNumber - 1;
	nextNumber = displayNumber + 1;
});

function fnTestPrev() {
	$.ajax({
		url: '/eval/exam/' + popupType + '/popup',
		method: 'POST',
		dataType: 'html',
		data: {
			skill: skill,
			class: clazz,
			no: prevNumber
		},
		complete: function(jqXHR) {
			$('#layer-test canvas').remove();
			$('#layer-test .test-popup').html(jqXHR.responseText);
			displayNumber = displayNumber - 1;
			getChangePopupTest(displayNumber);  //시험 이전/다음 페이지
		}
	});
}
function fnTestNext() {
	console.log($('#answerForm').serialize());
	$.ajax({
		url: '/eval/exam/' + popupType + '/popup',
		method: 'POST',
		dataType: 'html',
		data: 'skill=' + skill + '&class=' + clazz + '&no='+nextNumber+'&' + $('#answerForm').serialize(),
		complete: function(jqXHR) {
			$('#layer-test canvas').remove();
			$('#layer-test .test-popup').html(jqXHR.responseText);
			displayNumber = displayNumber + 1;
			getChangePopupTest(displayNumber);  //시험 이전/다음 페이지
		}
	});
}

//시험 이전/다음 페이지
function getChangePopupTest(number) {
	$.ajax({
		url: '/eval/exam/' + popupType + '/popup/api',
		type: 'POST',
		dataType: 'json',
		data: 'skill=' + skill + '&class=' + clazz + '&no=' + number,
		success: function(response) {
			var data = response.data;
			console.log(data);
			if(data != null) {
				var skill = data.skill;
				var display = data.displaySequence;
				console.log(display);

				if(display != 1) {
					//popup header
					$('h2.popup-title.d-down-md.skillName').text(skill.skillName);
					$('p.skill-name.d-up-lg.skillName').text(skill.skillName);

					var skillTitle = '';
					if(skill.skillProgressLevelCode == '1202') {
						skillTitle += '<spring:message code="evaluate.skill.step1" text="Auto reporte" />';
					} else if(skill.skillProgressLevelCode == '1203') {
						skillTitle += '<spring:message code="evaluate.skill.step2" text="Comportamiento" />';
					}
					$('p.test-title.skillTitle').append(skillTitle);

					var sequence = data.displaySequence;
					var total = data.totalQuestionCount;
					var persent = sequence / total * 100;
					
					var questionProgress = '';
						questionProgress += '<div class="question-progress q'+data.totalQuestionCount+'">';
						questionProgress += '	<div class="bar p'+data.displaySequence+'">';
						questionProgress += '		<span class="fill" style="width:'+persent+'%"><span class="number">'+data.displaySequence+'/'+data.totalQuestionCount+'</span></span>';
						questionProgress += '	</div>';
						questionProgress += '</div>';
					$('div.question-info.infoQuestion').after(questionProgress);

					var reContents = data.questionContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
					
					var questionContents = '';
						questionContents += '<p class="text-purpose">'+reContents+'</p>';
						if(data.questionImagePath != '' || data.questionImagePath != null) {
							questionContents += '<div class="img-area">';
							questionContents += '	<img src="'+data.questionImagePath+'" alt="">';
							questionContents += '</div>';
						}
					$('div.item.questionContents').append(questionContents);

					var reTitle = data.questionTitle.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

					$('p.text-question.questionTitle').text(reTitle);
					$('[name=questionId]').val(data.questionId);
					$('[name=examProgressId]').val(data.examProgressId);


					//popup footer
					var prevButton = '';
					if(data.displaySequence != 1) {
						prevButton += '<button type="button" class="btn btn-md btn-outline-gray btn-prev" onclick="fnTestPrev()"><spring:message code="button.prev" text="이전" /></button>';
					}
					$('#btnNext').before(prevButton);


					//line drawing
					var lineDrawingTest = $('#lineDrawingTest').val();
					if(lineDrawingTest == 'lineDrawingTest') {
						var line = '';
						var len = data.exampleList1.length;
						if(len > 0) {
							for(var i = 0; i <= len-1; i++) {
								var right = data.exampleList1[i];
								var left = data.exampleList2[i];
								line += '<div class="nodes">';

								line += '	<div class="group1">';
								line += '		<label class="node">';
								line += '			<span class="node-inner">';

								var reLeftExampleContents = left.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
								
								line += 				reLeftExampleContents;
								if(left.exampleImagePath != '' || left.exampleImagePath != null) {
									line += '			<span class="answer-image">';
									line += '				<img src="'+left.exampleImagePath+'" alt="" onload="drawing(\'left_'+left.exampleNumber+'\')">';
									line += '			</span>';
								}
								line += '				<span class="check-item">';
								line += '					<input type="radio" data-connect="false" id="left_'+left.exampleNumber+'" data-id="left_'+left.exampleNumber+'" data-use="false" value="'+left.exampleNumber+'">';
								line += '					<span class="radio-custom"></span>';
								line += '				</span>';
								line += '			</span>';
								line += '		</label>';
								line += '	</div>';

								line += '	<div class="group2">';
								line += '		<label class="node">';
								line += '			<span class="node-inner">';

								var reRightExampleContents = right.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
								
								line += 				reRightExampleContents;
								if(right.exampleImagePath != '' || right.exampleImagePath != null) {
									line += '			<span class="answer-image">';
									line += '				<img src="'+right.exampleImagePath+'" alt="" onload="drawing(\'right_'+right.exampleNumber+'\')">';
									line += '			</span>';
								}
								line += '				<span class="check-item">';
								line += '					<input type="radio" data-connect="false" id="right_'+right.exampleNumber+'" data-id="right_'+right.exampleNumber+'" data-use="false" name="exampleAnswer'+right.exampleNumber+'">';
								line += '					<span class="radio-custom"></span>';
								line += '				</span>';
								line += '			</span>';
								line += '		</label>';
								line += '	</div>';

								line += '</div>';
							}
						}
						$('div.btn-group-default.mt-lg-8.mt-md-4.text-right.line-answer').before(line);

						lineConnect = $('#parent-nodes .nodes').connect('#layer-test');

						//선연결 다 안했을 경우-다음버튼 disabled 처리
						$('.group2 input[type=radio]').on('change', function() {
							let cnt = $('.group2 input[type=radio]:checked').length;
							$('#btnNext').prop('disabled', cnt != Number(len));
						});

						//선연결 후 연결한 선을 다시 눌러 취소했을 때-다음버튼 disabled 처리
						$('.group1 input[type=radio]').on('click', function() {
							var count = $('.group2 input[type=radio]:checked').length;
							$('#btnNext').prop('disabled', count != Number(len));
						});

						$('.group2 input[type=radio]').on('click', function() {
							var count = $('.group2 input[type=radio]:checked').length;
							$('#btnNext').prop('disabled', count != Number(len));
						});

						//연결 취소 버튼 눌렀을 때-다음버튼 disabled 처리
						$('.btn-canvas-reset').click(function() {
							$('#btnNext').prop('disabled', true);
						});

						if(data.answer != null) {
							for(var i = 0; i <= len-1; i++) {
								console.log('exampleAnswer ', data.answer.exampleAnswer[i], (i + 1));
								$('#left_'+data.answer.exampleAnswer[i]).trigger('click');
								$('#right_'+(i + 1)).trigger('click');
							}
							drawing('load');
						}
					}
					

					//multi choice
					var multiChoiceTest = $('#multiChoiceTest').val();
					if(multiChoiceTest == 'multiChoiceTest') {
						var multi = '';
						$.each(data.exampleList1, function(index, item) {
							multi += '<li class="check-item">';
							multi += '	<input type="checkbox" name="exampleAnswer" id="input_'+item.exampleNumber+'" value="'+item.exampleNumber+'">';
							multi += '	<label for="input_'+item.exampleNumber+'">';

							var reExampleContents = item.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
							
							multi += '		<strong>'+item.exampleNumber+'.</strong>'+reExampleContents;
							if(item.exampleImagePath != '' || item.exampleImagePath != null) {
								multi += '		<span class="answer-image">';
								multi += '			<img src="'+item.exampleImagePath+'" alt="" onload>';
								multi += '		</span>';
							}
							multi += '	</label>';
							multi += '</li>';
						});
						$('ul.answer-list.multiChoice').append(multi);

						$('[name=exampleAnswer]').on('click', function(e) {
							let cnt = $('[name=exampleAnswer]:checked').length;
							if(cnt > 4) {
								e.preventDefault();
								e.stopPropagation();
							}
						});
						
						$('[name=exampleAnswer]').on('change', function() {
							let cnt = $('[name=exampleAnswer]:checked').length;
							$('#btnNext').prop('disabled', cnt == 0);
						});
						
						var answer = data.answer;
						if(answer != null) {
							$.each(answer.exampleAnswer, function(index, item) {
								if(item != null) {
									$('#input_'+item).trigger('click');
								}
							});
						}
					}


					//scale
					var scaleTest = $('#scaleTest').val();
					if(scaleTest == 'scaleTest') {
						var scale = '';
						var len = data.exampleList1.length;
							scale += '<div class="measure-answer label-item'+len+'">';
							scale += '	<div class="range">';
							scale += '		<input type="range" min="1" max="'+len+'" step="1" value="0" name="exampleAnswer">';
							scale += '	</div>';
							scale += '	<ul class="range-label">';
							$.each(data.exampleList1, function(index, item) {
								var reExampleContents = item.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
								scale += '	<li><span>'+reExampleContents+'</span></li>';
							});
							scale += '	</ul>';
							scale += '</div>';
						$('#scaleTest').after(scale);
			
						// 척도 선택 문제
						let sheet = document.createElement('style'),
							$rangeInput = $('.range input'),
							prefs = ['webkit-slider-runnable-track', 'moz-range-track', 'ms-track'];
			
						$('#layer-test .test-popup').append(sheet);
			
						let getTrackStyle = function (el) {
							console.log(el);
							let curVal = el.value,
								itemLength = $('.range-label li').length,
								val = (curVal - 1) * (100 / (itemLength - 1)),
								style = '';
							$('#btnNext').prop('disabled', curVal.trim() == '');
						
							// Set active label
							$('.range-label li').removeClass('active selected');
			
							let curLabel = $('.range-label').find('li:nth-child(' + curVal + ')');
			
							curLabel.addClass('active selected');
							curLabel.prevAll().addClass('selected');
			
							// Change background gradient
							for (let i = 0; i < prefs.length; i++) {
								style += '.range {background: linear-gradient(to right, #1744ae 0%, #1744ae ' + val + '%, transparent ' + val + '%, transparent 100%)}';
								// style += '.range input::-' + prefs[i] + '{background: linear-gradient(to right, #1744ae 0%, #1744ae ' + val + '%, #edf0f5 ' + val + '%, #edf0f5 100%)}';
							}
							return style;
						}
			
						$rangeInput.off('input');
						$rangeInput.on('click', function () {
							sheet.textContent = getTrackStyle(this);
						});
			
						$('.range-label li').on('click', function () {
							let index = $(this).index();
							$rangeInput.val(index + 1).trigger('click');
						});
			
						var answer = data.answer;
						if(answer != null) {
							$.each(answer.exampleAnswer, function(index, item) {
								if(item != null) {
									$('.range-label li').eq((item-1)).trigger('click');
								}
							});
						}
					}



					//choice
					var choiceTest = $('#choiceTest').val();
					if(choiceTest == 'choiceTest') {
						var choice = '';
						$.each(data.exampleList1, function(index, item) {
							choice += '<li class="check-item">';
							choice += '	<input type="radio" name="exampleAnswer" id="input_'+item.exampleNumber+'" value="'+item.exampleNumber+'">';
							choice += '	<label for="input_'+item.exampleNumber+'">';

							var reExampleContents = item.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
							
							choice += '		<strong>'+item.exampleNumber+'.</strong>'+reExampleContents;
							if(item.exampleImagePath != null) {
								choice += '	<span class="answer-image">';
								choice += '		<img src="'+item.exampleImagePath+'" alt="">';
								choice += '	</span>';
							}
							choice += '	</label>';
							choice += '</li>';
						});
						$('ul.answer-list.choice').append(choice);

						$('[name=exampleAnswer]').on('change', function() {
							console.log('change', $(this).val());
							$('#btnNext').prop('disabled', $(this).val().trim() == '');
						});

						var answer = data.answer;
						if(answer != null) {
							$.each(answer.exampleAnswer, function(index, item) {
								if(item != null) {
									$('#input_'+item).trigger('click');
								}
							});
						}
					}



					//answer
					var answerTest = $('#answerTest').val();
					if(answerTest == 'answerTest') {
						var ans = '';
						var shortAnswer = '';
						if(data.answer != null) {
							var shortAnswer = data.answer.shortAnswer;
						}
							ans += '<dl class="subjective-answer">';
							ans += '	<dt><spring:message code="evaluate.question.answer" text="Respuesta" /></dt>';
							ans += '	<dd>';

							var reShortAnswer = shortAnswer.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
							
							ans += '		<textarea rows="4" class="form-control full" name="shortAnswer" maxlength="600">'+reShortAnswer+'</textarea>';
							ans += '	</dd>';
							ans += '</dl>';
						$('#answerTest').after(ans);

						$('[name=shortAnswer]').on('keyup', function() {
							$('#btnNext').prop('disabled', $(this).val().trim() == '');
						});

						if(shortAnswer != null) {
							$('[name=shortAnswer]').trigger('keyup');
						}				
					}

				}
			}

			
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}

//시험 첫 페이지
function getStartPopupTest() {
	$.ajax({
		url: '/eval/exam/' + popupType + '/popup/api',
		type: 'POST',
		dataType: 'json',
		data: 'skill=' + skill + '&class=' + clazz + '&no=1',
		success: function(response) {
			var data = response.data;
			console.log(data);
			if(data != null) {
				var skill = data.skill;
			}

			//popup header
			$('h2.popup-title.d-down-md.skillName').text(skill.skillName);
			$('p.skill-name.d-up-lg.skillName').text(skill.skillName);

			var skillTitle = '';
			if(skill.skillProgressLevelCode == '1202') {
				skillTitle += '<spring:message code="evaluate.skill.step1" text="Auto reporte" />';
			} else if(skill.skillProgressLevelCode == '1203') {
				skillTitle += '<spring:message code="evaluate.skill.step2" text="Comportamiento" />';
			}
			$('p.test-title.skillTitle').append(skillTitle);

			var sequence = data.displaySequence;
			var total = data.totalQuestionCount;
			var persent = sequence / total * 100;
			
			var questionProgress = '';
				questionProgress += '<div class="question-progress q'+data.totalQuestionCount+'">';
				questionProgress += '	<div class="bar p'+data.displaySequence+'">';
				questionProgress += '		<span class="fill" style="width:'+persent+'%"><span class="number">'+data.displaySequence+'/'+data.totalQuestionCount+'</span></span>';
				questionProgress += '	</div>';
				questionProgress += '</div>';
			$('div.question-info.infoQuestion').after(questionProgress);

			var reContents = data.questionContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

			var questionContents = '';
				questionContents += '<p class="text-purpose">'+reContents+'</p>';
				if(data.questionImagePath != '' || data.questionImagePath != null) {
					questionContents += '<div class="img-area">';
					questionContents += '	<img src="'+data.questionImagePath+'" alt="">';
					questionContents += '</div>';
				}
			$('div.item.questionContents').append(questionContents);

			var reTitle = data.questionTitle.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

			$('p.text-question.questionTitle').text(reTitle);
			$('[name=questionId]').val(data.questionId);
			$('[name=examProgressId]').val(data.examProgressId);


			//popup footer
			var prevButton = '';
			if(data.displaySequence != 1) {
				prevButton += '<button type="button" class="btn btn-md btn-outline-gray btn-prev" onclick="fnTestPrev()"><spring:message code="button.prev" text="이전" /></button>';
			}
			$('#btnNext').before(prevButton);

			//line drawing
			var lineDrawingTest = $('#lineDrawingTest').val();
			if(lineDrawingTest == 'lineDrawingTest') {
				var line = '';
				var len = data.exampleList1.length;
				if(len > 0) {
					for(var i = 0; i <= len-1; i++) {
						var right = data.exampleList1[i];
						var left = data.exampleList2[i];
						line += '<div class="nodes">';

						line += '	<div class="group1">';
						line += '		<label class="node">';
						line += '			<span class="node-inner">';

						var reLeftExampleContents = left.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
						
						line += 				reLeftExampleContents;
						if(left.exampleImagePath != '' || left.exampleImagePath != null) {
							line += '			<span class="answer-image">';
							line += '				<img src="'+left.exampleImagePath+'" alt="" onload="drawing(\'left_'+left.exampleNumber+'\')">';
							line += '			</span>';
						}
						line += '				<span class="check-item">';
						line += '					<input type="radio" data-connect="false" id="left_'+left.exampleNumber+'" data-id="left_'+left.exampleNumber+'" data-use="false" value="'+left.exampleNumber+'">';
						line += '					<span class="radio-custom"></span>';
						line += '				</span>';
						line += '			</span>';
						line += '		</label>';
						line += '	</div>';

						line += '	<div class="group2">';
						line += '		<label class="node">';
						line += '			<span class="node-inner">';

						var reRightExampleContents = right.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
						
						line += 				reRightExampleContents;
						if(right.exampleImagePath != '' || right.exampleImagePath != null) {
							line += '			<span class="answer-image">';
							line += '				<img src="'+right.exampleImagePath+'" alt="" onload="drawing(\'right_'+right.exampleNumber+'\')">';
							line += '			</span>';
						}
						line += '				<span class="check-item">';
						line += '					<input type="radio" data-connect="false" id="right_'+right.exampleNumber+'" data-id="right_'+right.exampleNumber+'" data-use="false" name="exampleAnswer'+right.exampleNumber+'">';
						line += '					<span class="radio-custom"></span>';
						line += '				</span>';
						line += '			</span>';
						line += '		</label>';
						line += '	</div>';

						line += '</div>';
					}
				}
				$('div.btn-group-default.mt-lg-8.mt-md-4.text-right.line-answer').before(line);

				lineConnect = $('#parent-nodes .nodes').connect('#layer-test');

				//선연결 다 안했을 경우-다음버튼 disabled 처리
				$('.group2 input[type=radio]').on('change', function() {
					let cnt = $('.group2 input[type=radio]:checked').length;
					$('#btnNext').prop('disabled', cnt != Number(len));
				});

				//선연결 후 연결한 선을 다시 눌러 취소했을 때-다음버튼 disabled 처리
				$('.group1 input[type=radio]').on('click', function() {
					var count = $('.group2 input[type=radio]:checked').length;
					$('#btnNext').prop('disabled', count != Number(len));
				});

				$('.group2 input[type=radio]').on('click', function() {
					var count = $('.group2 input[type=radio]:checked').length;
					$('#btnNext').prop('disabled', count != Number(len));
				});

				//연결 취소 버튼 눌렀을 때-다음버튼 disabled 처리
				$('.btn-canvas-reset').click(function() {
					$('#btnNext').prop('disabled', true);
				});

				if(data.answer != null) {
					for(var i = 0; i <= len-1; i++) {
						console.log('exampleAnswer ', data.answer.exampleAnswer[i], (i + 1));
						$('#left_'+data.answer.exampleAnswer[i]).trigger('click');
						$('#right_'+(i + 1)).trigger('click');
					}
					drawing('load');
				}
			}
			
			//multi choice
			var multiChoiceTest = $('#multiChoiceTest').val();
			if(multiChoiceTest == 'multiChoiceTest') {
				var multi = '';
				$.each(data.exampleList1, function(index, item) {
					multi += '<li class="check-item">';
					multi += '	<input type="checkbox" name="exampleAnswer" id="input_'+item.exampleNumber+'" value="'+item.exampleNumber+'">';
					multi += '	<label for="input_'+item.exampleNumber+'">';
					
					var reExampleContents = item.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
					
					multi += '		<strong>'+item.exampleNumber+'.</strong>'+reExampleContents;
					if(item.exampleImagePath != '' || item.exampleImagePath != null) {
						multi += '		<span class="answer-image">';
						multi += '			<img src="'+item.exampleImagePath+'" alt="" onload>';
						multi += '		</span>';
					}
					multi += '	</label>';
					multi += '</li>';
				});
				$('ul.answer-list.multiChoice').append(multi);

				$('[name=exampleAnswer]').on('click', function(e) {
					let cnt = $('[name=exampleAnswer]:checked').length;
					if(cnt > 4) {
						e.preventDefault();
						e.stopPropagation();
					}
				});
				
				$('[name=exampleAnswer]').on('change', function() {
					let cnt = $('[name=exampleAnswer]:checked').length;
					$('#btnNext').prop('disabled', cnt == 0);
				});
				
				var answer = data.answer;
				if(answer != null) {
					$.each(answer.exampleAnswer, function(index, item) {
						if(item != null) {
							$('#input_'+item).trigger('click');
						}
					});
				}
			}



			//scale
			var scaleTest = $('#scaleTest').val();
			if(scaleTest == 'scaleTest') {
				var scale = '';
				var len = data.exampleList1.length;
					scale += '<div class="measure-answer label-item'+len+'">';
					scale += '	<div class="range">';
					scale += '		<input type="range" min="1" max="'+len+'" step="1" value="0" name="exampleAnswer">';
					scale += '	</div>';
					scale += '	<ul class="range-label">';
					$.each(data.exampleList1, function(index, item) {
						var reExampleContents = item.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
						scale += '	<li><span>'+reExampleContents+'</span></li>';
					});
					scale += '	</ul>';
					scale += '</div>';
				$('#scaleTest').after(scale);

				// 척도 선택 문제
				let sheet = document.createElement('style'),
					$rangeInput = $('.range input'),
					prefs = ['webkit-slider-runnable-track', 'moz-range-track', 'ms-track'];

				$('#layer-test .test-popup').append(sheet);

				let getTrackStyle = function (el) {
					console.log(el);
					let curVal = el.value,
						itemLength = $('.range-label li').length,
						val = (curVal - 1) * (100 / (itemLength - 1)),
						style = '';
					$('#btnNext').prop('disabled', curVal.trim() == '');
				
					// Set active label
					$('.range-label li').removeClass('active selected');

					let curLabel = $('.range-label').find('li:nth-child(' + curVal + ')');

					curLabel.addClass('active selected');
					curLabel.prevAll().addClass('selected');

					// Change background gradient
					for (let i = 0; i < prefs.length; i++) {
						style += '.range {background: linear-gradient(to right, #1744ae 0%, #1744ae ' + val + '%, transparent ' + val + '%, transparent 100%)}';
						// style += '.range input::-' + prefs[i] + '{background: linear-gradient(to right, #1744ae 0%, #1744ae ' + val + '%, #edf0f5 ' + val + '%, #edf0f5 100%)}';
					}
					return style;
				}

				$rangeInput.off('input');
				$rangeInput.on('click', function () {
					sheet.textContent = getTrackStyle(this);
				});

				$('.range-label li').on('click', function () {
					let index = $(this).index();
					$rangeInput.val(index + 1).trigger('click');
				});

				var answer = data.answer;
				if(answer != null) {
					$.each(answer.exampleAnswer, function(index, item) {
						if(item != null) {
							$('.range-label li').eq((item-1)).trigger('click');
						}
					});
				}
			}



			//choice
			var choiceTest = $('#choiceTest').val();
			if(choiceTest == 'choiceTest') {
				var choice = '';
				$.each(data.exampleList1, function(index, item) {
					choice += '<li class="check-item">';
					choice += '	<input type="radio" name="exampleAnswer" id="input_'+item.exampleNumber+'" value="'+item.exampleNumber+'">';
					choice += '	<label for="input_'+item.exampleNumber+'">';

					var reExampleContents = item.exampleContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
					
					choice += '		<strong>'+item.exampleNumber+'.</strong>'+reExampleContents;
					if(item.exampleImagePath != null) {
						choice += '	<span class="answer-image">';
						choice += '		<img src="'+item.exampleImagePath+'" alt="">';
						choice += '	</span>';
					}
					choice += '	</label>';
					choice += '</li>';
				});
				$('ul.answer-list.choice').append(choice);

				$('[name=exampleAnswer]').on('change', function() {
					console.log('change', $(this).val());
					$('#btnNext').prop('disabled', $(this).val().trim() == '');
				});

				var answer = data.answer;
				if(answer != null) {
					$.each(answer.exampleAnswer, function(index, item) {
						if(item != null) {
							$('#input_'+item).trigger('click');
						}
					});
				}
			}



			//answer
			var answerTest = $('#answerTest').val();
			if(answerTest == 'answerTest') {
				var ans = '';
				var shortAnswer = '';
				if(data.answer != null) {
					var shortAnswer = data.answer.shortAnswer;
				}
					ans += '<dl class="subjective-answer">';
					ans += '	<dt><spring:message code="evaluate.question.answer" text="Respuesta" /></dt>';
					ans += '	<dd>';

					var reShortAnswer = shortAnswer.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
					
					ans += '		<textarea rows="4" class="form-control full" name="shortAnswer" maxlength="600">'+reShortAnswer+'</textarea>';
					ans += '	</dd>';
					ans += '</dl>';
				$('#answerTest').after(ans);

				$('[name=shortAnswer]').on('keyup', function() {
					$('#btnNext').prop('disabled', $(this).val().trim() == '');
				});

				if(shortAnswer != null) {
					$('[name=shortAnswer]').trigger('keyup');
				}				
			}

		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}

function drawing(text) {
	if($('#layer-test canvas').length > 0) {
		lineConnect.redrawLines();
	}
	else {
		setTimeout(function() {
			drawing(text);
		}, 500);
	}
}
</script>
<style>
.check-item label {
	width: 100%;
}
</style>
<%-- <%@ include file="common/q-footer.jsp" %> --%>