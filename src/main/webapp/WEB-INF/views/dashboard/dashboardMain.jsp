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
	
	<script src="/static/common/js/Chart.min.js"></script>
    <script src="/static/common/js/utils.js"></script>	
	<script src="/static/assets/js/jquery.DonutWidget.js"></script>
	<!-- 페이지 개별 스크립트 -->
	<script>
    $(document).ready(function(){
        
        //오늘 날짜 세팅 
        var date = new Date();
        var year = date.getFullYear();        
        var monthNames = ["January", "February", "March", "April", "May", "June",
              "July", "August", "September", "October", "November", "December"
            ];
        var month = monthNames[date.getMonth()];        
        var day = date.getDate();        
        $("#nowDate").text(month+" "+day+", "+year);
        
        getList();
    });
    
    function fnOverviewMenuMove(){    
        location.href= "/dashboard/dashboardOverview";
    }	
    
    
  //조회
	function getList(cityText){
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        url : '/dashboard/dashboardMainList',
	        success : function(response) {
		        var result = response.data;		    
		        
		        userId = result.userId;
		        email = result.email;
	        	 
				//회원
				$("#userCnt").text(addComma(result.userCnt));    
				  
				//테스트응시
				$("#skillStcTotalCnt").text(addComma(result.skillStcTotalCnt)); 
				  
				//테스트통과
				$("#skillStcPassCnt").text(addComma(result.skillStcPassCnt)); 
				//$("#aprobarNumber").text("100000"); 
				  
				//이력서
				$("#resumeCnt").text(addComma(result.resumeCnt)); 
				  
				//포트폴리오
				$("#portfolioCnt").text(addComma(result.portfolioCnt)); 				  
				
			 
	       },error:function(){
	    	   alert("Failed to fetch data.");	          
	       }
	    }); 
	}	
		
	</script>
</head>
<body>
	<div class="wrapper gvm-wrapper"><!-- // 정부회원 로그인시 클래스 .gvm-login 추가 (로그아웃 또는 일반회원 로그인시 클래스 삭제) -->
		
		<!-- header Start -->
		<jsp:include page="../common/dashboardHeader.jsp"></jsp:include>
		<!-- header End -->
		
		<div id="container">
			<article id="content">
				<div class="dashboard-main">
					<div class="map-area">
						<div class="map-inner">
							<!-- 지도 영역 -->
							<img src="/static/assets/images/content/img-map-world.png" class="d-up-lg" alt="">
							<img src="/static/assets/images/content/img-map-world@2x.png" class="d-down-md" alt="">
							<!-- // 지도 영역 -->
							<!-- 위치 포인트 -->
							<div class="location-tooltip">
								<span class="tooltip tooltip-colombia">Colombia</span>
							</div>
							<!-- // 위치 포인트 -->
						</div>

						<!-- 마크업 수정 (07.14) -->
						<div class="use-state">
							<span class="country">Colombia</span>
							<%-- <span class="date" id="nowDate">January ${totalAllCount}</span> --%>
							<span class="date" id="nowDate"></span>
							<div class="state-list">
								<dl class="item">
									<dt><spring:message code="dashboard.text1" text="Inscripciones en Clic" /></dt>
									<dd id="userCnt"></dd>
								</dl>
								<dl class="item">
									<dt><spring:message code="dashboard.text2" text="Intentos de hacer las prueba" /></dt>
									<dd id="skillStcTotalCnt"></dd>
								</dl>
								
								<dl class="item">
									<dt><spring:message code="dashboard.text4" text="Pruebas aprobadas" /></dt>
									<dd id="skillStcPassCnt"></dd>
								</dl>
								
								<dl class="item">
									<dt><spring:message code="dashboard.text6" text="Currículums" /></dt>
									<dd id="resumeCnt"></dd>
								</dl>
								<dl class="item">
									<dt><spring:message code="dashboard.text7" text="Portafolios" /></dt>
									<dd id="portfolioCnt"></dd>
								</dl>
							</div>
							<div class="btn-area">
								<button type="button" class="btn btn-sm btn-secondary" onclick="fnOverviewMenuMove()"><spring:message code="dashboard.text8" text="Overview" /></button>

							</div>
						</div>
						<!-- // 마크업 수정 (07.14) -->
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