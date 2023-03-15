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
	<script>
	var portfolioId = getParameterByName('portfolioId');
	
	function getParameterByName(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
	}	
	
	$(document).ready(function () {
		//포토폴리오  좌측 세팅
		getSidePortfolio();
		
		//프로젝트 데이터 세팅 
		fnProjectList(portfolioId);
		
		//포토폴리오 데이터 세팅 
		fnPortfolioDetail("",portfolioId);
		
		
		
		$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
		
		//필수값 체크 및 저장버튼 활성화 
		  $('#portfolioName').on('input',processkey);
		  $('#introduction').on('input',processkey);
		  $('#tag').on('input',processkey);
		  $('#lb_file1').on('input',processkey);	 
		  
		  $('#projectName').on('input',projectProcesskey);
		  $('#lb_file3').on('input',projectProcesskey);
		  
		  
		  
		//========================프로필 이미지 미리보기=================================	
		  //프로필 이미지 미리보기   
	      $(function() {
	           $("#lb_file1").on('change', function(){
	        	   var fileName =  $("#lb_file1").val(); 
		       	   fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
		       	   if(fileName != "jpg" && fileName != "png" &&  fileName != "gif" &&  fileName != "bmp"){
		       		alert('<spring:message code="resume.text14" text="이미지 파일만 등록 가능합니다." />');
		       			$("#lb_file1").val("");
		       			return false;
		       	   }
	               readURL(this);
	           });
	           
	           $("#lb_file2").on('change', function(){
	        	   var fileName =  $("#lb_file2").val(); 
		       	   fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
		       	   if(fileName != "jpg" && fileName != "png" &&  fileName != "gif" &&  fileName != "bmp"){
		       			alert('<spring:message code="resume.text14" text="이미지 파일만 등록 가능합니다." />');
		       			$("#lb_file2").val("");
		       			return false;
		       	   }
	        	   readURL_02(this);
	           });
	           
	           $("#lb_file3").on('change', function(){
	        	   var fileName =  $("#lb_file3").val(); 
		       	   fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
		       	   if(fileName != "jpg" && fileName != "png" &&  fileName != "gif" &&  fileName != "bmp"){
		       		alert('<spring:message code="resume.text14" text="이미지 파일만 등록 가능합니다." />');
		       			$("#lb_file3").val("");
		       			return false;
		       	   }
	        	   readURL_03(this);
	           });
	       });
		  
	       function readURL(input) {
	           if (input.files && input.files[0]) {
	              var reader = new FileReader();
	              reader.onload = function (e) {
	                 //$('#preImage').attr('src', e.target.result);
	                 $('#file_01').show();
	                 $('#fileUrl_01').attr('src', e.target.result);
	              }
	              reader.readAsDataURL(input.files[0]);
	           }
	       }
	       
	       function readURL_02(input) {
	           if (input.files && input.files[0]) {
	              var reader = new FileReader();
	              reader.onload = function (e) {
	                 //$('#preImage').attr('src', e.target.result);
	                 $('#file_02').show();
	                 $('#fileUrl_02').attr('src', e.target.result);
	              }
	              reader.readAsDataURL(input.files[0]);
	           }
	       }
	       
	       function readURL_03(input) {
	           if (input.files && input.files[0]) {
	              var reader = new FileReader();
	              reader.onload = function (e) {
	                 //$('#preImage').attr('src', e.target.result);
	                 $('#projectFile_01').show();
	                 $('#projectFileUrl_01').attr('src', e.target.result);
	              }
	              reader.readAsDataURL(input.files[0]);
	           }
	       }
	     //========================프로필 이미지 미리보기=================================
			
	});
	
	function processkey(){ 	        
	      var portfolioName = $("#portfolioName").val();		//포토폴리오명 
	      var introduction = $("#introduction").val();			//포토폴리오 소개
	      var tag = $("#tag").val();					//태그명 
	      var fileUrl_01 = $('#fileUrl_01').attr("src");
	      var lb_file1 = $("#lb_file1").val();
	   	  
	   	 if(portfolioName == "" || tag == "" || (fileUrl_01 == "" && lb_file1 == "") ){	 
	   		//$('#saveButton').attr('disabled', false);			//버튼 해제 
	   		$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
	     }else {
	        $('#saveButton').attr('disabled', false);			//버튼 해제 
	      	  //$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
	     }
	  }
	   	 
	  function projectProcesskey(){
		  var projectName = $("#projectName").val();		
	      var fileUrl_01 = $("#lb_file3").val();
	   	  
	   	 if(projectName == "" || fileUrl_01 == ""){
	   		//$('#saveButton').attr('disabled', false);			//버튼 해제 
	   		$('#projectButton').attr('disabled', true); 			//번튼 딤 처리 
	     }else {
	        $('#projectButton').attr('disabled', false);			//버튼 해제 
	      	  //$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
	     }
	  }
	
	
	//포토폴리오  좌측 세팅
	function getSidePortfolio(){
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : {"userId" : userId },
	        url : '/studio/portfolio/portfolioList',
	        success : function(response) {
	          var resultList = response.data;
	          
	          var html = '';
	          if(resultList != null && resultList.length > 0){
				for (var i = 0; i < resultList.length; i++) {	
					if(portfolioId == resultList[i].portfolioId){
						html += '<li class="on" id="sideTitle_'+(i+1)+'" data-portfolioid="'+resultList[i].portfolioId+'"><a href="#;" onclick="fnPortfolioDetail(\''+resultList[i].userId+'\',\''+resultList[i].portfolioId+'\');">'+resultList[i].name+'</a></li>';		
					}else{
						html += '<li id="sideTitle_'+(i+1)+'" data-portfolioid="'+resultList[i].portfolioId+'"><a href="#;" onclick="fnPortfolioDetail(\''+resultList[i].userId+'\',\''+resultList[i].portfolioId+'\');">'+resultList[i].name+'</a></li>';		
					}			
				  }				   
			  }			 
	          var noListLength = 3-resultList.length;
			  for (var j = 0; j < noListLength; j++) {
				     html += '<li id="sideTitle_3"><a href="#;" onclick="fnPortfolioDetail(\'\',\'\');">portalfolio title</a></li>';
			  }
			  $("#sidePortfolio").append(html);  
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	var concatWordsList;
	//포토폴리오 상세 보기 
	function fnPortfolioDetail(userIds, portfolioIds){
		
		//side 메뉴 on처리 
		if(portfolioIds == $("#sideTitle_1").data("portfolioid")){
			$("#sideTitle_1").addClass("on");
			$("#sideTitle_2").removeClass("on");
			$("#sideTitle_3").removeClass("on");
		}else if(portfolioIds == $("#sideTitle_2").data("portfolioid")){
			$("#sideTitle_1").removeClass("on");
			$("#sideTitle_2").addClass("on");
			$("#sideTitle_3").removeClass("on");
		}else{	
			$("#sideTitle_1").removeClass("on");
			$("#sideTitle_2").removeClass("on");
			$("#sideTitle_3").addClass("on");
		}
		
		//데이터 초기하 
		$("#portfolioName").val("");		//포토폴리오명 
   	  	$("#introduction").val("");			//포토폴리오 소개
   	  	$("#tag").val("");					//태그명   	  	
   		$("#file_01").hide();
   		$("#file_02").hide();   	
   		$("#isUseQr_1").prop('checked', true);	//QR코드 
   		
   		//공개유형 코드 세팅 필요 .
		
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"userId" : userIds ,"portfolioId" : portfolioIds },
	        url : '/studio/portfolio/portfolioDetail',
	        success : function(response) {
	          var data = response.data.portfolioInfo;	
	          
	          concatWordsList = response.data.concatWordsList;
	          
	          var publicList = response.data.publicList
	          var html = '';
	          $("#publicForm").empty();	  
	          if(publicList != null && publicList.length > 0){	
		          for (var i = 0; i < publicList.length; i++) {		        	
		        	  
		        	  html += '<li id="public_'+publicList[i].minor+'" value="'+publicList[i].major+publicList[i].minor+'"><a href="#;" onclick="textPublicValue(this,\''+publicList[i].minor+'\');">'+publicList[i].name+'</a></li>';
				  }
	          }
	          $("#publicForm").append(html);
	          
	          if(data != null){
		          //프로젝트 데이터 세팅 
		      	  fnProjectList(data.portfolioId);
		          
		      	  var reName = data.name;	        	  
	        	  var newName = reName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
	        	  
	        	  var reIntroduction = data.introduction;
	        	  var newIntroduction = reIntroduction.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
		          
				  ///////////////////////프로젝트 포토폴리오 데이터 세팅 Start //////////////////////////
	        	  $('#backgroundImagePathTitle').attr('src', data.backgroundImagePath);
	        	  $("#portfolioTitle").text(newName);
	        	  $("#tagTitle").text(data.tag);
	        	  $("#introductionTitle").text(newIntroduction);
	        	  $("#portfolioId_main").val(data.portfolioId);
				  ///////////////////////프로젝트 포토폴리오 데이터 세팅 END //////////////////////////
	        	  
	        	  
	        	  ///////////////////////포토폴리오 등록팝업 데이터 세팅 Start //////////////////////////
	        	  $("#portfolioId").val(data.portfolioId);
	        	  $("#portfolioName").val(newName);					//포토폴리오명 
	        	  $("#introduction").val(newIntroduction);			//포토폴리오 소개
	        	  $("#tag").val(data.tag);							//태그명
	        	  
	        	  var selectPublicType;
	        	  if(data.publicTypeCode == "1801"){	        		 
	        		  selectPublicType= $("#public_01 a").text();
	        	  }else if(data.publicTypeCode == "1802"){
	        		  selectPublicType= $("#public_02 a").text();
	        	  }else if(data.publicTypeCode == "1803"){
	        		  selectPublicType= $("#public_03 a").text();
	        	  }else if(data.publicTypeCode == "1804"){
	        		  selectPublicType= $("#public_04 a").text();
	        	  }	        	  
	        	  $("#selectPublicType").text(selectPublicType);
	        	  
	        	  $("#publicTypeCode").val(data.publicTypeCode);	
	        	  
	        	  if(data.listImagePath != null){
	        		  $("#file_01").show();
	        		  $("#fileUrl_01").attr('src', data.listImagePath);	// 리스트 이미지경로 		  
	        	  }
	        	  
	        	  if(data.backgroundImagePath != null){
	        		  $("#file_02").show();
	        		  $("#fileUrl_02").attr('src', data.backgroundImagePath);	// 배경화면 이미지 경로
	        	  }	
	        	  
	        	  if(data.isUseQr == "Y"){							//qr코드
	           	   	  $("#isUseQr_1").prop('checked', true); 
	              }else{
	            	  $("#isUseQr_2").prop('checked', true); 
	              }
	        	  
	        	  if(data.publicTypeCode == "1801"){
                      var stext1 = $("#public_01 a").text();
                      $('#selectPublicType').text(stext1);
	        	  }else if(data.publicTypeCode == "1802"){
                      var stext2 = $("#public_02 a").text();
                      $('#selectPublicType').text(stext2);
	        	  }else if(data.publicTypeCode == "1803"){
                      var stext3 = $("#public_03 a").text();
                      $('#selectPublicType').text(stext3);
	        	  }else if(data.publicTypeCode == "1804"){
                      var stext4 = $("#public_04 a").text();
                      $('#selectPublicType').text(stext4);
	        	  }
	        	 
	        	  
	        	  $('#saveButton').attr('disabled', false); 		//버튼 disabled 해제 
	        	  $("#saveButton").attr("onClick", "fnPortfolioUpdate()");	//수정 function 변경 
				  ///////////////////////포토폴리오 등록팝업 데이터 세팅 END //////////////////////////
	          }else{
	        	  $('#saveButton').attr('disabled', true); 			//버튼 disabled 처리 
	        	  $('#selectPublicType').text($("#public_01 a").text());
	        	  $("#saveButton").attr("onClick", "fnPortfolioSave()");	 //저장 function 변경 
	        	  openModal('#layer-portfolio');
	          }
	          
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    });
	}
	
	//포토폴리오 등록 
	function fnPortfolioSave(){
		//데이터
		var portfolioName = $("#portfolioName").val();		//포토폴리오명 
		var introduction = $("#introduction").val();		//포토폴리오 소개
		var tag = $("#tag").val();							//태그명 
   		var isUseQr = $("input[name='isUseQr']:checked").val();	//qr코드 사용 여부 
   		var publicTypeCode = $("#publicTypeCode").val();  		
   		
   		//금지처리
   		//var bad = ${test};  
   		//var ckc = [" ",".","-","/","*","[","]","=","#"];  //금지단어 사이에 입력되는 제거대상 문자  ex)관/리.자
   		var ckc = [" ",".","-","/","*","[","]","="];  //금지단어 사이에 입력되는 제거대상 문자  ex)관/리.자
   		var position;

   		for (i=0; i<ckc.length ; i++) {
   		  position = tag.indexOf(ckc[i]);
   		  while (position != -1){
   			tag = tag.replace(ckc[i],"");
   		    position = tag.indexOf(ckc[i]);
   		  }
   		}
   		
   		for (i=0; i<concatWordsList.length ; i++) {
   			if (tag.match(concatWordsList[i])) {	   		    
	   			alert('<spring:message code="alert.text.1-1" text="입력한 내용에 금칙어가 포함되어 있습니다." />');
	   		    return;
	   		  }
   		}
   		
   		var form = $("#upload-file-form")[0];
   		var formData = new FormData(form);
   		//formData.append("userId", userId);
   		formData.append("portfolioName", portfolioName);
   		formData.append("introduction", introduction);
   		formData.append("tag", tag);
   		formData.append("isUseQr", isUseQr);
   		formData.append("publicTypeCode", publicTypeCode);
   		
		$.ajax({
	        type : 'POST',  
	        enctype: 'multipart/form-data',
	        url : '/studio/portfolio/savePortfolio',
	        data : formData,	       
	        processData: false,
     	    contentType: false,
     	    cache: false,	        
	        success : function(response) {
		        var resultList = response.data;
		        if(response.code == "SUCCESS"){
		        	//alert("저장성공 했습니다.");
		        	closeModal('#layer-portfolio');
		        	location.reload(); //페이지 리로딩
		        }	          
	       },error:function(){
	          //alert("등록에 실패하였습니다.");
	       }
	    });		
	}
	
	//포토폴리오 수정
	function fnPortfolioUpdate(){
		//데이터
		var portfolioId = $("#portfolioId").val();			//포토폴리오 아이디
		var portfolioName = $("#portfolioName").val();		//포토폴리오명 
		var introduction = $("#introduction").val();		//포토폴리오 소개
		var tag = $("#tag").val();							//태그명 
   		var isUseQr = $("input[name='isUseQr']:checked").val();	//qr코드 사용 여부 
   		var publicTypeCode = $("#publicTypeCode").val();  		
   		
   		
   		//금지처리
   		//var bad = ${test};  
   		//var ckc = [" ",".","-","/","*","[","]","=","#"];  //금지단어 사이에 입력되는 제거대상 문자  ex)관/리.자
   		var ckc = [" ",".","-","/","*","[","]","="];  //금지단어 사이에 입력되는 제거대상 문자  ex)관/리.자
   		var position;

   		for (i=0; i<ckc.length ; i++) {
   		  position = tag.indexOf(ckc[i]);
   		  while (position != -1){
   			tag = tag.replace(ckc[i],"");
   		    position = tag.indexOf(ckc[i]);
   		  }
   		}
   		
   		for (i=0; i<concatWordsList.length ; i++) {
   			if (tag.match(concatWordsList[i])) {	   		    
	   			alert('<spring:message code="alert.text.1-1" text="입력한 내용에 금칙어가 포함되어 있습니다." />');
	   		    return;
	   		  }
   		}
   		
   		var form = $("#upload-file-form")[0];
   		var formData = new FormData(form);
   		//formData.append("userId", userId);
   		formData.append("portfolioId", portfolioId);
   		formData.append("portfolioName", portfolioName);
   		formData.append("introduction", introduction);
   		formData.append("tag", tag);
   		formData.append("isUseQr", isUseQr);
   		formData.append("publicTypeCode", publicTypeCode);
   		
		$.ajax({
	        type : 'POST',  
	        enctype: 'multipart/form-data',
	        url : '/studio/portfolio/updatePortfolio',
	        data : formData,	       
	        processData: false,
     	    contentType: false,
     	    cache: false,	        
	        success : function(response) {
		        var resultList = response.data;
		        if(response.code == "SUCCESS"){
		        	//alert("수정성공 했습니다.");
		        	closeModal('#layer-portfolio');
		        	location.reload(); //페이지 리로딩
		        }	          
	       },error:function(){
	          //alert("수정에 실패하였습니다.");
	       }
	    });
	}
	
	//프로젝트 리스트 생성
	function fnProjectList(portfolioIds){
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"portfolioId" : portfolioIds },
	        url : '/studio/project/projectList',
	        success : function(response) {
	          var resultList = response.data;
	          
	          var html = '';
	          $("#projectView").empty();
	          if(resultList != null && resultList.length > 0){
	        	
				for (var i = 0; i < resultList.length; i++) {
					html += '<li>';
					html += '	<div class="project-item">';
					html += '		<a href="#;" class="thumb-area" onclick="fnProjectFrom(\''+resultList[i].portfolioId+'\',\''+resultList[i].projectId+'\');">';
					html += '			<span class="thumb">';
					html += '				<img src="'+resultList[i].imagPath+'" alt="">';
					html += '			</span>';
					html += '		</a>';
					html += '		<div class="project-ctrl">';
					html += '			<ul class="sns-list">';
					html += '				<li class="sns-facebook"><a href="#;"><span>facebook</span></a></li>';
					html += '				<li class="sns-linkedin"><a href="#;"><span>linkedin</span></a></li>';
					html += '				<li class="sns-twitter"><a href="#;"><span>twitter</span></a></li>';
					html += '			</ul>';
					html += '			<dl class="portfolio-ctrl">';
					html += '				<dt><a href="#;" class="btn btn-edit">edit</a></dt>';
					html += '				<dd>';
					html += '					<ul class="btn-list">';
					html += '						<li><a href="#;" class="btn btn-modify" onclick="fnProjectDetail(\''+resultList[i].projectId+'\');">Modificar</a></li>';
					html += '						<li><button type="button" class="btn btn-delete" onclick="fnProjectDel(\''+resultList[i].userId+'\',\''+resultList[i].projectId+'\',\''+resultList[i].portfolioId+'\');">Eliminar</button></li>';
					html += '					</ul>';
					html += '				</dd>';
					html += '			</dl>';
					html += '		</div>';
					html += '		<a href="#;" class="info-area">';
					html += '			<span class="name">'+resultList[i].name+'</span>';
					html += '			<span class="date">update: '+resultList[i].updatedDate+'</span>';
					html += '			<div class="like">';
					html += '				<em class="ico ico-like-on-lg"></em>';
					html += '				<span class="number">'+resultList[i].likeCount+'</span>';
					html += '			</div>';
					html += '		</a>';
					html += '	</div>';
					html += '</li>';			 
				  }				   
			  }
			 
			  $("#projectView").append(html);
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//프로젝트 등록 view 오픈
	function fnOpenProject(){
		//데이터 초기하 
		$("#projectName").val("");		//포토폴리오명 
   	  	$("#projectIntroduction").val("");			//포토폴리오 소개   	  	
   		$("#projectFile_01").hide();
   		$('#projectButton').attr('disabled', true);
		$("#projectButton").attr("onClick", "fnProjectSave()");	//function 변경 
		openModal('#layer-project');
	}
	
	
	//프로젝트 상세 보기 
	function fnProjectDetail(projectId){
		
		//데이터 초기하 
		$("#projectName").val("");		//포토폴리오명 
   	  	$("#projectIntroduction").val("");			//포토폴리오 소개   	  	
   		$("#projectFile_01").hide();
		
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {"projectId" : projectId },
	        url : '/studio/project/getProjectDetail',
	        success : function(response) {
	          var data = response.data;	 
	          
	          if(data != null){
	        	  var reName = data.name;	        	  
	        	  var newName = reName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
	        	  
	        	  var reIntroduction = data.introduction;
	        	  var newIntroduction = reIntroduction.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
		          
	        	  
	        	  $("#projectName").val(newName);//프로젝트명  
	        	  $("#projectIntroduction").val(newIntroduction);		//프로젝트소개 
	        	  $("#projectId").val(data.projectId);
	        	  
	        	  if(data.imagPath != null){
	        		  $("#projectFile_01").show();
	        		  $("#projectFileUrl_01").attr('src', data.imagPath);	// 이미지경로
	        		  //$("#fileUrl_01").attr('src', "/static/fileUpload/"+data.listImagePath);	// 리스트 이미지경로	    
	        		  $('#projectButton').attr('disabled', false);			//버튼 해제 
	        	  	  $("#projectButton").attr("onClick", "fnProjectUpdate()");	//function 변경 
	        	  }else{
	        		  $("#projectButton").attr("onClick", "fnProjectSave()");	//수정 function 변경 
	        	  }
	        	 
	          }
	          openModal('#layer-project');
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    });
	}
	
	//프로젝트 등록 
	function fnProjectSave(){
		//데이터
		var projectName = $("#projectName").val();		//프로젝트명 
		var projectIntroduction = $("#projectIntroduction").val();		//프로젝트소개 
		var portfolioId_main = $("#portfolioId_main").val();
   		
   		var form = $("#project-file-form")[0];
   		var formData = new FormData(form);
   		//formData.append("userId", userId);
   		formData.append("portfolioId", portfolioId_main);
   		formData.append("projectName", projectName);
   		formData.append("projectIntroduction", projectIntroduction);   		
   		
		$.ajax({
	        type : 'POST',  
	        enctype: 'multipart/form-data',
	        url : '/studio/project/saveProject',
	        data : formData,	       
	        processData: false,
     	    contentType: false,
     	    cache: false,	        
	        success : function(response) {
		        var resultList = response.data;
		        if(resultList == true){
		        	closeModal('#layer-project');
		        	location.reload(); //페이지 리로딩
		        }else{
		        	closeModal('#layer-project');  
		        	alert('<spring:message code="portfolio.alert.msg2" text="최대 50개의 프로젝트를 등록할수 있습니다." />');
		        }
	       },error:function(){
	          //alert("등록에 실패하였습니다.");
	       }
	    });		
	}
	
	//프로젝트 수정
	function fnProjectUpdate(){
		//데이터
		var projectName = $("#projectName").val();		//프로젝트명 
		var projectIntroduction = $("#projectIntroduction").val();		//프로젝트소개 
		var portfolioId_main = $("#portfolioId_main").val();
		var projectId = $("#projectId").val();
		var projectFileUrl =  $("#projectFileUrl_01").attr('src');	// 이미지경로
   		
   		
   		var form = $("#project-file-form")[0];
   		var formData = new FormData(form);
   		//formData.append("userId", userId);
   		formData.append("portfolioId", portfolioId_main);
   		formData.append("projectName", projectName);
   		formData.append("projectIntroduction", projectIntroduction);   
   		formData.append("projectId", projectId);
   		formData.append("projectFileUrl", projectFileUrl);
   		
		$.ajax({
	        type : 'POST',  
	        enctype: 'multipart/form-data',
	        url : '/studio/project/modifyProject',
	        data : formData,	       
	        processData: false,
     	    contentType: false,
     	    cache: false,	        
	        success : function(response) {
		        var resultList = response.data;
		        if(response.code == "SUCCESS"){
		        	closeModal('#layer-project');
		        	location.reload(); //페이지 리로딩
		        }	          
	       },error:function(){
	          //alert("수정 실패하였습니다.");
	       }
	    });
	}
	
	//포토폴리오 삭제
	function fnProjectDel(userIds,projectIds, portfolioIds){
		if(confirm('<spring:message code="portfolio.alert.msg3" text="프로젝트를 삭제 하시겠습니까? 등록된 컨텐츠가 모두 삭제됩니다." />')) {
			$.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : {"userId" : userIds ,"projectId" : projectIds ,"portfolioId" : portfolioIds },
		        url : '/studio/project/delProject',
		        success : function(response) {
		        	if(response.code == "SUCCESS"){
		        		fnProjectList(portfolioIds);
		        	}
		       },error:function(){
		          //alert("삭제에 실패하였습니다.");
		       }
		    });
	    } 	    
	}
	
	
	//이미지 숨김 처리 
	function fnImageRomove(type){ 
		if(type == "01"){
			$("#lb_file1").val("");
			$("#file_01").hide();
			$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
		}else if(type == "02"){
			$("#lb_file2").val("");
			$("#file_02").hide();
		}else if(type == "03"){
			$("#lb_file3").val("");
			$('#projectFile_01').hide();
			$('#projectButton').attr('disabled', true); 
		}
	}
	
	//포토폴리오 프로젝트 화면 이동 
	function fnProjectFrom(portfolioIds, projectIds){
		location.href= "/studio/project/projectForm?portfolioId="+ portfolioIds+"&projectId="+projectIds;		
	}
	
	//포트폴리오 제목 value
	function textPublicValue(value, code) {
		var str = $(value).text();
		$('#selectPublicType').text(str);
		
		var publicCode = $("#public_"+code).val();
		$('#publicTypeCode').val(publicCode);
		processkey();
		
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
				<%@ include file="../common/side-profile.jsp" %>

				<ul class="portfolio-detail-list" id="sidePortfolio">
				
				</ul>
			</aside>
			<article id="content">
				<h2 class="content-title"><spring:message code="menu7-2" text="Portafolio"/></h2>
				<div class="content-fixed portfolio-detail">
					<div class="content-header">
						<div class="inner">
							<h2 class="content-title d-down-md">Detalles de la portafolio</h2>
							<a href="#;" class="btn btn-back d-down-md">prev</a>			
							<a href="/studio/portfolio/portfolioFrom" class="btn btn-list"><spring:message code="button.list" text=""/></a>
						</div>
					</div>
					<div class="content-body style2">
						<div class="portfolio-detail-info">
							<div class="bg-image">
								<img id="backgroundImagePathTitle" src="/static/assets/images/common/_img-sample2.png" alt="">
							</div>
							<div class="info-area">
								<span id="portfolioTitle" class="name">Diseño De Aplicaciones</span>
								<span id="tagTitle" class="hashtag">#AppDesign#UI/UX</span>
								<div class="content">
									<p id="introductionTitle" style="white-space: pre-line;">Comparta información diversa con amigos que conoció en CLIC</p>
								</div>
								<input type="hidden" id="portfolioId_main" value="">
								<a href="#;" class="btn btn-modify" onclick="openModal('#layer-portfolio');" >modify</a>
							</div>
							<a href="#;" class="btn btn-md btn-secondary btn-project-add" onclick="fnOpenProject()"><spring:message code="portfolio.text18" text="Crea un proyecto"/></a> 
						</div>

						<ul class="project-list" id="projectView">
							
						</ul>
					</div>
				</div>
			</article>
		</div>
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->		
	</div>

	<!-- 레이어팝업 -->
	<div class="modal-popup modal-md2 hide" id="layer-portfolio">
		<div class="dimed"></div>
			<div class="popup-inner popup-portfolio">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="portfolio.text1" text="Información del portafolio"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-portfolio');">Close</button>
				</div>
				<div class="popup-body">
				<input type="hidden" id="portfolioId" value="">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="portfolioName"><spring:message code="portfolio.text2" text="Nombre del idiomas"/>*</label></dt>
								<dd>
									<input type="text" id="portfolioName" class="form-control">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><label for="introduction"><spring:message code="portfolio.text3" text="Introducción al portafolio"/></label></dt>
								<dd>
									<textarea id="introduction" rows="5" class="form-control"></textarea>
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><label for="tag"><spring:message code="portfolio.text4" text="Etiqueta de portafolio"/>*</label> <span class="text-guide">(<spring:message code="portfolio.text5" text="marcada con # sin espacios"/>)</span></dt>
								<dd>
									<input type="text" id="tag" class="form-control">
								</dd>
							</dl>
						</div>
						<form id="upload-file-form" method="POST" enctype="multipart/form-data" >
						<div class="form-item">
							<dl class="form-group form-file">
								<dt class="title2"><spring:message code="portfolio.text6" text="Imagen de la lista de portafolio"/>* <span class="text-guide">(<spring:message code="portfolio.text8" text="Tamaño recomendado"/> 480X600)</span></dt>
								<dd>
									<div class="file-attatch-wrap list-image">
										<div class="file-attatch-item">
											<!-- label for와 id 매칭 필수 -->
											<input type="file" id="lb_file1" name="files">
											<label for="lb_file1">
												<span class="d-up-lg">Registro de imagen</span>
												<span class="d-down-md">
													<em class="ico ico-upload"></em>
													imagen<br> Inscripción
												</span>
											</label>
										</div>

										<!-- 업로드 후 노출 -->										
										<div class="attatched-file" id="file_01" style="display:none">
											<div>
												<div class="image-area">
													<img id="fileUrl_01" src="/static/assets/images/common/_img-sample.jpg" alt="">
												</div>
												<button type="button" class="btn btn-delete" onclick="fnImageRomove('01');">delete</button>
											</div>
										</div>										
										<!-- // 업로드 후 노출 -->
									</div>
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group form-file">
								<dt class="title2"><spring:message code="portfolio.text7" text="Imágenes de portfolio wallpapers"/> <span class="text-guide">(<spring:message code="portfolio.text8" text="Tamaño recomendado"/> 940X300)</span></dt>
								<dd>
									<div class="file-attatch-wrap bg-image">
										<div class="file-attatch-item">
											<!-- label for와 id 매칭 필수 -->
											<input type="file" id="lb_file2" name="files">
											<label for="lb_file2">
												<span class="d-up-lg">Registro de imagen</span>
												<span class="d-down-md">
													<em class="ico ico-upload"></em>
													imagen Inscripción
												</span>
											</label>
										</div>

										<!-- 업로드 후 노출 -->										
										<div class="attatched-file" id="file_02" style="display:none">
											<div>
												<div class="image-area">
													<img id="fileUrl_02" src="/static/assets/images/common/_img-sample.jpg" alt="">
												</div>
												<button type="button" class="btn btn-delete" onclick="fnImageRomove('02');">delete</button>
											</div>
										</div>
										<!-- // 업로드 후 노출 -->
									</div>
								</dd>
							</dl>
						</div>
						</form>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><spring:message code="portfolio.text9" text="Entorno público"/>*</dt>
								<dd>
								<input type="hidden" id="publicTypeCode" value="1801">
									<dl class="dropdown-select up on">
										<dt><a href="#;" id="selectPublicType" class="btn">Seleccionar</a></dt>
										<dd style="bottom: -258px;"><!-- // bottom: -{레이어 높이값}px 변경 -->
											<div class="dimed"></div>
											<div class="dropdown-inner custom-scroll" style="height: 310px;"><!-- // height: {레이어 높이값}px 변경 -->
												<span class="dropdown-title">Entorno público</span>
												<ul class="dropdown-list" id="publicForm">
													
												</ul>
											</div>
										</dd>
									</dl>
								</dd>
							</dl>
							<dl class="form-group ml-lg-16 mb-md-6">
								<dt class="title2">Ya sea para usar el código QR*</dt>
								<dd>
									<span class="check-item">
										<input type="radio" name="isUseQr" id="isUseQr_1" value="Y" checked>
										<label for="isUseQr_1"><spring:message code="portfolio.text14" text="Usar"/></label>
									</span>
									<span class="check-item">
										<input type="radio" name="isUseQr" id="isUseQr_2" value="N">
										<label for="isUseQr_2"><spring:message code="portfolio.text15" text="No Utilizado"/></label>
									</span>
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">  
					<div class="btn-group-default btn-fixed">
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-portfolio');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="saveButton" disabled onclick="fnPortfolioSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
	</div>

	<!-- 프로젝트 등록 팝업 -->
	<div class="modal-popup modal-md2 hide" id="layer-project">
		<div class="dimed"></div>
			<div class="popup-inner popup-project">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="portfolio.text19" text="Información del proyecto"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-project');">Close</button>
				</div>
				<div class="popup-body">
					<input type="hidden" id="projectId" value="">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="projectName"><spring:message code="portfolio.text20" text="Nombre del proyecto"/>*</label></dt>
								<dd>
									<input type="text" id="projectName" class="form-control">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><label for="projectIntroduction"><spring:message code="portfolio.text21" text="Introducción al proyecto"/></label></dt>
								<dd>
									<textarea id="projectIntroduction" rows="5" class="form-control"></textarea>
								</dd>
							</dl>
						</div>
						<form id="project-file-form" method="POST" enctype="multipart/form-data" >
						<div class="form-item">
							<dl class="form-group form-file">						
								<dt class="title2"><spring:message code="portfolio.text22" text="Imagen de la lista de proyecto"/>* <span class="text-guide">(<spring:message code="portfolio.text8" text="Tamaño recomendado"/> 600X400)</span></dt>
								<dd>
									<div class="file-attatch-wrap list-image">
										<div class="file-attatch-item">
											<!-- label for와 id 매칭 필수 -->
											<input type="file" id="lb_file3" name="projectFile">
											<label for="lb_file3">
												<span class="d-up-lg">Registro de imagen</span>
												<span class="d-down-md">
													<em class="ico ico-upload"></em>
													imagen<br> Inscripción
												</span>
											</label>
										</div>

										<!-- 업로드 후 노출 -->										
										<div class="attatched-file" id="projectFile_01" style="display:none">
											<div>
												<div class="image-area">
													<img id="projectFileUrl_01" src="/static/assets/images/common/_img-sample.jpg" alt="">
												</div>
												<button type="button" class="btn btn-delete" onclick="fnImageRomove('03');">delete</button>
											</div>
										</div>										
										<!-- // 업로드 후 노출 -->
									</div>
								</dd>
							</dl>
						</div>
						</form>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-project');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="projectButton" onclick="fnProjectSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
	</div>
</body>
</html>