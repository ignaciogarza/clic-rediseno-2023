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
	//var otherUserId = "${otherUserId}";
	//var projectId = "${projectId}";
	
	
	var otherUserId = getParameterByNames('otherUserId');
	var portfolioId = getParameterByNames('portfolioId');
	var projectId = getParameterByNames('projectId');
	var otherEmail = getParameterByNames('otherEmail');
	var type = getParameterByNames('type');
	
	function getParameterByNames(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1]); 
	}
	
	
	//http://localhost:8080/project/portfolioOthersMemberProjectView?otherUserId=6571c845d7194ef38a4318ab5be71a07&otherEmail=jmh10243@naver.com&projectId=19
	$(document).ready(function () {
		getList();
		//fnProjectContentsList(projectId);
	});
	
	function getList(){
		
		var data ={
				otherUserId : otherUserId,
				portfolioId : portfolioId,
				projectId : projectId,
				otherEmail :otherEmail,
				type : type
		};
		 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : data,
	        url : '/studio/project/portfolioOthersMemberProjectList',
	        success : function(response) {
	        	
	          userId = response.data.userId;	
	          likeStatus = response.data.likeStatus;
	        	
	          var userDetail = response.data.userDetail;
	          $("#userImage").attr("src", userDetail.userImagePath);
	          $("#userCountry").attr("src", "https://flagcdn.com/w640/"+userDetail.countryCode.toLowerCase()+".png");
	          $("#userName").text(userDetail.name+" "+userDetail.firstName);
	          $("#userJob").text(userDetail.jobNameEng);
	        
	          
	          var projectInfo = response.data.projectInfo;	             
	          $("#projectName").text(projectInfo.name);	        
	          
	          var reIntroduction = projectInfo.introduction;
        	  var newIntroduction = reIntroduction.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
	          
	          $("#projectIntro").text(newIntroduction);
	          
	          
	          $("#likeCount").text(projectInfo.likeCount); 
	          
	          fnProjectContentsList(projectId);
	  		
	          
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	    
		
	}
	
	//프로젝트 리스트 생성
	function fnProjectContentsList(projectIds){
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"userId" : otherUserId, "projectId" : projectId },
	        url : '/studio/project/projectContentsList',
	        success : function(response) {
	          var resultList = response.data.projectList;
	          
	          var html = '';
	          var html_image = '';
	          var html_video = '';
	          var html_audio = '';
	          var html_document = '';
	          var html_badge = '';	          
	          
	          $("#ContentView_image").empty();  
			  $("#ContentView_video").empty();  
			  $("#ContentView_audio").empty();  
			  $("#ContentView_documentos").empty();  
			  $("#ContentView_badge").empty(); 
	          if(resultList != null && resultList.length > 0){
	        	
				for (var i = 0; i < resultList.length; i++) {
					
					//html += '		<a href="#;" class="thumb-area" onclick="fnProjectFrom(\''+resultList[i].portfolioId+'\',\''+resultList[i].projectId+'\');">';
					if(resultList[i].contentsTypeCode == "1901"){
						html_image += '<li>';
						html_image += '	<a href="#" class="thumb" target="_blank" onclick="fnProjectImageView(\''+otherUserId+'\')">';
						//html_image += '	<a href="CLIC_F_PTO_6200.html" class="thumb" target="_blank">';
						html_image += '		<img src="'+resultList[i].contentsPath+'" alt="">';
						html_image += '	</a>';
						html_image += '	<a href="#;" class="info-area">';
						html_image += '		<span class="title">'+resultList[i].contentsName+'</span>';
						html_image += '		<span class="date">'+resultList[i].updatedDate+'</span>';
						html_image += '	</a>';
						html_image += '</li>';
						$("#imageView").show();
					}else if(resultList[i].contentsTypeCode == "1903"){
						//// 비디오 
						html_video += '<li>';
						html_video += '	<div class="thumb">';
						html_video += '		<iframe src="'+resultList[i].contentsUrl+'" title="YouTube video player" style="width: 100%; height: 100%; border:0; margin:0; padding:0;" allowfullscreen></iframe>';
						html_video += '	</div>';
						html_video += '	<a href="#;" class="info-area">';
						html_video += '		<span class="title">'+resultList[i].contentsName+'</span>';
						html_video += '		<span class="date">'+resultList[i].updatedDate+'</span>';
						html_video += '	</a>';
						html_video += '</li>';
						$("#videosView").show();
					}else if(resultList[i].contentsTypeCode == "1906"){
						////  오디오
						html_audio += '<li>';
						html_audio += '	<div class="thumb">';
						html_audio += '		<iframe src="'+resultList[i].contentsUrl+'"  style="width: 100%; height: 100%; border:0; margin:0; padding:0;"></iframe>';
						html_audio += '	</div>';
						html_audio += '	<a href="#;" class="info-area">';
						html_audio += '		<span class="title">'+resultList[i].contentsName+'</span>';
						html_audio += '		<span class="date">'+resultList[i].updatedDate+'</span>';
						html_audio += '	</a>';
						html_audio += '</li>';
						$("#audioView").show();
					}else if(resultList[i].contentsTypeCode == "1904"){
						///////문서
						html_document += '<li>';
						//html_document += '	<a href="#;" class="box box-document">';
						html_document += '	<a class="box box-document" href="'+resultList[i].contentsPath+'" download>';
						html_document += '		<div class="info-area">';
						html_document += '			<span class="title">'+resultList[i].contentsName+'</span>';
						html_document += '			<span class="date">'+resultList[i].updatedDate+'</span>';
						html_document += '		</div>';
						html_document += '	</a>';
						html_document += '</li>';
						$("#documentosView").show();
					}else if(resultList[i].contentsTypeCode == "1907"){
						//뱃지
						html_badge += '<li>';
						html_badge += '	<div class="box box-badge">';
						html_badge += '		<div class="image-area">';
						html_badge += '			<img src="'+resultList[i].contentsPath+'" alt="">';
						html_badge += '		</div>';
						html_badge += '		<span class="name">'+resultList[i].contentsName+'</span>';
						html_badge += '	</div>';
						html_badge += '</li>';
						$("#badgeView").show();
					}			 
				}				   
			  }			 
			  $("#ContentView_image").append(html_image);  
			  $("#ContentView_video").append(html_video);  
			  $("#ContentView_audio").append(html_audio);  
			  $("#ContentView_documentos").append(html_document);  
			  $("#ContentView_badge").append(html_badge);  
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//컨텐츠 이미지 화면 이동 
	function fnProjectImageView(otherUserIds){
		location.href= "/studio/project/projectContentsOutImageFrom?otherUserId="+otherUserIds+"&projectId="+projectId;		
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
				<div class="project-detail member-project">
					<div class="member-info">
						<div class="community-list">
							<div class="item">
								<div class="profile-area">
									<div class="profile-frame">
										<div class="photo">
											<img id="userImage" src="${list.userImagePath}" onerror="this.src='/static/assets/images/common/img-sm-profile-default.png'" alt="">
										</div>
										<div class="country">
											<img id="userCountry" src="https://flagcdn.com/w640/<c:out value='${fn:toLowerCase(list.countryCode)}'/>.png" onerror="this.src='/static/assets/images/common/_img-flag.png'"alt="">
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
						<div class="info-area">
							<span class="name" STATUS>${projectInfo.name}</span>
							<div class="content">
								<p id="projectIntro" style="white-space: pre-line;">${projectInfo.introduction}</p>
							</div>
							<div class="like">
								<em class="ico ico-like-on-lg"></em>
								<span class="number" id="likeCount">${projectInfo.likeCount}</span>
							</div>
						</div>
					</div>

					<div class="project-form mt-lg-10">
						<div class="item" id="imageView" style="display:none">
							<h3 class="title1 mt-0"><spring:message code="portfolio.text25" text="Imagenes"/></h3>
							<ul class="thumbnail-list thumb-image" id="ContentView_image">
								
							</ul>
						</div>
						<div class="item" id="videosView" style="display:none">
							<h3 class="title1 mt-0"><spring:message code="portfolio.text27" text="Videos"/></h3>
							<ul class="thumbnail-list thumb-video" id="ContentView_video">
								
							</ul>
						</div>
						<div class="item" id="audioView" style="display:none">
							<h3 class="title1 mt-0"><spring:message code="portfolio.text31" text="Audio"/></h3>
							<ul class="thumbnail-list thumb-audio" id="ContentView_audio">
								
							</ul>
						</div>
						<div class="item" id="documentosView" style="display:none">
							<h3 class="title1 mt-0"><spring:message code="portfolio.text29" text="Documentos"/></h3>
							<ul class="document-list" id="ContentView_documentos">
								
							</ul>
						</div>
						<div class="item" id="badgeView" style="display:none">
							<h3 class="title1 mt-0"><spring:message code="mypage.skill3" text="Insignia"/></h3>
							<ul class="mybadge-list" id="ContentView_badge">
								
							</ul>
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