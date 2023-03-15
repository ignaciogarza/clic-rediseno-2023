<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
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
	<link rel="stylesheet" href="/static/assets/css/style.css">
</head>
<body>
	<div class="error-wrapper">
		<header id="header">
			<div class="header-top">
				<div class="inner">
					<h1 id="logo">
						<a href="javascript:;">Clic</a>
					</h1>
				</div>
			</div>
		</header>
		<div class="error-content">
			<em class="ico ico-error2"></em>
			<c:if test="${empty msgCode}">
				<div class="error-copy">
					<p class="main-text"><spring:message code="error.msg.title" text="요청 된 페이지에 액세스 할 수 없습니다." /></p>
					<p class="sub-text"><spring:message code="error.msg.content" text="찾고있는 페이지가 변경되었거나 기술적인 문제가 발생했습니다.<br>정상적으로 처리되지 않습니다.<br>잠시 후 다시 연결하십시오." /></p>
				</div>
				<div class="btn-group-default">
					<a href="javascript:;" onclick="history.back()" class="btn btn-md btn-outline-gray"><spring:message code="button.prev" text="이전" /></a>
					<a href="/main" class="btn btn-md btn-secondary"><spring:message code="button.home" text="HOME" /></a>
				</div>
			</c:if>
			<c:if test="${not empty msgCode}">
				<div class="error-copy">
					<p class="main-text"><spring:message code="${msgCode}.title" text="${msgCode}.title" /></p>
					<p class="sub-text"><spring:message code="${msgCode}.content" text="${msgCode}.content" /></p>
				</div>
				<div class="btn-group-default">
					<a href="<spring:message code='${msgCode}.prev-url' text='/' />" class="btn btn-md btn-outline-gray"><spring:message code="button.prev" text="이전" /></a>
					<a href="/main" class="btn btn-md btn-secondary"><spring:message code="button.home" text="HOME" /></a>
				</div>
			</c:if>
		</div>
	</div>

	<!-- JavaScript -->
	<script src="/static/assets/js/jquery-3.5.1.min.js"></script>

	<!-- 공통 UI 컴포넌트 -->
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script>

	<!-- 페이지 개별 스크립트 -->
	<script>
		// 이곳에 정의
	</script>
</body>

</html>