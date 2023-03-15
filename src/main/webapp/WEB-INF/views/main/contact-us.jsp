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
					<h2 class="content-title"><spring:message code="footer.menu.3" text="Contáctenos" /></h2>
					<button type="button" class="btn btn-back">prev</button>
				</div>
				<div class="content-body style3">
					<div class="contact-area">
						<p class="text-guide"><spring:message code="contact.text.1" /></p>
						<div class="form-area style2">
							<div class="form-item">
								<dl class="form-group">
									<dt class="title2"><label for="lb_name1"><spring:message code="contact.text.2" text="Nombre" />*</label></dt>
									<dd>
										<input type="text" id="lb_name1" name="name" class="form-control" maxlength="30">
									</dd>
								</dl>
								<dl class="form-group">
									<dt class="title2"><label for="lb_name2"><spring:message code="contact.text.3" text="Apellido" />*</label></dt>
									<dd>
										<input type="text" id="lb_name2" name="lastName" class="form-control" maxlength="30">
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title2"><label for="lb_mail"><spring:message code="contact.text.4" text="E-mail" />*</label></dt>
									<dd>
										<input type="text" id="lb_mail" name="email" class="form-control" maxlength="100">
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title2"><label for="lb_subject"><spring:message code="contact.text.5" text="Título" />*</label></dt>
									<dd>
										<input type="text" id="lb_subject" name="subject" class="form-control" maxlength="200">
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title2"><label for="lb_content"><spring:message code="contact.text.6" text="Contenido de la consulta" />*</label></dt>
									<dd>
										<textarea rows="5" id="lb_content" name="contents" class="form-control" maxlength="5000"></textarea>
									</dd>
								</dl>
							</div>
						</div>

						<div class="btn-group-default btn-group-fixed mt-lg-6">
							<button type="button" class="btn btn-md btn-secondary btn-send" disabled><spring:message code="button.save" text="Ahorrar" /></button>
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
<div class="modal-popup modal-sm hide" id="layer-confirm">
	<div class="dimed"></div>
	<div class="popup-inner">
		<div class="popup-body text-center">
			<em class="ico ico-check"></em>
			<h2 class="popup-title"><spring:message code="contact.text.8" text="등록완료" /></h2>
			<p class="text mt-lg-5 mt-md-2"><spring:message code="contact.text.9" text="입력하신 이메일 주소로 답변 드리겠습니다." /></p>
			<div class="btn-group-default mt-lg-8 mt-md-8">
				<a href="#;" class="btn btn-md btn-secondary" onclick="closeConfirm()"><spring:message code="button.check" text="확인" /></a>
			</div>
		</div>
	</div>
</div>
<script>
$(function() {
	$('.contact-area input, .contact-area textarea').on('keyup', function() {
		let disabled = false;
		$('.contact-area input, .contact-area textarea').each(function() {
			// console.log($(this).attr('name'), $(this).val());
			if($(this).val().trim() == '') {
				disabled = true;
			}
		});
		$('.btn-send').prop('disabled', disabled);
	})
	$('.btn-send').on('click', function() {
		$.ajax({
			url: '/common/contact-us/send',
			method:'POST',
			dataType: 'json',
			data: {
				name: $('[name=name]').val(),
				lastName: $('[name=lastName]').val(),
				email: $('[name=email]').val(),
				subject: $('[name=subject]').val(),
				contents: $('[name=contents]').val(),
			},
			complete: function() {
				openModal('#layer-confirm');
			}
		});
	});
});

function closeConfirm() {
	// 메인으로 이동
	location.href = '/main';
}
</script>
</body>
</html>