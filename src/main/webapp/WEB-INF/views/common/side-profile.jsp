<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script>
//비빌번호 체크  
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
				alert('<spring:message code="error.msg.6.title" text="비밀번호를 확인해주세요." />');	
				closeModal('#layer-profile');
			}
		}
	});
}
</script>
<div class="profile-area">
	<div class="profile-frame">
		<div class="photo">
			<img src="${sessionScope.userImagePath}" onerror="this.src='/static/assets/images/common/img-profile-default@2x.png'" alt="">
		</div>
		<div class="country">
			<img
				src="https://flagcdn.com/w640/<c:out value='${fn:toLowerCase(sessionScope.countryCode)}'/>.png"
				alt="${sessionScope.countryCode}"
				title="${sessionScope.countryCode}"
			>
		</div>
	</div>
	<div class="profile-info">
		<span class="name">${sessionScope.fullName}</span>
		<%-- <span class="career">
			<c:if test="${pageContext.response.locale.language eq 'es'}">
				${sessionScope.jobNameSpa}
			</c:if>
			<c:if test="${pageContext.response.locale.language ne 'es'}">
				${sessionScope.jobNameEng}
			</c:if>
		</span> --%>
	</div>	
	<a href="#" onClick="openModal('#layer-profile');" class="btn btn-profile-edit">Edit Profile</a>
</div>


<!-- 저장버튼 클릭시 비밀번호 확인 레이어팝업 -->
<div class="modal-popup modal-md hide" id="layer-profile">
	<div class="dimed"></div>
	<div class="popup-inner">
		<div class="popup-header">
			<h2 class="popup-title"><spring:message code="menu13" text="" /></h2>  
		</div>
		<div class="popup-body">
			<p class="text mt-md-3 text-md-center"><spring:message code="profile.message1" text=""/></p>
			<div class="form-item mt-lg-7 mt-md-6">
				<input type="password" class="form-control" title="password" id="passwordCk" >
				<button type="button" class="btn btn-view">View password</button>
			</div>
			<div class="btn-group-default btn-fixed mt-lg-8">
				<a href="#;" class="btn btn-md btn-gray" onclick="closeModal('#layer-profile');"><spring:message code="button.cancel" text="cancelar"/></a>
				<button type="button" class="btn btn-md btn-secondary" onClick="fnPwCheckForm()"><spring:message code="button.check" text="Confirmar"/></button>
			</div>
		</div>
	</div>
</div>