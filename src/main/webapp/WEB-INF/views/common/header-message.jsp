<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="/static/common/js/lib/sockjs-client/sockjs.min.js"></script>
<script src="/static/common/js/lib/stomp-websocket/stomp.js"></script>
<div class="modal-popup hide" id="layer-message">
	<div class="dimed"></div>
	<div class="popup-inner">
		<div class="message-wrap message-list">
			<div class="message-header">
				<p class="title"><spring:message code="message.title" text="메세지" /></p>
				<button type="button" class="btn btn-close-popup">Close</button>
			</div>
			<div class="message-content">
				<div class="global-search">
					<input type="text" class="form-control keyword" placeholder="search" title="search">
					<button type="button" class="btn btn-search">Search</button>
				</div>
				<div class="message-result custom-scroll">
					<p class="title"><spring:message code="friend.text2" text="친구" />(<span class="friend-count">0</span>)</p>
					<div class="message-friend-list"></div>
				</div>
			</div>
		</div>
		<div class="message-wrap message-view" style="display: none;"></div>
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
let $popup = $('#layer-message');
let friendId, messageGroupId, messageCount, userImagePath;
let wsCount = 0;
const userId = '${sessionScope.userId}';
let friendParam = {
	page: 1,
	limit: 10,
	offset: 0
}
let messageParam = {
	page: 1,
	limit: 15,
	offset: 0,
	totalPage: 99,
}
$(function() {

	// 헤더 - 메시지 버튼 클릭시 팝업 오픈
	$('#header .btn-message').on('click', function() {
		showFriendList();
	});

	// 친구 목록 닫기 클릭시
	$popup.find('.message-list .btn-close-popup').on('click', function() {
		closeModal('#layer-message');
		$popup.find('.friend-count').text(0);
		$popup.find('.message-list .message-friend-list').html('');
	});

	// 검색 박스에서 엔터시
	$popup.find('.keyword').on('keypress', function(e) {
		if(e.keyCode == '13') {
			searchFriend(friendParam.page = 1);
		}
	});
	// 검색 버튼 클릭시
	$popup.find('.btn-search').on('click', function() {
			searchFriend(friendParam.page = 1);
	});
});

function message_scrollbar(type) {
	let id = '';
	if(type == 'friend') {
		id = 'list';
	}
	else if(type == 'message') {
		id = 'view';
	}

	$popup.find('.message-' + id + ' .custom-scroll').mCustomScrollbar('destroy');
	// 모바일
	if (window.matchMedia("(max-width: 1024px)").matches) {
		$popup.find('.message-' + id + ' .custom-scroll').scroll(function(i) {
			if(type == 'friend') {
				if($(this).scrollTop() >= $(document).height() - $(this).height()){
					searchFriend(++friendParam.page);
				}
			}
			else if(type == 'message') {
				if($(this).scrollTop() <= 10 && messageParam.totalPage >= (messageParam.page + 1)){
					searchMessage(++messageParam.page);
					// $popup.find('.message-view .message-body').scrollTop(20);
				}
			}
		});
	}
	// PC
	else {
		$popup.find('.message-' + id + ' .custom-scroll').mCustomScrollbar({
			// 크롬에서 scrollTo가 작동하지 않는 이슈로 인해 비활성화
			// scrollInertia: 300,
			scrollInertia: 0,
			scrollEasing: 'easeOut',
			callbacks: {
				onTotalScroll: function() {
					if(type == 'friend') {
						searchFriend(++friendParam.page);
					}
				},
				onTotalScrollBack: function() {
					if(type == 'message' && messageParam.totalPage >= (messageParam.page + 1)) {
						searchMessage(++messageParam.page);
						$popup.find('.message-view .custom-scroll').mCustomScrollbar('scrollTo', 20);
					}
				},
				onTotalScrollOffset: 10,
				onTotalScrollBackOffset: 10,
				alwaysTriggerOffsets: false
			}
		});
	}
}
function fnMoveScrollBottom() {
	// 모바일
	if (window.matchMedia("(max-width: 1024px)").matches) {
		let $box = $popup.find('.message-view .message-list-box');
		$popup.find('.message-view .message-body').scrollTop($box.height());
	}
	// PC
	else {
		$popup.find('.message-view .custom-scroll').mCustomScrollbar('scrollTo', 'bottom');
	}
}

