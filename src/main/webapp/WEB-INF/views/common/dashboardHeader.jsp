<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script src="/static/common/js/common_util.js"></script>
<script>
var userId;
var email;
var menuType;
$(document).ready(function () {		
	//var menuType = "${menuType}"	
	/* 
	if(menuType == "vi"){		
		$("#vi").addClass("on");
	}else if(menuType == "en"){
		$("#en").addClass("on");
	}else if(menuType == "pr"){
		$("#pr").addClass("on");
	}else if(menuType == "ra"){
		$("#ra").addClass("on");
	}	 */
});

function fnTopMenu(type){
	
	if(type == "vi"){
		location.href= "/dashboard/dashboardOverview";
	}else if(type == "en"){
		location.href= "/dashboard/dashboardSurveyView";
	}else if(type == "pr"){
		location.href= "/dashboard/dashboardSurveyView";
	}else if(type == "ra"){
		location.href= "/dashboard/dashboardRankingView";
	}	
	
}

//로그아웃 
/* function fnSignOut(email){
	//이메일 인코딩
	var email = encodeURIComponent(email);
	location.href= "/login/signOut?email="+email;
} */

//비밀번호 변경
function fnPwChangSave(){
	
	 //userId = "${userId}";
	 //email = "${email}";
	var passwordOld = $("#passwordOld").val();
	var password_01 = $("#password_01").val();
	var password_02 = $("#password_02").val();
	
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
</script>

<header id="header">
	<div class="header-top">
		<div class="inner">
				<span class="logo-idb">IDB</span>
				<h1 id="logo">
						<a href="/dashboard/dashboardMainView"><span>Clic</span><spring:message code="menu10" text="Observatory"/></a>
					</h1>
				<div class="util-area">
				<!-- 로그인 전 -->
				<c:if test="${empty sessionScope.userId}">
				<ul class="util-menu">
					<li><a href="#;" class="btn btn-login"><em class="ico ico-login"></em><span>Ingresar</span></a></li>
				</ul>
				</c:if>
				<!-- // 로그인 전 -->
				<!-- 로그인 후 (일반회원, 정부회원) -->
				<c:if test="${not empty sessionScope.userId}">
				<ul class="util-menu d-up-lg">
					<li>
						<dl class="dropdown dropdown-profile">
							<dt><a href="#;" class="btn btn-util btn-profile">Profile</a></dt>
							<dd>
								<div class="dropdown-inner">
									<div class="info-area">
										<span class="country">
											<img src="/static/assets/images/content/img-flag-colombia.png" alt="">
										</span>
										<span class="account">${sessionScope.sessionEmail}</span>
									</div>
									<ul class="dropdown-list">
										<li><a href="#;" onclick="openModal('#layer-pwchange');"><spring:message code="profile.text8" text="Cambia la contraseña"/></a></li><!-- 비밀번호 변경 -->
										<li><a href="#;" onclick="fnSignOut('${sessionScope.sessionEmail}','${sessionScope.userId}');"><spring:message code="menu.drop3" text="cerrar sesión" /></a></li>
									</ul>
								</div>
							</dd>
						</dl>
					</li>
				</ul>
				<!-- // 로그인 후 -->
				<dl class="dropdown dropdown-language d-up-lg">
					<dt><a href="#;" class="btn btn-language" id="langText">ESPAÑOL</a></dt>
					<dd>
						<div class="dropdown-inner">
							<ul class="dropdown-list">
								<li class="lang" data-value="es"><a href="javascript:;" onclick="fnOpenLang('es');">Español</a></li>
								<li class="lang" data-value="en"><a href="javascript:;" onclick="fnOpenLang('en');">English</a></li>
								<li class="lang" data-value="ko"><a href="javascript:;" onclick="fnOpenLang('ko');">한글</a></li>
							</ul>
						</div>
					</dd>
				</dl>
				</c:if>
				
			</div>
		</div>
	</div>
	<!-- 로그인 후 (정부회원) -->
	<c:if test="${not empty sessionScope.userId}">
	<nav id="gnb">
		<div class="inner">
			<ul class="gnb-list">
				<li id="vi"><a href="/dashboard/dashboardOverview" ><span><spring:message code="dashboard.text8" text="Visión general"/></span></a></li>
				<li id="en"><a href="/dashboard/dashboardSurveyView"><span><spring:message code="profile.text7" text="Encuesta sobre el entorno de las TIC"/></span></a></li>
				<li id="pr"><a href="/dashboard/dashboardSkillsView"><span><spring:message code="dashboard.text29" text="Prueba de habilidades"/></span></a></li>
				<li id="ra"><a href="/dashboard/dashboardRankingView"><span><spring:message code="dashboard.text27" text="Ranking"/></span></a></li>
			</ul>
		</div>
	</nav>
	<a href="#allmenu" class="btn btn-allmenu-open">
		<em class="ico ico-allmenu"></em>
		<span class="sr-only">Allmenu</span>
	</a>
	<div id="allmenu">
		<div class="allmenu-inner">
			<div class="allmenu-header">
				<div class="allmenu-util">
					<div class="logo">
						<a href="#;"><span>Clic</span><spring:message code="menu10" text="Observatory"/></a>
					</div>
					<button type="button" class="btn btn-allmenu-close">
						<em class="ico ico-close"></em>
						<span class="sr-only">Close</span>
					</button>
				</div>
			</div>
			<div class="allmenu-content">
				<div class="profile-area">
					<div class="info-area">
						<span class="country">
							<img src="/static/assets/images/content/img-flag-colombia.png" alt="">
						</span>
						<span class="account">abcd12341111@gmail.com</span>
					</div>
					<div class="btn-area">
						<a href="#;" class="btn btn-md btn-outline-gray btn-round" onclick="openModal('#layer-pwchange');">Cambiar la contraseña</a>
					</div>
				</div>
				<div class="lnb-area">
					<ul class="lnb-list">
						<li><a href="#;"><span>Visión general</span></a></li>
						<li><a href="#;"><span>Encuesta sobre el entorno de las TIC</span></a></li>
						<li><a href="#;"><span>Prueba de habilidades</span></a></li>
						<li><a href="#;"><span>Ranking</span></a></li>
					</ul>
					<div class="btn-area">
						<button type="button" class="btn btn-md btn-outline-gray btn-block">cerrar sesión</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	</c:if>
	<!-- // 로그인 후 (정부회원) -->
	
	<!-- 레이어팝업 비밀번호 변경 로직 -->
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
								<th scope="row"><label for="passwordOld"><spring:message code="profile.text9" text="contraseña actual"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="passwordOld" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="password_01"><spring:message code="profile.text10" text="Cambia la contraseña"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="password_01" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="password_02"><spring:message code="profile.text11" text="Confirmar cambio de contraseña"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="password_02" class="form-control">
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
	<div class="modal-popup modal-sm hide" id="layer-complete">
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
</header>