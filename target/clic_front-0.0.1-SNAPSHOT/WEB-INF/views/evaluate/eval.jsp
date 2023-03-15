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
			<%-- <c:forEach var="data" items="${skillList}">
				<%@ include file="skill-progress.jsp" %>
				<c:if test="${isView}">
					<%@ include file="skill-progress-side.jsp" %>
				</c:if>
			</c:forEach> --%>
		</aside>
		<article id="content">
			<h2 class="content-title"><spring:message code="menu3" text="평가" /></h2>
			<dl class="text-intro mt-lg-8 mt-md-5">
				<dt><spring:message code="evaluate.text1" text="Habilidades21" /></dt>
				<dd><spring:message code="evaluate.text2" text="Blah blah ~" /></dd>
			</dl>
			<ul class="skill-list">
				<%-- <c:forEach var="data" items="${skillList}">
					<%@ include file="skill-progress.jsp" %>
					<c:choose>
						<c:when test="${data.isUse == 'Y'}"> 노출 여부가 Y 인 경우
							<li data-skill="${data.skillCode}" data-clazz="${data.examClassCode}">
								<a href="javascript:;">
									<span class="name">${data.skillName}</span>
									<c:if test="${not empty badgeImage}">
										<span class="state"><img src="${badgeImage}" alt=""></span>
									</c:if>
								</a>
							</li>
						</c:when>
						<c:when test="${skillDisabled != '' && progress != 'PASS'}"> 노출 여부가 Y 인 경우
							<li>
								<a class="disabled">
									<span class="name">${data.skillName} ${step1Class}</span>
									<c:if test="${not empty badgeImage}">
										<span class="state"><img src="${badgeImage}" alt=""></span>
									</c:if>
									<span class="msg-disabled"><spring:message code="evaluate.alert.cant-continue" text="No puede continuar con la prueba." /></span>
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
$(function() {
	
	getSkillList();  //평가 스킬 list
	
});

