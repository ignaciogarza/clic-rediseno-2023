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
	
	<!-- 페이지 개별 스크립트 -->
	<script src="/static/common/js/Chart.min.js"></script>
    <script src="/static/common/js/utils.js"></script>	
	<script src="/static/assets/js/jquery.DonutWidget.js"></script>
	<script>
	var userId = "${userId}";
	
	$(document).ready(function () {
		
		search();	
		
		fnPortfolioChart();
		
	});
	
	function search(){
		
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        url : '/community/communityMainList',
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
	          
	          
	          
	         	          
	          //요청받은 친구 목록 
	          var friendReceptionList = resultList.friendReceptionList;  
	          var receptionHtml = '';
	          $("#receptionForm").empty();	          
	          if(friendReceptionList != null && friendReceptionList.length > 0){	
	        	  receptionHtml += '	<div class="community-list community-friend">';
	        	  for (var i = 0; i < friendReceptionList.length; i++) {
					receptionHtml += '		<div class="item">	';        			  
					receptionHtml += '			<div class="profile-area">';
					receptionHtml += '				<div class="profile-frame">';
					receptionHtml += '					<div class="photo">';
					receptionHtml += '							<img src="'+friendReceptionList[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
					receptionHtml += '					</div>';
					receptionHtml += '					<div class="country">';
					receptionHtml += '							<img src="https://flagcdn.com/w640/'+friendReceptionList[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
					receptionHtml += '					</div>';
					receptionHtml += '				</div>';
					receptionHtml += '				<div class="profile-info">';
					receptionHtml += '					<span class="name">'+friendReceptionList[i].name+' '+ friendReceptionList[i].firstName+'</span>';
					//receptionHtml += '					<span class="career">'+friendReceptionList[i].jobNameEng+'</span>';
					receptionHtml += '				</div>';
					receptionHtml += '			</div>';
					receptionHtml += '			<div class="community-ctrl">';
					receptionHtml += '				<button type="button" class="btn btn-approve" onclick="fuApprovalFriend(\''+friendReceptionList[i].userId+'\')"><spring:message code="button.accept" text=""/></button>';
					receptionHtml += '				<button type="button" class="btn btn-cancle" onclick="fuRejectFriend(\''+friendReceptionList[i].userId+'\')"><spring:message code="button.cancel" text=""/></button>';
					receptionHtml += '			</div>';
					receptionHtml += '		</div>';	        			
				  }	 
	        	  receptionHtml += '	</div>	';	
	          }else{	        	 
	        	  receptionHtml += '<div class="no-data">';
	        	  receptionHtml += '	<i class="ico ico-community"></i>';
	        	  receptionHtml += '	<p class="text"><spring:message code="community.text16" text=""/></p>';
	        	  receptionHtml += '	<a href="/community/communityRecommendFriendView" class="btn btn-md btn-secondary"><spring:message code="friend.text8" text="Encuentra un amigo"/></a>';
	        	  receptionHtml += '</div>';
	          }	         
	          $("#receptionForm").append(receptionHtml);
	          
	          
	          //추천친구
	          var recommendFriendList = resultList.recommendFriendList;   
	          var recommendHtml = '';
	          $("#recommendForm").empty();	          
	          if(recommendFriendList != null && recommendFriendList.length > 0){
	        	  recommendHtml += '<div class="community-list community-friend">';
	        	  for (var i = 0; i < recommendFriendList.length; i++) {						
	        		  <!-- 친구 목록이 있을 경우 -->
	        		  recommendHtml += '	<div class="item">';
	        		  recommendHtml += '		<div class="profile-area">	';
	        		  recommendHtml += '			<div class="profile-frame">';
	        		  recommendHtml += '				<div class="photo">';
	        		  recommendHtml += '							<img src="'+recommendFriendList[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
	        		  recommendHtml += '				</div>';
	        		  recommendHtml += '				<div class="country">';
	        		  recommendHtml += '							<img src="https://flagcdn.com/w640/'+recommendFriendList[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
	        		  recommendHtml += '				</div>';
	        		  recommendHtml += '			</div>';
	        		  recommendHtml += '			<div class="profile-info">';
	        		  recommendHtml += '				<span class="name">'+recommendFriendList[i].name+' '+ recommendFriendList[i].firstName+'</span>';
	        		  //recommendHtml += '				<span class="career">'+recommendFriendList[i].jobNameEng+'</span>';
	        		  recommendHtml += '			</div>'; 
	        		  recommendHtml += '		</div>';
	        		  recommendHtml += '		<div class="community-ctrl">';
	        		  recommendHtml += '			<button type="button" class="btn btn-add" onclick="fuFriendRequest(\''+recommendFriendList[i].userId+'\')">add</button>';
	        		  recommendHtml += '		</div>';
	        		  recommendHtml += '	</div>';
				  }	        	
	        	  recommendHtml += '</div>';	 
	          }else{
	        	  recommendHtml += '<div class="no-data">';
	        	  recommendHtml += '<i class="ico ico-community"></i>';
	        	  recommendHtml += '<p class="text"><spring:message code="community.message2" text=""/></p>';					
				  recommendHtml += '</div>';
	          }
	          $("#recommendForm").append(recommendHtml);
	          
	         
	          var friendCheckList = resultList.friendCheckList;  //친구 조회
	          
	          //스킬 요청 데이터 세팅 
	          var skillList = resultList.skillList;			//스킬 완료 조회 
	          var skillSendList = resultList.skillSendList;		//스킬 보낸 인증 
	          var skillReceptionList = resultList.skillReceptionList;	//스킬 받은 인증 
	          var skillHtml = '';
	          $("#skillAllForm").empty();	          
	          if((skillList != null && skillList.length > 0) || (skillSendList != null && skillSendList.length > 0) || (skillReceptionList != null && skillReceptionList.length > 0)){	
	        	  skillHtml += '<div class="community-list community-skill">';
	        	  for (var i = 0; i < skillList.length; i++) {	
	        		  skillHtml += '	<div class="item">';
	        		  skillHtml += '		<div class="profile-area">';	
	        		  skillHtml += '			<div class="profile-frame">';
	        		  skillHtml += '				<div class="photo">';
	        		  skillHtml += '							<img src="'+skillList[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
	        		  skillHtml += '				</div>';
	        		  skillHtml += '				<div class="country">';
	        		  skillHtml += '							<img src="https://flagcdn.com/w640/'+skillList[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
	        		  skillHtml += '				</div>';		
	        		  for (var j = 0; j < friendCheckList.length; j++) {		        		  
		        		  if(friendCheckList[j].friendId == skillList[i].userId){
		        			  skillHtml += '				<div class="stat"><i class="ico ico-connect"></i></div> ';
		        		  }		        		
	        		  }	        		 
	        		  skillHtml += '			</div>';
	        		  skillHtml += '			<div class="profile-info">';
	        		  skillHtml += '				<span class="name">'+skillList[i].name+' '+ skillList[i].firstName+'</span>';
	        		  //skillHtml += '				<span class="career">'+skillList[i].jobNameEng+'</span>';
	        		  skillHtml += '			</div>';
	        		  skillHtml += '		</div>';
	        		  skillHtml += '		<div class="content">	';	
	        		  skillHtml += '			<p class="name">'+skillList[i].skillNameEng+'</p>';
	        		  skillHtml += '			<p class="text"><spring:message code="community.message12" text="La autenticación está completa"/></p>';
	        		  skillHtml += '		</div>';
	        		  skillHtml += '		<div class="community-ctrl">';													
	        		  skillHtml += '			<a href="/community/communitySkillAllView" class="btn btn-sm btn-secondary"><spring:message code="button.check" text="Confirmar"/></a>';
	        		  skillHtml += '		</div>';
	        		  skillHtml += '	</div>';
				  }	
				  for (var i = 0; i < skillSendList.length; i++) {
					  skillHtml += '	<div class="item">';
					  skillHtml += '		<div class="profile-area">	';
					  skillHtml += '			<div class="profile-frame">';
					  skillHtml += '				<div class="photo">';
					  skillHtml += '							<img src="'+skillSendList[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
					  skillHtml += '				</div>';
					  skillHtml += '				<div class="country">';
					  skillHtml += '							<img src="https://flagcdn.com/w640/'+skillSendList[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
					  skillHtml += '				</div>';
					  for (var j = 0; j < friendCheckList.length; j++) {		        		  
		        		  if(friendCheckList[j].friendId == skillSendList[i].userId){
		        			  skillHtml += '				<div class="stat"><i class="ico ico-connect"></i></div> ';
		        		  }		        		
	        		  }	
					  skillHtml += '			</div>';
					  skillHtml += '			<div class="profile-info">';
					  skillHtml += '				<span class="name">'+skillSendList[i].name+' '+ skillSendList[i].firstName+'</span>';
					  //skillHtml += '				<span class="career">'+skillSendList[i].jobNameEng+'</span>';
					  skillHtml += '			</div>';
					  skillHtml += '		</div>';
					  skillHtml += '		<div class="content">';
					  skillHtml += '			<p class="name">'+skillList[i].skillNameEng+'</p>';
					  //skillHtml += '			<p class="text"><spring:message code="community.message7" text="Aún no me he certificado"/></p>';
					  skillHtml += '		</div>';
					  skillHtml += '		<div class="community-ctrl">';
					  skillHtml += '			<a href="#;" class="btn btn-sm btn-outline-gray" onclick="fnAgainSkillFriendAuth(\''+skillSendList[i].userId+'\',\''+skillSendList[i].skillCode+'\',\''+skillSendList[i].examClassCode+'\')"><spring:message code="community.text5" text="Recordar"/></a>';
					  skillHtml += '		</div>';
					  skillHtml += '	</div>';        		  
				  }	
				  for (var i = 0; i < skillReceptionList.length; i++) {	
					  skillHtml += '	<div class="item">';
					  skillHtml += '		<div class="profile-area">';	
					  skillHtml += '			<div class="profile-frame">';
					  skillHtml += '				<div class="photo">';
					  skillHtml += '					<img src="'+skillReceptionList[i].userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';"alt="">';
					  skillHtml += '				</div>';
					  skillHtml += '				<div class="country">';
					  skillHtml += '					<img src="https://flagcdn.com/w640/'+skillReceptionList[i].countryCode.toLowerCase()+'.png" alt="" onerror="this.src=\'/static/assets/images/common/_img-flag.png\';" alt="">';
					  skillHtml += '				</div>';
					  for (var j = 0; j < friendCheckList.length; j++) {		        		  
		        		  if(friendCheckList[j].friendId == skillReceptionList[i].userId){
		        			  skillHtml += '				<div class="stat"><i class="ico ico-connect"></i></div> ';
		        		  }		        		
	        		  }	
					  skillHtml += '			</div>';
					  skillHtml += '			<div class="profile-info">';
					  skillHtml += '				<span class="name">'+skillReceptionList[i].name+' '+ skillReceptionList[i].firstName+'</span>';
					  //skillHtml += '				<span class="career">'+skillReceptionList[i].jobNameEng+'</span>';
					  skillHtml += '			</div>';
					  skillHtml += '		</div>';
					  skillHtml += '		<div class="content">';
					  skillHtml += '			<p class="name">'+skillReceptionList[i].skillNameEng+'</p>';
					  skillHtml += '			<p class="text">';
					  if(skillReceptionList[i].isAuth   == 'R'){
						  skillHtml += '				<spring:message code="community.message9" text="Autentíquese"/>';
					  }else if(skillReceptionList[i].isAuth   == 'Y'){
						  skillHtml += '				<spring:message code="community.message12" text="Autentíquese"/>';
					  }
					  skillHtml += '			</p>';
					  skillHtml += '		</div>';
					  skillHtml += '		<div class="community-ctrl">';
					  if(skillReceptionList[i].isAuth   == 'R'){
						  skillHtml += '			<a href="#;" class="btn btn-sm btn-secondary" onclick="fnCertificateMove(\''+skillReceptionList[i].userId+'\',\''+skillReceptionList[i].skillCode+'\',\''+skillReceptionList[i].examClassCode+'\')"><spring:message code="community.text19" text="Certificación"/></a>';
					  }else if(skillReceptionList[i].isAuth   == 'Y'){
						  skillHtml += '			<a href="/community/communitySkillReceptionView" class="btn btn-sm btn-secondary" >completada</a>';
					  }					  
					  skillHtml += '		</div>';
					  skillHtml += '	</div>';
				  }	
				  skillHtml += '	</div>';
	          }else{ 
		        	skillHtml += '<div class="no-data">';
		        	skillHtml += '	<i class="ico ico-skill"></i>';
		        	skillHtml += '	<p class="text"><spring:message code="community.message1" text=""/></p>';
		        	skillHtml += '	<a href="/eval/list" class="btn btn-md btn-secondary">Prueba de habilidad</a>';
		        	skillHtml += '</div>';
	          }
	          $("#skillAllForm").append(skillHtml);
	          
	          
	        
	           
	       },error:function(){
	    	   alert("Failed to fetch data.");
	       }
	    }); 
	}
	
	//포토폴리오 열람 그래프   https://doolyit.tistory.com/225    https://yeahvely.tistory.com/6
	function fnPortfolioChart(){		
		 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : {"userId" : friendId },
	        url : '/community/portfolioChart',
	        success : function(response) {
	          var resultList = response.data;
	          var portfolioCountList1 = resultList.portfolioCountList1;
	          var portfolioCountList2 = resultList.portfolioCountList2;
	          var portfolioCountList3 = resultList.portfolioCountList3;
	          
	          $("#chartNoData").hide();
	          $("#chartData").hide();
	          
	          if(portfolioCountList1 == null && portfolioCountList2 == null && portfolioCountList3 == null){
	        	 $("#chartNoData").show();
	          }else{
	        	  $("#chartData").show();
	        	  var labelsData;
		          //var chartDateList = resultList.chartDateList;	          
		          //var labelsData = [chartDateList[6].chartDate, chartDateList[5].chartDate, chartDateList[4].chartDate, chartDateList[3].chartDate, chartDateList[2].chartDate,
	            //	  chartDateList[1].chartDate, chartDateList[0].chartDate];
		         
		          //var chartDateList = resultList.chart1;	          
		          var labelsData = [resultList.chartDate1, resultList.chartDate2, resultList.chartDate3, resultList.chartDate4, resultList.chartDate5,
		        	  resultList.chartDate6, resultList.chartDate7];
		          
		          var data1;
		          var data2;
		          var data3;
		         if(portfolioCountList1 != null){
		        	 data1 = [portfolioCountList1.chart1, portfolioCountList1.chart2, portfolioCountList1.chart3, portfolioCountList1.chart4, portfolioCountList1.chart5,
			        	 portfolioCountList1.chart6, portfolioCountList1.chart7];
		         }
		         
		         if(portfolioCountList2 != null){
		        	 data2 = [portfolioCountList2.chart1, portfolioCountList2.chart2, portfolioCountList2.chart3, portfolioCountList2.chart4, portfolioCountList2.chart5,
			        	 portfolioCountList2.chart6, portfolioCountList2.chart7];
		         }
		         
		         if(portfolioCountList3 != null){
		        	 data3 = [portfolioCountList3.chart1, portfolioCountList3.chart2, portfolioCountList3.chart3, portfolioCountList3.chart4, portfolioCountList3.chart5,
		        		 portfolioCountList3.chart6, portfolioCountList3.chart7];
		         }
		         
		         var color = Chart.helpers.color;
		         var dataSetting= [];
		         if(portfolioCountList1 != null){	        	
		        	 dataSetting.push(
		        			 {
				  	                label: '<spring:message code="main.portfolio.text2" text="" />1',  // 데이터셑의 이름                
				  	                pointRadius: 5, // 꼭지점의 원크기
				  	                pointHoverRadius: 10, // 꼭지점에 마우스 오버시 원크기   
				  	                backgroundColor: color(window.chartColors.red).alpha(0.5).rgbString(), // 챠트의 백그라운드 색상
				  	                borderColor: window.chartColors.red, // 챠트의 테두리 색상
				  	                borderWidth: 1, // 챠트의 테두리 굵기
				  	                //lineTension:0, // 챠트의 유연성( 클수록 곡선에 가깝게 표시됨)
				  	                fill:false,  // 선챠트의 경우 하단 부분에 색상을 채울지 여부                  
				  	                //data: [18,21,13,44,35,26,54,17,32,23,22,35,0]  // 해당 데이터셋의 데이터 리스트
				  	                //data: [18,1,13,44,35,26,54]  // 해당 데이터셋의 데이터 리스트
				  	              	data: data1
				  	            }		 
		        	 );
		         }
		         
		         if(portfolioCountList2 != null){	        	 
		        	 dataSetting.push({
				  	                label: '<spring:message code="main.portfolio.text2" text="" />2', 
				  	                pointRadius: 5,
				  	                pointHoverRadius: 10,                                    
				  	                backgroundColor: color(window.chartColors.green).alpha(0.5).rgbString(), 
				  	                borderColor: window.chartColors.green, 
				  	                borderWidth: 1,
				  	                //lineTension:0, 
				  	                fill:false, 
				  	                //data: [31,24,23,12,25,14,37] // 해당 데이터셋의 데이터 리스트
				  	                data : data2
				  	            });
		         }
		         
		         if(portfolioCountList3 != null){	        	
		        	 dataSetting.push({
		  	                label: '<spring:message code="main.portfolio.text2" text="" />3', 
		  	                pointRadius: 5,
		  	                pointHoverRadius: 10,                                    
		  	                backgroundColor: color(window.chartColors.yellow).alpha(0.5).rgbString(),  //blue  yellow
		  	                borderColor: window.chartColors.yellow, 
		  	                borderWidth: 1,
		  	                //lineTension:0, 
		  	                fill:false,
		  	                //data: [11,20,29,30,25,6,27] // 해당 데이터셋의 데이터 리스트
		  	                data : data3
		  	            });
		         }
		        	          
		          
		          var ChartData = {            
		              //labels: ['1월', '2월', '3월', '4월', '5월', '6월', '7월', '8월', '9월', '10월', '11월', '12월'], // 챠트의 항목명 설정
		              labels : labelsData,
		              datasets: dataSetting	   
		          };
		   
		          //window.onload = function() {
		          //var ctx = document.getElementById('canvas').getContext('2d');
		          var ctx = $("#canvas")[0].getContext('2d');
		          window.myHorizontalBar = new Chart(ctx, {
		              // type 을 변경하면 선차트, 가로막대차트, 세로막대차트 등을 선택할 수 있습니다 
		              // ex) horizontalBar, line, bar, pie, bubble
		              type: 'line', 
		              data: ChartData,
		              options: {
		                  responsive: true,                    
		                  maintainAspectRatio: false    
		                  /* title: {
		                      display: true
		                      ,text: '2021년 영업현황'
		                  } */
		                  
		              }
		          }); 
	          }
	          
	          var filter = 'win16|win32|win64|mac|macintel';
				
    		  if(navigator.platform) {
        		  if(filter.indexOf(navigator.platform.toLowerCase()) < 0 || $(window).width() < 1024) {
        			  $('#chartType').attr("style",'width: 80%;height:15%;position: absolute; ');
        			  $('#canvas').attr("style",'display: block; width: 380px; height: 250px;');
        		  } else {
        			  $('#chartType').attr("style",'width: 530px;height:250px;');
        			  $('#canvas').attr("style",'display: block; width: 530px; height: 250px;');
        		  }
    		  } 
	          
	          
	       },error:function(){
	    	   alert("Failed to fetch data.");
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
	
	//재요청  
	function fnAgainSkillFriendAuth(friendId, skillCode, examClassCode){
		var data = {
				userId : userId,
				friendId : friendId,
				skillCode : skillCode,
				examClassCode : examClassCode
		};
		
		$.ajax({
			url: '/community/againSkillFriendAuth',
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
	
	//요청인증 팝업 조회 
	function fnCertificateMove(friendId,  skillCode, examClassCode){
		
		$("#userIds").val(userId);
		$("#friendIds").val(friendId);
		$("#skillCodes").val(skillCode);
		$("#examClassCodes").val(examClassCode);

		var fullName = '${sessionScope.fullName}';
		
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
	        	  html += '<img src="'+userInfo.userImagePath+'" alt="">';
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
				userId : userId,
				friendId : friendId,
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
	function fnPortfolioList(friendId, name, firstName, jobNameEng){
		
		$("#fullName").text(name+" "+firstName);
		$("#popJobName").text(jobNameEng);
		 
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
	<style>
    canvas {
        -moz-user-select: none;
        -webkit-user-select: none;
        -ms-user-select: none;
    }
    </style>
</head>
<body>
	<div class="wrapper">
		<!-- header Start -->
		<jsp:include page="../common/header.jsp"></jsp:include>
		<!-- header End -->
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
							<dt><a href="/community/communityFriendAllView"><spring:message code="community.text7" text="Todos los amigos"/> </a></dt>
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
				<div class="community-wrap mt-lg-8 mt-md-5">
					<div class="content-row">
						<div class="col-item">
							<div class="clearfix">
								<div class="float-left">
									<h3 class="title1 mt-0 mb-md-2"><spring:message code="community.text1" text="Solicitudes"/></h3>
								</div>
								<div class="float-right">
									<a href="/community/communityFriendReceptionView" class="btn-more"><spring:message code="community.text18" text="more"/></a>
								</div>
							</div>
							<!-- 요청받은 친구 목록  -->
							<div class="box box-shadow box-round box-community" id="receptionForm">
															
							</div>

							<div class="clearfix mt-lg-12 mt-md-8">
								<div class="float-left">
									<h3 class="title1 mt-0 mb-md-2"><spring:message code="community.text3" text="Sugerencias"/></h3>
								</div>
								<div class="float-right">
									<a href="/community/communityRecommendFriendView" class="btn-more"><spring:message code="community.text18" text="more"/></a>
								</div>
							</div>
							
							<!-- 추천친구  -->
							<div class="box box-shadow box-round box-community" id="recommendForm">
								
							</div>
						</div>

						<div class="col-item-fit">
							<div class="clearfix mt-md-8">
								<div class="float-left">
									<h3 class="title1 mt-0 mb-md-2"><spring:message code="community.text2" text="Validaciones"/></h3>
								</div>
								<div class="float-right">
									<a href="/community/communitySkillSendView" class="btn-more"><spring:message code="community.text18" text="more"/></a>
								</div>
							</div>
							<div class="box box-shadow box-round box-community" id="skillAllForm">								
								
							</div>

							<div class="clearfix mt-lg-12 mt-md-8">
								<div class="float-left">
									<h3 class="title1 mt-0 mb-md-2"><spring:message code="community.text4" text="Quien vio tu portafolio"/></h3>
								</div>
								
							</div>
							<div class="box box-shadow box-round box-community">
								<!-- 등록된 포트폴리오가 없을 경우 -->
								<div class="no-data" id="chartNoData" style="display:none">
									<em class="ico ico-portfolio"></em>
									<p class="text"><spring:message code="community.message3" text=""/></p>
									<a href="/studio/portfolio/portfolioFrom" class="btn btn-md btn-secondary">portafolio</a>
								</div>
								<!-- // 등록된 포트폴리오가 없을 경우 -->
								<!-- 등록된 포트폴리오가 있을 경우 -->
								<div class="chart-area" id="chartData" style="display:none">
									
									<p id="chartType" >
									
										<canvas id="canvas" ></canvas>
									</p><!-- // 해당 라인 삭제 후 개발 -->
								</div>
								<!-- // 등록된 포트폴리오가 있을 경우 -->
							</div>
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
								<div class="stat">
									<em class="ico ico-connect"></em>
								</div>
							</div>
							<div class="profile-info">
								<span class="name friendName">Julio Cesar Torres</span>
								<!-- <span class="career friendJob">Estudiante</span> -->
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
						<textarea cols="30" rows="3" class="form-control full" id="authContents" ><spring:message code="community.message10" text=""/></textarea>
					</div>
					<div class="btn-group-default btn-fixed">
						<a href="#;" class="btn btn-md btn-gray d-up-lg" onclick="closeModal('#layer-certificate');">cancelar</a>
						<button type="button" class="btn btn-md btn-primary" onclick="fuCompleteSkillDel()">Negación</button>
						<button type="button" class="btn btn-md btn-secondary" onclick="fuCompleteSkillAuth()">Certificación</button>
						
					</div>
				
			</div>
		</div>
	</div>

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
								<span class="name" id="fullName">Julio Cesar Torres</span>
								<!-- <span class="career" id="popJobName">Estudiante</span> -->
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
				
				<!-- 포트폴리오 view -->
				<div id="portfolioForm">
				</div>
			</div>
		</div>
	</div>
</body>
</html>