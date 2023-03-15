// 공통 UI 제어 스크립트

allmenuSetting();
textareaResizing();
barPercent();

// 전체메뉴
function allmenuSetting() {
	$('.lnb-list ul').each(function () {
		$(this).parent('li').addClass('collapse');
	});
}

// 메시지 입력 영역 확장
function textareaResizing(){
	$('textarea[data-autoresize]').each(function() {
		var offset = this.offsetHeight - this.clientHeight;
		var textareaHeight = function(el) {
			$(el).css('height', 'auto').css('height', el.scrollHeight + offset);
			var mbody = $('.message-content').outerHeight() - $('.message-footer').outerHeight();
			$('.message-body').css('max-height', mbody);
		};
		$(this).on('keyup input', function() {
			textareaHeight(this);
		}).removeAttr('data-autoresize');
	});
}

$(document).on('click', '.btn-allmenu-open', function (e) {
	e.preventDefault();
	$('body').addClass('allmenu-open');
}).on('click', '.btn-allmenu-close', function () {
	$('body').removeClass('allmenu-open');
});

$(document).on('click', '.lnb-list .collapse > a', function (e) {
	if ($(window).width() < 1025) {
		if ($(this).next('ul').length > 0) {
			e.preventDefault();
			$(this).next('ul').slideToggle(300).parent('li').toggleClass('on').siblings('li').removeClass('on').children('ul').slideUp(300);
		}
	}
});

// GNB
$(document).on('mouseenter', '.gnb-list > li', function () {
	$(this).addClass('active');
}).on('mouseleave', '.gnb-list > li', function () {
	$(this).removeClass('active');
});

$(window).on('scroll', function () {
	if ($(window).width() <= 1024 && $(this).scrollTop() > 50) {
		$('body').addClass('header-fixed');
	} else if ($(window).width() > 1024 && $(this).scrollTop() > 62) {
		$('body').addClass('header-fixed');
	} else {
		$('body').removeClass('header-fixed');
	}
});

// 모달 레이어
$(function () {
	$('.modal-popup.show').each(function () {
		openModal($(this), null);
	});
});

var modalOpener = null;
$(document).on('click', 'a.js-layer-open', function (e) {
	var tg = $(this).attr('href');
	openModal(tg, $(this));
	e.preventDefault();
}).on('click', '.js-layer-close, .modal-popup .btn-close-popup, .modal-popup .js-layer-close, .modal-popup .dimed.close', function () {
	var target = $(this).closest('.modal-popup').attr('id');
	closeModal('#' + target, modalOpener);
}).on('keydown', '.modal-popup .popup-inner', function (e) {
	if ($('.popup-inner').is(e.target) && e.keyCode == 9 && e.shiftKey) { // shift + tab
		e.preventDefault();
		$(this).find('.btn-close-popup').focus();
	}
}).on('keydown', '.modal-popup .btn-close-popup', function (e) {
	if (e.keyCode == 9 && !e.shiftKey) { // tab
		e.preventDefault();
		$(this).closest('.popup-inner').attr('tabindex', '0').focus();
		$(this).unbind('keydown').keydown();
	}
});

function openModal(_target, _opener) {
	modalOpener = _opener;
	if ($(_target).length > 0) {
		$('body').addClass('modal-open');
		$(_target).appendTo('body');
		setTimeout(function () {
			$(_target).addClass('show').removeClass('hide');
		}, 100);
		// setTimeout(function () {
		// 	$('.popup-inner', _target).attr('tabindex', '0').focus();
		// }, 300);
	}
}

function closeModal(_target, _opener) {
	var tg = $(_target);
	$('body').removeClass('modal-open');


	if (tg.length == 0) {
		tg = $('.modal-popup.show');
	}

	tg.addClass('hide').removeClass('show');
	var modalOpener = $(_opener);
	if (modalOpener.length > 0) {
		// modalOpener.focus();
	}
}

// 드롭다운
$(document).on('click', '.dropdown', function () {
	$('.dropdown-select, .dropdown').not(this).removeClass('opened');
	$('.portfolio-ctrl').removeClass('opened');
	if ($(this).hasClass('opened')) {
		$(this).not('.disabled').removeClass('opened');
	} else {
		$(this).not('.disabled').addClass('opened');
	}
	return false;
}).on('click', 'html', function(e) {
	var target = e.target;
	if (!$(target).is('.dropdown')) {
		$('.dropdown').not('.disabled').removeClass('opened');
	}
});

