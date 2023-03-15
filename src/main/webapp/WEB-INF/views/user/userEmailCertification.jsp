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
	
	<script src="https://code.jquery.com/jquery-1.11.3.js"></script>
	<script>
	var email = getParameterByNames('email');
	
	
	
	function getParameterByNames(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1]); 
	}
	
	$(document).ready(function () {		
		$("#email").val(email);
		$("#emailSendEvent").attr("onClick", "fnEmailSend(\'"+email+"\')");
		//인증시간 체크 
		var AuthTimer = new $ComTimer()
		  AuthTimer.comSecond = 900;
    	  //AuthTimer.comSecond = 10;
		  AuthTimer.fnCallback = function(){alert('<spring:message code="login.message11" text="다시인증을 시도해주세요." />');}
		  AuthTimer.timer =  setInterval(function(){AuthTimer.fnTimer()},1000);
		  AuthTimer.domId = document.getElementById("timer");
		  
		  
		  $("#emailNo").keyup(function(){
			  //clearInterval(4);
			  //$("#timer").text("");
			  $('#submitBt').attr("style",'background-color: #81BA26;');
			  $("#submitBt").attr("onClick", "fnEmailConfirm()");
		  });
		  
		  document.onkeydown = NotReload;
		  
		  
		  
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
	
	function getCookie(cookieName) {
	    cookieName = cookieName + '=';
	    var cookieData = document.cookie;
	    var start = cookieData.indexOf(cookieName);
	    var cookieValue = '';
	    if(start != -1){
	        start += cookieName.length;
	        var end = cookieData.indexOf(';', start);
	        if(end == -1)end = cookieData.length;
	        cookieValue = cookieData.substring(start, end);
	    }
	    return unescape(cookieValue);
	}
	
	
	//새로고침 방지 
	function NotReload(){ 
		if( (event.ctrlKey == true && (event.keyCode == 78 || event.keyCode == 82)) || (event.keyCode == 116) ) { 
			event.keyCode = 0; event.cancelBubble = true; event.returnValue = false; 
			} 
	} 

	
	//이메일 인증 확인 
	function fnEmailConfirm(){
		var emailNo = $("#emailNo").val();
		var email = $("#email").val();
		
		var data = {
				email : email,
				emailNo :emailNo
		};
	
		$.ajax({
			url: '/user/getEmailNoConfirm',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				var result = response.data;
				if(result == true){
					//인증 성공 로그인 페이지로 이동 
					//alert("인증성공");
					//회원가입 완료 레이어 팝업 호출
					openModal('#layerUserConfirm');
				}else{
					alert('<spring:message code="error.msg.13.title" text="인증번호가 일치하지 않습니다." />');
				}
			}
		});
	}
	
	//인증시간 체크 
	function $ComTimer(){
	    //prototype extend
	}

	$ComTimer.prototype = {
	    comSecond : ""
	    , fnCallback : function(){}
	    , timer : ""
	    , domId : ""
	    , fnTimer : function(){    	
	    	
	    	var m1 = Math.floor(this.comSecond / 60);
	    	if(m1 <10){	m1 = "0"+m1;	    	}
	    	
	    	var m2 = (this.comSecond % 60);
	    	if(m2 <10){	m2 = "0"+m2;	    	}
	    	
	    	var m = m1 + ":" + m2;	    	
	    	//var m = Math.floor(this.comSecond / 60) + ":" + (this.comSecond % 60);	// 남은 시간 계산
	        
	        this.comSecond--;					// 1초씩 감소
	        console.log(m);
	        this.domId.innerText = m;
	        if (this.comSecond < 0) {			// 시간이 종료 되었으면..
	            clearInterval(this.timer);		// 타이머 해제
	            //alert("인증시간이 초과하였습니다. 다시 인증해주시기 바랍니다.");
	            //$("#timer").text("00:00");
	            $("#emailReSend").show();
	        }
	    }
	    ,fnStop : function(){
	        clearInterval(this.timer);
	    }
	}
	
	
	
	//이메일 인증 요청 
	function fnEmailSend(email) { 
		//location.href = "/user/emailCertificationView?email=jmh10243@naver.com";
		var data = {email : email	}; 
		$.ajax({
			url: '/user/emailSend',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				result = response.data;
				//alert("인증요청 했씁니다.");
				//location.href = "/user/emailCertificationView?email="+email;
				openModal('#layer-resend');
			}
		});		
		
	}
	
	//이메일 인증 화면 이동
	function fnEmailCertificationView(){
		var email  = $("#email").val();
		
		//이메일 인코딩
		email = encodeURIComponent(email);
		location.href = "/user/emailCertificationView?email="+email;
	}
	
	//로그인 화면 이동 
	function fnLoginView(){
		//로그인 화면 이동 
		location.href = "/login/login";
	} 
	
	</script>
