
$(function() {
	console.log('evaluate.js is load')
	$(document).off('click', '.js-layer-close, .modal-popup .btn-close-popup, .modal-popup .js-layer-close, .modal-popup .dimed.close');

	// 브라우저 종료 감지 이벤트
	$(window).on('beforeunload',function(e) {
		let confirmationMessage = confirmTestGiveUp();
		if(confirmationMessage) {
			// console.log(confirmationMessage);
			(e || window.event).returnValue = confirmationMessage;     // Gecko + IE
			return confirmationMessage;                                // Safari, Chrome, and other WebKit-derived browsers
		}
	});
	// 작동하지 않아 주석 처리
	// // beforeunload 이후 이벤트
	// $(window).on('unload', function() {
	// 	$.ajax({
	// 		url: '/eval/' + popupType + '/status/timeout?skill=' + skill + '&class=' + clazz,
	// 		async: false
	// 	});
	// });
});

// 테스트 중도 포기 alert
function confirmTestGiveUp() {
	if($('#answerForm').length != 0) {
		// IE를 제외한 브라우저에서는 팝업 메시지가 고정임
		let confirmationMessage = window.giveupMsg;
		if(confirm(confirmationMessage)) {
			fnTestGiveUp();
		}
		return confirmationMessage;
	}
}

// 테스트 중도 포기 ajax
function fnTestGiveUp() {
	$.ajax({
		url: '/eval/' + popupType + '/status/timeout?skill=' + skill + '&class=' + clazz,
		dataType: 'json',
		complete: function(jqXHR) {
			let json = jqXHR.requestJSON;
			if(json) {
				if(json.code == 'SUCCESS') {
				}
				else if(json.code == 'CODE_ERROR') {
					alert(json.message);
				}
				else {
					location.href = '/error';
				}
			}
			$(window).off('beforeunload');
			location.href = '/eval/list';
		}
	});
}

let timer;
function fnExamTimeCountdown(startTime, endTime) {
	/*let timezoneOffset = new Date().getTimezoneOffset() * 60 * 1000;
	startTime = Number(startTime) - timezoneOffset;
	endTime = Number(endTime) - timezoneOffset;*/    
	let sTime = new Date(); // 시작 시간
	sTime.setTime(Number(startTime));
	let eTime = new Date();   // 종료 시간
	eTime.setTime(Number(endTime));
	// console.log(`skill => ${skill}, class => ${clazz}, popupType => ${popupType} ============================================`);
	console.log(`startTime => ${startTime}, sTime => ${sTime}`);
	console.log(`endTime   => ${endTime}, eTime => ${eTime}`);

	clearInterval(timer);
	timer = setInterval(() => {
		//DB 현재시간 가져오기
		$.ajax({
			url: '/eval/now',
			type: 'GET',
			dataType: 'json',
			success: function(response) {
				var data = response.data;    
				
				let cTime = new Date(); // 현재 시간
				cTime.setTime(Number(data));
				let dist = eTime.getTime() - cTime.getTime();
				// console.log(`${eTime.getTime()} / ${cTime.getTime()} / dist => ${dist}`);
				
				// 평가화면일 경우 타임아웃 해제
				if($('#layer-test .popup-body .time dd').length == 0) {
					clearInterval(timer);
				}
				else if(dist <= 900) {
					$('#layer-test .popup-body .time dd').text('00:00:00');
					clearInterval(timer);
					$(window).off('beforeunload');
					openModal('#layer-timeout');
					$.ajax({
						url: '/eval/' + popupType + '/status/timeout?skill=' + skill + '&class=' + clazz,
						dataType: 'json',
						error: function() {
							location.href = '/error';
						},
						success: function(result) {
							if(result.code == 'SUCCESS') {
								$('#layer-timeout .btn-check').prop('disabled', false);
							}
							else if(result.code == 'CODE_ERROR') {
								alert(result.message);
							}
							else {
								location.href = '/error';
							}
						}
					});
				}
				else {
					let seconds = parseInt((dist / 1000) % 60);
					let minutes = parseInt((dist / (1000 * 60)) % 60);
					let hours = parseInt(dist / (1000 * 60 * 60));
					// console.log(`dist => ${dist} / ${fnZeroFill(hours) + ':' + fnZeroFill(minutes) + ':' + fnZeroFill(seconds)}`);
					$('#layer-test .popup-body .time dd').text(fnZeroFill(hours) + ':' + fnZeroFill(minutes) + ':' + fnZeroFill(seconds));
				}
			},
			error : function(xhr, status) {
	            console.log(xhr + " : " + status);
	      }
		});
		
	}, 100);
}

function fnZeroFill(val, len = 2, padStr = '0') {
	return String(val).padStart(len, padStr);
}