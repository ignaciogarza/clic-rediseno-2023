<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
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
<style>
.gvm-wrapper {
	background-color: #ffffff;
}
</style>
</head>
<body>
<c:choose>							 
	<c:when test = "${sessionScope.userTypeCode == '0102'}">		
		<div class="wrapper gvm-wrapper gvm-login">
		<jsp:include page="../common/dashboardHeader.jsp"></jsp:include>
	</c:when>
	<c:otherwise>
		<div class="wrapper">
		<jsp:include page="../common/header.jsp"></jsp:include>
	</c:otherwise>
</c:choose>
	<div id="container">
		<article id="content">
			<div class="content-fixed policy-wrap">
				<div class="content-header">
					<h2 class="content-title"><spring:message code="footer.menu.0" text="Política" /></h2>
					<button type="button" class="btn btn-back">prev</button>
				</div>
				<div class="content-body style2">
					<nav class="tab-menu">
						<ul class="tab-list">
							<%-- <li class="${code eq '0901' ? 'on' : ''}"><a href="/common/terms-and-conditions"><spring:message code="footer.menu.1" text="Términos De Servicio" /></a></li>
							<li class="${code eq '0902' ? 'on' : ''}"><a href="/common/privacy-policy"><spring:message code="footer.menu.2" text="Política De Privacidad" /></a></li> --%>
						</ul>
					</nav>
					<div class="tab-content">
						<div class="policy-content">
							<%-- <p>${data.termsContents}</p> --%>
						</div>
					</div>
				</div>
			</div>
		</article>
	</div>
	<c:choose>							 
		<c:when test = "${sessionScope.userTypeCode == '0102'}">
			<jsp:include page="../common/dashboardFooter.jsp"></jsp:include>
		</c:when>
		<c:otherwise>
			<jsp:include page="../common/footer.jsp"></jsp:include>
		</c:otherwise>
	</c:choose>
</div>

<script>
$(document).ready(function() {
	if(document.URL.indexOf('terms-and-conditions') >= 0) {
		//이용 약관 조회
		getTerms();
	} else {
		//개인정보 취급 방침 조회
		getPolicy();
	}
});

function getTerms() {
	$.ajax({
		url: '/common/terms-and-conditions/api',
		dataType: 'json',
		error: function() {
			// location.href = '/error';
		},
		success: function(response) {
			var data = response.data;
			var terms = (data.code == '0901') ? 'on' : '';
			var policy = (data.code == '0902') ? 'on' : '';
			
			var html = '';
				html += '<li class="'+terms+'"><a href="/common/terms-and-conditions"><spring:message code="footer.menu.1" text="Términos De Servicio" /></a></li>';
				html += '<li class="'+policy+'"><a href="/common/privacy-policy"><spring:message code="footer.menu.2" text="Política De Privacidad" /></a></li>';
			$('ul.tab-list').append(html);

			var reContents = data.termsContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
			
			var content = '<p style="margin-top:30px;">'+reContents+'</p>';
			$('div.policy-content').append(content);
		}
	});
}

function getPolicy() {
	$.ajax({
		url: '/common/privacy-policy/api',
		dataType: 'json',
		error: function() {
			// location.href = '/error';
		},
		success: function(response) {
			var data = response.data;
			var terms = (data.code == '0901') ? 'on' : '';
			var policy = (data.code == '0902') ? 'on' : '';
			
			var html = '';
				html += '<li class="'+terms+'"><a href="/common/terms-and-conditions"><spring:message code="footer.menu.1" text="Términos De Servicio" /></a></li>';
				html += '<li class="'+policy+'"><a href="/common/privacy-policy"><spring:message code="footer.menu.2" text="Política De Privacidad" /></a></li>';
			$('ul.tab-list').append(html);

			var reContents = data.termsContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

			var content = '<p style="margin-top: 30px;">'+reContents+'</p>';
			$('div.policy-content').append(content);

			
		}
	});
}
</script>
</body>
</html>