// ==============================================================================================================================
function showFriendList() {
	openModal('#layer-message');
	searchFriend(friendParam.page = 1);
	message_scrollbar('friend');
}

function searchFriend(page=1) {
	let search = $popup.find('.keyword').val();
	friendParam.offset = (page - 1) * friendParam.limit;
	$.ajax({
		url: '/message/friend/list',
		dataType: 'json',
		data: {
			searchKeyword: search,
			offset: friendParam.offset,
			limit: friendParam.limit
		},
		error: function() {
			location.href = '/error';
		},
		success: function(result) {
			let html = '';
			if(result.code == 'SUCCESS' && result.data != null) {
				let data = result.data;
				// 친구가 없을 경우
				if(search == '' && data.friendCount == 0) {
					html += '<div class="no-data">';
					html += '	<p class="main-copy"><spring:message code="friend.text5" text="등록된 친구가 없습니다." /></p>';
					html += '	<div class="btn-group-default mt-4">';
					html += '		<a type="button" class="btn btn-md btn-secondary" href="/community/communityRecommendFriendView"><spring:message code="friend.text8" text="친구 찾기" /></a>';
					html += '	</div>';
					html += '</div>';
				}
				// 검색 결과가 없을 경우
				else if(search != '' && data.friendCount == 0) {
					html += '<div class="no-data type2">';
					html += '	<p class="main-copy"><spring:message code="friend.text6" text="검색 결과가 없습니다." /></p>';
					html += '	<p class="sub-copy"><spring:message code="friend.text7" text="입력하신 검색어를 확인해 주세요." /></p>';
					html += '</div>';
				}
				// 친구 목록
				else if(data.friendCount > 0) {
					if(page == 1) {
						html += '<ul class="friend-list">';
					}
					for(let i = 0; i < data.friendList.length; i++) {
						html += _createItem(data.friendList[i]);
					}
					if(page == 1) {
						html += '</ul>';
					}
				}

				if(page == 1) {
					$popup.find('.message-friend-list').html(html);
				}
				else {
					$popup.find('.message-friend-list').append(html);
				}
				$popup.find('.friend-count').text(data.friendCount);

				// 친구(메세지 그룹) 선택시 메시지 박스 오픈
				$popup.find('.message-group').off('click').on('click', function() {
					// 메세지 팝업
					friendId = $(this).data('friend-id');
					messageGroupId = $(this).data('message-group-id');
					messageCount = $(this).data('message-count');
					userImagePath = $(this).find('.photo img').attr('src');
					// openModal('#layer-message');
					let name = $(this).find('.name').text();
					showMessageBox(name);
				});
			}
			else {
				location.href = '/error';
			}
		}
	});

	function _createItem(item) {
		let id = (item.messageGroupId) ? item.messageGroupId : '';
		let html = '';
		html += '	<li class="item">';
		html += '		<a href="javascript:;" class="message-group" data-friend-id="' + item.userId + '" data-message-group-id="' + id + '" data-message-count="' + item.messageCount + '" >';
		html += '			<div class="profile-area">';
		html += '				<div class="profile-frame">';
		html += '					<div class="photo">';
		if(item.userImagePath) {
			html += '					<img src="' + item.userImagePath + '" alt="" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';">';
		}
		else {
			html += '					<img src="/static/assets/images/common/img-sm-profile-default.png" alt="">';
		}
		html += '					</div>';
		html += '					<div class="country">';
		html += '						<img src="https://flagcdn.com/w640/' + item.countryCode.toLowerCase() + '.png"/>';
		// html += '						<img src="/static/assets/images/common/_img-flag.png" alt="">';
		html += '					</div>';
		html += '				</div>';
		html += '				<div class="profile-info">';
		html += '					<span class="name">' + item.name + ' ' + item.firstName + '</span>';
		if(item.jobName) {
			html += '				<span class="career">' + item.jobName + '</span>';
		}
		html += '				</div>';
		html += '			</div>';
		if(!item.confirmation && item.transDate) {
			html += '			<span class="new">N</span>';
		}
		if(item.transDate) {
			html += '			<span class="time">' + getDate(item.transDate) + '</span>';
		}
		html += '		</a>';
		html += '	</li>';
		return html;
	}
}