</head>

<body class="login-page">
	<div class="login-wrap">
		<%-- <div class="login-header">
			<div class="header-top">
				<div class="inner">
					<h1 id="logo">
						<a href="#;">Clic</a>
					</h1>
					<div class="util-area">
						<div class="util-menu d-up-lg">
							<a href="#;" class="btn btn-login"><i class="ico ico-login"></i><spring:message code="login.loginbutton" text="Ingresar" /></a>
							<a href="#;" class="btn btn-sm btn-primary btn-join"><spring:message code="login.memberSave" text="Registrate Ya!" /></a>
						</div>
					</div>
				</div>
			</div>
		</div> --%>
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
		<div class="login-box email-box">
			<div class="login-title">
				<div class="img-logo d-up-lg">Clic</div>
				<h2 class="title"><spring:message code="login.text10" text="Verificaciogn de Email" /></h2>
				
				<p class="text"><spring:message code="login.message9" text="" /></p>
			</div>
			<div class="login-area">
				<form action="#;">
					<div class="login-form">
						<div class="form-item">
							
							<input type="text" class="form-control" title="E-mail" id="email" value="" disabled>  
						</div>
						<div class="form-item form-number">
							<input type="text" class="form-control" id="emailNo" placeholder="<spring:message code="login.text9" text="Numero de Certificación" />" title="Numero de Certificación">
							<p class="remain-time" id="timer"></p>
							<div class="clearfix"  style="display:none" id="emailReSend">
								<div class="float-left">
									
									<p class="msg-invalid"><spring:message code="login.message11" text="" /></p>
								</div>
								<div class="float-right">
									<button type="button" class="btn btn-md btn-primary btn-resend" id="emailSendEvent" ><spring:message code="login.text8" text="reenviar" /></button>
									
								</div>
							</div>
						</div>
						
						<button type="button" style="background-color: #585856;" class="btn btn-lg btn-secondary btn-block btn-login" id="submitBt"><spring:message code="button.check" text="Confirmar" /></button>
					</div>
				</form>
			</div>
		</div>
	</div>

	<!-- 인증번호 보냈다는 레이어팝업 -->
	<div class="modal-popup modal-sm hide" id="layer-resend">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title"><spring:message code="evaluate.friend.text2-1" text="Envío completado" /></h2>
				<p class="text mt-lg-5 mt-md-2"><spring:message code="login.message8" text="Envío completado" /></p>
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="#;" class="btn btn-md btn-secondary" onclick="fnEmailCertificationView();"><spring:message code="button.check" text="Confirmar" /></a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 회원가입완료 레이어팝업 -->
	<div class="modal-popup modal-sm hide" id="layerUserConfirm">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title"><spring:message code="login.memberSave" text="" /></h2>
				
				<p class="text mt-lg-5 mt-md-2"><spring:message code="login.message10" text="" /></p>
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="#;" class="btn btn-md btn-secondary" onclick="fnLoginView();"><spring:message code="login.loginbutton" text="Ingresar" /></a>
				</div>
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
</body>

</html>