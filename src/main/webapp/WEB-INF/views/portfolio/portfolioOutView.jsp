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
	
	<!-- BEGIN FACEBOOK -->
	<meta property="og:type" content="website" />
	<meta property="og:url" content="" />
	<meta property="og:title" content="Clic" >
	<meta property="og:description" content="Clic" >
	<meta property="og:image" content="/static/assets/images/common/logo3.png" >
	<!-- END FACEBOOK -->	
	
	<!-- BEGIN TWITTERCARD -->
	<meta name="twitter:card" content="summary_large_image">	
	<meta name="twitter:url" content="" />
	<meta name="twitter:title" content="Clic" >
	<meta name="twitter:description" content="Clic" >
	<meta name="twitter:image" content="/static/assets/images/common/logo3.png" >
	<!-- END TWITTERCARD -->
	
	
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
		//http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId=cdcbaf0732ed465d8d22981bd04a3f1f&otherEmail=l29MRUNyGNiPwFCeIjlq05RjpM8pqrq+zz4rg6vq1Wg=&portfolioId=1&type=out&lang=en;
		//var otherUserId = "${otherUserId}";
		//var otherEmail = "${otherEmail}";

		var otherUserId = getParameterByNames('otherUserId');
		var otherEmail = getParameterByNames('otherEmail');
		var portfolioId = getParameterByNames('portfolioId');
		var type = getParameterByNames('type');
		
		function getParameterByNames(name) { 
			name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
			var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
			results = regex.exec(location.search); 
			//return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
			return results == null ? "" : decodeURIComponent(results[1]); 
		}
		
		$(document).ready(function () { 
			getList();
		});

		function getList(){
			
			var data ={
					otherUserId : otherUserId,
					portfolioId : portfolioId,
					otherEmail :otherEmail,
					type : type
			};
			 
		    $.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : data,
		        url : '/studio/project/portfolioOthersMemberList',
		        success : function(response) {
		        	
		          var userDetail = response.data.userDetail;
		          $("#userImage").attr("src", userDetail.userImagePath);
		          $("#userCountry").attr("src", "https://flagcdn.com/w640/"+userDetail.countryCode.toLowerCase()+".png");
		          $("#userName").text(userDetail.name+" "+userDetail.firstName);
		          
		          if(userDetail.language == "en"){
		        	  $("#userJob").text(userDetail.jobNameEng); 
		          }else{
		        	  $("#userJob").text(userDetail.jobNameSpa); 
		          }
		          
		          
		          //$("#portfolioEvent").attr("onClick", "fnPortfolioUpdate(\'"+userDetail.userId+"\',\'"+userDetail.name+"\',\'"+userDetail.firstName+"\',\'"+userDetail.jobNameEng+"\',\'"+userDetail.userImagePath+"\',\'"+userDetail.countryCode+"\')");	
		          //<span class="d-up-lg ml-lg-1" id="portfolioEvent" onclick="fnPortfolioList('${userDetail.userId}', '${userDetail.name}', '${userDetail.firstName}', '${userDetail.jobNameEng}','${userDetail.userImagePath}', '${userDetail.countryCode}')">Info</span>
		          
		          var portfolioInfo = response.data.portfolioInfo;
		          $("#portfolioImage").attr("src", portfolioInfo.backgroundImagePath);	          
		          $("#portfolioName").text(portfolioInfo.name);
		          $("#portfolioTag").text(portfolioInfo.tag);
		          
		          var reIntroduction = portfolioInfo.introduction;
	        	  var newIntroduction = reIntroduction.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
		          	          
		          $("#portfolioIntro").text(newIntroduction);
		          
		          var projectList = response.data.projectList;
		          $("#projectForm").empty();
		          var html = '';
		          if(projectList != null && projectList.length > 0){
						for (var i = 0; i < projectList.length; i++) { 
							html += '	<li>';
							html += '		<div class="project-item">';
							html += '			<a href="#" onclick="fnProjectFrom(\''+projectList[i].portfolioId+'\',\''+projectList[i].projectId+'\');">';
							html += '				<span class="thumb-area">';
							html += '					<span class="thumb">';
							html += '						<img src="'+projectList[i].imagPath+'" alt="">';
							html += '					</span>';
							html += '				</span>';
							html += '				<span class="info-area">';
							html += '					<span class="name">'+projectList[i].name+'</span>';
							html += '					<div class="like">';
							html += '						<em class="ico ico-like-on-lg"></em>';
							html += '						<span class="number">'+projectList[i].likeCount+'</span>';
							html += '					</div>';
							html += '				</span>';
							html += '			</a>';
							html += '		</div>';
							html += '	</li>';				
						  }				   
					  }	
				  $("#projectForm").append(html); 
		       },error:function(){
		          alert("데이터를 가져오는데 실패하였습니다.");
		       }
		    }); 
		}
		
		//포토폴리오 프로젝트 화면 이동 
		function fnProjectFrom(portfolioIds, projectIds){
			//회원 프로젝트로 이동 
			//location.href= "/project/portfolioOthersMemberProjectView?otherUserId="+ otherUserId+"&otherEmail="+otherEmail+"&projectId="+projectIds+"&type=out";
			location.href= "/studio/project/portfolioOthersMemberProjectView?otherUserId="+ otherUserId+"&otherEmail="+otherEmail+"&portfolioId="+portfolioIds+"&projectId="+projectIds+"&type=out";		
		}
	</script>
