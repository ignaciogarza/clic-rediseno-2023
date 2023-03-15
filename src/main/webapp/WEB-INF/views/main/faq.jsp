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
<style>
pre {
	font-size: unset;
	font-family: unset;
	letter-spacing: 0;
	word-wrap: break-word;
	word-break: keep-all;
}
.gvm-wrapper {
	background-color: #ffffff;
}
</style>
</head>
<body>
<c:choose>							 
	<c:when test = "${sessionScope.userTypeCode == '0102'}">		
		<div class="wrapper gvm-wrapper gvm-login">
		<jsp:include page="../common/dashboardHeader.jsp"></jsp:include>
	</c:when>
	<c:otherwise>
		<div class="wrapper">
		<jsp:include page="../common/header.jsp"></jsp:include>
	</c:otherwise>
</c:choose>
	<div id="container">
		<article id="content">
			<div class="content-fixed policy-wrap">
				<div class="content-header">
					<h2 class="content-title"><spring:message code="footer.menu.4" text="FAQ" /></h2>
					<button type="button" class="btn btn-back">prev</button>
				</div>
				<div class="content-body style2">
					<nav class="tab-menu">
						<ul class="tab-list">
							<%-- <li class="${code eq '2501' ? 'on' : ''}"><a href="?code=2501"><spring:message code="faq.type.1" text="회원" /></a></li>
							<li class="${code eq '2502' ? 'on' : ''}"><a href="?code=2502"><spring:message code="faq.type.2" text="서비스 이용" /></a></li>
							<li class="${code eq '2503' ? 'on' : ''}"><a href="?code=2503"><spring:message code="faq.type.3" text="이력서" /></a></li>
							<li class="${code eq '2504' ? 'on' : ''}"><a href="?code=2504"><spring:message code="faq.type.4" text="포트폴리오" /></a></li>
							<li class="${code eq '2505' ? 'on' : ''}"><a href="?code=2505"><spring:message code="faq.type.5" text="기타" /></a></li> --%>
						</ul>
					</nav>
					<div class="tab-content">
						<div class="toggle-list mt-lg-8"></div>
						<div class="pagination d-up-lg mt-lg-6"></div>
					</div>
				</div>
			</div>
		</article>
	</div>
	<c:choose>							 
		<c:when test = "${sessionScope.userTypeCode == '0102'}">
			<jsp:include page="../common/dashboardFooter.jsp"></jsp:include>
		</c:when>
		<c:otherwise>
			<jsp:include page="../common/footer.jsp"></jsp:include>
		</c:otherwise>
	</c:choose>
</div>
<script>
let code = getParameterByName('code');
$(document).ready(function() {
	searchFaq(1);
	if(code == '') {
		code = '2501';
	}
	
	var users = (code == '2501') ? 'on' : '';
	var services = (code == '2502') ? 'on' : '';
	var resumes = (code == '2503') ? 'on' : '';
	var portfolios = (code == '2504') ? 'on' : '';
	var others = (code == '2505') ? 'on' : '';

	var li = '';
		li += '<li class="'+users+'"><a href="?code=2501"><spring:message code="faq.type.1" text="회원" /></a></li>';
		li += '<li class="'+services+'"><a href="?code=2502"><spring:message code="faq.type.2" text="서비스 이용" /></a></li>';
		li += '<li class="'+resumes+'"><a href="?code=2503"><spring:message code="faq.type.3" text="이력서" /></a></li>';
		li += '<li class="'+portfolios+'"><a href="?code=2504"><spring:message code="faq.type.4" text="포트폴리오" /></a></li>';
		li += '<li class="'+others+'"><a href="?code=2505"><spring:message code="faq.type.5" text="기타" /></a></li>';
		
	$('ul.tab-list').append(li);
});

//URL 파라미터 값 가져오기
function getParameterByName(name) { 
	name = name.replace(/[\[]/, "\\[").replace(/[\]]/, "\\]"); 
	var regex = new RegExp("[\\?&]" + name + "=([^&#]*)"), 
	results = regex.exec(location.search); 
	return results == null ? "" : decodeURIComponent(results[1].replace(/\+/g, " ")); 
}

