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
	<script>
	$(document).ready(function(){
		getList()
	});
	
	function getList(){
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        url : '/dashboard/dashboardSurveyList',
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
		        
		        var list = result.resultList;
		        var html = '';
		        $("#surveyForm").empty();
		        if(list != null && list.length > 0){			        	  
	        	  for (var i = 0; i < list.length; i++) {
	        		  html += '	<div class="box-survey">';					
	        		  html += '		<h3 class="title">';
	        		  //html += '			<a href="/dashboard/dashboardSurveyDetailView?questionId='+list[i].questionId+'" link-disabled="mobile"><span class="number">'+list[i].questionNumber+'</span>'+list[i].questionTitleEng+'</a>';
	        		  html += '			<a href="/dashboard/dashboardSurveyDetailView?questionId='+list[i].questionId+'" link-disabled="mobile"><span class="number">'+(i+1)+'</span>'+list[i].questionTitleEng+'</a>';
	        		  html += '		</h3>';
	        		  html += '		<ul class="list">';
	        		  var exampleList = list[i].exampleList;
	        		  for (var j = 0; j < exampleList.length; j++) {
	        		  html += '				<li>';
	        		  html += '					<span class="response">'+exampleList[j].exampleTitleEng+'</span>';
	        		  html += '					<div class="info-area">';
	        		  html += '						<div class="bar">';
	        		  html += '							<span class="fill" style="width: '+exampleList[j].answerRate+'%;"></span>';
	        		  html += '						</div>';
	        		  html += '						<div class="figure">';
	        		  html += '							<span class="ratio">'+exampleList[j].answerRate+'%</span>';
	        		  html += '							<span class="number"><i class="ico ico-respondents"></i>'+exampleList[j].answerCnt+'</span>';
	        		  html += '						</div>';
	        		  html += '					</div>';
	        		  html += '				</li>';
	        		  }
	        		  html += '		</ul>';
	        		  html += '	</div>';
				  }
					  
		        }
		        $("#surveyForm").append(html);
				
			 
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
		
		<div id="container">
			<article id="content">
				<h2 class="title1 mt-0 d-down-md">Encuesta sobre el entorno de las TIC</h2>
				<div class="survey-area" id="surveyForm">
					
				</div>
			</article>
		</div>
		
		<!-- footer Start -->	
		<jsp:include page="../common/dashboardFooter.jsp"></jsp:include>
		<!-- footer End -->	
	</div>
</body>
</html>