//평가 스킬 list
function getSkillList() {
	$.ajax({
		url: '/eval/list/api',
		type: 'get',
		dataType: 'json',
		success: function(response) {
			var resultList = response.data;
			
			var side = '';
			$.each(resultList, function(index, item) {
				//skill-progress.jsp
				var isView = false;
				var progress = item.progressStatusCode;
			//	var skillDisabled = (item.isUse == 'N' && progress != 'NOT_TESTED') ? 'disabled' : '';
				var skillDisabled = (item.isUse == 'N') ? 'disabled' : '';
				var testEnabled = true;

				var step1Class = '';
				var step2Class = '';
				var step3Class = '';
				var step4Class = '';
				var badgeImage = '';

				if(progress == 'NOT_TESTED' || progress == 'SELF_EXAM_WAIT') {
					isView = true;
					step4Class = 'default';
					badgeImage = '/static/assets/images/content/img-step1-default.png';
				}
				if(progress == 'SELF_EXAM_TAKING') {
					isView = true;
					step1Class = 'ongoing';
					badgeImage = '/static/assets/images/content/img-step1-ongoing.png';
				}
				if(progress == 'SELF_EXAM_PASS' || progress == 'SKILL_EXAM_WAIT') {
					isView = true;
					step1Class = 'on';
					badgeImage = '/static/assets/images/content/img-step1-pass.png';
				}
				if(progress == 'SKILL_EXAM_TAKING') {
					isView = true;
					step1Class = 'on';
					step2Class = 'ongoing';
					badgeImage = '/static/assets/images/content/img-step2-ongoing.png';
				}
				if(progress == 'SKILL_EXAM_PASS' || progress == 'FRIEND_AUTH_WAIT') {
					isView = true;
					step1Class = 'on';
					step2Class = 'on';
					badgeImage = '/static/assets/images/content/img-step2-pass.png';
				}
				if(progress == 'FRIEND_AUTH_TAKING') {
					isView = true;
					step1Class = 'on';
					step2Class = 'on';
					step3Class = 'ongoing';
					badgeImage = '/static/assets/images/content/img-step3-ongoing.png';
				}
				if(progress == 'PASS') {
					isView = false;
					badgeImage = item.badgeObtainImagePath;
				}
				if(progress == 'SELF_EXAM_TIME_OUT' || progress == 'SELF_EXAM_FAILED' || progress == 'SKILL_EXAM_TIME_OUT' || progress == 'SKILL_EXAM_FAILED') {
					badgeImage = '/static/assets/images/content/img-skill-disabled.png';
					testEnabled = false;
				}
				if(item.isUse != 'Y' && (resultList == '' || resultList == null)) {
					isView = false;
				}
				if(item.checkSkillBadgeObtain) {
					isView = false;
					badgeImage = item.badgeObtainImagePath;
				}

				//skill-progress-side.jsp 와 skill-progress-side-list.jsp
				if(isView && item.isUse == 'Y') {
					side += '<div class="skill-progress '+skillDisabled+'">';
					side += '	<p class="title" style="text-align: center;padding: 10px 0 10px 0;">'+item.skillName+'</p>';
					side += '	<ol class="list">';
					side += '		<li class="step1 '+step1Class+'">';
					side += '			<span class="state '+step4Class+'"><spring:message code="evaluate.skill.step1" text="Auto reporte" /></span>';
					side += '		</li>';
					if(item.badgeObtainLevelCode == '1502' || item.badgeObtainLevelCode == '1503') {
						side += '	<li class="step2 '+step2Class+'">';
						side += '		<span class="state"><spring:message code="evaluate.skill.step2" text="Comportamiento" /></span>';
						side += '	</li>';
					}
					if(item.badgeObtainLevelCode == '1503' || item.badgeObtainLevelCode == '1504') {
						side += '	<li class="step3 '+step3Class+'">';
						side += '		<span class="state"><spring:message code="evaluate.skill.step3-1" text="Validación" /><br><spring:message code="evaluate.skill.step3-2" text="de pares" /></span>';
						side += '	</li>';
					}
					side += '	</ol>';
					if(skillDisabled == 'disabled') {
						side += '<span class="msg-disabled"><spring:message code="evaluate.alert.cant-continue-1" text="No puede continuar con la" /></span>';
					}
					side += '</div>';
					side += '<div class="division-line mt-4 mb-4"></div>';
				} 
			});
			$('div#layer-profile.modal-popup.modal-md.hide').after(side);

			var list = '';
			$.each(resultList, function(index, item) {
				//skill-progress.jsp
				var isView = false;
				var progress = item.progressStatusCode;
				var skillDisabled = (item.isUse == 'N' && progress != 'NOT_TESTED') ? 'disabled' : '';
				var testEnabled = true;

				var step1Class = '';
				var step2Class = '';
				var step3Class = '';
				var badgeImage = '';

				if(progress == 'SELF_EXAM_TAKING') {
					isView = true;
					step1Class = 'ongoing';
					badgeImage = '/static/assets/images/content/img-step1-ongoing.png';
				}
				if(progress == 'SELF_EXAM_PASS' || progress == 'SKILL_EXAM_WAIT') {
					isView = true;
					step1Class = 'on';
					badgeImage = '/static/assets/images/content/img-step1-pass.png';
				}
				if(progress == 'SKILL_EXAM_TAKING') {
					isView = true;
					step1Class = 'on';
					step2Class = 'ongoing';
					badgeImage = '/static/assets/images/content/img-step2-ongoing.png';
				}
				if(progress == 'SKILL_EXAM_PASS' || progress == 'FRIEND_AUTH_WAIT') {
					isView = true;
					step1Class = 'on';
					step2Class = 'on';
					badgeImage = '/static/assets/images/content/img-step2-pass.png';
				}
				if(progress == 'FRIEND_AUTH_TAKING') {
					isView = true;
					step1Class = 'on';
					step2Class = 'on';
					step3Class = 'ongoing';
					badgeImage = '/static/assets/images/content/img-step3-ongoing.png';
				}
				if(progress == 'PASS') {
					isView = false;
					badgeImage = item.badgeObtainImagePath;
				}
				if(progress == 'SELF_EXAM_TIME_OUT' || progress == 'SELF_EXAM_FAILED' || progress == 'SKILL_EXAM_TIME_OUT' || progress == 'SKILL_EXAM_FAILED') {
					badgeImage = '/static/assets/images/content/img-skill-disabled.png';
					testEnabled = false;
				}
				if(item.isUse != 'Y' && (resultList == '' || resultList == null)) {
					isView = false;
				}
				if(item.checkSkillBadgeObtain) {
					isView = false;
					badgeImage = item.badgeObtainImagePath;
				}

				//skill list 부분
				var emptyText = '';
				if(item.isUse == 'Y') {
					list += '<li data-skill="'+item.skillCode+'" data-clazz="'+item.examClassCode+'">';
					list += '	<a href="javascript:;">';
					list += '		<span class="name">'+item.skillName+'</span>';
					if(badgeImage != emptyText) {
						list += '	<span class="state"><img src="'+badgeImage+'" alt=""></span>';
					}
					list += '	</a>';
					list += '</li>';
				}
				if(skillDisabled != emptyText && progress != 'PASS') {
					list += '<li>';
					list += '	<a class="disabled">';
					list += '		<span class="name">'+item.skillName+' '+step1Class+'</span>';
					if(badgeImage != '' || badgeImage != null) {
						list += '	<span class="state"><img src="'+badgeImage+'" alt=""></span>';
					}
					list += '		<span class="msg-disabled"><spring:message code="evaluate.alert.cant-continue" text="No puede continuar con la prueba." /></span>';
					list += '	</a>';
					list += '</li>';
				}
			});
			$('ul.skill-list').append(list);

			$('.skill-list > li').on('click', function() {
				let skill = $(this).data('skill');
				let clazz = $(this).data('clazz');
				if(skill != undefined && clazz != undefined) {
					window.location.href = '/eval/skill?skill=' + skill + '&class=' + clazz;
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