// 셀렉트박스
$(document).on('click', '.dropdown-select .btn', function () {
	var except = $(this).closest('.dropdown-select');
	$('.dropdown-select, .dropdown').not(except).removeClass('opened');
	if ($(window).width() <= 1024) {
		$('body').removeClass('select-open');
	}
	if ($(this).closest('.dropdown-select').hasClass('opened')) {
		$(this).closest('.dropdown-select').not('.disabled').removeClass('opened');
		if ($(window).width() <= 1024) {
			$('body').removeClass('select-open');
		}
	} else {
		$(this).closest('.dropdown-select').not('.disabled').addClass('opened');
		if ($(window).width() <= 1024) {
			$('body').addClass('select-open');
		}
	}
	return false;
}).on('click', '.dropdown-select .dropdown-list li a, .dropdown-select .dimed, .dropdown-select-country .btn-lg:not(.disabled)', function() {
	$(this).closest('.dropdown-select').removeClass('opened').addClass('on');
	if ($(window).width() <= 1024) {
		$('body').removeClass('select-open');
	}
}).on('click', 'html', function(e) {
	if ($(window).width() > 1024) {
		var target = e.target;
		if (!$(target).is('.dropdown-select')) {
			$('.dropdown-select').not('.disabled').removeClass('opened');
		}
	}
});

// 패스워드 Password Visible
$(document).on('click', '.form-item .btn-view', function () {
	var inputType = 'text';
	if ($(this).closest('.form-item').hasClass('show')) {
		inputType = 'password';
	}
	$(this).closest('.form-item').toggleClass('show').find('input').attr('type', inputType);
});

// 스크롤바 커스텀 디자인
$(function () {
	scrollbar();
});

function scrollbar() {
	var handleMediaChange = function (mediaQueryList) {
		if (mediaQueryList.matches) {
			// 모바일
			$('.custom-scroll').mCustomScrollbar('destroy');
		} else {
			// 데스크탑
			$('.custom-scroll').mCustomScrollbar({
				scrollInertia: 300
			});
		}
	}
	var mediaQueryMatch = window.matchMedia("(max-width: 1024px)");
	mediaQueryMatch.addListener(handleMediaChange);
	handleMediaChange(mediaQueryMatch);
}

// 인증 별점
$(document).on('click', '.star-rating input[type="radio"]', function () {
	var theNumber = $(this).attr('id').slice(-1);
	$(this).siblings('label').each(function() {
		var sibNumber = $(this).attr('for').slice(-1);
		if (sibNumber <= theNumber) {
			$(this).addClass('on');
		} else {
			$(this).removeClass('on');
		}
	});
});

$(window).on('load resize', function() {
	// 문제 진행바
	if ($('.question-progress').length) {
		var questionNumber = $('.question-progress').attr('class').match(/\d+/)[0];
		var currentNumber = $('.question-progress .bar').attr('class').match(/\d+/)[0];
		var progress = (100/questionNumber)*currentNumber;

		if ($(window).width() <= 1024) {
			if (progress > 16.96) {
				$('.question-progress .fill').css('width', progress+'%');
			} else {
				$('.question-progress .fill').css('width', 56+'px');
			};
		} else {
			if (progress > 6.5) {
				$('.question-progress .fill').css('width', progress+'%');
			} else {
				$('.question-progress .fill').css('width', 72+'px');
			};
		}
	}

	templateResize();
});

// 정답선택 비율 바
function barPercent() {
	$('.bar-percent').each(function () {
		var percentNumber = $(this).find('.bar').attr('class').match(/\d+/)[0];
		$(this).find('.fill').css('width', percentNumber+'%');
	});
}

// 포트폴리오 목록 편집 레이어
$(document).on('click', '.portfolio-ctrl .btn-edit', function () {
	if ($(window).width() <= 1024) {
		$('.dropdown-select, .dropdown').removeClass('opened');
		$('.portfolio-ctrl .btn-edit').not(this).closest('.portfolio-ctrl').removeClass('opened');
		if ($(this).closest('.portfolio-ctrl').hasClass('opened')) {
			$(this).closest('.portfolio-ctrl').removeClass('opened');
		} else {
			$(this).closest('.portfolio-ctrl').addClass('opened');
		}
		return false;
	}
}).on('click', 'html', function(e) {
	var target = e.target;
	if (!$(target).is('.portfolio-ctrl')) {
		$('.portfolio-ctrl').removeClass('opened');
	}
});

