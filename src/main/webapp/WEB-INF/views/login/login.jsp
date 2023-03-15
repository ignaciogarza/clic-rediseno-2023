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
				
		// 저장된 쿠키값을 가져와서 ID 칸에 넣어준다. 없으면 공백으로 들어감.
	    var key = getCookie("key");
	    $("#email").val(key); 
	     
	    if($("#email").val() != ""){ // 그 전에 ID를 저장해서 처음 페이지 로딩 시, 입력 칸에 저장된 ID가 표시된 상태라면,
	        $("#idSaveCheck").attr("checked", true); // ID 저장하기를 체크 상태로 두기.
	    }
	     
	    $("#idSaveCheck").change(function(){ // 체크박스에 변화가 있다면,
	        if($("#idSaveCheck").is(":checked")){ // ID 저장하기 체크했을 때,
	            setCookie("key", $("#email").val(), 7); // 7일 동안 쿠키 보관
	        }else{ // ID 저장하기 체크 해제 시,
	            deleteCookie("key");
	        }
	    });
	     
	    // ID 저장하기를 체크한 상태에서 ID를 입력하는 경우, 이럴 때도 쿠키 저장.
	    $("#email").keyup(function(){ // ID 입력 칸에 ID를 입력할 때,
	        if($("#idSaveCheck").is(":checked")){ // ID 저장하기를 체크한 상태라면,
	            setCookie("key", $("#email").val(), 7); // 7일 동안 쿠키 보관
	        }
	    });
	    
	    
	  //엔터키 처리 
		$("#password").keydown(function(e){
			if(e.keyCode == 13){
				fnLoginCk();
			}	 
		});
	  
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
	
	
	//로그인 체크  
	function fnLoginCk(){
				
		var email = $("#email").val();
		var password = $("#password").val();
		var data = {				
				email : email,
				password : password
		};	
	
		$.ajax({
			url: '/login/signIn',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				
				//setCookie("lang", 'es', 7); // 7일 동안 쿠키 보관
				
				if(result == "1"){					
					//프로필 저장  
					//location.href= "/user/userProfileForm?email="+email;
					location.href= "/user/userProfileForm";	
				}else if(result == "2"){
					//다른 쪽으로 이동 메인 페이지
					location.href= "/main";					
				}else if(result == "4"){
					//정부관계자 대시보드 이동
					location.href= "/dashboard/dashboardMainView";
				}else if(result == "5"){
					alert('<spring:message code="error.msg.14.title" text="" />');	
					location.reload();
				}else{
					alert('<spring:message code="error.msg.2.title" text="아이디 또는 비밀번호가 일치하지 않습니다. 다시 입력해주세요." />');				
				}
			}
		});
	}
	
	//회원가입 view 이동 
	function fnUserFormMove(){
		location.href= "/user/userForm";
	}
	
	//비밀번호 view 이동 
	function fnPasswordFindView(){
		location.href= "/login/passwordFindView";
	}
	
	function setCookie(cookieName, value, exdays){
	    var exdate = new Date();
	    exdate.setDate(exdate.getDate() + exdays);
	    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
	    document.cookie = cookieName + "=" + cookieValue;
	}
	 
	function deleteCookie(cookieName){
	    var expireDate = new Date();
	    expireDate.setDate(expireDate.getDate() - 1);
	    document.cookie = cookieName + "= " + "; expires=" + expireDate.toGMTString();
	}
	 
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
		<div class="login-box">
			<div class="login-title">
				<a href="/main" class="img-logo d-up-lg">Clic</a>
				<h2 class="title"><spring:message code="login.title" /></h2>  <!--  Iniciar Sesión -->
			</div>
			<div class="login-area">
				<form action="#;">
					<div class="login-form">
						<div class="form-item">
							<input type="text" class="form-control" placeholder="<spring:message code="contact.text.4" text="Usuario" />" title="Usuario" id="email">
						</div>
						<div class="form-item">
							<input type="password" class="form-control" autocomplete="off" placeholder="<spring:message code="contact.text.7" text="Contraseña" />" title="Contraseña" id="password">
							<button type="button" class="btn btn-view">View password</button>
						</div>
						<div class="login-info">
							<div class="check-item">
								<input type="checkbox" id="idSaveCheck">
								<label for="idSaveCheck"><spring:message code="login.text1" text="Recuerdame" /></label>
							</div>
							<a href="#;" class="btn-pwfind" onClick="fnPasswordFindView()"><spring:message code="login.message1" text="Olvidaste la contraseña?" /></a>
						</div>
						<button type="button" class="btn btn-lg btn-secondary btn-block btn-login" onClick="fnLoginCk()"><spring:message code="login.loginbutton" text="Ingresar" /></button> 
						<div>
							<div class="divider"></div>
							<a href="/user/userProfileForm" class="btn btn-sm btn-secondary btn-block btn-login btn-login-employee mt-1">
								<spring:message code="login.loginbuttonemployee" text="Ingresar" />
							</a> 
						</div>
					</div>
				</form>
				<div class="login-notice btn-fixed">
					<spring:message code="login.message2" text="No tienes cuenta?"/>
					<a href="#;" class="text-primary" onClick="fnUserFormMove()"><spring:message code="login.memberSave" text="Crea una"/></a>
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