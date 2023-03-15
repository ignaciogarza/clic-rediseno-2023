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
	//var userId = "${userId}";	
	//var portfolioId = "${portfolioId}";
	//var projectId = "${projectId}";
	
	var portfolioId = getParameterByNames('portfolioId');
	var projectId = getParameterByNames('projectId');
	
	function getParameterByNames(name) { 
		name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
		var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
		results = regex.exec(location.search); 
		return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
	}
	
	$(document).ready(function () {
		getSidePortfolio();		//포토폴리오  좌측 세팅
		
		//프로젝트 상세 데이터 세팅 
		fnProjectMainDate(projectId)
		
		//프로젝트 컨첸츠 리스트 
		fnProjectContentsList(projectId);
		
		
		$('#projectUPName').on('input',projectProcesskey);
		$('#lb_file3').on('input',projectProcesskey);
		
		/* $('#contentsNameImage').on('input',contentProcesskey("1901"));
		$('#lb_file4').on('input',contentProcesskey("1901"));
		
		$('#contentsNameVideo').on('input',contentProcesskey("1903"));
		$('#contentsUrlVideo').on('input',contentProcesskey("1903"));
		
		$('#contentsNameAudio').on('input',contentProcesskey("1906"));
		$('#contentsUrlAudio').on('input',contentProcesskey("1906"));
		
		$('#contentsNameDocument').on('input',contentProcesskey("1904"));
		$('#lb_file5').on('input',contentProcesskey("1904")); */
		
		
		
		$('#contentsNameImage').on('input',contentProcesskey);
		$('#lb_file4').on('input',contentProcesskey);
		
		$('#contentsNameVideo').on('input',contentProcesskey);
		$('#contentsUrlVideo').on('input',contentProcesskey);
		
		$('#contentsNameAudio').on('input',contentProcesskey);
		$('#contentsUrlAudio').on('input',contentProcesskey);
		
		$('#contentsNameDocument').on('input',contentProcesskey);
		$('#lb_file5').on('input',contentProcesskey);
		
		
		
		
		//========================프로필 이미지 미리보기=================================	
		$(function() {   
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
           
		   $("#lb_file4").on('change', function(){
			    var fileName =  $("#lb_file4").val(); 
        		fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
        		if(fileName != "jpg" && fileName != "png" &&  fileName != "gif" &&  fileName != "bmp"){
        			alert('<spring:message code="resume.text14" text="이미지 파일만 등록 가능합니다." />');
        			$("#lb_file4").val("");
        			return false;
        		}
        		
        	    readURL_04(this);
           });
           
           $("#lb_file5").on('change', function(){
        	   var fileName =  $("#lb_file5").val(); 
        		fileName = fileName.slice(fileName.indexOf(".") + 1).toLowerCase();
        		if(fileName != "pdf"){
        			alert("문서 파일은 (pdf) 형식만 등록 가능합니다.");
        			$("#lb_file5").val("");
        			return false;
        		}
        		
        	   readURL_05(this);//문서
           });
        });
		
		function readURL_03(input) {
           if (input.files && input.files[0]) {
              var reader = new FileReader();
              reader.onload = function (e) {
                 //$('#preImage').attr('src', e.target.result);
                 $('#projectUPFile_01').show();
                 $('#projectUPFileUrl_01').attr('src', e.target.result);
              }
              reader.readAsDataURL(input.files[0]);
           }
        }
		
		function readURL_04(input) {
           if (input.files && input.files[0]) {
              var reader = new FileReader();
              reader.onload = function (e) {
                 //$('#preImage').attr('src', e.target.result);
                 $('#contentFile_01').show();
                 $('#contentFileUrl_01').attr('src', e.target.result);
              }
              reader.readAsDataURL(input.files[0]);
           }
        }
		
		function readURL_05(input) {
           if (input.files && input.files[0]) {
              var reader = new FileReader();
              reader.onload = function (e) {
                 //$('#preImage').attr('src', e.target.result);
                 $('#contentFile_02').show();
                 $('#contentFileText_02').text(input.files[0].name);
              }
              reader.readAsDataURL(input.files[0]);
           }
        }
			
			
		//========================프로필 이미지 미리보기=================================	
	});
	
	 function projectProcesskey(){
		  var projectName = $("#projectUPName").val();		
	      var lb_file3 = $("#lb_file3").val();	   	  
	      var fileUrl_01 = $("#projectUPFileUrl_01").attr("src");
	   	 
	   	 if(projectName == ""  || (lb_file3 == "" && fileUrl_01 == "")){	   		
	   		$('#projectButton').attr('disabled', true); 			//번튼 딤 처리 
	     }else {
	        $('#projectButton').attr('disabled', false);			//버튼 해제 
	     }
	  }
	 
	 function contentProcesskey(){
			 //이미지
			 var contentsNameImage = $("#contentsNameImage").val();		
		     var lb_file4 = $("#lb_file4").val();	   	
		     var contentFileUrl_01 = $('#contentFileUrl_01').attr("src");
		   	 
		   	 if(contentsNameImage == "" || (lb_file4 == "" && contentFileUrl_01 == "") ){	   		
		   		$('#contentButtonImage').attr('disabled', true); 			//번튼 딤 처리 
		     }else {
		        $('#contentButtonImage').attr('disabled', false);			//버튼 해제 
		     }
		
		   	 //비디오
			 var contentsNameVideo = $("#contentsNameVideo").val();		
		     var contentsUrlVideo = $("#contentsUrlVideo").val();	   	  
		   	 
		   	 if(contentsNameVideo == "" || contentsUrlVideo == ""){	   		
		   		$('#contentButtonVideo').attr('disabled', true); 			//번튼 딤 처리 
		     }else {
		        $('#contentButtonVideo').attr('disabled', false);			//버튼 해제 
		     }					
		
		   	 //오디오
			 var contentsNameAudio = $("#contentsNameAudio").val();		
		     var contentsUrlAudio = $("#contentsUrlAudio").val();	   	  
		   	 
		   	 if(contentsNameAudio == "" || contentsUrlAudio == ""){	   		
		   		$('#contentButtonAudio').attr('disabled', true); 			//번튼 딤 처리 
		     }else {
		        $('#contentButtonAudio').attr('disabled', false);			//버튼 해제 
		     }		
		
		   	 //문서
			 var contentsNameDocument = $("#contentsNameDocument").val();		
		     var lb_file5 = $("#lb_file5").val();	   	  
		     var contentFileText_02 = $('#contentFileText_02').val();
		     
		   	 if(contentsNameDocument == "" || (lb_file5 == "" && contentFileText_02 == "") ){	   		
		   		$('#contentButtonDocument').attr('disabled', true); 			//번튼 딤 처리    
		     }else {
		        $('#contentButtonDocument').attr('disabled', false);			//버튼 해제 
		     }	
		 
	  }
	 
	 
	
	
	//이미지 숨김 처리 
	function fnImageRomove(type){ 
		if(type == "03"){
			$("#lb_file3").val("");
			$("#projectUPFile_01").hide();
			$('#projectButton').attr('disabled', true); 			//번튼 딤 처리 
		}else if(type == "04"){
			$("#lb_file4").val("");
			$('#contentButtonImage').attr('disabled', true); 			//번튼 딤 처리 
			$("#contentFile_01").hide();
		}else if(type == "05"){
			$("#lb_file5").val("");
			$('#contentButtonDocument').attr('disabled', true); 			//번튼 딤 처리 
			$('#contentFile_02').hide();
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
						html += '<li class="on" id="sideTitle_'+(i+1)+'" data-portfolioid="'+resultList[i].portfolioId+'"><a href="#;" onclick="fnProjectView(\''+resultList[i].portfolioId+'\');">'+resultList[i].name+'</a></li>';		
					}else{
						html += '<li id="sideTitle_'+(i+1)+'" data-portfolioid="'+resultList[i].portfolioId+'"><a href="#;" onclick="fnProjectView(\''+resultList[i].portfolioId+'\');">'+resultList[i].name+'</a></li>';		
					}			
				  }				   
			  }			 
	          /* var noListLength = 3-resultList.length;
			  for (var j = 0; j < noListLength; j++) {
				     html += '<li id="sideTitle_3"><a href="#;" onclick="fnPortfolioDetail(\'\',\'\');">portalfolio title</a></li>';
			  } */
			  $("#sidePortfolio").append(html);  
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//프로젝트 상세 보기 
	function fnProjectMainDate(projectId){		   		
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
		          
	        	  
	        	  $("#mainName").text(newName);//프로젝트명 
	        	  $("#mainIntroduction").text(newIntroduction);		//프로젝트소개 
	        	  $("#mainLikeCount").text(data.likeCount);	        	 
	          }
	          
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    });
	}
	
	
	
	//프로젝트 리스트 생성
	function fnProjectContentsList(projectIds){
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : {"userId" : userId, "projectId" : projectId },
	        data : {"projectId" : projectId },
	        url : '/studio/project/projectContentsList',
	        success : function(response) {
	          var resultList = response.data.projectList;
	          
	          
	          
	          var contentHtml = '';
	          var contentList = response.data.contentList;
	          if(contentList != null && contentList.length > 0){
		       		for (var i = 0; i < contentList.length; i++) {
		       			contentHtml += '<li><a href="#;" onclick="fnOpenProject(\''+contentList[i].major+contentList[i].minor+'\');">'+contentList[i].name+'</a></li>';
					}
	          }		
	          $("#contentForm").append(contentHtml);  
	          
	          
	          var html = '';
	          var html_image = '';
	          var html_video = '';
	          var html_audio = '';
	          var html_document = '';
	          var html_badge = '';	          
	          
	          $("#ContentView_image").empty();  
			  $("#ContentView_video").empty();  
			  $("#ContentView_audio").empty();  
			  $("#ContentView_documentos").empty();  
			  $("#ContentView_badge").empty(); 
	          if(resultList != null && resultList.length > 0){
	        	
				for (var i = 0; i < resultList.length; i++) {
					if(resultList[i].contentsTypeCode == "1901"){
						html_image += '<li>';
						html_image += '	<a href="#" class="thumb" target="_blank" onclick="fnProjectImageView()">';
						html_image += '		<img src="'+resultList[i].contentsPath+'" alt="">';
						html_image += '	</a>';
						html_image += '	<div class="info-area">';
						html_image += '		<span class="title">'+resultList[i].contentsName+'</span>';
						html_image += '		<span class="date">'+resultList[i].updatedDate+'</span>';
						html_image += '		<dl class="portfolio-ctrl">';
						html_image += '			<dt><a href="#;" class="btn btn-edit">edit</a></dt>';
						html_image += '			<dd>';
						html_image += '				<ul class="btn-list">';
						html_image += '					<li><a href="#;" class="btn btn-modify" onclick="fnProjectContentsDetail(\''+resultList[i].projectContentsId+'\',\'1901\');">Modificar</a></li>';
						//html_image += '					<li><a href="#;" class="btn btn-modify" onclick="openModal(\'#layer-image\');">Modificar</a></li>';
						html_image += '					<li><button type="button" class="btn btn-delete" onclick="fnProjectContentsDel(\''+resultList[i].userId+'\',\''+resultList[i].projectContentsId+'\');">Eliminar</button></li>';
						html_image += '				</ul>';
						html_image += '			</dd>';
						html_image += '		</dl>';
						html_image += '	</div>';
						html_image += '</li>';
						$("#imageView").show();
					}else if(resultList[i].contentsTypeCode == "1903"){
						//// 비디오 
						html_video += '<li>';
						html_video += '	<div class="thumb">';
						html_video += '		<iframe src="'+resultList[i].contentsUrl+'" title="YouTube video player" style="width: 100%; height: 100%; border:0; margin:0; padding:0;" allowfullscreen></iframe>';
						html_video += '	</div>';
						html_video += '	<div class="info-area">';
						html_video += '		<span class="title">'+resultList[i].contentsName+'</span>';
						html_video += '		<span class="date">'+resultList[i].updatedDate+'</span>';
						html_video += '		<dl class="portfolio-ctrl">';
						html_video += '			<dt><a href="#;" class="btn btn-edit">edit</a></dt>';
						html_video += '			<dd>';
						html_video += '				<ul class="btn-list">';
						html_video += '					<li><a href="#;" class="btn btn-modify" onclick="fnProjectContentsDetail(\''+resultList[i].projectContentsId+'\',\'1903\');">Modificar</a></li>';
						//html_video += '					<li><a href="#;" class="btn btn-modify" onclick="openModal(\'#layer-video\');">Modificar</a></li>';
						html_video += '					<li><button type="button" class="btn btn-delete" onclick="fnProjectContentsDel(\''+resultList[i].userId+'\',\''+resultList[i].projectContentsId+'\');">Eliminar</button></li>';
						html_video += '				</ul>';
						html_video += '			</dd>';
						html_video += '		</dl>';
						html_video += '	</div>';
						html_video += '</li>';
						$("#videosView").show();
					}else if(resultList[i].contentsTypeCode == "1906"){
						////  오디오
						html_audio += '<li>';
						html_audio += '	<div class="thumb">';
						html_audio += '		<iframe src="'+resultList[i].contentsUrl+'"  style="width: 100%; height: 100%; border:0; margin:0; padding:0;"></iframe>';
						html_audio += '	</div>';
						html_audio += '	<div class="info-area">';
						html_audio += '		<span class="title">'+resultList[i].contentsName+'</span>';
						html_audio += '		<span class="date">'+resultList[i].updatedDate+'</span>';
						html_audio += '		<dl class="portfolio-ctrl">';
						html_audio += '			<dt><a href="#;" class="btn btn-edit">edit</a></dt>';
						html_audio += '			<dd>';
						html_audio += '				<ul class="btn-list">';
						html_audio += '					<li><a href="#;" class="btn btn-modify" onclick="fnProjectContentsDetail(\''+resultList[i].projectContentsId+'\',\'1906\');">Modificar</a></li>';
						//html_audio += '					<li><a href="#;" class="btn btn-modify" onclick="openModal(\'#layer-audio\');">Modificar</a></li>';
						html_audio += '					<li><button type="button" class="btn btn-delete" onclick="fnProjectContentsDel(\''+resultList[i].userId+'\',\''+resultList[i].projectContentsId+'\');">Eliminar</button></li>';
						html_audio += '				</ul>';
						html_audio += '			</dd>';
						html_audio += '		</dl>';
						html_audio += '	</div>';
						html_audio += '</li>';
						$("#audioView").show();
					}else if(resultList[i].contentsTypeCode == "1904"){
						///////문서
						html_document += '<li>';
						html_document += '	<div class="box box-document">';
						html_document += '		<a class="btn" href="'+resultList[i].contentsPath+'" target="_blank">';
						html_document += '		<div class="info-area">';
						html_document += '			<span class="title">'+resultList[i].contentsName+'</span>';
						html_document += '			<span class="date">'+resultList[i].updatedDate+'</span>';
						html_document += '		</div>';
						html_document += '		</a>';
						html_document += '		<dl class="portfolio-ctrl">';
						html_document += '			<dt><a href="#;" class="btn btn-edit">edit</a></dt>';
						html_document += '			<dd>';
						html_document += '				<ul class="btn-list">';
						html_document += '					<li><a href="#;" class="btn btn-modify" onclick="fnProjectContentsDetail(\''+resultList[i].projectContentsId+'\',\'1904\');">Modificar</a></li>';
						//html_document += '					<li><a href="#;" class="btn btn-modify" onclick="openModal(\'#layer-document\');">Modificar</a></li>';
						html_document += '					<li><button type="button" class="btn btn-delete" onclick="fnProjectContentsDel(\''+resultList[i].userId+'\',\''+resultList[i].projectContentsId+'\');">Eliminar</button></li>';
						html_document += '				</ul>';
						html_document += '			</dd>';
						html_document += '		</dl>';
						html_document += '	</div>';
						html_document += '</li>';
						$("#documentosView").show();
					}else if(resultList[i].contentsTypeCode == "1907"){
						//뱃지
						html_badge += '<li>';
						html_badge += '	<div class="box box-badge">';
						html_badge += '		<div class="image-area">';
						html_badge +='		<input type="hidden" name="skillCode" id="skillCode_'+(i+1)+'" value="'+resultList[i].skillCode+'">'
						html_badge += '			<img src="'+resultList[i].contentsPath+'" alt="">';
						html_badge += '		</div>';
						html_badge += '		<span class="name">'+resultList[i].contentsName+'</span>';
						html_badge += '	</div>';
						html_badge += '</li>';
						$("#badgeView").show();
					}			 
				}				   
			  }			 
			  $("#ContentView_image").append(html_image);  
			  $("#ContentView_video").append(html_video);  
			  $("#ContentView_audio").append(html_audio);  
			  $("#ContentView_documentos").append(html_document);  
			  $("#ContentView_badge").append(html_badge);  
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	
	//프로젝트 등록 view 오픈
	function fnOpenProject(type){
		
		$("#typeImage").val('');			//이미지
		$("#typeVideo").val('');			//비디오
		$("#typeAudio").val('');			//오디오
		$("#typeDocument").val('');	//문서 
		$("#typeBadge").val('');			//뱃지
		
		if(type == "1901"){
			$("#typeImage").val("1901");			//이미지
			$("#contentsNameImage").val('');
	        $("#contentFile_01").hide();
	        $('#contentButtonImage').attr('disabled', true);  
	        $("#contentButtonImage").attr("onClick", "fnContentSave()");	//수정 function 변경 
			openModal('#layer-image');			
		}else if(type == "1903"){
			$("#typeVideo").val("1903");			//비디오
			$("#contentsNameVideo").val('');
    		$("#contentsUrlVideo").val('');	
    		$('#contentButtonVideo').attr('disabled', true);
    		$("#contentButtonVideo").attr("onClick", "fnContentSave()");	//수정 function 변경 
			openModal('#layer-video');			
		}else if(type == "1906"){
			$("#typeAudio").val("1906");			//오디오
			$("#contentsNameAudio").val('');
    		$("#contentsUrlAudio").val('');	
    		$('#contentButtonAudio').attr('disabled', true);
    		$("#contentButtonAudio").attr("onClick", "fnContentSave()");	//수정 function 변경 
			openModal('#layer-audio');
		}else if(type == "1904"){
			$("#typeDocument").val("1904");	//문서
			$("#contentsNameDocument").val('');
    		$("#contentFileText_02").text('');		        		 
    		$("#contentFile_02").hide();
    		$('#contentButtonDocument').attr('disabled', true);
    		$("#contentButtonDocument").attr("onClick", "fnContentSave()");	//수정 function 변경
			openModal('#layer-document');
		}else if(type == "1907"){
			$("#typeBadge").val("1907");			//뱃지
			//openModal('#layer-badge');
			//뱃지 리스트 호출 해야함 
			fnBadgeList();
		}		
	}
	
	
	//뱃지 리스트 리스트 생성
	function fnBadgeList(){
		$("#typeBadge").val("1907");
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {},
	        url : '/studio/project/getBadgeList',
	        success : function(response) {
	          var resultList = response.data;	          
	          var html = ''; 
	          $("#badgeLayerView").empty();
	          if(resultList != null && resultList.length > 0){
	        	  $('#contentButtonBadge').attr('disabled', false); 
	        	  html +='<ul class="mybadge-area">';
				 for (var i = 0; i < resultList.length; i++) {
					 html +='<input type="hidden" id="badgeId_'+(i+1)+'" value="'+resultList[i].badgeId+'">'
					 html +='	<li>';
					 html +='		<span class="check-item">';	
					 html +='			<input type="checkbox" id="inputCheck1_'+(i+1)+'" name="badgeCkeck" value="'+resultList[i].skillCode+'" data-badgepath="'+resultList[i].badgeObtainImagePath+'" data-badgename="'+resultList[i].badgeName+'">';
					 html +='			<label for="inputCheck1_'+(i+1)+'">';
					 html +='				<div class="box box-badge">';
					 html +='					<div class="image-area">';
					 html +='						<img src="'+resultList[i].badgeObtainImagePath+'" alt="">';
					 html +='					</div>';
					 html +='					<span class="name">'+resultList[i].badgeName+'</span>';
					 html +='				</div>';
					 html +='			</label>';
					 html +='		</span>';
					 html +='	</li>';
				 }
				 html +='</ul>';
	          }else{
	        	  html +='	<div class="no-data">';
	           	  html +='		<p class="text">No hay insignias ganadas</p>';
	        	  html +='	</div>';
	        	  
	        	  $('#contentButtonBadge').attr('disabled', true); 
	          } 	          
	          $("#badgeLayerView").append(html);  	          
	          
	       // 선택된 뱃지 세팅 
	  		var skillCode = [];
	  		$("input[name=skillCode]").each(function(){
	  			var val = $(this).val();
	  			skillCode.push(val);
	  		});
	          
	        //선택된 뱃지 선택 세팅 
	        for(var i = 0; i < skillCode.length; i++){
	          for (var j = 0; j < resultList.length; j++) {
		       	  if(skillCode[i] == resultList[j].skillCode){
		       		  $("#inputCheck1_"+ (j+1)).prop('checked', true); 
		       	  }						 
			  }
	        } 
	        openModal('#layer-badge');
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	
	//프로젝트 등록 
	function fnContentSave(){
		//데이터		
		var contentsName= '';		//컨텐츠명  		
		var contentsNameImage = $("#contentsNameImage").val();
		var contentsNameVideo = $("#contentsNameVideo").val();
		var contentsNameAudio = $("#contentsNameAudio").val();
		var contentsNameDocument = $("#contentsNameDocument").val();
		
		var contentsUrl = '';			//컨첸츠 경로		
		var contentsUrlVideo = $("#contentsUrlVideo").val();
		var contentsUrlAudio = $("#contentsUrlAudio").val();
		
		var contentsTypeCode;	//컨첸츠 종류
		
		var typeImage = $("#typeImage").val();			//이미지
		var typeVideo = $("#typeVideo").val();			//비디오
		var typeAudio = $("#typeAudio").val();			//오디오
		var typeDocument = $("#typeDocument").val();	//문서 
		var typeBadge = $("#typeBadge").val();			//뱃지
		
		if(typeImage == "1901"){
			contentsTypeCode = typeImage;				//
			contentsName = contentsNameImage;
		}else if(typeVideo == "1903"){
			if (contentsUrlVideo.indexOf("youtu") == -1) {
				alert('<spring:message code="portfolio.alert.msg5" text="Youtube 영상 링크만 등록 가능합니다."/>');
				return false;
			}
			contentsTypeCode = typeVideo;
			contentsName = contentsNameVideo;
			//youtube url 변경 로직 추가 
			//var strUrl = getParameterByName(contentsUrlVideo,"v");			
			//contentsUrlVideo = "https://www.youtube.com/embed/"+strUrl;			
			contentsUrl = contentsUrlVideo;
		}else if(typeAudio == "1906"){
			//soundcloud 값이 포함 되어 있는지 체크 			
			if (contentsUrlAudio.indexOf("soundcloud") == -1) {
				alert('<spring:message code="portfolio.alert.msg7" text="soundcloud 코드를 입력해주세요."/>');				
				return false;
			}
			contentsTypeCode = typeAudio;
			contentsName = contentsNameAudio;
			contentsUrl = contentsUrlAudio;
		}else if(typeDocument == "1904"){
			contentsTypeCode = typeDocument;
			contentsName = contentsNameDocument;
		}else if(typeBadge == "1907"){
			contentsTypeCode = typeBadge;
		}	
		
		
		var chk_arr = [];
		var chk_path = [];
		var chk_name = [];
		if(typeBadge == "1907"){
			
			$("input[name=badgeCkeck]:checked").each(function(){
				var chk = $(this).val();
				var badgePath = $(this).data("badgepath");
				var badgeName = $(this).data("badgename");				
				chk_arr.push(chk);
				chk_path.push(badgePath);
				chk_name.push(badgeName);
			});
		}	
		
		
		var form;		
		if(typeImage == "1901"){
			form = $("#contentImg-file-form")[0];
		}else if(typeDocument == "1904"){
			form = $("#contentDocument-file-form")[0];
		}else{
			form = $("#contentImg-file-form")[0];
		}
		
   		//var form = $("#contentImg-file-form")[0];
   		var formData = new FormData(form);
   		//formData.append("userId", userId);
   		formData.append("projectId", projectId);   		
   		formData.append("contentsTypeCode", contentsTypeCode);
   		formData.append("contentsName", contentsName);
   		formData.append("contentsUrl", contentsUrl);
   		formData.append("chk_arr", chk_arr);
   		formData.append("chk_path", chk_path);
   		formData.append("chk_name", chk_name);
   		
   		
		$.ajax({
	        type : 'POST',  
	        enctype: 'multipart/form-data',
	        url : '/studio/project/saveProjectContents',
	        data : formData,	       
	        processData: false,
     	    contentType: false,
     	    cache: false,	        
	        success : function(response) {
		        var resultList = response.data;
		        if(response.code == "SUCCESS"){
		        	//alert("저장성공 했습니다.");
		        	/* if(contentsTypeCode == "이미지 "){
		        		closeModal('#layer-image');
		        	}else if(contentsTypeCode == "비디오"){
		        		closeModal('#layer-video');
		        	} */
		        	
		        	location.reload(); //페이지 리로딩
		        }	          
	       },error:function(){
	          alert("등록에 실패하였습니다.");
	       }
	    });		
	}
	
	
	function getParameterByName(url, name) {
	    name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]");
	    var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"),
	        results = regex.exec(url);
	    return results === null ? "" : decodeURIComponent(results[1].replace(/\+/g, " "));
	}

	
	//프로젝트 수정 
	function fnProjectContentsUpdate(projectContentsIds){
		//데이터
		
		var contentsName= '';		//컨텐츠명  		
		var contentsNameImage = $("#contentsNameImage").val();
		var contentsNameVideo = $("#contentsNameVideo").val();
		var contentsNameAudio = $("#contentsNameAudio").val();
		var contentsNameDocument = $("#contentsNameDocument").val();
		
		var contentsUrl = '';			//컨첸츠 경로		
		var contentsUrlVideo = $("#contentsUrlVideo").val();
		var contentsUrlAudio = $("#contentsUrlAudio").val();		
				
		var contentsTypeCode;	//컨첸츠 종류
		
		var typeImage = $("#typeImage").val();			//이미지
		var typeVideo = $("#typeVideo").val();			//비디오
		var typeAudio = $("#typeAudio").val();			//오디오
		var typeDocument = $("#typeDocument").val();	//문서 
		var typeBadge = $("#typeBadge").val();			//뱃지
		
		if(typeImage == "1901"){
			contentsTypeCode = typeImage;				//
			contentsName = contentsNameImage;
		}else if(typeVideo == "1903"){
			contentsTypeCode = typeVideo;
			contentsName = contentsNameVideo;
			contentsUrl = contentsUrlVideo;
		}else if(typeAudio == "1906"){
			contentsTypeCode = typeAudio;
			contentsName = contentsNameAudio;
			contentsUrl = contentsUrlAudio;
		}else if(typeDocument == "1904"){
			contentsTypeCode = typeDocument;
			contentsName = contentsNameDocument;
		}else if(typeBadge == "1907"){
			contentsTypeCode = typeBadge;
		}		
		
		var form;		
		if(typeImage == "1901"){
			form = $("#contentImg-file-form")[0];
		}else if(typeDocument == "1904"){
			form = $("#contentDocument-file-form")[0];
		}
		
   		//var form = $("#contentImg-file-form")[0];
   		var formData = new FormData(form);   		
   		formData.append("projectContentsId", projectContentsIds);
   		formData.append("contentsName", contentsName);
   		formData.append("contentsUrl", contentsUrl);   		   		
   		
		$.ajax({
	        type : 'POST',  
	        enctype: 'multipart/form-data',
	        url : '/studio/project/updateProjectContents',  
	        data : formData,	       
	        processData: false,
     	    contentType: false,
     	    cache: false,	        
	        success : function(response) {
		        var resultList = response.data;
		        if(response.code == "SUCCESS"){
		        	//alert("저장성공 했습니다.");
		        	/* if(contentsTypeCode == "이미지 "){
		        		closeModal('#layer-image');
		        	}else if(contentsTypeCode == "비디오"){
		        		closeModal('#layer-video');
		        	} */		        	
		        	location.reload(); //페이지 리로딩
		        }	          
	       },error:function(){
	          alert("등록에 실패하였습니다.");
	       }
	    });		
	}
	
	//프로젝트 컨첸츠 상세 보기 
	function fnProjectContentsDetail(projectContentsIds, type){
		
		//데이터 초기하 
		$("#projectName").val("");		//포토폴리오명 
   	  	$("#projectIntroduction").val("");			//포토폴리오 소개   	  	
   		$("#projectFile_01").hide();
		
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        //data : {"userId": userId, "projectId" : projectId, "projectContentsId" : projectContentsIds},
	        data : {"projectId" : projectId, "projectContentsId" : projectContentsIds},
	        url : '/studio/project/getProjectContentsDetail',
	        success : function(response) {
	          var data = response.data;	 
	          var reName = data.contentsName;	        	  
        	  var newName = reName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
	          if(data != null){
		        	if(type == "1901"){	//이미지
		        		$("#typeImage").val("1901");			//이미지
		        		$("#contentsNameImage").val(newName);
		        		$("#contentFileUrl_01").attr("src", data.contentsPath);
		        		$("#contentFile_01").show();
		        		$('#contentButtonImage').attr('disabled', false);  
		        		$("#contentButtonImage").attr("onClick", "fnProjectContentsUpdate(\'"+projectContentsIds+"\')");	//수정 function 변경 
		        		openModal('#layer-image');
		      		}else if(type == "1903"){	//비디오
		      			$("#typeVideo").val("1903");			//비디오
		      			$("#contentsNameVideo").val(newName);
		        		$("#contentsUrlVideo").val(data.contentsUrl);	
		        		$('#contentButtonVideo').attr('disabled', false);  
		        		$("#contentButtonVideo").attr("onClick", "fnProjectContentsUpdate(\'"+projectContentsIds+"\')");	//수정 function 변경 
		      			openModal('#layer-video	');	
		      		}else if(type == "1906"){	//오디오
		      			$("#typeAudio").val("1906");			//오디오
		      			$("#contentsNameAudio").val(newName);
		        		$("#contentsUrlAudio").val(data.contentsUrl);	
		        		$('#contentButtonAudio').attr('disabled', false);  
		        		$("#contentButtonAudio").attr("onClick", "fnProjectContentsUpdate(\'"+projectContentsIds+"\')");	//수정 function 변경 
		      			openModal('#layer-audio');
		      		}else if(type == "1904"){		//문서
		      			$("#typeDocument").val("1904");	//문서
		      			$("#contentsNameDocument").val(newName);
		        		$("#contentFileText_02").text(data.contentsPath);
		        		$('#contentButtonDocument').attr('disabled', false);  
		        		$("#contentButtonDocument").attr("onClick", "fnProjectContentsUpdate(\'"+projectContentsIds+"\')");	//수정 function 변경 
		        		$("#contentFile_02").show();
		      			openModal('#layer-document');
		      		}else if(type == "1907"){	//뱃지
		      			$("#typeBadge").val("1907");			//뱃지	
		      			//$("#contentButtonBadge").attr("onClick", "fnProjectContentsUpdate(\'"+projectContentsIds+"\')");	//수정 function 변경 
		      			
		      		}	        	 
	          }else{
	        	   if(type == "1901"){	//이미지
		        		$("#contentsNameImage").val('');
		        		$("#contentFile_01").hide();
		        		$("#contentButtonImage").attr("onClick", "fnContentSave()");	//수정 function 변경 
		        		openModal('#layer-image');
		      		}else if(type == "1903"){	//비디오
		      			$("#contentsNameVideo").val('');
		        		$("#contentsUrlVideo").val('');	
		        		$("#contentButtonVideo").attr("onClick", "fnContentSave()");	//수정 function 변경 
		      			openModal('#layer-video	');	
		      		}else if(type == "1906"){	//오디오
		      			$("#contentsNameAudio").val('');
		        		$("#contentsUrlAudio").val('');	
		        		$("#contentButtonAudio").attr("onClick", "fnContentSave()");	//수정 function 변경 
		      			openModal('#layer-audio');
		      		}else if(type == "1904"){		//문서
		      			$("#contentsNameDocument").val('');
		        		$("#contentFileText_02").text('');		        		 
		        		$("#contentFile_02").hide();
		        		$("#contentButtonDocument").attr("onClick", "fnContentSave()");	//수정 function 변경
		      			openModal('#layer-document');
		      		}else if(type == "1907"){	//뱃지
		      			//$("#contentButtonBadge").attr("onClick", "fnContentSave()");	//수정 function 변경 
		      		}	   
	          }
	          //openModal('#layer-project');
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    });
	}	
	
	
	//프로젝트 상세 보기 
	function fnProjectDetail(){
		
		//데이터 초기하 
		$("#projectUPName").val("");		//포토폴리오명 
   	  	$("#projectUPIntroduction").val("");			//포토폴리오 소개   	  	
   		$("#projectUPFile_01").hide();
		
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
	        	  
	        	  $("#projectUPName").val(newName);//프로젝트명  
	        	  $("#projectUPIntroduction").val(newIntroduction);		//프로젝트소개 
	        	  $("#projectUPId").val(data.projectId);
	        	  
	        	  if(data.imagPath != null){
	        		  $("#projectUPFile_01").show();
	        		  $("#projectUPFileUrl_01").attr('src', data.imagPath);	// 이미지경로
	        	  }
	          }
	          openModal('#layer-project');
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    });
	}
	
	//프로젝트 수정
	function fnProjectUpdate(){
		//데이터
		var projectName = $("#projectUPName").val();		//프로젝트명 
		var projectIntroduction = $("#projectUPIntroduction").val();		//프로젝트소개 
		//var portfolioId_main = $("#portfolioId_main").val();
		var projectId = $("#projectUPId").val();
		var projectFileUrl =  $("#projectUPFileUrl_01").attr('src');	// 이미지경로
		
   		var form = $("#project-file-form")[0];
   		var formData = new FormData(form);
   		//formData.append("userId", userId);
   		formData.append("portfolioId", portfolioId);
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
		        	//alert("수정 성공 했습니다.");
		        	closeModal('#layer-project');
		        	location.reload(); //페이지 리로딩
		        	//fnProjectList(portfolioId_main);
		        }	          
	       },error:function(){
	          //alert("수정 실패하였습니다.");
	       }
	    });
	}
	
	//포토폴리오 삭제
	function fnProjectContentsDel(userIds,projectContentsId){
		if(confirm('<spring:message code="portfolio.alert.msg8" text="컨텐츠를 삭제하시겠습니까?" />')) {
			$.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : {"userId" : userIds ,"projectContentsId" : projectContentsId},
		        url : '/studio/project/delProjectContents',
		        success : function(response) {
		        	if(response.code == "SUCCESS"){
		        		//alert("삭제 처리 했습니다.");
		        		//location.reload(); //페이지 리로딩
		        		fnProjectContentsList(projectId);
		        	}
		       },error:function(){
		          //alert("삭제에 실패하였습니다.");
		       }
		    });
	    } 	    
	}
	
	
	//프로젝트 리스트 화면 이동 
	function fnProjectView(portfolioIds){
		if(portfolioIds != undefined){
			location.href= "/studio/project/projectListForm?portfolioId="+ portfolioIds;	
		}else{
			location.href= "/studio/project/projectListForm?portfolioId="+ portfolioId;	
		}
			
	}
	
	//컨텐츠 이미지 화면 이동 
	function fnProjectImageView(){
		location.href= "/studio/project/projectContentsImageFrom?projectId="+projectId;		
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
				<h2 class="content-title" ><spring:message code="menu7-2" text="Portafolio"/></h2>
				<div class="content-fixed project-detail">
					<div class="content-header">
						<div class="inner">
							<h2 class="content-title d-down-md">Detalles de la portafolio</h2>
							<a href="#;" class="btn btn-list" onclick="fnProjectView(${portfolioId})"><spring:message code="button.list" text=""/></a>  
						</div>
					</div>
					<div class="content-body style2">
						<div class="portfolio-detail-info">
							<div class="info-area">
								<span class="name" id="mainName">Diseño De Aplicaciones Proyecto title</span>
								<div class="content">
									<p id="mainIntroduction" style="white-space: pre-line;">Aquí se muestran las presentaciones introducidas al registrar el proyecto. Aquí se muestran las presentaciones introducidas al registrar el proyecto. Aquí se muestran las presentaciones introducidas al registrar el proyecto.</p>
								</div>
								<div class="like">
									<em class="ico ico-like-on-lg"></em>
									<span class="number" id="mainLikeCount">123,000</span>
								</div>
								<a href="#;" class="btn btn-modify" onclick="fnProjectDetail()">modify</a>
							</div>
							<dl class="dropdown-select dropdown-select-content">  
								<dt><a href="#;" class="btn btn-md btn-secondary">Registro de contenido</a></dt>
								<dd style="bottom: -306px;">
									
									<div class="dropdown-inner" style="height: 306px;">
										<span class="dropdown-title"><spring:message code="portfolio.text24" text="Registro de contenido"/></span>
										<span class="dropdown-guide d-up-lg">Contenido a registrar<br>
											Por favor seleccione un tipo</span>
										<ul class="dropdown-list" id="contentForm">
																				
										</ul>
									</div>
								</dd>
							</dl>
						</div>

						<div class="project-form" >
							<div class="item" id="imageView" style="display:none">
								<h3 class="title1 mt-0"><spring:message code="portfolio.text25" text="Imagenes"/></h3>
								<ul class="thumbnail-list thumb-image" id="ContentView_image">
									
								</ul>
							</div>
							<div class="item" id="videosView" style="display:none">
								<h3 class="title1 mt-0"><spring:message code="portfolio.text27" text="Videos"/></h3>
								<ul class="thumbnail-list thumb-video" id="ContentView_video">
									
								</ul>
							</div>
							<div class="item" id="audioView" style="display:none">
								<h3 class="title1 mt-0"><spring:message code="portfolio.text31" text="Audio"/></h3>
								<ul class="thumbnail-list thumb-audio" id="ContentView_audio">
									
								</ul>
							</div>
							<div class="item" id="documentosView" style="display:none">
								<h3 class="title1 mt-0"><spring:message code="portfolio.text29" text="Documentos"/></h3>
								<ul class="document-list" id="ContentView_documentos">
									
								</ul>
							</div>
							<div class="item" id="badgeView" style="display:none">
								<h3 class="title1 mt-0"><spring:message code="mypage.skill3" text="Insignia"/></h3>
								<div class="portfolio-ctrl item-ctrl">
									<a href="#;" class="btn btn-modify" onclick="fnBadgeList();">Modificar</a>
								</div>
								<ul class="mybadge-list" id="ContentView_badge">
									
								</ul>
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
	<div class="modal-popup modal-md2 hide" id="layer-project">
		<div class="dimed"></div>
		
			<div class="popup-inner popup-project">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="portfolio.text19" text="Información del proyecto"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-project');">Close</button>
				</div>
				<div class="popup-body">
					<input type="hidden" id="projectUPId" value="">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="projectUPName"><spring:message code="portfolio.text20" text="Nombre del proyecto"/>*</label></dt>
								<dd>
									<input type="text" id="projectUPName" class="form-control">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><label for="projectUPIntroduction"><spring:message code="portfolio.text21" text="Introducción al proyecto"/></label></dt>
								<dd>
									<textarea id="projectUPIntroduction" rows="5"  class="form-control"></textarea>
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
										
										<div class="attatched-file" id="projectUPFile_01" style="display:none">
											<div>
												<div class="image-area">
													<img id="projectUPFileUrl_01" src="/static/assets/images/common/_img-sample.jpg" alt="">
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
						<button type="submit" class="btn btn-md btn-secondary" id="projectButton" onclick="fnProjectUpdate()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
		
	</div>
	
	<div class="modal-popup modal-md2 hide" id="layer-image">
		<div class="dimed"></div>
			<input type="hidden" id="typeImage" value="">
			<div class="popup-inner popup-image">
				<div class="popup-header">
					<h2 class="popup-title">Registro de imagen</h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-image');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="contentsNameImage">Nombre del contenido*</label></dt>
								<dd>
									<input type="text" id="contentsNameImage" class="form-control">
								</dd>
							</dl>
						</div>
						<form id="contentImg-file-form" method="POST" enctype="multipart/form-data" >
						<div class="form-item">
							<dl class="form-group form-file">
								<dt class="title2">Imagen*</dt>
								<dd>
									<div class="file-attatch-wrap project-image">
										<div class="file-attatch-item">
											<!-- label for와 id 매칭 필수 -->
											<input type="file" id="lb_file4" name="contentFile">
											<label for="lb_file4">
												<span class="d-up-lg">Registro de imagen</span>
												<span class="d-down-md">
													<em class="ico ico-upload"></em>
													imagen<br> Inscripción
												</span>
											</label>
										</div>

										<!-- 업로드 후 노출 -->
										
										<div class="attatched-file" id="contentFile_01" style="display:none">
											<div>
												<div class="image-area">
													<img id="contentFileUrl_01"src="" alt="">
												</div>
												<button type="button" class="btn btn-delete" onclick="fnImageRomove('04');">delete</button>
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
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-image');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="contentButtonImage" onclick="fnContentSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
		
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-video">
		<div class="dimed"></div>
		<input type="hidden" id="typeVideo" value="">
		
			<div class="popup-inner popup-video">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="portfolio.text27" text="Registro de video"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-video');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="contentsUrl"><spring:message code="portfolio.text26" text="Nombre del contenido"/>*</label></dt>
								<dd>
									<input type="text" id="contentsNameVideo" class="form-control">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">						
								<dt class="title2"><label for="contentsUrlVideo"><spring:message code="portfolio.text28" text="URL del vídeo"/>*</label> <span class="text-guide text-invalid">(<spring:message code="portfolio.alert.msg5" text=""/>)</span></dt>
								<dd>
									<input type="text" class="form-control" id="contentsUrlVideo">
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-video');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="contentButtonVideo" onclick="fnContentSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
		
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-audio">
		<div class="dimed"></div>
		<input type="hidden" id="typeAudio" value="">
		
			<div class="popup-inner popup-audio">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="portfolio.text31" text="Registro de audio"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-audio');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="contentsNameAudio"><spring:message code="portfolio.text26" text="Nombre del contenido"/>*</label></dt>
								<dd>
									<input type="text" id="contentsNameAudio" class="form-control">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">		
								<dt class="title2"><label for="contentsUrlAudio"><spring:message code="portfolio.text32" text="Code del audio"/>*</label> <span class="text-guide text-invalid">(<spring:message code="portfolio.alert.msg7" text=""/>)</span></dt>
								<dd>
									<input type="text" id="contentsUrlAudio" class="form-control">
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-audio');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="contentButtonAudio" onclick="fnContentSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
		
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-document">
		<div class="dimed"></div>
		<input type="hidden" id="typeDocument" value="">
		
			<div class="popup-inner popup-document">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="portfolio.text29" text="Registro de documentos"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-document');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="contentsNameDocument"><spring:message code="portfolio.text26" text="Nombre del contenido"/>*</label></dt>
								<dd>
									<input type="text" id="contentsNameDocument" class="form-control">
								</dd>
							</dl>
						</div>
						<form id="contentDocument-file-form" method="POST" enctype="multipart/form-data" >
						<div class="form-item">
							<dl class="form-group form-file">	
								<dt class="title2"><spring:message code="portfolio.text30" text=""/>* <span class="text-guide text-invalid">(<spring:message code="portfolio.alert.msg6" text=""/>)</span></dt>
								<dd>
									<div class="file-attatch-wrap project-document">
										<div class="file-attatch-item">
											<!-- label for와 id 매칭 필수 -->
											<input type="file" id="lb_file5" name="contentFile">
											<label for="lb_file5">
												<span>Registro de archivos</span>
											</label>
										</div>

										<!-- 업로드 후 노출 -->
										
										<div class="attatched-file" id="contentFile_02" style="display:none">
											<div>
												<div class="file-area">
													<span class="file-name" id="contentFileText_02"></span>
													<button type="button" class="btn btn-delete" onclick="fnImageRomove('05');">delete</button>
												</div>
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
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-document');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="contentButtonDocument" onclick="fnContentSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
		
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-badge">
		<div class="dimed"></div>
		<input type="hidden" id="typeBadge" value="">
		
			<div class="popup-inner popup-badge">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="mypage.skill3" text="Registro de Insignia"/></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-badge');">Close</button>
				</div>
				<div class="popup-body" id="badgeLayerView">
					
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-badge');"><spring:message code="button.cancel" text="cancelar"/></a>
						<button type="submit" class="btn btn-md btn-secondary" id="contentButtonBadge" onclick="fnContentSave()"><spring:message code="button.save" text="Ahorrar"/></button>
					</div>
				</div>
			</div>
		
	</div>

</body>

</html>