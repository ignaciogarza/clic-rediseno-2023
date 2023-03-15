<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
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
	span.title {
		display: -webkit-box !important;
		max-width: 300px;
		-webkit-line-clamp: 2;
		-webkit-box-orient: vertical;
		overflow: hidden;
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
			</aside>
			<article id="content">
				<h2 class="content-title"><spring:message code="menu1" text="Mi página" /></h2>
				<!-- 마크업 수정 (07.07) -->
				<div class="intro-wrap mt-lg-8 mt-md-5">
					<div class="clearfix">
						<div class="float-left">
							<h3 class="title1 mt-0 mb-md-2"><spring:message code="menu3" text="Evalúate" /></h3>
						</div>
						<div class="float-right">
							<a href="/eval/list" class="btn-more"><spring:message code="community.text18" text="more"/></a>
						</div>
					</div>
					<p class="text-info"><spring:message code="mypage.text1" text="Las certificaciones Clic son pruebas~" /></p>
					<div class="box box-shadow box-round box-evaluate">
						<div class="evaluate-stat">
							<div class="item">
								<p class="title"><spring:message code="mypage.skill1" text="Self-reported" /></p>
								<div class="number self"><!-- // 활동내역 없을 경우 클래스 .no-data 추가 -->
									<em class="ico ico-evaluate1"></em>
								</div>
							</div>
							<div class="item">
								<p class="title"><spring:message code="mypage.skill4" text="Behavioral" /></p>
								<div class="number exam">
									<em class="ico ico-evaluate2"></em>
								</div>
							</div>
							<div class="item">
								<p class="title"><spring:message code="mypage.skill2" text="Peer endorsement" /></p>
								<div class="number friend">
									<em class="ico ico-evaluate3"></em>
								</div>
							</div>
							<div class="item">
								<p class="title"><spring:message code="mypage.skill3" text="Badges" /></p>
								<div class="number badge">
									<em class="ico ico-evaluate4"></em>
								</div>
							</div>
						</div>
						<div class="evaluate-badge">
							<div id="badge-state" class="badge-list">
							</div>
						</div>
					</div>
					
					<div class="mt-12">
						<div class="clearfix">
							<div class="float-left">
								<h3 class="title1 mt-0 mb-md-2"><spring:message code="menu5" text="Conéctate" /></h3>
							</div>
							<div class="float-right">
								<a href="/community/communityMainView" class="btn-more"><spring:message code="community.text18" text="more"/></a>
							</div>
						</div>
						<p class="text-info"><spring:message code="mypage.text2" text="Podrás conectar con tu~" /></p>
						<input type="hidden" id="userId" value="">
						<div id="communityBox" class="box box-shadow box-round box-community">
						</div>
					</div>
					<!-- Disable education / educación -->
					<!-- <div class="mt-12">
						<div class="clearfix">
							<div class="float-left">
								<h3 class="title1 mt-0 mb-md-2"><spring:message code="menu6" text="Aprende" /></h3>
							</div>
							<div class="float-right">
								<a href="/education/list" class="btn-more"><spring:message code="community.text18" text="more"/></a>
							</div>
						</div>
						<p class="text-info edu"><spring:message code="mypage.text3" text="Learn 21st century skills~" /></p> -->
						<!-- 등록된 교육이 있을 경우 -->
						<!-- <input type="text" id="urlBox" value="" style="position: absolute; top: 0; left: 0; width: 1px; height: 1px; margin: 0; padding: 0; border: 0;">
						<ul class="education-list" id="eduList"></ul> -->
						<!-- // 등록된 교육이 있을 경우 -->
					<!-- </div> -->

					<div class="mt-12">
						<div class="clearfix">
							<div class="float-left">
								<h3 class="title1 mt-0 mb-md-2"><spring:message code="mypage.text10" text="Portafolio" /></h3>
							</div>
							<div class="float-right">
								<a href="/studio/portfolio/portfolioFrom" class="btn-more"><spring:message code="community.text18" text="more"/></a>
							</div>
						</div>
						<p class="text-info"><spring:message code="mypage.text4" text="Create your portfolio to~" /></p>
						<div class="portfolio-wrap">
							<div id="portfolioList" class="content-row"></div>
						</div>
					</div>
				</div>
				<!-- // 마크업 수정 (07.07) -->
			</article>
		</div>
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->		
	</div>
	
	
	<!-- 레이어팝업(스킬 인증 요철 팝업) -->
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
						<textarea cols="30" rows="3" class="form-control full" id="authContents"><spring:message code="community.message10" text="당신이 보유한 스킬을 인증합니다." /></textarea>
					</div>
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray d-up-lg" onclick="closeModal('#layer-certificate');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button type="button" class="btn btn-md btn-primary" onclick="fuCompleteSkillDel()"><spring:message code="button.reject" text="Negación" /></button>
						<button type="button" class="btn btn-md btn-secondary" onclick="fuCompleteSkillAuth()"><spring:message code="community.text11" text="Certificación" /></button>
					</div>
			</div>
		</div>
	</div>
	
	<!-- 공통 UI 컴포넌트 -->
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script>
	<script src="/static/common/js/init.js"></script>
	
	<!-- 페이지 개별 스크립트 -->
	<script src="/static/assets/js/slick.min.js"></script>
	<script src="/static/assets/js/jquery.qrcode.min.js"></script>
	<script src="/static/assets/js/jquery.DonutWidget.js"></script>
	
	<!-- 페이지 개별 스크립트 -->
	<script>
	$(document).ready(function () {
		//뱃지 부분 그래프
		DonutWidget.draw();

		//뱃지 list
		getBadgeList();

		//커뮤니티 조회
		getCommunityList();

		//교육 조회
		getEducationList();

		//포트폴리오 조회
		getPortfolioList();
	});
	
	function getBadgeList() {
		$.ajax({
			url: '/mypage/badgeList',
			type: 'get',
			dataType: 'json',
			success: function(response) {
				var result = response.data;
				var badgeList = result.skillList;

				if(result.selfCount == 0) {
					$('div.number.self').addClass('no-data');
					var selfCountHtml = '<span class="text">'+result.selfCount+'</span>';
					$('.ico-evaluate1').after(selfCountHtml);
				} else {
					$('div.number.self').removeClass('no-data');
					var selfCountHtml = '<span class="text">'+result.selfCount+'</span>';
					$('.ico-evaluate1').after(selfCountHtml);
				}

				if(result.examCount == 0) {
					$('div.number.exam').addClass('no-data');
					var examCountHtml = '<span class="text">'+result.examCount+'</span>';
					$('.ico-evaluate2').after(examCountHtml);
				} else {
					$('div.number.exam').removeClass('no-data');
					var examCountHtml = '<span class="text">'+result.examCount+'</span>';
					$('.ico-evaluate2').after(examCountHtml);
				}

				if(result.friendCount == 0) {
					$('div.number.friend').addClass('no-data');
					var friendCountHtml = '<span class="text">'+result.friendCount+'</span>';
					$('.ico-evaluate3').after(friendCountHtml);
					
				} else {
					$('div.number.friend').removeClass('no-data');
					var friendCountHtml = '<span class="text">'+result.friendCount+'</span>';
					$('.ico-evaluate3').after(friendCountHtml);
				}

				if(result.badgeGetCount == 0) {
					$('div.number.badge').addClass('no-data');
					var badgeGetCountHtml = '<span class="text">'+result.badgeGetCount+'</span>';
					$('.ico-evaluate4').after(badgeGetCountHtml);
				} else {
					$('div.number.badge').removeClass('no-data');
					var badgeGetCountHtml = '<span class="text">'+result.badgeGetCount+'</span>';
					$('.ico-evaluate4').after(badgeGetCountHtml);
				}

				var html = '';
				$('#badge-state').empty(html);
				$.each(badgeList, function(index, item) {
					if(item.progressStatusCode == 'PASS') {
						html += '<div class="item">';
						html += '	<img src="'+item.badgeObtainImagePath+'" alt="" />';
						html += '</div>';
					} else {
						html += '<div class="item">';
						html += '	<img src="'+item.badgeDefaultImagePath+'" alt="" />';
						if(item.progressStatusCode != 'NOT_TESTED' && item.progressStatusCode != 'SELF_EXAM_WAIT') {
							html += '	<span class="stat">';
							html += '		<em class="ico ico-ongoing"></em>';
							html += '	</span>';
						} 
						html += '</div>'; 
					}
				});
				$('#badge-state').append(html);
				//뱃지 부분 slick slider
				$('#badge-state').not('.slick-initialized').slick({
					autoplay: false,
					speed: 500,
					centerMode: false,
					slidesToShow: 7,
					slidesToScroll: 7,
					infinite: false,
					arrows: true,
					dots: true,
					accessibility: false,
					responsive: [{
						breakpoint: 1025,
						settings: {
							slidesToShow: 5,
							slidesToScroll: 5,
						}
					}],
				});
			} 
		});
	}

	function getCommunityList() {
		$.ajax({
			url: '/mypage/communityList',
			type: 'get',
			dataType: 'json',
			success: function(response) {
				var result = response.data;
				var communityList = result.communityList;
				var friendCheckList = result.friendCheckList;
				var userId = result.userId;
				$('#userId').val(userId);

				var html = '';
				$('#communityBox').empty(html);
				if(communityList == null || communityList == '') {
					html += '<div class="no-data">';
					html += '	<em class="ico ico-community"></em>';
					html += '	<p class="text"><spring:message code="mypage.text8" text="No hay noticias registradas" /><br><spring:message code="mypage.text9" text="Encontrar nuevos amigos" /></p>';
					html += '	<a href="/community/communityRecommendFriendView" class="btn btn-md btn-secondary"><spring:message code="friend.text8" text="Encuentra un amigo" /></a>';
					html += '</div>';
				} else {
					html += '<div class="community-list">';
					$.each(communityList, function(index, item) {
						//스킬 인증
						if(item.friendId == result.userId && item.useIf != '1101') {
							html += '<input type="hidden" name="myFriendId" value="'+item.userId+'">';
							html += '<div class="item">';
							html += '	<div class="profile-area">';
							html += '		<div class="profile-frame">';
							html += '			<div class="photo">';
							html += '				<img src="'+item.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
							html += '			</div>';
							html += '			<div class="country">';
							html += '				<img src="https://flagcdn.com/w640/'+item.countryCode.toLowerCase()+'.png" alt="">';
							html += '			</div>';
							$.each(friendCheckList, function(index, data) {
								if(data.friendId == item.userId) {
									html += '	<div class="stat">';
									html += '		<em class="ico ico-connect"></em>';
									html += '	</div>';
								}
								return true;
							});
							html += '		</div>';
							html += '		<div class="profile-info">';
							html += '			<span class="name">'+item.name+' '+item.firstName+'</span>';
						//	html += '			<span class="career">'+item.jobName+'</span>';
							html += '		</div>';
							html += '	</div>';
							html += '	<div class="content">';
							html += '		<p class="name">'+item.skillName+'</p>';
							html += '		<p class="text"><spring:message code="mypage.text7" text="Received a verification request" /></p>';
							html += '	</div>';
							html += '	<div class="community-ctrl">';
							html += '		<a href="javascript:;" class="btn btn-sm btn-blue" onclick="fnCertificateMove(\''+item.friendId+'\',\''+item.userId+'\',\''+item.skillCode+'\' ,\''+item.examClassCode+'\')"><spring:message code="button.verify" text="Verify" /></a>';
							html += '	</div>';
							html += '</div>';
						//친구 요청
						} else if(item.friendId == result.userId && item.useIf == '1101') {
							html += '<div class="item">';
							html += '	<div class="profile-area">';
							html += '		<div class="profile-frame">';
							html += '			<div class="photo">';
							html += '				<img src="'+item.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
							html += '			</div>';
							html += '			<div class="country">';
							html += '				<img src="https://flagcdn.com/w640/'+item.countryCode.toLowerCase()+'.png" alt="">';
							html += '			</div>';
							html += '		</div>';
							html += '		<div class="profile-info">';
							html += '			<span class="name">'+item.name+' '+item.firstName+'</span>';
						//	html += '			<span class="career">'+item.jobName+'</span>';
							html += '		</div>';
							html += '	</div>';
							html += '	<div class="content">';
							html += '		<p class="text"><spring:message code="mypage.text6" text="Received a friend request" /></p>';
							html += '	</div>';
							html += '	<div class="community-ctrl '+item.userId+'">';
							html += '		<button type="button" class="btn btn-sm btn-secondary btn-accept" onclick="fuApprovalFriend(\''+item.userId+'\')">';
							html += '			<em class="ico ico-check-white"></em>';
							html += '			<spring:message code="button.accept" text="Accept" />';
							html += '		</button>';
							html += '		<button type="button" class="btn btn-sm btn-primary btn-reject" onclick="fuRejectFriend(\''+item.userId+'\')">';
							html += '			<em class="ico ico-cancle-white"></em>';
							html += '			<spring:message code="button.reject" text="Reject" />';
							html += '		</button>';
							html += '	</div>';
							html += '</div>';
						//스킬 인증 완료
						} else if(item.userId == result.userId) {
							html += '<div class="item">';
							html += '	<div class="profile-area">';
							html += '		<div class="profile-frame">';
							html += '			<div class="photo">';
							html += '				<img src="'+item.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
							html += '			</div>';
							html += '			<div class="country">';
							html += '				<img src="https://flagcdn.com/w640/'+item.countryCode.toLowerCase()+'.png" alt="">';
							html += '			</div>';
							$.each(friendCheckList, function(index, data) {
								if(data.friendId == item.friendId) {
									html += '	<div class="stat">';
									html += '		<em class="ico ico-connect"></em>';
									html += '	</div>';
								}
								return true;
							});
							html += '		</div>';
							html += '		<div class="profile-info">';
							html += '			<span class="name">'+item.name+' '+item.firstName+'</span>';
						//	html += '			<span class="career">'+item.jobName+'</span>';
							html += '		</div>';
							html += '	</div>';
							html += '	<div class="content">';
							html += '		<p class="name">'+item.skillName+'</p>';
							html += '		<p class="text"><spring:message code="mypage.text5" text="Request the validation" /></p>';
							html += '	</div>';
							html += '	<div class="community-ctrl">';
							html += '		<a href="/community/communitySkillAllView" class="btn btn-sm btn-blue"><spring:message code="button.check" text="Confirmar" /></a>';
							html += '	</div>';
							html += '</div>';
						}
					});
					html += '</div>';
				}
				$('#communityBox').append(html);
			} 
		});
	}

	//친구 요청 승인
	function fuApprovalFriend(friendId) {
		var userId = $('#userId').val();
		var data = {
			userId : friendId,
			friendId : userId
		};

		$.ajax({
			url: '/mypage/approvalFriend',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response) {
				var result = response.data;

				if(friendId === result.userId) {
					var html = '<p class="text"><spring:message code="button.accept" text="Accept" /></p>';
					$('div.community-ctrl.'+result.userId).html(html);
				}
			} 
		});
	}

	//친구 요청 거절
	function fuRejectFriend(friendId) {
		var userId = $('#userId').val();
		var data = {
			userId : friendId,
			friendId : userId
		};

		$.ajax({
			url: '/mypage/rejectFriend',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response) {
				var result = response.data;

				if(friendId === result.userId) {
					var html = '	<p class="text"><spring:message code="button.reject" text="Delete" /></p>';
					$('div.community-ctrl.'+result.userId).html(html);
				}

			}
		});
	}

	//인증 요청 팝업 조회 
	function fnCertificateMove(userId,friendId, skillCode, examClassCode){
		
		$("#userIds").val(userId);
		$("#friendIds").val(friendId);
		$("#skillCodes").val(skillCode);
		$("#examClassCodes").val(examClassCode);

		var fullName = '${sessionScope.fullName}';
		
	    $.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        data : {userId : friendId , skillCode : skillCode, examClassCode : examClassCode, friendId: userId},
	        url : '/mypage/getExamResult',
	        success : function(response) {
	          var result = response.data;
	          var userInfo = result.user;
	          var myFriendId = $('input[name=myFriendId]').val();
	          var html = '';
	        	  html += '<img src="'+userInfo.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
	          $('div.photo.friendImage').html(html);

	          $('div.country.friendCountry').html('<img src="https://flagcdn.com/w640/'+userInfo.countryCode.toLowerCase()+'.png" alt="">');
	          $('span.name.friendName').text(userInfo.name+' '+userInfo.firstName);
	        //  $('span.career.friendJob').text(userInfo.jobName);
	          $('p.test-title.skillName').text(userInfo.skillName);
	          $('p.test-title.d-down-md.skillName').text(userInfo.skillName);
	          
	          $('div.stat').hide();
	          var friendCheckList = result.friendCheckList;
	          $.each(friendCheckList, function(index, data) {
					if(data.friendId == userInfo.userId) {
						$('div.stat').show();
					}
					return true;
				});

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
	          alert("데이터를 가져오는데 실패하였습니다.");
	       }
	    }); 
	}
	
	//인증 요청 승인
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
	
	//인증 요청 거부
	function fuCompleteSkillDel(){	
		//T_SKILL_FRIEND_AUTH 테이블 IS_AUTH 값 N으로 처리 
		var userId = $("#userIds").val();
		var friendId = $("#friendIds").val();
		var skillCode = $("#skillCodes").val();
		var authContents = $("#authContents").val();
		var examClassCode = $("#examClassCodes").val();
		
		var data = {
				userId : friendId,
				friendId : userId,
				skillCode : skillCode,
				authContents : authContents,
				examClassCode : examClassCode
		};
		if(confirm("<spring:message code="complete.alert.msg1" text="인증을 거절하시겠습니까?"/>")) {
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

	//교육 조회
	function getEducationList() {
		$.ajax({
			url: '/mypage/eduList',
			type: 'get',
			dataType: 'json',
			success: function(response){
				var resultList = response.data;

				var edu = '';
				var filter = 'win16|win32|win64|mac|macintel';
				if(resultList == '' || resultList == null) {
					var html = '';
						html += '<div class="box box-shadow box-round box-community">';
						html += '	<div class="no-data">';
						html += '		<em class="ico ico-skill"></em>';
						html += '		<p class="text"><spring:message code="education.text3" text="There Are No Registered Traingins." /></p>';
						html += '	</div>';
						html += '</div>';
					$('p.text-info.edu').after(html);
				} else {
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
				}
				
			},
			error : function() {
				var html = '';
					html += '<div class="box box-shadow box-round box-community">';
					html += '	<div class="no-data">';
					html += '		<em class="ico ico-skill"></em>';
					html += '		<p class="text"><spring:message code="education.text3" text="There Are No Registered Traingins." /></p>';
					html += '	</div>';
					html += '</div>';
				$('p.text-info.edu').after(html);
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
	
	//포트폴리오 조회
	function getPortfolioList() {
		$.ajax({
	        type : 'POST',  
	        dataType : 'json', 
	        url : '/mypage/portfolioList',
	        success : function(response) {
	          var resultList = response.data;
	          
	          var html = '';
	          if(resultList != null && resultList.length > 0){
				for (var i = 0; i < resultList.length; i++) {
					 var qrUrl =  server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+resultList[i].userId+"&otherEmail="+resultList[i].email+"&portfolioId="+resultList[i].portfolioId+"&type=others";
				 	 html += '<div class="col-item">';
					 html += '	<a href="/studio/project/projectListForm?portfolioId='+resultList[i].portfolioId+'" class="portfolio-item">';
					 html += '		<p class="portfolio-title">'+resultList[i].name+'</p>';
					 html += '		<div class="box box-shadow box-round box-portfolio">';
					 html += '			<div class="thumb">';
					 html += '				<img src="'+resultList[i].listImagePath+'" alt="">';
					 html += '			</div>';
					 html += '			<div class="portfolio-info">';
					 html += '				<span class="public-setting">Public</span>';
					 html += '				<div class="total">';
					 html += '					<span class="number">'+resultList[i].projectCount+'</span>';
					 html += '					<span class="title"><spring:message code="mypage.text11" text="Proyectos" /></span>';
					 html += '				</div>';
					 html += '				<div class="like">';
					 html += '					<em class="ico ico-like-on"></em>';
					 html += '					<span class="number">'+resultList[i].likeCount+'</span>';
					 html += '				</div>';
					 if(resultList[i].isUseQr == 'Y'){
						 html += '			<div id="qr-portfolio_'+(i+1)+'" class="qrcode"></div>';
						  var userId_01 = resultList[i].userId;	
						  var email_01 = resultList[i].email;
								
						  var portfolioId_01;
						  var portfolioId_02;
						  var portfolioId_03;
						  
						 if(resultList.length == 1){							
							 portfolioId_01 = resultList[0].portfolioId;
						 }
						 if(resultList.length == 2){							
							 portfolioId_01 = resultList[0].portfolioId;
							 portfolioId_02 = resultList[1].portfolioId;
						 }
						 if(resultList.length == 3){							 
							 portfolioId_01 = resultList[0].portfolioId;
							 portfolioId_02 = resultList[1].portfolioId;
							 portfolioId_03 = resultList[2].portfolioId;
						 }
					 }
					 html += '			</div>';
					 html += '		</div>';
					 html += '	</a>';
					 html += '		<ul class="sns-list">';  
					 html += '			<li class="sns-facebook"><a href="javascript:;" onclick="snsSubmit(\'facebook\',\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\')"><span>facebook</span></a></li>';
					 html += '			<li class="sns-linkedin"><a href="javascript:;" onclick="snsSubmit(\'linkedin\',\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\')"><span>linkedin</span></a></li>';
					 html += '			<li class="sns-twitter"><a href="javascript:;" onclick="snsSubmit(\'twitter\',\''+resultList[i].userId+'\',\''+resultList[i].email+'\',\''+resultList[i].portfolioId+'\')"><span>twitter</span></a></li>';
					 html += '		</ul>';

					 html += '	<button type="button" class="btn btn-sm btn-outline-gray btn-copy" onclick="urlCopy(\''+qrUrl+'\');">';
					 html += '		<em class="ico ico-copy"></em>URL';
					 html += '	</button>';
					 html += '</div>';	
				  }				   
			  }
			 
	          var noListLength = 3-resultList.length;
			  for (var j = 0; j < noListLength; j++) {
				     html += '<div class="col-item mt-md-7">';
					 html += '	<a href="/studio/portfolio/portfolioFrom" class="portfolio-item disabled">';
                     html += '    <p class="portfolio-title"><spring:message code="mypage.text10" text="Portfoilo" /> '+(j+1)+'</p>';
					 html += '		<div class="box box-shadow box-round box-portfolio">';
					 html += '			<div class="thumb">';
					 html += '				<em class="ico ico-upload"></em>';
					 html += '				<span class="text"><spring:message code="mypage.text12" text="Subir Portafolio" /></span>';
					 html += '			</div>';
					 html += '			<div class="portfolio-info">';
					 html += '				<div class="total">';
					 html += '					<span class="number">0</span>';
					 html += '					<span class="title"><spring:message code="mypage.text11" text="Proyectos" /></span>';
					 html += '				</div>';
					 html += '				<div class="qrcode">';
					 html += '					<img src="/static/assets/images/content/img-qrcode-disabled.png" alt="">';
					 html += '				</div>';
					 html += '			</div>';
					 html += '		</div>';
					 html += '	</a>';
					 html += '</div>'; 
					 
			  }
			  $("#portfolioList").append(html);  
			  
			  //qr 코드 
			  $('#qr-portfolio_1').qrcode({
			 		width: 48,
					height: 48,
					text:  server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_01+"&type=others"
			  });	
			  $('#qr-portfolio_2').qrcode({
					width: 48,
					height: 48,
					text:  server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_02+"&type=others"
			  });
			  $('#qr-portfolio_3').qrcode({
					width: 48,
					height: 48,
					text:  server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+userId_01+"&otherEmail="+email_01+"&portfolioId="+portfolioId_03+"&type=others"
			  });
			    
	       },
	       error:function() {
			var html = '';
			for(var j = 0; j < 3; j++) {
				html += '<div class="col-item mt-md-7">';
				html += '	<a href="/studio/portfolio/portfolioFrom" class="portfolio-item disabled">';
				html += '		<p class="portfolio-title"><spring:message code="mypage.text10" text="Portfoilo" /> '+(j+1)+'</p>';
				html += '			<div class="box box-shadow box-round box-portfolio">';
				html += '				<div class="thumb">';
				html += '					<em class="ico ico-upload"></em>';
				html += '					<span class="text"><spring:message code="mypage.text12" text="Subir Portafolio" /></span>';
				html += '				</div>';
				html += '				<div class="portfolio-info">';
				html += '					<div class="total">';
				html += '						<span class="number">0</span>';
				html += '						<span class="title"><spring:message code="mypage.text11" text="Proyectos" /></span>';
				html += '					</div>';
				html += '					<div class="qrcode">';
				html += '						<img src="/static/assets/images/content/img-qrcode-disabled.png" alt="">';
				html += '					</div>';
				html += '				</div>';
				html += '			</div>';
				html += '	</a>';
				html += '</div>';
			}
			$('#portfolioList').append(html);
	       }
	    }); 
	}

	//포토폴리오 프로젝트 화면 이동 
	function fnProjectView(portfolioId){
		location.href= "/studio/project/projectListForm?portfolioId="+ portfolioId;		
	}

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
	</script>
</body>
</html>