function searchFaq(page) {
	let limit = 20;
	let offset = (page - 1) * limit;
	
	//$('ul.tab-list').remove();
	$.ajax({
		url: '/common/faq/list',
		dataType: 'json',
		data: {
			code: code,
			offset: offset,
			limit: limit
		},
		error: function() {
			// location.href = '/error';
		},
		success: function(result) {
			//
			

			let html = '';
			if(result.data.dataList != null && result.data.dataList.length > 0) {
				for(let i = 0; i < result.data.dataList.length; i++) {
					let item = result.data.dataList[i];
					let category = '';
					switch(item.faqTypeCode) {
						case '2501': category = '<spring:message code="faq.type.1" text="회원" />'; break;
						case '2502': category = '<spring:message code="faq.type.2" text="서비스 이용" />'; break;
						case '2503': category = '<spring:message code="faq.type.3" text="이력서" />'; break;
						case '2504': category = '<spring:message code="faq.type.4" text="포트폴리오" />'; break;
						case '2505': category = '<spring:message code="faq.type.5" text="기타" />'; break;
					}
					html += '<div id="faq-' + item.faqId + '">';
					html += '	<div class="toggle-title">';
					html += '		<a href="javascript:;" class="btn">';
					html += '			<span><span class="category">[' + category + ']</span> ' + item.title + '</span>';
					html += '		</a>';
					html += '	</div>';
					html += '	<div class="toggle-content"><pre>' + item.contents + '</pre></div>';
					html += '</div>';
				}
			}
			$('.toggle-list').html(html);

			// FAQ 아코디언 목록
			$('.toggle-title.on').each(function () {
				$(this).next('.toggle-content').show();
			});
			$('.toggle-title .btn').click(function () {
				$(this).parent('.toggle-title').siblings('.toggle-title').removeClass('on').next('.toggle-content').slideUp('fast');
				$(this).parent('.toggle-title').toggleClass('on').next('.toggle-content').slideToggle('fast');
			});

			if(result.data.totalCount > 0) {
				let pageParam = pagination(result.data.totalCount, page, limit, 10);
				let html = '';
				html += '<a href="javascript:searchFaq(1);" class="direction first">';
				html += '	<span class="sr-only">first</span>';
				html += '</a>';
				if(pageParam.startPage > limit) {
					let p = pageParam.startPage - limit;
					html += '<a href="javascript:searchFaq(' + p + ');" class="direction prev">';
					html += '	<span class="sr-only">prev</span>';
					html += '</a>';
				}
				html += Array.from(Array((pageParam.endPage + 1) - pageParam.startPage).keys()).map(i => {
					let p = pageParam.startPage + i;
					if(page == p) {
						return '<strong>' + p + '</strong>';
					}
					return '<a href="javascript:searchFaq(' + p + ');">' + p + '</a>';
				});
				if(pageParam.endPage < pageParam.totalPage) {
					let p = pageParam.endPage + 1;
					html += '<a href="javascript:searchFaq(' + p + ');" class="direction next">';
					html += '	<span class="sr-only">next</span>';
					html += '</a>';
				}
				html += '<a href="javascript:searchFaq(' + pageParam.totalPage + ');" class="direction last">';
				html += '	<span class="sr-only">last</span>';
				html += '</a>';
				$('.pagination').html(html);
			}
		}
	});
}

function pagination(
	totalCount,
	currentPage = 1,
	pageSize = 10,
	blockPage = 10
) {
	// calculate total pages
	let totalPage = Math.ceil(totalCount / pageSize);

	// ensure current page isn't out of range
	if (currentPage < 1) {
		currentPage = 1;
	} else if (currentPage > totalPage) {
		currentPage = totalPage;
	}

	let startPage, endPage;
	if (totalPage <= blockPage) {
		// total pages less than max so show all pages
		startPage = 1;
		endPage = totalPage;
	} else {
		// total pages more than max so calculate start and end pages
		let blockPageBeforeCurrentPage = Math.floor(blockPage / 2);
		let blockPageAfterCurrentPage = Math.ceil(blockPage / 2) - 1;
		if (currentPage <= blockPageBeforeCurrentPage) {
			// current page near the start
			startPage = 1;
			endPage = blockPage;
		} else if (currentPage + blockPageAfterCurrentPage >= totalPage) {
			// current page near the end
			startPage = totalPage - blockPage + 1;
			endPage = totalPage;
		} else {
			// current page somewhere in the middle
			startPage = currentPage - blockPageBeforeCurrentPage;
			endPage = currentPage + blockPageAfterCurrentPage;
		}
	}

	// calculate start and end item indexes
	let startIndex = (currentPage - 1) * pageSize;
	let endIndex = Math.min(startIndex + pageSize - 1, totalCount - 1);

	// return object with all pager properties required by the view
	return {
		totalCount: totalCount,
		currentPage: currentPage,
		totalPage: totalPage,
		startPage: startPage,
		endPage: endPage,
		startIndex: startIndex,
		endIndex: endIndex
	};
}
</script>
</body>
</html>