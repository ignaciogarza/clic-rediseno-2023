<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
	<script>
	//var madinSearchValue = "${madinSearchValue}";
	//var userId = "${userId}";
	
	var madinSearchValue = getParameterByName('madinSearchValue');
	
	
	var type = getParameterByName('type');
	var userId = getParameterByName('userId');

	
	  
	
	function getParameterByName(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
	}
	
	$(document).ready(function () {
		$("#madinSearchValues").val(madinSearchValue);
		search(1);	
		
	});
	
	/* function mainSearchs(page, type){
		var form = $("form[name=mainPagingForm]");		
	  	form.find("input[name=mainPage]").val(page);
	  	form.find("input[name=mainRows]").val(15);  
	  	form.find("input[name=madinSearchValue]").val($("#madinSearchValues").val());
	  	form.find("input[name=type]").val(type);
	  	
	  	form.attr("action", "/main/mainSearchView");
	  	form.submit();
	}  */
	
	function search(page){
		
		var searchValue = $("#madinSearchValues").val();
		
		//if(){
		//	madinSearchValue = searchValue;
		//}
		
		var data = {
				mainPage : page,
				mainRows : 15,
				madinSearchValue : searchValue,
				type : type
		};	
		
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : data,
	        url : '/main/mainSearchList',
	        success : function(response) {
	          var result = response.data;
	          
	          $("#madinSearchVal").text("'"+searchValue+"'"); 
	      	  $("#madinSearchValues").val(searchValue);
	          $("#madinSearchValue").val(searchValue);
	          
	          var userTotal = result.userTotal;
	          $("#userTotal").text("Amigo("+userTotal+")");
	          
	          var portfolioTotal = result.portfolioTotal; 
	          $("#portfolioTotal").text("Portafolio("+portfolioTotal+")"); 
	          
	          var list = result.userlist;
	          var friendCheckList = result.friendCheckList;
	          var html = '';
	          $("#mainUserForm").empty();
	          
	          if(list != null && list.length > 0){	
	        	  html += '<div class="search-result">';
        		  html += '	<div class="community-list friend-list">';
	        	  for (var i = 0; i < list.length; i++) {						
	        		  <!-- 친구 목록이 있을 경우 -->	        		 
	        		  html += '		<li>';
	        		  html += '			<a href="#;" class="item" onclick="fnPortfolioList(\''+list[i].userId+'\',	\''+list[i].name+'\', \''+list[i].firstName+'\',\''+list[i].jobNameEng+'\',\''+list[i].userImagePath+'\', \''+list[i].countryCode+'\'	)">';
	        		  html += '				<div class="profile-area">';
	        		  html += '					<div class="profile-frame">';
	        		  html += '						<div class="photo">';
	        		  html += '							<img src="'+list[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
	        		  html += '						</div>';
	        		  html += '						<div class="country">';
	        		  if(list[i].countryCode != null){
	        			  html += '							<img src="https://flagcdn.com/w640/'+list[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';								
	        		  }else{
	        			  html += '							<img src="https://flagcdn.com/w640/'+list[i].countryCode+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';								
	        		  }
	        		  								
	        		  html += '						</div>';
	        		  for (var j = 0; j < friendCheckList.length; j++) {		        		  
		        		  if(friendCheckList[j].friendId == list[i].userId){
		        			  html += '				<div class="stat"><em class="ico ico-connect"></em></div> ';
		        			  html += '				<div class="stat" id="stat_'+list[i].userId+'"><em class="ico ico-connect"></em></div> ';
		        		  }		        		
	        		  }	        		  
	        		  html += '					</div>';
	        		  html += '					<div class="profile-info">';
	        		  html += '						<span class="name">'+list[i].name+' '+ list[i].firstName+'</span>';
	        		  //html += '						<span class="career">'+list[i].jobNameEng+'</span>';
	        		  html += '					</div>';
	        		  html += '				</div>';
	        		  html += '			</a>';
	        		  html += '		</li>';	
				  }
	        	  html += '	</div>';								
        		  html += '</div>';
				  
	          }else{
	        	  html += '<div class="no-data">';
	        	  html += '<p class="main-copy">No Se Encontraron Resultados Para<br class="d-down-md"> Tu Búsqueda</p>';
	        	  html += '<p class="sub-copy">Verifique El Término De Búsqueda Que<br class="d-down-md"> Ingresó</p>';
	        	  html += '<div class="btn-group-default d-down-md">';
	        	  html += '<button type="button" class="btn btn-md btn-outline-gray">cancelar</button>';
	        	  html += '</div>';
	        	  html += '</div>	';
	          }
	          html += '</div>';
	          $("#mainUserForm").append(html);
	          
	        if(list != null && list.length > 0){	    
		        //페이징 처리 
		  		var totalPage = result.totalPage;
		  		var rows = result.rows;
		  		var page = result.page;
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
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//탭클릭시 페이지 이동 
	function fnMainSearchTabMove(type){
		var searchValue = $("#madinSearchValues").val();
		location.href= "/main/mainSearchView?mainPage=1&mainRows=15&type="+type+"&madinSearchValue="+searchValue;	
		//location.href = "/main/mainSearchView?type="+ type+"&madinSearchValue="+madinSearchValue;		
	}
	
	//포토폴리오  
	function fnPortfolioList(friendId, name, firstName, jobNameEng, userImagePath, countryCode){
		$("#fullName").text(name+" "+firstName);
		$("#popJobName").text(jobNameEng);
		
		if(userImagePath != ""){
			$("#imageLayer").attr("src", userImagePath);
		}else{
			$("#imageLayer").attr("src", "/static/assets/images/common/img-md-profile-default.png");
		}
		
		$("#countryLayer").attr("src", 'https://flagcdn.com/w640/'+countryCode.toLowerCase()+'.png');  
		
		
		var friendStatusCode = $("#stat_"+friendId).hasClass("stat");
		
		if(userId == friendId){
			$("#solicitud").hide();
		}else{
			//$("#solicitud").show();				
			//$("#solicitud").attr("onClick", "fuFriendRequest(\'"+friendId+"\')");
			
			//친구상태일태 친구요청 숨김 처리 
			$("#statFriend").hide();
			if(friendStatusCode == true){
				$("#solicitud").hide();
				$("#statFriend").show();
			}else{
				$("#solicitud").show();				
				$("#solicitud").attr("onClick", "fuFriendRequest(\'"+friendId+"\')");
			}
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
						html += '				<div class="box-portfolio"  style="min-height: 278px;">';
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
	
	
	//포토폴리오 프로젝트 화면 이동 
	function fnProjectFrom(otherUserId, otherEmail, portfolioId){
		//회원 프로젝트로 이동
		location.href = "/studio/project/portfolioOthersMemberView?otherUserId="+ otherUserId+"&otherEmail="+ otherEmail+"&portfolioId="+ portfolioId+"&type=others";		
	}
	
	
	//친구요청
	function fuFriendRequest(friendId){  
		
		var data = {
				userId : userId,
				friendId : friendId
		};	
	
		$.ajax({
			url: '/community/friendRequestSave',
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
	</script>
</head>
<body>
	<div class="wrapper">		
		<!-- header Start -->
		<jsp:include page="../common/header.jsp"></jsp:include>
		<!-- header End -->
		
		<div id="container">
			<article id="content">
				<div class="content-fixed search-wrap">
					<div class="content-header d-down-md">
						<h2 class="content-title">Buscar</h2>
						<button type="button" class="btn btn-close" onclick="window.history.back()">Close</button>
					</div>
					<div class="content-body style2">
						<p class="search-keyword d-up-lg">Resultados para<span class="text-keyword" id="madinSearchVal"></span></p>
						<div class="global-search d-down-md">
							<input type="text" class="form-control" id="madinSearchValues" value=""placeholder="search" title="search">
							<button type="button" class="btn btn-search" onclick="search('1')">Search</button>
						</div>
						<nav class="tab-menu">
							<ul class="tab-list">
								<li class="on"><a href="#;" onclick="fnMainSearchTabMove('user')" id="userTotal"></a></li>
								<li><a href="#;" onclick="fnMainSearchTabMove('portfolio')" id="portfolioTotal"></a></li>
							</ul>
						</nav>
						<div class="tab-content" id="mainUserForm">							
													
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
</body>
</html>