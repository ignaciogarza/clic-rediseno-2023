<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<div class="modal-popup hide" id="layer-notice">
	<div class="dimed close"></div>
	<div class="popup-inner">
		<div class="notice-wrap">
			<div class="notice-header">
				<p class="title"><spring:message code="notice.title" text="알림" /></p>
				<button type="button" class="btn btn-close-popup">Close</button>
			</div>
			<div class="notice-content custom-scroll">
				<p class="text-info"><spring:message code="notice.text.1" text="Solo Puede Ver Notificaciones Hasta Por 3 Meses" /></p>
				<div class="notice-box"></div>
			</div>
		</div>
	</div>
</div>
<style>
pre {
	font-size: unset;
	font-family: unset;
	letter-spacing: 0;
	word-wrap: break-word;
	word-break: keep-all;
}
</style>
<script type="module">
let $popup = $('#layer-notice');
let noticeParam = {
	page: 1,
	limit: 15,
	offset: 0,
	totalCount: 99,
}
$(function() {
	// 헤더 - 알림 버튼 클릭시 팝업 오픈
	$('#header .btn-notice').on('click', function() {
		showNoticeList();
	});

	// 알림 팝업 닫기
	$popup.find('.btn-close-popup, .dimed.close').on('click', function() {
		hideNoticeList();
	});

	
	
	$popup.find('.custom-scroll').mCustomScrollbar('destroy');
	// 모바일
	if (window.matchMedia("(max-width: 1024px)").matches) {
		$popup.find('.custom-scroll').scroll(function(i) {
			if($(this).scrollTop() >= $(document).height() - $(this).height()){
				searchNotice(++noticeParam.page);
			}
		});
	}
	// PC
	else {
		$popup.find('.custom-scroll').mCustomScrollbar({
			scrollInertia: 300,
			scrollEasing: 'easeOut',
			callbacks: {
				onTotalScroll: function() {
					searchNotice(++noticeParam.page);
				},
				onTotalScrollOffset: 10,
				alwaysTriggerOffsets: false
			}
		});
	}
});

// ==============================================================================================================================
function showNoticeList() {
	openModal('#layer-notice');
	searchNotice(noticeParam.page = 1);
}

function hideNoticeList() {
	closeModal('#layer-notice');
	$popup.find('.notice-box').html('');
}

function searchNotice(page=1) {
	noticeParam.offset = (page - 1) * noticeParam.limit;
	if(noticeParam.offset > noticeParam.totalCount) return;
	$.ajax({
		url: '/notice/list',
		dataType: 'json',
		data: {
			offset: noticeParam.offset,
			limit: noticeParam.limit
		},
		error: function() {
			location.href = '/error';
		},
		success: function(result) {
			let html = '';
			if(result.code == 'SUCCESS' && result.data != null) {
				let data = result.data;
				// 데이터가 없을 경우
				if(data.noticeCount == 0) {
					html += '<div class="no-data">';
					html += '	<p class="text"><spring:message code="notice.text.2" text="No hay notificación" /></p>';
					html += '</div>';
				}
				else {
					if(page == 1) html += '<ul class="notice-list">';
					for(let i = 0; i < data.noticeLists.length; i++) {
						let item = data.noticeLists[i];
						// 알림유형 - 클래스 type1 : 친구요청 / type2 : 능력인증요청 / type3 : 능력인증완료 / type4 : 뱃지획득 / type5 : 프로젝트좋아요
						let className = '';
						let url = 'javascript:;';
						switch(item.noticeTypeCode.label) {
							case 'FRIEND_REQUEST'      : 
								className = 'type1';
								url = '/community/communityFriendReceptionView';
								break;;
							case 'SKILL_AUTH_REQUEST'  : 
								className = 'type2';
								url = '/community/communitySkillReceptionView';
								break;;
							case 'SKILL_AUTH_COMPLETE' : 
								className = 'type3';
								url = '/community/communitySkillAllView';
								break;;
							case 'BADGE_OBTAIN'        : 
								className = 'type4';
								url = '/cert/resultList';
								break;;
							case 'PROJECT_LIKE'        : 
								className = 'type5';
								url = '/studio/project/projectForm?portfolioId=' + item.parameter1 + '&projectId=' + item.parameter2;
								break;;
						}
						html += '<li class="' + className + '">';
						html += '	<a href="' + url + '">';
						if(item.noticeTypeCode.label == 'BADGE_OBTAIN') {
							html += '		<span class="name">' + item.badgeName + '</span>';
						}
						else {
							html += '		<span class="name">' + item.name + ' ' + item.firstName + '</span>';
						}
						html += '		<span class="content">' + item.noticeMessage + '</span>';
						html += '		<span class="time">' + getDate(item.createdDate) + '</span>';
						html += '	</a>';
						html += '</li>';
					}
					if(page == 1) html += '</ul>';
				}

				if(page == 1) $popup.find('.notice-box').html(html);
				else          $popup.find('.notice-box .notice-list').append(html);
				
			}
			else {
				location.href = '/error';
			}
		}
	});
}
</script>