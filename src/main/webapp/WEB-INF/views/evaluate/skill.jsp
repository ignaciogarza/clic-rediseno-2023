<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<meta name="format-detection" content="telephone=no">
<title>CLIC</title>
<!-- 리소스 추가 (10.28) -->
<link rel="stylesheet" media="all" href="https://live-idb-config.pantheonsite.io/themes/custom/iadb/css/iadb-styles.css?v=0.0.4">
<!-- // 리소스 추가 (10.28) -->
<link rel="stylesheet" href="/static/assets/css/style.css">

<!-- JavaScript -->
<script src="/static/assets/js/jquery-3.5.1.min.js"></script>

<!-- 공통 UI 컴포넌트 -->
<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
<script src="/static/assets/js/ui-common.js"></script>
<script src="/static/common/js/lineConnect.js"></script>
<script src="/static/common/js/evaluate.js"></script>
</head>
<body>
<div class="wrapper">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div id="container">
		<aside id="sidebar">
			<%@ include file="../common/side-profile.jsp" %>
			<%-- <%@ include file="skill-progress.jsp" %>
			<%@ include file="skill-progress-side.jsp" %> --%>
			<div class="btn-group-default mt-lg-6 going">
				<%-- <c:choose>
					<c:when test="${testEnabled}">
						<!-- 테스트 참여 가능 -->
						<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnTestPopupOpen()">
							<spring:message code="evaluate.start-test" text="테스트 시작" />
						</button>
						<!-- // 테스트 참여 가능 -->
					</c:when>
					<c:otherwise>
						<!-- 테스트 참여 불가 -->
						<button type="button" class="btn btn-md btn-secondary btn-test" disabled>
							<spring:message code="evaluate.start-test" text="테스트 시작" />
						</button>
						<div class="tooltip-guide">
							<p class="text">
								<spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." />
							</p>
						</div>
						<!-- // 테스트 참여 불가 -->
					</c:otherwise>
				</c:choose> --%>
			</div>
		</aside>
		<article id="content">
			<h2 class="content-title"><spring:message code="menu3" text="평가" /></h2>
			<div class="content-fixed evaluate-intro">
			<input type="hidden" id="isUseTest" name="isUse" value="">
				<div class="content-header">
					<%-- <div class="inner listButton">
						<h2 class="content-title d-down-md">${data.skillName}</h2>
						<a href="/eval/list" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>
					</div> --%>
				</div>
				<div class="content-body style3">
					<%-- <c:if test="${isView}"> --%>
						<div class="skill-progress d-down-md">
							<%-- <%@ include file="skill-progress-side-list.jsp" %> --%>
						</div>
					<%-- </c:if> --%>
					<p class="text-greeting"><spring:message code="evaluate.greetings" text="테스트 시작" /></p>
					<div class="test-info">
						<%-- <div class="summary-list">
							<dl class="item">
								<dt><spring:message code="evaluate.exam:text1" text="테스트 기간" />:</dt>
								<dd>${exam.limitTime} <spring:message code="evaluate.exam:text1-1" text="minutes" /></dd>
							</dl>
							<dl class="item">
								<dt><spring:message code="evaluate.exam:text2" text="질문 개수" />:</dt>
								<dd>${exam.totalQuestionCount} <spring:message code="evaluate.exam:text2-1" text="questions" /></dd>
							</dl>
							<dl class="item">
								<dt><spring:message code="evaluate.exam:text3" text="통과 할 수있는 최소 자격" />:</dt>
								<dd>${exam.passCriteria}%</dd>
							</dl>
						</div>
						<div class="guide-content">
							${exam.examContents}
						</div> --%>
					</div>

					<%-- <c:if test="${not testEnabled}"> --%>
						<!-- 테스트 참여 불가 -->
						<div class="tooltip-guide test-fail d-down-md" data-html2canvas-ignore="true">
							<p class="text"><spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." /></p>
						</div>
						<!-- // 테스트 참여 불가 -->
					<%-- </c:if> --%>
					<div class="btn-group-default btn-group-fixed d-down-md joinTest" data-html2canvas-ignore="true">
						<%-- <c:choose>
							<c:when test="${testEnabled}">
								<!-- 테스트 참여 가능 -->
								<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnTestPopupOpen()">
									<spring:message code="evaluate.start-test" text="테스트 시작" />
								</button>
								<!-- // 테스트 참여 가능 -->
							</c:when>
							<c:otherwise>
								<!-- 테스트 참여 불가 -->
								<button type="button" class="btn btn-md btn-secondary btn-test" disabled>
									<spring:message code="evaluate.start-test" text="테스트 시작" />
								</button>
								<!-- // 테스트 참여 불가 -->
							</c:otherwise>
						</c:choose> --%>
					</div>
				</div>
			</div>
		</article>
	</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</div>

