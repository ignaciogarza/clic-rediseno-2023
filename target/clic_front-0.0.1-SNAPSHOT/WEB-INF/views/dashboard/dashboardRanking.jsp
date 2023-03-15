<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
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
	
	<script src="/static/common/js/Chart.min.js"></script>
    <script src="/static/common/js/utils.js"></script>	
	<script src="/static/assets/js/jquery.DonutWidget.js"></script>
	<script>
	$(document).ready(function(){
		skillRankingListSetting();
	});
	
	function skillRankingListSetting(){
				 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : data,
	        url : '/dashboard/dashboardRankingList',
	        success : function(response) {		 
	        	var result = response.data;	    
	        	
	        	userId = result.userId;
		        email = result.email;
		        menuType = result.menuType;
		        
		        if(menuType == "vi"){		
		    		$("#vi").addClass("on");
		    	}else if(menuType == "en"){
		    		$("#en").addClass("on");
		    	}else if(menuType == "pr"){
		    		$("#pr").addClass("on");
		    	}else if(menuType == "ra"){
		    		$("#ra").addClass("on");
		    	}	
		        
		        //스킬 랭킹
		        var skillRankingList = response.data.skillRankingList;
				var skillRankingHtml = '';
				$("#skillRankingFrom").empty();
				for (var i = 0; i < skillRankingList.length; i++) {
					skillRankingHtml += '<li>';
					skillRankingHtml += '	<span class="name"><span class="text-ranking">'+(i+1)+'.</span>'+skillRankingList[i].title+'</span>';
					skillRankingHtml += '	<span class="number">'+addComma(skillRankingList[i].userCnt)+'</span>';
					skillRankingHtml += '</li>';
				}
				$("#skillRankingFrom").append(skillRankingHtml);
				
				//프로그래밍 랭킹
				var programRankingList = response.data.programRankingList;
				var programRankingHtml = '';
				$("#programRankingFrom").empty();
				for (var i = 0; i < programRankingList.length; i++) {
					programRankingHtml += '<li>';
					programRankingHtml += '	<span class="name"><span class="text-ranking">'+(i+1)+'.</span>'+programRankingList[i].title+'</span>';
					programRankingHtml += '	<span class="number">'+addComma(programRankingList[i].userCnt)+'</span>';
					programRankingHtml += '</li>';
				}
				$("#programRankingFrom").append(programRankingHtml);
				
				
				//언어 랭킹
				var langRankingList = response.data.langRankingList;
				var langRankingHtml = '';
				$("#langRankingFrom").empty();
				for (var i = 0; i < langRankingList.length; i++) {
					langRankingHtml += '<li>';
					langRankingHtml += '	<span class="name"><span class="text-ranking">'+(i+1)+'.</span>'+langRankingList[i].title+'</span>';
					langRankingHtml += '	<span class="number">'+addComma(langRankingList[i].userCnt)+'</span>';
					langRankingHtml += '</li>';
				}
				$("#langRankingFrom").append(langRankingHtml);
				
				
				//포토폴리오 랭킹 
				var portfolioRankingList = response.data.portfolioRankingList;
				var portfolioRankingHtml = '';
				$("#portfolioRankingFrom").empty();
				for (var i = 0; i < portfolioRankingList.length; i++) {
					portfolioRankingHtml += '<li>';
					portfolioRankingHtml += '	<span class="name"><span class="text-ranking">'+(i+1)+'.</span>'+portfolioRankingList[i].title+'</span>';
					portfolioRankingHtml += '	<span class="number"><i class="ico ico-like"></i>'+addComma(portfolioRankingList[i].userCnt)+'</span>';
					portfolioRankingHtml += '</li>';
				}
				$("#portfolioRankingFrom").append(portfolioRankingHtml);
				 
				
	       },error:function(){
	    	   alert("Failed to fetch data.");	          
	       }
	    }); 
		
	}	
	
	</script>
</head>
<body>
	<div class="wrapper gvm-wrapper gvm-login"><!-- // 정부회원 로그인시 클래스 .gvm-login 추가 (로그아웃 또는 일반회원 로그인시 클래스 삭제) -->
		
		<!-- header Start -->
		<jsp:include page="../common/dashboardHeader.jsp"></jsp:include>
		<!-- header End -->
		
		<!-- // 마크업 수정 (07.14) -->
		<div id="container">
			<article id="content">
				<h2 class="title1 mt-0 d-down-md">Ranking</h2>
				<!-- 마크업 수정 (07.14) -->
				<div class="ranking-area">
					<div class="box-ranking ranking-type1">
						<h3 class="title"><spring:message code="dashboard.text14" text="" /></h3>
						<ol class="list" id="skillRankingFrom">
											
						</ol>
					</div>
					<div class="box-ranking ranking-type2">
						<h3 class="title"><spring:message code="dashboard.text15" text="" /></h3>
						<ol class="list" id="programRankingFrom">
											
						</ol>
					</div>
					<div class="box-ranking ranking-type3">
						<h3 class="title"><spring:message code="dashboard.text16" text="" /></h3>
						<ol class="list" id="langRankingFrom">
							
						</ol>
					</div>
					<div class="box-ranking ranking-type4">
						<h3 class="title"><spring:message code="dashboard.text17" text="" /></h3>
						<ol class="list" id="portfolioRankingFrom">
									
						</ol>
					</div>
				</div>
				<!-- // 마크업 수정 (07.14) -->
			</article>
		</div>
		<!-- footer Start -->	
		<jsp:include page="../common/dashboardFooter.jsp"></jsp:include>
		<!-- footer End -->	
	</div>
</body>
</html>