$(document).ready(function () {
	// 모바일 헤더 미노출
	if ($('.content-fixed').length) {
		$('body').addClass('header-none');
	}

	// 하단 고정 버튼
	if ($('.btn-group-fixed').length) {
		$('body').addClass('btn-fixed');
	}

	// 경력사항 팝업 textarea 높이값 조절
	if ($('.popup-career').length) {
		if ($(window).width() < 1280) {
			var formHeight = $('.popup-career .popup-body').outerHeight();
			var textareaHeight = formHeight - 404;
			$('.popup-career textarea').css('min-height', textareaHeight);
		}
	}

	// FAQ 아코디언 목록
	$('.toggle-title.on').each(function () {
		$(this).next('.toggle-content').show();
	});
	$('.toggle-title .btn').click(function () {
		$(this).parent('.toggle-title').siblings('.toggle-title').removeClass('on').next('.toggle-content').slideUp('fast');
		$(this).parent('.toggle-title').toggleClass('on').next('.toggle-content').slideToggle('fast');
	});

	// 국가 및 지역 설정 초기 세팅
	$('.dropdown-select-country .country-list .on a').each(function () {
		var tg = $(this).attr('href');
		if (tg !== '#' && tg !== '#;' && tg.charAt(0) === '#') {
			$(tg + '.region-content').css('display', 'block');
		}
	});
});

// 이력서 템플릿 모바일 사이즈 축소
function templateResize() {
	var popupWidth = $('.popup-template .popup-body').innerWidth() - 30;
	var tgHeight = $('.popup-template .template-inner').height();
	var scaleRate = (popupWidth/1040);
	var changeHeight = (tgHeight*scaleRate);

	if ($(window).width() < 1280) {
		$('.popup-template .template-wrap').css('background-size', popupWidth+'px');
		$('.popup-template .template-preview').css('transform', 'scale('+scaleRate+')');
		$('.popup-template .template-inner').css('height', changeHeight);
	} else {
		$('.popup-template .template-preview').css('transform', '');
		$('.popup-template .template-inner').css('height', '');
	}
}

// 척도 선택 문제
var sheet = document.createElement('style'),  
	$rangeInput = $('.range input'),
	prefs = ['webkit-slider-runnable-track', 'moz-range-track', 'ms-track'];

document.body.appendChild(sheet);

var getTrackStyle = function (el) {  
	var curVal = el.value,
			itemLength = $('.range-label li').length,
			val = (curVal - 1) * (100 / (itemLength - 1)),
			style = '';
  
	// Set active label
	$('.range-label li').removeClass('active selected');

	var curLabel = $('.range-label').find('li:nth-child(' + curVal + ')');

	curLabel.addClass('active selected');
	curLabel.prevAll().addClass('selected');

	// Change background gradient
	for (var i = 0; i < prefs.length; i++) {
		style += '.range {background: linear-gradient(to right, #1744ae 0%, #1744ae ' + val + '%, transparent ' + val + '%, transparent 100%)}';
		// style += '.range input::-' + prefs[i] + '{background: linear-gradient(to right, #1744ae 0%, #1744ae ' + val + '%, #edf0f5 ' + val + '%, #edf0f5 100%)}';
	}
	return style;
}

$rangeInput.on('input', function () {
	sheet.textContent = getTrackStyle(this);
});

$('.range-label li').on('click', function () {
	var index = $(this).index();
	$rangeInput.val(index + 1).trigger('input');
});

// 모바일 이력서 스크롤 시 기능 버튼 상단 고정
if ($('.resume-ctrl').length) {
	$(window).on('scroll', function () {
		if ($(window).width() < 1280 && $(this).scrollTop() > 120) {
			$('body').addClass('ctrl-fixed');
		} else {
			$('body').removeClass('ctrl-fixed');
		}
	});
}

// 국가 및 지역 설정
$('.country-list a').on('click', function (e) {
	var tg = $(this).attr('href');
	$(this).parent('li').addClass('on').siblings('li').removeClass('on');
	$(tg).siblings('.region-content').find('.region-list li').removeClass('on');

	if (tg === '#' || tg === '' || tg === '#;') {
		e.preventDefault();
	} else if (tg.charAt(0) === '#') {
		if ($(tg).hasClass('region-content')) {
			$(tg).show().siblings('.region-content').hide();
			e.preventDefault();
		}
	}
});
$('.region-list a').on('click', function () {
	$(this).parent('li').toggleClass('on').siblings('li').removeClass('on');
});