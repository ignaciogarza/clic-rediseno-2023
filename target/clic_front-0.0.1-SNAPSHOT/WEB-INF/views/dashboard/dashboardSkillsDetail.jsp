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
	<script>
	var skillCode = getParameterByNames('skillCode');
	var examClassCode = getParameterByNames('examClassCode');
	
	function getParameterByNames(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
	}
	
		$(document).ready(function(){
			initMarker();
			
			$("#skillCode").val(skillCode);
	        $("#examClassCode").val(examClassCode);
			
			skillReportListSetting(skillCode, examClassCode);
			//스킬 코드 세팅 
			//var skillText = $("#skillCode_${skillCode} a").text();
			//$("#skillText").text(skillText);
			
			 getList();
		});
		
		
		function skillReportListSetting(skillCode, examClassCode){
					
			
			var data = {
					skillCode : skillCode	,
					examClassCode : examClassCode
			};
			 
		    $.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : data,
		        url : '/dashboard/dashboardSkillsDetailViewList',
		        success : function(response) {
			        var resultList = response.data.skillReportList;
			        
			        var skillCodes = response.data.skillCode;
			        var examClassCodes = response.data.examClassCode;
			        //$("#skillCode").val(skillCodes);
			        //$("#examClassCode").val(examClassCodes);
			       
					var selectHtml = '';
					$("#selectForm").empty();
					for (var i = 0; i < resultList.length; i++) {
						selectHtml += '<li class="on" data-skillcodenm="'+resultList[i].skillCodeNm+'" data-examclasscode="'+resultList[i].examClassCode+'" value="'+resultList[i].skillCode+'" onclick="searchSkillList(this);" id="skillCode_'+resultList[i].skillCode+'"><a href="#;" onclick="textSkillValue(this);" >'+resultList[i].skillCodeNm+'</a></li>';	
					}
					$("#selectForm").append(selectHtml);
					
					var skillText = $("#skillCode_"+skillCode+" a").text();
					$("#skillText").text(skillText);
					
		       },error:function(){
		    	   alert("Failed to fetch data.");		          
		       }
		    }); 
			
		}
		
		//설문문항 제목
		function textSkillValue(value) {
			var code = $(value).text();
			$("#skillText").text(code);
		}

		//설문 문항 검색
		function searchSkillList(value) {
			var skillCode = $(value).val();			
			$("#skillCode").val(skillCode);
			
			
			var examClassCode =  $(value).data("examclasscode");
			$("#examClassCode").val(examClassCode);
			
			getList();
		}
		
		//제목
		function textCodeValue(value) {
			var code = $(value).text();
			$("#searchText").text(code);
		}

		//셀러트박스 검색
		function searchList(value) {
			var searchType = $(value).val();			
			$("#searchType").val(searchType);
			console.log(searchType);
			//page = 1; //1로 초기화
			//getList(page, skillCode, examClassCode);
			getList();
		}
		
		//상단 탭 클릭 
		function fnTabMenuClick(type){
			$("#examinados").removeClass("on");
			$("#reported").removeClass("on");
			$("#based").removeClass("on");
			$("#aprobadas").removeClass("on");
			
			
			$("#tabMenuVal").val(type);
			
			if(type == "T"){
				$("#examinados").addClass("on");
			}else if(type == "S"){
				$("#reported").addClass("on");
			}else if(type == "B"){
				$("#based").addClass("on");
			}else if(type == "A"){
				$("#aprobadas").addClass("on");
			}
			//alert($("#searchType").val());
			getList();
		}
		

		var currentPath = null;

		// 마커초기설정
		function initMarker(){
			$('#map-color').find('path').each(function(){
				$(this).click(function(){
					var path = $(this).attr('id');
					var text = $('[data-path="' + $(this).attr('id') + '"]').attr('id'); 
					var top = $('[data-path="' + $(this).attr('id') + '"]').data('top');
					var left = $('[data-path="' + $(this).attr('id') + '"]').data('left');
					showMarker(path, text, top, left);
				});

				$('[data-path="' + $(this).attr('id') + '"]').click(function(){
					var path = $(this).data('path');
					var text = $(this).attr('id'); 
					var top = $(this).data('top');
					var left = $(this).data('left');
					showMarker(path, text, top, left);
				});
			});	
		}

		// 마커표시
		function showMarker(path, text, top, left){
			if(currentPath==path){
				clearMarker();
			} else {
				$('.location-tooltip').show().css({top: top, left: left});
				$('.location-tooltip > .tooltip').text(text.replace(/_/gi, ' '));
				currentPath = path;
				getList(text);
			}
		}

		// 마커제거
		function clearMarker(){
			$('.location-tooltip').hide();
			currentPath = null;
			
			$("#cityId").val("");	
			getList();
		}
		
		var language;
		//조회
		function getList(cityText){
			//도시값 세팅 
			if(cityText != undefined){
				citySetting(cityText);
			}
			
			var searchDate = $("#searchType").val();
			var tabMenuVal = $("#tabMenuVal").val();
			var cityId = $("#cityId").val();
			var skillCode = $("#skillCode").val();
			var examClassCode = $("#examClassCode").val();
			
			var data = {
					searchDate : searchDate,
					tabMenuVal : tabMenuVal,
					cityId : cityId,					
					skillCode : skillCode,
					examClassCode : examClassCode
			};
			 
		    $.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : data,
		        url : '/dashboard/dashboardSkillsDetailList',
		        success : function(response) {
			        var result = response.data;	  
			        
			        userId = result.userId;
			        email = result.email;
			        menuType = result.menuType;
			        
			        language = result.language;
			        
			        if(menuType == "vi"){		
			    		$("#vi").addClass("on");
			    	}else if(menuType == "en"){
			    		$("#en").addClass("on");
			    	}else if(menuType == "pr"){
			    		$("#pr").addClass("on");
			    	}else if(menuType == "ra"){
			    		$("#ra").addClass("on");
			    	}	
			        
			        
			      	//전체응시
					$("#examinadosNumber").text(addComma(result.totalCnt));    
					  
					//자기평가
					$("#reportedNumber").text(addComma(result.selfCnt)); 
					  
					//기술테스트
					$("#basedNumber").text(addComma(result.skillCnt)); 
					//$("#basedNumber").text("100000"); 
					  
					//테스트 통과 
					$("#aprobadasNumber").text(addComma(result.passCnt)); 
		        	 
					$("#_1_100 path").addClass("cls-none");
		    		$("#_101_1000 path").addClass("cls-none");
		    		$("#_1001_10000 path").addClass("cls-none");	
					//도시 리스트 세팅   
					cityListSetting(result.cityDateList);  
					  
			        //성별그래프
					fnGeneroChart(result.sexDateList);
					  
					//연령 그래프
					fnEnvejecerChart(result.ageDateList);				
					
					//교육수전
					fnEducacionChart(result.educationDateList);
					
					
					//업무경력 그래프
					fnExperienciaChart(result.taskDateList);
					
					//직업상황 그래프 
					fnSectoresChart(result.jobDateList);
				 
		       },error:function(){
		    	   alert("Failed to fetch data.");		          
		       }
		    }); 
		}
		
		//도시 리스트 세팅 
		function cityListSetting(cityDateList){
			//var cityId;
			//var cityId = $("#"+cityText).data("path");
			if(cityDateList.length > 0){
				for (var i = 0; i < cityDateList.length; i++) {
					if(cityDateList[i].cityId != ""){
						$("#"+cityDateList[i].cityId).removeClass();
						/* 0 : 클래스 .cls-none
						1~100 : 클래스 .cls-group1
						101~1000 :  클래스 .cls-group2
						1001~10000 :  클래스 .cls-group3 */
			    		if(cityDateList[i].value == 0){     
			    			//시티 아이디 로 	    			
			    			$("#"+cityDateList[i].cityId).addClass("cls-none");
			    		}
						if(cityDateList[i].value > 0 ){
			    			$("#"+cityDateList[i].cityId).addClass("cls-group1");
			    		}
						if(cityDateList[i].value > 100){
			    			$("#"+cityDateList[i].cityId).addClass("cls-group2");
			    		}
						if(cityDateList[i].value > 1000){
			    			$("#"+cityDateList[i].cityId).addClass("cls-group3");
			    		}
					}
		    	}
			}else{
				$("#_1_100 path").addClass("cls-none");
	    		$("#_101_1000 path").addClass("cls-none");
	    		$("#_1001_10000 path").addClass("cls-none");	
			}
		}
		
		//도시값 세팅 
		function citySetting(cityText){
			var cityId = $("#"+cityText).data("path");
			$("#cityId").val(cityId);	
		}
		
		
		function fnMobileCityId(cityId){
			$("#cityId").val(cityId);	
		}
		
		//성별경력 그래프  
		function fnGeneroChart(sexDateList){		
			//alert("데이터를 가져오는데 실패하였습니다.");
	    	/* const n1 = 5000; 
	    	$("#hombres").text(n1.toString().replace(/\B(?<!\.\d*)(?=(\d{3})+(?!\d))/g, ","));
	    	$("#mujer").text("21");
	    	$("#etc").text("13"); */
	    	
	    	var data=[];
	    	$("#hombres").text("0");
    		$("#mujer").text("0");
    		$("#nosex").text("0");
    		$("#etc").text("0");
	    	for (var i = 0; i < sexDateList.length; i++) {	    		
	    		data.push(sexDateList[i].value);
	    			    		
	    		if(sexDateList[i].minor == "0301"){                           
	    			$("#hombres").text(addComma(sexDateList[i].value));
	    		}else if(sexDateList[i].minor == "0302"){
	    			$("#mujer").text(addComma(sexDateList[i].value));
	    		}else if(sexDateList[i].minor == "0303"){
	    			$("#nosex").text(addComma(sexDateList[i].value));
	    		}else if(sexDateList[i].minor == "0399"){
	    			$("#etc").text(addComma(sexDateList[i].value));
	    		}
	    	}
	    	
	    	
	    	//var test = new Set(data);	    	
	    	//alert(test);
	    	  
	    	var color = Chart.helpers.color;
	        var dataSetting= [];
      	  	dataSetting.push(
      			 {               
		  	        data: data , // 해당 데이터셋의 데이터 리스트
		  	        backgroundColor: [ "#537bc4", "#e65441", "#25cdb3" , "#ffde5a" ]
		  	     }		 
      	  	);
	                   
		          
      	   if(language == "en"){    	  		
  	  		 var ChartData = { 
  		          	labels: ['Male', 'Female', 'Others', 'ETC'], // 챠트의 항목명 설정
  		        	datasets: dataSetting	   
  		        };
	      	}else{
	      		var ChartData = { 
	    	          	labels: ['Hombres', 'Mujer', 'Others', 'ETC'], // 챠트의 항목명 설정
	    	        	datasets: dataSetting	   
	    	        };
	      	} 
	        
	        if(window.myChart != undefined){
	        	window.myChart.destroy();
	        }
	        
        	var ctx = $("#Genero_Canvas")[0].getContext('2d');
        	window.myChart = new Chart(ctx, {	      
	        //window.myHorizontalBar = new Chart(ctx, {
	              // type 을 변경하면 선차트, 가로막대차트, 세로막대차트 등을 선택할 수 있습니다 
	              // ex) horizontalBar, line, bar, pie, bubble
	              type: 'pie', 
	              data: ChartData,
	              options: {
	                  responsive: true,                    
	                  maintainAspectRatio: false   ,
	                  legend: {
	                  	display: false
	                  },
	                  hover: {
	                	    mode: true
	                	  },	                
	              }
	        });
	        
	        
	        
	        
	        //myChart.destroy();
	        //myChart.clear();
	        //$("#test111").html("데이터가 없습니다.");
		}
		
		//교육수준 그래프  Educacion_Canvas
		function fnEducacionChart(educationDateList){		
		  //alert("데이터를 가져오는데 실패하였습니다.");
		  
		  var data = [];
		  var label = [];
		  var html = '';	
		  var backgroundColor = [ "#FF6384", "#36A2EB", "#FFCE56", "#4dc9f6", "#f67019", "#f53794", "#537bc4", "#acc236"	];
		  //var colorCode = "#" + Math.floor(Math.random() * 16777215).toString(16);
		  $("#educationView").empty(html);  
    	  for (var i = 0; i < educationDateList.length; i++) {	    		
    		data.push(educationDateList[i].value);
    		label.push(educationDateList[i].label);
    		
    		html += '<li>';
    		html += '<span class="name"><span class="marker" style="background-color: '+backgroundColor[i]+';"></span>'+educationDateList[i].label+'</span>';
    		html += '<span class="number">'+addComma(educationDateList[i].value)+'</span>';
    		//html += '<span class="number">110,000</span>';
    		html += '</li>';
    		
    	  }
    	  $("#educationView").append(html); 
	    			  
	      var color = Chart.helpers.color;
	      var dataSetting= [];
      	  dataSetting.push(
      			 {			  	                         
		  	          //data: [30, 83, 300, 45, 10, 450, 800, 65, 150] , // 해당 데이터셋의 데이터 리스트  8ro
		  	          //backgroundColor: color
		  	          data: data,
		  	          backgroundColor: backgroundColor
		  	         	//backgroundColor: [ "#FF6384", "#36A2EB", "#FFCE56", "#4dc9f6", "#f67019", "#f53794", "#537bc4", "#acc236", "#166a8f"	]
		  	      }		 
      	  );
	                   
		          
	      var ChartData = {            
	       	  //labels: ['Ninguno', 'Primaria', 'Media', 'Secundaria', 'Tecnica', 'Universitaria', 'Maestria', 'Doctorado', 'Otro'], // 챠트의 항목명 설정
	          labels : label,
	          datasets: dataSetting	   
	      };
	      
	      if(window.myHorizontalBar != undefined){
	        	window.myHorizontalBar.destroy();
	        }
	   
          //window.onload = function() {
          //var ctx = document.getElementById('canvas').getContext('2d');
          var ctx = $("#Educacion_Canvas")[0].getContext('2d');
          //ctx.destroy();
          window.myHorizontalBar = new Chart(ctx, {
              // type 을 변경하면 선차트, 가로막대차트, 세로막대차트 등을 선택할 수 있습니다 
              // ex) horizontalBar, line, bar, pie, bubble
              type: 'doughnut', 
              data: ChartData,
              options: {
                  responsive: true,                    
                  maintainAspectRatio: false   ,
                  legend: {
                  	display: false
                  },
                  /* tooltips: {
                  	callbacks: {
                    	label: function(tooltipItem) {
                      console.log(tooltipItem)
                      	return tooltipItem.yLabel;
                      }
                    }
                  } */
              }
          }); 
       }
		
		//업무경력 그래프   
		function fnExperienciaChart(taskDateList){		
			
			  var data = [];
	    	  var labels = [];
	    	  for (var i = 0; i < taskDateList.length; i++) {	    		
	    		  data.push(taskDateList[i].value);
	    		  labels.push(taskDateList[i].label);	    		
	    	  }
			
	    	  var color = Chart.helpers.color;
	          var dataSetting= [];
        	  dataSetting.push(
        			 {
		  	                //label: 'portfolio1',  // 데이터셑의 이름                
		  	                pointRadius: 5, // 꼭지점의 원크기
		  	                pointHoverRadius: 10, // 꼭지점에 마우스 오버시 원크기   
		  	                backgroundColor: color(window.chartColors.red).alpha(0.5).rgbString(), // 챠트의 백그라운드 색상
		  	                borderColor: window.chartColors.red, // 챠트의 테두리 색상
		  	                borderWidth: 1, // 챠트의 테두리 굵기
		  	                //lineTension:0, // 챠트의 유연성( 클수록 곡선에 가깝게 표시됨)
		  	                fill:false,  // 선챠트의 경우 하단 부분에 색상을 채울지 여부                  
		  	                //data: [18,21,13,44,35,26,54,17,32,23,22,35,0]  // 해당 데이터셋의 데이터 리스트
		  	                //data: [18,1,13,44,35,26,54]  // 해당 데이터셋의 데이터 리스트
		  	              	data: data
		  	          }		 
        	  );
		                   
			          
	          var ChartData = {            
	        	  //labels: ['0', '~6M', '+6M', '+1Y', '+2Y', '+3Y', '+4Y', '+5Y', '+6Y'], // 챠트의 항목명 설정
	        	  labels: ['0', '-1Y', '1~3Y', '3~5Y', '+5Y'], // 챠트의 항목명 설정
	              //labels : labels,
	              datasets: dataSetting	   
	          };
	          
	          if(window.myHorizontalBar1 != undefined){
		        	window.myHorizontalBar1.destroy();
		        }
	   
	          //window.onload = function() {
	          //var ctx = document.getElementById('canvas').getContext('2d');
	          var ctx = $("#Experiencia_Canvas")[0].getContext('2d');
	          //ctx.destroy();
	          window.myHorizontalBar1 = new Chart(ctx, {
	              // type 을 변경하면 선차트, 가로막대차트, 세로막대차트 등을 선택할 수 있습니다 
	              // ex) horizontalBar, line, bar, pie, bubble
	              type: 'bar', 
	              data: ChartData,
	              options: {
	                  responsive: true,                    
	                  maintainAspectRatio: false   ,
	                  legend: {
	                  	display: false
	                  },
	                  scales: {
		      				yAxes: [{
		      					ticks: {
		      						beginAtZero: true
		      						//fontSize : 14,
		      					}
		      				}]
		      		  },
	                  tooltips: {
	                  	callbacks: {
	                    	label: function(tooltipItem) {
	                      console.log(tooltipItem)
	                      	return tooltipItem.yLabel;
	                      }
	                    }
	                  }
	              }
	          }); 
		}
		
		
		
		//연령 열람 그래프   https://doolyit.tistory.com/225    https://yeahvely.tistory.com/6
		function fnEnvejecerChart(ageDateList){		
			  //alert("데이터를 가져오는데 실패하였습니다.");
	    	var data = [];
	    	var labels = [];
	    	for (var i = 0; i < ageDateList.length; i++) {	    		
	    		data.push(ageDateList[i].value);
	    		labels.push(ageDateList[i].label);	    		
	    	} 
	    	
			var color = Chart.helpers.color;
	        var dataSetting= [];
        	dataSetting.push(
        			 {
		  	                //label: 'portfolio1',  // 데이터셑의 이름                
		  	                pointRadius: 5, // 꼭지점의 원크기
		  	                pointHoverRadius: 10, // 꼭지점에 마우스 오버시 원크기   
		  	                backgroundColor: color(window.chartColors.green).alpha(0.5).rgbString(), // 챠트의 백그라운드 색상				  	             	
		  	                borderColor: window.chartColors.green, // 챠트의 테두리 색상
		  	                borderWidth: 1, // 챠트의 테두리 굵기
		  	                //lineTension:0, // 챠트의 유연성( 클수록 곡선에 가깝게 표시됨)
		  	                fill:false,  // 선챠트의 경우 하단 부분에 색상을 채울지 여부                  
		  	                //data: [18,21,13,44,35,26]  // 해당 데이터셋의 데이터 리스트
		  	                data : data
		  	                //data: [18,1,13,44,35,26,54]  // 해당 데이터셋의 데이터 리스트		  	              	
		  	            }		 
        	  );
	                   
		          
	          var ChartData = {            
	              //labels: ['10s', '20s', '30s', '40s', '50s', '60s'], // 챠트의 항목명 설정
	              labels : labels,
	              datasets: dataSetting	   
	          };
	          
	          if(window.myHorizontalBar2 != undefined){
		        	window.myHorizontalBar2.destroy();
		        }
	          
	          //window.onload = function() {
	          //var ctx = document.getElementById('canvas').getContext('2d');
	          //$("#educationView").empty(html);  
	          var ctx = $("#Envejecer_Canvas")[0].getContext('2d');
	          //ctx.destroy();
	          window.myHorizontalBar2 = new Chart(ctx, {
	              // type 을 변경하면 선차트, 가로막대차트, 세로막대차트 등을 선택할 수 있습니다 
	              // ex) horizontalBar, line, bar, pie, bubble
	              type: 'bar', 
	              data: ChartData,
	              options: {
	                  responsive: true,                    
	                  maintainAspectRatio: false  ,  
	                  legend: {
	                  	display: false
	                  },
	                  scales: {
	      				yAxes: [{
	      					ticks: {
	      						beginAtZero: true
	      						//fontSize : 14,
	      					}
	      				}]
	      			  },
	                  tooltips: {
	                  	callbacks: {
	                    	label: function(tooltipItem) {
	                         console.log(tooltipItem)
	                      	 return tooltipItem.yLabel;
	                      }
	                    }
	                  }
	                  
	              }
	          }); 
		}
		        
		        
		//직업상황 그래프   https://doolyit.tistory.com/225    https://yeahvely.tistory.com/6 Sectores_Canvas
		function fnSectoresChart(jobDateList){		
			  var data = [];
		      var labels = [];
		      
		      var html = '';
		      var backgroundColor = [ "#4dd291", "#25cdb3", "#79defc", "#065687", "#8f1c53", "#cc4968",
					"#e65441", "#fc892c", "#ffde5a", "#4dc9f6", "#f67019", "#f53794", "#FF6384" ];
			  $("#jobNameView").empty(html);  
		      for (var i = 0; i < jobDateList.length; i++) {	    		
		      	  data.push(jobDateList[i].value);
		      	  labels.push('');			    	  
		    	  
		    	  html += '<li>';
		    	  html += '<span class="name">';
		    	  html += '<span class="marker" style="background-color: '+backgroundColor[i]+';"></span>'+jobDateList[i].label
		    	  html += '</span>';
		    	  html += '</li>';	
		      }   
		      $("#jobNameView").append(html); 
			
			//alert("데이터를 가져오는데 실패하였습니다.");
	    	  var color = Chart.helpers.color;
	          var dataSetting= [];
        	  dataSetting.push(
        			 {
		  	                //label: 'portfolio1',  // 데이터셑의 이름                
		  	                pointRadius: 5, // 꼭지점의 원크기
		  	                pointHoverRadius: 10, // 꼭지점에 마우스 오버시 원크기   
		  	                //backgroundColor: color(window.chartColors.green).alpha(0.5).rgbString(), // 챠트의 백그라운드 색상
		  	                //borderColor: window.chartColors.green, // 챠트의 테두리 색상
		  	              	//backgroundColor: [ "#4dd291", "#25cdb3", "#79defc", "#065687", "#8f1c53", "#cc4968",
		  	              	//					"#e65441", "#fc892c", "#ffde5a", "#4dc9f6", "#f67019", "#f53794", "#FF6384" ],	
		  	              	backgroundColor: backgroundColor,
		  	              	borderWidth: 1, // 챠트의 테두리 굵기
		  	                //lineTension:0, // 챠트의 유연성( 클수록 곡선에 가깝게 표시됨)
		  	                fill:false,  // 선챠트의 경우 하단 부분에 색상을 채울지 여부                  
		  	                //data: [18,21,13,44,35,26,50,17,32,23,22,35,15]  // 해당 데이터셋의 데이터 리스트
		  	                data : data
		  	            }		 
        	  );
	                   
		          
	          var ChartData = {            
	              //labels: ['', '', '', '', '', '', '', '', '', '', '', '', ''], // 챠트의 항목명 설정
	              labels : labels,
	              datasets: dataSetting	   
	          };
	          
	          if(window.myHorizontalBar3 != undefined){
		        	window.myHorizontalBar3.destroy();
		        }
	   
	          var ctx = $("#Sectores_Canvas")[0].getContext('2d');
	          window.myHorizontalBar3 = new Chart(ctx, {
	              // type 을 변경하면 선차트, 가로막대차트, 세로막대차트 등을 선택할 수 있습니다 
	              // ex) horizontalBar, line, bar, pie, bubble
	              type: 'bar', 
	              data: ChartData,
	              options: {
	                  responsive: true,                    
	                  maintainAspectRatio: false  ,  
	                  legend: {
	                  	display: false
	                  },
	                  scales: {
		      				yAxes: [{
		      					ticks: {
		      						beginAtZero: true
		      						//fontSize : 14,
		      					}
		      				}]
		      		  },
	                  tooltips: {
	                  	callbacks: {
	                    	label: function(tooltipItem) {
	                      console.log(tooltipItem)
	                      	return tooltipItem.yLabel;
	                      }
	                    }
	                  }
	                  
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
				<div class="gv-area skills-area">
					<div class="gv-ctrl d-up-lg">
						<div class="gv-ctrl-inner">
							<div class="left">
								<dl class="dropdown dropdown-gv">
									<input type="hidden" id="skillCode" value="">
									<input type="hidden" id="examClassCode" value="">
									<dt><a href="#;" class="btn" id="skillText">MENTALIDAD DE CRECIMIENTO</a></dt>
									<dd>
										<div class="dropdown-inner custom-scroll" style="max-height: 364px;">
											<ul class="dropdown-list" id="selectForm">
												<%-- <c:forEach var="item" items="${skillReportList}" varStatus="status">													
													<li class="on" data-skillcodenm="${item.skillCodeNm}" value="${item.skillCode}" onclick="searchSkillList(this);" id="skillCode_${item.skillCode}"><a href="#;" onclick="textSkillValue(this);" data-examclasscode="${item.examClassCode}">${item.skillCodeNm}</a></li>
												</c:forEach> --%>												
											</ul>
										</div>
									</dd>
								</dl>
							</div>
							<div class="right">
								<a href="/dashboard/dashboardSkillsView" class="btn btn-list">Lista</a>
							</div>
						</div>
					</div>
					<div class="gv-setting">
						<div class="country">
							<div class="country-name d-up-lg">
								<span>Colombia</span>
								
							</div>
							<dl class="dropdown-select dropdown-select-country d-down-md">
								<dt><a href="#;" class="btn">Colombia, Valle del Cauca</a></dt>
								<dd style="bottom: -498px;">
									<div class="dimed"></div>
									<div class="dropdown-inner" style="height: 498px;">
										<span class="dropdown-title">Configuración de país y región</span>
										<div class="country-area">
											<ul class="country-list">
												<li class="on"><a href="#region-content1">Colombia</a></li>												
											</ul>
											<div class="region-content" id="region-content1">
												<ul class="region-list">
													<li class="on"><a href="#;" onclick="fnMobileCityId('0001')">Guajira</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0002')">Cesar</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0003')">Magdalena</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0004')">Atlántico</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0005')">Norte de</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0006')">Bolívar</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0007')">Sucre</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0008')">Córdoba</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0009')">Chocó</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0010')">Antioquia</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0011')">Santander</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0012')">Arauca</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0013')">Casanare</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0014')">Boyaca</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0015')">Cundinamarca</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0016')">Caldas</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0017')">Risaralda</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0018')">Quindío</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0019')">Valle del</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0020')">Tolima</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0021')">Bogota</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0022')">Meta</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0023')">Cauca</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0024')">Nariño</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0025')">Putumayo</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0026')">Huila</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0027')">Caqueta</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0028')">Guaviare</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0029')">Vaupes</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0030')">Amazonas</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0031')">Guainia</a></li>
													<li><a href="#;" onclick="fnMobileCityId('0032')">Vichada</a></li>
												</ul>
											</div>											
										</div>
										<div class="btn-area">
											<button type="button" class="btn btn-lg btn-secondary" onclick="getList()">Confirmar</button>
										</div>
									</div>
								</dd>
							</dl>
						</div>
						<div class="period mt-md-2">
							<input type="hidden" id="searchType" value="0">
							<dl class="dropdown-select">
								<dt><a href="#;" class="btn" id="searchText"><spring:message code="dashboard.text22" text="" /></a></dt>
								<dd style="bottom: -258px;">
									<div class="dimed"></div>
									<div class="dropdown-inner custom-scroll" style="height: 258px;">
										<span class="dropdown-title">Período</span>
										<ul class="dropdown-list">
											<li value="0" onclick="searchList(this);"><a href="#;" onclick="textCodeValue(this);"><spring:message code="dashboard.text22" text="" /></a></li><!-- // 선택된 항목 클래스 .on 추가 -->
											<li value="7" onclick="searchList(this);"><a href="#;"  onclick="textCodeValue(this);"><spring:message code="dashboard.text23" text="최근7일" /></a></li>
											<li value="1" onclick="searchList(this);"><a href="#;"  onclick="textCodeValue(this);"><spring:message code="dashboard.text24" text="최근1개월" /></a></li>
											<li value="3" onclick="searchList(this);"><a href="#;"  onclick="textCodeValue(this);"><spring:message code="dashboard.text25" text="최근3개월" /></a></li>
										</ul>
									</div>
								</dd>
							</dl>
						</div>
					</div>
					<nav class="tab-menu">
						<!-- 마크업 수정 (07.14) -->
						<ul class="tab-list">
							<input type="hidden" id="tabMenuVal" value="T">
							<li class="on" id="examinados">
								<a href="#;" onclick="fnTabMenuClick('T')">
									<div class="info-area">
										<span class="title"><spring:message code="dashboard.text20" text="Todos los examinados" /></span>
										<span class="number" id="examinadosNumber">0</span>
									</div>
								</a>
							</li>
							<li id="reported">
								<a href="#;" onclick="fnTabMenuClick('S')">
									<div class="info-area">
										<span class="title"><spring:message code="dashboard.text21" text="Self-reported" /></span>
										<span class="number" id="reportedNumber">0</span>
									</div>
								</a>
							</li>
							<li id="based">
								<a href="#;" onclick="fnTabMenuClick('B')">
									<div class="info-area">
										<span class="title"><spring:message code="evaluate.skill-test" text="Performance-Based" /></span>
										<span class="number" id="basedNumber">0</span>
									</div>
								</a>
							</li>
							<li id="aprobadas">
								<a href="#;" onclick="fnTabMenuClick('A')">
									<div class="info-area">
										<span class="title"><spring:message code="dashboard.text4" text="Pruebas aprobadas" /></span>
										<span class="number" id="aprobadasNumber">0</span>
									</div>
								</a>
							</li>
						</ul>
						<!-- // 마크업 수정 (07.14) -->
					</nav>
					<div class="tab-content">
						<div class="state-data">
							<div class="region-state d-up-lg">
								<div class="map-area">
									<input type="hidden" id="cityId" >
									<!-- 지도 영역 -->
									<!--
									집계수 기준별 클래스 변경 요망
									0 : 클래스 .cls-none
									1~100 : 클래스 .cls-group1
									101~1000 :  클래스 .cls-group2
									1001~10000 :  클래스 .cls-group3
									-->
									<svg xmlns="http://www.w3.org/2000/svg" width="480" height="840" viewbox="0 0 480 840">
										<defs>
											<clippath id="clip-path">
												<rect id="Frame" width="480" height="840" fill="#fff" rx="10"/>
											</clippath>
										</defs>
										<g id="img-colombia-map" clip-path="url(#clip-path)">
											<g id="colombia-Map" transform="translate(-6.083 116.687)">
												<g id="neighboring-countries" transform="translate(.99)">
													<path id="venezuela" d="M495.166 396.466L494.5 17.67s-19.02.939-20.66 1.984-2.872 1.462-7.383 1.67-6.768.314-10.05.209-4.615 1.253-9.332 2.61-4.615.314-8.2-.626-2.154.209-5.435-.417-3.794-3.55-6.358-7.622 2.359-5.534 2.359-5.534l.718-2.193s-4.179-.626-4.615-1.044 2.871-.626 2.871-.626.616-.835-.513-2.193-1.64-1.671-2.154-3.446-.922-3.028-1.948-3.655-1.335-.102-3.8-1.987-2.769-1.357-4.1-2.3-1.333-1.566-2.154-2.193-2.871-.626-4.306-2.088-2.974-1.045-5.64-.94-2.358.314-4.409-.313-6.563-3.133-8.512-3.341-2.973 1.879-4.512 2.192-2.872-.939-5.23-1.148-1.846 1.253-3.281 1.566-3.487-4.49-4.615-7.2a53.694 53.694 0 0 1-2.87-12.735c-.205-3.446-.513-1.775-2.461-3.027s-1.538-3.968-2.256-4.7-2.256-.835-4.615-.835-.923 1.775-2.564 2.923-2.256.209-3.589.731-.615.731-.922 3.133-2.769 3.758-2.359 5.742 1.333 2.506 2.564 3.967.205 3.342 0 4.176a1.9 1.9 0 0 0 .512 1.984c.616.835 4.615-.1 6.461-.939a7.581 7.581 0 0 1 2.872-.94c1.538-.313 3.794-.731 3.794-.731l2.872.418s1.538 1.879 1.538 6.995-1.23 2.611-2.769 2.924-2.051-.209-4.819-2.3-3.18-.626-3.18-.626l.513 2.088-3.9.209a10.169 10.169 0 0 1-.922 2.61c-.821 1.776-2.769.522-5.435 1.357S348.529-6.97 344.53-5.3s-10.05 1.671-12.2 2.088-3.49 2.507-6.874 3.968-4.1 3.236-6.05 3.446-2.564 1.879-4.512 2.4-3.281-.731-4-.835a12.793 12.793 0 0 0-4.41.731c-1.333.522 1.333.94 1.744 3.967s.1 2.715-.411 2.819-3.384-.522-4.1.209.923.94 1.538 1.67.205 4.386.205 4.386a10.011 10.011 0 0 0 0 3.341c.307 1.879 1.64 1.566 1.948 2.924s-.41 1.67-.718 2.3.41.626 1.743 1.67a6.216 6.216 0 0 1 1.846 2.819 13.245 13.245 0 0 0 .82 2.3c.411.73 2.666 2.192 4.307 4.176s1.23 3.028 1.743 4.49 2.256 1.67 3.589 3.341 1.128 3.028 1.333 4.907 1.128.939 1.948 2.088.411 1.879-.205 3.446A30.51 30.51 0 0 1 322.072 61c-.307.523-.307.835.308 1.566a3.355 3.355 0 0 1 .82 3.55 3.351 3.351 0 0 0 .615 3.132s.205 1.357-.717 1.776-2.256 1.357-3.692 1.984-2.154 4.594-2.154 4.594a13.54 13.54 0 0 1-3.281.94c-1.64.208-2.563 1.879-4.614 2.3s-5.742 1.357-9.229.522-3.384-5.22-3.487-6.056-1.743-.313-2.256-.939 1.026-1.045 1.333-1.357 1.538.1 1.847-.835-1.026-2.715-2.051-2.715-1.23-.835-2.256-2.715-2.666-2.193-4.409-2.61-.513-2.61-.615-4.176-5.743-6.16-6.05-7.517.615-1.984 2.564-3.759 1.333-3.967 1.948-5.742 2.154-1.776 3.589-2.61 1.435-.731 2.153-2.715.411-2.506 1.333-4.386a6.581 6.581 0 0 1 2.666-3.341c1.641-1.253 4.2-3.446 4.41-4.49s-.205-5.429 0-6.473 2.255-.94 2.255-.94a19.975 19.975 0 0 1-4-4.8c-1.23-2.4-1.333-5.637-1.436-6.787s-2.666-.1-4.716-.731-2.564-2.4-1.744-2.923 1.026 1.148 1.846 1.67 3.487.209 4.615.209 2.872 1.566 3.384 1.879 1.436-.731 1.436-1.044-1.743-1.045-4.409-2.088-4.309-3.243-6.155-5.958-3.6-10.973-3.6-10.973L280.332-.137l-10.985.812-.8 3.05-.2 2.847-2.4 3.05-10.155 20.893-.026.053-.2 4.474-1 2.643-1.8 3.864.4 7.931-1.6 2.237-3.995 7.93-3.4 7.524-6.791 9.152 5.992.813 2.6-1.423 2.8-2.034h2.8v3.05l1.2 1.017.2 3.864 7.989.2.2 2.033 1.4 6.1.2 4.881 2 5.9 3.4 2.847 4.993 4.88 1.6 6.1 2 1.627-.2 4.678-3.2 2.44-2.8 1.83.2 20.133 7.789 2.236 2.8 1.627 1.6 6.915 2.595 3.8.6.879 4.793 3.051 2.8-.814 1.4-.61 3-.813 4.394-.2 7.59 1.423 5.592 1.627 2.8.2 2.8-1.22h5.392l3.994-3.253 3-1.017h3.795l1 1.017 2.2 1.22 3.995 1.22 3.6 2.847 4.394-.2 1.6-.814 5.791.2 3 1.423 1.8 3.254 21.37 27.656 4.194.407 2.308 1.627 4.083.407 1.2-1.221 1.4-2.441 3.995-2.236 3 .813 2.2 1.221 2.8 1.423 11.185-.407 3.795-1.83 11.185-.407 2.4-.609 4.593-.61 3.2-1.627 1.6-1.83 2.8-.2 1.4 1.423h4.794l6.591 9.965-.6 1.627-6.591 7.117-.8 11.184-8.389 7.117v6.508l1.2 5.694-.6 5.287-1.2 14.438 2.8 3.66.6 3.66 1.4 6.3 1.809 7 2.186 8.458 1.6 1.22 6.391 4.271.4 3.863 4.793 5.491-.4 1.83-20.66 17.888v4.067l9.387 2.034 2.2 2.643 3.795 1.627 2.4 4.271 3.995 5.084 3.6 2.034-1.4 1.627.2 3.458 2.8 2.846-.2 4.474 7.39 14.031 4.394 11.388v6.71l-1 .387z" class="cls-3" transform="translate(-5.998 50.772)"/>
													<path id="peru_brasil" d="M139.364 467.79c-1.692 1.018-4.206.158-4.076 3.994.077 2.271 1.385 2.9 3 5.559 1.3 2.149 3.692 4.542 4 8.3s.462 13-1.23 14.721-3.384 3.133-6.768 9.554-4.615 13.155-9.536 21.769-13.075 12.842-18.305 18.01-18 16.758-22.457 18.011-6.922 1.253-17.689 5.637-22.3 8.3-24.919 9.24-3.076 4.856-7.691 8.458-4.306 3.6-5.537 7.361 1.23 3.6-1.077 2.976-2-1.88-4.923-2.349 0 0-.922 5.011-.923 8.457-3.077 10.963-2.154 2.506-4 8.77S10.463 797.3 10.463 797.3l466.739-.351V420.806l-7.744-6.392-3.2 1.24-3.6-1.017-1.2-3.253.2-2.644 1-6.71-1.6-3.457-3.4-8.134-3.995-8.337-4.195-5.288-3.2 1.424-3.6-.407-2.6 3.253-6.79 9.965-5.792 1.627-1.6-.814-1.6-3.05-5.592-5.9-2.2 2.441.4 3.66 1.8 1.423v2.846l-47.135-.2-1.8-1.017-3.595-.609-2.8 1.829-3.795.61-4.593 1.627v23.793l12.183-.2 2.4.813h2.2l2.4-1.016 1.51.813 3.084 3.051.8 4.473 1 3.051v6.3l-4.882-.609-2.108-1.221-3.995-1.423h-3.2l-2.4 2.237h-1.8l-2.2-.814-2.2 1.221-2 1.627-8.988 1.83-1 27.656 11.385 11.388 3.2 1.423h3.4l-1 11.795 6.191 5.49.4 7.727 3.2 2.236v3.458l-1 6.71-3 3.66L367 534.819l-4.993 24-11.185 65.072-3 1.627-1.4-1.22v-2.237l-3-1.221-1.2-1.83-3.6-4.473-3.2-4.067h-11.166l-2.8-1.423-.4-2.44 1.6-2.846 18.973-28.876 4.794-6.1 1.4-2.236h-3.995l-2-2.847-3.6-3.05-3.986-2.652-4.993-.813-4.993-1.221-3.795-2.237-2.4-3.253-3-1.83-4.195.407-2.2 2.644-4.793 1.83-4.194.813-3-.813-3.6-2.237-2.8-4.067-8.188-.61-4.994-.813-4.393 7.728-5.992.813-.8 3.457-2.2.61-3-.2-3.4-1.423-3-.814h-6.79l-2.4.814h-4.594l-4.393 2.643-1-4.473h-3.6l-2.2-1.221-2-2.643v-1.631l1.6-2.44.6-2.44-1.8-5.084-1-3.457-.8-2.644H217.4l-3-1.627-1.6-3.05.8-2.237V521.4l-2-2.237V515.7l-2.6-3.051-1.6-3.05h-8.789l.4-2.237-1.4-1.627-2.4-1.423-1.6-2.846h-6.591l-1.6-1.221L180.854 485l-.635-1.83-.563-1.627-5.393-2.237-3.795-2.236-2-1.83-1.4-1.83-2.8-4.271h-4.393l-3-2.034-4.393-2.034-3.995-2.644h-1.6l-2.6 1.628h-3.6z" class="cls-3" transform="translate(10.994 26.432)"/>
													<path id="ecuador" d="M-10.965 798.479V410.971s5.579-2.367 8.369-3.314 2.324-2.84 3.719-4.259S6.686 406 6.686 406l2.6 2.846 5.592 4.271 6.79 5.9 4.793 3.253 5.592 1.627 5.792 3.253 4.194 1.627h7.39l.4 5.287.8 2.441 2.2 1.423 3.4 1.628 3.4 3.66 2.4 3.457 3.795 1.83h3.6l2.8-1.017 2.2 2.034 3.795 1.22 3.995 1.424H98.56l1-3.864 12.782.407 7.789 11.184h7.39l3.795 1.423h2.4l3.995 1.83 1.4 2.44-1.345 3.738c-1.692 1.018-4.206.158-4.076 3.994.077 2.271 1.385 2.9 3 5.559 1.3 2.149 3.692 4.542 4 8.3s.462 13-1.23 14.721-3.384 3.133-6.768 9.554-4.614 13.155-9.536 21.769-13.075 12.842-18.305 18.01-18 16.758-22.457 18.011-6.922 1.253-17.689 5.637-22.3 8.3-24.919 9.24-3.076 4.856-7.691 8.458-4.306 3.6-5.537 7.361 1.23 3.6-1.077 2.976-2-1.88-4.923-2.349 0 0-.922 5.011-.923 8.457-3.077 10.963-2.154 2.506-4 8.77S8.858 798.83 8.858 798.83z" class="cls-3" transform="translate(12.599 24.905)"/>
													<path id="panama" fill="#fff" stroke="#e4e1eb" stroke-miterlimit="10" stroke-width="2px" d="M44.653 159.216l-1-2.034 2.6-5.084v-2.643l1.6-1.423h2.8v-7.322l2.4 2.034 2.8 2.644h2.8l3.2-2.237 2.8-1.423.8-1.627-.2-3.457.4-2.847 1-1.016 3.4-1.017 1.2-1.627.2-2.237-1.2-3.457-1.2-1.83-2.6-2.846-1.2-1.423-.6-2.644.4-4.271L62.428 110l-2.2-.814v-3.457l2.2-2.846 3-.407s-6.813 1.073-7.838.028-.41-.417-1.23-2.506-2.256-3.967-3.281-4.386-3.487-.835-4.1-1.879.821-1.67-.411-2.3a26.281 26.281 0 0 1-5.332-4.176c-2.461-2.3-4.512-6.057-6.152-6.683s-3.487-1.044-4.513-1.462-3.281.209-4.1-.626a9.578 9.578 0 0 0-4.717-3.549c-3.281-1.254-5.948-2.088-6.973-2.088s-1.026.208-2.256.208-1.64-.835-3.9-1.044-2.872 2.088-4.512 1.67.41-.417-2.872-1.044-15.817 0-15.817 0v19.847l12.535-.835s3.281 3.133 4.1 4.176a2.273 2.273 0 0 0 2.051.835s1.436-1.045 2.051-.835 0 .417 1.025 2.088-.615 1.462 1.026 1.671 2.255-.627 2.666.208a5.641 5.641 0 0 0 3.076 2.506c1.641.626 2.256 2.3 1.846 2.923s3.692 9.5 4.513 10.076a2.559 2.559 0 0 0 1.167.462.391.391 0 0 0 .423-.341l.107-.722a2.319 2.319 0 0 0-.147-1.23c-.646-1.575-2.253-5.853-.807-6.235 1.282-.339 1.23 4.306 1.91 4.255.723-.056.679-1.618.679-1.618s.205-.509.615.313a2.652 2.652 0 0 0 1 1.006.358.358 0 0 0 .546-.234 16.508 16.508 0 0 1 .494-1.755 2.222 2.222 0 0 1 .967-1.122c.574-.266 1.217-.15 1.35.478a4.154 4.154 0 0 1-.253 2.3l-1.282 3.289s-.051 1.409 2-1.2l1.33-1.694a1.933 1.933 0 0 0 .252-1.935c-.527-1.276-1.107-3.247.585-2.78 2.461.678 2.769 5.651 2.973 7.112a9.465 9.465 0 0 0 .966 3.228 1.289 1.289 0 0 0 .859.492c1.068.134 3.6.571 4.88 1.788a6.031 6.031 0 0 1 1.795 3.55l-.615 1.045a12.871 12.871 0 0 1-2.877-1.451c-.77-.679-4.358-2.819-4.358-2.819l-1.641-2.61-1.589-1.305-1.128-.783s-.205 0-1.385 2.349a2.437 2.437 0 0 1-1.487 1.253l-2.072.449a.214.214 0 0 0-.117.344l1.219 1.176a.474.474 0 0 0 .316.138c.976.037 5.44.346.192 2.906a11.99 11.99 0 0 0-2.83 1.916 3.6 3.6 0 0 1-2.3.955l-1.342-.876a.464.464 0 0 0-.715.391 11.372 11.372 0 0 0 1.8 6.489 29.257 29.257 0 0 0 4.1 5.064v.276a11.18 11.18 0 0 0 1.01 4.649l.015.034a23.47 23.47 0 0 1 1.282 2.035 19.664 19.664 0 0 0 2.666 3.342 9.193 9.193 0 0 0 2.973 3.654c.872.626 1.488-2.035 1.847.522q.064.463.127.883a7.015 7.015 0 0 0 4.355 5.517z" transform="translate(12.58 44.135)"/>
												</g>
												<g id="colmbia" transform="translate(9.698)">
													<path id="colombia_outline" fill="none" stroke="#e4e1eb" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="10" stroke-width="6px" d="M347.721 650.724v-2.237l-3-1.22-1.2-1.83-3.595-4.474-3.2-4.067h-11.174l-2.8-1.424-.4-2.44 1.6-2.847 18.974-28.877 4.793-6.1 1.4-2.236h-3.994l-2-2.848-3.6-3.05-3.994-2.643-4.993-.814-4.993-1.22-3.794-2.237-2.4-3.253-3-1.831-4.194.407-2.2 2.643-4.793 1.831-4.194.814-3-.814-3.595-2.236-2.8-4.067-8.188-.61-4.993-.814-4.395 7.727-5.991.814-.8 3.457-2.2.61-3-.2-3.395-1.424-3-.814h-6.79l-2.4.814h-4.594l-4.394 2.643-1-4.473h-3.555l-2.2-1.22-2-2.643v-1.627l1.6-2.44.6-2.441-1.8-5.083-1-3.457-.8-2.644h-8.58l-3-1.626-1.6-3.05.8-2.237v-5.083l-2-2.237v-3.457l-2.6-3.05-1.6-3.05h-8.788l.4-2.237-1.4-1.626-2.4-1.424-1.6-2.847h-6.572l-1.6-1.22-4.594-15.251-.634-1.83 7.325-3.355 6.89-2.949 1.583-1.589-1.583 1.589-6.89 2.949-7.325 3.355-.564-1.627-5.392-2.237-3.8-2.237-2-1.83-1.4-1.831-2.8-4.271h-4.394l-3-2.033-4.394-2.034-4-2.643h-1.6l-2.6 1.627H142l-1.4-2.441-3.994-1.83h-2.4l-3.8-1.424h-7.39l-7.789-11.184-12.783-.407-1 3.864H85.082l-3.994-1.423-3.794-1.22-2.2-2.033-2.794 1.01h-3.6l-3.794-1.83-2.4-3.457-3.4-3.66-3.4-1.627-2.2-1.423-.8-2.441-.4-5.287h-7.39l-4.194-1.627-5.771-3.248-5.593-1.627-4.793-3.254-6.791-5.9-5.592-4.27-2.6-2.847-3.4-7.117H0l1.8-2.644 1.6-2.643 1.6-2.44h13.374l.2-8.744-2.4-3.05-2.6-4.449 3.794-7.753 2.4-2.847 2.4-1.22 2.2-.2 1.2 1.424h2.4l1.2-1.017 1.4-1.627 2 .407 2.2 1.22 1.8-1.017 2.4-2.033h3.246l.349 1.016 2.6 4.067 3.794 4.474 3 3.66 2.4 2.441h2.8l7.19 1.016 1.6 3.457 3.8 3.051 1.2 3.66-1.2-3.66-3.8-3.051-1.6-3.457-7.19-1.016h-2.8l-2.4-2.441-3-3.66-3.794-4.474-2.6-4.067-.349-1.016h6.94l.2-7.524 2.6-2.237 2.2-1.83v-3.05h-1.4v-2.441l2-1.83h1.8l.6-1.627 1.4-3.457.6-3.05.8-1.424 2.2-1.423 3-1.424 2.2-3.254 2.8-4.474 2.4-2.847 1-3.05.6-2.034 1.6-2.033-.2-3.457-2.4 2.033-1.6 3.457h-2.8l-.8-3.05-.4-1.22 1.4-2.643 1.8-2.44-1.4-2.034-3.2 4.474h-1.6l-2-1.424-.4-2.236 1.4-1.017.2-2.237.8-2.367H69.9l-.8-2.514h-2l-1.8-2.034-1.2-3.66 2.6-3.864 1.2-4.676 1-3.05s-1.8-3.051-2.4-3.051-.8-5.49-.8-5.49v-6.507l-1-8.134-1.2-7.321h-4.581l.6-1.831 3.395-3.864 3.2-1.626 2.6-1.627.8-1.83-.2-3.051-1-3.254-1.6-2.847L60.117 243l3.595-1.016 1.4-2.441 1-5.49-.2-4.677-1-4.067h-5.394l-.4-4.881-3.6-3.05-1.8-1.626 1-2.034.2-4.88-4.394-2.848-3-2.643-1-2.033 2.6-5.085v-2.642l1.6-1.424h2.8v-7.321l2.4 2.033 2.8 2.644h2.8l3.2-2.237 2.8-1.423.8-1.627-.2-3.457.4-2.848 1-1.016 3.4-1.017 1.2-1.627.2-2.236-1.2-3.457-1.2-1.831L69.3 163.9l-1.2-1.424-.6-2.643.4-4.271-2.6-1.423-2.2-.814v-3.455l2.2-2.847 3-.407v1.219l2 3.051 3.6 4.27 5.392 5.288 4 3.864 1.4 3.66 1.836.623-.896 1.409-2.847 1.221-2.546 3.762-2.7 5.083 2.7-5.083 2.546-3.762L85.632 170l.886-1.409 1.161.393v2.644l-1.8 1.83-1.2 2.034 1.4 2.439h4.594l1.6-1.016v-7.931l-1.4-3.254-1.8-3.457v-1.626l.6-4.882-1-2.236h-2l-2-1.424v-2.235l2-1.627 2.4-1.626 3.595-1.219 4.594-1.018 2-1.83 3.395-2.237 1.264-1.168 1.933 5.642-1.933-5.642.934-.865 3.6-2.44 1.2-3.05 1.8-1.627 1.2-2.033v-3.66l1.4-1.424 3.4-1.627 2.468-2.847 3.723-1.83h8.987l1.6-1.831 1.8-1.424 1.4-2.033-1-2.44-.6-2.441h-2.4l-.4-2.643.4-1.424 1.2-2.033.8-2.847.8-2.441.8-2.44.067-1.345 2.012.939 1.647 2.695v5.185h5.841v8.389h3.3l2.1 1.983 2.6 1.525 2.647 1.983 1.8 1.372h1.2l.849 3.965 1.4 4.729 1.2 4.27 1.348 3.2 3 1.831 4.194 4.27 1.8 1.83.9 1.678-.9-1.678-1.8-1.83-4.195-4.27-3-1.831-1.348-3.2-1.2-4.27-1.4-4.729-.849-3.965h-1.2l-1.8-1.372-2.647-1.983-2.6-1.525-2.1-1.983H146.6v-8.389h-5.842v-5.186l-1.648-2.695-2.01-.938.315-4.958-2.6.813-4 1.22 2.2-2.44 1.2-1.831 2.2-2.847h2l1.4-.814-1.4-1.423v-4.066l2.4-3.457 3.2-3.254 3.395-1.219 1.166-.527.881 9.373 2.7 1.831 3.295 2.288 1.648 1.474 4 2.237 3.695-4.473 3.1-3.458 1.9-3.152-1.9 3.152-3.1 3.458-3.717 4.473-4-2.237-1.648-1.474-3.289-2.289-2.7-1.831-.881-9.373 2.429-1.1 2.2-3.253 3.395-2.643 2-3.457 2.8-2.237 2.8-2.033.167-.057 2.23-.757 2.2 1.22 2.2 1.626 2.4 1.22 3.2 1.017 1.6 2.033-.2 1.22-.8 1.22-1.8.61v1.831l1 1.423h1.8l1-1.016 1.8 1.016h3.2v-1.22l1.8-2.847 2.2-4.474 2-3.66 1.2-6.914v-2.237l2.8-1.22h3.395l2.6 2.848h14.03l-.348 1.931-.8 1.932-1.1 2.033v9.863l1.4.914-1.4-.915v-9.862l1.1-2.033.8-1.932.348-1.931h1.494l10.585-1.22L246.061 30.5l5.193-1.017 3.794-2.643 4.395-2.034h3.994l3.994-10.574V9.354l5.792-.2v2.644h4.194V4.677l1.8-1.424 3.2 3.253 1.4-3.864L286.006 0h3.6L292 1.626l3.395 2.644 4.195 1.016 2.2.407 1.2 1.017 1.4 3.457 2.8 4.067.2 2.236-1.6 2.034-10.186 8.744H290.2l-1.8 1.22-6.99 1.831-5.592 1.626-3.2 5.287-7.989 13.421-10.984.814-.8 3.05-.2 2.848-2.4 3.05-10.16 20.892-2.921.257-3.9 1.017h-3.395l-2.2-2.034-.3-2.643.3 2.643 2.2 2.034h3.395l3.9-1.017 2.921-.257-.025.053-.2 4.474-1 2.643-1.8 3.864.4 7.931-1.6 2.237-3.994 7.931-3.395 7.524-6.791 9.15 5.992.814 2.6-1.424 2.8-2.033h2.8v3.05l1.2 1.017.2 3.864 7.988.2.2 2.033 1.4 6.1.2 4.88 2 5.9 3.4 2.847 4.992 4.881 1.6 6.1 2 1.627-.2 4.676-3.2 2.441-2.8 1.83.2 20.132 7.789 2.236 2.8 1.627 1.6 6.914 2.6 3.8-1 2.1h-5.842l-1.948 1.525 1.948-1.525h5.842l1-2.1.6.879 4.793 3.05 2.8-.814 1.4-.61 3-.814 4.394-.2 7.59 1.423 5.593 1.627 2.8.2 2.8-1.22h5.393l3.994-3.253 3-1.017h3.8l1 1.017 2.2 1.22 4 1.219 3.595 2.847 4.394-.2 1.6-.814 5.792.2 3 1.423 1.8 3.254 21.37 27.656-3.395 2.237-2.547 2.592h-8.088l-1.8-2.9-1.947-1.525-3.3-1.067-3.595-2.136-1.8-2.9-4.194-.305-3-.458-3.146.61-2.7 1.067-3.295 1.22-4.195.457-2.846-.457-4.045-.457 4.045.457 2.846.458 4.195-.458 3.295-1.22 2.7-1.067 3.146-.61 3 .458 4.194.305 1.8 2.9 3.6 2.136 3.3 1.067 1.947 1.525 1.8 2.9-7.489 9.914 7.49-9.914h8.088l2.547-2.592 3.395-2.237 4.195.407 2.308 1.627 4.083.407 1.2-1.22 1.4-2.441 3.994-2.237 3 .814 2.2 1.22 2.8 1.423 11.185-.407 3.794-1.83 11.185-.407 2.4-.61 4.594-.61 3.2-1.626 1.6-1.831 2.8-.2 1.4 1.424h4.793l6.591 9.964-.6 1.627-6.592 7.117-.8 11.184-8.389 7.117v6.509l1.2 5.694-.6 5.287-1.2 14.438 2.8 3.66.6 3.66 1.4 6.3 1.808 7-3.856.222-2.048 1.22-.9 1.983-1.8 1.221-2.546-1.526s-2.7-1.678-3.146-1.83-10.636-.457-10.636-.457 10.186.3 10.636.457 3.146 1.83 3.146 1.83l2.546 1.526 1.8-1.221.9-1.983 1.948-1.219 3.856-.222 2.186 8.458 1.6 1.22 6.391 4.271.4 3.863 4.793 5.491-.4 1.831-20.574 17.893v4.067l9.387 2.033 2.2 2.643 3.794 1.626 2.4 4.271 4 5.083 3.595 2.034-1.4 1.626.2 3.458 2.8 2.847-.2 4.474 7.39 14.031 4.394 11.388v6.71l-4.194 1.627-3.6-1.017-1.2-3.254.2-2.644 1-6.71-1.6-3.456-3.4-8.135-3.994-8.337-4.195-5.288-3.2 1.424-3.595-.407-2.6 3.254-6.79 9.964-5.792 1.627-1.6-.814-1.6-3.05-5.593-5.9-2.2 2.441.4 3.66 1.8 1.423v2.848l-47.135-.2-1.8-1.017-3.595-.609-2.8 1.83-3.794.609-4.594 1.627v23.792l12.183-.2 2.4.813h2.2l2.4-1.016 1.51.814 3.083 3.05.8 4.474 1 3.05v6.3l-4.881-.61-2.11-1.22-3.994-1.423h-3.2l-2.4 2.236h-1.8l-2.2-.814-2.2 1.22-2 1.627-8.987 1.83-1 27.656 11.384 11.388 3.2 1.424h3.423l-1 11.794 6.191 5.491.4 7.727-1.1 1.626H365.4l-1.1-1.83-1.5-2.745-1.5-1.22-8.289.2 8.289-.2 1.5 1.22 1.5 2.745 1.1 1.83h4.195l1.1-1.626 3.2 2.237v3.457l-1 6.711-3 3.66-1.6 13.828-4.993 24-11.184 65.072-3 1.627zm-9.587-125.264l2.1 1.626 1.8 1.424 1.4 1.423.45-4.778 4.943-.1 3.2-1.017 1 1.119-1-1.119-3.2 1.017-4.943.1-.45 4.778-1.4-1.423-1.8-1.424-2.1-1.627zm-.6-13.828l.6 2.441zm-93.671-2.643l2.6 1.728 1.5 1.932.9 1.424h1.1l2-.61.7-1.322 1.3-.915-1.3.915-.7 1.322-2 .61h-1.1l-.9-1.424-1.5-1.932-2.6-1.728h-.8l-3.495.915-3 .508-.7-.609-1-1.322-1.9-1.119-1.2 1.119-1.4 1.22-2.5 1.728-1.6-.61-2.1-1.118-2.8-1.831h-9.187l-3-2.643-3.195-2.542-8.189-.61 8.189.61 3.195 2.542 3 2.643h9.187l2.8 1.831 2.1 1.118 1.6.61 2.5-1.728 1.4-1.22 1.2-1.119 1.9 1.119 1 1.322.7.609 3-.508 3.495-.915zm13.381 1.728l1.7 1.119.8 1.119 2.7.1v-6.1l1.3-3.559 2.1-1.83 2.2-1.22 2.3-1.525 3.595-2.237 5.393-.509 1.4-2.643 1.7-2.44 1.1-1.729 1.5-1.626.5-1.424 2.5-.509 1.3-.712 2.6-1.321-2.6 1.321-1.3.712-2.5.509-.5 1.424-1.5 1.626-1.1 1.729-1.7 2.44-1.4 2.643-5.393.509-3.595 2.237-2.3 1.525-2.2 1.22-2.1 1.83-1.3 3.559v6.1l-2.7-.1-.8-1.119zm68.706-9.964l3 2.542 2.2.712 2.2.814h3.994l2-.61-2 .61h-3.994l-2.2-.814-2.2-.712-3-2.542-2.7-1.525-2.4.915-2.4 1.627-1.8-1.119-.9-2.542-3.3-6.3-1.5-4.575h-3.4l-2.4-1.322-2.7-1.729-3.5-1.22-3.3-1.831-3.495-.814-3.6-2.338 3.6 2.339 3.495.814 3.3 1.831 3.5 1.22 2.7 1.729 2.4 1.322h3.4l1.5 4.575 3.3 6.3.9 2.542 1.8 1.119 2.4-1.627 2.4-.915zm-156.384-11.795l1.5 1.627 3 .814h4.594l2 1.118h3l9.287 6.609 3.2 1.729-3.2-1.729-9.287-6.609h-3l-2-1.118h-4.6l-3-.814zm-.5-6.609l.5 3.05zm-10.385-5.8h2l3.2 1.525 1.9 1.22-1.9-1.22-3.2-1.525zM147 468.522l2.5.508h2.7l3.4 1.424-3.4-1.424h-2.7zm103.558-26.894l3.3 3.508L257.6 452l2.846 5.338 5.693 3.2 4.943 1.372 18.118-20.587.9-1.525.149-5.8 13.332-12.658 8.239-7.473 3.3-1.678 10.336-1.831 10.186-2.44 8.239-.305v-1.067l3-2.136 3.745-2.44-3.745 2.44-3 2.136v1.067l-8.239.305-10.186 2.44-10.336 1.831-3.3 1.678-8.239 7.473L290.25 434l-.149 5.8-.9 1.525-18.125 20.589-4.943-1.372-5.693-3.2L257.6 452l-3.745-6.863-3.3-3.508h-10.187l-.449 5.186-3 .61-4.643 1.83h-3.3l-.9-1.525-2.7-1.22-4.776-3.81-1.948-2.287-1.5-2.593-1.648-2.593-3.445-4.27-2.847-3.66 2.847 3.66 3.445 4.27 1.648 2.593 1.5 2.593 1.948 2.287 4.793 3.813 2.7 1.22.9 1.525h3.3l4.643-1.83 3-.61.449-5.186zm-175.259 9l1.4 3.051 1 3.66.6 3.66-.6-3.66-1-3.66zm25.965-2.643h20.571l2.1 1.729 1.8 2.542.7 1.017h5.693l3.595 1.423 2.6 1.729 3.2 1.423-3.2-1.423-2.6-1.729-3.595-1.423h-5.693l-.7-1.017-1.8-2.542-2.1-1.729h-4.394l-4.594-4.779-4.544-3.253-1.848-1.728 1.848 1.728 4.544 3.253 4.594 4.779zm-4.295-5.9l1.5 2.338 1.6 2.44-1.6-2.44zm-2-9.965l2.2 3.762 1.9 1.932.5 1.525-.5-1.525-1.9-1.932-2.2-3.762-1.5-.712-6.592 4.982 6.591-4.982zm16.177-5.9h6.692l3-1.831 3.8-6.507 4.793-4.982 3.395-2.338 2-1.831.9-5.8 3.6-3.127 3.1-3.787 2.4-3.152 1.8-4.474.9-1.119 4.294-.2 2.7-1.626 1.8-1.322v-2.542l-.7-2.034-.4-2.542 1.1-2.643 1.7-.61 1.057-1.22 2.337 1.119 2.9.508 2.8.508 2.7 2.237 2.2 3.05 1.7 2.542-1 1.831-1.9 2.643-1.2 2.441.9 4.676 1.4 9.049 1.1 7.219 1.2 3.559 1.5 1.932 3.9 1.372h5.792l4.195 3.609 4.693 2.948 2.6 1.831 5.093-1.424 4.892-1.016 2.4-.305v-25.005l1.2-2.288 1.948-1.982h15.278l2.847-.763 5.392-3.2 1.8-2.593 2.1-1.678h7.19l2.246-.915 2.847-1.678 3.295-2.288 3.145-2.818h2.7l1.048 1.292 1.948 1.526V375.1h3.894l3 1.408 3.6 1.148 1.5-1.3 2.4-1.068h4.644l10.185-.152 1.948-.687 2.7-1.906 1.2 1.22 1.2 1.83 1.648.763 2.546-1.525h3.445v-77.938l-4.494.915-6.142 2.745-10.137 5.033-6.142 2.593-2.547 1.373v3.355l-1.048.153-2.4.152-2.4 1.372h-2.246l-2.846-1.83-2.7-.305-1.648 1.831-2.847 1.448-1.947 2.669-4.045-.152-2.7-1.068-2.546.915-2.7.915-2.247-.915-1.947-3.508-3.445-3.507-5.186-6.738.691-2.413-.691 2.413-.357 1.247h-3.894l-7.34-4.117-9.138-5.491-2.247-4.271-.749-5.8 1.648-4.728 1.348-6.71-3.9-1.678-4.194-1.22h-3.445l-1.5 1.22-3.745 3.051-2.846 1.83-2.4-1.678-3.3-1.983-3-2.44v-3.66l-1.8-6.1v-1.983h-1.5l-3.146 1.983-4.791.844-.452-.844h-1.648l-3.894 1.22 3.894-1.22h1.648l.452.844.447.833-1.348 5.186-1.8 5.186-.9 3.2-3.096 1.84-2.1.61-5.243.305-4.643.762-4.793 2.44-5.693 4.118-1.2 9.76-.55.239v4.133l-.9 3.05-1.4 5.288-3.595 5.8-3.3 7.016-1.7 2.949-1.703 3.107-2.174-3.622-1.049-3.864-1.847-2.644 1.847 2.644 1.049 3.864 2.174 3.622-.076.14-1.5 1.525-1.648 1.525-3.944.712-1.7 1.83-1.7 3.965-.9 3.66-3.195 17.489-1.4 1.931h-1.2l1.1 3.762 1.8 3.05 1.9 1.627.482 1.168.316.763v4.476l1.57 1.729 2.425 3.05 1.1 2.338 1.5 1.22 1.4 1.83.449 1.729-1.148 2.237-.9 1.017-2-.814-2.824-1.83-2.468.407-4.693 3.254-3.3 2.033-3 1.322-2 1.322-1.3 1.321v1.551l.6 2.11.5 1.729-.3 1.423h-2.2l-2-.711-2.6-1.017-2.2.305-1.1.814v2.847l1.1 2.643v4.677h2.6l2.1 1.728 2.2 3.66 1.2 2.848 1 2.44 2.4.915h4.693zm-41.442-5.9l1.2 1.424h6.791l4 1.627L85.882 425l1 1.22-1-1.22-4.194-1.626-4-1.627H70.9zm251.254-36.806l-2.247 1.067-1.2 2.288 1.2-2.288zm6.591-6.558l.469.69-.983 1.638.984-1.638.878 1.292 3.37-3.2 4.119-3.66.45-2.136.6-4.88 3.595-2.441 1.948-1.525.15-3.05 3.745-2.441 2.4-1.83 3.145-.305 4.045-1.526 4.643-4.117 3.445-1.983 3.595-2.593 1.948-.762 25.166.914 3.9-1.219 3.595-1.526 3.3-2.135 3.295-1.678-3.295 1.677-3.3 2.136-3.595 1.526-3.9 1.219-25.166-.914-1.948.762-3.595 2.592-3.445 1.984-4.643 4.117-4.045 1.526-3.145.305-2.4 1.83-3.745 2.441-.15 3.05-1.948 1.525-3.595 2.441-.6 4.88-.45 2.136-4.119 3.66-3.37 3.2-.878-1.292-.469-.69-2.247-.914zm-12.578-.75l.445-.164zM86.88 370.3l-2.3-1.729zm13.282-11.283zm-23.667-33.909zm22.469-4.27l1.049 1.982-1.049-1.983-.524-1.754zm20.472-12.456l.471 3.254 1.826 1.729 3.2 1.728-3.2-1.728-1.826-1.729zm-21.521 5.592l3.445-6.253zm5.243-9.608l-1.8 3.356 1.8-3.355 3.295-4.576zm14.18-11.336l2.568 2.339 2.625 2.948 1.9 2.236 1.6 1.932 1.3 1.423.589.72-.589-.72-1.3-1.423-1.6-1.932-1.9-2.236-2.625-2.948-2.568-2.339zm122.132-14.896l-2.247 1.219V291.4l-3.445.457-2.246 2.745 2.246-2.745 3.445-.457v-12.046l2.247-1.219 1.8-1.068 2.846 2.746 1.648 1.83 1.948-.915 4.793-5.948-4.793 5.948-1.948.915-1.648-1.83-2.846-2.746zm-109.2 2.745l-3.445 1.372-1.049.762-.9 2.746-1.39 1.83-2.5.762 2.5-.762 1.39-1.83.9-2.746 1.049-.762 3.445-1.372 2.1-1.831zm186.043 3.66l-.855.67.856-.67 1.8-1.22zm-211.509-1.22l1.2 1.525-1.2-1.526-.245-1.246zm18.682-6.406zm205.859-3.05l-3.22 2.822 3.221-2.822 3.894-1.831zM119.036 272.8l-2.547-1.219zm140.357-1.22l1.8-1.22-1.8 1.22zm-142.9 0zm17.225-4.88l-1.247 2.439 1.248-2.44 1.049-2.9zm9.438-.763l3.744-.458-3.744.458zm-29.51-4.118zM220 258.307l-1.5 3.05-.6 2.135.6-2.135 1.5-3.05zm38.647-18l-.9 15.4-1.648 2.9 1.648-2.9.9-15.4 2.7 5.033 1.647 3.2 2.1 1.983h2.4l4.194-3.355 3.545-1.525 3.645-1.067 4.793.3 2.4 1.22 4.793-.152 2.546-.153 3.445-1.525 3.9-.763 2.546-1.372 5.093.153 3.894 1.525-3.9-1.525-5.093-.153-2.546 1.372-3.9.763-3.449 1.534-2.546.153-4.793.152-2.4-1.22-4.793-.305-3.645 1.068-3.545 1.525-4.194 3.355h-2.4l-2.1-1.983-1.648-3.2zm-86.282 10.371l-2.1 5.338 2.1-5.338 2.546-6.1zm2.781-7.484l-.234 1.383.235-1.383.257-1.52zm68.3-7.615l.974 2.441.749 3.812-.749-3.812zm8.763-10.066l2.4.915zm-53.926-10.066l-9.437 6.405 9.437-6.405 2.546-1.831zm-116.695 3.816l-1.049 2.288 1.049-2.288 1.347-2.288H88.5v-5.185l2.222.152 3.445.763 3.146.762-3.146-.762-3.445-.763-2.222-.152v5.185h-5.565zm173.161 0H252.2l-3-1.83-2.4-1.372-5.692-1.678-3.745-1.678 3.745 1.678 5.692 1.678 2.4 1.372 3 1.83zm-53.925-5.643l.749-2.135zm-19.024-6.71l1.8 5.8h4.469l2.272-2.288v-2.136l2.7-3.507h6.142l2.4 4.117-2.4-4.117h-6.142l-2.7 3.507v2.136l-2.272 2.287H183.6zm56.623-1.983l.749 2.44zm-138.96-2.44zm74.547-9.914v4.727l1.649 3.66-1.648-3.66v-4.728l3-3.508zm63.213 3.508l1.2 4.729zm-131.368-.05l2 3.66h11.185l7.389-2.236 3.794-7.321.8-2.339-.8 2.338-3.794 7.321-7.39 2.237h-11.187zm77.293 1.728l-1.348-2.9zm48.833-7.473l2.846.915 2.4 1.525-2.4-1.525-2.846-.915-3.3-1.831-1.2 2.746H217.3l-1.872-1.678-2.173-1.22-1.5-2.593 1.5 2.593 2.173 1.22 1.872 1.677h10.186l1.2-2.746zm-64.711-20.894l5.243 4.118 4.195 3.66 1.2 3.507.749 4.423-.749-4.423-1.2-3.508-4.195-3.66-5.243-4.117-1.8-1.372 1.348-3.965-1.348 3.965-4.394 4.219-2.5.2-5.193.61-5.293.61-2.1 3.457 2.1-3.457 5.293-.61 5.193-.61 2.5-.2 4.394-4.219zm-34.448 15.27l.795-.629zm68.3-5.662l1.5 3.2zm5.842 1.372l1.948-2.288zm-.149-5.389zm12.282-9.1l1.2 3.508.749 3.2-.749-3.2zm-45.837-3.66l-3.445 1.831 3.446-1.831.9-5.185zm43.591-.457l1.2-2.44 1.348-2.9 2.4-1.372-2.4 1.372-1.348 2.9zm-107.2-.1l2.6-2.643zm80.689-29.079l4.495 3.05 3.495 1.626h2.8l1.348 6.813 1.8 9.15 1.348 7.931-1.348-7.931-1.8-9.15-1.348-6.813 1.8-4.067.7-3.355-.7 3.355-1.8 4.067h-2.8l-3.495-1.626zm-37.6 26.588l1.847-2.135-1.847 2.134zm-44.888-8.9l1.6 1.83 2.8 1.22-2.8-1.22zm65.26-3.152l.3 3.2 1.5 2.9-1.5-2.9zm45.688-.763l-1.348 2.9 1.348-2.9.749-1.983zm-1.348-10.676l.149 1.576.6 1.17 1.2 3.507.15 2.441-.15-2.441-1.2-3.507-.6-1.17zm-67.407 4.576l-2.7 1.372-4.944 1.526 4.944-1.526 2.7-1.372.449-1.983zm48.383-12.76l.5-7.931zm-31.458-11.285l.1 3.05 3.7 2.441 3.395 1.83 1.4 2.338 1.7.508 7.09.509-7.09-.509-1.7-.508-1.4-2.338-3.395-1.83-3.7-2.441zm29.26 1.831l2.7 1.525-2.7-1.525-2.4-.914zm7.39-5.491l-4 .61-3.695.712-2.1 3.253 2.1-3.253 3.7-.712 3.994-.61zm-38.847-5.8l.649 2.338 1.548 3.66-1.548-3.66zm37.248-1.831l1.6 2.135-1.6-2.135-.5-3.152zm-40.943-12.806l2.3 1.729 3.2 2.135-3.2-2.135zm53.077-15.912l-2.247.762-1.2.915-13.681 8.033-2.3 4.677-1.5 4.88 1.5-4.88 2.3-4.677 13.681-8.033 1.2-.915 2.247-.762zm4.545-12.964h3.395l3.1.712.5 3.05.5.814 3.6.508 1.3.914 1.3 3.051-1.3-3.051-1.3-.914-3.6-.508-.5-.814-.5-3.05-3.1-.712H218.7l-5.393-.814-.5 2.491.5-2.491zm-4.544 7.626l-.749 1.067zm.9-1.831z"/>
													<!-- 콜롬비아 수도 영역 -->
													<g id="map-color">
														<g id="_1_100" transform="translate(42.192 52.815)">
															<path id="0012" class="cls-none" d="M289.165 183.652l-1.8 4.423v1.678l-.9 3.2-1.8 1.373-2.7 2.135-4.644 5.49 2.7 5.033 1.648 3.2 2.1 1.983h2.4l4.194-3.355 3.545-1.525 3.645-1.068 4.793.305 2.4 1.22 4.793-.153 2.547-.152 3.445-1.525 3.895-.763 2.546-1.373 5.093.153 3.895 1.525 4.344-.153 4.044.458 2.846.458 4.194-.458 3.3-1.22 2.7-1.068 3.146-.61 3 .458 4.194.305 1.8 2.9 3.6 2.135 3.3 1.068 1.947 1.525 1.8 2.9h8.089l2.547-2.593 3.4-2.237-21.404-27.654-1.8-3.254-3-1.423-5.792-.2-1.6.813-4.394.2-3.6-2.847-3.995-1.22-2.2-1.22-1-1.017h-3.776l-3 1.017-3.994 3.254h-5.393l-2.8 1.22-2.8-.2-5.592-1.627-7.59-1.423-4.394.2-3 .813-1.4.61-2.8.813-2.646 3.66z" transform="translate(-60.879 -14.458)"/>
															<path id="path_6896" class="cls-none" d="M202.066 298.305l-2.781 3.081-3.795 3.152-2.9 2.644" transform="translate(-54.534 -21.823)"/>
															<path id="0018" class="cls-none" d="M140.836 289.882l3.3-7.016 3.6-5.8 1.4-5.287-1.4.813h-11.993l-.409-.5-1.788.958-1.7.661-3.445 1.118-1.548 1.017.471 3.254 1.826 1.728 3.2 1.729v3.254l1.847 2.644 1.049 3.864 2.174 3.623 1.721-3.115z"  transform="translate(-49.612 -20.283)"/>
															<path id="0023" class="cls-none" d="M119.189 341.47l-.483-1.168-1.9-1.627-1.8-3.05-1.1-3.762h-.7l-2.1-.712-3.695-2.034-3.895-1.525-1.9.3-.3 1.729 1 2.237-1 1.22-1.9 1.118-3.5 2.339-4.922 3.565-2.946.813-2.3-1.728-3.2-1.83-7.689-.813-3.5-.508-1.6-1.322-2.1-2.644-1.7-3.05-2.7-3.152-2.2 1.423-.8 1.423-.6 3.05-1.4 3.457-.6 1.627h-1.8l-2 1.83v2.44h1.4v3.05L53.1 346l-2.6 2.237-.2 7.524h-6.94l.35 1.017 2.6 4.067 3.795 4.474 3 3.66 2.4 2.44h2.8l7.19 1.017 1.6 3.457 3.795 3.05 1.2 3.66v2.644l-1 2.593-.2 3.1 1.2 1.423h6.791l3.994 1.627 4.194 1.627 1 1.22V407l6.591-4.982 1.5.712 2.2 3.762 1.9 1.932.5 1.525-1.7 1.627-.9 1.118 1.5 2.339 1.6 2.44 1.2 1.118h16.178l-4.594-4.779-4.544-3.254-1.847-1.729v-1.423l.6-1.424 1-2.237 2.1-6.914h-3.695l-2.4-.915-1-2.44-1.2-2.847-2.2-3.66-2.1-1.728h-2.6v-4.677l-1.1-2.644v-2.847l1.1-.813 2.2-.305 2.6 1.017 2 .712h2.2l.3-1.423-.5-1.728-.6-2.11v-1.551l1.3-1.322 2-1.322 3-1.322 3.3-2.034 4.694-3.254 2.468-.407 2.825 1.83 2 .813.9-1.017 1.148-2.237-.449-1.728-1.4-1.83-1.5-1.22-1.1-2.339-2.425-3.05-1.569-1.729v-4.474l-.316-.764"  transform="translate(-43.359 -23.424)"/>
															<path id="0019" class="cls-none" d="M69.289 328.229l2.1 2.644 1.6 1.322 3.5.508 7.689.813 3.2 1.83 2.3 1.728 2.946-.813 4.926-3.561 3.5-2.339 1.9-1.118 1-1.22-1-2.237.3-1.729 1.9-.305 3.895 1.525 3.695 2.033 2.1.712h1.9l1.4-1.932 3.2-17.488.9-3.66 1.7-3.965 1.7-1.83 3.945-.712 1.648-1.525 1.5-1.525.077-.139-2.174-3.623-1.049-3.864-1.847-2.644v-3.254l-3.2-1.728-1.826-1.728-.471-3.254 1.548-1.017 3.445-1.118 1.7-.661 1.788-.958-.589-.72-1.3-1.423-1.6-1.932-1.9-2.237-2.625-2.949-2.568-2.339h-6.391v1.728l-1.5 2.135-3 2.9-3.3 4.575-1.8 3.355-3.445 6.253v3.357l1.049 3.508 1.049 1.983-1.049 1.906-1.648 1.246-2.247.813-3.16 2.744h-2.843l-1.648-1.373h-2.4l-2.4-1.373h-5.086l-1.049-1.678v-2.288l-6.591-.842h-5.392l-.8 2.367-.2 2.237-1.4 1.017.4 2.237 2 1.423h1.6l3.2-4.474 1.4 2.034-1.8 2.44-1.4 2.644.4 1.22.8 3.05h2.8l1.6-3.457 2.4-2.034.2 3.457-1.6 2.034-.6 2.033-1 3.05-2.4 2.847-2.8 4.474-2.2 3.254-3 1.423 2.7 3.152z"  transform="translate(-44.972 -19.587)"/>
															<path id="0029" class="cls-none" d="M364.619 391.674l-1.049-3.508v-6.711l-8.239.3-10.186 2.44-10.336 1.83-3.3 1.678-8.239 7.473-13.332 12.659-.15 5.8-.9 1.525-18.118 20.591 4.344 5.084 5.592 6.2 3.4 3.457 4.194 1.322 3.6 2.339 3.5.813 3.3 1.83 3.5 1.22 2.7 1.728 2.4 1.322h3.4l1.5 4.575 3.3 6.3.9 2.542 1.8 1.118 2.4-1.627 2.4-.915 2.7 1.525 3 2.542 2.2.712 2.2.813h3.995l2-.61v3.359l-1.3 1.932-.5 2.135.6 2.44V499.3l2.1 1.627 1.8 1.423 1.4 1.423.449-4.779 4.943-.1 3.2-1.017 1 1.118v2.237l8.289-.2 1.5 1.22 1.5 2.745 1.1 1.83h4.194l1.1-1.627-.4-7.727-6.191-5.49 1-11.794h-3.4l-3.2-1.423-11.384-11.388 1-27.656 8.988-1.83 2-1.627 2.2-1.22 2.2.813h1.8l2.4-2.237h3.2l3.995 1.423 2.109 1.22 4.882.61v-6.3l-1-3.05-.8-4.474-3.084-3.05-1.51-.813-2.4 1.017h-2.2l-2.4-.813-12.183.2v-23.799l-8.089-2.9z"  transform="translate(-61.885 -26.653)"/>
															<path id="0030" class="cls-none" d="M377.841 511.3l-1.1-1.83-1.5-2.745-1.5-1.22-8.289.2v-2.237l-1-1.118-3.2 1.017-4.943.1-.449 4.779-1.4-1.424-1.8-1.423-2.1-1.627v-11.379l-.6-2.44.5-2.135 1.3-1.932v-3.355l-2 .61h-3.995l-2.2-.813-2.2-.712-3-2.542-2.7-1.525-2.4.915-2.4 1.627-1.8-1.118-.9-2.542-3.3-6.3-1.5-4.575h-3.4l-2.4-1.322-2.7-1.728-3.5-1.22-3.3-1.83-3.5-.813-.3 3.355-2.6 1.322-1.3.712-2.5.508-.5 1.423-1.5 1.627-1.1 1.728-1.7 2.44-1.4 2.644-5.393.508-3.6 2.237-2.3 1.525-2.2 1.22-2.1 1.83-1.3 3.559v6.1l-2.7-.1-.8-1.118-1.7-1.118-2.2-.2-1.1.712-1.3.915-.7 1.322-2 .61h-1.1l-.9-1.423-1.5-1.932-2.6-1.729h-.8l-3.5.915-3 .508-.7-.61-1-1.322-1.9-1.118-1.2 1.118-1.4 1.22-2.5 1.729-1.6-.61-2.1-1.118-2.8-1.83h-9.187l-3-2.644-3.2-2.542-8.189-.61-.514-.369-1.584 1.589-6.891 2.949-7.325 3.355.634 1.83 4.771 15.24 1.6 1.22h6.591l1.6 2.847 2.4 1.423 1.4 1.627-.4 2.237h8.788l1.6 3.05 2.6 3.05v3.457l2 2.237v5.084l-.8 2.237 1.6 3.05 3 1.627h8.588l.8 2.644 1 3.457 1.8 5.084-.6 2.44-1.6 2.44v1.627l2 2.644 2.2 1.22h3.6l1 4.474 4.394-2.644h4.594l2.4-.813h6.791l3 .813 3.4 1.423 3 .2 2.2-.61.8-3.457 5.992-.813 4.394-7.727 4.993.813 8.189.61 2.8 4.067 3.6 2.237 3 .813 4.194-.813 4.793-1.83 2.2-2.644 4.194-.407 3 1.83 2.4 3.254 3.718 2.241 4.993 1.22 4.993.813 3.994 2.643 3.6 3.05 2 2.847h3.994l-1.4 2.237-4.793 6.1-18.981 28.878-1.6 2.847.4 2.44 2.8 1.424h11.185l3.2 4.067 3.6 4.474 1.2 1.83 3 1.22v2.237l1.4 1.22 3-1.627 11.185-65.073 4.993-24 1.6-13.828 3-3.66 1-6.711v-3.457l-3.2-2.237-1.1 1.627z"  transform="translate(-54.636 -31.136)"/>
															<path id="0009" class="cls-none" d="M78.014 282.852l1.048 1.678h5.093l2.4 1.373h2.4l1.648 1.372h2.846l3.146-2.746 2.246-.813 1.648-1.246 1.049-1.906-1.049-1.983-1.048-3.509v-3.355l3.445-6.253 1.8-3.356 3.3-4.575 3-2.9 1.5-2.134v-2.44l-4.943-7.473-1.2-1.525-.449-2.288 4.943-3.2 5.093-3.965 2.1-2.288v-3.508l-2.847-2.9v-8.846l-1.348-5.49-2.4-3.508-2.546-3.05H92.094l-2.072-5.49-1.972-5.186-3.15-6.251-2.247-3.813-.6-1.983 1.048-2.288 1.348-2.288h5.567v-5.185l2.222.153 3.445.763 3.145.762 1.5-.762.649-10.219-4.244-2.8L85.2 146.2s-6.142-5.339-6.142-5.8v-2.593l2.7-5.084 2.546-3.762 2.847-1.221.886-1.41-1.835-.623-1.4-3.66-3.995-3.864-5.39-5.283-3.6-4.27-2-3.051v-1.22l-3 .407-2.2 2.846v3.457l2.2.814 2.6 1.423-.4 4.271.6 2.644 1.2 1.423 2.6 2.846 1.2 1.83 1.2 3.457-.2 2.237-1.2 1.627-3.4 1.017-1 1.016-.4 2.847.2 3.457-.8 1.627-2.8 1.423-3.2 2.237h-2.8l-2.8-2.644-2.4-2.033v7.321h-2.8l-1.6 1.423v2.643l-2.6 5.084 1 2.034 3 2.643 4.394 2.847-.2 4.88-1 2.034 1.8 1.627 3.6 3.05.4 4.881h5.419l1 4.067.2 4.677-1 5.49-1.4 2.441-3.6 1.016 6.591 8.745 1.6 2.846 1 3.253.2 3.051-.8 1.83-2.6 1.627-3.2 1.627-3.4 3.864-.6 1.83h4.594l1.2 7.321 1 8.134v6.507s.2 5.49.8 5.49 2.4 3.051 2.4 3.051l-1 3.05-1.2 4.677-2.6 3.864 1.2 3.66 1.8 2.034h2l.8 2.514 6.591.842z"  transform="translate(-43.711 -10.558)"/>
															<path id="0008" class="cls-none" d="M111.657 100.749l1 3.457 1 2.034 1.6 1.83 2.8 1.22v5.694l-2.6 2.644-2.2 2.389-1.8 3.3-6.191 16.065v2.034l2 3.457 4.394 7.117 2 3.66h11.185l7.39-2.237 3.795-7.321 1.6-4.677 1.8-1.423 3.4 1.017 2.4-.407 6.591-7.524 2.1-3.457 5.293-.61 5.193-.61 2.5-.2 4.394-4.22 1.348-3.965h-.749l-1.8-4.88-3.2-2.44-4.294-.61-2.2.915-1.847 2.135-3.6-3.508-3-.763-1.348-.61-.6-7.168-.749-1.22-1.049-2.745 4.937-1.522 2.7-1.373.449-1.983-.449-2.593-3-3.66L137.641 73.7h-8.208l-3.723 1.83-2.468 2.847-3.4 1.627-1.4 1.423v3.66l-1.2 2.034-1.8 1.627-1.2 3.05-3.6 2.44-.934.865z"  transform="translate(-47.995 -8.778)"/>
															<path id="0004" class="cls-none" d="M161.918 30.758l3.3 2.288 1.648 1.474 3.994 2.237 3.695-4.474 3.1-3.457 1.9-3.152V12.762l-1.2-3.864-3.3-3.152-.932-.972-.167.056-2.8 2.034-2.8 2.237-2 3.457-3.4 2.644-2.2 3.254-2.429 1.1.881 9.373z"  transform="translate(-51.969 -4.774)"/>
															<path id="0006" class="cls-none" d="M149.1 48.9v5.185h5.842v8.388h3.3l2.1 1.983 2.6 1.525 2.646 1.983 1.8 1.373h1.2l.849 3.965 1.4 4.728 1.2 4.27 1.348 3.2 3 1.83 4.194 4.27 1.8 1.83.9 1.678-.749 3.508-1.077 1.384.3 3.2 1.5 2.9-.749 3.813-.9 5.185-3.445 1.83h-3l-1.348 3.965 1.8 1.373 5.243 4.118 4.194 3.66 1.2 3.508.749 4.423-1.648 3.965-3 3.508v4.728l1.648 3.66 2.1-2.745 4.044-3.355 1.348 2.9-1.348 2.288v6.863l1.8 5.8h4.469l2.272-2.288v-2.135l2.7-3.508h6.142v-6.863l1.947-3.508 1.049-4.118.449-8.083-1.5-3.2v-5.8l2.247-3.813 1.5-3.355.749-4.88-1.355-7.936-1.8-9.151-1.348-6.812h-2.8l-3.5-1.627-4.494-3.05-2.9-3.152-3.1-2.542-7.09-.508-1.7-.508-1.4-2.339-3.4-1.83-3.695-2.44-.1-3.05v-3.462l-1.548-3.66-.649-2.339.2-3.457 1.5-3.66.1-3.66-3.2-2.135-2.3-1.728v-7.322l-3.994-2.237-1.648-1.474-3.3-2.288-2.7-1.83-.881-9.373-1.166.528-3.4 1.22-3.2 3.254-2.4 3.457v4.067l1.4 1.423-1.4.813h-2l-2.2 2.847-1.2 1.83-2.2 2.44 3.995-1.22 2.6-.813-.314 4.958 2.012.939z"  transform="translate(-50.533 -5.686)"/>
															<path id="0021" class="cls-none" d="M199.285 299.523l2.781-3.081-.085-2.1.5-3.457.9-3.152.1-4.118 2.3-4.626 1.6-3.889 1-3.635-.9-2.339-.6-2.9-2 1.474-2 3.152-1.1 4.245-1 5.618-2.4 12.4-2.6 1.932-2.4.712-.8 9.558 2.9-2.644z"  transform="translate(-54.534 -19.96)"/>
														</g>
														<g id="_101_1000">
															<path id="0005" class="cls-none" d="M232.792 90.385l-.449 1.678.15 1.576.6 1.169 1.2 3.508.15 2.44-.749 1.983-1.348 2.9-2.4 3.66v4.728l1.8 4.118 1.2-2.44 1.348-2.9 2.4-1.373v4.423l-.749 2.745-1.947 3.66 1.2 3.508.749 3.2v4.957l-.6 1.6-1.5 5.8-2.1.763h-5.093l1.5 2.593 2.172 1.22 1.872 1.678h10.186l1.2-2.745 3.3 1.83 2.846.915 2.4 1.525v3.355l1.2 4.728v4.113l.749 2.44v4.423l-1.8.915 3.745 1.678 5.692 1.678 2.4 1.373 3 1.83h2.547l3.445-3.2 2.846-1.83 1.947-1.525h5.842l1-2.1-2.6-3.8-1.6-6.914-2.8-1.627-7.789-2.237-.2-20.132 2.8-1.83 3.2-2.44.2-4.677-2-1.627-1.6-6.1-4.993-4.88-3.4-2.847-2-5.9-.2-4.88-1.4-6.1-.2-2.034-7.989-.2-.2-3.864-1.2-1.017v-3.05h-2.8l-2.8 2.034-2.6 1.423-5.992-.813-2.147 4.321z"  transform="translate(-14.892 43.623)"/>
															<path id="0028" class="cls-none" d="M339.988 347.723h-1.2l-1.648 1.373-2.54 1.524-3-1.373-1.5-1.525-1.648.61-1.5.915-2.1-1.983-2.1-.763h-3.445l-2.547 1.525-1.648-.763-1.2-1.83-1.2-1.22-2.7 1.906-1.947.686-10.186.153h-4.644l-2.4 1.068-1.5 1.3-3.6-1.148-3-1.409h-3.895v5.374l-1.947-1.525-1.048-1.293h-2.7l-3.146 2.818-3.3 2.288-2.846 1.678-2.247.915h-7.19l-2.1 1.678-1.8 2.593-5.393 3.2-2.846.763h-15.233l-1.947 1.983-1.2 2.288v29.435l2.846 3.66 3.445 4.27 1.648 2.593 1.5 2.593 1.947 2.288 4.793 3.813 2.7 1.22.9 1.525h3.3l4.644-1.83 3-.61.449-5.185h10.186l3.3 3.508 3.745 6.863 2.846 5.338 5.692 3.2 4.943 1.373L303.888 413l.9-1.525.15-5.8 13.332-12.659 8.239-7.473 3.3-1.678 10.336-1.83 10.186-2.44 8.239-.3v-1.068l3-2.135 3.745-2.44v-2.9l-3.745-1.22-6.741.153-5.393 1.068-5.542.737-2.247-1.652-2.7-3.965-3-3.66-1.648-.763-2.1-2.9 1.2-2.288 2.247-1.068 5.093-2.593 1.967-3.275-.469-.69z"  transform="translate(-14.686 28.325)"/>
															<path id="0026" class="cls-none" d="M123.188 395.843l3-1.83 3.795-6.507 4.793-4.982 3.4-2.339 2-1.83.9-5.8 3.6-3.127 3.1-3.787 2.4-3.152 1.8-4.474.9-1.118 4.294-.2 2.7-1.627 1.8-1.322v-2.542l-.7-2.034-.4-2.542 1.1-2.644 1.7-.61 1.057-1.22.441-.508 1.5-2.949 5.193-3.254 5.393-4.575v-12.4l2.7-3.05 3.1-3.66-3.345-1.728-.268-1.22h-.179l-3.6.508-1.9 1.627-1 3.152-1.4 3.559-1.6 3.762-1.6 4.169-2.1 1.525-2.5 1.22h-1.9V326.3l-1.1-1.83-12.283.61h-3.2l-2.2 1.83-2.8 3.457-1.9 2.339-2.6.508-2.7.915-3.3 3.152-2.9 2.644-3.012.558.316.764v4.474l1.569 1.729 2.425 3.05 1.1 2.339 1.5 1.22 1.4 1.83.449 1.729-1.148 2.237-.9 1.017-2-.813-2.825-1.83-2.468.407-4.694 3.254-3.3 2.034-3 1.322-2 1.322-1.3 1.322v1.551l.6 2.11.5 1.728-.3 1.423h-2.2l-2-.712-2.6-1.017-2.2.305-1.1.813v2.847l1.1 2.644v4.677h2.6l2.1 1.728 2.2 3.66 1.2 2.847 1 2.44 2.4.915h11.384z"  transform="translate(-5.35 30.382)"/>
															<path id="0027" class="cls-none" d="M266.81 429.012l-2.846-5.338-3.745-6.863-3.3-3.508h-10.181l-.449 5.185-3 .61-4.644 1.83h-3.3l-.9-1.525-2.7-1.22-4.793-3.813-1.947-2.288-1.5-2.593-1.648-2.593-3.445-4.27-2.846-3.66v-4.423l-2.4.305-4.893 1.017-5.073 1.425-2.6-1.83-4.694-2.949-4.194-3.61h-5.792l-3.895-1.373-1.5-1.932-1.2-3.559-1.1-7.219-1.4-9.049-.9-4.677 1.2-2.44 1.9-2.644 1-1.83-1.7-2.542-2.2-3.05-2.7-2.237-2.8-.508-2.9-.508-2.338-1.118-1.057 1.22-1.7.61-1.1 2.644.4 2.542.7 2.034v2.542l-1.8 1.322-2.7 1.627-4.294.2-.9 1.118-1.8 4.474-2.4 3.152-3.1 3.787-3.6 3.126-.9 5.8-2 1.83-3.4 2.339-4.736 4.98-3.795 6.507-3 1.83h-7.689l-2.1 6.914-1 2.237-.6 1.423v1.427l1.847 1.728 4.544 3.254 4.594 4.779h4.399l2.1 1.728 1.8 2.542.7 1.017h5.692l3.6 1.423 2.6 1.729 3.2 1.423h5.492V440.2l2.5.508h2.7l3.4 1.423.8 2.644v2.44l2.3 1.017h2l3.2 1.525 1.9 1.22 2.6.61.7 2.44.5 3.05v3.559l1.5 1.627 3 .813h4.594l2 1.118h3l9.222 6.606 3.2 1.728 1.184.851.514.369 8.189.61 3.2 2.542 3 2.644h9.187l2.8 1.83 2.1 1.118 1.6.61 2.5-1.728 1.4-1.22 1.2-1.118 1.9 1.118 1 1.322.7.61 3-.508 3.5-.915h.8l2.6 1.729 1.5 1.932.9 1.423h1.1l2-.61.7-1.322 1.3-.915 1.1-.712 2.2.2 1.7 1.118.8 1.118 2.7.1v-6.1l1.3-3.559 2.1-1.83 2.2-1.22 2.3-1.525 3.6-2.237 5.393-.508 1.4-2.644 1.7-2.44 1.1-1.728 1.5-1.627.5-1.423 2.5-.508 1.3-.712 2.6-1.322.3-3.355-3.6-2.339-4.194-1.322-3.4-3.457-5.592-6.2-4.344-5.084-4.943-1.373z"  transform="translate(-6.369 28.325)"/>
															<path id="0013" class="cls-none" d="M258.959 278.106l1.947 3.508 2.247.915 2.7-.915 2.546-.915 2.7 1.068 4.044.152 1.947-2.669 2.846-1.449 1.648-1.83 2.7.305 2.846 1.83h2.247l2.4-1.373 2.4-.152 1.049-.153v-3.355l2.546-1.373 6.142-2.593 10.036-5.033 6.142-2.745 4.494-.915v-.914l2.846-2.288.9-2.9 1.348-3.2 1.2-1.525 1.947-1.525 1.8-1.22 4.793-3.813 6.441-5.643 3.895-1.83 4.044-1.22 3.895-1.525 3.3-.915 1.947-3.2 2.546-2.745 7.49-9.913-1.8-2.9-1.947-1.525-3.3-1.068-3.6-2.135-1.8-2.9-4.194-.305-3-.458-3.146.61-2.7 1.068-3.3 1.22-4.191.455-2.846-.458-4.044-.458-4.344.153-3.895-1.525-5.093-.153-2.546 1.373-3.895.763-3.445 1.525-2.547.152-4.793.153-2.4-1.22-4.793-.305-3.645 1.068-3.545 1.525-4.194 3.355h-2.4l-2.1-1.983-1.648-3.2-2.7-5.033-.9 15.4-1.648 2.9.749 1.22 1.8 1.22 2.547 2.44v6.863l-1.8 1.22h-3.6l-3.3 3.2-4.793 5.948-1.947.915-1.648-1.83-2.846-2.745-1.8 1.068-2.247 1.22v12.049l-3.445.458-2.247 2.745.9 3.2 2.1 4.118-.691 2.413 5.185 6.738z"  transform="translate(-16.493 36.479)"/>
															<path id="0011" class="cls-none" d="M195.077 209.525l2.4 2.135 1.5 3.508 1.8 2.288 3.146 1.525 3.6 1.525 1.049 2.135 13.182-.915 1.947-6.711 2.1-5.185 1.573-1.373 4.569 1.525v7.473l-1.5 3.05-.6 2.135h6.441l1.648-3.355 1.5-3.355 1.348-.305 5.243-.61 1.8-3.965 2.7-4.88 2.247-2.745 2.621-1.079 1.723-1.361-.749-3.813-.974-2.44-.674-4.194 1.348-.686 1.8.686 2.4 2.364 1.648 1.373 1.2.458 1.947-1.83 1.5-3.05v-4.27l-2.4-.915v-6.253l-3-1.83-2.4-1.373-5.692-1.678-3.745-1.678 1.8-.915v-4.423l-.749-2.44v-4.118l-1.2-4.728v-3.355l-2.4-1.525-2.846-.915-3.3-1.83-1.2 2.745H229.23l-1.872-1.678-2.172-1.22-1.5-2.593h-1.2l-2.846-2.135-.749-3.2 1.947-2.288-.9-1.678-1.2-1.423v-1.017l-1.2-1.983-2.238-2.597-2.247 3.813v5.8l1.5 3.2-.449 8.083-1.049 4.118-1.955 3.506v6.863l2.4 4.118v2.593l-.749 2.135-2.546 1.83-9.436 6.401-8.838 6.253v8.083l-1.5 1.525-2.846 2.44-.515 3.039 3.96 3.519z"  transform="translate(-11.929 40.852)"/>
															<path id="0016" class="cls-none" d="M135.269 241.761h3.445l1.2 2.135-2.1 1.83-3.444 1.374-1.049.763-.9 2.745-1.391 1.83-2.5.763.9 2.745 2.247 2.9h5.692l1.648.763.9.915 3.895-.763 3.3 1.525 1.5 1.373 2.1-.915 1.2-9.761 5.692-4.118 4.793-2.44 4.644-.763 5.243-.305 2.1-.61 3.146-1.83.9-3.2 1.8-5.185 1.348-5.185-.447-.833-.452-.844h-1.648l-3.895 1.22-6.491.305-4.444 1.068-2.247 3.965-4.044 1.983-2.247-.305-1.2-4.575-3.745.458-3-.458-1.947-1.983-3.445.305-1.049 2.9-1.248 2.44-5.642 1.525-3.338.915v5.338z"  transform="translate(-7.545 35.153)"/>
															<path id="0025" class="cls-none" d="M192.671 481.549l6.891-2.949 1.584-1.589-1.184-.851-3.2-1.728-9.287-6.609h-3l-2-1.118h-4.594l-3-.813-1.5-1.627v-3.559l-.5-3.05-.7-2.44-2.6-.61-1.9-1.22-3.2-1.525h-2l-2.3-1.017V448.4l-.8-2.644-3.4-1.423h-2.7l-2.5-.508v-10.674h-5.492l-3.2-1.423-2.6-1.729-3.6-1.423h-5.692l-.7-1.017-1.8-2.542-2.1-1.728h-20.506l-1.2-1.118-1.6-2.44-1.5-2.339.9-1.118 1.7-1.627-.5-1.525-1.9-1.932-2.2-3.762-1.5-.712-6.58 4.984h-7.39l-2 2.237L80.126 418l-.6 3.457-.4 4.474 1.4 3.05 1 3.66.6 3.66-2.6 2.644-.6 8.744 2.2 2.034 3.795 1.22 3.995 1.423h16.377l1-3.864 12.782.407 7.789 11.184h7.39l3.795 1.423h2.4l3.994 1.83 1.4 2.44h3.6l2.6-1.627h1.6l3.995 2.644 4.394 2.034 3 2.034h4.368l2.8 4.27 1.4 1.83 2 1.83 3.795 2.237 5.393 2.237.564 1.627z" transform="translate(-3.831 24.695)"/>
															<path id="0024" class="cls-none" d="M76.045 433.45l-.6-3.66-1-3.66-1.4-3.05.4-4.474.6-3.457 1.2-4.067 2-2.237h7.39v-10.168l-1-1.22-4.195-1.627-3.994-1.63h-6.791l-1.2-1.423.2-3.1 1-2.593v-2.644l-1.2-3.66-3.795-3.05-1.6-3.457-7.19-1.017h-2.8l-2.4-2.44-3-3.66-3.795-4.474-2.6-4.067-.35-1.017H36.7l-2.4 2.034-1.8 1.017-2.2-1.22-2-.407-1.4 1.627-1.2 1.017h-2.4l-1.2-1.423-2.2.2-2.4 1.22-2.4 2.847-3.795 7.753 2.6 4.448 2.4 3.05-.2 8.744H2.746l-1.6 2.44-1.6 2.644-1.8 2.644h6.198l3.4 7.117 2.6 2.847 5.592 4.27 6.791 5.9 4.793 3.254 5.592 1.627L38.5 424.5l4.194 1.627h7.39l.4 5.287.8 2.44 2.2 1.423 3.4 1.627 3.4 3.66 2.4 3.457 3.795 1.83h3.6l2.8-1.017.6-8.744z"  transform="translate(2.247 27.548)"/>
															<path id="0031" class="cls-none" d="M490.809 391.483l-7.39-14.031.2-4.474-2.8-2.846-.2-3.458 1.4-1.627-3.6-2.034-3.995-5.083-2.4-4.271-3.795-1.627-2.2-2.643-9.387-2.034v-4.067l20.572-17.895.4-1.83-4.793-5.491-.4-3.863-6.391-4.271-1.6-1.22-2.186-8.458-3.856.222-1.947 1.22-.9 1.983-1.8 1.221-2.546-1.526s-2.7-1.678-3.145-1.83-10.636-.457-10.636-.457l-2.246 2.44-2.4 2.44-3.3 1.678-3.3 2.135-3.6 1.525-3.895 1.22-25.166-.915-1.947.763-3.56 2.593-3.445 1.983-4.643 4.118-4.045 1.525-3.145.305-2.4 1.83-3.745 2.44-.15 3.05-1.947 1.525-3.6 2.441-.6 4.88-.45 2.135-4.12 3.66-3.37 3.2-.879-1.292-1.961 3.278-5.093 2.593-2.247 1.067-1.2 2.288 2.1 2.9 1.648.762 3 3.66 2.7 3.965 2.247 1.652 5.542-.737 5.393-1.068 6.74-.153 3.745 1.221v2.9l-3.745 2.44-3 2.135v7.777l1.048 3.509 3.3 1.22 8.089 2.9 4.593-1.627 3.795-.609 2.8-1.83 3.6.609 1.8 1.017 47.135.2v-2.847l-1.8-1.423-.4-3.66 2.2-2.44 5.592 5.9 1.6 3.05 1.6.814 5.792-1.627 6.79-9.965 2.6-3.253 3.6.407 3.2-1.424 4.194 5.288 3.995 8.337 3.4 8.134 1.6 3.457-1 6.71-.2 2.644 1.2 3.253 3.6 1.017 4.194-1.628v-6.71z"  transform="translate(-23.452 30.878)"/>
															<path id="0003" class="cls-none" d="M179.358 8.287l1.2 3.864v12.912l-1.9 3.152-3.1 3.457-3.695 4.474v7.321l2.3 1.728 3.2 2.135-.1 3.66-1.5 3.66-.2 3.457.649 2.339 1.548 3.66v3.457l.1 3.05 3.695 2.44 3.4 1.83 1.4 2.339 1.7.508 7.09.508 3.1 2.542 2.9 3.152 4.494 3.05 3.5 1.627h2.8l1.8-4.067.7-3.355-5.193-2.339.5-7.931-2.7-1.525-2.4-.915 2.1-3.254 3.695-.712 3.994-.61v-5.49l-1.6-2.135-.5-3.152-2-1.83-4.094-2.339-2.2-2.135 1.5-4.88 2.3-4.677 13.659-8.031 1.2-.915 2.247-.763v-2.44l-.749-1.83.749-1.068.9-1.83v-1.83l-1.648-.915-.6-1.373.5-2.491-1.4-.915V3L223.8.966l.8-1.932.349-1.932h-14.03l-2.6-2.847h-3.4l-2.8 1.22v2.237l-1.2 6.914-2 3.66-2.2 4.474-1.8 2.847v1.22h-3.2l-1.8-1.017-1 1.017h-1.8l-1-1.423v-1.83l1.8-.61.8-1.22.2-1.22-1.6-2.034-3.2-1.017-2.4-1.22-2.2-1.627-2.2-1.22-2.23.757.932.972z"  transform="translate(-10.79 48.652)"/>
															<path id="0001" class="cls-none" d="M227.911-1.68l-1.1 2.034v9.863l1.4.915 5.393.813H237l3.1.712.5 3.05.5.813 3.6.508 1.3.915 1.3 3.05-.5 1.728-2.4 1.932-2.1 1.932.3 2.644 2.2 2.034h3.4l3.895-1.017L255 29.99 265.16 9.1l2.4-3.05.2-2.847.8-3.05 10.98-.816 7.989-13.421 3.2-5.287L296.317-21l6.99-1.83 1.8-1.22h5.393l10.186-8.744 1.6-2.034-.2-2.237-2.8-4.067-1.4-3.457-1.2-1.017-2.2-.407-4.186-1.014-3.4-2.644-2.4-1.627h-3.6l-2.2 2.644-1.4 3.864-3.2-3.254-1.8 1.423v7.121h-4.194v-2.644l-5.792.2v4.88L278.32-26.49h-3.994l-4.394 2.034-3.795 2.644-5.193 1.017-19.751 14.032-10.585 1.22h-1.549l-.349 1.932z"  transform="translate(-14.904 51.297)"/>
															<path id="0010" class="cls-none" d="M86.815 128.5l-2.546 3.762-2.7 5.084v2.593c0 .457 6.142 5.8 6.142 5.8l11.534 11.235 4.244 2.8-.649 10.219-1.5.762-3.145-.762-3.445-.763-2.222-.153v5.185h-5.563l-1.348 2.288-1.048 2.288.6 1.983 2.247 3.813 3.145 6.252 1.972 5.186 2.072 5.49h16.777l2.546 3.05 2.4 3.508 1.348 5.49v8.846l2.847 2.9v3.508l2.547 1.22 4.451-1.22 3.338-.916 5.642-1.525 1.248-2.44 1.049-2.9 3.445-.305 1.947 1.983 3 .458 3.745-.458 1.2 4.576 2.246.305 4.045-1.983 2.247-3.965 4.444-1.068 6.491-.3 1.648-2.593 1.049-4.423 2.1-5.338 2.547-6.1.234-1.384.515-3.039 2.832-2.449 1.5-1.525v-8.084l8.838-6.252 9.437-6.406 2.547-1.83.748-2.135v-2.592l-2.4-4.118h-6.142l-2.7 3.508v2.134l-2.272 2.288h-4.469l-1.8-5.8v-6.858l1.348-2.287-1.348-2.9-4.045 3.355-2.1 2.746-1.649-3.66v-4.728l3-3.508 1.648-3.965-.749-4.422-1.2-3.508-4.194-3.66-5.243-4.118-1.8-1.372-4.393 4.219-2.5.2-5.193.61-5.293.61-2.1 3.457-6.591 7.524-2.4.406-3.4-1.016-1.8 1.423-1.6 4.678-3.795 7.321-7.389 2.237h-11.153l-2-3.66-4.394-7.118-2-3.457v-2.034l6.192-16.064 1.8-3.3 2.2-2.39 2.6-2.644v-5.694l-2.8-1.22-1.6-1.83-1-2.034-1-3.457-1.934-5.642-1.263 1.168-3.4 2.237-2 1.83-4.582 1.016-3.6 1.22-2.4 1.627-2 1.627v2.237l2 1.423h2l1 2.237-.6 4.881v1.627l1.8 3.457 1.4 3.253v7.932l-1.6 1.016h-4.589l-1.4-2.44 1.2-2.034 1.8-1.83v-2.644l-1.161-.394-.886 1.41z"  transform="translate(-4.029 42.717)"/>
														</g>
														<g id="_1001_10000" transform="translate(104.356 62.429)">
															<path id="0032" class="cls-none" d="M330.764 260.4v77.94l2.1.762 2.1 1.983 1.5-.915 1.648-.61 1.5 1.525 3 1.372 2.546-1.525 1.648-1.372h1.2l2.247.915.469.69.879 1.292 3.37-3.2 4.12-3.66.45-2.135.6-4.88 3.6-2.441 1.947-1.525.15-3.05 3.745-2.441 2.4-1.83 3.145-.305 4.045-1.525 4.643-4.118 3.445-1.983 3.595-2.592 1.947-.763 25.166.915 3.895-1.22 3.6-1.525 3.3-2.135 3.3-1.678 2.4-2.441 2.246-2.44s10.187.3 10.636.457 3.145 1.83 3.145 1.83L453 299.3l1.8-1.221.9-1.983 1.947-1.22 3.856-.222-1.809-7-1.4-6.3-.6-3.66-2.8-3.66 1.2-14.438.6-5.287-1.2-5.694V242.1l8.389-7.117.8-11.184 6.592-7.117.6-1.627-6.591-9.965h-4.794l-1.4-1.423-2.8.2-1.6 1.83-3.2 1.627-4.593.61-2.4.609-11.185.407-3.795 1.83-11.185.407-2.8-1.423-2.2-1.221-3-.813-3.995 2.236-1.4 2.441-1.2 1.221-4.083-.407-2.308-1.627-4.195-.407-3.4 2.237-2.547 2.592h-8.088l-7.49 9.914-2.547 2.745-1.947 3.2-3.3.915-3.895 1.525-4.044 1.221-3.895 1.83-6.442 5.643-4.793 3.813-1.8 1.22-1.947 1.525-1.2 1.525-1.348 3.2-.9 2.9-2.847 2.288v.915"  transform="translate(-127.045 -25.941)"/>
															<path id="0014" class="cls-none" d="M278.348 174.4H274.3l-1.947 1.525-2.846 1.83-3.445 3.2h-2.546v6.253l2.4.915v4.27l-1.5 3.05-1.947 1.83-1.2-.458-1.648-1.373-2.4-2.364-1.8-.686-1.348.686.674 4.194.974 2.44.749 3.813-1.723 1.361-2.621 1.079-2.247 2.745-2.7 4.88-1.8 3.965-5.243.61-1.348.305-1.5 3.355-1.648 3.355h-6.441l.6-2.135 1.5-3.05v-7.473L226.744 211l-1.573 1.373-2.1 5.185-1.947 6.711-13.182.915-1.049-2.135-3.6-1.525-3.137-1.524-1.8-2.288-1.5-3.508-2.4-2.135-4.044-3.66-3.96-3.519-.234 1.384-2.546 6.1-2.1 5.338-1.049 4.423-1.648 2.593 3.895-1.22h1.648l.452.844 4.791-.844 3.146-1.983h1.5v1.975l1.8 6.1v3.66l3 2.44 3.3 1.983 2.4 1.678 2.846-1.83 3.745-3.05 1.5-1.22h3.445l4.194 1.22 3.895 1.678-1.348 6.711-1.648 4.728.749 5.8 2.247 4.27 9.137 5.49 7.34 4.118h3.895l.357-1.247.691-2.413-2.1-4.118-.9-3.2 2.247-2.745 3.445-.458v-12.051l2.247-1.22 1.8-1.068 2.846 2.745 1.648 1.83 1.947-.915 4.793-5.948 3.3-3.2h3.6l1.8-1.22v-6.863l-2.547-2.44-1.8-1.22-.749-1.22 1.648-2.9.9-15.4 4.644-5.49 2.7-2.135L279.1 193l.9-3.2v-1.678l1.8-4.423 2.1-3.813 2.646-3.66-4.793-3.05-.6-.879-1 2.1z"  transform="translate(-115.672 -24.118)"/>
															<path id="0020" class="cls-none" fill="#7386d8" stroke="#6c7193" stroke-linecap="round" stroke-linejoin="round" stroke-miterlimit="10" d="M136.876 294.378l-.076.138-1.5 1.526-1.648 1.525-3.945.711-1.7 1.83-1.7 3.965-.9 3.66-3.2 17.489-1.4 1.932h-1.2l1.1 3.762 1.8 3.05 1.9 1.627.484 1.169 3.011-.559 2.9-2.644 3.3-3.152 2.7-.915 2.6-.509 1.9-2.339 2.8-3.457 2.2-1.83h3.2l12.283-.61 1.1 1.83v2.034h1.9l2.5-1.22 2.1-1.525 1.6-4.169 1.6-3.762 1.4-3.559 1-3.152 1.9-1.628 3.6-.508h.179l-.179-.814 1.579-3.66 1.214-5.185.9-3.559h-.9l-2.793-.712-2.8-1.627s-4.095-2.441-4.393-2.441a48.419 48.419 0 0 1-4.095-2.846l-.6-1.881.4-1.779 1.7-3.965 1.148-3.559v-2.847l-1.9-2.134 1.549-3.56 1.3-2.44V257l.948-6.915V244.8l-2.1.61-5.244.305-4.643.762-4.793 2.44-5.692 4.118-1.2 9.76-.549.24v4.132l-.9 3.05-1.4 5.288-3.6 5.795-3.3 7.016-1.7 2.948-1.722 3.115"  transform="translate(-111.234 -28.329)"/>
															<path id="0022" class="cls-none" d="M190.877 305.184l-2.9 3.965-3.1 3.66-2.7 3.05v12.4l-5.377 4.581-5.193 3.254-1.5 2.949-.441.508 2.334 1.118 2.9.508 2.8.508 2.7 2.237 2.2 3.05 1.7 2.542-1 1.83-1.9 2.644-1.2 2.44.9 4.677 1.4 9.049 1.1 7.219 1.2 3.559 1.5 1.932 3.895 1.373h5.792l4.194 3.61 4.694 2.949 2.6 1.83 5.093-1.423 4.893-1.017 2.4-.305v-25.014l1.2-2.288 1.947-1.983h15.279l2.846-.763 5.393-3.2 1.8-2.593 2.1-1.678h7.19l2.247-.915 2.846-1.678 3.3-2.288 3.146-2.818h2.7l1.049 1.293 1.947 1.525v-5.374h3.895l3 1.409 3.6 1.148 1.5-1.3 2.4-1.068h4.644l10.186-.152 1.947-.686 2.7-1.906 1.2 1.22 1.2 1.83 1.648.763 2.546-1.525h3.383V263.9l-4.494.915-6.142 2.745-10.034 5.04-6.142 2.593-2.547 1.373v3.355l-1.049.153-2.4.152-2.4 1.373h-2.247l-2.846-1.83-2.7-.305-1.648 1.83-2.846 1.449-1.947 2.669-4.044-.153-2.7-1.068-2.546.915-2.7.915-2.247-.915-1.947-3.508-3.445-3.508-5.185-6.738-.344 1.248h-1.3v2.364l-1.7 8.77-1.8 5.259-1.4 1.146-1.5-1.146-1.8-1.5h-7.689l-2.1-2.44-3.775-3.053-3.2-4.169h-3.1l-.5 2.034 1.3 9.123-3 1.248-3.3 1.728-4.893 2.949-3.4.712-.614.681z"  transform="translate(-114.982 -29.439)"/>
															<path id="0015" class="cls-none" d="M184.581 303.915l.267 1.22 3.346 1.728 2.9-3.965.8-9.558 2.4-.711 2.6-1.932 2.4-12.405 1-5.618 1.1-4.244 2-3.153 2-1.474.6 2.9.9 2.338-1 3.635-1.6 3.889-2.3 4.627-.1 4.118-.9 3.152-.5 3.457.084 2.1.615-.681 3.4-.711 4.893-2.949 3.3-1.728 3-1.248-1.3-9.122.5-2.034h3.1l3.2 4.169 3.795 3.05 2.1 2.44h7.69l1.8 1.5 1.5 1.146 1.4-1.146 1.8-5.259 1.7-8.77v-2.363h-2.6l-7.34-4.118-9.137-5.49-2.247-4.271-.748-5.8 1.648-4.728 1.348-6.711-3.895-1.678-4.194-1.22h-3.446l-1.5 1.22-3.745 3.051-2.846 1.83-2.4-1.678-3.3-1.983-3-2.44v-3.66l-1.8-6.1v-1.983h-1.5l-3.145 1.983-4.79.844.446.834-1.38 5.185-1.8 5.185-.9 3.2-3.146 1.83v5.287l-.948 6.915v5.084l-1.3 2.44-1.549 3.559 1.9 2.134v2.847l-1.148 3.559-1.7 3.965-.4 1.779.6 1.881a48.417 48.417 0 0 0 4.095 2.846c.3 0 4.393 2.441 4.393 2.441l2.8 1.627 2.793.712h.9l-.9 3.559-1.214 5.185-1.576 3.665.179.814"  transform="translate(-115.195 -27.154)"/>
															<path id="0017" class="cls-none" d="M134.113 270.078l.409.5h11.984l1.4-.813.9-3.05v-4.132l-1.548.675-1.5-1.373-3.3-1.525-3.895.763-.9-.915-1.648-.763h-5.692l-2.247-2.9-.9-2.745 2.5-.763 1.391-1.83.9-2.745 1.049-.763 3.445-1.373 2.1-1.83-1.2-2.135h-7.682v-5.338l-4.451 1.22-2.547-1.22-2.1 2.288-5.093 3.965-4.943 3.2.449 2.288 1.2 1.525 4.943 7.473v.712h6.391l2.568 2.339 2.625 2.949 1.9 2.237 1.6 1.932 1.3 1.423.589.72"  transform="translate(-110.556 -27.878)"/>
															<path id="0002" class="cls-none"  d="M246.672 35.113h-3.4l-2.2-2.034-.3-2.644 2.1-1.932 2.4-1.932.5-1.728-1.3-3.05-1.3-.915-3.6-.508-.5-.813-.5-3.05-3.1-.712h-3.4l-5.393-.813-.5 2.491.6 1.373 1.648.915v1.83l-.9 1.83-.749 1.068.749 1.83v2.44l-2.247.763-1.2.915-13.681 8.032-2.3 4.677-1.5 4.88 2.2 2.135 4.094 2.339 2 1.83.5 3.152 1.6 2.135v5.49l-3.995.61-3.695.712-2.1 3.254 2.4.915 2.7 1.525-.5 7.931 5.193 2.339-.7 3.355-1.8 4.067 1.348 6.812 1.8 9.151 1.348 7.931-.749 4.88-1.5 3.355 2.247 2.593 1.2 1.983v1.017l1.2 1.423.9 1.678-1.947 2.288.749 3.2 2.846 2.135h6.291l2.1-.763 1.5-5.8.6-1.6v-4.957l-.749-3.2-1.2-3.508 1.947-3.66.749-2.745v-4.423l-2.4 1.373-1.348 2.9-1.2 2.44-1.8-4.118v-4.728l2.4-3.66 1.348-2.9.749-1.983-.15-2.44-1.2-3.508-.6-1.169-.15-1.576.449-1.678 1.648-2.593 2.147-4.321 6.791-9.151 3.4-7.524 3.994-7.931 1.6-2.237-.4-7.931 1.8-3.864 1-2.644.2-4.474.026-.053-2.922.256z"  transform="translate(-117.749 -14.981)"/>
															<path id="0007" class="cls-none"d="M158.467 90.087l.449 2.593-.449 1.983-2.7 1.373-4.943 1.525 1.049 2.745.749 1.22.6 7.168 1.348.61 3 .763 3.6 3.508 1.847-2.135 2.2-.915 4.294.61 3.2 2.44 1.8 4.88h3.745l3.445-1.83.9-5.185.749-3.813-1.5-2.9-.3-3.2 1.049-1.373.749-3.508-.9-1.678-1.8-1.83-4.194-4.27-3-1.83-1.348-3.2-1.2-4.27-1.4-4.728-.849-3.965h-1.2l-1.8-1.373-2.646-1.983-2.6-1.525-2.1-1.983h-3.3v-8.392h-5.831v-5.186l-1.648-2.694-2.012-.939-.085 1.346-.8 2.44-.8 2.44-.8 2.847-1.2 2.034-.4 1.423.4 2.644h2.4l.6 2.44 1 2.44-1.4 2.034-1.8 1.423-1.6 1.83h-.78l15.21 14.285z"  transform="translate(-112.78 -16.829)"/>
														</g>
													</g>
													<g id="Name_:_Colombia_State" transform="translate(30.644 45.705)">
														<text id="Guajira" class="cls-12" transform="translate(204.408 10)" data-path="0001" data-top="70" data-left="196">
															<tspan x="-14.652" y="0">Guajira</tspan>
														</text>
														<text id="Cesar" class="cls-12" transform="translate(187.919 57.024)" data-path="0002" data-top="118" data-left="172">
															<tspan x="-11.484" y="0">Cesar</tspan>
														</text>
														<text id="Magdalena" class="cls-13" transform="translate(156.814 42.024)" data-path="0003" data-top="104" data-left="112">
															<tspan x="-20.153" y="0">Magdalena</tspan>
														</text>
														<text id="Atlántico" class="cls-13" transform="translate(138.741 28.024)" data-path="0004" data-top="92" data-left="98">
															<tspan x="-16.38" y="0">Atlántico</tspan>
														</text>
														<text id="Norte_de_Aantander" class="cls-13" transform="translate(210.993 120.149)" data-path="0005" data-top="180" data-left="115">
															<tspan x="-15.76" y="0">Norte de</tspan><tspan x="-19.219" y="8">Aantander</tspan>
														</text>
														<text id="Bolívar" class="cls-12" transform="translate(158.741 118.149)" data-path="0006" data-top="176" data-left="135">
															<tspan x="-14.288" y="0">Bolívar</tspan>
														</text>
														<text id="Sucre" class="cls-12" transform="translate(128.74 102.608)" data-path="0007" data-top="161" data-left="110">
															<tspan x="-11.692" y="0">Sucre</tspan>
														</text>
														<text id="Córdoba" class="cls-12" transform="translate(101.489 123.149)" data-path="0008" data-top="181" data-left="69">
															<tspan x="-17.52" y="0">Córdoba</tspan>
														</text>
														<text id="Chocó" class="cls-12" transform="translate(42.563 159.344)" data-path="0009" data-top="221" data-left="22">
															<tspan x="-13.12" y="0">Chocó</tspan>
														</text>
														<text id="Antioquia" class="cls-12" transform="translate(113.814 180.296)" data-path="0010" data-top="238" data-left="77">
															<tspan x="-20.22" y="0">Antioquia</tspan>
														</text>
														<text id="Santander" class="cls-12" transform="translate(184.802 186.288)" data-path="0011" data-top="245" data-left="147">
															<tspan x="-21.484" y="0">Santander</tspan>
														</text>
														<text id="Arauca" class="cls-12" transform="translate(284.641 189.608)" data-path="0012" data-top="251" data-left="262">
															<tspan x="-14.548" y="0">Arauca</tspan>
														</text>
														<text id="Casanare" class="cls-12" transform="translate(261.641 233.95)" data-path="0013" data-top="292" data-left="228">
															<tspan x="-19.1" y="0">Casanare</tspan>
														</text>
														<text id="Boyaca" class="cls-12" transform="translate(202.919 227.45)" data-path="0014" data-top="289" data-left="187">
															<tspan x="-15.008" y="0">Boyaca</tspan>
														</text>
														<text id="Cundinamarca" class="cls-13" transform="translate(163.741 248.608)" data-path="0015" data-top="311" data-left="95">
															<tspan x="-26.632" y="0">Cundinamarca</tspan>
														</text>
														<text id="Caldas" class="cls-13" transform="translate(116.741 232.608)" data-path="0016" data-top="299" data-left="98">
															<tspan x="-11.995" y="0">Caldas</tspan>
														</text>
														<text id="Risaralda" class="cls-13" transform="translate(84.74 239.608)" data-path="0017" data-top="306" data-left="53">
															<tspan x="-16.604" y="0">Risaralda</tspan>
														</text>
														<text id="Quindío" class="cls-13" transform="translate(108.74 269.608)" data-path="0018" data-top="336" data-left="73">
															<tspan x="-14.431" y="0">Quindío</tspan>
														</text>
														<text id="Valle_del_Cauca" class="cls-13" transform="translate(67.74 293.335)" data-path="0019" data-top="358" data-left="4">
															<tspan x="-15.243" y="0">Valle del</tspan><tspan x="-11.193" y="8">Cauca</tspan>
														</text>
														<text id="Tolima" class="cls-12" transform="translate(118.741 293.335)" data-path="0020" data-top="352" data-left="98">
															<tspan x="-13.72" y="0">Tolima</tspan>
														</text>
														<text id="Bogota" font-family="Montserrat-SemiBold, Montserrat" data-path="0021" data-top="330" data-left="160" font-size="10px" font-weight="600" transform="translate(167.741 269.608)">
															<tspan x="0" y="0">Bogota</tspan>
														</text>
														<text id="Meta" class="cls-12" transform="translate(214.919 308.188)" data-path="0022" data-top="367" data-left="202">
															<tspan x="-10.432" y="0">Meta</tspan>
														</text>
														<text id="Cauca" class="cls-12" transform="translate(56.563 346.314)" data-path="0023" data-top="405" data-left="38">
															<tspan x="-12.792" y="0">Cauca</tspan>
														</text>
														<text id="Nariño" class="cls-12" transform="translate(14 380.886)" data-path="0024" data-top="437" data-left="3">
															<tspan x="-13.824" y="0">Nariño</tspan>
														</text>
														<text id="Putumayo" class="cls-12" transform="translate(84.74 421.065)" data-path="0025" data-top="482" data-left="43">
															<tspan x="-21.48" y="0">Putumayo</tspan>
														</text>
														<text id="Huila" class="cls-12" transform="translate(108.74 333.507)" data-path="0026" data-top="396" data-left="96">
															<tspan x="-10.704" y="0">Huila</tspan>
														</text>
														<text id="Caqueta" class="cls-12" transform="translate(155.814 407.505)" data-path="0027" data-top="466" data-left="125">
															<tspan x="-17.416" y="0">Caqueta</tspan>
														</text>
														<text id="Guaviare" class="cls-12" transform="translate(237.702 369.886)" data-path="0028" data-top="427" data-left="205">
															<tspan x="-18.224" y="0">Guaviare</tspan>
														</text>
														<text id="Vaupes" class="cls-12" transform="translate(294.641 410.065)" data-path="0029" data-top="468" data-left="270">
															<tspan x="-15.14" y="0">Vaupes</tspan>
														</text>
														<text id="Amazonas" class="cls-12" transform="translate(262.663 499.776)" data-path="0030" data-top="558" data-left="223">
															<tspan x="-21.54" y="0">Amazonas</tspan>
														</text>
														<text id="Guainia" class="cls-12" transform="translate(362.927 336.314)" data-path="0031" data-top="394" data-left="337">
															<tspan x="-15.72" y="0">Guainia</tspan>
														</text>
														<text id="Vichada" class="cls-12" transform="translate(344.927 263.666)" data-path="0032" data-top="321" data-left="317">
															<tspan x="-16.7" y="0">Vichada</tspan>
														</text>
													</g>
													<!-- // 콜롬비아 수도 영역 -->
													<g id="Name_:_Neighboring_countries" transform="translate(13.315 138.522)">
														<text id="ECUADOR-2" fill="#b0adb5" font-family="Montserrat-SemiBold, Montserrat" font-size="8px" font-weight="600" transform="translate(4.859 407.734)">
																<tspan x="0" y="0">ECUADOR</tspan>
														</text>
														<text id="PERU" class="cls-16" transform="translate(147.108 499.069)">
															<tspan x="0" y="0">PERU</tspan>
														</text>
														<text id="BRASIL" class="cls-16" transform="translate(396.747 423.597)">
															<tspan x="0" y="0">BRASIL</tspan>
														</text>
														<text id="VENEZUELA-2" class="cls-16" transform="translate(349.988 20.863)">
															<tspan x="0" y="0">VENEZUELA</tspan>
														</text>
														<text id="PANAMA-2" class="cls-16" transform="translate(-1 1)">
															<tspan x="0" y="0">PANAMA</tspan>
														</text>
													</g>
												</g>
											</g>
										</g>
									</svg>
									<!-- // 지도 영역 -->
									<!-- 위치 포인트 -->
									<div class="location-tooltip">
										<span class="tooltip tooltip-colombia">Córdoba</span>
									</div>
									<!-- // 위치 포인트 -->
									<!-- 수도 위치 표시 -->
									<div class="location-capital">
										<img src="/static/assets/images/content/ico-capital.png" alt="">
									</div>
									<!-- // 수도 위치 표시 -->
								</div>
								<div class="data-desc">
									<ul class="list">
										<li>0</li>
										<li>1 ~ 100</li>
										<li>101 ~ 1,000</li>
										<li>1,001 ~ 10,000</li>
									</ul>
								</div>
							</div>
							<!-- 마크업 수정 (07.14) -->
							<div class="detail-state">
								<div class="content-row">
									<div class="box-state box-state1">
										<h3 class="title"><spring:message code="contact.text.12" text="Género" /></h3>
										<div class="gv-chart">
											<div class="chart-inner">
												<div class="chart-area"><br/>
													<p class="dummy" id="test111" style="line-height: 188px; text-align: center;"><canvas id="Genero_Canvas" ></canvas></p><!-- // 해당 라인 삭제 후 개발 -->
												</div>
												<ul class="chart-label">
													<li>
														<span class="name">
															<span class="marker" style="background-color: #537bc4;"></span>
															<spring:message code="contact.text.12-1" text="Hombre"/>
														</span>
														<span class="number" id="hombres">0</span>
													</li>
													<li>
														<span class="name">
															<span class="marker" style="background-color: #e65441;"></span>
															<spring:message code="contact.text.12-2" text="Mujer"/>
														</span>
														<span class="number" id="mujer">0</span>
													</li>
													<li>
														<span class="name">
															<span class="marker" style="background-color: #25cdb3;"></span>Others
														</span>
														<span class="number" id="nosex">0</span>
													</li>
													<li>
														<span class="name">
															<span class="marker" style="background-color: #ffde5a;"></span>ETC
														</span>
														<span class="number" id="etc">0</span>
													</li>
												</ul>
											</div>
										</div>
									</div>
									<div class="box-state box-state2">
										<h3 class="title"><spring:message code="dashboard.text10" text="Envejecer" /></h3>
										<div class="chart-area">
											<p class="dummy" style="line-height: 188px; text-align: center;"><canvas id="Envejecer_Canvas" ></canvas></p><!-- // 해당 라인 삭제 후 개발 -->
										</div>
									</div>
								</div>
								<div class="content-row">
									<div class="box-state box-state3">
										<h3 class="title"><spring:message code="dashboard.text11" text="Nivel de Educación" /></h3>
										<div class="gv-chart">
											<div class="chart-inner">
												<div class="chart-area"><br/>
													<p class="dummy" style="line-height: 188px; text-align: center;"><canvas id="Educacion_Canvas" ></canvas></p><!-- // 해당 라인 삭제 후 개발 -->
												</div>
												<ul class="chart-label" id="educationView">
													
												</ul>
											</div>
										</div>
									</div>
									<div class="box-state box-state4">
										<h3 class="title"><spring:message code="dashboard.text12" text="Experiencia laboral" /></h3>
										<div class="chart-area">
											<p class="dummy" style="line-height: 188px; text-align: center;"><canvas id="Experiencia_Canvas" ></canvas></p><!-- // 해당 라인 삭제 후 개발 -->
										</div>
									</div>
								</div>
								<div class="content-row">
									<div class="box-state box-state5">
										<h3 class="title"><spring:message code="dashboard.text13" text="Sectores" /></h3>
										<div class="gv-chart">
											<div class="chart-inner">
												<div class="chart-area"><br/><br/>
													<p class="dummy" style="line-height: 208px; text-align: center;"><canvas id="Sectores_Canvas" ></canvas></p><!-- // 해당 라인 삭제 후 개발 -->
												</div>
												<ul class="chart-label" id="jobNameView">
																									
												</ul>
											</div>
										</div>
									</div>
								</div>
							</div>
							<!-- // 마크업 수정 (07.14) -->
						</div>
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