<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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

<!-- 공통 UI 컴포넌트 -->
<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
<script src="/static/assets/js/ui-common.js"></script>
<script src="/static/common/js/evaluate.js"></script>
</head>
<body>
<div class="wrapper">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<div id="container">
		<aside id="sidebar">
			<%@ include file="../common/side-profile.jsp" %>
		</aside>
		<article id="content">
			<h2 class="content-title"><spring:message code="menu4-2" text="Insignia" /></h2>
			<dl class="text-intro mt-lg-8 mt-md-5">
				<dt><spring:message code="evaluate.text1" text="Habilidades21" /></dt>
				<dd><spring:message code="evaluate.text2" text="Blah blah ~" /></dd>
			</dl>
			<ul class="badge-area" style="overflow: hidden; height: auto;">
				<%-- <c:forEach var="data" items="${skillList}">
					<c:choose>
						<c:when test="${data.isUse == 'Y' || data.progressStatusCode == 'PASS'}"> <!-- 노출 여부가 Y 인 경우 -->
							<li data-skill="${data.skillCode}" data-clazz="${data.examClassCode}">
								<a href="javascript:;">
									<c:if test="${data.progressStatusCode == 'PASS'}">
										<img src="${data.badgeObtainImagePath}" alt="" style="width:100px">
									</c:if>
									<c:if test="${data.progressStatusCode != 'PASS'}">
										<img src="${data.badgeDefaultImagePath}" alt="" style="width:100px">
									</c:if>
									<span class="name">${data.skillName}</span>
								</a>
							</li>
						</c:when>
					</c:choose>
				</c:forEach> --%>
			</ul>
		</article>
	</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</div>
<script>
$(document).ready(function() {

	getSkillList();  //스킬 list
	
});

//스킬 list
function getSkillList() {
	$.ajax({
		url: '/cert/badgeList/api',
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var skillList = response.data;
			console.log(skillList);
			var html = '';
			$.each(skillList, function(index, item) {
				//노출 여부가 Y인 경우
				if(item.isUse == 'Y' || item.progressStatusCode == 'PASS') {
					html += '<li data-skill="'+item.skillCode+'" data-clazz="'+item.examClassCode+'">';
					html += '	<a href="javascript:;">';
					if(item.progressStatusCode == 'PASS') {
						html += '	<img src="'+item.badgeObtainImagePath+'" alt="" style="width:100px">';
					} else {
						html += '	<img src="'+item.badgeDefaultImagePath+'" alt="" style="width:100px">';
					}
					html += '		<span class="name">'+item.skillName+'</span>';
					html += '	</a>';
					html += '</li>';
				}
			});
			$('ul.badge-area').append(html);

			$('.badge-area > li').on('click', function() {
				let skill = $(this).data('skill');
				let clazz = $(this).data('clazz');
				if(skill != undefined && clazz != undefined) {
					window.location.href = '/cert/badge?skill=' + skill + '&class=' + clazz;
				}
			});
		},
		error : function(xhr, status) {
            console.log(xhr + " : " + status);
      }
	});
}
</script>
</body>
</html>