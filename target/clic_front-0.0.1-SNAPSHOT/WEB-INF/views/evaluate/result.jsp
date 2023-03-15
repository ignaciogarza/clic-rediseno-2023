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
<script src="/static/assets/js/jquery.DonutWidget.js"></script>
<script src="/static/common/js/evaluate.js"></script>
<script src="/static/common/js/init.js"></script>

<script src="/static/common/js/lib/html2canvas.min.js"></script>
<script src="/static/common/js/lib/jspdf.umd.min.js"></script>
</head>
<body>
<div class="wrapper">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div id="container">
		<aside id="sidebar">
			<%@ include file="../common/side-profile.jsp" %>
			<%-- <%@ include file="skill-progress.jsp" %>
			<%@ include file="skill-progress-side.jsp" %> --%>
			<%-- <c:if test="${(fn:startsWith(progress, 'SELF_') || fn:startsWith(progress, 'SKILL_')) && (data.badgeObtainLevelCode eq '1502' || data.badgeObtainLevelCode eq '1503')}">
				<div class="btn-group-default mt-lg-6">
					<c:choose>
						<c:when test="${testEnabled}">
							<!-- 테스트 참여 가능 -->
							<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnSkillExamStart()">
								<spring:message code="evaluate.skill-test" text="기술 테스트" />
							</button>
							<!-- // 테스트 참여 가능 -->
						</c:when>
						<c:otherwise>
							<!-- 테스트 참여 불가 -->
							<button type="button" class="btn btn-md btn-secondary btn-test" disabled>
								<spring:message code="evaluate.skill-test" text="기술 테스트" />
							</button>
							<div class="tooltip-guide">
								<p class="text">
									<spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." />
								</p>
							</div>
							<!-- // 테스트 참여 불가 -->
						</c:otherwise>
					</c:choose>
				</div>
			</c:if> --%>
		</aside>
		<article id="content">
			<div class="pdf-area">
				<h2 class="content-title"><spring:message code="menu3" text="평가" /></h2>
			</div>
			<div class="content-fixed evaluate-result">
				<div class="content-header">
				<input type="hidden" id="progressTest" name="progress" value="">
				<input type="hidden" id="testEnable" name="testEnabled" value="">
					<div class="inner pdfButton">
						<%-- <h2 class="content-title d-down-md">${data.skillName}</h2>
						<span data-html2canvas-ignore="true">
							<a href="javascript:;" class="btn btn-sm btn-primary btn-down" id="btnPdf"><spring:message code="button.download.pdf" text="PDF 다운로드" /></a>
							<a href="/eval/list" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>
						</span> --%>
					</div>
				</div>
				<div class="content-body style3">
					<div class="test-result">
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
						<%-- <%@ include file="../result/result-pdf-area.jsp" %>
						<%@ include file="../result/result-ref-area.jsp" %> --%>
					</div>

					<%-- <c:if test="${not testEnabled}">
						<!-- 테스트 참여 불가 -->
						<div class="tooltip-guide d-down-md" data-html2canvas-ignore="true">
							<p class="text"><spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." /></p>
						</div>
						<!-- // 테스트 참여 불가 -->
					</c:if>
					<c:if test="${progress == 'SELF_EXAM_PASS'}">
						<div class="btn-group-default btn-group-fixed d-down-md" data-html2canvas-ignore="true">
							<c:choose>
								<c:when test="${testEnabled}">
									<!-- 테스트 참여 가능 -->
									<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnSkillExamStart()">
										<spring:message code="evaluate.skill-test" text="기술 테스트" />
									</button>
									<!-- // 테스트 참여 가능 -->
								</c:when>
								<c:otherwise>
									<!-- 테스트 참여 불가 -->
									<button type="button" class="btn btn-md btn-secondary btn-test" disabled>
										<spring:message code="evaluate.skill-test" text="기술 테스트" />
									</button>
									<!-- // 테스트 참여 불가 -->
								</c:otherwise>
							</c:choose>
						</div>
					</c:if> --%>
				</div>
			</div>
		</article>
	</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</div>

<%-- <c:choose>
	<c:when test="${(data.skillProgressLevelCode == '1202' && progress == 'SELF_EXAM_PASS') || data.skillProgressLevelCode == '1203'}"><script>const popupType = 'skill';</script></c:when>
	<c:when test="${data.skillProgressLevelCode == '1202'}"><script>const popupType = 'self';</script></c:when>
	<c:otherwise><script>const popupType = 'self';</script></c:otherwise>
