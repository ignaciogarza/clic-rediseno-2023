<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
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
		</aside>
		<article id="content">
			<h2 class="content-title"><spring:message code="menu4-1" text="Resltandos" /></h2>
			<div class="certificate-wrap">
				<%-- <c:if test="${fn:length(skillList) eq 0}">
					<!-- 참여내역이 없는 경우 -->
					<div class="no-data">
						<p class="main-copy">
							<spring:message code="certificate.no-data.text1" text="No hay historial de participación" />
						</p>
						<p class="sub-copy">
							<spring:message code="certificate.no-data.text2" text="Pon a prueba tus propias habilidades y<br class=\"d-down-sm\"> solicita una certificación" />
						</p>
						<div class="btn-group-default mt-lg-8 mt-md-4">
							<a class="btn btn-md btn-secondary" href="/eval/list"/>
								<spring:message code="evaluate.skill-test" text="기술 테스트" />
							</a>
						</div>
					</div>
				</c:if>
				<c:if test="${fn:length(skillList) > 0}">
					<!-- 참여내역이 있는 경우 -->
					<div class="certificate-result">
						<c:forEach items="${skillList}" var="item">
							<div class="box box-shadow box-round">
								<div class="item">
									<div class="skill-info">
										<div class="badge-image">
											<img src="${item.badgeObtainImagePath}" alt="">
										</div>
										<span class="skill-name">${item.skillName}</span>
									</div>
									<div class="test-result">
										<div class="total-rate">
											<div class="item">
												<p class="title"><spring:message code="evaluate.skill.step1" text="Auto-reporte" /></p>
												<div class="donut-widget normal"
													data-chart-size="normal"
													data-chart-max="100"
													data-chart-value="${item.selfFinalScore}"
													data-chart-primary="#88386d"
													data-chart-background="#edf0f5">
												</div>
											</div>
											<c:if test="${item.badgeObtainLevelCode == '1502' || item.badgeObtainLevelCode == '1503'}">
												<div class="item">
													<p class="title"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></p>
													<div class="donut-widget normal"
														data-chart-size="normal"
														data-chart-max="100"
														data-chart-value="${item.skillFinalScore}"
														data-chart-primary="#167e87"
														data-chart-background="#edf0f5">
													</div>
												</div>
											</c:if>
										</div>
									</div>
									<span class="date-info">
										<fmt:formatDate value="${item.updatedDate}" pattern="dd.MM.yyyy"/>
									</span>
									<div class="btn-area">
										<button type="button" class="btn btn-md btn-secondary btn-result" data-skill="${item.skillCode}" data-clazz="${item.examClassCode}">
											<spring:message code="button.result" text="결과" />
										</button>
									</div>
								</div>
							</div>
						</c:forEach>
					</div>
				</c:if> --%>
			</div>
		</article>
	</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</div>
<script>
$(document).ready(function() {
	
	getSkillList();  //스킬 list
	
});

//스킬 list
function getSkillList() {
	$.ajax({
		url: '/cert/resultList/api',
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var skillList = response.data;
			var html = '';
			//참여 내역이 있는 경우
			if(skillList.length != 0) {
				html += '<div class="certificate-result">';
				$.each(skillList, function(index, item) {
					html += '<div class="box box-shadow box-round">';
					html += '	<div class="item">';
					html += '		<div class="skill-info">';
					html += '			<div class="badge-image">';
					html += '				<img src="'+item.badgeObtainImagePath+'" alt="">';
					html += '			</div>';
					html += '			<span class="skill-name">'+item.skillName+'</span>';
					html += '		</div>';
					html += '		<div class="test-result">';
					html += '			<div class="total-rate">';
				
					html += '				<div class="item">';
					html += '					<p class="title"><spring:message code="evaluate.skill.step1" text="Auto-reporte" /></p>';
					html += '					<div class="donut-widget normal"';
					html += '						data-chart-size="normal"';
					html += '						data-chart-max="100"';
					html += '						data-chart-value="'+item.selfFinalScore+'"';
					html += '						data-chart-primary="#88386d"';
					html += '						data-chart-background="#edf0f5">';
					html += '					</div>';
					html += '				</div>';
					if(item.badgeObtainLevelCode == '1502' || item.badgeObtainLevelCode == '1503') {
						html += '			<div class="item">';
						html += '				<p class="title"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></p>';
						html += '				<div class="donut-widget normal"';
						html += '					data-chart-size="normal"';
						html += '					data-chart-max="100"';
						html += '					data-chart-value="'+item.skillFinalScore+'"';
						html += '					data-chart-primary="#167e87"';
						html += '					data-chart-background="#edf0f5">';
						html += '				</div>';
						html += '			</div>';
					}
					if(item.badgeObtainLevelCode == '1503' || item.badgeObtainLevelCode == '1504') {
						html += '<div class="item">';
						html += '	<p class="title"><spring:message code="evaluate.skill.step3-1" text="Validación" /> <br class="d-down-sm"><spring:message code="evaluate.skill.step3-2" text="de pares" /></p>';
						html += '	<div class="donut-widget normal"';
						html += '		data-chart-size="normal"';
						html += '		data-chart-max="3"';
						html += '		data-chart-value="3"';
						html += '		data-chart-text="3/3"';
						html += '		data-chart-primary="#81BA26"';
						html += '		data-chart-background="#edf0f5">';
						html += '	</div>';
						html += '</div>';
					}
					
					html += '			</div>';
					html += '		</div>';
					html += '		<span class="date-info">'+item.formateUpdatedDate+'</span>';
					html += '		<div class="btn-area">';
					html += '			<button type="button" class="btn btn-md btn-secondary btn-result" data-skill="'+item.skillCode+'" data-clazz="'+item.examClassCode+'">';
					html += '				<spring:message code="button.result" text="결과" />';
					html += '			</button>';
					html += '		</div>';
					html += '	</div>';
					html += '</div>';
				});
				html += '</div>';
				$('div.certificate-wrap').append(html);
				
				DonutWidget.draw();  // 시험별 정답률

				$('.btn-result').on('click', function() {
					let skill = $(this).data('skill');
					let clazz = $(this).data('clazz');
					if(skill != undefined && clazz != undefined) {
						window.location.href = '/cert/result?skill=' + skill + '&class=' + clazz;
					}
				});
			//참여 내역이 없는 경우
			} else {
				html += '<div class="no-data">';
				html += '	<p class="main-copy">';
				html += '		<spring:message code="certificate.no-data.text1" text="No hay historial de participación" />';
				html += '	</p>';
				html += '	<p class="sub-copy">';
				html += '		<spring:message code="certificate.no-data.text2" text="Pon a prueba tus propias habilidades y<br class=\"d-down-sm\"> solicita una certificación" />';
				html += '	</p>';
				html += '	<div class="btn-group-default mt-lg-8 mt-md-4">';
				html += '		<a class="btn btn-md btn-secondary" href="/eval/list"/>';
				html += '			<spring:message code="evaluate.skill-test" text="기술 테스트" />';
				html += '		</a>';
				html += '	</div>';
				html += '</div>';
				$('div.certificate-wrap').append(html);
			}
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}
</script>
</body>
</html>