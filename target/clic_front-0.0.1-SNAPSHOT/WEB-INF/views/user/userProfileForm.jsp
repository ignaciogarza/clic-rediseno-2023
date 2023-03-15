<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="es">
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
	var isComplete;	
	var questionIdList;
	
	$(document).ready(function () {
		
		getList();	
		
	   //년/월/일 선택된 값 세팅 
	   $("#year").change(function() {   $("#year").val($(this).val()).prop("selected", true);   });
	   $("#month").change(function() {  $("#month").val($(this).val()).prop("selected", true);  });
       $("#day").change(function() {    $("#day").val($(this).val()).prop("selected", true);    });
       
       
       //국가코드
       $("#country").change(function() {   $("#country").val($(this).val()).prop("selected", true);   });
	   	   
	   //도시코드
	   $("#city").change(function() {   $("#city").val($(this).val()).prop("selected", true);   });
	   
       // 학력 선택
       $("#educationCode").change(function() {   $("#educationCode").val($(this).val()).prop("selected", true);   });
       
       //직업 코드	  
       $("#jobId").change(function() {   $("#jobId").val($(this).val()).prop("selected", true);   });
		
       //경력 선택
       $("#careerCode").change(function() {   $("#careerCode").val($(this).val()).prop("selected", true);   });
	
	
      //프로필 이미지 미리보기 
      $(function() {
           $("#upload-file-input").on('change', function(){   
        	   var fileName =  $("#upload-file-input").val(); 
          		fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
          		if(fileName == "jpg" && fileName == "png" &&  fileName == "gif" &&  fileName == "bmp"){
          			 readURL(this);
          		}
              
           });
       });
       function readURL(input) {
           if (input.files && input.files[0]) {
              var reader = new FileReader();
              reader.onload = function (e) {
                 $('#preImage').attr('src', e.target.result);
              }
              reader.readAsDataURL(input.files[0]);
           }
       }
	
	});
	
	
	/* //비빌번호 체크  
	function fnPwCheckForm(){
				
		var passwordCk = $("#passwordCk").val();
		var passwordOld = "${userDetail.password}";
		var data = {
				password : passwordCk
				//password : passwordCk,
				//passwordOld : passwordOld
		};	
	
		$.ajax({
			url: '/user/userPwCheck',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				var result = response.data;
				if(result == true){					
					//프로필 저장  
					//fnSubmitBt()
					//프로필 화면으로 이동 
					location.href="/user/userProfileForm";
				}else{
					alert(response.message);
				}
			}
		});
	} */
	
	
	function getList(){
		 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : {"userId" : userId },
	        url : '/user/userProfileList',
	        success : function(response) {
	          isComplete = response.data.isComplete;
        	  //설무조사 영역 		
	  		  if(isComplete == "Y"){
	  			$("#surveyForm").hide();
	  			//$("#caution").hide();
	  		  }else{
	  			$("#surveyForm").show();
	  			//$("#caution").show();
	  		  }	 
	          
	          var userDetail = response.data.userDetail;
		  		
		  	   ///////////// 데이터 세팅 Start /////////////
		  	  $("#preImage").attr("src", userDetail.userImagePath);
		      
		      $("#userName").text(userDetail.name+" "+userDetail.firstName);
		      //$("#userJob").text(userDetail.jobNameEng);
		      
		      $("#preImages").attr("src", userDetail.userImagePath);
		      
		      $("#userNames").text(userDetail.name+" "+userDetail.firstName);
		      //$("#userJobs").text(userDetail.jobNameEng);
		      
		      if(userDetail.countryCode != null){
		    	  $("#userCountry").attr("src", "https://flagcdn.com/w640/"+userDetail.countryCode.toLowerCase()+".png"); 
		    	  $("#userCountrys").attr("src", "https://flagcdn.com/w640/"+userDetail.countryCode.toLowerCase()+".png");
		      }
		      
		      		      
		      $("#userId").val(userDetail.userId);
		      $("#email").val(userDetail.email);
		      $("#name").val(userDetail.name);
		      $("#firstName").val(userDetail.firstName);
		      $("#tell").val(userDetail.tell);
		  	   
		  	   
		  	   // select box 연도 , 월 일 표시		
		  	   var year = userDetail.year;
		  	   var month = userDetail.month;
		  	   var day = userDetail.day;
		  	   
		  	   //select box 연도 , 월 일 데이터 세팅	
			   setDateBox(year,month,day);	
		  	   
		  	   //성별 체크
		       var sexCode = userDetail.sexCode;       
		       if(sexCode == "0301"){
		      	   $("#sexCode_01").prop('checked', true); 
		       }else if(sexCode == "0302"){
		      	   $("#sexCode_02").prop('checked', true); 
		       }else if(sexCode == "0303"){
		      	   $("#sexCode_03").prop('checked', true); 
		       }      
		         
		       
	          
	          
	          //국가  
	          var countryList = response.data.countryList;
	          var countryHtml = '';
	          $("#country").empty(countryHtml);
	          countryHtml += '<option selected value=""><spring:message code="contact.text.18" text="" /></option>  '; 
	          for (var i = 0; i < countryList.length; i++) {	        	  
	        	  countryHtml += '<option  value="'+countryList[i].countryCode+'">'+countryList[i].countryName+'</option>';
	          }
	          $("#country").append(countryHtml);
	          	    
	          //직업
	          var jobList = response.data.jobList;
	          var jobHtml = '';
	          $("#jobId").empty(jobHtml);
	          	  jobHtml += '<option selected value="">Seleccionar</option>  '; 
	          for (var i = 0; i < jobList.length; i++) {
	        	  jobHtml += '<option value="'+jobList[i].jobId+'">'+jobList[i].jobName+'</option>';
	          }
	          $("#jobId").append(jobHtml);
	          	          
	          
	          //교육
	          var educationList = response.data.educationList;
	          var educationHtml = '';
	          $("#educationCode").empty(educationHtml);
	          	  educationHtml += '<option selected value="">Seleccionar</option>'; 
	          for (var i = 0; i < educationList.length; i++) {
	        	  educationHtml += '<option value="'+educationList[i].major+educationList[i].minor+'">'+educationList[i].name+'</option>';
	          }
	          $("#educationCode").append(educationHtml);
	          
	          //경력
	          var careerList = response.data.careerList;
	          var careerHtml = '';
	          $("#careerCode").empty(careerHtml);
	          	  careerHtml += '<option selected value="">Seleccionar</option>'; 
	          for (var i = 0; i < careerList.length; i++) {
	        	  careerHtml += '<option value="'+careerList[i].major+careerList[i].minor+'">'+careerList[i].name+'</option>';
	          }
	          $("#careerCode").append(careerHtml);
	          
	           //국가코드
		  	   var country = userDetail.countryCode;
		  	   if(country != ""){	
		  		   $("#country").val(country);
		  	   }
		  	   
		  	   //도시코드
		  	   var cityId = userDetail.cityId;
		  	   if(cityId != ""){
		  		   $("#city").val(cityId);
		  	   }
		  	   
		  	   fnCitySetting(country, cityId);
		  	   
		  	   //학력       
		       var educationCode = userDetail.educationCode;
		  	   if(educationCode != ""){
		  		   $("#educationCode").val(educationCode);
		  	   }	
		         
	           //학생여부체크
	           var isStudent = userDetail.isStudent;  
	           if(isStudent == "Y"){
	      	     $("#isStudent_Si").prop('checked', true); 
	           }else if(isStudent == "N"){
	      	     $("#isStudent_No").prop('checked', true); 
	           }
		  	   
		  	   //직업 코드	  
		  	   var jobId = userDetail.jobId;
		  	   if(jobId != "0000"){
		  		   $("#jobId").val(jobId);
		  	   }
		         
		         //경력
		       var careerCode = userDetail.careerCode;
		  	   if(careerCode != ""){
		  		   $("#careerCode").val(careerCode);
		  	   }	
	         
	          
	          //설문 
	          questionIdList = response.data.questionIdList;
	          
	          var surveyQuestionList = response.data.surveyQuestionList;
	          var surveyExampleList = response.data.surveyExampleList;
	          
	          var html = '';
	          $("#surveyDataForm").empty();	  
	          if(surveyQuestionList != null && surveyQuestionList.length > 0){
				for (var i = 0; i < surveyQuestionList.length; i++) {					
					html += '	<input type="hidden" id="surveyId_'+i+'" value="'+surveyQuestionList[i].surveyId+'">';										
					html += '	<dt class="title2 mt-lg-10 mt-md-8 mb-md-3 " style="font-size: 15px;">'+(i+1)+'. '+ surveyQuestionList[i].questionTitle+'</dt>';										
					html += '	<dd>';
					html += '		<div class="check-group check-lg-w235 check-md-full">';
					for (var j = 0; j < surveyExampleList.length; j++) {						
						if(surveyQuestionList[i].questionId == surveyExampleList[j].questionId){
							html += '	<span class="check-item" style="width: 210px;">';
							//html += '		<input type="radio" name="example_'+surveyExampleList[j].questionId+'" id="exampleId_'+j+'" data-orderid="'+surveyExampleList[j].exampleId+'" value="'+surveyExampleList[j].exampleNumber+'">';
							html += '		<input type="radio" name="example_'+surveyExampleList[j].questionId+'" id="exampleId_'+j+'" data-orderid="'+surveyExampleList[j].questionId+'" value="'+surveyExampleList[j].exampleNumber+'">'; 
							html += '		<label for="exampleId_'+j+'">'+surveyExampleList[j].exampleTitle+'</label>';
							html += '	</span>';
						}
					}
					html += '		</div>';
					html += '	</dd>';					
				  }				
			  }
	          $("#surveyDataForm").append(html);
			    
	       },error:function(){
	          //alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	
	//도시 세팅 
	function fnCitySetting(countryCodes, cityIds){
		var countryCode;
		if(countryCodes == "" || countryCodes == undefined){
			var countryCode = $("#country option:selected").val();
		}else{
			countryCode = countryCodes
		}
		
		$("#city").removeAttr("disabled");
		
		
		var data = {
				countryCode : countryCode
		};	
	
		$.ajax({
			url: '/user/getCityList',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				
				$("#city").empty();     
		        var html = '';
		        if(resultList != null && resultList.length > 0){
					for (var i = 0; i < resultList.length; i++) {
						html += '<option value="'+resultList[i].cityId+'">'+resultList[i].cityName+'</option>'
					}
					
		        }else{
		        	html += '<option selected ></option>'
		        }
		        $("#city").append(html);  
		        
		        if(cityIds != "" && cityIds != undefined){
		        	$("#city").val(cityIds);
				}
		        
			}
		});
	}
	
	//프로필 비밀번호 체크 
	function fnOpenModal(){
		var userId = $("#userId").val();
		var email = $("#email").val();		
		
		//이름
		var name = $("#name").val();
		var firstName = $("#firstName").val();
		
		//년/월/일
		var year = $("#year option:selected").val();
		var month = $("#month option:selected").val();
		var day = $("#day option:selected").val();
		//성별 체크 값 
		var sexCode = $("input[name='sexCode']:checked").val();
		//전화번호 
		var tell = $("#tell").val();	
		//국가
		var country = $("#country option:selected").val();
		//도시
		var city = $("#city option:selected").val();		
		//학력
		var educationCode = $("#educationCode option:selected").val();				
		//학생여부 체크 값
		var isStudent = $("input[name='isStudent']:checked").val();		
		//직업
		var jobId = $("#jobId option:selected").val();		
		//경력
		var careerCode = $("#careerCode option:selected").val();
		
		
		if(name == "") {
			alert('<spring:message code="profile.message11" text="성을 입력해주세요." />');
			return false;
		} 
		if(firstName == "") {					
			alert('<spring:message code="profile.message12" text="이름을 입력해주세요." />');		
			return false;
		} 
		
		if(year == "") {					
			alert('<spring:message code="profile.message13" text="년 입력해주세요." />');		
			return false;
		}
		if(month == "") {					
			alert('<spring:message code="profile.message14" text="월 입력해주세요." />');		
			return false;
		}
		if(day == "") {					
			alert('<spring:message code="profile.message15" text="일 입력해주세요." />');		
			return false;
		}
		if(sexCode == "") {					
			alert('<spring:message code="profile.message16" text="성별을 체크해주세요." />');				
			return false;
		}
		if(tell == "") {					
			alert('<spring:message code="profile.message17" text="전화번호를 입력해주세요." />');		
			return false;
		}
		
		if(country == "") {					
			alert('<spring:message code="profile.message18" text="국가를 선택해주세요." />');				
			return false;
		}
		
		if(city == "") {					
			alert('<spring:message code="profile.message19" text="도시를 선택해주세요." />');				
			return false;
		} 
		if(educationCode == "") {					
			alert('<spring:message code="profile.message20" text="학력을 선택해주세요." />');					
			return false;
		}		
		if(isStudent == "") {					
			alert('<spring:message code="profile.message21" text="학생여부를 선택해주세요." />');		
			return false;
		}
		if(jobId == "") {					
			alert('<spring:message code="profile.message22" text="직업을 선택해주세요." />');		
			return false;
		}
		if(careerCode == "") {					
			alert('<spring:message code="profile.message23" text="경력을 선택해주세요." />');				
			return false;
		}
		
		//설문조사 데이터 가지고와야함 
		///////////////////////////////////////////////
		//설문 보기 답변 확인 필요.
		//설문 아이디   surveyId
		
		if(isComplete != "Y"){
			var surveyId = $("#surveyId_0").val();	
			
			//보기 아이디   exampleId
			var exampleId = [];
					
			//답변 아이디
			//var questionIdList = ${questionIdList};	
			
			var exampleQuestionId = []; 
			
			//보기/답변 데이터 세팅 
			for (var i = 0; i < questionIdList.length; i++) {
			    console.log(questionIdList[i]);
			    
			    if($("input[name='example_"+questionIdList[i]+"']:checked").val() == undefined) {					
					alert("설문조사 "+(i+1)+"선택해주세요.");
					closeModal('#layer-profile');
					return false;
				} 
			    
			    exampleQuestionId.push($("input[name='example_"+questionIdList[i]+"']:checked").val()); 	
			    exampleId.push($("input[name='example_"+questionIdList[i]+"']:checked").data("orderid"));
			   //data-orderid
			} 
			
		}	
		//////////////////////////////////////////////////////
		openModal('#layer-profile');
	}
	
	
	
	//프로필 저장
	function fnSubmitBt(){
			
		
		
		var userId = $("#userId").val();
		var email = $("#email").val();		
		
		//이름
		var name = $("#name").val();
		var firstName = $("#firstName").val();
		
		//년/월/일
		var year = $("#year option:selected").val();
		var month = $("#month option:selected").val();
		var day = $("#day option:selected").val();
		//성별 체크 값 
		var sexCode = $("input[name='sexCode']:checked").val();
		//전화번호 
		var tell = $("#tell").val();	
		//국가
		var country = $("#country option:selected").val();
		//도시
		var city = $("#city option:selected").val();		
		//학력
		var educationCode = $("#educationCode option:selected").val();				
		//학생여부 체크 값
		var isStudent = $("input[name='isStudent']:checked").val();		
		//직업
		var jobId = $("#jobId option:selected").val();		
		//경력
		var careerCode = $("#careerCode option:selected").val();
		
		if(name == "") {
			alert('<spring:message code="profile.message11" text="성을 입력해주세요." />');
			return false;
		} 
		if(firstName == "") {					
			alert('<spring:message code="profile.message12" text="이름을 입력해주세요." />');		
			return false;
		} 
		
		if(year == "") {					
			alert('<spring:message code="profile.message13" text="년 입력해주세요." />');		
			return false;
		}
		if(month == "") {					
			alert('<spring:message code="profile.message14" text="월 입력해주세요." />');		
			return false;
		}
		if(day == "") {					
			alert('<spring:message code="profile.message15" text="일 입력해주세요." />');		
			return false;
		}
		if(sexCode == "") {					
			alert('<spring:message code="profile.message16" text="성별을 체크해주세요." />');				
			return false;
		}
		if(tell == "") {					
			alert('<spring:message code="profile.message17" text="전화번호를 입력해주세요." />');		
			return false;
		}
		
		if(country == "") {					
			alert('<spring:message code="profile.message18" text="국가를 선택해주세요." />');				
			return false;
		}
		
		if(city == "") {					
			alert('<spring:message code="profile.message19" text="도시를 선택해주세요." />');				
			return false;
		} 
		if(educationCode == "") {					
			alert('<spring:message code="profile.message20" text="학력을 선택해주세요." />');					
			return false;
		}		
		if(isStudent == "") {					
			alert('<spring:message code="profile.message21" text="학생여부를 선택해주세요." />');		
			return false;
		}
		if(jobId == "") {					
			alert('<spring:message code="profile.message22" text="직업을 선택해주세요." />');		
			return false;
		}
		if(careerCode == "") {					
			alert('<spring:message code="profile.message23" text="경력을 선택해주세요." />');				
			return false;
		}
		
		
		//설문조사 데이터 
		///////////////////////////////////////////////		
		//설문 아이디   surveyId		
		if(isComplete != "Y"){
			var surveyId = $("#surveyId_0").val();	
			
			//보기 아이디   exampleId
			var exampleId = [];
					
			//답변 아이디
			//var questionIdList = ${questionIdList};		
			var exampleQuestionId = []; 
			
			//보기/답변 데이터 세팅 
			for (var i = 0; i < questionIdList.length; i++) {			   			    
			    var exampleQuestion = $("input[name='example_"+questionIdList[i]+"']:checked").val();
			    if(exampleQuestion == undefined){
			    	alert('<spring:message code="profile.message24" text="설문 등록 해주세요." />');				
					return false;
			    }else{
			    	exampleQuestionId.push(exampleQuestion); 
			    }
				//exampleQuestionId.push($("input[name='example_"+questionIdList[i]+"']:checked").val()); 
			    exampleId.push($("input[name='example_"+questionIdList[i]+"']:checked").data("orderid"));
			   //data-orderid
			}  
		}	
		//////////////////////////////////////////////////////
		
		var data = {
				userId : userId,
				email : email,
				name : name,
				firstName : firstName,
				year : year,
				month : month,
				day : day,
				sexCode : sexCode,
				tell : tell,
				country : country,
				city : city,
				educationCode : educationCode,
				isStudent : isStudent,
				jobId : jobId,
				careerCode : careerCode,
				surveyId : surveyId,
				exampleId : exampleId,
				exampleQuestionId : exampleQuestionId
		};	
	
		$.ajax({
			url: '/user/userUpdate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				if(response.code == "SUCCESS"){ 
					//alert('저장되었습니다.');						
					//페이지 리플레이스 처리 하고 설문조사 참여 했으면 설문조사 영역 숨김 처리 
					
					//비빌번호 확인 팝업 숨김
					//closeModal('#layer-profile');
					
					//설문조사 숨김 여부 확인 필요.
					$("#surveyForm").hide();
					location.reload(); //페이지 리로딩
					
				}else{
					alert(response.message);
				}
			}
		});
	}
	
	//비밀번호 변경
	function fnPwChangSave(){
		
		var userId = $("#userId").val();
		var email = $("#email").val();
		var passwordOld = $("#passwordOld_user").val();
		var password_01 = $("#password_01_user").val();
		var password_02 = $("#password_02_user").val();
		
		if(passwordOld == "") {					
			alert('<spring:message code="profile.message25" text="기존 비밀번호를 입력해주세요." />');	
			return false;
		}
		
		if(password_01 == "") {					
			alert('<spring:message code="profile.message26" text="비밀번호을 입력해주세요." />');	
			return false;
		}
		
		if(passwordOld == password_01) {					
			alert('<spring:message code="profile.message27" text="입력하신 비밀번호가 기존 비밀번호와 동일합니다." />');	
			return false;
		}
		
		if(password_02 == "") {					
			alert('<spring:message code="profile.message26" text="비밀번호을 입력해주세요." />');	
			return false;
		}
	 	if(password_01 != password_02) {					
	 		alert('<spring:message code="profile.message28" text="비밀번호가 일치하지 않습니다" />');	
			return false;
		}
		if(password_01.search(/[a-z]/g) < 0) {					
			alert('<spring:message code="profile.message29" text="비밀번호에 영문 소문자를 하나 이상 입력해주세요" />');	
			return false;
		}
		if(password_01.search(/[A-Z]/g) < 0) {					
			alert('<spring:message code="profile.message30" text="비밀번호에 영문 대문자를 하나 이상 입력해주세요" />');	
			return false;
		}
		if(!isValidPwdPolicy(password_01)) {					
			alert('<spring:message code="profile.message31" text="영어, 숫자, 특수문자 포함 8~16자 이내의 조합으로 등록해주세요" />');	
			return false;
		}
		
		var data = {
				userId : userId,				
				email : email,
				passwordOld : passwordOld,
				password : password_01
		};	
		
		$.ajax({
			url: '/user/userPwUpdate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				console.log(response);
				var result = response.data;
				
				if(result == "1"){					
					//alert('저장되었습니다.');	
					//이메일인증 요청 
					//fnEmailSend(email);
					closeModal('#layer-pwchange');
					openModal('#layer-complete');
				}else if(result == "0"){
					//다른 쪽으로 이동 메인 페이지
					//location.href= "/main";	
					alert('<spring:message code="profile.message25" text="기존 비밀번호를 입력해주세요." />');						
				}
				
			}
		});
	}
	
	//프로필 이미지 업로드
	function uploadFile() {
		
		var fileName =  $("#upload-file-input").val(); 
   		fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
   		if(fileName != "jpg" && fileName != "png" &&  fileName != "gif" &&  fileName != "bmp"){
   			alert('<spring:message code="resume.text14" text="이미지 파일만 등록 가능합니다." />');
   			return false;
   		}
     	var test = "";
     	  $.ajax({
     	    url: "/user/upload",
     	    type: "POST",
     	    data: new FormData($("#upload-file-form")[0]),
     	    enctype: 'multipart/form-data',
     	    processData: false,
     	    contentType: false,
     	    cache: false,
     	    success: function (response) {
     	    	//console.log(response);
				if(response.code == "SUCCESS"){
					//alert('저장되었습니다.');	
					//이메일인증 요청 
					$("#preImage").attr("src", response.data);
					//alert(response.data);
				}else{
					alert(response.message);
				}
     	    },
     	    error: function () {
     	      // Handle upload error
     	      // ...
     	    }
     	  });
     } 
	
	
	//탈퇴 view 이동 
	function fnUserSecessionFormMove(){
		var email = $("#email").val();
		var userId = $("#userId").val();
		
		//이메일 인코딩
		//email = encodeURIComponent(email);
		location.href= "/user/userSecessionForm?email="+email+"&userId="+userId;
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
				<div class="profile-area">
					<div class="profile-frame">
						<div class="photo">
							<img id="preImage" src="" alt="" onerror="this.src='/static/assets/images/common/img-profile-default@2x.png'">
						</div>
						<div class="country">
							<img id="userCountry" src="" onerror="this.src='/static/assets/images/common/_img-flag.png'"alt="">
						</div>
						<label for="upload-file-input" class="btn-upload">Photo upload</label>
						
						<form id="upload-file-form">
							<input id="upload-file-input" type="file" onChange="uploadFile()" name="filename" accept="*" />
						</form>
					</div>
					<div class="profile-info">
						<span class="name" id="userName"></span>
						<span class="job" id="userJob"></span>
					</div>
					<div class="mt-lg-7 mt-md-4">
						<a href="#;" class="btn btn-md btn-outline-gray btn-round btn-block" onclick="openModal('#layer-pwchange');"><spring:message code="profile.text8" text=""/></a>
					</div>
				</div>
			</aside>
			<article id="content">
				<h2 class="content-title"><spring:message code="menu.drop1" text=""/></h2> 
				<div class="profile-wrap"><!-- // 마크업 수정 (04.14) -->
					<div class="profile-area d-down-md">
						<div class="profile-frame">
							<div class="photo">
								<img id="preImages" src="" alt="">
							</div>
							<div class="country">
								<img id="userCountrys" src="" onerror="this.src='/static/assets/images/common/_img-flag.png'"alt="">
							</div>
							<label for="lb_upload2" class="btn-upload">Photo upload</label>
							
							<form id="upload-file-form_mobile">
								<input id="upload-file-input_mobile" type="file" onChange="uploadFile()" name="filename" accept="*" />
							</form>
						</div>
						<div class="profile-info">
							<span class="name" id="userNames"></span>
							<span class="job" id="userJobs"></span>
						</div>
						<div class="mt-lg-7 mt-md-4">
							<a href="#;" class="btn btn-md btn-outline-gray btn-round btn-block" onclick="openModal('#layer-pwchange');"><spring:message code="profile.text8" text="Cambiar la contraseña"/></a>
						</div>
					</div>
 
					<div class="division-line d-down-md mt-md-6"></div>

					<div class="box box-notice mt-md-3" id="caution" style="display:none">
						<p class="text"><spring:message code="profile.message2" text=""/></p>
					</div>
					
						<h3 class="title1 mt-lg-4 mb-lg-4"><spring:message code="resume.text5" text="Intimidad"/></h3>
						<div class="form-area">
							<div class="form-item">
								<dl class="form-group">
									<dt class="title3 mt-0"><spring:message code="dashboard.text1" text=""/></dt>
									<dd>
										<input type="hidden" id="userId" name="userId" value="">
										<input type="text" class="form-control" id="email" value="" title="id" disabled>
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title3"><label for="lb_name1"><spring:message code="login.text2" text=""/></label></dt>
									<dd>
										<input type="text" id="name" class="form-control" value="">
									</dd>
								</dl>
								<dl class="form-group">
									<dt class="title3"><label for="lb_name2"><spring:message code="contact.text.3" text="Apellido(s)"/></label></dt>
									<dd>
										<input type="text" id="firstName" class="form-control" value="">
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title3"><spring:message code="contact.text.10" text="Fecha de nacimiento"/></dt>
									<dd>
										<div class="form-row">
											<div class="input-item">  
												<select class="form-control" required title="day" id="day">
													<option value=""><spring:message code="contact.text.11-3" text=""/></option>																									
												</select>
											</div>
											<div class="input-item">
												<select class="form-control" required title="month" id="month">
													<option value=""><spring:message code="contact.text.11-2" text=""/></option>											
												</select>
											</div>
											<div class="input-item">
												<select class="form-control" required title="year" id="year">
													<option value=""><spring:message code="contact.text.11-1" text=""/></option>												
												</select>
											</div>
										</div>
									</dd>
								</dl>
								<dl class="form-group">
									<dt class="title3"><spring:message code="contact.text.12" text="Sexo"/></dt>
									<dd>
										<div class="check-group check-lg-w120">
											<span class="check-item">
												<input type="radio" name="sexCode" id="sexCode_01" value="0301" checked>
												<label for="sexCode_01"><spring:message code="contact.text.12-1" text=""/></label>
											</span>
											<span class="check-item">
												<input type="radio" name="sexCode" id="sexCode_02" value="0302">
												<label for="sexCode_02"><spring:message code="contact.text.12-2" text=""/></label>
											</span>
											<span class="check-item">
												<input type="radio" name="sexCode" id="sexCode_03" value="0303">
												<label for="sexCode_03"><spring:message code="contact.text.12-3" text=""/></label>
											</span>
										</div>
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title3"><label for="lb_tel"><spring:message code="contact.text.13" text="Contacto"/></label></dt>
									<dd>										
										<input type="text"  id="tell" class="form-control" oninput="this.value = this.value.replace(/[^0-9.]/g, '').replace(/(\..*)\./g, '$1');" />
									</dd>
								</dl>
								<dl class="form-group">
									<div style="display: inline-block; width:50%;">
										<dt class="title3"><spring:message code="contact.text.11" text="Información del país"/></label></dt>	
									</div>
									<div style="display: inline-block;">
										<dt class="title3" ><spring:message code="contact.text.19" text="Información del departamento"/></label></dt>
									</div>
									<dd>
										<div class="form-row">
											<div class="input-item">
												<select class="form-control" required title="country" id="country" onchange="fnCitySetting()">
													<option selected value=""><spring:message code="contact.text.11-2-1" text="Información del país"/></option> 
												</select>
											</div>
											<div class="input-item">
												<select class="form-control" required title="state" id="city" disabled >
													<option selected value=""><spring:message code="contact.text.19" text="" /></option>
												</select>
											</div>
										</div>
									</dd>
								</dl>
							</div>
						</div>

						<div class="division-line mt-lg-12 mt-md-8"></div>
	
						<h3 class="title1 mt-md-8"><spring:message code="profile.text2" text="Información sobre educación y carreras"/></h3>
						<div class="form-area">
							<div class="form-item">
								<dl class="form-group">
									<dt class="title2"><label for="lb_edu"><spring:message code="profile.text3" text="Cuál es el nivel de educación más alto que has terminado"/></label></dt>
									<dd>
										<select id="educationCode" class="form-control" required>
											
										</select>
									</dd>
								</dl>
								<dl class="form-group">
									<dt class="title2 text-row2"><spring:message code="profile.text4" text="Eres estudiante"/></dt>
									<dd>
										<div class="check-group check-lg-w120">
											<span class="check-item">
												<input type="radio" name="isStudent" id="isStudent_Si" value="Y" checked>
												<label for="isStudent_Si">Si</label>
											</span>
											<span class="check-item">
												<input type="radio" name="isStudent" id="isStudent_No" value="N">
												<label for="isStudent_No">No</label>
											</span>
										</div>
									</dd>
								</dl>
							</div>
							<div class="form-item">
								<dl class="form-group">
									<dt class="title2"><label for="lb_job"><spring:message code="profile.text5" text="Situación laboral actual"/></label></dt>
									<dd>
										<select id="jobId" class="form-control" required>
											
										</select>
									</dd>
								</dl>
								<dl class="form-group">
									<dt class="title2"><label for="lb_career"><spring:message code="profile.text6" text="Nivel de experiencia"/></label></dt>
									<dd>   
										<select id="careerCode" class="form-control" required> 
											
										</select>
									</dd>
								</dl>
							</div>
							<div class="mt-4 mb-4 text-right">
								<a href="#;" class="btn btn-link"  onClick="fnUserSecessionFormMove()"><spring:message code="profile.text12" text="Retiro"/></a>
							</div>
						</div>

						<!-- 설문조사 영역 Start -->
						<div id="surveyForm" style="display:none">
						<div class="division-line"></div>
	
						<p class="img-logo mt-lg-12 mt-md-8">Clic</p>
						<h3 class="title1 mt-lg-4 mt-md-3 mb-1"><spring:message code="profile.text7" text="Encuesta sobre el entorno de las ICT"/></h3> 
						<p><spring:message code="profile.message3" text=""/></p>
						<div class="form-area">
							<div class="form-item">
								<dl class="form-group" id="surveyDataForm" style="width: 100%;">
									
								</dl>
							</div>							
						</div>
						</div>
						<!-- 설문조사 END -->
						
						<div class="btn-group-default btn-group-fixed">
							
							<button type="button" class="btn btn-md btn-primary" id="submitBt" onClick="fnSubmitBt();"><spring:message code="button.save" text="Guardar"/></button>
						</div>
					
				</div>
			</article>
		</div>
		
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->		
	</div>
	
	
	<!-- 비밀번호 변경 팝업 레이어팝업 -->
	
	<div class="modal-popup modal-md hide" id="layer-pwchange">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-header">
				<h2 class="popup-title"><spring:message code="profile.text8" text="Cambia la contraseña"/></h2>
			</div>
			<div class="popup-body">
				<div class="table-wrap">
					<table class="table table-write">
						<caption class="sr-only"><spring:message code="profile.text8" text="Cambia la contraseña"/></caption>
						<colgroup>
							<col style="width:200px">
							<col>
						</colgroup>
						<tbody>
							<tr>
								<th scope="row"><label for="passwordOld_user"><spring:message code="profile.text9" text="contraseña actual"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="passwordOld_user" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="password_01_user"><spring:message code="profile.text10" text="Cambia la contraseña"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="password_01_user" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
								</td>
							</tr>
							<tr>
								<th scope="row"><label for="password_02_user"><spring:message code="profile.text11" text="Confirmar cambio de contraseña"/></label></th>
								<td>
									<div class="form-item">
										<input type="password" id="password_02_user" class="form-control">
										<button type="button" class="btn btn-view">View password</button>
									</div>
									<p class="text-info"><spring:message code="contact.text.15" text="Cambia la contraseña"/></p>
								</td>
							</tr>
						</tbody>
					</table>
				</div>
				<div class="btn-group-default btn-fixed mt-lg-8">
					<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-pwchange');"><spring:message code="button.cancel" text="cancelar"/></a>
					<button type="submit" class="btn btn-md btn-secondary" onclick="fnPwChangSave();"><spring:message code="button.save" text="Confirmar"/></button>
				</div>
			</div>
		</div>
	</div>

	<!-- 비밀번호 성공후 팝업  -->
	<div class="modal-popup modal-sm hide" id="layer-complete">
		<div class="dimed"></div>
		<div class="popup-inner">
			<div class="popup-body text-center">
				<em class="ico ico-check"></em>
				<h2 class="popup-title">Envío completado</h2>
				<p class="text mt-lg-5 mt-md-2"><spring:message code="profile.message4" text=""/></p>
				<div class="btn-group-default mt-lg-8 mt-md-8">
					<a href="/login/login" class="btn btn-md btn-secondary" onclick="closeModal('#layer-complete');"><spring:message code="login.loginbutton" text="Ingresar"/></a>
				</div>
			</div>
		</div>
	</div>	
</body>
</html>