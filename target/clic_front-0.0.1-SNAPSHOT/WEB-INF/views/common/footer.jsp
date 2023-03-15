<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<script>
//다국어 문자 변경
function fnOpenLang(type){
	let params = new URLSearchParams(location.search.substr(location.search.indexOf("?") + 1));
	params.set('lang', type);
	console.log('params', params.toString());
	location.href = location.pathname + '?' + params.toString();
	
}
function setParam(sname) {
	let params = new URLSearchParams(location.search.substr(location.search.indexOf("?") + 1));
}
function getCookie(key) {
	let cookieKey = key + "=";
	let result = "";
	let cookieArr = document.cookie.split(";");

	for (let i = 0; i < cookieArr.length; i++) {
		if (cookieArr[i][0] === " ") {
			cookieArr[i] = cookieArr[i].substring(1);
		}

		if (cookieArr[i].indexOf(cookieKey) === 0) {
			result = cookieArr[i].slice(cookieKey.length, cookieArr[i].length);
			return result;
		}
	}
	return result;
}

$(function() {
	let lang = getCookie('lang');

	$('#footer .lang').each(function() {
		if(lang == $(this).data('value')) {
			$('.btn-language').text($(this).text());
		}
	});

	//현재 기본 언어 - 스페인어
	$('html').attr('lang', 'es');

	//헤더 다국어
	console.log('lang: '+lang);
	if(lang == 'en') {
		$('#language_IADB').val('en');
		$('html').attr('lang', 'en');
	} else if(lang == 'es') {
		$('#language_IADB').val('es');
		$('html').attr('lang', 'es');
	}

	//기존 파라미터가 있을 경우 다국어
	const urlParameter = window.location.search;
	if(urlParameter.length > 0) {
		const urlParams = new URLSearchParams(urlParameter);
		if(urlParams.has('lang') == true) {
			urlParams.delete('lang');
			var newUrl = urlParams.toString();
			if(newUrl == '') {
				$('#en_path_IADB').val('?lang=en');
				$('#es_path_IADB').val('?lang=es');
			} else {
				$('#en_path_IADB').val('?'+newUrl+'&lang=en');
				$('#es_path_IADB').val('?'+newUrl+'&lang=es');
			}
		} else {
			$('#en_path_IADB').val(urlParameter+'&lang=en');
			$('#es_path_IADB').val(urlParameter+'&lang=es');
		}
	}
});
</script>
	<footer id="footer">
		<div class="inner">
			<div class="logo-wrap">
				<div class="logo-bottom">
					<a href="/main">Clic</a>
				</div>
			</div>
			<div class="footer-util">
				<ul class="policy-list">
					<%-- <li class="dashboard"><a href="javascript:;" onclick="fnSignOut('${sessionScope.sessionEmail}');">Clic Dashboard</a></li> --%>
					<li class="dashboard"><a href="/login/login">Clic Dashboard</a></li>
					<li><a href="/common/terms-and-conditions"><spring:message code="footer.menu.1" text="이용 약관"/></a></li>
					<li><a href="/common/privacy-policy"><spring:message code="footer.menu.2" text="개인 정보 정책"/></a></li>
					<li><a href="/common/contact-us"><spring:message code="footer.menu.3" text="문의하기"/></a></li>
					<li><a href="/common/faq"><spring:message code="footer.menu.4" text="FAQ"/></a></li>
				</ul>
			</div>
		</div>
	</footer>

<!-- 리소스 추가 (10.28) -->
<script src="https://live-idb-config.pantheonsite.io/modules/custom/api_menu_items/V.0.0.4/js/lib/template-idb.js"></script>
<script src="https://live-idb-config.pantheonsite.io/modules/custom/api_menu_items/V.0.0.4/js/lib/underscore-min.js"></script>
<script src="https://live-idb-config.pantheonsite.io/modules/custom/api_menu_items/V.0.0.4/js/main.js"></script>
<!-- Start __ Header And Footer IADB-->
<input type="hidden" id="language_IADB" name="language_IADB" value="es"><!-- 현재 기본 언어 - 스페인어 -->
<input type="hidden" id="en_path_IADB" name="en_path_IADB" value="?lang=en">
<input type="hidden" id="es_path_IADB" name="es_path_IADB" value="?lang=es">
<input type="hidden" id="pt_path_IADB" name="pt_path_IADB" value="no-link">
<input type="hidden" id="fr_path_IADB" name="fr_path_IADB" value="no-link">
<!-- End __ Header And Footer IADB-->
<!-- // 리소스 추가 (10.28) -->