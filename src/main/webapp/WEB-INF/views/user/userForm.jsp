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
	<!-- 공통 UI 컴포넌트 -->
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script> 	
	<script src="/static/common/js/init.js"></script>	
	<script>	
	$(document).ready(function () {		
		
		//이용약관 체크 
		/* $("#inputCheck").change(function(){
	        if($("#inputCheck").is(":checked")){
	            //alert("체크박스 체크했음!");	          
	            $('#submitBt').attr("style",'background-color: #81BA26;');
				$("#submitBt").attr("onClick", "fnSubmitBt()");	
	        }else{
	            //alert("체크박스 체크 해제!");
	            $('#submitBt').attr("style",'background-color: #585856;');
				$("#submitBt").attr("onClick", "");
	        }	      
	    }); */
	    
	    getTermsList();
		
		$("#inputCheck").change(processkey);
		$('#name').on('input',processkey);
		$('#firstName').on('input',processkey);
		$('#email').on('input',processkey);
		$('#password_01').on('input',processkey);
		$('#password_02').on('input',processkey);
		
		
		
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
	      var name = $("#name").val();		
	      var firstName = $("#firstName").val();			
	      var email = $("#email").val();					
	      var password_01 = $('#password_01').val();
	      var password_02 = $('#password_02').val();
	   	  
	   	 //if(portfolioName == "" || tag == "" || lb_file1 == ""){
	   	 if(name == "" || firstName == "" || email == "" || password_01 == "" || password_02 == "" || !$("#inputCheck").is(":checked")){
	   		$('#submitBt').attr("style",'background-color: #585856;');
			$("#submitBt").attr("onClick", "");
	     }else {
	    	 $('#submitBt').attr("style",'background-color: #81BA26;');
			 $("#submitBt").attr("onClick", "fnSubmitBt()");	
	     }
	}
	
	
	/* function Mobile(){
		return /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent);
	}
	// 모바일 여부
	var isMobile = false;
	 
	// PC 환경
	var filter = "win16|win32|win64|mac";	 
	if (navigator.platform) {
	    isMobile = filter.indexOf(navigator.platform.toLowerCase()) < 0;
	} */
	
	//이용약관 조회 
	function getTermsList(){		 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : {"userId" : userId },
	        url : '/user/termsList',
	        success : function(response) {
	          var resultList = response.data;	          
	          var html = '';
	          if(resultList != null && resultList.length > 0){
				for (var i = 0; i < resultList.length; i++) {
					
					if(resultList[i].termsTypeCode == '0901'){
						html += '		<li>';
						html += '			<input type="hidden" id="termsId_01" name="termsId_01" value="'+resultList[i].termsId+'">';
						html += '			<a href="#;" onclick="fnCondiciones(\''+resultList[i].termsId+'\')"><spring:message code="login.text6" text="Términos y condiciones"/></a>';
						html += '		</li>';
					}else if(resultList[i].termsTypeCode == '0902'){
						html += '		<li>';
						html += '			<input type="hidden" id="termsId_02" name="termsId_02" value="'+resultList[i].termsId+'">';
						html += '			<a href="#;" onclick="fnPrivacidad(\''+resultList[i].termsId+'\')"><spring:message code="login.text7" text="Política de privacidad"/></a>';
						html += '		</li>';
					}
				  }				   
			  }			 
			  $("#termsForm").append(html);  
			 
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	    
	
	//저장  
	function fnSubmitBt(){ 
		
		//1. 필수 정보 체크 
		//2.다음버튼 숨기기 이용약관 등록해야 버튼 활성화 퍼블이 필요 할거 같음 
		//3.비밀번호 체크 및 암호와 어떻게 할건지 학인 필요.
		//4.취소 팝업창 확인 필요.
		 
		var name  = $("#name").val();
		var firstName  = $("#firstName").val(); 
		var email  = $("#email").val();
		var password_01 = $("#password_01").val();
		var password_02 = $("#password_02").val();
		
		var termsId_01 = parseInt($("#termsId_01").val());
		var termsId_02 = parseInt($("#termsId_02").val());
		var termsId = [termsId_01, termsId_02]; 
		//	var termsId = ['0901', '0902'] ;
		
		// 체크여부 확인
		if($("input:checkbox[name=inputCheck]").is(":checked") == false) {
			//alert("이용약관 동의 해주세요.");
			return false;
		}
		
		if(name == ""){
			alert('<spring:message code="profile.message11" text="성을 입력해주세요." />');
			return false;
		}		
		if(firstName == ""){
			alert('<spring:message code="profile.message12" text="이름을 입력해주세요." />');		
			return false;
		}
		if(email == ""){
			//alert("이메일을 입력해주세요.");
			return false;
		}
		// 이메일 체크 정규식
		var regExp = /^[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*@[0-9a-zA-Z]([-_\.]?[0-9a-zA-Z])*\.[a-zA-Z]{2,3}$/i;
		if(regExp.test(email) == false){
			alert('<spring:message code="error.msg.10.title" text="이메일형식에 맞게 입력해주세요." />');	
			return false;
		}
		if(password_01 == "") {					
			alert('<spring:message code="profile.message26" text="비밀번호을 입력해주세요." />');	
			return false;
		}
		if(password_02 == "") {					
			alert('<spring:message code="profile.message26" text="비밀번호을 입력해주세요." />');	
			return false;
		}
	 	if(password_01 != password_02) {					
	 		alert('<spring:message code="profile.message28" text="비밀번호가 일치하지 않습니다." />');
			return false;
		}
		if(password_01.search(/[a-z]/g) < 0) {					
			alert('<spring:message code="profile.message29" text="비밀번호에 영문 소문자를 하나 이상 입력해주세요." />');	
			return false;
		}
		if(password_01.search(/[A-Z]/g) < 0) {					
			alert('<spring:message code="profile.message30" text="비밀번호에 영문 대문자를 하나 이상 입력해주세요." />');	
			return false;
		}
		if(!isValidPwdPolicy(password_01)) {					
			alert('<spring:message code="profile.message31" text="영어, 숫자, 특수문자 포함 8~16자 이내의 조합으로 등록해주세요." />');
			return false;
		}
		
		// 모바일 여부
		var isMobile = false;
		 
		// PC 환경
		var filter = "win16|win32|win64|mac";	 
		if (navigator.platform) {
		    isMobile = filter.indexOf(navigator.platform.toLowerCase()) < 0;
		}
		
		var osType;
		
		if(isMobile == false){
			osType = "P";
		}else{
			osType = "M";
		}
				 
		var data = {
					name : name,
					firstName : firstName,
					email : email,
					password : password_01,
					termsId_01 : termsId_01,
					termsId_02 : termsId_02,
					termsId : termsId,
					osType : osType
			};
		
		
		//이메일 인증 전 상태 체크
		var resultNo = checkEmailNoStatus(email);
		if(resultNo == false){			
			alert('<spring:message code="error.msg.14.title" text="이메일 인증 되지 않은 회원입니다. 다시 회원가입 해주세요." />');
			location.reload();
			return false;			
		}
		
		
		//이메일 중복 체크 
		var result = checkEmailDup(email);
		if(result == false){			
			alert('<spring:message code="error.msg.5.title" text="이미 가입된 이메일 정보 입니다." />');
			return false;
		}
		
		
		
		
		$.ajax({
			url: '/user/userInsert',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				if(response.code == "SUCCESS"){
					//alert('저장되었습니다.');	
					//이메일인증 요청 비동기 처리 
					fnEmailSend(email);
					openModal('#layer-resend');
					
				}else{
					alert(response.message);
				}
			}
		});
	}
	
	//이메일 인증 요청 
	function fnEmailSend(email) { 
		var data = {	email : email	}; 
		$.ajax({
			url: '/user/emailSend',
			type: 'post',
			data: data,
			dataType: 'json',
			async: true,
			success: function(response){
				result = response.data;
				//alert("인증요청 했씁니다."); // 레이팝업 이 필요.
				//location.href = "/user/emailCertificationView?email="+email;
				openModal('#layer-resend')
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
	
	//이메일 인증 전 상태 체크
	function checkEmailNoStatus(email) { 
		var result; 
		var data = {email : email	}; 
		$.ajax({
			url: '/user/getEamilNoStatusCk',
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
	
	
	//로그인 페이지 이동 
	function fnClose(){			
		if(confirm('<spring:message code="error.msg.4.title" text="회원가입을 취소하시겠습니까?입력사항은 저장되지 않습니다." />')) {
	        // 취소(아니오) 버튼 클릭 시 이벤트
	        //alert("로그인페이지로이동");
			location.href= "/main";
	    } 
	}
	
	
	//이용약관 확인 
	function fnCondiciones(){
		//alert("이용약관 확인 이동");
		location.href= "/common/terms-and-conditions";
	}
	
	//개인정보 취급방침 확인 
	function fnPrivacidad(){
		//alert("개인정보 취급방침 확인 ");
		location.href= "/common/privacy-policy";		
	}
	
	 
	//로그인 페이지 이동 
	function fnLoginMove(){
		if(confirm('<spring:message code="error.msg.4.title" text="회원가입을 취소하시겠습니까?입력사항은 저장되지 않습니다." />')) {
	        // 취소(아니오) 버튼 클릭 시 이벤트
	        //alert("로그인페이지로이동");
			location.href= "/login/login";
	    } 
		
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
		<div class="login-box join-box">
			<div class="login-title" onclick="fnClose()">
				<div class="img-logo d-up-lg">Clic</div>
				<h2 class="title"><spring:message code="login.memberSave" text=""/></h2>
			</div>
			<div class="login-area">
				<form id="form" action="#;">
					<div class="login-form">
						<div class="form-item">
							<input type="text" class="form-control" placeholder="<spring:message code="login.text2" text="Nombre(s)"/>" title="Nombre(s)" id="name" name="name" maxlength="50">
						</div>
						<div class="form-item">
							<input type="text" class="form-control" placeholder="<spring:message code="contact.text.3" text="Nombre(s)"/>" title="Apellido(s)" id="firstName" name="firstName" maxlength="25">
						</div>
						<div class="form-item">
							<input type="text" class="form-control" placeholder="" title="" id="" name="E-mail" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
							<input type="text" class="form-control" placeholder="<spring:message code="contact.text.4" text="E-mail"/>" title="E-mail" id="email" name="email" autocomplete="off">
						</div>
						<div class="form-item">
							<input type="password" class="form-control" placeholder="" title="" id="" name="" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
							<input type="password" class="form-control" placeholder="<spring:message code="contact.text.7" text="Contraseña"/>" title="Contraseña" id="password_01" name="password_01" autocomplete="off">
							<button type="button" class="btn btn-view">View password</button>
						</div>
						<div class="form-item">
							<input type="password" class="form-control" autocomplete="off" placeholder="<spring:message code="contact.text.14" text="Confirmar Contraseña"/>" title="Confirmar Contraseña" id="password_02" name="password_02">
							<button type="button" class="btn btn-view">View password</button>
						</div>
						<p class="text-info"><spring:message code="contact.text.15" text=""/></p>
						<div class="login-info">
							<div class="check-item">
								
								<input type="checkbox" id="inputCheck" name="inputCheck" value="Y">
								<label for="inputCheck"><spring:message code="login.message5" text=""/></label>
							</div>
						</div>
						<ul class="terms-list" id="termsForm">
							
						</ul>
						
						<button type="button" style="background-color: #585856;" class="btn btn-lg btn-secondary btn-block btn-join" id="submitBt" ><spring:message code="button.next" text="Siguiente" /></button> 
					</div>
				</form>
				<div class="login-notice btn-fixed">
					<spring:message code="login.message6" text="Ya tienes cuenta?" /><a href="#;" class="text-primary" onclick="fnLoginMove();"><spring:message code="login.loginbutton" text="Inicia Sesión" /></a>
				</div>
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