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
		<!-- 리소스 추가 (10.28) -->
	
	<link rel="stylesheet" media="all" href="https://live-idb-config.pantheonsite.io/themes/custom/iadb/css/iadb-styles.css?v=0.0.4">
	<!-- // 리소스 추가 (10.28) -->	
	<link rel="stylesheet" href="/static/assets/css/style.css">
	<script src="/static/assets/js/jquery-3.5.1.min.js"></script>	
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script> 
	
	<script src="/static/common/js/init.js"></script>
	<script>
	$(document).ready(function () {
		$('#email').on('input',processkey);
		
		
		let lang = getCookie('lang');
		  
		//현재 기본 언어 - 스페인어
		$('html').attr('lang', 'es');

		//헤더 다국어
		console.log('lang: '+lang);
		if(lang == 'en') {
			$('#language_IADB').val('en');
			$('html').attr('lang', 'en');
		} else if(lang == 'es') {
			$('#language_IADB').val('es');
			$('html').attr('lang', 'es');
		}

		//기존 파라미터가 있을 경우 다국어
		const urlParameter = window.location.search;
		if(urlParameter.length > 0) {
			const urlParams = new URLSearchParams(urlParameter);
			if(urlParams.has('lang') == true) {
				urlParams.delete('lang');
				var newUrl = urlParams.toString();
				if(newUrl == '') {
					$('#en_path_IADB').val('?lang=en');
					$('#es_path_IADB').val('?lang=es');
				} else {
					$('#en_path_IADB').val('?'+newUrl+'&lang=en');
					$('#es_path_IADB').val('?'+newUrl+'&lang=es');
				}
			} else {
				$('#en_path_IADB').val(urlParameter+'&lang=en');
				$('#es_path_IADB').val(urlParameter+'&lang=es');
			}
		}
		
	});
	
	function processkey(){ 	        
	     	
	      var email = $("#email").val();
	   	  
	   	 //if(portfolioName == "" || tag == "" || lb_file1 == ""){
	   	 if(email == ""){
	   		$('#submitBt').attr("style",'background-color: #585856;');
			$("#submitBt").attr("onClick", ""); 
	     }else {
	    	 $('#submitBt').attr("style",'background-color: #81BA26;');
			 $("#submitBt").attr("onClick", "fnEmailPasswordSend()");	
	     }
	}
	
	//임시 비밀번호 메일 발송
	function fnEmailPasswordSend(){		
		var email = $("#email").val();		
		var data = {
				email : email
		};
		
		
		
		// 이메일 체크 정규식
		var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		if(regExp.test(email) == false){
			alert('<spring:message code="error.msg.10.title" text="이메일형식에 맞게 입력해주세요." />');	
			return false;
		}
		
		//이메일 중복 체크 
		var result = checkEmailDup(email);
		if(result == true){		
			alert('<spring:message code="error.msg.3.title" text="등록 이메일이 아닙니다. 다시 이메일 확인 부탁 드립니다." />');	
			return false;
		}
	
		$.ajax({
			url: '/login/emailPasswordSend',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				if(response.code == "SUCCESS"){
					openModal('#layer-resend');	
				}
			}
		});
	}
	
	//이메일 중복 체크 
	function checkEmailDup(email) { 
		var result; 
		var data = {email : email	}; 
		$.ajax({
			url: '/user/getEamilCk',
			type: 'post',
			data: data,
			dataType: 'json',
			async: false,
			success: function(response){
				result = response.data;
			}
		});		
		return result; 
	}
	
	
	//로그인 화면 이동 
	function fnLoginView(){
		location.href = "/login/login";
	} 
	
	</script>
</head>
<body class="login-page">
	<div class="login-wrap">
		
		<div class="login-header">
			<div class="header-top">
				<div class="inner">
					
					<h1 id="logo">
						<a href="#;">Clic</a>
					</h1>
					
					<a href="#;" class="btn btn-close d-down-md">close</a>
				</div>
			</div>
		</div>
		<div class="login-box pwfind-box">
			<div class="login-title">
				<a href="/main" class="img-logo d-up-lg">Clic</a>
				<h2 class="title"><spring:message code="login.message3" text="" /></h2>
				<p class="text"><spring:message code="login.message3-1" text="" /></p>
			</div>
			<div class="login-area">
				<form action="#;">
					<div class="login-form">
						<div class="form-item">
							<input type="text" class="form-control" placeholder="E-mail" title="E-mail" id="email">
							
						</div>
						
						<button type="button" style="background-color: #585856;" class="btn btn-lg btn-secondary btn-block btn-login" id="submitBt"><spring:message code="button.check" text="" /></button>
					</div>
				</form>
			</div>
		</div>
	</div>
		
	<!-- 공통 UI 컴포넌트 -->
	<!-- 리소스 추가 (10.28) -->
	<script src="https://live-idb-config.pantheonsite.io/modules/custom/api_menu_items/V.0.0.4/js/lib/template-idb.js"></script>
	<script src="https://live-idb-config.pantheonsite.io/modules/custom/api_menu_items/V.0.0.4/js/lib/underscore-min.js"></script>
	<script src="https://live-idb-config.pantheonsite.io/modules/custom/api_menu_items/V.0.0.4/js/main.js"></script>

	<!-- Start __ Header And Footer IADB-->
	<input type="hidden" id="language_IADB" name="language_IADB" value="es"><!-- 현재 기본 언어 - 스페인어 -->
	<input type="hidden" id="en_path_IADB" name="en_path_IADB" value="?lang=en">
	<input type="hidden" id="es_path_IADB" name="es_path_IADB" value="?lang=es">	
	<input type="hidden" id="pt_path_IADB" name="pt_path_IADB" value="no-link">
	<input type="hidden" id="fr_path_IADB" name="fr_path_IADB" value="no-link">
	<!-- End __ Header And Footer IADB-->
	<!-- // 리소스 추가 (10.28) -->	
		
	<!-- 발송완료 레이어팝업 -->
	<div class="modal-popup modal-sm hide" id="layer-resend">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title"><spring:message code="login.message4" text="" /></h2> 
				<p class="text mt-lg-5 mt-md-2"><spring:message code="login.message4-1" text="" /></p>
				<!-- <p class="text mt-lg-5 mt-md-2">입력하신 이메일 주소로<br class="d-down-md">임시비밀번호를 발송하였습니다.</p> -->
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="#;" class="btn btn-md btn-secondary" onclick="fnLoginView();"><spring:message code="button.check" text="확인" /></a>
				</div>
			</div>
		</div>
	</div>

</body>
</html>