// ==============================================================================================================================
function showMessageBox(name) {
	let html = '';
	html += '<div class="message-header">';
	html += '	<div class="profile-area">';
	html += '		<div class="profile-frame">';
	html += '			<div class="photo">';
	if(userImagePath) {
		html += '			<img src="' + userImagePath + '" alt="" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';">';
	}
	else {
		html += '			<img src="/static/assets/images/common/img-sm-profile-default.png" alt="">';
	}
	html += '			</div>';
	html += '		</div>';
	html += '		<div class="profile-info">';
	html += '			<span class="name">' + name + '</span>';
	html += '		</div>';
	html += '	</div>';
	html += '	<button type="button" class="btn btn-close-popup">close</button>';
	html += '</div>';
	html += '<div class="message-content">';
	html += '	<div class="message-body custom-scroll">';
	html += '		<div class="message-list-box"></div>';
	html += '	</div>';
	html += '	<div class="message-footer">';
	html += '		<div class="input-group">';
	html += '			<textarea class="form-control message-box" data-autoresize rows="1" placeholder="" style="box-sizing: border-box; resize: none;"></textarea>';
	html += '			<div class="input-addon">';
	html += '				<button type="button" class="btn btn-sm btn-secondary btn-send"><spring:message code="button.send" text="Send" /></button>';
	html += '			</div>';
	html += '		</div>';
	html += '	</div>';
	html += '</div>';

	$popup.find('.message-list').hide();
	$popup.find('.message-view').show();
	$popup.find('.message-view').html(html);
	textareaResizing();

	// 메세지 박스 닫기 클릭시
	$popup.find('.message-view .btn-close-popup').on('click', function() {
		$popup.find('.message-view').html('');
		$popup.find('.message-view').hide();
		$popup.find('.message-list').show();
		searchFriend(friendParam.page = 1);
		disconnect(messageGroupId);
		wsCount = 0;
	});

	$popup.find('.message-box').on('keydown', function(e) {
		if(e.keyCode == 13) {
			e.stopPropagation();
			e.preventDefault();
			if(e.ctrlKey) {
				let text = $(this).val() + '\n';
				$(this).val(text);
			}
			else {
				$popup.find('.btn-send').trigger('click');
			}
		}
	});

	// 메세지 전송 버튼 클릭시
	$popup.find('.btn-send').on('click', function() {
		send(messageGroupId);
	});

	if(messageGroupId) {
		searchMessage(messageParam.page = 1);
	}
	connect(messageGroupId);
	message_scrollbar('message');
}

function searchMessage(page=1) {
	messageParam.offset = (page - 1) * messageParam.limit + wsCount;
	$.ajax({
		url: '/message/list',
		dataType: 'json',
		data: {
			messageGroupId: messageGroupId,
			offset: messageParam.offset,
			limit: messageParam.limit
		},
		error: function() {
			console.log('error');
		},
		success: function(result) {
			if(result.code == 'SUCCESS' && result.data != null) {
				let data = result.data;

				if(page == 1) {
					messageParam.totalPage = Math.floor(data.messageCount / messageParam.limit) + (data.messageCount % messageParam.limit > 0 ? 1 : 0);
				}

				let lastTrans;
				for(let i = 0; i < data.messageLists.length; i++) {
					let item = data.messageLists[i];
					createMessage(page, item.from, item.messageContents, item.transDate);
					lastTrans = item.transDate;
				}

				if(data.messageLists.length > 0 && messageParam.totalPage <= page) {
					let date1 = getFullDate(lastTrans);
					let className = 'date-' + date1.replace(/\./gi, '-')
					let $box = $popup.find('.message-view .message-list-box');
					if($box.find('.' + className).length == 0) {
						$box.prepend('<div class="date"><span>' + date1 + '</span></div>');
					}
					if(page == 1) {
						fnMoveScrollBottom();
					}
				}
			}
		}
	});
}

