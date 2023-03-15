var server = {	
	env: 'real',
	local: 'http://localhost:8080', 			//CDN
	dev:  'http://idb.i-screammedia.com:8080', 
	real: 'https://idb-front.azurewebsites.net'
};

/**
 * 패스워드 정책에 부합하는지 확인한다
 (8~16자의 영어 대소문자 및 특수문자 조합)
 */
function isValidPwdPolicy(pwd) {
	var length = pwd.length;
	var minLength = 8, maxLength = 16;
	const ALPHABET_UPPERCASE = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
	const ALPHABET_LOWERCASE = "abcdefghijklmnopqrstuvwxyz";
	const NUMBERS = "0123456789";
	const SPECIAL_CHARS = "!@#$%^&*";
	
	if(length == 0) return false;
	if(length < minLength || length > maxLength) return false;

	var isIncludeUpperCase = false;
	
	for(var i = 0; i < ALPHABET_UPPERCASE.length; i++) {
		if(pwd.includes(ALPHABET_UPPERCASE[i])) {
			isIncludeUpperCase = true;
			break;
		}
	}
	if(!isIncludeUpperCase) return false;

	var isIncludeLowerCase = false;
	
	for(var i = 0; i < ALPHABET_LOWERCASE.length; i++) {
		if(pwd.includes(ALPHABET_LOWERCASE[i])) {
			isIncludeLowerCase = true;
			break;
		}
	}
	if(!isIncludeLowerCase) return false;

	var isIncludeNumber = false;
	
	for(var i = 0; i < NUMBERS.length; i++) {
		if(pwd.includes(NUMBERS[i])) {
			isIncludeNumber = true;
			break;
		}
	}
	if(!isIncludeNumber) return false;

	var isIncludeSpecialChars = false;
	for(var i = 0; i < SPECIAL_CHARS.length; i++) {
		if(pwd.includes(SPECIAL_CHARS[i])) {
			isIncludeSpecialChars = true;
			break;
		}
	}
	if(!isIncludeSpecialChars) return false;
	
	return true;
}



// select box 연도 , 월 일 표시
function setDateBox(year,month,day){
    var dt = new Date();
    var com_year = dt.getFullYear();
    
    // 올해 기준으로 -1년부터 +5년을 보여준다.
    for(var y = (com_year-60); y <= (com_year+1); y++){
    	var html = '<option value="'+ y +'" id="year_'+ y +'">'+y+'</option>';
    	$("#year").append(html);
    }
    // 월 뿌려주기(1월부터 12월)
    var month;
    for(var i = 1; i <= 12; i++){
    	var html = '<option value="'+ i +'" id="month_'+ i +'">'+i+'</option>';
    	$("#month").append(html);
    }
    
    // 월 뿌려주기(1일부터 31일)
    var day;
    for(var i = 1; i <= 31; i++){
    	var html = '<option value="'+ i +'" id="day_'+ i +'" >'+i+'</option>';
    	$("#day").append(html);
    }
    
    //설정된 값 세팅 
    if(year != ""){
    	$("#year").val(year);
 	    $("#month").val(month);
 	    $("#day").val(day);
    }
}

function getDate(val) {
	let today = new Date();
	let timezoneOffset = today.getTimezoneOffset() * 60 * 1000;
	val = Number(val) - timezoneOffset;
	let date = new Date(val);

	let a = today.getFullYear() + '.' + fnZeroPad(today.getMonth() + 1) + fnZeroPad(today.getDate());
	let b = date.getFullYear() + '.' + fnZeroPad(date.getMonth() + 1) + fnZeroPad(date.getDate());

	if(a == b) {
		return getTime(val);
	}
	else if(today.getFullYear() == date.getFullYear()) {
		return getShortDate(val);
	}
	else {
		return getFullDate(val);
	}
}

function getFullDate(val) {
	let date = new Date(val);
	return date.getFullYear() + '.' + fnZeroPad(date.getMonth() + 1)  + '.' +  fnZeroPad(date.getDate());
}

