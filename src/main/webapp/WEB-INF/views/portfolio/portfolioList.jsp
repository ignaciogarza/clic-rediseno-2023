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
	<!-- 페이지 개별 스크립트 -->
	<script src="/static/assets/js/jquery.qrcode.min.js"></script>
	<script src="/static/common/js/init.js"></script>
	<style>
	.title {
		display: -webkit-box !important;
		max-width: 300px;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}
	</style>		
	<script>
	$(document).ready(function () {
	  //포토폴리오 리스트 호출
	  getList();
	  
	  //필수값 체크 및 저장버튼 활성화 
	  $('#portfolioName').on('input',processkey);
	  $('#introduction').on('input',processkey);
	  $('#tag').on('input',processkey);
	  $('#lb_file1').on('input',processkey);	  
	  
	  
		
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
     //========================프로필 이미지 미리보기=================================
    	 
    	 
     
       
	});
	
	//========================sns 공유하기 =================================
	//sns 공유하기 
	function snsSubmit(type, otherUserId, otherEmail, portfolioId){
		//	http://localhost:8080/project/portfolioOthersMemberView?otherUserId=6571c845d7194ef38a4318ab5be71a07&otherEmail=jmh10243@naver.com&portfolioId=2&type=out;
		var link= server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+ otherUserId+"&otherEmail="+otherEmail+"&portfolioId="+portfolioId+"&type=out";		
		
		if(type == "twitter"){
			var title = "twitterSharer";
			SNS.twitter(link, title);
		}else if(type == "facebook"){
			var title = "facebookSharer";
			SNS.facebook(link, title);
		}else if(type == "linkedin"){
			var title = "linkedinSharer";
			SNS.linkedin(link, title);
		}
	}
	
	var SNS = {
		 		facebook: function (link, title){
		 			link = encodeURIComponent(link);
		 			title = encodeURIComponent(title);
		 			var url = "https://www.facebook.com/sharer/sharer.php?u="+link+ "&text=" + title;
		 			window.open(url);
		 		},
		 		twitter: function (link, title){
		 			link = encodeURIComponent(link);
		 			title = encodeURIComponent(title);    		 			
		 			var url = "https://twitter.com/intent/tweet?url=" + link + "&text=" + title;
		 			window.open(url);
		 			
		 		},
		 		linkedin: function(link, title){
		 			link = encodeURIComponent(link);
		 			title = encodeURIComponent(title);    		 			
		 			var url = "https://www.linkedin.com/shareArticle?mini=true&url=" + link + "&title=" + title;
		 			window.open(url);
		 		}
	 
			};
	//========================sns 공유하기 =================================
		
		
	function processkey(){ 	        
	     var portfolioName = $("#portfolioName").val();		//포토폴리오명 
	     var introduction = $("#introduction").val();			//포토폴리오 소개
	     var tag = $("#tag").val();					//태그명
	     var fileUrl_01 = $('#fileUrl_01').attr("src");
	     var lb_file1 = $("#lb_file1").val();
	   	  
	   	
	   	 if(portfolioName == "" || tag == "" || (fileUrl_01 == "" && lb_file1 == "") ){	 
	   		$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
	     }else {
	    	$('#saveButton').attr('disabled', false);			//버튼 해제 
	     }
	   }	
		
	var userId_01;	
	var email_01;
		
	var portfolioId_01;
	var portfolioId_02;
	var portfolioId_03;
	//포토폴리오  
	function getList(){
		 
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        url : '/studio/portfolio/portfolioList',
	        success : function(response) {
	          var resultList = response.data;
	          
	          var html = '';
	          if(resultList != null && resultList.length > 0){
				for (var i = 0; i < resultList.length; i++) {
					
					 //var qrUrl =  "http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId="+resultList[i].userId+"&otherEmail="+resultList[i].email+"&portfolioId="+resultList[i].portfolioId+"&type=others"
					 var qrUrl =  server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+resultList[i].userId+"&otherEmail="+resultList[i].email+"&portfolioId="+resultList[i].portfolioId+"&type=others"
				 	 html += '<div class="col-item">';
					 html += '	<div class="portfolio-item">';
					 html += '		<p class="portfolio-title">'+resultList[i].name+'</p>';
					 html += '		<div class="box box-shadow box-round box-portfolio">';
					 html += '			<div class="thumb" onclick="fnProjectView(\''+resultList[i].portfolioId+'\');">';
					 html += '				<img src="'+resultList[i].listImagePath+'" alt="">';
					 html += '			</div>';
					 html += '			<div class="portfolio-info">';
					 html += '				<span class="public-setting">Public</span>';
					 html += '				<div class="total">';
					 html += '					<span class="number">'+resultList[i].projectCount+'</span>';
					 html += '					<span class="title"><spring:message code="mypage.text11" text="" /></span>';   
					 html += '				</div>';
					 html += '				<div class="like">';
					 html += '					<em class="ico ico-like-on"></em>';
					 html += '					<span class="number">'+resultList[i].likeCount+'</span>';
					 html += '				</div>';
					 if(resultList[i].isUseQr == 'Y'){
						 //html += '	<button type="button" class="btn btn-sm btn-outline-gray btn-copy" onclick="urlCopy(\''+qrUrl+'\');" style="min-width: 50px;height: 32px;padding: 13px 10px; font-size: 12px;">';
						 //html += '		<i class="ico ico-copy"></i>URL';
						 //html += '	</button>';
						 
						 html += '				<div id="qr-portfolio_'+(i+1)+'" class="qrcode"></div>';
						 if(resultList.length == 1){		
							 userId_01 = resultList[0].userId;
							 email_01 = resultList[0].email;
							 portfolioId_01 = resultList[0].portfolioId;
						 }
						 if(resultList.length == 2){	
							 userId_01 = resultList[0].userId;
							 email_01 = resultList[0].email;
							 portfolioId_01 = resultList[0].portfolioId;
							 portfolioId_02 = resultList[1].portfolioId;
						 }
						 if(resultList.length == 3){	
							 userId_01 = resultList[0].userId;
							 email_01 = resultList[0].email;
							 portfolioId_01 = resultList[0].portfolioId;
							 portfolioId_02 = resultList[1].portfolioId;
							 portfolioId_03 = resultList[2].portfolioId;
						 }
					 }
					 html += '			</div>';
					 html += '			<dl class="portfolio-ctrl">';
					 html += '				<dt><a href="#;" class="btn btn-edit">edit</a></dt>';
					 html += '				<dd>';
					 html += '					<ul class="btn-list">';
					 html += '						<li><a href="#;" class="btn btn-modify" onclick="fnPortfolioDetail(\''+resultList[i].userId+'\',\''+resultList[i].portfolioId+'\');">Modificar</a></li>'; 
					 html += '						<li><button type="button" class="btn btn-delete" onclick="fnPortfolioDel(\''+resultList[i].userId+'\',\''+resultList[i].portfolioId+'\');">Eliminar</button></li>';
					 html += '					</ul>';
					 html += '				</dd>';
					 html += '			</dl>';
					 html += '		</div>';
					 html += '	</div>';
					 html += '		<ul class="sns-list">';  
					 html += '			<li class="sns-facebook"><a href="#;" onclick="snsSubmit(\'facebook\',\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\')"><span>facebook</span></a></li>';
					 html += '			<li class="sns-linkedin"><a href="#;" onclick="snsSubmit(\'linkedin\',\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\')"><span>linkedin</span></a></li>';
					 html += '			<li class="sns-twitter"><a href="#;" onclick="snsSubmit(\'twitter\',\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\')"><span>twitter</span></a></li>';
					 html += '		</ul>';
					 //html += '		<button type="button" class="btn btn-sm btn-outline-gray btn-copy" onclick="urlCopy(\''+qrUrl+'\');" style="min-width: 50px;height: 32px;padding: 13px 10px; font-size: 12px;">';
					 html += '		<button type="button" class="btn btn-sm btn-outline-gray btn-copy" onclick="urlCopy(\''+qrUrl+'\');" >';
					 html += '			<em class="ico ico-copy"></em>URL';
					 html += '		</button>';
					 html += '</div>';	
				  }				   
			  }
			 
	          var noListLength = 3-resultList.length;
			  for (var j = 0; j < noListLength; j++) {
				     html += '<div class="col-item mt-md-7">';
					 html += '	<a href="#;" class="portfolio-item disabled" onclick="fnPortfolioDetail(\'\',\'\');">';
                     html += '    <p class="portfolio-title"><spring:message code="main.portfolio.text2" text="" /> '+(j+1)+'</p>';
					 html += '		<div class="box box-shadow box-round box-portfolio">';
					 html += '			<div class="thumb  ">';
					 html += '				<em class="ico ico-upload"></em>';
					 html += '				<span class="text"><spring:message code="mypage.text12" text="" /></span>';  
					 html += '			</div>';
					 html += '			<div class="portfolio-info">';
					 html += '				<div class="total">';
					 html += '					<span class="number">0</span>';
					 html += '					<span class="title"><spring:message code="mypage.text11" text="" /></span>';
					 html += '				</div>';
					 html += '				<div class="qrcode">';
					 html += '					<img src="/static/assets/images/content/img-qrcode-disabled.png" alt="">';
					 html += '				</div>';
					 html += '			</div>';
					 html += '		</div>';
					 html += '	</a>';
					 html += '</div>'; 
					 
			  }
			  $("#portfolioView").append(html);  
			  
			  //var userId_01;	
			  //var email_01;
					
			  //var portfolioId_01;
			  //var portfolioId_02;
			  //var portfolioId_03;
			  
			  //qr 코드 
			  $('#qr-portfolio_1').qrcode({
			 		width: 48,
					height: 48,					
					//text: "http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_01+"&type=others"
					text: server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_01+"&type=others"
			  });	
			  $('#qr-portfolio_2').qrcode({
					width: 48,
					height: 48,
					//text: "http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_02+"&type=others"
					text: server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_02+"&type=others"
			  });
			  $('#qr-portfolio_3').qrcode({
					width: 48,
					height: 48,
					//text: "http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_02+"&type=others"
					text: server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_03+"&type=others"
			  });
			    
	       },error:function(){
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//url 복사
	function urlCopy(url) {
		console.log(url);
		$('#urlBox').val(url);
		$('#urlBox').select();
		var successful = document.execCommand('copy');

		if(successful) {
			alert('<spring:message code="education.alert.url" text="url이 복사 되었습니다." />');
			//alert("url이 복사 되었습니다");
		} else {
			alert('error');
		} 
	}
	
	var concatWordsList;
	
	//포토폴리오 상세 보기 
	function fnPortfolioDetail(userIds, portfolioId){
		
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
	        data : {"userId" : userIds ,"portfolioId" : portfolioId },
	        url : '/studio/portfolio/portfolioDetail',
	        success : function(response) {
	          var data = response.data.portfolioInfo;	 
	          
	          concatWordsList = response.data.concatWordsList;
	          
	          var publicList = response.data.publicList
	          var html = '';
	          $("#publicForm").empty();	  
	          if(publicList != null && publicList.length > 0){	
		          for (var i = 0; i < publicList.length; i++) {	
		        	  //html += '<li class="on" id="public_'+publicList[i].minor+'" value="'+publicList[i].major+publicList[i].minor+'"><a href="#;" onclick="textPublicValue(this,\''+publicList[i].minor+'\');">'+publicList[i].name+'</a></li>';
		        	  html += '<li id="public_'+publicList[i].minor+'" value="'+publicList[i].major+publicList[i].minor+'"><a href="#;" onclick="textPublicValue(this,\''+publicList[i].minor+'\');">'+publicList[i].name+'</a></li>';
				  }
	          }
	          $("#publicForm").append(html);
	          
	          if(data != null){
	        	  $("#portfolioId").val(data.portfolioId);
	        	  
	        	  var reName = data.name;	        	  
	        	  var newName = reName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
	        	  $("#portfolioName").val(newName);					//포토폴리오명 
	        	  
	        	  var reIntroduction = data.introduction;
	        	  var newIntroduction = reIntroduction.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
	        	  $("#introduction").val(newIntroduction);			//포토폴리오 소개
	        	  
	        	  $("#tag").val(data.tag);							//태그명
	        	  
	        	  var selectPublicType;
	        	  if(data.publicTypeCode == "1801"){	        		 
	        		  selectPublicType= $("#public_01 a").text();
	        		  //$("#public_01").addClass("on");
	        	  }else if(data.publicTypeCode == "1802"){
	        		  selectPublicType= $("#public_02 a").text();
	        		  //$("#public_02").addClass("on");
	        	  }else if(data.publicTypeCode == "1803"){
	        		  selectPublicType= $("#public_03 a").text();
	        		  //$("#public_03").addClass("on");
	        	  }else if(data.publicTypeCode == "1804"){
	        		  selectPublicType= $("#public_04 a").text();
	        		  //$("#public_04").addClass("on");
	        	  }	        	  
	        	  $("#selectPublicType").text(selectPublicType);
	        	  
	        	  $("#publicTypeCode").val(data.publicTypeCode);	
	        	  
	        	  
	        	  if(data.listImagePath != null){
	        		  $("#file_01").show();
	        		  $("#fileUrl_01").attr('src', data.listImagePath);	// 리스트 이미지경로
	        		  //$("#fileUrl_01").attr('src', "/static/fileUpload/"+data.listImagePath);	// 리스트 이미지경로	        		  
	        	  }
	        	  
	        	  if(data.backgroundImagePath != null){
	        		  $("#file_02").show();
	        		  $("#fileUrl_02").attr('src', data.backgroundImagePath);	// 배경화면 이미지 경로
	        		  //$("#fileUrl_02").attr('src', "/static/fileUpload/"+data.listImagePath);	// 리스트 이미지경로
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
	        	  	        	  
	          }else{
	        	  $('#selectPublicType').text($("#public_01 a").text());
	        	  $('#saveButton').attr('disabled', true); 			//버튼 disabled 처리 
	        	  $("#saveButton").attr("onClick", "fnPortfolioSave()");	 //저장 function 변경 
	          }
	          openModal('#layer-portfolio');
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
		        	closeModal('#layer-portfolio');
		        	location.reload(); //페이지 리로딩
		        }	          
	       },error:function(){
	          //alert("수정에 실패하였습니다.");
	       }
	    });
	}
	
	//포토폴리오 삭제
	function fnPortfolioDel(userIds,portfolioId){
		if(confirm('<spring:message code="portfolio.alert.msg1" text="포트폴리오를 삭제 하시겠습니까? 등록된 프로젝트 및 컨텐츠가 모두 삭제됩니다." />')) {
			$.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : {"userId" : userIds ,"portfolioId" : portfolioId },
		        url : '/studio/portfolio/delPortfolio',
		        success : function(response) {
		        	if(response.code == "SUCCESS"){
		        		location.reload(); //페이지 리로딩
		        	}
		       },error:function(){
		          //alert("삭제에 실패하였습니다.");
		       }
		    });
	    } 	    
	}
	
	//이미지 숨김 처리 
	function fnImageRomove(type){ $('#projectFile_01').show();
		if(type == "01"){
			$("#lb_file1").val("");
			$("#file_01").hide();
			$('#saveButton').attr('disabled', true); 			//번튼 딤 처리 
		}else{
			$("#lb_file2").val("");
			$("#file_02").hide();
		}
	}
	
	//프로필 수정 페이지 이동 
	function fnUserProfileMove(){
		//location.href= "/user/userProfileForm?email="+ email;	
		location.href= "/user/userProfileForm";	
	}
	
	//포토폴리오 프로젝트 화면 이동 
	function fnProjectView(portfolioId){
		location.href= "/studio/project/projectListForm?portfolioId="+ portfolioId;		
	}
	
	
	
	//공개여부 제목 value
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
			</aside>
			<article id="content">
				<h2 class="content-title"><spring:message code="menu7-2" text="Portafolio"/></h2>
				<div class="portfolio-wrap">
					<input type="text" id="urlBox" value="" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
					<div class="content-row" id="portfolioView">
						
					</div>
				</div>
			</article>
		</div>
		
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->		
	</div>

	<!-- 포토폴리오 등록 레이어팝업 -->
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
								<dt class="title2"><spring:message code="portfolio.text6" text="Imagen de la lista de portafolio"/>*<span class="text-guide">(<spring:message code="portfolio.text8" text="Tamaño recomendado"/>480X600)</span></dt>
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
													<img id="fileUrl_01" src="" alt="">
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
								<dt class="title2"><spring:message code="portfolio.text7" text="Imágenes de portfolio wallpapers"/><span class="text-guide">(<spring:message code="portfolio.text8" text="Tamaño recomendado"/> 940X300)</span></dt>
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
										<dt><a href="#;" id="selectPublicType" class="btn">전체공개</a></dt>
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
								<dt class="title2"><spring:message code="portfolio.text13" text="Ya sea para usar el código QR"/>*</dt>
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
</body>
</html>