<script>
const skill = getParameterByName('skill');
const clazz = getParameterByName('class');
$(function() {

	getSkillDeatil();  //테스트 결과 상세화면 조회
	
});

//URL 파라미터 값 가져오기
function getParameterByName(name) { 
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
	results = regex.exec(location.search); 
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
}

//테스트 결과 상세화면 조회
function getSkillDeatil() {
	$.ajax({
		url: '/eval/skill/api?skill='+skill+'&class='+clazz,
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var data = response.data.skill;
			var exam = response.data.exam;
			const progress = data.progressStatusCode;

			var isView = false;
		//	var progress = data.progressStatusCode;
			var skillDisabled = (data.isUse == 'N' && progress != 'NOT_TESTED') ? 'disabled' : '';
			var testEnabled = true;

			var step1Class = '';
			var step2Class = '';
			var step3Class = '';
			var badgeImage = '';

			if(progress == 'SELF_EXAM_TAKING') {
				isView = true;
				step1Class = 'ongoing';
				badgeImage = '/static/assets/images/content/img-step1-ongoing.png';
			}
			if(progress == 'SELF_EXAM_PASS' || progress == 'SKILL_EXAM_WAIT') {
				isView = true;
				step1Class = 'on';
				badgeImage = '/static/assets/images/content/img-step1-pass.png';
			}
			if(progress == 'SKILL_EXAM_TAKING') {
				isView = true;
				step1Class = 'on';
				step2Class = 'ongoing';
				badgeImage = '/static/assets/images/content/img-step2-ongoing.png';
			}
			if(progress == 'SKILL_EXAM_PASS' || progress == 'FRIEND_AUTH_WAIT') {
				isView = true;
				step1Class = 'on';
				step2Class = 'on';
				badgeImage = '/static/assets/images/content/img-step2-pass.png';
			}
			if(progress == 'FRIEND_AUTH_TAKING') {
				isView = true;
				step1Class = 'on';
				step2Class = 'on';
				step3Class = 'ongoing';
				badgeImage = '/static/assets/images/content/img-step3-ongoing.png';
			}
			if(progress == 'PASS') {
				isView = false;
				badgeImage = data.badgeObtainImagePath;
			}
			if(progress == 'SELF_EXAM_TIME_OUT' || progress == 'SELF_EXAM_FAILED' || progress == 'SKILL_EXAM_TIME_OUT' || progress == 'SKILL_EXAM_FAILED') {
				badgeImage = '/static/assets/images/content/img-skill-disabled.png';
				testEnabled = false;
			}
			if(data.isUse != 'Y' && (skill == '' || skill == null)) {
				isView = false;
			}
			if(data.checkSkillBadgeObtain) {
				console.log('9');
				isView = false;
				badgeImage = data.badgeObtainImagePath;
			}

			var side = '';
			if(isView) {
				side += '<div class="skill-progress '+skillDisabled+'">';
				side += '	<p class="title d-up-lg">'+data.skillName+'</p>';
				side += '	<ol class="list">';
				side += '		<li class="step1 '+step1Class+'">';
				side += '			<span class="state"><spring:message code="evaluate.skill.step1" text="Auto reporte" /></span>';
				side += '		</li>';
				if(data.badgeObtainLevelCode == '1502' || data.badgeObtainLevelCode == '1503') {
					side += '	<li class="step2 '+step2Class+'">';
					side += '		<span class="state"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></span>';
					side += '	</li>';
				}
				if(data.badgeObtainLevelCode == '1503' || data.badgeObtainLevelCode == '1504') {
					side += '	<li class="step3 '+step3Class+'">';
					side += '		<span class="state"><spring:message code="evaluate.skill.step3-1" text="Validación" /><br><spring:message code="evaluate.skill.step3-2" text="de pares" /></span>';
					side += '	</li>';
				}
				side += '	</ol>';
				if(skillDisabled == 'disabled') {
					side += '<span class="msg-disabled"><spring:message code="evaluate.alert.cant-continue-1" text="No puede continuar con la" /><br><spring:message code="evaluate.alert.cant-continue-2" text="prueba" /></span>';
				}
				side += '</div>';
				side += '<div class="division-line mt-4 mb-4"></div>';
			}
			$('div#layer-profile.modal-popup.modal-md.hide').after(side);

			var name = '';
				name += '<h2 class="content-title d-down-md">'+data.skillName+'</h2>';
				name += '<a href="/eval/list" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>';
			$('div.inner.listButton').append(name);

			var going = '';
			if(testEnabled) {
				going += '<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnTestPopupOpen()">';
				going += '	<spring:message code="evaluate.start-test" text="테스트 시작" />';
				going += '</button>';
			} else {
				going += '<button type="button" class="btn btn-md btn-secondary btn-test" disabled>';
				going += '	<spring:message code="evaluate.start-test" text="테스트 시작" />';
				going += '</button>';
				going += '<div class="tooltip-guide">';
				going += '	<p class="text">';
				going += '		<spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." />';
				going += '	</p>';
				going += '</div>';
			}
			$('div.going').append(going);

			var sideList = '';
			if(isView) {
				$('div.skill-progress.d-down-md').show();
				sideList += '	<p class="title d-up-lg">'+data.skillName+'</p>';
				sideList += '	<ol class="list">';
				sideList += '		<li class="step1 '+step1Class+'">';
				sideList += '			<span class="state"><spring:message code="evaluate.skill.step1" text="Auto reporte" /></span>';
				sideList += '		</li>';
				if(data.badgeObtainLevelCode == '1502' || data.badgeObtainLevelCode == '1503') {
					sideList += '	<li class="step2 '+step2Class+'">';
					sideList += '		<span class="state"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></span>';
					sideList += '	</li>';
				}
				if(data.badgeObtainLevelCode == '1503' || data.badgeObtainLevelCode == '1504') {
					sideList += '	<li class="step3 '+step3Class+'">';
					sideList += '		<span class="state"><spring:message code="evaluate.skill.step3-1" text="Validación" /><br><spring:message code="evaluate.skill.step3-2" text="de pares" /></span>';
					sideList += '	</li>';
				}
				sideList += '	</ol>';
				if(skillDisabled == 'disabled') {
					sideList += '<span class="msg-disabled"><spring:message code="evaluate.alert.cant-continue-1" text="No puede continuar con la" /><br><spring:message code="evaluate.alert.cant-continue-2" text="prueba" /></span>';
				}
				sideList += '</div>';
				sideList += '<div class="division-line mt-4 mb-4"></div>';
				$('div.skill-progress.d-down-md').append(sideList);
			} else {
				$('div.skill-progress.d-down-md').hide();
			}

			var header = '';
				header += '<div class="inner listButton">';
				header += '	<h2 class="content-title d-down-md">'+data.skillName+'</h2>';
				header += '	<a href="/eval/list" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>';
				header += '</div>';
			$('div.content-header').append(header);

			var reContents = exam.examContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

			var content = '';
				content += '<div class="summary-list">';
				content += '	<dl class="item">';
				content += '		<dt><spring:message code="evaluate.exam.text1" text="테스트 기간" />:</dt>';
				content += '		<dd>'+exam.limitTime+' <spring:message code="evaluate.exam.text1-1" text="minutes" /></dd>';
				content += '	</dl>';
				content += '	<dl class="item">';
				content += '		<dt><spring:message code="evaluate.exam.text2" text="질문 개수" />:</dt>';
				content += '		<dd>'+exam.totalQuestionCount+' <spring:message code="evaluate.exam.text2-1" text="questions" /></dd>';
				content += '	</dl>';
				content += '	<dl class="item">';
				content += '		<dt><spring:message code="evaluate.exam.text3" text="통과 할 수있는 최소 자격" />:</dt>';
				content += '		<dd>'+exam.passCriteria+'%</dd>';
				content += '	</dl>';
				content += '</div>';
				content += '<div class="guide-content">';
				content += 		reContents;
				content += '</div>';
			$('div.test-info').append(content);

			if(!testEnabled) {
				$('div.tooltip-guide.test-fail').show();
			} else {
				$('div.tooltip-guide.test-fail').hide();
			}

			var joinTest = '';
			if(testEnabled) {
				joinTest += '<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnTestPopupOpen()">';
				joinTest += '	<spring:message code="evaluate.start-test" text="테스트 시작" />';
				joinTest += '</button>';
			} else {
				joinTest += '<button type="button" class="btn btn-md btn-secondary btn-test" disabled>';
				joinTest += '	<spring:message code="evaluate.start-test" text="테스트 시작" />';
				joinTest += '</button>';
			}
			$('div.btn-group-default.btn-group-fixed.d-down-md.joinTest').append(joinTest);

			if(data.isUse == 'Y') {
				$('#layer-test').show();
				$('#layer-result').show();
				$('#layer-timeout').show();

				if((data.skillProgressLevelCode == '1202' && progress == 'SELF_EXAM_PASS') || data.skillProgressLevelCode == '1203') {
					window.popupType = 'skill';
				} else if(data.skillProgressLevelCode == '1202') {
					window.popupType = 'self';
				} else {
					window.popupType = 'self';
				}

				let lineConnect;
				
			} else {
				$('#layer-test').hide();
				$('#layer-result').hide();
				$('#layer-timeout').hide();
			}

			//test popup
			$('#isUseTest').val(data.isUse);

		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}

function fnTestPopupOpen() {
	var isUse = $('#isUseTest').val();
	if(isUse == 'Y') {
		$.ajax({
			url: '/eval/exam/tutorial/popup',
			method: 'POST',
			dataType: 'html',
			data: {
				skill: skill,
				class: clazz
			},
			complete: function(jqXHR) {
				$('#layer-test .test-popup').html(jqXHR.responseText);
			}
		});
		openModal('#layer-test');
		getPopupTest();  //시험 popup -> footer랑 연결
	} else {
		alert('<spring:message code="alert.text.2" text="테스트를 정상적으로 진행할 수 없는 상태로 변경되었습니다." />');
		location.href = '/eval/list';
	}
}
function fnTestPopupClose() {
	window.location.reload();
}

//시험 popup -> footer랑 연결
function getPopupTest() {
	$.ajax({
		url: '/eval/exam/' + popupType + '/popup/api',
		type: 'POST',
		dataType: 'json',
		data: 'skill=' + skill + '&class=' + clazz + '&no=1',
		success: function(response) {
			var data = response.data;    
			window.displayNumber = data.displaySequence;
			window.examStartTime = data.examStartTime;
			window.examEndTime = data.examLimitTime;
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}
</script>

<%-- 스킬 노출 여부 Y --%>
<%-- <c:if test="${data.isUse eq 'Y'}"> --%>
<!-- 레이어팝업 -->
<div class="modal-popup modal-full hide" id="layer-test">
	<div class="dimed"></div>
	<div class="popup-inner test-popup">
	</div>
</div>

<div class="modal-popup modal-sm hide" id="layer-result">
	<div class="dimed"></div>
	<div class="popup-inner">
		<div class="popup-body text-center"></div>
	</div>
</div>

<div class="modal-popup modal-sm hide" id="layer-timeout">
	<div class="dimed"></div>
	<div class="popup-inner">
		<div class="popup-body text-center">
			<em class="ico ico-error"></em>
			<h2 class="popup-title"><spring:message code="evaluate.popup.timeout-title" text="안타깝네요!" /></h2>
			<p class="text mt-lg-5 mt-md-2">
				<spring:message code="evaluate.popup.timeout-text1" text="테스트시간이 초과되어 불합격 하였습니다." /><br>
				<spring:message code="evaluate.popup.timeout-text2" text="다음 기회에 다시 참여해주세요." />
			</p>
			<div class="btn-group-default mt-lg-8 mt-md-8">
				<button class="btn btn-md btn-secondary btn-check" onclick="location.href='/eval/list'" disabled><spring:message code="button.check" text="확인" /></button>
			</div>
		</div>
	</div>
</div>

<%-- <c:choose>
	<c:when test="${(data.skillProgressLevelCode == '1202' && progress == 'SELF_EXAM_PASS') || data.skillProgressLevelCode == '1203'}"><script>const popupType = 'skill';</script></c:when>
	<c:when test="${data.skillProgressLevelCode == '1202'}"><script>const popupType = 'self';</script></c:when>
	<c:otherwise><script>const popupType = 'self';</script></c:otherwise>
</c:choose>
<script>
const skill = '${data.skillCode}';
const clazz = '${data.examClassCode}';
const progress = '${data.progressStatusCode}';
let lineConnect;
function fnTestPopupOpen() {
	$.ajax({
		url: '/eval/exam/tutorial/popup',
		method: 'POST',
		dataType: 'html',
		data: {
			skill: skill,
			class: clazz
		},
		complete: function(jqXHR) {
			$('#layer-test .test-popup').html(jqXHR.responseText);
		}
	});
	openModal('#layer-test');
}
function fnTestPopupClose() {
	window.location.reload();
}
</script>
</c:if> --%>

<%-- 스킬 노출 여부 N --%>
<%-- <c:if test="${data.isUse ne 'Y'}">
<script>
function fnTestPopupOpen() {
	alert('<spring:message code="alert.text.2" text="테스트를 정상적으로 진행할 수 없는 상태로 변경되었습니다." />');
	location.href = '/eval/list';
}
</script>
</c:if> --%>
</body>
</html>