function createMessage(page, from, message, transDate, append=false) {
	let $box = $popup.find('.message-view .message-list-box');
	let html = '';
	if(from) {
		html += '<div class="message to">';
	}
	else {
		html += '<div class="message from">';
		html += '	<div class="photo">';
		if(userImagePath) {
			html += '	<img src="' + userImagePath + '" alt="" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\';">';
		}
		else {
			html += '	<img src="/static/assets/images/common/img-sm-profile-default.png" alt="">';
		}
		html += '	</div>';
	}
	html += '		<pre class="content">' + XSSFilter(message) + '</pre>';
	html += '		<p class="time" data-time="' + transDate + '">' + getTime(transDate) + '</p>';
	html += '	</div>';

	if(append) {
		if($box.find('.message').length > 0) {
			let date1 = getFullDate(transDate);
			let date2 = getFullDate($box.find('.message').last().find('.time').data('time'));
			if(date2 != date1) {
				html = '<div class="date date-' + date1.replace(/\./gi, '-') + '"><span>' + date1 + '</span></div>' + html;
			}
		}
		$box.append(html);
		fnMoveScrollBottom();
	}
	else {
		if($box.find('.message').length > 0) {
			let date1 = getFullDate(transDate);
			let date2 = getFullDate($box.find('.message').eq(0).find('.time').data('time'));
			if(date2 != date1) {
				html += '<div class="date date-' + date2.replace(/\./gi, '-') + '"><span>' + date2 + '</span></div>';
			}
		}
		$box.prepend(html);
		if(page == 1) {
			fnMoveScrollBottom();
		}
	}
}

function ajaxMessageConfirm(messageGroupId, messageId) {
	let param = {
		'messageGroupId': messageGroupId,
		'messageId': messageId
	}
	$.ajax({
		url: '/message/confirm',
		method: 'POST',
		data: param,
		dataType: 'json'
	})
}
// ==============================================================================================================================
let stompClient = {};
function connect(messageGroupId) {
	let socket = new SockJS('/websocket');
	stompClient[messageGroupId] = Stomp.over(socket);
	stompClient[messageGroupId].connect({}, function (frame) {
		enter(messageGroupId);

		stompClient[messageGroupId].subscribe('/topic/group/' + messageGroupId, function (message) {
			let json = JSON.parse(message.body);
			ajaxMessageConfirm(json.messageGroupId, json.messageId);
			createMessage(0, userId == json.fromId, json.message, json.trans, true);
			wsCount++;
		});
	});
}

function disconnect(messageGroupId) {
	if(stompClient[messageGroupId] !== null) {
		stompClient[messageGroupId].disconnect();
	}
	console.log('Disconnected');
}

function send(messageGroupId) {
	let message = $popup.find('.message-box').val();
	if(message != '') {
		$.ajax({
			url: '/fword/check',
			method: 'POST',
			data: {
				w: message
			},
			dataType: 'json',
			success: function(result) {
				if(result.data == true) {
					let text1 = '<spring:message code="alert.text.1-1" text="입력한 내용에 금칙어가 포함되어 있습니다." />';
					let text2 = '<spring:message code="alert.text.1-2" text="금칙어 삭제 후 등록해 주세요." />'
					alert(text1 + '\n' + text2);
				}
				else {
					let param = {
						'gId': messageGroupId,
						'tId': friendId,
						'fId': userId,
						'm': message
					}
					stompClient[messageGroupId].send('/ws/message', {}, JSON.stringify(param));
					$popup.find('.message-box').val('');
					$popup.find('.message-box').css('height', '40px');
				}
			}
		});
	}
}

function enter(messageGroupId) {
	let param = {
		'gId': messageGroupId
	}
	stompClient[messageGroupId].send('/ws/enter', {}, JSON.stringify(param));
}
</script>