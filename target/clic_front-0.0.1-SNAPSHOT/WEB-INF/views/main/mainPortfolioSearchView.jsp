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
	<script>
	//var madinSearchValue = "${madinSearchValue}";
	//var userId = "${userId}";
	
	var madinSearchValue = getParameterByName('madinSearchValue');
	
	var type = getParameterByName('type');
	var userId = getParameterByName('userId');
	
	
	//$("#madinSearchVal").text("'"+madinSearchValue+"'");
	//$("#madinSearchValues").val(madinSearchValue);
	
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
	
	
	function search(page){
		
		var searchValue = $("#madinSearchValues").val();
		
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
	          
	          var list = result.portfoliolist;
	          var friendCheckList = result.friendCheckList;
	          var html = '';
	          $("#portfolioForm").empty();
	          
	          if(list != null && list.length > 0){	
	        	  html += '<div class="search-result">';
        		  html += '	<ul class="portfolio-list">';
	        	  for (var i = 0; i < list.length; i++) {						
	        		  <!-- 친구 목록이 있을 경우 -->
	        		  html += '		<li>';
	        		  html += '			<a href="#;" class="portfolio-item" onclick="fnPortfolioMemberMove(\''+list[i].userId+'\',\''+list[i].email+'\',\''+list[i].portfolioId+'\')">';
	        		  html += '				<div class="community-list">';
	        		  html += '					<div class="profile-area">';
	        		  html += '						<div class="profile-frame">';
	        		  html += '							<div class="photo">';																
	        		  html += '							<img src="'+list[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
	        		  html += '							</div>';
	        		  html += '							<div class="country">';
	        		  html += '							<img src="https://flagcdn.com/w640/'+list[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
	        		  html += '							</div>';
	        		  html += '						</div>';
	        		  html += '						<div class="profile-info">';
	        		  html += '							<span class="name">'+list[i].userName+' '+ list[i].firstName+'</span>';
	        		  //html += '							<span class="career">'+list[i].jobNameEng+'</span>';
	        		  html += '						</div>';
	        		  html += '					</div>';
	        		  html += '				</div>';
	        		  html += '				<div class="box-portfolio">	';												
	        		  html += '					<div class="thumb">';
	        		  html += '						<img src="'+list[i].listImagePath+'" alt="">';
	        		  html += '					</div>';
	        		  html += '					<div class="portfolio-info">';
	        		  html += '						<div class="total">';
	        		  html += '							<span class="number">'+list[i].projectCount+'</span>';
	        		  html += '							<span class="title">Proyectos</span>';
	        		  html += '						</div>';
	        		  html += '						<div class="like">';
	        		  html += '							<em class="ico ico-like-on"></em>';
	        		  html += '							<span class="number">'+list[i].likeCount+'</span>';
	        		  html += '						</div>';
	        		  html += '					</div>';
	        		  html += '				</div>';
	        		  html += '				<p class="portfolio-title">'+list[i].name+'</p>';
	        		  
	        		  
	        		  var filter = 'win16|win32|win64|mac|macintel';
						
	        		  if(navigator.platform) {
		        		  if(filter.indexOf(navigator.platform.toLowerCase()) < 0 || $(window).width() < 1024) {
		        			  html += '				<p class="hashtag" style="margin-top: 13px;">'+list[i].tag+'</p>';
		        		  } else {
		        			  html += '				<p class="hashtag" style="margin-top: -32px;">'+list[i].tag+'</p>';
		        		  }
	        		  }
	        		  
	        		  html += '			</a>';
	        		  html += '		</li>';
				  }
	        	  html += '	</ul>';						
        		  html += '</div>';
				  
	          }else{
	        	  html += '<div class="no-data">';
	        	  html += '<p class="main-copy">No Se Encontraron Resultados Para<br class="d-down-md"> Tu Búsqueda</p>';
	        	  html += '<p class="sub-copy">Verifique El Término De Búsqueda Que<br class="d-down-md"> Ingresó</p>';
	        	  html += '<div class="btn-group-default d-down-md">';
	        	  html += '<button type="button" class="btn btn-md btn-outline-gray">cancelar</button>';
	        	  html += '</div>';
	        	  html += '</div>';
	          }
	          html += '</div>';
	          $("#portfolioForm").append(html);
	          
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
	}
	
	function fnPortfolioMemberMove(otherUserId, otherEmail, portfolioId){		
		location.href = "/studio/project/portfolioOthersMemberView?otherUserId="+ otherUserId+"&otherEmail="+otherEmail+"&portfolioId="+portfolioId+"&type=others";	
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
			<input type="hidden" name="searchValue" value="${view.searchValue}"/>		
			<input type="hidden" name="type" value="${type}"/>		
		</form>	 --%>	
		
		<div id="container">
			<article id="content">
				<div class="content-fixed search-wrap">
					<div class="content-header d-down-md">
						<h2 class="content-title">Buscar</h2>
						<button type="button" class="btn btn-close" onclick="window.history.back()">Close</button>
						<p></p>
					</div>
					<div class="content-body style2">
						<p class="search-keyword d-up-lg">Resultados para<span class="text-keyword" id="madinSearchVal"></span></p>
						<div class="global-search d-down-md">
							<input type="text" class="form-control" id="madinSearchValues" value="" placeholder="search" title="search" >
							<button type="button" class="btn btn-search" onclick="search('1')">Search</button>
						</div>
						<nav class="tab-menu">
							<ul class="tab-list">
								<li><a href="#;" onclick="fnMainSearchTabMove('user')" id="userTotal"></a></li>
								<li class="on"><a href="#;" onclick="fnMainSearchTabMove('portfolio')" id="portfolioTotal"></a></li>
							</ul>
						</nav>
						<div class="tab-content" id="portfolioForm">
														
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
</body>
</html>