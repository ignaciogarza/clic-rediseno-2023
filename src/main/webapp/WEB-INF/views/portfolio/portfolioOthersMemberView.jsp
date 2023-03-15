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
	//http://localhost:8080/project/portfolioOthersMemberView?otherUserId=6571c845d7194ef38a4318ab5be71a07&otherEmail=jmh10243@naver.com&portfolioId=2&type=others&lang=en;
	//http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId=cdcbaf0732ed465d8d22981bd04a3f1f&otherEmail=l29MRUNyGNiPwFCeIjlq05RjpM8pqrq+zz4rg6vq1Wg=&portfolioId=1&type=others
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
	          $("#userJob").text(userDetail.jobNameEng);
	          
	          
	          $("#portfolioEvent").attr("onClick", "fnPortfolioList(\'"+userDetail.userId+"\',\'"+userDetail.name+"\',\'"+userDetail.firstName+"\',\'"+userDetail.jobNameEng+"\',\'"+userDetail.userImagePath+"\',\'"+userDetail.countryCode+"\')");	
	          //<span class="d-up-lg ml-lg-1" id="portfolioEvent" onclick="fnPortfolioList('${userDetail.userId}', '${userDetail.name}', '${userDetail.firstName}', '${userDetail.jobNameEng}','${userDetail.userImagePath}', '${userDetail.countryCode}')">Info</span>
	          
	          var portfolioInfo = response.data.portfolioInfo;
	          $("#portfolioImage").attr("src", portfolioInfo.backgroundImagePath);	          
	         
	          var reName = portfolioInfo.name;	        	  
        	  var newName = reName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
        	
	          $("#portfolioName").text(newName);
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
	
	
	
	//포토폴리오  
	//function fnPortfolioList(friendId, name, firstName, jobNameEng, friendStatusCode, userImagePath, countryCode){
	function fnPortfolioList(friendId, name, firstName, jobNameEng, userImagePath, countryCode){	
		$("#fullName").text(name+" "+firstName);
		$("#popJobName").text(jobNameEng);
		
		if(userImagePath != ""){
			$("#imageLayer").attr("src", userImagePath);
		}else{
			$("#imageLayer").attr("src", "/static/assets/images/common/img-md-profile-default.png");
		}
		
		$("#countryLayer").attr("src", 'https://flagcdn.com/w640/'+countryCode.toLowerCase()+'.png');
		
		$("#aceptar").hide();
		$("#rechazar").hide();
		$("#solicitud").hide();
		
		$("#statFriend").hide();
		
		/* if(friendStatusCode == '1101'){
			//$("#aceptar").show();
			//$("#rechazar").show();
		}else if(friendStatusCode == '1103'){
			$("#statFriend").show();
		}else{
			$("#solicitud").show();
		} */
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"userId" : friendId },
	        url : '/studio/portfolio/portfolioList',
	        success : function(response) {
	          var resultList = response.data;
	          //var resultList = null;
	          var html = '';
	          $("#portfolioForm").empty();
	          if(resultList != null && resultList.length > 0){
	        	    html += '<div class="portfolio-list">';
				    html += '	<ul class="list">';
				    for (var i = 0; i < resultList.length; i++) {
						//전체공개
						if(resultList[i].publicTypeCode == '1801'){
							html += '		<li>';
							html += '			<a href="#;" class="portfolio-item" onclick="fnPortfolioMemberMove(\''+otherUserId+'\',\''+otherEmail+'\',\''+resultList[i].portfolioId+'\');">';
							//html += '			<a href="#;" class="portfolio-item" onclick="fnProjectFrom(\''+resultList[i].userId+'\',\''+resultList[i].portfolioId+'\');">';
							html += '				<div class="box-portfolio" style="min-height: 278px;">';
							html += '					<div class="thumb">';
							html += '						<img src="'+resultList[i].listImagePath+'" alt="">';
							html += '					</div>';
							html += '					<div class="portfolio-info">';
							html += '						<div class="total">';
							html += '							<span class="number">'+resultList[i].projectCount+'</span>';
							html += '							<span class="title">Proyectos</span>';
							html += '						</div>';
							html += '						<div class="like">';
							html += '							<em class="ico ico-like-on"></em>';
							html += '							<span class="number">'+resultList[i].likeCount+'</span>';
							html += '						</div>';
							html += '					</div>';
							html += '				</div>';
							html += '				<p class="portfolio-title">'+resultList[i].name+'</p>';
							html += '			</a>';
							html += '		</li>';	
						}else
						//친구 일대 공개 
						if(resultList[i].friendStatusCode == '1103' && resultList[i].publicTypeCode == '1802'){
							html += '		<li>';
							html += '			<a href="#;" class="portfolio-item" onclick="fnPortfolioMemberMove(\''+otherUserId+'\',\''+otherEmail+'\',\''+resultList[i].portfolioId+'\');">';
							//html += '			<a href="#;" class="portfolio-item" onclick="fnProjectFrom(\''+resultList[i].userId+'\',\''+resultList[i].portfolioId+'\');">';
							html += '				<div class="box-portfolio" style="min-height: 278px;">';
							html += '					<div class="thumb">';
							html += '						<img src="'+resultList[i].listImagePath+'" alt="">';
							html += '					</div>';
							html += '					<div class="portfolio-info">';
							html += '						<div class="total">';
							html += '							<span class="number">'+resultList[i].projectCount+'</span>';
							html += '							<span class="title">Proyectos</span>';
							html += '						</div>';
							html += '						<div class="like">';
							html += '							<em class="ico ico-like-on"></em>';
							html += '							<span class="number">'+resultList[i].likeCount+'</span>';
							html += '						</div>';
							html += '					</div>';
							html += '				</div>';
							html += '				<p class="portfolio-title">'+resultList[i].name+'</p>';
							html += '			</a>';
							html += '		</li>';	
						}else
						
						//비공개
						if(resultList[i].publicTypeCode == '1803'){
							//$("#portfolioForm").empty();
							//html += '<div class="no-data">';
							//html += 	'<p class="text">No Hay Cartera Registrada</p>';
							//html += '</div>';
						}else{
							html += '<div class="no-data">';
							 html += 	'<p class="text">No Hay Cartera Registrada</p>';
							 html += '</div>';
						}
						
						
						
					  }
					html += '	</ul>';
					html += '</div>';
			  }else{
				  var filter = 'win16|win32|win64|mac|macintel';
					
				  if(navigator.platform) {
					if(filter.indexOf(navigator.platform.toLowerCase()) < 0 || $(window).width() < 1024) {
						 html += '<div class="no-data" style="margin-top: 196px;">';
						 html += 	'<p class="text">No Hay Cartera Registrada</p>';
						 html += '</div>';
					} else {
						 html += '<div class="no-data">';
						 html += 	'<p class="text">No Hay Cartera Registrada</p>';
						 html += '</div>';
					}
				  }
			  }
			  
	          $("#portfolioForm").append(html);
	          openModal('#layer-member');  
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	
	//포토폴리오  
	function fnPortfolioListsssss(friendId, name, firstName, jobNameEng, friendStatusCode){
		$("#fullName").text(name+" "+firstName);
		$("#popJobName").text(jobNameEng);
		
		$("#aceptar").hide();
		$("#rechazar").hide();
		$("#solicitud").hide();
		
		$("#statFriend").hide();
		
		if(friendStatusCode == '1101'){
			$("#aceptar").show();
			$("#rechazar").show();
		}else if(friendStatusCode == '1103'){
			$("#statFriend").show();
		}else{
			$("#solicitud").show();
		}
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"userId" : friendId },
	        url : '/studio/portfolio/portfolioList',
	        success : function(response) {
	          var resultList = response.data;
	          //var resultList = null;
	          var html = '';
	          $("#portfolioForm").empty();
	          if(resultList != null && resultList.length > 0){
	        	    html += '<div class="portfolio-list">';
				    html += '	<ul class="list">';
				for (var i = 0; i < resultList.length; i++) {
					html += '		<li>';
					html += '			<a href="#;" class="portfolio-item" onclick="fnProjectFrom(\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\');">';
					html += '				<div class="box-portfolio">';
					html += '					<div class="thumb">';
					html += '						<img src="'+resultList[i].listImagePath+'" alt="">';
					html += '					</div>';
					html += '					<div class="portfolio-info">';
					html += '						<div class="total">';
					html += '							<span class="number">'+resultList[i].projectCount+'</span>';
					html += '							<span class="title">Proyectos</span>';
					html += '						</div>';
					html += '						<div class="like">';
					html += '							<em class="ico ico-like-on"></em>';
					html += '							<span class="number">'+resultList[i].likeCount+'</span>';
					html += '						</div>';
					html += '					</div>';
					html += '				</div>';
					html += '				<p class="portfolio-title">'+resultList[i].name+'</p>';
					html += '			</a>';
					html += '		</li>';	
				  }
					html += '	</ul>';
					html += '</div>';
			  }else{
				  html += '<div class="no-data">';
				  html += 	'<p class="text">No Hay Cartera Registrada</p>';
				  html += '</div>';
			  }
			  
	          $("#portfolioForm").append(html);
	          openModal('#layer-member');  
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//친구 요청 승인 
	function fuApprovalFriend(friendId){
		
		var data = {
				userId : userId,
				friendId : friendId				
		};	
		
		$.ajax({
			url: '/community/approvalFriend',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				if(response.code == "SUCCESS"){					
					location.reload(); //페이지 리로딩
				}else{
					alert(response.message);
				}
			}
		});		
	}
	
	//친구 요청 거절
	function fuRejectFriend(friendId){
		
		var data = {
				userId : userId,
				friendId : friendId				
		};	
		
		$.ajax({
			url: '/community/rejectFriend',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				if(response.code == "SUCCESS"){					
					location.reload(); //페이지 리로딩
				}else{
					alert(response.message);
				}
			}
		});		
	}
	
	function fnPortfolioMemberMove(otherUserId, otherEmail, portfolioId){		
		location.href = "/studio/project/portfolioOthersMemberView?otherUserId="+ otherUserId+"&otherEmail="+otherEmail+"&portfolioId="+portfolioId+"&type=others";	
	}
	
	//포토폴리오 프로젝트 화면 이동 
	function fnProjectFrom(portfolioIds, projectIds){
		//회원 프로젝트로 이동 
		location.href= "/studio/project/portfolioOthersMemberProjectView?otherUserId="+ otherUserId+"&otherEmail="+otherEmail+"&portfolioId="+portfolioIds+"&projectId="+projectIds+"&type=others";		
	}
	</script>
