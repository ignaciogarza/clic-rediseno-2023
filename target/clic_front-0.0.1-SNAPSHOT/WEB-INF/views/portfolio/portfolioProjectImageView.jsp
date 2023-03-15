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
	
	<script src="/static/common/js/init.js"></script>	
	<script src="/static/assets/js/slick.min.js"></script>
	<script>
		var projectId = getParameterByNames('projectId');
		var otherUserId = getParameterByNames('otherUserId');
		
		$(document).ready(function () {
			 getList(otherUserId, projectId);
		});
		
		function getList(otherUserId, projectId){
			 
		    $.ajax({
		        type : 'POST',  
		        dataType : 'json', 
		        data : {"otherUserId" : otherUserId, "projectId" : projectId },
		        url : '/studio/project/projectContentsImageList',
		        success : function(response) {
		          var resultList = response.data.contentsImageList;
		          
		          
		          $("#image-preview").empty();
		          var html = '';
		          if(resultList != null && resultList.length > 0){
					for (var i = 0; i < resultList.length; i++) {
						 html += '<div class="item">';
						 html += '<div class="image-area">';
						 html += '<img src="'+resultList[i].contentsPath+'" alt="">';
						 html += '</div>';
						 html += '<span class="title">'+resultList[i].contentsName+'</span>';
						 html += '</div>';						
					  }				   
				  }	
				  $("#image-preview").append(html);  
				  
				  $('#image-preview').not('.slick-initialized').slick({
						autoplay: false,
						speed: 0,
						slidesToShow: 1,
						slidesToScroll: 1,
						infinite: false,
						arrows: true,
						dots: true,
						accessibility: false,
						customPaging: function (slick, index) {
							$('.preview-info .count .total').text(slick.slideCount);
						}
					}).on('afterChange', function (event, index, slick, currentSlide) {
						$('.preview-info .count strong').text(slick + 1);
					}); 
				    
		       },error:function(){
		          alert("데이터를 가져오는데 실패하였습니다.");
		       }
		    }); 
		}
		
		function getParameterByNames(name) { 
			name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
			var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
			results = regex.exec(location.search); 
			return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
		}	
	</script>
</head>

<body>
	<div class="popup-preview">
		<div class="popup-inner">
			<div id="image-preview" class="preview-list" >			
				
			</div>
			<div class="preview-info">
				<div class="count">
					<span class="d-up-lg">(</span><strong>1</strong>/<span class="total">3</span><span class="d-up-lg">)</span>
				</div>
			</div>

			<a href="#;" class="btn btn-close d-down-md" onclick="window.history.back()">
				<em class="ico ico-close-white"></em>
				<span class="sr-only">close</span>
			</a>
		</div>
	</div>	
</body>
</html>