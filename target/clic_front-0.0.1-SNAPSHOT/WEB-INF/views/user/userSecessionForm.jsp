<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
	
	var email = getParameterByNames('email');
	var userId = getParameterByNames('userId');	
	
	$("#email").val(email);
	$("#userId").val(userId);
	
	function getParameterByNames(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1]); 
	}
	
	//탈퇴 화면 
	$(document).ready(function () {
		getUserDetailInfo();
	});
	
	//사용자 정보 조회 
	function getUserDetailInfo(){		 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"email" : email, "userId" : userId },
	        url : '/user/userSecessionList',
	        success : function(response) {
	          var userDetail = response.data.userDetail;
	          
	          $("#preImage").attr("src", userDetail.userImagePath);
		      $("#userCountry").attr("src", "https://flagcdn.com/w640/"+userDetail.countryCode.toLowerCase()+".png");
		      $("#userName").text(userDetail.name+" "+userDetail.firstName);
		      //$("#userJob").text(userDetail.jobNameEng);
		      
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	
	//탈퇴사유 저장
	function fnSecessionSave(){
				
		var email = $("#email").val();
		var userId = $("#userId").val();		
		//탈퇴사유 체크값 
		var leverReasonCode = $("input[name='leverReasonCode']:checked").val();
		
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
						email : email,
						userId : userId,
						leverReasonCode : leverReasonCode,
						osType : osType
					}; 
		$.ajax({
			url: '/user/userSecessionSave',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				if(response.code == "SUCCESS"){
					//result = response.data;				
					openModal('#layer-complete');	
				}else{
					
				}				
			}
		});		
	}
	
	
	//비밀번호 변경
	function fnPwChangSave(){
		
		var userId = $("#userId").val();
		var email = $("#email").val();
		var passwordOld = $("#passwordOld_user").val();
		var password_01 = $("#password_01_user").val();
		var password_02 = $("#password_02_user").val();
		
		if(passwordOld == "") {					
			alert('<spring:message code="profile.message25" text="기존 비밀번호를 입력해주세요." />');	
			return false;
		}
		
		if(password_01 == "") {					
			alert('<spring:message code="profile.message26" text="비밀번호을 입력해주세요." />');	
			return false;
		}
		
		if(passwordOld == password_01) {					
			alert('<spring:message code="profile.message27" text="입력하신 비밀번호가 기존 비밀번호와 동일합니다." />');	
			return false;
		}
		
		if(password_02 == "") {					
			alert('<spring:message code="profile.message26" text="비밀번호을 입력해주세요." />');	
			return false;
		}
	 	if(password_01 != password_02) {					
	 		alert('<spring:message code="profile.message28" text="비밀번호가 일치하지 않습니다" />');	
			return false;
		}
		if(password_01.search(/[a-z]/g) < 0) {					
			alert('<spring:message code="profile.message29" text="비밀번호에 영문 소문자를 하나 이상 입력해주세요" />');	
			return false;
		}
		if(password_01.search(/[A-Z]/g) < 0) {					
			alert('<spring:message code="profile.message30" text="비밀번호에 영문 대문자를 하나 이상 입력해주세요" />');	
			return false;
		}
		if(!isValidPwdPolicy(password_01)) {					
			alert('<spring:message code="profile.message31" text="영어, 숫자, 특수문자 포함 8~16자 이내의 조합으로 등록해주세요" />');	
			return false;
		}
		
		var data = {
				userId : userId,				
				email : email,
				passwordOld : passwordOld,
				password : password_01
		};	
		
		$.ajax({
			url: '/user/userPwUpdate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				var result = response.data;
				
				if(result == "1"){					
					//alert('저장되었습니다.');	
					//이메일인증 요청 
					//fnEmailSend(email);
					closeModal('#layer-pwchange');
					openModal('#layer-complete');
				}else if(result == "0"){
					//다른 쪽으로 이동 메인 페이지
					//location.href= "/main";	
					alert('<spring:message code="profile.message25" text="기존 비밀번호를 입력해주세요." />');						
				}
			}
		});
	}
	
	
	//회원프로필 view 이동 
	function fnUserProfileFormMove(){
		location.href= "/user/userProfileForm";	
	}
	</script>	
</head>