</c:choose> --%>
<script>
/* const skill = '${data.skillCode}';
const clazz = '${data.examClassCode}';
const progress = '${data.progressStatusCode}'; */
const skill = getParameterByName('skill');
const clazz = getParameterByName('class');
window.jsPDF = window.jspdf.jsPDF;
$(function() {

	getResultDeatil();  //테스트 결과 상세화면 조회
	
});

//URL 파라미터 값 가져오기
function getParameterByName(name) { 
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
	results = regex.exec(location.search); 
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
}

//테스트 결과 상세화면 조회
function getResultDeatil() {
	$.ajax({
		url: '/eval/skill/api?skill='+skill+'&class='+clazz,
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var data = response.data.skill;
			var result = response.data.examResult;
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
				isView = false;
				badgeImage = data.badgeObtainImagePath;
			}

			var side = '';
			//skill-progress-side.jsp 와 skill-progress-side-list.jsp
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
			if((progress.indexOf('SELF_') != -1 || progress.indexOf('SKILL_') != -1) && progress != 'SKILL_EXAM_PASS' && (data.badgeObtainLevelCode == '1502' || data.badgeObtainLevelCode == '1503')) {
				side += '<div class="btn-group-default mt-lg-6">';
				if(testEnabled) {
					side += '<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnSkillExamStart()">';
					side += '	<spring:message code="evaluate.skill-test" text="기술 테스트" />';
					side += '</button>';
				} else {
					side += '<button type="button" class="btn btn-md btn-secondary btn-test" disabled>';
					side += '	<spring:message code="evaluate.skill-test" text="기술 테스트" />';
					side += '</button>';
					side += '<div class="tooltip-guide">';
					side += '	<p class="text">';
					side += '		<spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." />';
					side += '	</p>';
					side += '</div>';
				}
				side += '</div>';
			}
			$('div#layer-profile.modal-popup.modal-md.hide').after(side);

			var name = '';
				name += '<h2 class="content-title d-down-md">'+data.skillName+'</h2>';
				name += '<span data-html2canvas-ignore="true">';
				name += '	<a href="javascript:;" class="btn btn-sm btn-primary btn-down" id="btnPdf"><spring:message code="button.download.pdf" text="PDF 다운로드" /></a>';
				name += '	<a href="/eval/list" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>';
				name += '</span>';
			$('div.inner.pdfButton').append(name);
			
			//pdf 부분
			let selfScore = result.selfComplete ? result.selfFinalScore : 0;
			let selfClass = selfScore == 0 ? 'darkblue' : '';
			
			let skillScore = result.skillComplete ? result.skillFinalScore : 0;
			let skillClass = skillScore == 0 ? 'darkblue' : '';

			let friendScore = result.friendRecommendCount;
			let friendClass = friendScore == 0 ? 'darkblue' : '';
			
			var total = '';
				total += '<div class="item">';
				total += '	<p class="title"><spring:message code="evaluate.skill.step1" text="Auto-reporte" /></p>';
				total += '	<div class="donut-widget '+selfClass+'"';
				total += '		data-chart-size="large"';
				total += '		data-chart-max="100"';
				total += '		data-chart-value="'+selfScore+'"';
				total += '		data-chart-primary="#88386d"';
				total += '		data-chart-background="#edf0f5">';
				total += '	</div>';
				total += '</div>';
				if(data.badgeObtainLevelCode == '1502' || data.badgeObtainLevelCode == '1503') {
					total += '<div class="item">';
					total += '	<p class="title"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></p>';
					total += '	<div class="donut-widget '+skillClass+'"';
					total += '		data-chart-size="large"';
					total += '		data-chart-max="100"';
					total += '		data-chart-value="'+skillScore+'"';
					total += '		data-chart-primary="#167e87"';
					total += '		data-chart-background="#edf0f5">';
					total += '	</div>';
					total += '</div>';
				}
				if(data.badgeObtainLevelCode == '1503' || data.badgeObtainLevelCode == '1504') {
					total += '<div class="item">';
					total += '	<p class="title">';
					total += '		<spring:message code="evaluate.skill.step3-1" text="Validación" />';
					total += '		<br class="d-down-sm"><spring:message code="evaluate.skill.step3-2" text="de pares" />';
					total += '	</p>';
					total += '	<div class="donut-widget '+friendClass+'"';
					total += '		data-chart-size="large"';
					total += '		data-chart-max="3"';
					total += '		data-chart-value="'+friendScore+'"';
					total += '		data-chart-text="'+friendScore+'/3"';
					total += '		data-chart-primary="#81BA26"';
					total += '		data-chart-background="#edf0f5">';
					total += '	</div>';
					total += '</div>';
				}
			$('div.total-rate').append(total);

			var detail = '';
			$.each(result.detailList, function(index, item) {
				let selfComplete = result.selfComplete ? item.selfScore : 0;
				let skillComplete = result.skillComplete ? item.skillScore : 0;
				
				detail += '<dl class="item">';
				detail += '	<dt>'+item.title+'</dt>';
				detail += '	<dd>';
				detail += '		<div class="bar-percent purple">';
				detail += '			<div class="bar p'+selfComplete+'">';
				detail += '				<span class="fill"><span class="number">'+selfComplete+'%</span></span>';
				detail += '			</div>';
				detail += '		</div>';
				detail += '		<div class="bar-percent blue-green">';
				detail += '			<div class="bar p'+skillComplete+'">';
				detail += '				<span class="fill"><span class="number">'+skillComplete+'%</span></span>';
				detail += '			</div>';
				detail += '		</div>';
				detail += '		<p class="content">'+item.contents+'</p>';
				detail += '	</dd>';
				detail += '</dl>';
			});
			$('div.detail-rate').append(detail);

			//references 부분
			var ref = '';
			if((data.badgeObtainLevelCode == '1503' && data.progressStatusCode == 'SKILL_EXAM_PASS') || (data.badgeObtainLevelCode == '1504' && data.progressStatusCode == 'SELF_EXAM_PASS') || (result.authList.length > 0)) {
				ref += '<h3 class="title1"><spring:message code="evaluate.friend.text1" text="References" /></h3>';
				ref += '<div class="skill-certificate">';
				$.each(result.authList, function(index, item) {
					ref += '<div class="item">';
					ref += '	<div class="community-list">';
					ref += '		<div class="profile-area">';
					ref += '			<div class="profile-frame">';
					ref += '				<div class="photo">';
					ref += '					<img src="'+item.userImagePath+'" alt="" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'">';
					ref += '				</div>';
					ref += '				<div class="country">';
					if(typeof item.countryCode == "undefined" || item.countryCode == "" || item.countryCode == null) {
						ref += '					<img src="https://flagcdn.com/w640/co.png" alt="co" title="co" >';
					} else {
						ref += '					<img src="https://flagcdn.com/w640/'+item.countryCode.toLowerCase()+'.png" alt="'+item.countryCode+'" title="'+item.countryCode+'" >';
					}
					ref += '				</div>';
					if(item.isAuth == 'Y') {
						ref += '			<div class="stat">';
						ref += '				<i class="ico ico-connect"></i>';
						ref += '			</div>';
					}
					ref += '			</div>';
					ref += '			<div class="profile-info">';
					if(typeof item.name == "undefined" || item.name == "" || item.name == null) {
						ref += '				<span class="name"><spring:message code="evaluate.friend.text4-1" text="Former member" /></span>';
					} else {
						ref += '				<span class="name">'+item.name+' '+item.firstName+'</span>';
					}
					/* if(typeof item.jobName == "undefined" || item.jobName == '' || item.jobName == null) {
						ref += '				<span class="career"><spring:message code="evaluate.friend.text4-2" text="None" /></span>';
					} else {
						ref += '			<span class="career">'+item.jobName+'</span>';
					} */
					ref += '			</div>';
					ref += '		</div>';
					ref += '	</div>';
					if(item.isAuth == 'R') {
						ref += '<div class="state">';
						ref += '	<button type="button" class="btn btn-md btn-outline-gray btn-cancle" data-friend-id="'+item.userId+'">';
						ref += '		<spring:message code="evaluate.friend.text3-1" text="요청 취소" />';
						ref += '	</button>';
						ref += '</div>';
						ref += '<div class="content">';
						ref += '	<p class="text text-darkgray"><spring:message code="evaluate.friend.text3-2" /></p>';
						ref += '</div>';
					} else if (item.isAuth == 'Y') {
						ref += '<div class="state">';
						ref += '	<p class="text-complete"><spring:message code="community.text11" text="인증 완료" /></p>';
						ref += '</div>';
						ref += '<div class="content">';
						ref += '	<p class="text">'+item.authContents+'</p>';
						ref += '</div>';
					}
					ref += '</div>';
				});
				for (var i = result.authList.length; i < 3; i++) {
					ref += '<div class="item">';
					ref += '	<div class="community-list">';
					ref += '		<div class="profile-area">';
					ref += '			<div class="profile-frame">';
					ref += '				<div class="photo">';
					ref += '					<img src="/static/assets/images/common/img-profile-default2.png" alt="">';
					ref += '				</div>';
					ref += '			</div>';
					ref += '		</div>';
					ref += '	</div>';
					ref += '	<div class="state">';
					ref += '		<button type="button" class="btn btn-md btn-secondary btn-request">';
					ref += '			<spring:message code="evaluate.friend.text2-1" text="인증 요청" />';
					ref += '		</button>';
					ref += '	</div>';
					ref += '	<div class="content">';
					ref += '		<p class="text text-darkgray"><spring:message code="evaluate.friend.text2-2" /></p>';
					ref += '	</div>';
					ref += '</div>';
				}
				ref += '</div>';
			}
			$('#references').after(ref);
			
			DonutWidget.draw();  // 시험별 정답률
			barPercent(); // 척도별 장답률 

			// pdf download
			$('#btnPdf').on('click', function() {
				$('#pdf_iframe').attr('src', '/eval/result-pdf-download?skill=' + skill + '&class=' + clazz);
			});

			var going = '';
			//테스트 참여불가
			if(!testEnabled) {
				going += '<div class="tooltip-guide d-down-md" data-html2canvas-ignore="true">';
				going += '	<p class="text"><spring:message code="evaluate.failed" text="불합격 48시간 이후 재 참여가 가능합니다." /></p>';
				going += '</div>';
			}
			if(progress == 'SELF_EXAM_PASS') {
				going += '<div class="btn-group-default btn-group-fixed d-down-md" data-html2canvas-ignore="true">';
				if(testEnabled) {
					//테스트 참여 가능
					going += '<button type="button" class="btn btn-md btn-secondary btn-test" onclick="fnSkillExamStart()">';
					going += '	<spring:message code="evaluate.skill-test" text="기술 테스트" />';
					going += '</button>';
				} else {
					//테스트 참여 불가
					going += '<button type="button" class="btn btn-md btn-secondary btn-test" disabled>';
					going += '	<spring:message code="evaluate.skill-test" text="기술 테스트" />';
					going += '</button>';
				}
				going += '</div>';
			}
			$('div.test-result').after(going);

			if((data.skillProgressLevelCode == '1202' && progress == 'SELF_EXAM_PASS') || data.skillProgressLevelCode == '1203') {
				window.popupType = 'skill';
			} else if(data.skillProgressLevelCode == '1202') {
				window.popupType = 'self';
			} else {
				window.popupType = 'self';
			}

			if(data.isUse == 'Y') {
				$('#layer-request').show();
				// 친구 목록 팝업 ============================================================================================================
				let $popup = $('#layer-request');
				let page = 1;
				let limit = 10;
				let offset = (page - 1) * limit;
				$(function() {
					$('#layer-request .custom-scroll').mCustomScrollbar('destroy');
					// 모바일
					if (window.matchMedia("(max-width: 1024px)").matches) {
						$popup.find('.custom-scroll').scroll(function(i) {
							if($(window).scrollTop() >= $(document).height() - $(window).height()){
								searchFriend(++page);
							}
						});
					}
					// PC
					else {
						$popup.find('.custom-scroll').mCustomScrollbar({
							scrollInertia: 300,
							scrollEasing: 'easeOut',
							callbacks: {
								onTotalScroll: function() {
									searchFriend(++page);
								},
								onTotalScrollOffset: 10,
								alwaysTriggerOffsets: false
							}
						});
					}

					$popup.find('.keyword').on('keypress', function(e) {
						if(e.keyCode == '13') {
							searchFriend(page = 1);
						}
					});
					$popup.find('.btn-search').on('click', function() {
						searchFriend(page = 1);
					});
					

					// 친구 목록 팝업
					$('.skill-certificate .btn-request').on('click', function() {
						popupOpenRequest();
					});

					$popup.find('.btn-close').on('click', function() {
						popupCloseRequest();
					});

					// 인증 취소
					$('.skill-certificate .btn-cancle').on('click', function() {
						fnAuthRequest('cancel', $(this).data('friend-id'));
					});

					// 인증 요청
					$popup.find('.btn-request').on('click', function() {
						fnAuthRequest('request', $('#layer-request .item [name=friendId]:checked').val());
					});
				});

				function fnAuthRequest(type, friendId) {
					$.ajax({
						url: '/eval/auth/' + type,
						method: 'POST',
						dataType: 'json',
						data: {
							skill: skill,
							class: clazz,
							friendId: friendId
						},
						error: function() {
							location.href = '/error';
						},
						success: function() {
							location.reload();
						}
					});
				}

				function searchFriend() {
					let search = $popup.find('.keyword').val();
					offset = (page - 1) * limit;
					$.ajax({
						url: '/eval/friend/list',
						dataType: 'json',
						data: {
							skill: skill,
							class: clazz,
							searchKeyword: search,
							offset: offset,
							limit: limit
						},
						error: function() {
							location.href = '/error';
						},
						success: function(result) {
							let html = '';
							if(result.code == 'SUCCESS' && result.data != null) {
								let data = result.data;
								let addPadding = false;
								// 친구가 없을 경우
								if(search == '' && data.friendCount == 0 && page == 1) {
									html += '<p class="title"><spring:message code="friend.text2" text="친구" />(0)</p>\n';
									addPadding = true;
									html += '<div class="no-data">\n';
									html += '	<p class="main-copy"><spring:message code="friend.text5" text="등록된 친구가 없습니다." /></p>\n';
									html += '	<div class="btn-group-default mt-4">\n';
									html += '		<a type="button" class="btn btn-md btn-secondary" href="/community/communityRecommendFriendView"><spring:message code="friend.text8" text="친구 찾기" /></a>\n';
									html += '	</div>\n';
									html += '</div>\n';
								}
								// 검색 결과가 없을 경우
								else if(search != '' && data.friendCount == 0 && data.memberCount == 0) {
									html += '<div class="no-data type2">\n';
									html += '	<p class="main-copy"><spring:message code="friend.text6" text="검색 결과가 없습니다." /></p>\n';
									html += '	<p class="sub-copy"><spring:message code="friend.text7" text="입력하신 검색어를 확인해 주세요." /></p>\n';
									html += '</div>\n';
								}

								// 친구 목록
								if(data.friendCount > 0) {
									if(page == 1) {
										html += '<p class="title"><spring:message code="friend.text2" text="친구" />(' + data.friendCount + ')</p>\n';
										addPadding = true;
										html += '<ul class="friend-list">\n';
									}
									for(let i = 0; i < data.friendList.length; i++) {
										html += _createItem(data.friendList[i]);
									}
									if(page == 1) {
										html += '</ul>\n';
									}
								}
								// 회원 목록
								if(data.memberCount > 0) {
									if(page == 1) {
										html += '<p class="title ' + (addPadding ? 'mt-lg-4 mt-md-3' : '') + '"><spring:message code="friend.text3" text="CLIC 회원" />(' + data.memberCount + ')</p>\n';
										addPadding = true;
										html += '<ul class="friend-list" id="member-list">\n';
									}
									for(let i = 0; i < data.memberList.length; i++) {
										html += _createItem(data.memberList[i]);
									}
									if(page == 1) {
										html += '</ul>\n';
									}
								}
								// 추천 회원 목록
								else if(data.referralMemberList != null && data.referralMemberList.length > 0) {
									if(page == 1) {
										html += '<p class="title ' + (addPadding ? 'mt-lg-4 mt-md-3' : '') + '"><spring:message code="friend.text4" text="추천 회원" /></p>\n';
										html += '<ul class="friend-list" id="member-list">\n';
									}
									for(let i = 0; i < data.referralMemberList.length; i++) {
										html += _createItem(data.referralMemberList[i]);
									}
									if(page == 1) {
										html += '</ul>\n';
									}
								}

								if(page == 1) {
									$('#friend-list').html(html);
								}
								else {
									$('#member-list').append(html);
								}
								scrollbar();

								$popup.find('[type=radio]').off('change').on('change', function() {
									$popup.find('.btn-request').prop('disabled', false);
								});
							}
							else {
								location.href = '/error';
							}
						}
					});

					function _createItem(item) {
						let html = '';
						html += '	<li class="item">\n';
						let isAuthReq = !(typeof item.authRequestDate == 'undefined' || item.authRequestDate == 'null' || item.authRequestDate == '');
						if(!isAuthReq) {
							html += '	<input type="radio" name="friendId" id="friend-' + item.userId + '" value="' + item.userId + '">\n';
						}
						html += '		<label for="friend-' + item.userId + '">\n';
						html += '			<div class="profile-area">\n';
						html += '				<div class="profile-frame">\n';
						html += '					<div class="photo">\n';
						let isUserImagePath = !(typeof item.userImagePath == undefined || item.userImagePath == null || item.userImagePath == '');
						if(isUserImagePath) {
							html += '					<img src="' + item.userImagePath + '" alt="" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';">\n';
						} else {
							html += '					<img src="/static/assets/images/common/img-sm-profile-default.png" alt="">\n';
						}
						html += '					</div>\n';
						html += '					<div class="country">\n';
						html += '						<img src="https://flagcdn.com/w640/' + item.countryCode.toLowerCase() + '.png"/>';
						html += '					</div>\n';
						html += '				</div>\n';
						html += '				<div class="profile-info">\n';
						html += '					<span class="name">' + item.name + ' ' + item.firstName + '</span>\n';
						/* if(item.jobName) {
							html += '				<span class="career">' + item.jobName + '</span>\n';
						} */
						html += '				</div>\n';
						html += '			</div>\n';
						html += '		</label>\n';
						if(item.isAuth == 'Y') {
							html += '	<div class="state state-complete">\n';
							html += '		<i class="ico ico-complete"></i>\n';
							html += '	</div>\n';
						}
						else if(item.isAuth == 'R') {
							html += '	<div class="state state-request">\n';
							html += '		<span class="text"><spring:message code="button.request" text="요청" /></span>\n';
							html += '	</div>\n';
						}
						html += '	</li>\n';
						return html;
					}
				}

				function popupOpenRequest() {
					openModal('#layer-request');
					searchFriend(page = 1);
				}

				function popupCloseRequest() {
					$('#friend-list').html('');
					$popup.find('.btn-request').prop('disabled', true);
					$popup.find('.keyword').val('');
					closeModal('#layer-request');
				}
			} else {
				$('#layer-request').hide();
				$('.skill-certificate .btn-request').on('click', function() {
					alert('<spring:message code="alert.text.2" text="테스트를 정상적으로 진행할 수 없는 상태로 변경되었습니다." />');
					location.href = '/eval/list';
				});
			}

			//자가 시험 합격 후 기술 시험 볼 때
			$('#progressTest').val(progress);
			$('#testEnable').val(testEnabled);
			
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}

function fnSkillExamStart() {
	var progress = $('#progressTest').val();
	var testEnabled = $('#testEnable').val();

	if(progress == 'SELF_EXAM_PASS' && testEnabled == 'true') {
		$.ajax({
			url: '/eval/skill/status/wait',
			method: '',
			data: {
				skill: skill,
				class: clazz,
				cuCode: progress,
				upCode: 'SKILL_EXAM_WAIT'
			},
			dataType: '',
			error: function() {
				location.href = '/error';
			},
			success: function() {
				location.reload();
			}
		});
	}
}
</script>

<%-- 스킬 노출 여부 Y --%>
<%-- <c:if test="${data.isUse eq 'Y'}"> --%>
<div class="modal-popup hide" id="layer-request">
	<div class="dimed"></div>
	<div class="popup-inner popup-request">
		<div class="message-wrap message-list">
			<div class="message-header">
				<p class="title"><spring:message code="friend.text1" text="회원 선택" /></p>
				<button type="button" class="btn btn-close-popup d-down-md btn-close">Close</button>
			</div>
			<div class="message-content">
				<div class="global-search">
					<input type="text" class="form-control keyword" placeholder="<spring:message code='friend.text9' text='이름/직업' />">
					<button type="button" class="btn btn-search">Search</button>
				</div>
				
				<div class="message-result custom-scroll">
					<div id="friend-list"></div>
				</div>
				<div class="btn-group-default btn-fixed">
					<a href="javascript:;" class="btn btn-md btn-gray d-up-lg btn-close"><spring:message code="button.cancel" text="취소" /></a>
					<button type="button" class="btn btn-md btn-secondary btn-request" disabled><spring:message code="button.request" text="요청" /></button>
				</div>
			</div>
		</div>
	</div>
</div>
<script type="module">
// 친구 목록 팝업 ============================================================================================================
/* let $popup = $('#layer-request');
let page = 1;
let limit = 10;
let offset = (page - 1) * limit;
$(function() {
	$('#layer-request .custom-scroll').mCustomScrollbar('destroy');
	// 모바일
	if (window.matchMedia("(max-width: 1024px)").matches) {
		$popup.find('.custom-scroll').scroll(function(i) {
			if($(window).scrollTop() >= $(document).height() - $(window).height()){
				searchFriend(++page);
			}
		});
	}
	// PC
	else {
		$popup.find('.custom-scroll').mCustomScrollbar({
			scrollInertia: 300,
			scrollEasing: 'easeOut',
			callbacks: {
				onTotalScroll: function() {
					searchFriend(++page);
				},
				onTotalScrollOffset: 10,
				alwaysTriggerOffsets: false
			}
		});
	}

	$popup.find('.keyword').on('keypress', function(e) {
		if(e.keyCode == '13') {
			searchFriend(page = 1);
		}
	});
	$popup.find('.btn-search').on('click', function() {
		searchFriend(page = 1);
	});
	

	// 친구 목록 팝업
	$('.skill-certificate .btn-request').on('click', function() {
		popupOpenRequest();
	});

	$popup.find('.btn-close').on('click', function() {
		popupCloseRequest();
	});

	// 인증 취소
	$('.skill-certificate .btn-cancle').on('click', function() {
		fnAuthRequest('cancel', $(this).data('friend-id'));
	});

	// 인증 요청
	$popup.find('.btn-request').on('click', function() {
		fnAuthRequest('request', $('#layer-request .item [name=friendId]:checked').val());
	});
});

function fnAuthRequest(type, friendId) {
	$.ajax({
		url: '/eval/auth/' + type,
		method: 'POST',
		dataType: 'json',
		data: {
			skill: skill,
			class: clazz,
			friendId: friendId
		},
		error: function() {
			location.href = '/error';
		},
		success: function() {
			location.reload();
		}
	});
}

function searchFriend() {
	let search = $popup.find('.keyword').val();
	offset = (page - 1) * limit;
	$.ajax({
		url: '/eval/friend/list',
		dataType: 'json',
		data: {
			skill: skill,
			class: clazz,
			searchKeyword: search,
			offset: offset,
			limit: limit
		},
		error: function() {
			location.href = '/error';
		},
		success: function(result) {
			let html = '';
			if(result.code == 'SUCCESS' && result.data != null) {
				let data = result.data;
				let addPadding = false;
				// 친구가 없을 경우
				if(search == '' && data.friendCount == 0 && page == 1) {
					html += '<p class="title"><spring:message code="friend.text2" text="친구" />(0)</p>\n';
					addPadding = true;
					html += '<div class="no-data">\n';
					html += '	<p class="main-copy"><spring:message code="friend.text5" text="등록된 친구가 없습니다." /></p>\n';
					html += '	<div class="btn-group-default mt-4">\n';
					html += '		<a type="button" class="btn btn-md btn-secondary" href="/community/communityRecommendFriendView"><spring:message code="friend.text8" text="친구 찾기" /></a>\n';
					html += '	</div>\n';
					html += '</div>\n';
				}
				// 검색 결과가 없을 경우
				else if(search != '' && data.friendCount == 0 && data.memberCount == 0) {
					html += '<div class="no-data type2">\n';
					html += '	<p class="main-copy"><spring:message code="friend.text6" text="검색 결과가 없습니다." /></p>\n';
					html += '	<p class="sub-copy"><spring:message code="friend.text7" text="입력하신 검색어를 확인해 주세요." /></p>\n';
					html += '</div>\n';
				}

				// 친구 목록
				if(data.friendCount > 0) {
					if(page == 1) {
						html += '<p class="title"><spring:message code="friend.text2" text="친구" />(' + data.friendCount + ')</p>\n';
						addPadding = true;
						html += '<ul class="friend-list">\n';
					}
					for(let i = 0; i < data.friendList.length; i++) {
						html += _createItem(data.friendList[i]);
					}
					if(page == 1) {
						html += '</ul>\n';
					}
				}
				// 회원 목록
				if(data.memberCount > 0) {
					if(page == 1) {
						html += '<p class="title ' + (addPadding ? 'mt-lg-4 mt-md-3' : '') + '"><spring:message code="friend.text3" text="CLIC 회원" />(' + data.memberCount + ')</p>\n';
						addPadding = true;
						html += '<ul class="friend-list" id="member-list">\n';
					}
					for(let i = 0; i < data.memberList.length; i++) {
						html += _createItem(data.memberList[i]);
					}
					if(page == 1) {
						html += '</ul>\n';
					}
				}
				// 추천 회원 목록
				else if(data.referralMemberList != null && data.referralMemberList.length > 0) {
					if(page == 1) {
						html += '<p class="title ' + (addPadding ? 'mt-lg-4 mt-md-3' : '') + '"><spring:message code="friend.text4" text="추천 회원" /></p>\n';
						html += '<ul class="friend-list" id="member-list">\n';
					}
					for(let i = 0; i < data.referralMemberList.length; i++) {
						html += _createItem(data.referralMemberList[i]);
					}
					if(page == 1) {
						html += '</ul>\n';
					}
				}

				if(page == 1) {
					$('#friend-list').html(html);
				}
				else {
					$('#member-list').append(html);
				}
				scrollbar();

				$popup.find('[type=radio]').off('change').on('change', function() {
					$popup.find('.btn-request').prop('disabled', false);
				});
			}
			else {
				location.href = '/error';
			}
		}
	});

	function _createItem(item) {
		let html = '';
		html += '	<li class="item">\n';
		let isAuthReq = !(typeof item.authRequestDate == 'undefined' || item.authRequestDate == 'null' || item.authRequestDate == '');
		if(!isAuthReq) {
			html += '	<input type="radio" name="friendId" id="friend-' + item.userId + '" value="' + item.userId + '">\n';
		}
		html += '		<label for="friend-' + item.userId + '">\n';
		html += '			<div class="profile-area">\n';
		html += '				<div class="profile-frame">\n';
		html += '					<div class="photo">\n';
		if(item.userImagePath == undefined || item.userImagePath == null || item.userImagePath == '') {
			html += '					<img src="' + item.userImagePath + '" alt="" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';">\n';
		}
		else {
			html += '					<img src="/static/assets/images/common/img-sm-profile-default.png" alt="">\n';
		}
		html += '					</div>\n';
		html += '					<div class="country">\n';
		html += '						<img src="https://flagcdn.com/w640/' + item.countryCode.toLowerCase() + '.png"/>';
		// html += '						<img src="/static/assets/images/common/_img-flag.png" alt="">\n';
		html += '					</div>\n';
		html += '				</div>\n';
		html += '				<div class="profile-info">\n';
		html += '					<span class="name">' + item.name + ' ' + item.firstName + '</span>\n';
		//if(item.jobName) {
		//	html += '				<span class="career">' + item.jobName + '</span>\n';
		//}
		html += '				</div>\n';
		html += '			</div>\n';
		html += '		</label>\n';
		if(item.isAuth == 'Y') {
			html += '	<div class="state state-complete">\n';
			html += '		<i class="ico ico-complete"></i>\n';
			html += '	</div>\n';
		}
		else if(item.isAuth == 'R') {
			html += '	<div class="state state-request">\n';
			html += '		<span class="text"><spring:message code="button.request" text="요청" /></span>\n';
			html += '	</div>\n';
		}
		html += '	</li>\n';
		return html;
	}
}

function popupOpenRequest() {
	openModal('#layer-request');
	searchFriend(page = 1);
}

function popupCloseRequest() {
	$('#friend-list').html('');
	$popup.find('.btn-request').prop('disabled', true);
	$popup.find('.keyword').val('');
	closeModal('#layer-request');
} */
</script>
<%-- </c:if> --%>

<%-- 스킬 노출 여부 N --%>
<%-- <c:if test="${data.isUse ne 'Y'}">
<script>
$(function() {
	// 친구 목록 팝업
	$('.skill-certificate .btn-request').on('click', function() {
		alert('<spring:message code="alert.text.2" text="테스트를 정상적으로 진행할 수 없는 상태로 변경되었습니다." />');
		location.href = '/eval/list';
	});
});
</script>
</c:if>

<c:if test="${progress == 'SELF_EXAM_PASS' && testEnabled}">
<script>
function fnSkillExamStart() {
	$.ajax({
		url: '/eval/skill/status/wait',
		method: '',
		data: {
			skill: skill,
			class: clazz,
			cuCode: progress,
			upCode: 'SKILL_EXAM_WAIT'
		},
		dataType: '',
		error: function() {
			location.href = '/error';
		},
		success: function() {
			location.reload();
		}
	});
}
</script>
</c:if> --%>
<iframe id="pdf_iframe" title="pdf content" style="width: 0px;height: 0;padding: 0;margin: 0;border: 0;"></iframe>
</body>
</html>