<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script src="/static/common/js/common_util.js"></script>
	<script>
	$(document).ready(function () {	
		
		
		//비밀번호 변경 팝업
		var passwordIsEarly = "${sessionScope.passwordIsEarly}";
		if(passwordIsEarly == "Y"){
			openModal('#layer-pwchange_header');
		}
		
		allmenuSetting();

		let lang = getCookie('lang');
		if(lang ==  "es"){
			$("#langText").text("Español");
		}else if(lang == "en"){
			$("#langText").text("English");
		}
		
		//엔터키 처리 
		$("#madinSearchValue").keydown(function(e){
			if(e.keyCode == 13){
				mainSearch(1);
			}	 
		});

		//메인 검색 (사람/포토폴리오)
		$('#mainSearch').click(function(){
			
			if($("#madinSearchValue").val() == ""){
				alert('<spring:message code="search.alert.msg2" text="검색어를 입력해주세요." />');
				return false;
			}	
			mainSearch(1);
		});
		
		
		//모바일 엔터키 처리 
		$("#madinSearchValueMobile").keydown(function(e){
			if(e.keyCode == 13){
				mainSearchMobile(1);
			}	 
		});

		//모바일 메인 검색 (사람/포토폴리오)
		$('#mainSearchMobile').click(function(){
			
			if($("#madinSearchValueMobile").val() == ""){
				alert('<spring:message code="search.alert.msg2" text="검색어를 입력해주세요." />');
				return false;
			}	
			mainSearchMobile(1);
		});
		
		// 모바일 뒤로가기
		$('.btn-back').on('click', function() {
			history.back();
		});
	});
	
	//메인 검색 (사람/포토폴리오)
	function mainSearchMobile(page){
		/* var forms = $("form[name=mainPagingForm]");		
	  	forms.find("input[name=mainPage]").val(page);
	  	forms.find("input[name=mainRows]").val(15);  
	  	//form.find("input[name=madinSearchValue]").val($("#madinSearchValue").val());
	  	forms.find("input[name=madinSearchValue]").val($("#madinSearchValueMobile").val());
	  	//form.attr("action", "/main/mainSearchView");
	  	forms.submit(); */
	  	var userId = "${sessionScope.userId}";
	  	var madinSearchValueMobile = $("#madinSearchValueMobile").val();
	  	location.href= "/main/mainSearchView?mainPage="+ page+"&madinSearchValue="+madinSearchValueMobile+"&userId="+userId+"&mainRows=15&type=user";	
	  		
	}
	
	//메인 검색 (사람/포토폴리오)
	function mainSearch(page){
		/* var form = $("form[name=mainPagingForm]");		
	  	form.find("input[name=mainPage]").val(page);
	  	form.find("input[name=mainRows]").val(15);  
	  	form.find("input[name=madinSearchValue]").val($("#madinSearchValue").val());
	  	//form.find("input[name=madinSearchValue]").val($("#madinSearchValueMobile").val());
	  	//form.attr("action", "/main/mainSearchView");
	  	form.submit(); */
	  	var userId = "${sessionScope.userId}";
	  	var madinSearchValue = $("#madinSearchValue").val();
	  	location.href= "/main/mainSearchView?mainPage="+ page+"&madinSearchValue="+madinSearchValue+"&userId="+userId+"&mainRows=15&type=user";		  	
	}
	
	//faq로 이동
	function fnFaq() {
		location.href='/common/faq';
	}

	
	//로그아웃 
	function fnSignOut(email){	
		//이메일 인코딩
		var email = encodeURIComponent(email);		
		location.href= "/login/signOut?email="+email;
		
	}
	
	//접속 이력 저장
	function fnAccessHistory(frontMenuId){
		var data = {
				frontMenuId : frontMenuId				
		};		
		$.ajax({
			//url: '/user/accessHistoryInsert',
			type: 'post',
			data: data, 
			dataType: 'json',
			success: function(response){
				
			}
		});
	}
	
	//비밀번호 변경
	function fnPwChangSave_header(){
		
		var userId = "${sessionScope.userId}";
		var email = "${sessionScope.sessionEmail}";
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
					<!-- 마크업 추가 (07.07) -->
					<span class="logo-idb">IDB</span>
					<!-- // 마크업 추가 (07.07) -->
					<h1 id="logo">
						<a href="/main">Clic</a>
					</h1>
					<div class="util-area">
						<c:if test="${empty sessionScope.userId}">
							<!-- 로그인 전 -->
						<div class="util-menu d-up-lg">
							<a href="/login/login" class="btn btn-login"><em class="ico ico-login"></em><spring:message code="login.loginbutton" text="Ingresar" /></a>
							<a href="/user/userForm" class="btn btn-sm btn-primary btn-join"><spring:message code="login.memberSave" text="Registrate Ya!" /></a>
						</div>
						<!-- // 로그인 전 -->
						</c:if>
						<c:if test="${not empty sessionScope.userId}">
						<!-- 로그인 후 -->
							<div class="global-search">								
							<input id="madinSearchValue" value="" class="form-control" title="" type="text" placeholder="search" autocomplete="off">
							<input value="" class="form-control" title="" type="text" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
							<button type="button" class="btn btn-search" id="mainSearch" >Search</button>
							</div>
							<ul class="util-menu">
								<li class="${isNewNotice ? 'new' : ''}"><a href="javascript:;" class="btn btn-util btn-notice">Notice</a></li>								
								<li>
									<dl class="dropdown dropdown-profile">
										<dt><a href="javascript:;" class="btn btn-util btn-profile">Profile</a></dt>
										<dd>
											<div class="dropdown-inner">
												<ul class="dropdown-list">
													<li><a href="javascript:;" onClick="openModal('#layer-profile');"><spring:message code="menu.drop1" text="Perfil" /></a></li>
													<li><a href="javascript:;" onclick="fnFaq();"><spring:message code="menu.drop2" text="FAQ" /></a></li>
													<li><a href="javascript:;" onclick="fnSignOut('${sessionScope.sessionEmail}');"><spring:message code="menu.drop3" text="cerrar sesión" /></a></li>
												</ul>
											</div>
										</dd>
									</dl>
								</li>
							</ul>
							<!-- 메시지 레이어 -->
							<%@ include file="header-message.jsp" %>
							<%@ include file="header-notice.jsp" %>
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
			<nav id="gnb">
				<div class="inner">
					<c:choose>							 
						<c:when test = "${sessionScope.isComplete == 'Y'}">
							<ul class="gnb-list">
								<li><a href="/mypage/mypageMain" onclick="fnAccessHistory('2804')"><span><spring:message code="menu1" text="Mi página" /></span></a></li>
								<li><a href="/eval/list" onclick="fnAccessHistory('2806')"><span><spring:message code="menu3" text="Evalúate" /></span></a></li>
								<li><a href="javascript:;"><span><spring:message code="menu4" text="Certifícate" /></span></a>
									<ul style="z-index: 1;">
										<li><a href="/cert/resultList" onclick="fnAccessHistory('2807')"><spring:message code="menu4-1" text="Resltandos" /></a></li>
										<li><a href="/cert/badgeList" onclick="fnAccessHistory('2808')"><spring:message code="menu4-2" text="Insignia" /></a></li>
									</ul>
								</li>
								<li><a href="/community/communityMainView" onclick="fnAccessHistory('2809')"><span><spring:message code="menu5" text="Conéctate" /></span></a></li>
								
								<li><a href="javascript:;" ><span><spring:message code="menu7" text="Clic studio" /></span></a>
									<ul style="z-index: 1;">
										<li><a href="/studio/resume/detail" onclick="fnAccessHistory('2811')"><spring:message code="menu7-1" text="Mi Currículo" /></a></li>
										<li><a href="/studio/portfolio/portfolioFrom"  onclick="fnAccessHistory('2812')"><spring:message code="menu7-2" text="Mi Portafolio" /></a></li>
									</ul>
								</li>
							</ul>
						</c:when>
						<c:otherwise>
							<ul class="gnb-list">
								<c:if test="${empty sessionScope.userId}">
									<li><a href="/login/login"><span><spring:message code="menu1" text="Mi página" /></span></a></li>
									<li><a href="/login/login"><span><spring:message code="menu3" text="Evalúate" /></span></a></li>
									<li><a href="/login/login"><span><spring:message code="menu4" text="Certifícate" /></span></a>
										<ul>
											<li><a href="#"><spring:message code="menu4-1" text="Resltandos" /></a></li>
											<li><a href="#"><spring:message code="menu4-2" text="Insignia" /></a></li>
										</ul>
									</li>
									<li><a href="/login/login"><span><spring:message code="menu5" text="Conéctate" /></span></a></li>
									<!-- <li><a href="/login/login"><span><spring:message code="menu6" text="Aprende" /></span></a></li> -->
									<li><a href="/login/login" ><span><spring:message code="menu7" text="Clic studio" /></span></a>
										<ul>
											<li><a href="#"><spring:message code="menu7-1" text="Mi Currículo" /></a></li>
											<li><a href="#"><spring:message code="menu7-2" text="Mi Portafolio" /></a></li>
										</ul>
									</li>
								</c:if>
								<c:if test="${not empty sessionScope.userId}">
									<li><a href="#"><span><spring:message code="menu1" text="Mi página" /></span></a></li>
									<li><a href="#"><span><spring:message code="menu3" text="Evalúate" /></span></a></li>
									<li><a href="javascript:;"><span><spring:message code="menu4" text="Certifícate" /></span></a>
										<ul>
											<li><a href="#"><spring:message code="menu4-1" text="Resltandos" /></a></li>
											<li><a href="#"><spring:message code="menu4-2" text="Insignia" /></a></li>
										</ul>
									</li>
									<li><a href="#"><span><spring:message code="menu5" text="Conéctate" /></span></a></li>
									<li><a href="#"><span><spring:message code="menu6" text="Aprende" /></span></a></li>
									<li><a href="javascript:;" ><span><spring:message code="menu7" text="Clic studio" /></span></a>
										<ul>
											<li><a href="#"><spring:message code="menu7-1" text="Mi Currículo" /></a></li>
											<li><a href="#"><spring:message code="menu7-2" text="Mi Portafolio" /></a></li>
										</ul>
									</li>
								</c:if>
								
							</ul>
						</c:otherwise>
					</c:choose>
				</div>
			</nav>
			<a href="#allmenu" class="btn btn-allmenu-open">
				<em class="ico ico-allmenu"></em>
				<span class="sr-only">Allmenu</span>
			</a>
			<div id="allmenu">
				<div class="allmenu-inner">
					<c:choose>							 
						<c:when test = "${sessionScope.isComplete == 'Y'}">
							<div class="allmenu-header">
								<div class="allmenu-util">
									<!-- 로그인 후 -->
									<div class="global-search">										
											<input id="madinSearchValueMobile" value="${madinSearchValue}"type="text" class="form-control" placeholder="search" title="search" autocomplete="off">
											<input value="" class="form-control" title="" type="text" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
											<button type="submit" class="btn btn-search" id="mainSearchMobile">Search</button>
									</div>
									<!-- // 로그인 후 -->
									<button type="button" class="btn btn-allmenu-close">
										<em class="ico ico-close"></em>
										<span class="sr-only">Close</span>
									</button>
								</div>
							</div>
							<div class="allmenu-content">
								<!-- 로그인 후 -->
								<%@ include file="../common/side-profile.jsp" %>
								<div class="lnb-area">
									<ul class="lnb-list">
										<li><a href="/mypage/mypageMain" onclick="fnAccessHistory('2804')"><span><spring:message code="menu1" text="Mi página" /></span></a></li>
										<li><a href="/eval/list" onclick="fnAccessHistory('2806')"><span><spring:message code="menu3" text="Evalúate" /></span></a></li>
										<li><a href="javascript:;"><span><spring:message code="menu4" text="Certifícate" /></span></a>
											<ul>
												<li><a href="/cert/resultList" onclick="fnAccessHistory('2807')"><spring:message code="menu4-1" text="Resltandos" /></a></li>
												<li><a href="/cert/badgeList" onclick="fnAccessHistory('2808')"><spring:message code="menu4-2" text="Insignia" /></a></li>
											</ul>
										</li>
										<li><a href="/community/communityMainView" onclick="fnAccessHistory('2809')"><span><spring:message code="menu5" text="Conéctate" /></span></a></li>
										<li><a href="/education/list" onclick="fnAccessHistory('2810')"><span><spring:message code="menu6" text="Aprende" /></span></a></li>
										<li><a href="javascript:;"><span><spring:message code="menu7" text="Clic studio" /></span></a>
											<ul>
												<li><a href="/studio/resume/detail" onclick="fnAccessHistory('2811')"><spring:message code="menu7-1" text="Mi Currículo" /></a></li>
												<li><a href="/studio/portfolio/portfolioFrom" onclick="fnAccessHistory('2812')"><spring:message code="menu7-2" text="Mi Portafolio" /></a></li>
											</ul>
										</li>
									</ul>
									<div class="mt-md-6">
										<button type="button" class="btn btn-md btn-outline-gray btn-block" onclick="fnSignOut('${sessionEmail}');"><spring:message code="menu.drop3" text="cerrar sesión" /></button>
									</div>
									<!-- // 로그인 후 -->
								</div>
							</div>
						</c:when>
						<c:otherwise>
						<div class="allmenu-header">
								<div class="allmenu-util">
									<!-- 로그인 전 -->
									<ul class="util-menu">
										<li><a href="/login/login" class="btn btn-login"><spring:message code="login.loginbutton" text="Ingresar" /></a></li>
										<li><a href="/user/userForm" class="btn btn-join text-primary"><spring:message code="login.memberSave" text="Registrate Ya!" /></a></li>
									</ul>
									<!-- // 로그인 전 -->
									<button type="button" class="btn btn-allmenu-close">
										<em class="ico ico-close"></em>
										<span class="sr-only">Close</span>
									</button>
								</div>
							</div>
							<div class="allmenu-content">
								<!-- 로그인 전 -->
								<div class="lnb-area">
									<ul class="lnb-list">
										<li><a href="/login/login"><span><spring:message code="menu1" text="Mi página" /></span></a></li>
										<li><a href="/login/login"><span><spring:message code="menu3" text="Evalúate" /></span></a></li>
										<li><a href="/login/login"><span><spring:message code="menu4" text="Certifícate" /></span></a>
											<ul>
												<li><a href="javascript:;"><spring:message code="menu4-1" text="Resltandos" /></a></li>
												<li><a href="javascript:;"><spring:message code="menu4-2" text="Insignia" /></a></li>
											</ul>
										</li>
										<li><a href="/login/login"><span><spring:message code="menu5" text="Conéctate" /></span></a></li>
										<li><a href="/login/login"><span><spring:message code="menu6" text="Aprende" /></span></a></li>
										<li><a href="/login/login"><span><spring:message code="menu7" text="Clic studio" /></span></a>
											<ul>
												<li><a href="javascript:;"><spring:message code="menu7-1" text="Mi Currículo" /></a></li>
												<li><a href="javascript:;"><spring:message code="menu7-2" text="Mi Portafolio" /></a></li>
											</ul>
										</li>
									</ul>
									<!-- // 로그인 전 -->
								</div>
							</div>
						</c:otherwise>
					</c:choose>
				</div>
			</div>
		</header>
		
		
		
		<!-- 비밀번호 변경 팝업 레이어팝업 -->	
	<div class="modal-popup modal-md hide" id="layer-pwchange_header">
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
					<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-pwchange_header');"><spring:message code="button.cancel" text="cancelar"/></a>
					<button type="submit" class="btn btn-md btn-secondary" onclick="fnPwChangSave_header();"><spring:message code="button.save" text="Confirmar"/></button>
				</div>
			</div>
		</div>
	</div>

	<!-- 비밀번호 성공후 팝업  -->
	<div class="modal-popup modal-sm hide" id="layer-complete_header">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title">Envío completado</h2>
				<p class="text mt-lg-5 mt-md-2"><spring:message code="profile.message4" text=""/></p>
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="#;" class="btn btn-md btn-secondary" onclick="fnSignOut('${sessionScope.sessionEmail}');"><spring:message code="login.loginbutton" text="Ingresar"/></a>
				</div>
			</div>
		</div>
	</div>	