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
			<div class="badge-info">
				<%-- <p class="title">${data.skillName}</p>
				<div class="img-badge">
					<img src="${data.badgeObtainImagePath}" alt="" style="width:100px">
				</div>
				<div class="btn-group-default">
					<a href="/cert/badge?skill=${data.skillCode}&class=${data.examClassCode}" class="btn btn-md btn-outline-gray">
						<spring:message code="button.check-info" text="Ver información" />
					</a>
				</div> --%>
			</div>
		</aside>
		<article id="content">
			<div class="pdf-area">
				<h2 class="content-title"><spring:message code="menu4-1" text="Resltandos" /></h2>
			</div>
			<div class="content-fixed evaluate-result">
				<div class="content-header">
					<div class="inner pdfButton">
						<%-- <h2 class="content-title d-down-md">${data.skillName}</h2>
						<span data-html2canvas-ignore="true">
							<a href="javascript:;" class="btn btn-sm btn-primary btn-down" id="btnPdf"><spring:message code="button.download.pdf" text="PDF 다운로드" /></a>
							<a href="/cert/resultList" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>
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
				</div>
			</div>
		</article>
	</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</div>
<script>
/* const skill = '${data.skillCode}';
const clazz = '${data.examClassCode}'; */
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
		url: '/cert/result/api?skill='+skill+'&class='+clazz,
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var data = response.data.skill;
			var result = response.data.examResult;

			var badge = '';
				badge += '<p class="title">'+data.skillName+'</p>';
				badge += '<div class="img-badge">';
				badge += '	<img src="'+data.badgeObtainImagePath+'" alt="" style="width:100px">';
				badge += '</div>';
				badge += '<div class="btn-group-default">';
				badge += '	<a href="/cert/badge?skill='+data.skillCode+'&class='+data.examClassCode+'" class="btn btn-md btn-outline-gray">';
				badge += '		<spring:message code="button.check-info" text="Ver información" />';
				badge += '	</a>';
				badge += '</div>';
			$('div.badge-info').append(badge);

			var name = '';
				name += '<h2 class="content-title d-down-md">'+data.skillName+'</h2>';
				name += '<span data-html2canvas-ignore="true">';
				name += '	<a href="javascript:;" class="btn btn-sm btn-primary btn-down" id="btnPdf"><spring:message code="button.download.pdf" text="PDF 다운로드" /></a>';
				name += '	<a href="/cert/resultList" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>';
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
				for (var i = result.authList.length; i < 2; i++) {
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
			
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}
</script>
<iframe id="pdf_iframe" title="pdf content" style="width: 0px;height: 0;padding: 0;margin: 0;border: 0;"></iframe>
</body>
</html>