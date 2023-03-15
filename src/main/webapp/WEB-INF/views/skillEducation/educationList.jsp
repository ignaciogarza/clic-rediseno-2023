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
	
	<!-- JavaScript -->
	<script src="/static/assets/js/jquery-3.5.1.min.js"></script>
	
	<style>
	.title {
		display: -webkit-box !important;
		max-width: 300px;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
	}
	</style>
	
	<!-- 페이지 개별 스크립트 -->
	<script>	
	var page = 1; //페이징과 같은 방식이라고 생각하면 된다
	var skillCode = null;
	var examClassCode = null;
	let isFetching = false;
	
	$(document).ready(function() {
		check();
		skillList();

		//pc 스크롤 페이징
		$(window).scroll(function() { //스크롤이 최하단으로 내려가면 리스트를 조회하고 page를 증가시킨다.
			if($(window).scrollTop() + 1000 >= $(document).height() - $(window).height() && !isFetching) {
				getList(page, skillCode, examClassCode);
				page++;
			}
		});
	});
	
	//스킬 교육 check
	function check() {
		$.ajax({
			url: '/education/check',
			type: 'get',
			data:  {"page" : page , "skillCode" : skillCode, "examClassCode" : examClassCode},
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == 0) {
					$('#urlBox').hide();
					$('#eduList').hide();
					var html = '<p class="text"><spring:message code="education.text3" text="There Are No Registered Trainings." /></p>';
					$('.no-data').append(html);
				} else {
					$('.no-data').hide();
					$('#urlBox').show();
					getList(page, skillCode, examClassCode);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//스킬 이름 검색 list
	function skillList() {
		$.ajax({
			url: '/education/skillList',
			type: 'get',
			data:  {"page" : page , "skillCode" : skillCode, "examClassCode" : examClassCode},
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				var skill = '';
				$.each(resultList, function(index, item) {
					skill += '<li value="'+item.skillCode+'" data-exam="'+item.examClassCode+'" onclick="searchList(this);"><a href="javascript:;" onclick="textCodeValue(this);">'+item.skillName+'</a></li>';
					return true;
				});
				$('.skillList').after(skill);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//스킬 교육 조회
	function getList(page, skillCode, examClassCode) {
		var skillCode = $('input[name=skillCode]').val();
		var examClassCode = $('input[name=examClassCode]').val();
		isFetching = true; //조회 완료되면 false로 변경
		$.ajax({
			url: '/education/scrollList',
			type: 'get',
			data:  {"page" : page , "skillCode" : skillCode, "examClassCode" : examClassCode},
			dataType: 'json',
			success: function(response){
				var resultList = response.data;

				if(page == 1) {
					$('#eduList').empty();
				}

				var edu = '';
				var filter = 'win16|win32|win64|mac|macintel';
				$.each(resultList, function(index, item) {
					edu += '<li>';
					if(navigator.platform) {
						if(filter.indexOf(navigator.platform.toLowerCase()) < 0) {
							edu += '	<a href="'+item.educationMobileUrl+'" target="_blank">';
						} else {
							edu += '	<a href="'+item.educationPcUrl+'" target="_blank">';
						}
					}
					edu += '		<div class="thumb">';
					if(item.imagePath != '') {
						edu += '		<img src="'+item.imagePath+'" alt="">';
					}
					edu += '		</div>';
					edu += '		<div class="info-area">';
					edu += '			<span class="skill-name">';
					var skillName = item.skillMapping;
					$.each(skillName, function(index, item) {
						if(index == 0) {
							edu += item.skillName;
						} else {
							edu += ' / ' + item.skillName;
						}
						return true;
					});
					edu += '			</span>';
					edu += '			<span class="title">'+item.title+'</span>';
					edu += '			<span class="content">'+item.contents+'</span>';
					edu += '			<ul class="list">';
					edu += '				<li>';
					edu += '					<em class="ico ico-education1"></em>';
					edu += '					<span class="text">'+item.educationOrganization+'</span>';
					edu += '				</li>';
					edu += '				<li>';
					edu += '					<em class="ico ico-education2"></em>';
					edu += '					<span class="text">'+item.educationPeriod+'</span>';
					edu += '				</li>';
					edu += '				<li>';
					edu += '					<em class="ico ico-education3"></em>';
					edu += '					<span class="text">'+item.educationCoast+'</span>';
					edu += '				</li>';
					edu += '			</ul>';
					edu += '		</div>';
					edu += '	</a>';
					if(navigator.platform) {
						if(filter.indexOf(navigator.platform.toLowerCase()) < 0) {
							edu += '	<button type="button" class="btn btn-sm btn-outline-gray btn-copy" onclick="urlCopy(\''+item.educationMobileUrl+'\');">';
							edu += '		<em class="ico ico-copy"></em>';
							edu += '		URL';
							edu += '	</button>';
						} else {
							edu += '	<button type="button" class="btn btn-sm btn-outline-gray btn-copy" onclick="urlCopy(\''+item.educationPcUrl+'\');">';
							edu += '		<em class="ico ico-copy"></em>';
							edu += '		URL';
							edu += '	</button>';
						}
					}
					edu += '</li>';
					return true;
				});
				$('#eduList').append(edu);
				isFetching = false;
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
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
		} else {
			alert('error');
		} 
	}

	//스킬 제목
	function textCodeValue(value) {
		var code = $(value).text();
		$('a.btn.skillCode').text(code);
	}

	//스킬 코드 검색
	function searchList(value) {
		var code = String($(value).val());
		var strValue = "" + code;
		var num = "0000";
		var ans = num.substring(0, num.length - strValue.length) + strValue;
		var examCode = $(value).data('exam');
		
		$('input[name=skillCode]').val(ans);
		$('input[name=examClassCode]').val(examCode);

		page = 1; //1로 초기화
		getList(page, skillCode, examClassCode);
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
					<h2 class="content-title"><spring:message code="menu6" text="Aprende" /></h2>
				<div class="education-wrap">
					<input type="hidden" name="skillCode" value="">
					<input type="hidden" name="examClassCode" value="">
					<!-- 
						** 선택값 개수에 따라 리스트 {레이어 높이값} 변경 요망
						- 레이어 높이값 최대 450px (선택값 8개 이상일 경우 스크롤 처리됨)
						** {레이어 높이값} 참고
						- 선택값 2개일 경우 : 162px
						- 선택값 3개일 경우 : 210px
						- 선택값 4개일 경우 : 258px
						- 선택값 5개일 경우 : 306px
						- 선택값 6개일 경우 : 354px
						- 선택값 7개일 경우 : 402px
						- 선택값 8개일 경우 : 450px
						-->
						<dl class="dropdown-select">
							<dt><a href="javascript:;" class="btn skillCode"><spring:message code="education.text1" text="Seleccionar" /></a></dt>
							<dd style="bottom: -210px;"><!-- // bottom: -{레이어 높이값}px 변경 -->
								<div class="dimed"></div>
								<div class="dropdown-inner custom-scroll" style="height: auto; overflow: auto;"><!-- // height: {레이어 높이값}px 변경 -->
									<span class="dropdown-title"><spring:message code="education.text1" text="selectbox title" /></span>
									<ul class="dropdown-list" id="selectSkillCode">
										<li value="" data-exam="" onclick="searchList(this);" class="skillList"><a href="javascript:;" onclick="textCodeValue(this);"><spring:message code="education.text2" text="All" /></a></li>
									</ul>
								</div>
							</dd>
						</dl>
						<div class="no-data"></div>
						<input type="text" id="urlBox" value="" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
						<ul class="education-list" id="eduList"></ul>
				</div>
			</article>
		</div>
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->		
	</div>
	<!-- 공통 UI 컴포넌트 -->
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script>
</body>
</html>