function getShortDate(val) {
	let date = new Date(val);
	return fnZeroPad(date.getMonth() + 1) + '.' + fnZeroPad(date.getDate());
}

function getTime(val) {
	let date = new Date(val);
	return fnZeroPad(date.getHours()) + ':' + fnZeroPad(date.getMinutes());
}

function fnZeroPad(val) {	
	var len = 2;
	return String(val).padStart(len, '0');
}

function XSSFilter(value) {
	value = value.replace(/</g, '&lt;').replace(/>/g, '&gt;');
	value = value.replace(/\(/g, '&#40;').replace(/\)/g, '&#41;');
	value = value.replace(/"/g, '&#34;').replace(/'/g, '&#39;');
	value = value.replace(/eval\((.*)\)/g, '');
	value = value.replace(/["'][\s]*javascript:(.*)["']/g, '""');

	return value;
}


//콤마 숫자 찍기
function addComma(num){	        
    var regexp = /\B(?=(\d{3})+(?!\d))/g;
    return num.toString().replace(regexp, ',');
}

var userDetail;
  //사용자 정보 조회 
function getUserDetail(){
   
   $.ajax({
       type : 'POST',  
       dataType : 'json', 
       url : server[server.env]+'/user/userDetail',       
       success : function(response) {
       	userDetail = response.data.userDetail;  
       	
       	//사이드 프로필 데이터 정리        
       	$("#side_userImagePath").attr("src", userDetail.userImagePath);       
       	$("#side_countryCode").attr("src", "https://flagcdn.com/w640/"+userDetail.countryCode.toLowerCase() +".png");
       	
       
       	$("#side_name").text(userDetail.name+" "+ userDetail.firstName);
       	let lang = getCookie('lang');
       	if(lang == "en"){
			$("#side_jobName").text(userDetail.jobNameEng);
		}else{
			$("#side_jobName").text(userDetail.jobNameSpa);
		}
		
		//비밀번호 변경 팝업
		var passwordIsEarly = userDetail.passwordIsEarly;
		if(passwordIsEarly == "Y"){
			openModal('#layer-pwchange_header');
		}
       	
       	
       	//헤더 부분 처리 
       	if(userDetail != null){
			var userIds = userDetail.userId;
	       	if(userIds != null){
				$("#test333").show();
				$("#test444").show();
				$("#test555").show();
				
				
				$("#test222").remove();
				$("#test777").remove();
			}else{
				$("#test222").show();
				$("#test777").show();
			}	
			
			var isComplete = userDetail.isComplete;
			if(isComplete == "Y"){
				$("#test666").show();
				$("#test1000").show();
				
				$("#test1100").remove();
				
			}else{
				//$("#test777").show();
				if(userIds != null){
					$("#test888").show();
					$("#test1100").show();
				}
			}			
		}else{
			$("#test222").show();
		}
       	
	 
      },error:function(){
         alert("데이터를 가져오는데 실패하였습니다.");		          
      }
   }); 
}

function getDashBoardUserDetail(){
   	
   $.ajax({
       type : 'POST',  
       dataType : 'json', 
       url : 'http://localhost:8080/user/userDetail',
       success : function(response) {
       	userDetail = response.data.userDetail;  
       	if(userDetail != null){
			var userIds = userDetail.userId;
		       	if(userIds != null){
					$("#test333").show();
					$("#test444").show();
					$("#test555").show();
				}else{
					$("#test222").show();
				}	
		}else{
			$("#test222").show();
		}
       	
	 
      },error:function(){
         alert("데이터를 가져오는데 실패하였습니다.");		          
      }
   }); 
}



//다국어 세팅 
function fnOpenLang(lang){	
	setCookie("lang", lang, 7); // 7일 동안 쿠키 보관
	if(lang ==  "es"){
		$("#langText").text("Español");
	}else if(lang == "en"){
		$("#langText").text("English");
	}
    setLanguage(lang);
}

/**
* setLanguage 
* use $.lang[currentLanguage][languageNumber]
*/
function setLanguage(currentLanguage) {
	
    console.log('setLanguage', arguments);

    $('[data-langCode]').each(function () {
        var $this = $(this);
        $this.html($.lang[currentLanguage][$this.data('langcode')]);               
    });
    let cookieArr = document.cookie.split(";");
}

function getCookie(cookieName) {
	    cookieName = cookieName + '=';
	    var cookieData = document.cookie;
	    var start = cookieData.indexOf(cookieName);
	    var cookieValue = '';
	    if(start != -1){
	        start += cookieName.length;
	        var end = cookieData.indexOf(';', start);
	        if(end == -1)end = cookieData.length;
	        cookieValue = cookieData.substring(start, end);
	    }
	    return unescape(cookieValue);
	}

//쿠키 저장 
function setCookie(cookieName, value, exdays){
    var exdate = new Date();
    exdate.setDate(exdate.getDate() + exdays);
    var cookieValue = escape(value) + ((exdays==null) ? "" : "; expires=" + exdate.toGMTString());
    document.cookie = cookieName + "=" + cookieValue;
}



//메인 검색 (사람/포토폴리오)
function mainSearchMobile(page){  	
  	var madinSearchValueMobile = $("#madinSearchValueMobile").val();
  	location.href= "/main/mainSearchView?mainPage="+ page+"&madinSearchValue="+madinSearchValueMobile+"&mainRows=15&type=user";	
  		
}

//메인 검색 (사람/포토폴리오)
function mainSearch(page){
  	var madinSearchValue = $("#madinSearchValue").val();
  	location.href= "/main/mainSearchView?mainPage="+ page+"&madinSearchValue="+madinSearchValue+"&mainRows=15&type=user";		  	
}

//faq로 이동
function fnFaq() {
	location.href='/common/faq';
}


//로그아웃 
function fnSignOut(email){	
	var email = encodeURIComponent(email);		
	location.href= "/login/signOut?email="+email;
	
}

//접속 이력 저장
function fnAccessHistory(frontMenuId){
	var data = {
			frontMenuId : frontMenuId				
	};		
	$.ajax({
		//url: '/user/accessHistoryInsert',
		type: 'post',
		data: data, 
		dataType: 'json',
		success: function(response){
			
		}
	});
}

//비밀번호 변경
function fnPwChangSave_header(){
	
	var userId = "${sessionScope.userId}";
	var email = $("#email").val();
	var passwordOld = $("#passwordOld").val();
	var password_01 = $("#password_01").val();
	var password_02 = $("#password_02").val();
	
	if(passwordOld == "") {					
		alert("기존 비밀번호를 입력해주세요.");
		return false;
	}
	
	if(password_01 == "") {					
		alert("비밀번호을 입력해주세요.");
		return false;
	}
	
	if(passwordOld == password_01) {					
		alert("입력하신 비밀번호가 기존 비밀번호와 동일합니다.");
		return false;
	}
	
	if(password_02 == "") {					
		alert("비밀번호을 입력해주세요.");
		return false;
	}
 	if(password_01 != password_02) {					
		alert("비밀번호가 일치하지 않습니다");
		return false;
	}
	if(password_01.search(/[a-z]/g) < 0) {					
		alert("비밀번호에 영문 소문자를 하나 이상 입력해주세요");
		return false;
	}
	if(password_01.search(/[A-Z]/g) < 0) {					
		alert("비밀번호에 영문 대문자를 하나 이상 입력해주세요");
		return false;
	}
	if(!isValidPwdPolicy(password_01)) {					
		alert("영어, 숫자, 특수문자 포함 8~16자 이내의 조합으로 등록해주세요");
		return false;
	}
	
	var data = {
			userId : userId,				
			email : email,
			password : password_01
	};	
	
	$.ajax({
		url: '/user/userPwUpdate',
		type: 'post',
		data: data,
		dataType: 'json',
		success: function(response){
			console.log(response);
			if(response.code == "SUCCESS"){
				alert('저장되었습니다.');	
				//이메일인증 요청 
				//fnEmailSend(email);
				closeModal('#layer-pwchange_header');
				openModal('#layer-complete_header');
				
			}else{
				alert(response.message);
			}
		}
	});
}