</head>
<body>
	<div class="wrapper no-member">
		<header id="header">
			<div class="header-top">
				<div class="inner">
					<h1 id="logo">
						<a href="#;">Clic</a>
					</h1>
					<div class="util-area">
						<div class="util-menu">
							<a href="/login/login" class="btn btn-login"><em class="ico ico-login"></em>Ingresar</a>
							<a href="/user/userForm" class="btn btn-sm btn-primary btn-join">Registrate Ya!</a>							
						</div>
					</div>
				</div>
			</div>
		</header>
		<div id="container">
			<article id="content" class="pt-lg-0">
				<h2 class="sr-only"><spring:message code="menu7-2" text="Portafolio"/></h2>
				<div class="portfolio-detail member-portfolio">
					<div class="member-info">
						<div class="community-list">
							<div class="item">
								<div class="profile-area">
									<div class="profile-frame">
										<div class="photo">
											<img id="userImage" src="${userDetail.userImagePath}" onerror="this.src='/static/assets/images/common/img-sm-profile-default.png'" alt="">
										</div>
										<div class="country">
											<img id="userCountry" src="https://flagcdn.com/w640/<c:out value='${fn:toLowerCase(userDetail.countryCode)}'/>.png" onerror="this.src='/static/assets/images/common/_img-flag.png'"alt="">
										</div>
									</div>
									<div class="profile-info">
										<span class="name" id="userName">${userDetail.name} ${userDetail.firstName}</span>
										<%-- <span class="career" id="userJob">${userDetail.jobNameEng}</span> --%>
									</div>
								</div>
							</div>
						</div>
					</div>

					<div class="portfolio-detail-info">
						<div class="bg-image">
							<img id="portfolioImage" src="${portfolioInfo.backgroundImagePath}" alt="">
						</div>
						<div class="info-area">
							<span class="name" id="portfolioName">${portfolioInfo.name}</span>
							<span class="hashtag" id="portfolioTag">${portfolioInfo.tag}</span>
							<div class="content">
								<p id="portfolioIntro" style="white-space: pre-line;">${portfolioInfo.introduction}</p>
							</div>
						</div>
					</div>

					<ul class="project-list mt-md-4" id="projectForm">
						<%-- <c:forEach var="list" items="${projectList}" varStatus="status">	
							<li>
								<div class="project-item">									
									<a href="#" onclick="fnProjectFrom('${list.portfolioId}', '${list.projectId}');">
										<span class="thumb-area">
											<span class="thumb">
												<img src="${list.imagPath}" alt="">
											</span>
										</span>
										<span class="info-area">
											<span class="name">${list.name}</span>
											<div class="like">
												<i class="ico ico-like-on-lg"></i>
												<span class="number">${list.likeCount}</span>
											</div>
										</span>
									</a>
								</div>
							</li>	  
						</c:forEach> --%>						
					</ul>
				</div>
			</article>
		</div>
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->
	</div>

	<!-- 레이어팝업 -->
	<div class="modal-popup modal-lg hide" id="layer-member">
		<div class="dimed"></div>
		<div class="popup-inner popup-member">
			<div class="popup-header">
				<h2 class="popup-title d-down-md">Detalles de amigo</h2>
				<button type="button" class="btn btn-close-popup" onclick="closeModal('#layer-member');">Close</button>
			</div>
			<div class="popup-body">
				<div class="community-list">
					<div class="item">
						<div class="profile-area">
							<div class="profile-frame">
								<div class="photo">
									<img src="/static/assets/images/common/img-md-profile-default.png" alt="">
								</div>
								<div class="country">
									<img src="/static/assets/images/common/_img-flag.png" alt="">
								</div>
								<div class="stat">
									<em class="ico ico-connect"></em>
								</div>
							</div>
							<div class="profile-info">
								<span class="name">Julio Cesar Torres</span>
								<span class="career">Estudiante</span>
							</div>
						</div>
						<div class="community-ctrl">
							<!-- 친구요청 받은 경우 -->
							<button type="button" class="btn btn-sm btn-secondary btn-approve">Aceptar amigo</button>
							<button type="button" class="btn btn-sm btn-primary btn-cancle">rechazar</button>
							<!-- // 친구요청 받은 경우 -->
						</div>
					</div>
				</div>
				<!-- 포트폴리오가 있을 경우 -->
				<div class="portfolio-list">
					<ul class="list">
						<li>
							<a href="#;" class="portfolio-item">
								<div class="box-portfolio">
									<div class="thumb">
										<img src="/static/assets/images/content/_img-lg-badge.png" alt="">
									</div>
									<div class="portfolio-info">
										<div class="total">
											<span class="number">2</span>
											<span class="title">Proyectos</span>
										</div>
										<div class="like">
											<em class="ico ico-like-on"></em>
											<span class="number">123</span>
										</div>
									</div>
								</div>
								<p class="portfolio-title">Diseño De Aplicaciones</p>
							</a>
						</li>
						<li>
							<a href="#;" class="portfolio-item">
								<div class="box-portfolio">
									<div class="thumb">
										<img src="/static/assets/images/content/_img-lg-badge.png" alt="">
									</div>
									<div class="portfolio-info">
										<div class="total">
											<span class="number">2</span>
											<span class="title">Proyectos</span>
										</div>
										<div class="like">
											<em class="ico ico-like-on"></em>
											<span class="number">123</span>
										</div>
									</div>
								</div>
								<p class="portfolio-title">Diseño De Aplicaciones</p>
							</a>
						</li>
					</ul>
				</div>
				<!-- // 포트폴리오가 있을 경우 -->
			</div>
		</div>
	</div>
</body>
</html>