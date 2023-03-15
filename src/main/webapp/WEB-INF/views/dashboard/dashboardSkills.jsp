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
		getList()
	});
	
	function getList(){
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        url : '/dashboard/dashboardSkillsList',
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
		        
		        var list = result.skillReportList;
		        var html = '';
		        $("#skillReportForm").empty();
		        if(list != null && list.length > 0){			        	  
	        	  for (var i = 0; i < list.length; i++) {	        		 
	        		  html += '<tr>';		
	        		  html += '		<th scope="row"><a href="/dashboard/dashboardSkillsDetailView?skillCode='+list[i].skillCode+'&examClassCode='+list[i].examClassCode+'" link-disabled="mobile">'+list[i].skillCodeNm+'</a></th>';
	        		  html += '		<td>';
	        		  html += '			<span class="title">Todos los examinados</span>';
	        		  html += '			<span class="number">'+addComma(list[i].totalUserCnt)+'</span>	';	
	        		  html += '		<td>';
	        		  html += '			<span class="title">Auto evaluación</span>';
	        		  html += '			<span class="number">'+addComma(list[i].selfUserCnt)+'</span>	';	
	        		  html += '		</td>';
	        		  html += '		<td>';
	        		  html += '			<span class="title">Prueba de habilidad</span>';
	        		  html += '			<span class="number">'+addComma(list[i].skillUserCnt)+'</span>	';	
	        		  html += '		</td>';
	        		  html += '		<td>';
	        		  html += '			<span class="title">Aprobar el examen</span>';
	        		  html += '			<span class="number">'+addComma(list[i].passUserCnt)+'</span>	';	
	        		  html += '		</td>';
	        		  html += '</tr>';	
				  }
					  
		        }
		        $("#skillReportForm").append(html);
				
			 
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
				<h2 class="title1 mt-0 d-down-md">Prueba de habilidades</h2>
				<div class="test-state">
					<div class="table-wrap">
						<table class="table table-list">
							<caption class="sr-only">Prueba de habilidades</caption>
							<colgroup>
								<col>
								<col span="3" style="width:200px">
								<col style="width:230px">
							</colgroup>
							<thead>
								<tr>
									<th scope="col"><spring:message code="dashboard.text26" text="Nombre de la tecnología" /></th>
									<th scope="col"><spring:message code="dashboard.text20" text="Todos los examinados" /></th>
									<th scope="col"><spring:message code="dashboard.text21" text="Todos los examinados" /></th>
									<th scope="col"><spring:message code="dashboard.text28" text="Performance-Based" /></th>
									<th scope="col"><spring:message code="dashboard.text4" text="Pruebas aprobadas" /></th>
								</tr>
							</thead>
							<tbody id="skillReportForm">
														
							</tbody>
						</table>
					</div>
				</div>
			</article>
		</div>
		
		<!-- footer Start -->	
		<jsp:include page="../common/dashboardFooter.jsp"></jsp:include>
		<!-- footer End -->	
	</div>
</body>
</html>