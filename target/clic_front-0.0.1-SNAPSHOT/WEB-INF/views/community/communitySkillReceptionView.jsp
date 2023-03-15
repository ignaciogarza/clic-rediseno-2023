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
	<!-- 페이지 처리 css -->
	<link rel="stylesheet" href="/static/common/css/pagination.css">
	<script src="/static/assets/js/jquery-3.5.1.min.js"></script>	
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script> 	
	<script src="/static/common/js/init.js"></script>
	<!-- 페이지 개별 스크립트 -->
	<script src="/static/assets/js/jquery.DonutWidget.js"></script>
	<script>
	//var userId = "${userId}";
	var userId;;
	
	$(document).ready(function () {
		search();	
		
		$('#btn_search').click(function(){
			search(1);
		});
	});
	
	function search(page){
		
		var data = {
				page : page,
				rows : 10
		};	
		
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : data,
	        url : '/community/communitySkillReceptionList',
	        success : function(response) {
	          var resultList = response.data;
	          
	          userId = resultList.userId;
	          
	          
	          
	          //사이트 데이터 세팅 
	          var friendCount = resultList.friendCount;
	          $("#friendAll").text(friendCount.friendAll);
	          $("#friendReception").text(friendCount.friendReception);
	          $("#friendSend").text(friendCount.friendSend);
	          
	          var skillAuthCount = resultList.skillAuthCount;
	          $("#authComplete").text(skillAuthCount.authComplete);
	          $("#authSend").text(skillAuthCount.authSend);
	          $("#authReception").text(skillAuthCount.authReception);
	          
	          //메인 상단 탑 데이터 세팅 
	          $("#allTotal").text('<spring:message code="community.text11" text="Todos Los Amigos"/> ('+resultList.allTotal+')');
	          $("#allTotalDown").text(resultList.allTotal);
	          
	          $("#receptionTotal").text('<spring:message code="community.text13" text="Solicitud Recibida"/> ('+resultList.receptionTotal+')');
	          $("#receptionTotalDown").text(resultList.receptionTotal);
	          
	          $("#sendTotal").text('<spring:message code="community.text12" text="Enviar Solicitud"/> ('+resultList.sendTotal+')');
	          $("#sendTotalDown").text(resultList.sendTotal);
	          
	          
	          var list = resultList.list;
	          var friendCheckList = resultList.friendCheckList;
	          var html = '';
	          $("#skillReceptionForm").empty();
	          
	          if(list != null && list.length > 0){	
	        	  html += '<div class="community-list friend-request col1">';
	        	  for (var i = 0; i < list.length; i++) {						
	        		  <!-- 친구 목록이 있을 경우 -->	        		  
	        		  html +='	<div class="box">';
	        		  html +='		<div class="item">';
	        		  html += '			<a href="#" class="profile-area" >';
	        		  //html += '			<a href="#" class="profile-area" onclick="fnPortfolioList(\''+list[i].userId+'\',	\''+list[i].name+'\', \''+list[i].firstName+'\',\''+list[i].jobNameEng+'\',	\''+list[i].friendStatusCode+'\',\''+list[i].userImagePath+'\', \''+list[i].countryCode+'\'	)">';
	        		  html +='				<div class="profile-frame">';
	        		  html +='					<div class="photo">';
	        		  html += '							<img src="'+list[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
	        		  html +='					</div>';
	        		  html +='					<div class="country">';
	        		  html += '							<img src="https://flagcdn.com/w640/'+list[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
	        		  html +='					</div>';
	        		  for (var j = 0; j < friendCheckList.length; j++) {		        		  
		        		  if(friendCheckList[j].friendId == list[i].userId){
		        			  html += '				<div class="stat"><i class="ico ico-connect"></i></div> ';
		        		  }		        		
	        		  }
	        		  html +='				</div>';
	        		  html +='				<div class="profile-info">';
	        		  html +='					<span class="name">'+list[i].name+' '+ list[i].firstName+'</span>';
	        		  //html +='					<span class="career">'+list[i].jobNameEng+'</span>';
	        		  html +='				</div>';
	        		  html +='			</a>';
	        		  html +='			<span class="skill-name">'+list[i].skillNameEng+'</span>';
	        		  html +='			<div class="content">';													
	        		  
	        		  if(list[i].isAuth == 'R'){
	        			  html +='					<p class="text">Verifique las habilidades de su amigo</p>';
		        		  html +='					<div class="mt-2">';															
		        		  html +='						<a href="#;" class="btn btn-sm btn-secondary btn-certificate" onclick="fnCertificateMove(\''+list[i].userId+'\', \''+list[i].skillCode+'\', \''+list[i].examClassCode+'\', \''+list[i].name+'\', \''+list[i].firstName+'\', \''+list[i].jobNameEng+'\')">Certificación</a>'; 
		        		  html +='					</div>';
	        		  }else if(list[i].isAuth == 'Y'){
	        			  html +='					<p class="text">'+list[i].authContents+'</p>';
		        		  html +='					<div class="certificate-info mt-2">';
		        		  html +='						<p class="state">Verificación completada</p>';
		        		  html +='						<p class="date">'+list[i].updatedDate+'</p>';
		        		  html +='					</div>';
	        		  }
	        		  html +='			</div>';
	        		  html +='			<span class="date-info">'+list[i].authRequestDate+'</span>';
	        		  html +='		</div>';
	        		  html +='	</div>';	        		  
				  }
	        	  html += '</div>';
				  
	          }else{
	        		html += '<div class="no-data">';
	        		html += '	<p class="main-copy"><spring:message code="community.message6" text="No Hay Amigos Conectados"/></p>';
	        		html += '</div>';
	          }
	          html += '</div>';
	          $("#skillReceptionForm").append(html);
	          
	        if(list != null && list.length > 0){	    
		        //페이징 처리 
		  		var totalPage = resultList.totalPage;
		  		var rows = resultList.rows;
		  		var page = resultList.page;
		  		if(totalPage > 0 && totalPage >= page ){
		  		    $('#pagination').twbsPagination({
		  		        totalPages: totalPage,
		  		        visiblePages: 10,
		  		        startPage : page,
		  		        initiateStartPageClick: false,
		  		        first: '<a href="#" class="direction first"><span class="sr-only">first</span></a>',
		  		        prev: '<a href="#" class="direction prev"><span class="sr-only">prev</span></a>',
		  		        next: '<a href="#" class="direction next"><span class="sr-only">next</span></a>',		       
		  		        last: '<a href="#" class="direction last"><span class="sr-only">last</span></a>', 
		  		        onPageClick: function(event, page) {	  		        	
		  		        	search(page);
		  		        }
		  		    })
		  		}
	        }
	           
	       },error:function(){
	    	   alert("Failed to fetch data.");
	       }
	    }); 
	}
	
	
	//요청인증 팝업 조회 
	function fnCertificateMove(friendId,  skillCode, examClassCode, name, firstName, jobName, type){
		
		$("#userIds").val(userId);
		$("#friendIds").val(friendId);
		$("#skillCodes").val(skillCode);
		$("#examClassCodes").val(examClassCode);

		var fullName = '${sessionScope.fullName}';
		
		//$("#certificateName").text(name+" "+firstName);
		//$("#certificatejobName").text(jobName);
		
		/* if($("#"+friendId).hasClass("stat") === true) {
			$("#statCheck").show();
		}else{
			$("#statCheck").hide();
		} */
		
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {userId : friendId , skillCode : skillCode, examClassCode : examClassCode},
	        //data : {userId : "TEST" , skillCode : "0001", examClassCode : examClassCode},
	        url : '/community/getExamResult',
	        success : function(response) {
	          var result = response.data;
	          var userInfo = result.user;
	          var html = '';
	          
	          if(userInfo.userImagePath == null || userInfo.userImagePath == '') {
	          	  html += '<img src="/static/assets/images/common/img-md-profile-default.png" alt="">';
	          } else {
	        	  html += '<img src="'+userInfo.userImagePath+'" alt="" onerror="this.src=\'/static/assets/images/common/img-md-profile-default.png\';">';
		      }
	          $('div.photo.friendImage').html(html);

	          $('div.country.friendCountry').html('<img src="https://flagcdn.com/w640/'+userInfo.countryCode.toLowerCase()+'.png" alt="">');
	          $('span.name.friendName').text(userInfo.name+' '+userInfo.firstName);
	          //$('span.career.friendJob').text(userInfo.jobName);
	          $('p.test-title.skillName').text(userInfo.skillName);
	          $('p.test-title.d-down-md.skillName').text(userInfo.skillName);

	          $('div.stat').hide();
	          <c:forEach var="friendList" items="${friendCheckList}" varStatus="status">
	          	if('${friendList.friendId}' == userInfo.userId) {
	          		$('div.stat').show();
		        }
	          </c:forEach>
	          
	          var dataSkill = result.dataSkill;
	          var peerHtml = '';
		      peerHtml += '<img src="/static/assets/images/common/logo.png" style="padding-bottom: 5%" alt="">';
	  	  	  peerHtml += '<p class="text" style="font-size: 20px; font-weight: 800; text-align: center;"><spring:message code="mypage.text13" text="Hello" /> '+fullName+'</p><br/>';
		  	  peerHtml += '<p class="text" style="font-size: 20px; font-weight: 800; padding-bottom: 15px; text-align: center;"><spring:message code="mypage.text14" text="Please validate my skill" /></p>';
		  	  peerHtml += '<p class="text" style="font-size: 30px; font-weight: 800; color: #004e70; padding-bottom: 15px; text-align: center;">"'+userInfo.skillName+'"</p>';
		  	  peerHtml += '<p class="text" style="font-size: 20px; font-weight: 800; text-align: center;"><spring:message code="mypage.text15" text="Thank you!" /></p><br/>';
		  	  peerHtml += '<p class="text" style="font-size: 20px; font-weight: 800; text-align: center;">'+userInfo.name+' '+userInfo.firstName+'</p>';
		  	  $('#testContents').html(peerHtml);
		  	  
	         openModal('#layer-certificate');  
	       },error:function(){
	    	   alert("Failed to fetch data.");
	       }
	    }); 
	}
	
	//인증완료
	function fuCompleteSkillAuth(){	
		
		var userId = $("#userIds").val();
		var friendId = $("#friendIds").val();
		var skillCode = $("#skillCodes").val();
		var authContents = $("#authContents").val();
		var examClassCode = $("#examClassCodes").val();
		
		var data = {
				userId : userId,
				friendId : friendId,
				skillCode : skillCode,
				authContents : authContents,
				examClassCode : examClassCode
		};
	
		$.ajax({
			url: '/community/completeSkillFriendAuth',
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
	
	//인증거부
	function fuCompleteSkillDel(){	
		//T_SKILL_FRIEND_AUTH 테이블 IS_AUTH 값 N으로 처리 
		var userId = $("#userIds").val();
		var friendId = $("#friendIds").val();
		var skillCode = $("#skillCodes").val();
		var authContents = $("#authContents").val();
		var examClassCode = $("#examClassCodes").val();
		
		var data = {				
				userId : friendId,
				friendId : userId,
				skillCode : skillCode,
				authContents : authContents,
				examClassCode : examClassCode
		};
		if(confirm('<spring:message code="complete.alert.msg1" text="인증을 거절하시겠습니까?"/>')) {
			$.ajax({
				url: '/community/completeSkillDel',
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
	}
	
	//포토폴리오  
	function fnPortfolioList(friendId, name, firstName, jobNameEng, friendStatusCode, userImagePath, countryCode){
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
		
		if(friendStatusCode == '1101'){
			//$("#aceptar").show();
			//$("#rechazar").show();
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
						//전체공개
						if(resultList[i].publicTypeCode == '1801'){
							html += '		<li>';
							html += '			<a href="#;" class="portfolio-item" onclick="fnProjectFrom(\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\');">';
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
							html += '							<i class="ico ico-like-on"></i>';
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
							html += '			<a href="#;" class="portfolio-item" onclick="fnProjectFrom(\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\');">';
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
							html += '							<i class="ico ico-like-on"></i>';
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
					if(filter.indexOf(navigator.platform.toLowerCase()) < 0) {
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
	    	   alert("Failed to fetch data.");
	       }
	    }); 
	}
	
	
	//포토폴리오 프로젝트 화면 이동 
	function fnProjectFrom(otherUserId, otherEmail, portfolioId){
		//회원 프로젝트로 이동
		location.href = "/studio/project/portfolioOthersMemberView?otherUserId="+ otherUserId+"&otherEmail="+ otherEmail+"&portfolioId="+ portfolioId+"&type=others";		
	}	
	</script>
</head>
<body>
	<div class="wrapper">
		<!-- header Start -->
		<jsp:include page="../common/header.jsp"></jsp:include>
		<!-- header End -->
		
		<%-- <form name="pagingForm" method="GET" action="">
			<input type="hidden" name="page" value="${view.page}"/>
			<input type="hidden" name="rows" value="${view.rows}"/>					
		</form>	 --%>
		
		<div id="container">
			<aside id="sidebar">
				<%@ include file="../common/side-profile.jsp" %>
				
				<dl class="total-info">
					<dt class="title">
						<em class="ico ico-sm-community"></em>
						<spring:message code="community.text17" text="Información de amigo"/> 
					</dt>
					<dd class="content">
						<dl class="item">
							<dt><a href="/community/communityFriendAllView" ><spring:message code="community.text7" text="Todos los amigos"/></a></dt>
							<dd id="friendAll"></dd><!-- // 집계 수 없을 경우 클래스 .no-data 추가 -->
						</dl>
						<dl class="item">
							<dt><a href="/community/communityFriendReceptionView"><spring:message code="community.text8" text="Solicitud recibida"/></a></dt>
							<dd id="friendReception"></dd>
						</dl>
						<dl class="item">
							<dt><a href="/community/communityFriendSendView"><spring:message code="community.text9" text="Enviar solicitud"/></a></dt>
							<dd id="friendSend"></dd>
						</dl>
					</dd>
					<dt class="title">
						<em class="ico ico-sm-skill"></em>
						<spring:message code="community.text2" text="Validaciones"/>   
					</dt>
					<dd class="content">
						<dl class="item">
							<dt><a href="/community/communitySkillAllView"><spring:message code="community.text11" text="Completo"/></a></dt>
							<dd id="authComplete"></dd>
						</dl>
						<dl class="item">
							<dt><a href="/community/communitySkillSendView"><spring:message code="community.text12" text="Recibió"/></a></dt>
							<dd id="authSend"></dd>
						</dl>
						<dl class="item">
							<dt><a href="/community/communitySkillReceptionView"><spring:message code="community.text13" text="Enviado"/></a></dt>
							<dd id="authReception"></dd>
						</dl>
					</dd>
				</dl>
			</aside>
			<article id="content">
				<h2 class="content-title"><spring:message code="menu5" text=""/></h2>
				<div class="content-fixed community-total">
					<div class="content-header">
						<div class="inner">
							<h2 class="content-title d-down-md">Validaciones</h2>
							<a href="#;" class="btn btn-back">prev</a>
						</div>
					</div>
					<div class="content-body style2">
						<nav class="tab-menu">
							<ul class="tab-list">
								<li>
									<a href="/community/communitySkillAllView">
										<span class="d-up-lg" id="allTotal"></span>
										<span class="d-down-md" id="allTotalDown"><span class="text"><spring:message code="community.text11" text="Verificación Completada"/></span></span>
									</a>
								</li>
								<li>
									<a href="/community/communitySkillSendView">
										<span class="d-up-lg" id="sendTotal"></span>
										<span class="d-down-md" id="sendTotalDown"><span class="text"><spring:message code="community.text12" text="Autenticación Enviada"/></span></span>
									</a>
								</li>
								<li class="on">
									<a href="/community/communitySkillReceptionView">
										<span class="d-up-lg" id="receptionTotal"></span>
										<span class="d-down-md" id="receptionTotalDown"><span class="text"><spring:message code="community.text13" text="Certificación Recibida"/></span></span>
									</a>
								</li>
							</ul>
						</nav>
						<div class="tab-content" id="skillReceptionForm">							
							
						</div>
						<div id="pagination">
        
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
									<img id="imageLayer" src="/static/assets/images/common/img-md-profile-default.png" onerror="this.src='/static/assets/images/common/img-sm-profile-default.png'" alt="">
								</div>
								<div class="country">
									<img id="countryLayer" src="/static/assets/images/common/_img-flag.png" onerror="this.src='/static/assets/images/common/_img-flag.png'" alt="">
								</div>
								<div class="stat" id="statFriend" style="display:none">
									<em class="ico ico-connect"></em>
								</div>
							</div>
							<div class="profile-info">
								<span class="name" id="fullName">Julio Cesar Torres</span>
								<!-- <span class="career" id="popJobName">Estudiante</span> -->
							</div>
						</div>
						<div class="community-ctrl">
							<!-- 친구요청 받은 경우 -->
							<button type="button" id="aceptar" style="display:none" class="btn btn-sm btn-secondary btn-approve">Aceptar amigo</button>
							<button type="button" id="rechazar" style="display:none" class="btn btn-sm btn-primary btn-cancle">rechazar</button>
							<!-- // 친구요청 받은 경우 -->
							<!-- 친구가 아닐 경우 -->							
							<button type="button" id="solicitud" style="display:none" class="btn btn-sm btn-secondary btn-add">Solicitud de amistad</button>
							
							<!-- // 친구가 아닐 경우 -->
						</div>
					</div>
				</div>
				
				<!-- 포트폴리오 view -->
				<div id="portfolioForm">
				</div>
			</div>
		</div>
	</div>

	<div class="modal-popup modal-lg hide" id="layer-certificate">
		<div class="dimed"></div>
		<div class="popup-inner popup-certificate">
			<div class="popup-header d-down-md">
				<h2 class="popup-title">Certificación</h2>
				<button type="button" class="btn btn-close-popup" onclick="closeModal('#layer-certificate');">Close</button>
			</div>
			<div class="popup-body">
				<div class="community-list">
					<div class="item">
						<div class="profile-area">
							<div class="profile-frame">
								<div class="photo friendImage">
									<img src="/static/assets/images/common/img-md-profile-default.png" alt="">
								</div>
								<div class="country friendCountry">
									<img src="/static/assets/images/common/_img-flag.png" alt="">
								</div>
								<div class="stat" id="statCheck" style="display:none">
									<em class="ico ico-connect"></em>
								</div>
							</div>
							<div class="profile-info">
								<span class="name friendName" >Julio Cesar Torres</span>
								<!-- <span class="career friendJob" >Estudiante</span> -->
								
								
							</div>
						</div>
						<div class="community-ctrl d-up-lg">
							<p class="test-title skillName">DIGITAL BASIC</p>
						</div>
					</div>
				</div>
				<div class="test-result custom-scroll">
					<p class="test-title d-down-md skillName">DIGITAL BASIC</p>
					
					<div id="testContents"></div>

				</div>
				
				<div class="form-item">
					<input type="hidden" id="userIds" />
					<input type="hidden" id="friendIds"/>
					<input type="hidden" id="skillCodes"/>
					<input type="hidden" id="examClassCodes"/>
					<textarea cols="30" rows="3" class="form-control full" id="authContents"><spring:message code="community.message10" text=""/></textarea>
				</div>
				<div class="btn-group-default btn-fixed">
					<a href="#;" class="btn btn-md btn-gray d-up-lg" onclick="closeModal('#layer-certificate');">cancelar</a>
					<button type="button" class="btn btn-md btn-primary" onclick="fuCompleteSkillDel()">Negación</button>
					<button type="button" class="btn btn-md btn-secondary" onclick="fuCompleteSkillAuth()">Certificación</button>
					
				</div>
				
			</div>
		</div>
	</div>
</body>
</html>