</head>
<body>
	<div class="wrapper">
		<!-- header Start -->
		<jsp:include page="../common/header.jsp"></jsp:include>
		<!-- header End -->
		
		<div id="container">
			<aside id="sidebar">
				<%@ include file="../common/side-profile.jsp" %>
			</aside>
			<article id="content">
				<h2 class="sr-only"><spring:message code="menu7-2" text="Portafolio"/></h2>
				<div class="content-fixed portfolio-detail member-portfolio">
					<div class="content-header">
						<div class="inner">
							<h2 class="content-title d-down-md">Detalles de la portafolio</h2>
							<a href="#;" class="btn btn-back d-down-md">prev</a>
						</div>
					</div>
					<div class="content-body style2">
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
								<div class="community-ctrl">
									<a href="#" class="btn btn-sm btn-outline-gray btn-info" id="portfolioEvent">
										<em class="ico ico-sm-community-gray"></em>
										<%-- <span class="d-up-lg ml-lg-1" id="portfolioEvent" onclick="fnPortfolioList('${userDetail.userId}', '${userDetail.name}', '${userDetail.firstName}', '${userDetail.jobNameEng}','${userDetail.userImagePath}', '${userDetail.countryCode}')">Info</span> --%>
										<span class="d-up-lg ml-lg-1" >Info</span>
									</a>
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
									<img id="imageLayer" src="/static/assets/images/common/img-md-profile-default.png" onerror="this.src='/static/assets/images/common/img-sm-profile-default.png'" alt="">
								</div>
								<div class="country">
									<img id="countryLayer" src="/static/assets/images/common/_img-flag.png" onerror="this.src='/static/assets/images/common/_img-flag.png'" alt="">
								</div>
							</div>
							<div class="profile-info">
								<span class="name" id="fullName">Julio Cesar Torres</span>
								<!-- <span class="career" id="popJobName">Estudiante</span> -->
							</div>
						</div>
						<div class="community-ctrl">
						</div>
					</div>
				</div>
				
				<!-- 포트폴리오 view -->
				<div id="portfolioForm">
				</div>
			</div>
		</div>
	</div>
</body>
</html>