<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta http-equiv="X-UA-Compatible" content="ie=edge">
<meta name="viewport" content="width=940, initial-scale=1.0">
<meta name="format-detection" content="telephone=no">
<title>CLIC</title>
<link rel="stylesheet" href="/static/common/css/pdf-download.css">

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
<script>
/* const skill = '${data.skillCode}';
const clazz = '${data.examClassCode}';
const progress = '${data.progressStatusCode}'; */
const skill = getParameterByName('skill');
const clazz = getParameterByName('class');
window.jsPDF = window.jspdf.jsPDF;
$(function() {
	getPdfDeatil();

//	DonutWidget.draw();  // 시험별 정답률
//	barPercent(); // 척도별 장답률

	// pdf download
	// let doc = $(document).width() > 1024 ? $('#pdf-area')[0] : $('.wrapper')[0];

});


//URL 파라미터 값 가져오기
function getParameterByName(name) { 
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
	results = regex.exec(location.search); 
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
}

//테스트 결과 상세화면 조회
function getPdfDeatil() {
	$.ajax({
		url: '/eval/result-pdf-download/api?skill='+skill+'&class='+clazz,
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var data = response.data.skill;
			var result = response.data.examResult;
			const progress = data.progressStatusCode;

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

			DonutWidget.draw();  // 시험별 정답률
			barPercent(); // 척도별 장답률

			let skillName = data.skillName;
			let pdf = new jsPDF('p', 'mm', 'a4'); // let pdf = new jsPDF('l', 'mm', 'a4');
			let pageWidth = 210;  // 출력 페이지 세로 길이 계산 A4 기준
			let pageHeight = 297; // 출력 페이지 세로 길이 계산 A4 기준
			let margin = 10;
			let position = margin;
			let height = position;
			let page = 1;

			let length = $('.pdf-area').length;
			for(let i = 0; i < length; i++) {
				html2canvas($('.pdf-area').eq(i)[0], {
					onclone: function(clonedDoc) {
						$(clonedDoc).find('.content-title').text(skillName);
					}
				}).then(function(canvas) {
					_createPdf(canvas, i);

					if(i == length -1) {
						// 파일 저장
						pdf.save('Clic_' + skillName.replace(/ /gi, '_') + '.pdf');
					}
				});
			}

			function _createPdf(canvas, i) {
				let data = canvas.toDataURL('image/jpeg'); //캔버스를 이미지로 변환
				// 출력 페이지 A4 기준 (210 × 297 mm)
				let imgWidth = pageWidth - (margin * 2);
				let imgHeight = canvas.height * imgWidth / canvas.width;

				// // 페이지 증가
				// height += imgHeight;
				// if(pageHeight * page < height) {
				// 	page++;
				// 	pdf.addPage();
				// 	position = 10;
				// }
				pdf.addImage(data, 'jpeg', margin, position, imgWidth, imgHeight);
				position += imgHeight + 10;
			}

		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}
</script>
</head>
<body>
<article id="content">
	<div class="pdf-area">
		<h2 class="content-title"><spring:message code="menu3" text="평가" /></h2>
	</div>
	<div class="content-fixed evaluate-result">
		<div class="content-body style3">
			<div class="test-result">
			<%-- <%@ include file="result-pdf-area.jsp" %> --%>
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
			</div>
		</div>
	</div>
</article>
</body>
</html>