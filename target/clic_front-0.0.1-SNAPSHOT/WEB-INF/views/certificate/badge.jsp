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
<%-- <c:if test="${data.isUse == 'N'}">
<script>
alert('<spring:message code="certificate.alert.no-use" text="스킬 상태가 변경되어 뱃지 정보를 확인할 수 없습니다" />');
location.href = '/cert/badgeList';
</script>
</c:if> --%>
</head>
<body>
<div class="wrapper">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div id="container">
		<aside id="sidebar">
			<%@ include file="../common/side-profile.jsp" %>
		</aside>
		<article id="content">
			<h2 class="content-title"><spring:message code="menu4-2" text="Insignia" /></h2>
			<div class="content-fixed badge-detail">
				<div class="content-header">
					<%-- <div class="inner">
						<h2 class="content-title d-down-md">${data.skillName}</h2>
						<a href="/cert/badgeList" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>
					</div> --%>
				</div>
				<div class="content-body style3">
					<%-- <div class="badge-intro">
						<div class="image-area">
							<img src="${data.badgeObtainImagePath}" alt="" style="width:100px">
							<span class="name">${data.skillName}</span>
						</div>
						<div class="intro-area">
							${data.badgeContents}
							<!-- 
							<p class="title">As a citizen of the 21st century, you should be able to</p>
							<div class="content"></div>
							 -->
							<div class="btn-group-default btn-fixed">
								<c:choose>
									<c:when test="${data.progressStatusCode == 'PASS'}">
										<a class="btn btn-md btn-secondary" href="/eval/skill?skill=${data.skillCode}&class=${data.examClassCode}">
											<spring:message code="button.check-result" text="결과 확인" />
										</a>
									</c:when>
									<c:otherwise>
										<a class="btn btn-md btn-secondary" href="/eval/skill?skill=${data.skillCode}&class=${data.examClassCode}">
											<spring:message code="button.test" text="테스트" />
										</a>
									</c:otherwise>
								</c:choose>
							</div>
						</div>
					</div> --%>
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
	
	getBadgeDeatil();  //뱃지 상세화면 조회
	
});

//URL 파라미터 값 가져오기
function getParameterByName(name) { 
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
	results = regex.exec(location.search); 
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
}

//뱃지 상세화면 조회
function getBadgeDeatil() {
	$.ajax({
		url: '/cert/badge/api?skill='+skill+'&class='+clazz,
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var result = response.data;
			console.log(result);
			var title = '';
			var content = '';
			if(result.isUse == 'N') {
				alert('<spring:message code="certificate.alert.no-use" text="스킬 상태가 변경되어 뱃지 정보를 확인할 수 없습니다" />');
				location.href = '/cert/badgeList';
			} else {
				title += '<div class="inner">';
				title += '	<h2 class="content-title d-down-md">'+result.skillName+'</h2>';
				title += '	<a href="/cert/badgeList" class="btn btn-list"><spring:message code="button.list" text="목록" /></a>';
				title += '</div>';
				$('div.content-header').append(title);

				var reContents = result.badgeContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

				content += '<div class="badge-intro">';
				content += '	<div class="image-area">';
				content += '		<img src="'+result.badgeObtainImagePath+'" alt="">';
				content += '		<span class="name">'+result.skillName+'</span>';
				content += '	</div>';
				content += '	<div class="intro-area">';
				content += 			reContents;
				content += '		<div class="btn-group-default btn-fixed">';
				if(result.progressStatusCode == 'PASS') {
					content += '		<a class="btn btn-md btn-secondary" href="/eval/skill?skill='+result.skillCode+'&class='+result.examClassCode+'">';
					content += '			<spring:message code="button.check-result" text="결과 확인" />';
					content += '		</a>';
				} else {
					content += '		<a class="btn btn-md btn-secondary" href="/eval/skill?skill='+result.skillCode+'&class='+result.examClassCode+'">';
					content += '			<spring:message code="button.test" text="테스트" />';
					content += '		</a>';
				}
				content += '		</div>';
				content += '	</div>';
				content += '</div>';
				$('div.content-body.style3').append(content);
			}

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