<body>
<input type="hidden" id="email" name="email" value="${email}">
<input type="hidden" id="userId" name="userId" value="${userId}">
	<div class="wrapper">
		
		<!-- header Start -->
		<jsp:include page="../common/header.jsp"></jsp:include>
		<!-- header End -->
		
		<div id="container">
			<aside id="sidebar">
				<div class="profile-area">
					<div class="profile-frame">
						<div class="photo">
							<img id="preImage"  alt="" onerror="this.src='/static/assets/images/common/img-profile-default@2x.png'">
						</div>
						<div class="country">
							<img id="userCountry" onerror="this.src='/static/assets/images/common/_img-flag.png'"alt="">
						</div>
						
						
					</div>
					<div class="profile-info">
						<span class="name" id="userName"></span>
						<span class="career" id="userJob"></span>
					</div>
					<div class="mt-lg-7 mt-md-4">
						<a href="#;" class="btn btn-md btn-outline-gray btn-round btn-block" onclick="openModal('#layer-pwchange');">Cambiar la contraseña</a>
					</div>
				</div>
			</aside>
			<article id="content">
				<div class="content-fixed">
					<div class="content-header">
						<div class="inner">
							<h2 class="content-title d-down-md">Retiro</h2>
							<a href="#;" class="btn btn-back">prev</a>
						</div>
					</div>
					<div class="content-body">
						<div class="withdrawal-wrap">
							<div class="img-logo">Clic</div>
							<p class="title"><spring:message code="profile.text12" text=""/></p>
							
							<p class="text mt-lg-2 mt-md-1"><spring:message code="profile.message5" text=""/></p>
							
							<form action="#">
								<div class="form-area">
									<div class="form-item">
										<dl class="form-group">
											<dt class="title2 mb-3"><spring:message code="profile.message6" text="Seleccione un motivo para el retiro."/></dt>
											<dd>
												<ul>
													<li>
														<span class="check-item">
															<input type="radio" name="leverReasonCode" id="leverReasonCode_1"  value="0702"> <!-- 서비스 이용이 불편해요 -->
															<label for="leverReasonCode_1"><spring:message code="profile.message7" text="El uso del servicio es inconveniente."/></label>
														</span>
													</li>
													<li class="mt-lg-4 mt-md-3">
														<span class="check-item">
															<input type="radio" name="leverReasonCode" id="leverReasonCode_2" value="0703"> <!-- 자유방문하지 않아요 -->
															<label for="leverReasonCode_2"><spring:message code="profile.message8" text="No visito a menudo"/></label>
														</span>
													</li>
													<li class="mt-lg-4 mt-md-3">
														<span class="check-item">
															<input type="radio" name="leverReasonCode" id="leverReasonCode_3" value="0704"> <!-- 중복되는 계정 사용중입니다 -->
															<label for="leverReasonCode_3"><spring:message code="profile.message9" text="Estás usando una cuenta duplicada"/></label>
														</span>
													</li>
												</ul>
											</dd>
										</dl>
									</div>
									<div class="btn-group-default btn-fixed">
										<a href="#;" class="btn btn-md btn-gray" onclick="fnUserProfileFormMove()"><spring:message code="button.cancel" text="cancelar"/></a>
										
										<button type="button" class="btn btn-md btn-primary" onclick="fnSecessionSave()"><spring:message code="profile.text12" text="Retiro"/></button>
									</div>
								</div>
							</form>
						</div>
					</div>
				</div>
			</article>
		</div>
		
		
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->	
	</div>

	<!-- 레이어팝업 -->
	<div class="modal-popup modal-sm hide" id="layer-complete">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title"><spring:message code="login.message4" text=""/></h2>
				<p class="text mt-lg-5 mt-md-2"><spring:message code="profile.message32" text=""/><br class="d-down-md"><spring:message code="profile.message33" text=""/></p>
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="/main" class="btn btn-md btn-secondary"><spring:message code="button.check" text=""/></a>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 비밀번호 변경 팝업 레이어팝업 -->
	
	<div class="modal-popup modal-md hide" id="layer-pwchange">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-header">
				<h2 class="popup-title"><spring:message code="profile.text8" text="Cambia la contraseña"/></h2>
			</div>
			<div class="popup-body">
				<div class="table-wrap">
					<table class="table table-write">
						<caption class="sr-only"><spring:message code="profile.text8" text="Cambia la contraseña"/></caption>
						<colgroup>
							<col style="width:200px">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="passwordOld_user"><spring:message code="profile.text9" text="contraseña actual"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="passwordOld_user" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="password_01_user"><spring:message code="profile.text10" text="Cambia la contraseña"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="password_01_user" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="password_02_user"><spring:message code="profile.text11" text="Confirmar cambio de contraseña"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="password_02_user" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
									<p class="text-info"><spring:message code="contact.text.15" text="Cambia la contraseña"/></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn-group-default btn-fixed mt-lg-8">
					<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-pwchange');"><spring:message code="button.cancel" text="cancelar"/></a>
					<button type="submit" class="btn btn-md btn-secondary" onclick="fnPwChangSave();"><spring:message code="button.save" text="Confirmar"/></button>
				</div>
			</div>
		</div>
	</div>

	<!-- 비밀번호 성공후 팝업  -->
	<div class="modal-popup modal-sm hide" id="layer-completess">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title">Envío completado</h2>
				<p class="text mt-lg-5 mt-md-2"><spring:message code="profile.message4" text=""/></p>
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="#;" class="btn btn-md btn-secondary" onclick="closeModal('#layer-complete');"><spring:message code="login.loginbutton" text="Ingresar"/></a>
				</div>
			</div>
		</div>
	</div>	
</body>
</html>