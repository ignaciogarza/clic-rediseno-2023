<%@ page language="java" contentType="text/html; charset=UTF-8"  pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags" %>
<!DOCTYPE html>
<html lang="en">
<head>
	<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="ie=edge">
	<meta name="viewport" content="width=device-width, initial-scale=1.0" id="viewportMeta">
	<meta name="format-detection" content="telephone=no">
	<title>CLIC</title>
	<!-- 리소스 추가 (10.28) -->
	<link rel="stylesheet" media="all" href="https://live-idb-config.pantheonsite.io/themes/custom/iadb/css/iadb-styles.css?v=0.0.4">
	<!-- // 리소스 추가 (10.28) -->
	<link rel="stylesheet" href="/static/assets/css/style.css">
	
	<!-- pdf 관련 css -->
	<style>
		.html2canvas-container {
			width: 3000px !important;
			height: 25000px !important;
		}
		.dropdown-select .dropdown-inner {
			max-height: 500px;
		}
		.template-wrap.type2 .resume-level .level-state .bar {
			border-radius: 6px;
		}
		.template-wrap.type2 .resume-level .level-state .fill {
			border-radius: 6px;
		}
	</style>
	
	<!-- JavaScript -->
	<script src="/static/assets/js/jquery-3.5.1.min.js"></script>
	<script src="/static/assets/js/jquery.qrcode.min.js"></script>
	
	<!-- 페이지 개별 스크립트 -->
	<script>	
	$(document).ready(function() {
		//이력서 조회
		getResumeDetail();

		//이력서 정보 노출 경고창 - 사진
		$(document).on('click', '#inputCheck1_1', function() {
			if($('#inputCheck1_1').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info1" javaScriptEscape="true" text="이력서에 \'사진\' 정보를 포함합니다." />');
			}
		});
		$(document).on('click', '#inputCheck3_1', function() {
			if($('#inputCheck3_1').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info1" javaScriptEscape="true" text="이력서에 \'사진\' 정보를 포함합니다." />');
			}
		});
		
		//이력서 정보 노출 경고창 - 생년월일
		$(document).on('click', '#inputCheck1_2', function() {
			if($('#inputCheck1_2').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info2" javaScriptEscape="true" text="이력서에 \'생년월일\' 정보를 포함합니다." />');
			}
		});
		$(document).on('click', '#inputCheck3_2', function() {
			if($('#inputCheck3_2').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info2" javaScriptEscape="true" text="이력서에 \'생년월일\' 정보를 포함합니다." />');
			}
		});

		//이력서 정보 노출 경고창 - 성별
		$(document).on('click', '#inputCheck1_3', function() {
			if($('#inputCheck1_3').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info3" javaScriptEscape="true" text="이력서에 \'성별\' 정보를 포함합니다." />');
			}
		});
		$(document).on('click', '#inputCheck3_3', function() {
			if($('#inputCheck3_3').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info3" javaScriptEscape="true" text="이력서에 \'성별\' 정보를 포함합니다." />');
			}
		});

		//이력서 정보 노출 경고창 - 국가
		$(document).on('click', '#inputCheck1_4', function() {
			if($('#inputCheck1_4').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info4" javaScriptEscape="true" text="이력서에 \'국가\' 정보를 포함합니다." />');
			}
		});
		$(document).on('click', '#inputCheck3_4', function() {
			if($('#inputCheck3_4').is(':checked') == true) {
				alert('<spring:message code="resume.alert.info4" javaScriptEscape="true" text="이력서에 \'국가\' 정보를 포함합니다." />');
			}
		});

		//년월 표시
		var dt = new Date();
		var com_year = dt.getFullYear();

		//입사년도 - 올해 기준으로 70년 전
		for(var jy = com_year; jy >= (com_year - 70); jy--) {
			$('#joinYear').append('<li class="joinYear"><a href="javascript:;" onclick="textJoinYearValue(this)">'+jy+'</a></li>');
			$('#admissionYear').append('<li class="admissionYear"><a href="javascript:;" onclick="textAdmissionYearValue(this)">'+jy+'</a></li>');
		}
		//퇴사년도 - 올해 기준으로 70년 전
		for(var ly = com_year; ly >= (com_year - 70); ly--) {
			$('#leaveYear').append('<li class="leaveYear"><a href="javascript:;" onclick="textLeaveYearValue(this)">'+ly+'</a></li>');
			$('#graduatedYear').append('<li class="graduatedYear"><a href="javascript:;" onclick="textGraduatedYearValue(this)">'+ly+'</a></li>');
		}
		//입사월
		for(var jm = 1; jm <= 12; jm++) {
			$('#joinMonth').append('<li class="joinMonth"><a href="javascript:;" onclick="textJoinMonthValue(this)">'+jm+'</a></li>');
			$('#admissionMonth').append('<li class="admissionMonth"><a href="javascript:;" onclick="textAdmissionMonthValue(this)">'+jm+'</a></li>');
		}
		//퇴사월
		for(var lm = 1; lm <= 12; lm++) {
			$('#leaveMonth').append('<li class="leaveMonth"><a href="javascript:;" onclick="textLeaveMonthValue(this)">'+lm+'</a></li>');
			$('#graduatedMonth').append('<li class="graduatedMonth"><a href="javascript:;" onclick="textGraduatedMonthValue(this)">'+lm+'</a></li>');
		}
		
		//이력서 경력사랑 현재 근무 중 check
		if($('#inputCheck3').is(':checked') == true) {
			$('#inputCheck3').val('Y');
		} else {
			$('#inputCheck3').val('N');
		}
		
		//이력서 교육 현재 재학중 check
		if($('#inputCheck4').is(':checked') == true) {
			$('#inputCheck4').val('Y');
		} else {
			$('#inputCheck4').val('N');
		}

		//모바일로 접속할 때 pdf 다운 버튼 안보이게
		var filter = 'win16|win32|win64|mac|macintel';

		if(navigator.platform) {
			if(filter.indexOf(navigator.platform.toLowerCase()) < 0 || $(window).width() < 1024) {
				$('.btn-down.template').prop('disabled', true);
				$('.btn-down.template').hide();
				
				$('.btn-down.template1').prop('disabled', true);
				$('.btn-down.template1').hide();
				
				$('.btn-down.template2').prop('disabled', true);
				$('.btn-down.template2').hide();
				
				$('.btn-down.template3').prop('disabled', true);
				$('.btn-down.template3').hide();
			} 
		}
	});

	//이력서 조회
	function getResumeDetail() {
		$.ajax({
			url: '/studio/resume/detail/main',
			type: 'get',
			dataType: 'json',
			success: function(response){
				var result = response.data;

				$('#infoCkResumeId').val(result.resumeId);
				$('#infoPopupResumeId').val(result.resumeId);
				$('#photoResumeId').val(result.resumeId);
				$('#selfResumeId').val(result.resumeId);
				$('#careerResumeId').val(result.resumeId);
				$('#eduResumeId').val(result.resumeId);
				$('#skillResumeId').val(result.resumeId);
				$('#proResumeId').val(result.resumeId);
				$('#langResumeId').val(result.resumeId);
				$('#skillCkResumeId').val(result.resumeId);
				$('input[name=portfolioName]').val(result.portfolioName);

				//템플릿 체크박스
				var resumeTemplateCode = result.resumeTemplateCode;

				if(resumeTemplateCode == '' || resumeTemplateCode == '1601') {
					$('#inputRadio1_1').prop("checked", true);
					$('input[name=resumeTemplateCode]').val('1601');
				} else if(resumeTemplateCode == '1602') {
					$('#inputRadio1_2').prop("checked", true);
					$('input[name=resumeTemplateCode]').val('1602');
				} else if(resumeTemplateCode == '1603') {
					$('#inputRadio1_3').prop("checked", true);
					$('input[name=resumeTemplateCode]').val('1603');
				}

				//정보노출 여부 체크박스
				var isPictureDisplay = result.isPictureDisplay;
				var isYearmonthdayDisplay = result.isYearmonthdayDisplay;
				var isSexDisplay = result.isSexDisplay;
				var isCountryDisplay = result.isCountryDisplay;
				var isAboutMeDisplay = result.isAboutMeDisplay;
				var isCareerDisplay = result.isCareerDisplay;
				var isEducationDisplay = result.isEducationDisplay;
				var isHaveSkillDisplay = result.isHaveSkillDisplay;
				var isProgramDisplay = result.isProgramDisplay;
				var isLangDisplay = result.isLangDisplay;
				var isQrPortfolioDisplay = result.isQrPortfolioDisplay;

				//사진 노출 여부
				if(isPictureDisplay == 'N') {
					$("#inputCheck1_1").prop("checked", true);
					$('input[name=isPictureDisplay]').val('N');
				} else {
					$("#inputCheck1_1").prop("checked", false);
					$('input[name=isPictureDisplay]').val('Y');
				}

				//년월일 노출 여부
				if(isYearmonthdayDisplay == 'N') {
					$("#inputCheck1_2").prop("checked", true);
					$('input[name=isYearmonthdayDisplay]').val('N');
				} else {
					$("#inputCheck1_2").prop("checked", false);
					$('input[name=isYearmonthdayDisplay]').val('Y');
				}

				//성별 노출 여부
				if(isSexDisplay == 'N') {
					$("#inputCheck1_3").prop("checked", true);
					$('input[name=isSexDisplay]').val('N');
				} else {
					$("#inputCheck1_3").prop("checked", false);
					$('input[name=isSexDisplay]').val('Y');
				}

				//국가 노출 여부
				if(isCountryDisplay == 'N') {
					$("#inputCheck1_4").prop("checked", true);
					$('input[name=isCountryDisplay]').val('N');
				} else {
					$("#inputCheck1_4").prop("checked", false);
					$('input[name=isCountryDisplay]').val('Y');
				}

				//자기소개 노출 여부
				if(isAboutMeDisplay == 'N') {
					$("#inputCheck2_1").prop("checked", true);
					$('input[name=isAboutMeDisplay]').val('N');
				} else {
					$("#inputCheck2_1").prop("checked", false);
					$('input[name=isAboutMeDisplay]').val('Y');
				}

				//경력 노출 여부
				if(isCareerDisplay == 'N') {
					$("#inputCheck2_2").prop("checked", true);
					$('input[name=isCareerDisplay]').val('N');
				} else {
					$("#inputCheck2_2").prop("checked", false);
					$('input[name=isCareerDisplay]').val('Y');
				}

				//교육 노출 여부
				if(isEducationDisplay == 'N') {
					$("#inputCheck2_3").prop("checked", true);
					$('input[name=isEducationDisplay]').val('N');
				} else {
					$("#inputCheck2_3").prop("checked", false);
					$('input[name=isEducationDisplay]').val('Y');
				}

				//보유스킬 노출 여부
				if(isHaveSkillDisplay == 'N') {
					$("#inputCheck2_4").prop("checked", true);
					$('input[name=isHaveSkillDisplay]').val('N');
				} else {
					$("#inputCheck2_4").prop("checked", false);
					$('input[name=isHaveSkillDisplay]').val('Y');
				}

				//프로그램 노출 여부
				if(isProgramDisplay == 'N') {
					$("#inputCheck2_5").prop("checked", true);
					$('input[name=isProgramDisplay]').val('N');
				} else {
					$("#inputCheck2_5").prop("checked", false);
					$('input[name=isProgramDisplay]').val('Y');
				}

				//언어 노출 여부
				if(isLangDisplay == 'N') {
					$("#inputCheck2_6").prop("checked", true);
					$('input[name=isLangDisplay]').val('N');
				} else {
					$("#inputCheck2_6").prop("checked", false);
					$('input[name=isLangDisplay]').val('Y');
				}

				//QR 포트폴리오 노출 여부
				if(isQrPortfolioDisplay == 'N') {
					$("#inputCheck2_7").prop("checked", true);
					$('input[name=isQrPortfolioDisplay]').val('N');
				} else {
					$("#inputCheck2_7").prop("checked", false);
					$('input[name=isQrPortfolioDisplay]').val('Y');
				}

				//프로필
				var photo = '';
				if(result.imagePath == '' || result.imagePath == null) {
					photo += '<img src="'+result.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
				} else {
					photo += '<img src="'+result.imagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
				}
				$('div.photo.mainpage').after(photo);

				var name = '<dd>'+result.name+' '+result.firstName+'</dd>';
				$('dt.mainpage.name').after(name);

				var birth = '<dd>'+result.day+'.'+result.month+'.'+result.year+'</dd>';
				$('dt.mainpage.birth').after(birth);

				var gender = '<dd>'+result.sex+'</dd>';
				$('dt.mainpage.gender').after(gender);

				var email = '<dd>'+result.email+'</dd>';
				$('dt.mainpage.email').after(email);

				var tell = '<dd>'+result.tell+'</dd>';
				$('dt.mainpage.tell').after(tell);

				var country = '';
				if(result.cityName == '' || result.cityName == null) {
					country += '<dd>'+result.countryName+'</dd>';
				} else {
					country += '<dd>'+result.countryName+'/'+result.cityName+'</dd>';
				}
				$('dt.mainpage.country').after(country);
				
				//자기소개
				var selfButton = '';
					selfButton += '<a href="javascript:;" class="btn btn-edit" onclick="modSelfPopup('+result.resumeId+')">edit</a>';
					selfButton += '<button type="button" class="btn btn-delete self" onclick="deleteSelf('+result.resumeId+');">delete</button>';
				$('div.info-ctrl.myself').append(selfButton);

				var myself = '';
				if(!result.selfIntroduction) {
					$('#selfBottom').after(myself);
				} else {
					myself += '<div id="selfDetail" class="info-area">';
					myself += '		<div class="box box-content">';
					myself += '			<p class="self" style="white-space: pre-line;">'+result.selfIntroduction+'</p>';
					myself += '		</div>';
					myself += '</div>';
					$('#selfBottom').after(myself);
				}

				//경력사항
				var careerList = result.careerList;
				var career = '';
				if(careerList.length != 0) {
					career += '<div id="careerList" class="info-area">';
					$.each(careerList, function(index, item) {
						if(item.isDelete != 'Y') {
							career += '<div class="box box-career">';
							career += '		<div class="check-item">';
							career += '			<input type="checkbox" id="inputCheck5_'+item.resumeCareerMattersId+'" name="isCareerDisplay" class="'+item.resumeCareerMattersId+'" onclick="isCareerCheck('+item.resumeCareerMattersId+');">';
							career += '			<label for="inputCheck5_'+item.resumeCareerMattersId+'"><spring:message code="resume.text8" text="Include" /></label>';
							career += '		</div>';
							if(item.isWork == 'N') {
								career += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
							} else {
								career += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+'</span>';
							}
							career += '		<span class="name">'+item.company+'</span>';
							career += '		<span class="position">'+item.position+'</span>';
							career += '		<div class="content jobContents">';
							career += '			<p style="white-space: pre-line;">'+item.jobContents+'</p>';
							career += '		</div>';
							career += '		<div class="info-ctrl">';
							career += '			<a href="javascript:;" class="btn btn-edit layer-career" onclick="modCareerPopup('+item.resumeCareerMattersId+');">edit</a>';
							career += '			<button type="button" class="btn btn-delete career" onclick="deleteCareer('+item.resumeCareerMattersId+');">delete</button>';
							career += '		</div>';
							career += '</div>';
						}
					});
					career += '</div>';
					$('#careerBottom').after(career);

					//이력서 경력 사항 포함여부 check 
					$.each(careerList, function(index, item) {
						if(item.isCareerDisplay == 'N') {
							$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", true);
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
						} else {
							$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", false);
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
						}
					});
				} else {
					$('#careerBottom').after(career);
				}

				//교육
				var educationList = result.educationList;
				var edu = '';
				if(educationList.length != 0) {
					edu += '<div id="educationList" class="info-area">';
					$.each(educationList, function(index, item) {
						if(item.isDelete != 'Y') {
							edu += '<div class="box box-career">';
							edu += '	<div class="check-item">';
							edu += '		<input type="checkbox" id="inputCheck6_'+item.resumeEducationId+'" name="isEducationDisplay" class="'+item.resumeEducationId+'" onclick="isEducationCheck('+item.resumeEducationId+');">';
							edu += '		<label for="inputCheck6_'+item.resumeEducationId+'"><spring:message code="resume.text8" text="Include" /></label>';
							edu += '	</div>';
							if(item.isWork == 'N') {
								edu += '<span class="date">'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
							} else {
								edu += '<span class="date">'+item.admissionMonth+'.'+item.admissionYear+'</span>';
							}
							edu += '	<span class="name">'+item.school+'</span>';
							edu += '	<span class="position">'+item.major+'</span>';
							edu += '	<div class="info-ctrl">';
							edu += '		<a href="javascript:;" class="btn btn-edit layer-education" onclick="modEducationPopup('+item.resumeEducationId+');">edit</a>';
							edu += '		<button type="button" class="btn btn-delete education" onclick="deleteEducation('+item.resumeEducationId+');">delete</button>';
							edu += '	</div>';
							edu += '</div>';
						}
					});
					edu += '</div>';
					$('#educationBottom').after(edu);

					//이력서 교육 포함여부 check 
					$.each(educationList, function(index, item) {
						if(item.isEducationDisplay == 'N') {
							$("#inputCheck6_"+item.resumeEducationId).prop("checked", true);
							$('input[name=isCareerDisplay].'+item.resumeEducationId).val('N');
						} else {
							$("#inputCheck6_"+item.resumeEducationId).prop("checked", false);
							$('input[name=isCareerDisplay].'+item.resumeEducationId).val('Y');
						}
					});
				} else {
					$('#educationBottom').after(edu);
				}

				//보유스킬
				var skillList = result.skillList;
				var skill = '';
				if(skillList.length != 0) {
					skill += '<div id="skillList" class="level-area">';
					$.each(skillList, function(index, item) {
						if(item.isDelete != 'Y') {
							skill += '<input type="hidden" class="skillCode '+item.resumeHaveSkillId+'" value="'+item.measureLevel+'">';
							skill += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
							skill += '<div class="box box-level skill '+item.resumeHaveSkillId+'">';
							skill += '	<div class="info-area">';
							skill += '		<div class="level-title">';
							skill += '			<span class="name">'+item.skillName+'</span>';
							skill += '			<span class="level skill '+item.resumeHaveSkillId+'">'+item.levelName+'</span>';
							skill += '		</div>';
							skill += '		<ul class="level-state skill">';
							skill += '			<li class="skill1 '+item.resumeHaveSkillId+'">Not Applicable</li>';
							skill += '			<li class="skill2 '+item.resumeHaveSkillId+'">Basic</li>';
							skill += '			<li class="skill3 '+item.resumeHaveSkillId+'">Intermediate</li>';
							skill += '			<li class="skill4 '+item.resumeHaveSkillId+'">Upper Intermediate</li>';
							skill += '			<li class="skill5 '+item.resumeHaveSkillId+'">Advanced</li>';
							skill += '		</ul>';
							skill += '	</div>';
							skill += '	<div class="info-ctrl">';
							skill += '		<a href="javascript:;" class="btn btn-edit layer-skill" onclick="modSkillPopup('+item.resumeHaveSkillId+');">edit</a>';
							skill += '		<button type="button" class="btn btn-delete skill" onclick="deleteSkill('+item.resumeHaveSkillId+');">delete</button>';
							skill += '	</div>';
							skill += '</div>';
						}
					});
					skill += '</div>';
					$('#skillBottom').after(skill);

					//이력서 보유 스킬 단계
					$.each(skillList, function(index, item) {
						$('div.box.box-level.skill.'+item.resumeHaveSkillId).ready(function() {
							var skillCode = $('.skillCode.'+item.resumeHaveSkillId).val();

							if(item.measureLevel == '1' && skillCode == '1') {
								$('.level.skill.'+item.resumeHaveSkillId).addClass('level1');
								$('.skill1.'+item.resumeHaveSkillId).addClass('on');
							} else if(item.measureLevel == '2' && skillCode == '2') {
								$('.level.skill.'+item.resumeHaveSkillId).addClass('level2');
								$('.skill2.'+item.resumeHaveSkillId).addClass('on');
							} else if(item.measureLevel == '3' && skillCode == '3') {
								$('.level.skill.'+item.resumeHaveSkillId).addClass('level3');
								$('.skill3.'+item.resumeHaveSkillId).addClass('on');
							} else if(item.measureLevel == '4' && skillCode == '4') {
								$('.level.skill.'+item.resumeHaveSkillId).addClass('level4');
								$('.skill4.'+item.resumeHaveSkillId).addClass('on');
							} else if(item.measureLevel == '5' && skillCode == '5') {
								$('.level.skill.'+item.resumeHaveSkillId).addClass('level5');
								$('.skill5.'+item.resumeHaveSkillId).addClass('on');
							} 
						});
					});
				} else {
					$('#skillBottom').after(skill);
				}

				//프로그램
				var programList = result.programList;
				var programingList = result.programingList;
				var program = '';
				if(programList.length != 0) {
					program += '<div id="programList" class="level-area">';
					$.each(programList, function(index, item) {
						if(item.isDelete != 'Y') {
							program += '<input type="hidden" class="programCode '+item.resumeProgramId+'" value="'+item.measureLevel+'">';
							program += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
							program += '<div class="box box-level program '+item.resumeProgramId+'">';
							program += '	<div class="info-area">';
							program += '		<div class="level-title">';
							if(item.programingId != '9999') {
								program += '		<span class="name">'+item.programingName+'</span>';
							} else {
								program += '		<span class="name">'+item.program+'</span>';
							}
							program += '			<span class="level program '+item.resumeProgramId+'">'+item.levelName+'</span>';
							program += '		</div>';
							program += '		<ul class="level-state program">';
							program += '			<li class="program1 '+item.resumeProgramId+'">Not Applicable</li>';
							program += '			<li class="program2 '+item.resumeProgramId+'">Basic</li>';
							program += '			<li class="program3 '+item.resumeProgramId+'">Intermediate</li>';
							program += '			<li class="program4 '+item.resumeProgramId+'">Upper Intermediate</li>';
							program += '			<li class="program5 '+item.resumeProgramId+'">Advanced</li>';
							program += '		</ul>';
							program += '	</div>';
							program += '	<div class="info-ctrl">';
							program += '		<a href="javascript:;" class="btn btn-edit layer-program" onclick="modProgramPopup('+item.resumeProgramId+');">edit</a>';
							program += '		<button type="button" class="btn btn-delete program" onclick="deleteProgram('+item.resumeProgramId+');">delete</button>';
							program += '	</div>';
							program += '</div>';
						}
					});
					program += '</div>';
					$('#programBottom').after(program);

					//이력서 프로그램 단계
					$.each(programList, function(index, item) {
						$('div.box.box-level.program.'+item.resumeProgramId).ready(function() {
							var programCode = $('.programCode.'+item.resumeProgramId).val();

							if(item.measureLevel == '1' && programCode == '1') {
								$('.level.program.'+item.resumeProgramId).addClass('level1');
								$('.program1.'+item.resumeProgramId).addClass('on');
							} else if(item.measureLevel == '2' && programCode == '2') {
								$('.level.program.'+item.resumeProgramId).addClass('level2');
								$('.program2.'+item.resumeProgramId).addClass('on');
							} else if(item.measureLevel == '3' && programCode == '3') {
								$('.level.program.'+item.resumeProgramId).addClass('level3');
								$('.program3.'+item.resumeProgramId).addClass('on');
							} else if(item.measureLevel == '4' && programCode == '4') {
								$('.level.program.'+item.resumeProgramId).addClass('level4');
								$('.program4.'+item.resumeProgramId).addClass('on');
							} else if(item.measureLevel == '5' && programCode == '5') {
								$('.level.program.'+item.resumeProgramId).addClass('level5');
								$('.program5.'+item.resumeProgramId).addClass('on');
							} 
						});
					});
				} else {
					$('#programBottom').after(program);
				}

				//프로그램 조회 popup
				var programing = '';
				$.each(programingList, function(index, item) {
					programing += '<li class="'+item.programingId+'" value="'+item.programingId+'" onclick="programingSelete(this);"><a href="javascript:;" onclick="textProgramingValue(this)">'+item.programingName+'</a></li>';
				});
				$('ul.dropdown-list.programingList').append(programing);

				//언어
				var langList = result.langList;
				var languageList = result.languageList;
				var lan = '';
				if(langList.length != 0) {
					lan += '<div id="langList" class="level-area">';
					$.each(langList, function(index, item) {
						if(item.isDelete != 'Y') {
							lan += '<input type="hidden" class="langCode '+item.resumeLangId+'" value="'+item.measureLevel+'">';
							lan += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
							lan += '<div class="box box-level lang '+item.resumeLangId+'">';
							lan += '	<div class="info-area">';
							lan += '		<div class="level-title">';
							if(item.langId != '9999') {
								lan += '		<span class="name">'+item.langName+'</span>';
							} else {
								lan += '		<span class="name">'+item.langTitle+'</span>';
							}
							lan += '			<span class="level lang '+item.resumeLangId+'">'+item.levelName+'</span>';
							lan += '		</div>';
							lan += '		<ul class="level-state lang">';
							lan += '			<li class="lang1 '+item.resumeLangId+'">Not Applicable</li>';
							lan += '			<li class="lang2 '+item.resumeLangId+'">Basic</li>';
							lan += '			<li class="lang3 '+item.resumeLangId+'">Intermediate</li>';
							lan += '			<li class="lang4 '+item.resumeLangId+'">Upper Intermediate</li>';
							lan += '			<li class="lang5 '+item.resumeLangId+'">Advanced</li>';
							lan += '		</ul>';
							lan += '	</div>';
							lan += '	<div class="info-ctrl">';
							lan += '		<a href="javascript:;" class="btn btn-edit layer-language" onclick="modLanguagePopup('+item.resumeLangId+');">edit</a>';
							lan += '		<button type="button" class="btn btn-delete language" onclick="deleteLang('+item.resumeLangId+');">delete</button>';
							lan += '	</div>';
							lan += '</div>';
						}
					});
					lan += '</div>';
					$('#langBottom').after(lan);

					//이력서 언어 단계
					$.each(langList, function(index, item) {
						$('div.box.box-level.lang.'+item.resumeLangId).ready(function() {
							var langCode = $('.langCode.'+item.resumeLangId).val();

							if(item.measureLevel == '1' && langCode == '1') {
								$('.level.lang.'+item.resumeLangId).addClass('level1');
								$('.lang1.'+item.resumeLangId).addClass('on');
							} else if(item.measureLevel == '2' && langCode == '2') {
								$('.level.lang.'+item.resumeLangId).addClass('level2');
								$('.lang2.'+item.resumeLangId).addClass('on');
							} else if(item.measureLevel == '3' && langCode == '3') {
								$('.level.lang.'+item.resumeLangId).addClass('level3');
								$('.lang3.'+item.resumeLangId).addClass('on');
							} else if(item.measureLevel == '4' && langCode == '4') {
								$('.level.lang.'+item.resumeLangId).addClass('level4');
								$('.lang4.'+item.resumeLangId).addClass('on');
							} else if(item.measureLevel == '5' && langCode == '5') {
								$('.level.lang.'+item.resumeLangId).addClass('level5');
								$('.lang5.'+item.resumeLangId).addClass('on');
							} 
						});
					});
				} else {
					$('#langBottom').after(lan);
				}

				//언어 조회 popup
				var language = '';
				$.each(languageList, function(index, item) {
					language += '<li class="lang '+item.langId+'" value="'+item.langId+'" onclick="languageSelete(this);"><a href="javascript:;" onclick="textLanguageValue(this)">'+item.langName+'</a></li>';
				});
				$('ul.dropdown-list.languageList').append(language);

				//qr 포트폴리오	
				var portfolioList = result.portfolioList;
				var qr = '';
				if(portfolioList.length != 0) {
					qr += '<dl class="dropdown-select portfolio">';
					qr += '		<dt><a href="javascript:;" class="btn portfolio"><spring:message code="resume.portfolio2" text="selectbox" /></a></dt>';
					qr += '		<dd style="bottom: -210px;">';
					qr += '			<div class="dimed"></div>';
					qr += '			<div class="dropdown-inner custom-scroll" style="height: 210px;">';
					qr += '				<span class="dropdown-title"><spring:message code="resume.portfolio2" text="selectbox title" /></span>';
					qr += '				<ul class="dropdown-list">';
					$.each(portfolioList, function(index, item) {
						qr += '				<li value="'+item.portfolioId+'" data-qr="'+item.name+'" onclick="portfolioSelete(this);"><a href="javascript:;" onclick="textPortfolioValue(this);">'+item.name+'</a></li>';
					});
					qr += '				</ul>';
					qr += '			</div>';
					qr += '		</dd>';
					qr += '</dl>';

					$('#portfolioBottom').after(qr);

					//이력서 포트폴리오
					var portfolioName = $('input[name=portfolioName]').val();
					var newPortfolioName = portfolioName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');

					if(newPortfolioName != '') {
						$('dl.dropdown-select.portfolio').addClass('on');
						$('a.btn.portfolio').text(newPortfolioName);
					}
				} else {
					qr += '<dl class="dropdown-select portfolio disabled">';
					qr += '		<dt><a href="javascript:;" class="btn portfolio"><spring:message code="resume.portfolio2" text="selectbox" /></a></dt>';
					qr += '		<dd style="bottom: -210px;">';
					qr += '			<div class="dimed"></div>';
					qr += '			<div class="dropdown-inner custom-scroll" style="height: 210px;">';
					qr += '				<span class="dropdown-title"><spring:message code="resume.portfolio2" text="selectbox title" /></span>';
					qr += '			</div>';
					qr += '		</dd>';
					qr += '</dl>';

					$('#portfolioBottom').after(qr);
				}
				
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//프로필 이미지 업로드
	function uploadFile() {
     	var fileVal = $("#lb_upload").val();
     	fileVal = fileVal.slice(fileVal.indexOf(".")+1).toLowerCase();
     	if(fileVal != "jpg" && fileVal != "png" && fileVal != "jpeg" && fileVal != "gif" && fileVal != "bmp") {
     		alert('<spring:message code="resume.text14" text="이미지 파일만 등록 가능합니다." />'); 
         } else {
        	 $.ajax({
          	    url: "/studio/resume/imgUpload",
          	    type: "POST",
          	    data: new FormData($("#img_upload")[0]),
          	    enctype: 'multipart/form-data',
          	    processData: false,
          	    contentType: false,
          	    cache: false,
          	    success: function (response) {
     				if(response.code == "SUCCESS"){
     					location.href = '/studio/resume/detail';
     				}else{
     					alert(response.message);
     				}
          	    },
          	    error: function () {
          	      // Handle upload error
          	      // ...
          	    }
          	  });
         }
     }

	//경력 사항 포함 여부
	function isCareerCheck(id) {
		if($('#inputCheck5_'+id).is(':checked') == false) {
			$('input[name=isCareerDisplay].'+id).val('Y');
		} else {
			$('input[name=isCareerDisplay].'+id).val('N');
		}

		var resumeCareerMattersId = id;
		var isCareerDisplay = $('input[name=isCareerDisplay].'+id).val();

		var data = {
			resumeCareerMattersId : resumeCareerMattersId,
			isCareerDisplay : isCareerDisplay
		};

		$.ajax({
			url: '/studio/resume/isCareer',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == true){					
					console.log("seccess");
				}else{
					alert(response.message);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//교육 포함 여부
	function isEducationCheck(id) {
		if($('#inputCheck6_'+id).is(':checked') == false) {
			$('input[name=isEducationDisplay].'+id).val('Y');
		} else {
			$('input[name=isEducationDisplay].'+id).val('N');
		}

		var resumeEducationId = id;
		var isEducationDisplay = $('input[name=isEducationDisplay].'+id).val();

		var data = {
			resumeEducationId : resumeEducationId,
			isEducationDisplay : isEducationDisplay
		};

		$.ajax({
			url: '/studio/resume/isEducation',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == true){					
					console.log("seccess");
				}else{
					alert(response.message);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//입사년도 value
	function textJoinYearValue(value) {
		var str = $(value).text();

		$('input[name=joinYear]').val(str);
		$('a.btn.joinYear').text(str);
	}

	//퇴사년도 value
	function textLeaveYearValue(value) {
		var str = $(value).text();

		$('input[name=leaveYear]').val(str);
		$('a.btn.leaveYear').text(str);
	}

	//입사월 value
	function textJoinMonthValue(value) {
		var str = $(value).text();

		$('input[name=joinMonth]').val(str);
		$('a.btn.joinMonth').text(str);
	}

	//퇴사월 value
	function textLeaveMonthValue(value) {
		var str = $(value).text();

		$('input[name=leaveMonth]').val(str);
		$('a.btn.leaveMonth').text(str);
	}

	//입학연도 value
	function textAdmissionYearValue(value) {
		var str = $(value).text();

		$('input[name=admissionYear]').val(str);
		$('a.btn.admissionYear').text(str);
	}

	//졸업연도 value
	function textGraduatedYearValue(value) {
		var str = $(value).text();

		$('input[name=graduatedYear]').val(str);
		$('a.btn.graduatedYear').text(str);
	}

	//입학월 value
	function textAdmissionMonthValue(value) {
		var str = $(value).text();

		$('input[name=admissionMonth]').val(str);
		$('a.btn.admissionMonth').text(str);
	}

	//졸업월 value
	function textGraduatedMonthValue(value) {
		var str = $(value).text();

		$('input[name=graduatedMonth]').val(str);
		$('a.btn.graduatedMonth').text(str);
	}

	//프로그래밍 제목 value
	function textProgramingValue(value) {
		var str = $(value).text();

		$('input[name=programingNameEng').val(str);
		$('a.btn.programingNameEng').text(str);
	}

	//언어 제목 value
	function textLanguageValue(value) {
		var str = $(value).text();

		$('input[name=langNameEng').val(str);
		$('a.btn.langNameEng').text(str);
	}

	//포트폴리오 제목 value
	function textPortfolioValue(value) {
		var str = $(value).text();
		$('a.btn.portfolio').text(str);
	}

	//정보 노출 check
	function isInfoCheck() {
		//사진 노출 여부
		if($('#inputCheck1_1').is(':checked') == false) {
			$('input[name=isPictureDisplay]').val('Y');
		} else {
			$('input[name=isPictureDisplay]').val('N');
		}

		//년월일 노출 여부
		if($('#inputCheck1_2').is(':checked') == false) {
			$('input[name=isYearmonthdayDisplay]').val('Y');
		} else {
			$('input[name=isYearmonthdayDisplay]').val('N');
		}

		//성별 노출 여부
		if($('#inputCheck1_3').is(':checked') == false) {
			$('input[name=isSexDisplay]').val('Y');
		} else {
			$('input[name=isSexDisplay]').val('N');
		}

		//국가 노출 여부
		if($('#inputCheck1_4').is(':checked') == false) {
			$('input[name=isCountryDisplay]').val('Y');
		} else {
			$('input[name=isCountryDisplay]').val('N');
		}

		//자기소개 노출 여부
		if($('#inputCheck2_1').is(':checked') == false) {
			$('input[name=isAboutMeDisplay]').val('Y');
		} else {
			$('input[name=isAboutMeDisplay]').val('N');
		}

		//경력 노출 여부
		if($('#inputCheck2_2').is(':checked') == false) {
			$('input[name=isCareerDisplay]').val('Y');
		} else {
			$('input[name=isCareerDisplay]').val('N');
		}

		//교육 노출 여부
		if($('#inputCheck2_3').is(':checked') == false) {
			$('input[name=isEducationDisplay]').val('Y');
		} else {
			$('input[name=isEducationDisplay]').val('N');
		}

		//보유 스킬 노출 여부
		if($('#inputCheck2_4').is(':checked') == false) {
			$('input[name=isHaveSkillDisplay]').val('Y');
		} else {
			$('input[name=isHaveSkillDisplay]').val('N');
		}

		//프로그램 노출 여부
		if($('#inputCheck2_5').is(':checked') == false) {
			$('input[name=isProgramDisplay]').val('Y');
		} else {
			$('input[name=isProgramDisplay]').val('N');
		}

		//언어 노출 여부
		if($('#inputCheck2_6').is(':checked') == false) {
			$('input[name=isLangDisplay]').val('Y');
		} else {
			$('input[name=isLangDisplay]').val('N');
		}

		//QR 포트폴리오 노출 여부
		if($('#inputCheck2_7').is(':checked') == false) {
			$('input[name=isQrPortfolioDisplay]').val('Y');
		} else {
			$('input[name=isQrPortfolioDisplay]').val('N');
		}

		var resumeId = $('#infoCkResumeId').val();
		var isPictureDisplay = $('input[name=isPictureDisplay]').val();
		var isYearmonthdayDisplay = $('input[name=isYearmonthdayDisplay]').val();
		var isSexDisplay = $('input[name=isSexDisplay]').val();
		var isCountryDisplay = $('input[name=isCountryDisplay]').val();
		var isAboutMeDisplay = $('input[name=isAboutMeDisplay]').val();
		var isCareerDisplay = $('input[name=isCareerDisplay]').val();
		var isEducationDisplay = $('input[name=isEducationDisplay]').val();
		var isHaveSkillDisplay = $('input[name=isHaveSkillDisplay]').val();
		var isProgramDisplay = $('input[name=isProgramDisplay]').val();
		var isLangDisplay = $('input[name=isLangDisplay]').val();
		var isQrPortfolioDisplay = $('input[name=isQrPortfolioDisplay]').val();

		var data = {
			resumeId : resumeId,
			isPictureDisplay : isPictureDisplay,
			isYearmonthdayDisplay : isYearmonthdayDisplay,
			isSexDisplay : isSexDisplay,
			isCountryDisplay : isCountryDisplay,
			isAboutMeDisplay : isAboutMeDisplay,
			isCareerDisplay : isCareerDisplay,
			isEducationDisplay : isEducationDisplay,
			isHaveSkillDisplay : isHaveSkillDisplay,
			isProgramDisplay : isProgramDisplay,
			isLangDisplay : isLangDisplay,
			isQrPortfolioDisplay : isQrPortfolioDisplay
		};

		$.ajax({
			url: '/studio/resume/infoEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == true){					
					console.log("seccess");
				}else{
					alert(response.message);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//정보 노출 check(모바일 버전)
	function isInfoPopCk() {
		
		//사진 노출 여부
		if($('#inputCheck3_1').is(':checked') == false) {
			$('input[name=isPictureDisplay].expose').val('Y');
		} else {
			$('input[name=isPictureDisplay].expose').val('N');
		}

		//년월일 노출 여부
		if($('#inputCheck3_2').is(':checked') == false) {
			$('input[name=isYearmonthdayDisplay].expose').val('Y');
		} else {
			$('input[name=isYearmonthdayDisplay].expose').val('N');
		}

		//성별 노출 여부
		if($('#inputCheck3_3').is(':checked') == false) {
			$('input[name=isSexDisplay].expose').val('Y');
		} else {
			$('input[name=isSexDisplay].expose').val('N');
		}

		//국가 노출 여부
		if($('#inputCheck3_4').is(':checked') == false) {
			$('input[name=isCountryDisplay].expose').val('Y');
		} else {
			$('input[name=isCountryDisplay].expose').val('N');
		}

		//자기소개 노출 여부
		if($('#inputCheck4_1').is(':checked') == false) {
			$('input[name=isAboutMeDisplay].expose').val('Y');
		} else {
			$('input[name=isAboutMeDisplay].expose').val('N');
		}

		//경력 노출 여부
		if($('#inputCheck4_2').is(':checked') == false) {
			$('input[name=isCareerDisplay].expose').val('Y');
		} else {
			$('input[name=isCareerDisplay].expose').val('N');
		}

		//교육 노출 여부
		if($('#inputCheck4_3').is(':checked') == false) {
			$('input[name=isEducationDisplay].expose').val('Y');
		} else {
			$('input[name=isEducationDisplay].expose').val('N');
		}

		//보유 스킬 노출 여부
		if($('#inputCheck4_4').is(':checked') == false) {
			$('input[name=isHaveSkillDisplay].expose').val('Y');
		} else {
			$('input[name=isHaveSkillDisplay].expose').val('N');
		}

		//프로그램 노출 여부
		if($('#inputCheck4_5').is(':checked') == false) {
			$('input[name=isProgramDisplay].expose').val('Y');
		} else {
			$('input[name=isProgramDisplay].expose').val('N');
		}

		//언어 노출 여부
		if($('#inputCheck4_6').is(':checked') == false) {
			$('input[name=isLangDisplay].expose').val('Y');
		} else {
			$('input[name=isLangDisplay].expose').val('N');
		}

		//QR 포트폴리오 노출 여부
		if($('#inputCheck4_7').is(':checked') == false) {
			$('input[name=isQrPortfolioDisplay].expose').val('Y');
		} else {
			$('input[name=isQrPortfolioDisplay].expose').val('N');
		}
	}

	//템플릿 check
	function isTemplateCk() {
		if($('#inputRadio1_1').is(':checked') == true) {
			$('input[name=resumeTemplateCode]').val('1601');
		} else if($('#inputRadio1_2').is(':checked') == true) {
			$('input[name=resumeTemplateCode]').val('1602');
		} else if($('#inputRadio1_3').is(':checked') == true) {
			$('input[name=resumeTemplateCode]').val('1603');
		}

		var resumeId = $('#infoCkResumeId').val();
		var resumeTemplateCode = $('input[name=resumeTemplateCode]').val();

		var data = {
			resumeId : resumeId,
			resumeTemplateCode : resumeTemplateCode
		};

		$.ajax({
			url: '/studio/resume/templateEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == true){					
					console.log("seccess");
				}else{
					alert(response.message);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//현재 근무중 check
	function isWorkCheck() {
		if($('#inputCheck3').is(':checked') == true) {
			$('#inputCheck3').val('Y');
			//월 비활성화
			$('a.btn.leaveMonth').bind('click', false);
			$('a.btn.leaveMonth').css('cursor', 'default');
			$('a.btn.leaveMonth').css('background-color', '#eeeeee');
			//연도 비활성화
			$('a.btn.leaveYear').bind('click', false);
			$('a.btn.leaveYear').css('cursor', 'default');
			$('a.btn.leaveYear').css('background-color', '#eeeeee');
		} else {
			$('#inputCheck3').val('N');
			//월 활성화
			$('a.btn.leaveMonth').unbind('click', false);
			$('a.btn.leaveMonth').css('cursor', 'pointer');
			$('a.btn.leaveMonth').css('background-color', '#fff');
			//연도 활성화
			$('a.btn.leaveYear').unbind('click', false);
			$('a.btn.leaveYear').css('cursor', 'pointer');
			$('a.btn.leaveYear').css('background-color', '#fff');
		}

		if($('#inputCheck4').is(':checked') == true) {
			$('#inputCheck4').val('Y');
			//월 비활성화
			$('a.btn.graduatedMonth').bind('click', false);
			$('a.btn.graduatedMonth').css('cursor', 'default');
			$('a.btn.graduatedMonth').css('background-color', '#eeeeee');
			//연도 비활성화
			$('a.btn.graduatedYear').bind('click', false);
			$('a.btn.graduatedYear').css('cursor', 'default');
			$('a.btn.graduatedYear').css('background-color', '#eeeeee');
		} else {
			$('#inputCheck4').val('N');
			//월 활성화
			$('a.btn.graduatedMonth').unbind('click', false);
			$('a.btn.graduatedMonth').css('cursor', 'pointer');
			$('a.btn.graduatedMonth').css('background-color', '#fff');
			//연도 활성화
			$('a.btn.graduatedYear').unbind('click', false);
			$('a.btn.graduatedYear').css('cursor', 'pointer');
			$('a.btn.graduatedYear').css('background-color', '#fff');
		}
	}

	//자기소개 수정
	function selfEditForm() {
		var resumeId = $('input[name=resumeId]').val();
		var selfIntroduction = $('textarea[name=selfIntroduction]').val();
		var data = {
			resumeId : resumeId,
			selfIntroduction :selfIntroduction 
		};

		$.ajax({
			url: '/studio/resume/selfEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response) {
				var result = response.data;
				closeModal('#layer-self');
			//	alert('등록이 완료되었습니다.');
				var self = $('p.self').text();
				var html = '';
				if(self != '') {
					html += '<div class="box box-content">';
					html += '	<p class="self" style="white-space: pre-line;">'+result.selfIntroduction+'</p>';
					html += '</div>';
					$('#selfDetail').html(html);
				} else {
					html += '<div id="selfDetail" class="info-area">';
					html += '	<div class="box box-content">';
					html += '		<p class="self" style="white-space: pre-line;">'+result.selfIntroduction+'</p>';
					html += '	</div>';
					html += '</div>';
					$('#selfBottom').after(html);
				}
			},
			error: function(xhr, status) {
				console.log(xhr + ' : ' + status);
			}
		});
	}

	//자기소개 등록 및 수정 modal
	function modSelfPopup(id) {
		$('textarea[name=selfIntroduction]').val(''); //팝업 띄울 때 초기화

		var self = $('p.self').text();

		if(self != '') {
			$.ajax({
				url: '/studio/resume/selfEditView?resumeId='+id,
				type: 'get',
				data: id,
				dataType: 'json',
				success: function(response) {
					var result = response.data;
					var intro = result.selfIntroduction;
					var newIntro = intro.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
					$('input[name=resumeId]').val(result.resumeId);
					$('textarea[name=selfIntroduction]').val(newIntro);
				},
				error: function(xhr, status) {
					console.log(xhr + ' : ' + status);
				}
			});
		}
		if(self != '') {
			$('#editSelfBtn').prop('disabled', false);
		} else {
			$('#editSelfBtn').prop('disabled', true); //처음 버튼 비활성화
		}
		
		openModal('#layer-self');

		//필수값 체크
		$('textarea[name=selfIntroduction]').on('propertychange change keyup paste input', processkey);

		function processkey() {
			var selfIntroduction = $('textarea[name=selfIntroduction]').val();

			if(selfIntroduction == '') {
				$('#editSelfBtn').prop('disabled', true);
			} else {
				$('#editSelfBtn').prop('disabled', false);
			}
		}

		//byte수 체크
		$('textarea[name=selfIntroduction]').on('input', {maxByte : 2000}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//자기소개 삭제
	function deleteSelf(id) {
		var data = {resumeId : id};

		if(confirm('<spring:message code="resume.alert.delete" text="삭제 하시겠습니까?" />') == true) {
			$.ajax({
				url: '/studio/resume/selfDelete',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var result = response.data;
					if(result == true){					
						$('#selfDetail').remove();
					}else{
						alert(response.message);
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			return false;
		}
	}

	//이력서 경력 사항 등록
	function careerCreateForm() {
		var resumeId = $('input[name=resumeId]').val();
		var company = $('input[name=company]').val();
		var position = $('input[name=position]').val();
		var isWork = $('#inputCheck3').val();
		var joinYear = $('input[name=joinYear]').val();
		var joinMonth = $('input[name=joinMonth]').val();
		var leaveYear = $('input[name=leaveYear]').val();
		var leaveMonth = $('input[name=leaveMonth]').val();
		var jobContents = $('textarea[name=jobContents]').val();
		var data = {
			resumeId : resumeId,
			company : company,
			position : position,
			isWork : isWork,
			joinYear : joinYear,
			joinMonth : joinMonth,
			leaveYear : leaveYear,
			leaveMonth : leaveMonth,
			jobContents : jobContents
		}; 

		$.ajax({
			url: '/studio/resume/careerCreate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-career');
			//	alert('등록이 완료되었습니다.');
				if(resultList.length == 1) {
					var htmlAdd = '<div id="careerList" class="info-area"></div>';
					$('#careerBottom').after(htmlAdd);
				}
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<div class="box box-career">';
						html += '	<div class="check-item">';
						html += '		<input type="checkbox" id="inputCheck5_'+item.resumeCareerMattersId+'" name="isCareerDisplay" class="'+item.resumeCareerMattersId+'" onclick="isCareerCheck('+item.resumeCareerMattersId+');">';
						html += '		<label for="inputCheck5_'+item.resumeCareerMattersId+'"><spring:message code="resume.text8" text="Include" /></label>';
						html += '	</div>';
						if(item.isWork == 'N') {
							html += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
						} else {
							html += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+'</span>';
						}
						html += '	<span class="name">'+item.company+'</span>';
						html += '	<span class="position">'+item.position+'</span>';
						html += '	<div class="content jobContents">';
						html += '		<p style="white-space: pre-line;">'+item.jobContents+'</p>';
						html += '	</div>';
						html += '	<div class="info-ctrl">';
						html += '		<a href="javascript:;" class="btn btn-edit layer-career" onclick="modCareerPopup('+item.resumeCareerMattersId+');">edit</a>';
						html += '		<button type="button" class="btn btn-delete career" onclick="deleteCareer('+item.resumeCareerMattersId+');">delete</button>';
						html += '	</div>';
						html += '</div>';
					}
					$("#inputCheck5_"+item.resumeCareerMattersId).ready(function() {
						if(item.isCareerDisplay == 'N') {
							$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", true);
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
						} else {
							$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", false);
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
						}
					});

					$(document).on('click', '#inputCheck5_'+item.resumeCareerMattersId, function() {
						if($("#inputCheck5_"+item.resumeCareerMattersId).is(':checked') == false) {
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
						} else {
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
						}

						var resumeCareerMattersId = item.resumeCareerMattersId;
						var isCareerDisplay = $('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val();

						var data = {
							resumeCareerMattersId : resumeCareerMattersId,
							isCareerDisplay : isCareerDisplay
						};

						$.ajax({
							url: '/studio/resume/isCareer',
							type: 'post',
							data: data,
							dataType: 'json',
							success: function(response){
								var result = response.data;
								if(result == true){					
									console.log("seccess");
								}else{
									alert(response.message);
								}
							},
							error : function(xhr, status) {
					               console.log(xhr + " : " + status);
					         }
						});
					});
					return true;
				});
				$('#careerList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 경력 사항 수정
	function careerEditForm() {
		var resumeId = $('input[name=resumeId]').val();
		var resumeCareerMattersId = $('input[name=resumeCareerMattersId]').val();
		var company = $('input[name=company]').val();
		var position = $('input[name=position]').val();
		var isWork = $('#inputCheck3').val();
		var joinYear = $('input[name=joinYear]').val();
		var joinMonth = $('input[name=joinMonth]').val();
		var leaveYear = $('input[name=leaveYear]').val();
		var leaveMonth = $('input[name=leaveMonth]').val();
		var jobContents = $('textarea[name=jobContents]').val();
		var data = {
			resumeId : resumeId,
			resumeCareerMattersId : resumeCareerMattersId,
			company : company,
			position : position,
			isWork : isWork,
			joinYear : joinYear,
			joinMonth : joinMonth,
			leaveYear : leaveYear,
			leaveMonth : leaveMonth,
			jobContents : jobContents
		}; 

		$.ajax({
			url: '/studio/resume/careerEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-career');
			//	alert('수정이 완료되었습니다.');
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<div class="box box-career">';
						html += '	<div class="check-item">';
						html += '		<input type="checkbox" id="inputCheck5_'+item.resumeCareerMattersId+'" name="isCareerDisplay" class="'+item.resumeCareerMattersId+'" onclick="isCareerCheck('+item.resumeCareerMattersId+');">';
						html += '		<label for="inputCheck5_'+item.resumeCareerMattersId+'"><spring:message code="resume.text8" text="Include" /></label>';
						html += '	</div>';
						if(item.isWork == 'N') {
							html += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
						} else {
							html += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+'</span>';
						}
						html += '	<span class="name">'+item.company+'</span>';
						html += '	<span class="position">'+item.position+'</span>';
						html += '	<div class="content jobContents">';
						html += '		<p style="white-space: pre-line;">'+item.jobContents+'</p>';
						html += '	</div>';
						html += '	<div class="info-ctrl">';
						html += '		<a href="javascript:;" class="btn btn-edit layer-career" onclick="modCareerPopup('+item.resumeCareerMattersId+');">edit</a>';
						html += '		<button type="button" class="btn btn-delete career" onclick="deleteCareer('+item.resumeCareerMattersId+');">delete</button>';
						html += '	</div>';
						html += '</div>';
					}
					$("#inputCheck5_"+item.resumeCareerMattersId).ready(function() {
						if(item.isCareerDisplay == 'N') {
							$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", true);
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
						} else {
							$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", false);
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
						}
					});

					$(document).on('click', '#inputCheck5_'+item.resumeCareerMattersId, function() {
						if($("#inputCheck5_"+item.resumeCareerMattersId).is(':checked') == false) {
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
						} else {
							$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
						}

						var resumeCareerMattersId = item.resumeCareerMattersId;
						var isCareerDisplay = $('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val();

						var data = {
							resumeCareerMattersId : resumeCareerMattersId,
							isCareerDisplay : isCareerDisplay
						};

						$.ajax({
							url: '/studio/resume/isCareer',
							type: 'post',
							data: data,
							dataType: 'json',
							success: function(response){
								var result = response.data;
								if(result == true){					
									console.log("seccess");
								}else{
									alert(response.message);
								}
							},
							error : function(xhr, status) {
					               console.log(xhr + " : " + status);
					         }
						});
					});
					return true;
				});
				$('#careerList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 경력 사항 삭제
	function deleteCareer(id) {
		var resumeId = $('input[name=resumeId]').val();
		var data = {
			resumeCareerMattersId : id,
			resumeId : resumeId
		};
		if(confirm('<spring:message code="resume.alert.delete" text="삭제 하시겠습니까?" />') == true) {
			$.ajax({
				url: '/studio/resume/careerDelete',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var resultList = response.data;
				//	alert('삭제가 완료되었습니다.');
					var html = '';
					if(resultList.length != 0) {
						$.each(resultList, function(index, item) {
							if(item.isDelete != 'Y') {
								html += '<div class="box box-career">';
								html += '	<div class="check-item">';
								html += '		<input type="checkbox" id="inputCheck5_'+item.resumeCareerMattersId+'" name="isCareerDisplay" class="'+item.resumeCareerMattersId+'" onclick="isCareerCheck('+item.resumeCareerMattersId+');">';
								html += '		<label for="inputCheck5_'+item.resumeCareerMattersId+'"><spring:message code="resume.text8" text="Include" /></label>';
								html += '	</div>';
								if(item.isWork == 'N') {
									html += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
								} else {
									html += '	<span class="date">'+item.joinMonth+'.'+item.joinYear+'</span>';
								}
								html += '	<span class="name">'+item.company+'</span>';
								html += '	<span class="position">'+item.position+'</span>';
								html += '	<div class="content jobContents">';
								html += '		<p style="white-space: pre-line;">'+item.jobContents+'</p>';
								html += '	</div>';
								html += '	<div class="info-ctrl">';
								html += '		<a href="javascript:;" class="btn btn-edit layer-career" onclick="modCareerPopup('+item.resumeCareerMattersId+');">edit</a>';
								html += '		<button type="button" class="btn btn-delete career" onclick="deleteCareer('+item.resumeCareerMattersId+');">delete</button>';
								html += '	</div>';
								html += '</div>';
							}
							$("#inputCheck5_"+item.resumeCareerMattersId).ready(function() {
								if(item.isCareerDisplay == 'N') {
									$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", true);
									$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
								} else {
									$("#inputCheck5_"+item.resumeCareerMattersId).prop("checked", false);
									$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
								}
							});

							$(document).on('click', '#inputCheck5_'+item.resumeCareerMattersId, function() {
								if($("#inputCheck5_"+item.resumeCareerMattersId).is(':checked') == false) {
									$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('Y');
								} else {
									$('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val('N');
								}

								var resumeCareerMattersId = item.resumeCareerMattersId;
								var isCareerDisplay = $('input[name=isCareerDisplay].'+item.resumeCareerMattersId).val();

								var data = {
									resumeCareerMattersId : resumeCareerMattersId,
									isCareerDisplay : isCareerDisplay
								};

								$.ajax({
									url: '/studio/resume/isCareer',
									type: 'post',
									data: data,
									dataType: 'json',
									success: function(response){
										var result = response.data;
										if(result == true){					
											console.log("seccess");
										}else{
											alert(response.message);
										}
									},
									error : function(xhr, status) {
							               console.log(xhr + " : " + status);
							         }
								});
							});
							return true;
						});
						$('#careerList').html(html);
					} else if (resultList.length == 0){
						$('div').remove('#careerList.info-area');
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			return false;
		}
	}

	//경력 사항 modal 리셋
	function resetCareer() {
		$('input[name=resumeCareerMattersId]').val('');
		$('input[name=company]').val('');
		$('input[name=position]').val('');
		$('textarea[name=jobContents]').val('');
		$('#inputCheck3').val('N');
		$('input[name=joinYear]').val('');
		$('input[name=joinMonth]').val('');
		$('input[name=leaveYear]').val('');
		$('input[name=leaveMonth]').val('');

		$('#inputCheck3').prop('checked', false);
		
		$('dl.dropdown-select.career').removeClass('on');
		$('a.btn.joinYear').text('<spring:message code="resume.text10" text="Año" />');
		$('a.btn.joinMonth').text('<spring:message code="resume.text11" text="Mes" />');
		$('a.btn.leaveYear').text('<spring:message code="resume.text10" text="Año" />');
		$('a.btn.leaveMonth').text('<spring:message code="resume.text11" text="Mes" />');

		//월 활성화
		$('a.btn.leaveMonth').unbind('click', false);
		$('a.btn.leaveMonth').css('cursor', 'pointer');
		$('a.btn.leaveMonth').css('background-color', '#fff');
		//연도 활성화
		$('a.btn.leaveYear').unbind('click', false);
		$('a.btn.leaveYear').css('cursor', 'pointer');
		$('a.btn.leaveYear').css('background-color', '#fff');
	}

	//경력 사항 등록 modal
	function regCareerPopup() {
		$('#createCareerBtn').prop('disabled', true); //처음 버튼 비활성화
		$('#createCareerBtn').show();
		$('#editCareerBtn').prop('disabled', true);
		$('#editCareerBtn').hide();
		resetCareer();
		openModal('#layer-career');

		//필수값 체크
		$('input[name=company]').on('propertychange change keyup paste input', processkey);
		$('input[name=position]').on('propertychange change keyup paste input', processkey);
		$('li.joinYear').on('propertychange change keyup paste input click', processkey);
		$('li.joinMonth').on('propertychange change keyup paste input click', processkey);
		$('li.leaveYear').on('propertychange change keyup paste input click', processkey);
		$('li.leaveMonth').on('propertychange change keyup paste input click', processkey);
		$('#inputCheck3').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var company = $('input[name=company]').val();
			var position = $('input[name=position]').val();
			var joinYear = $('input[name=joinYear]').val();
			var joinMonth = $('input[name=joinMonth]').val();
			var leaveYear = $('input[name=leaveYear]').val();
			var leaveMonth = $('input[name=leaveMonth]').val();
			var isWork = $('#inputCheck3').val();
			
			if(isWork == 'N') {
				if(company == '' || position == '' || joinYear == '' || joinMonth == '' || leaveYear == '' || leaveMonth == '') {
					$('#createCareerBtn').prop('disabled', true);
				} else {
					$('#createCareerBtn').prop('disabled', false);
				}
			} else {
				if(company == '' || position == '' || joinYear == '' || joinMonth == '') {
					$('#createCareerBtn').prop('disabled', true);
				} else {
					$('#createCareerBtn').prop('disabled', false);
				}
			}
		}

		//byte수 체크
		$('input[name=company]').on('input', {maxByte : 100}, strByteCheck);
		$('input[name=position]').on('input', {maxByte : 100}, strByteCheck);
		$('textarea[name=jobContents]').on('input', {maxByte : 2000}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//경력 사항 수정  modal
	function modCareerPopup(id) {
		$('#createCareerBtn').prop('disabled', true);
		$('#createCareerBtn').hide();
		$('#editCareerBtn').prop('disabled', false);
		$('#editCareerBtn').show();
		resetCareer();
		
		$.ajax({
			url: '/studio/resume/careerEditView?resumeCareerMattersId='+id,
			type: 'get',
			data: id,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				
				$('input[name=resumeCareerMattersId]').val(result.resumeCareerMattersId);
				var reCompany = result.company;
				var newCompany = reCompany.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=company]').val(newCompany);
				var rePosition = result.position;
				var newPosition = rePosition.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=position]').val(newPosition);
				var reContents = result.jobContents;
				var newContents = reContents.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('textarea[name=jobContents]').val(newContents);
				$('#inputCheck3').val(result.isWork);
				$('input[name=joinYear]').val(result.joinYear);
				$('input[name=joinMonth]').val(result.joinMonth);
				$('input[name=leaveYear]').val(result.leaveYear);
				$('input[name=leaveMonth]').val(result.leaveMonth);

				var isWork = $('#inputCheck3').val();
				if(isWork == 'Y') {
					$('#inputCheck3').prop('checked', true);
					//월 비활성화
					$('a.btn.leaveMonth').bind('click', false);
					$('a.btn.leaveMonth').css('cursor', 'default');
					$('a.btn.leaveMonth').css('background-color', '#eeeeee');
					//연도 비활성화
					$('a.btn.leaveYear').bind('click', false);
					$('a.btn.leaveYear').css('cursor', 'default');
					$('a.btn.leaveYear').css('background-color', '#eeeeee');
				} else {
					$('#inputCheck3').prop('checked', false);
					//월 활성화
					$('a.btn.leaveMonth').unbind('click', false);
					$('a.btn.leaveMonth').css('cursor', 'pointer');
					$('a.btn.leaveMonth').css('background-color', '#fff');
					//연도 활성화
					$('a.btn.leaveYear').unbind('click', false);
					$('a.btn.leaveYear').css('cursor', 'pointer');
					$('a.btn.leaveYear').css('background-color', '#fff');
				}

				if(result.leaveYear == '0' || result.leaveMonth == '0') {
					$('dl.dropdown-select.always').addClass('on');
				} else {
					$('dl.dropdown-select').addClass('on');
				}
				var joinYear = $('input[name=joinYear]').val();
				var joinMonth = $('input[name=joinMonth]').val();
				if(result.leaveYear == '0' || result.leaveYear == '') {
					var leaveYear = '<spring:message code="resume.text10" text="Año" />';
				} else {
					var leaveYear = $('input[name=leaveYear]').val();
				}
				if(result.leaveMonth == '0' || result.leaveMonth == '') {
					var leaveMonth = '<spring:message code="resume.text11" text="Mes" />';
				} else {
					var leaveMonth = $('input[name=leaveMonth]').val();
				}

				$('a.btn.joinYear').text(joinYear);
				$('a.btn.joinMonth').text(joinMonth);
				$('a.btn.leaveYear').text(leaveYear);
				$('a.btn.leaveMonth').text(leaveMonth);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
		
		openModal('#layer-career');

		//필수값 체크
		$('input[name=company]').on('propertychange change keyup paste input', processkey);
		$('input[name=position]').on('propertychange change keyup paste input', processkey);
		$('li.joinYear').on('propertychange change keyup paste input click', processkey);
		$('li.joinMonth').on('propertychange change keyup paste input click', processkey);
		$('li.leaveYear').on('propertychange change keyup paste input click', processkey);
		$('li.leaveMonth').on('propertychange change keyup paste input click', processkey);
		$('#inputCheck3').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var company = $('input[name=company]').val();
			var position = $('input[name=position]').val();
			var joinYear = $('input[name=joinYear]').val();
			var joinMonth = $('input[name=joinMonth]').val();
			var leaveYear = $('input[name=leaveYear]').val();
			var leaveMonth = $('input[name=leaveMonth]').val();
			var isWork = $('#inputCheck3').val();
			
			if(isWork == 'N') {
				if(company == '' || position == '' || joinYear == '' || joinMonth == '' || leaveYear == '0' || leaveMonth == '0') {
					$('#editCareerBtn').prop('disabled', true);
				} else {
					$('#editCareerBtn').prop('disabled', false);
				}
			} else {
				if(company == '' || position == '' || joinYear == '' || joinMonth == '') {
					$('#editCareerBtn').prop('disabled', true);
				} else {
					$('#editCareerBtn').prop('disabled', false);
				}
			}
		}

		//byte수 체크
		$('input[name=company]').on('input', {maxByte : 100}, strByteCheck);
		$('input[name=position]').on('input', {maxByte : 100}, strByteCheck);
		$('textarea[name=jobContents]').on('input', {maxByte : 2000}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++;
				}
				if(reByte <= maxByte) {
					reLen = i + 1; //영어일 때
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//이력서 교육 등록
	function educationCreateForm() {
		var resumeId = $('input[name=resumeId]').val();
		var school = $('input[name=school]').val();
		var major = $('input[name=major]').val();
		var isWork = $('#inputCheck4').val();
		var admissionYear = $('input[name=admissionYear]').val();
		var admissionMonth = $('input[name=admissionMonth]').val();
		var graduatedYear = $('input[name=graduatedYear]').val();
		var graduatedMonth = $('input[name=graduatedMonth]').val();
		var data = {
			resumeId : resumeId,
			school : school,
			major : major,
			isWork : isWork,
			admissionYear : admissionYear,
			admissionMonth : admissionMonth,
			graduatedYear : graduatedYear,
			graduatedMonth : graduatedMonth
		}; 

		$.ajax({
			url: '/studio/resume/educationCreate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-education');
			//	alert('등록이 완료되었습니다.');
				if(resultList.length == 1) {
					var htmlAdd = '<div id="educationList" class="info-area"></div>';
					$('#educationBottom').after(htmlAdd);
				}
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<div class="box box-career">';
						html += '	<div class="check-item">';
						html += '		<input type="checkbox" id="inputCheck6_'+item.resumeEducationId+'" name="isEducationDisplay" class="'+item.resumeEducationId+'" onclick="isEducationCheck('+item.resumeEducationId+');">';
						html += '		<label for="inputCheck6_'+item.resumeEducationId+'"><spring:message code="resume.text8" text="Include" /></label>';
						html += '	</div>';
						if(item.isWork == 'N') {
							html += '	<span class="date">'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
						} else {
							html += '	<span class="date">'+item.admissionMonth+'.'+item.admissionYear+'</span>';
						}
						html += '	<span class="name">'+item.school+'</span>';
						html += '	<span class="position">'+item.major+'</span>';
						html += '	<div class="info-ctrl">';
						html += '		<a href="javascript:;" class="btn btn-edit layer-education" onclick="modEducationPopup('+item.resumeEducationId+');">edit</a>';
						html += '		<button typ="button" class="btn btn-delete education" onclick="deleteEducation('+item.resumeEducationId+');">delete</button>';
						html += '	</div>';
						html += '</div>';
					}
					$("#inputCheck6_"+item.resumeEducationId).ready(function() {
						if(item.isEducationDisplay == 'N') {
							$("#inputCheck6_"+item.resumeEducationId).prop("checked", true);
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('N');
						} else {
							$("#inputCheck6_"+item.resumeEducationId).prop("checked", false);
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('Y');
						}
					});

					$(document).on('click', '#inputCheck6_'+item.resumeEducationId, function() {
						if($("#inputCheck6_"+item.resumeEducationId).is(':checked') == false) {
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('Y');
						} else {
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('N');
						}

						var resumeEducationId = item.resumeEducationId;
						var isEducationDisplay = $('input[name=isEducationDisplay].'+item.resumeEducationId).val();

						var data = {
							resumeEducationId : resumeEducationId,
							isEducationDisplay : isEducationDisplay
						};

						$.ajax({
							url: '/studio/resume/isEducation',
							type: 'post',
							data: data,
							dataType: 'json',
							success: function(response){
								var result = response.data;
								if(result == true){					
									console.log("seccess");
								}else{
									alert(response.message);
								}
							},
							error : function(xhr, status) {
					               console.log(xhr + " : " + status);
					         }
						});
					});
					return true;
				});
				$('#educationList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 교육 수정
	function educationEditForm() {
		var resumeId = $('input[name=resumeId]').val();
		var resumeEducationId = $('input[name=resumeEducationId]').val();
		var school = $('input[name=school]').val();
		var major = $('input[name=major]').val();
		var isWork = $('#inputCheck4').val();
		var admissionYear = $('input[name=admissionYear]').val();
		var admissionMonth = $('input[name=admissionMonth]').val();
		var graduatedYear = $('input[name=graduatedYear]').val();
		var graduatedMonth = $('input[name=graduatedMonth]').val();
		var data = {
			resumeId : resumeId,
			resumeEducationId : resumeEducationId,
			school : school,
			major : major,
			isWork : isWork,
			admissionYear : admissionYear,
			admissionMonth : admissionMonth,
			graduatedYear : graduatedYear,
			graduatedMonth : graduatedMonth
		};

		$.ajax({
			url: '/studio/resume/educationEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-education');
			//	alert('수정이 완료되었습니다.');
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<div class="box box-career">';
						html += '	<div class="check-item">';
						html += '		<input type="checkbox" id="inputCheck6_'+item.resumeEducationId+'" name="isEducationDisplay" class="'+item.resumeEducationId+'" onclick="isEducationCheck('+item.resumeEducationId+');">';
						html += '		<label for="inputCheck6_'+item.resumeEducationId+'"><spring:message code="resume.text8" text="Include" /></label>';
						html += '	</div>';
						if(item.isWork == 'N') {
							html += '	<span class="date">'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
						} else {
							html += '	<span class="date">'+item.admissionMonth+'.'+item.admissionYear+'</span>';
						}
						html += '	<span class="name">'+item.school+'</span>';
						html += '	<span class="position">'+item.major+'</span>';
						html += '	<div class="info-ctrl">';
						html += '		<a href="javascript:;" class="btn btn-edit layer-education" onclick="modEducationPopup('+item.resumeEducationId+');">edit</a>';
						html += '		<button typ="button" class="btn btn-delete education" onclick="deleteEducation('+item.resumeEducationId+');">delete</button>';
						html += '	</div>';
						html += '</div>';
					}
					$("#inputCheck6_"+item.resumeEducationId).ready(function() {
						if(item.isEducationDisplay == 'N') {
							$("#inputCheck6_"+item.resumeEducationId).prop("checked", true);
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('N');
						} else {
							$("#inputCheck6_"+item.resumeEducationId).prop("checked", false);
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('Y');
						}
					});

					$(document).on('click', '#inputCheck6_'+item.resumeEducationId, function() {
						if($("#inputCheck6_"+item.resumeEducationId).is(':checked') == false) {
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('Y');
						} else {
							$('input[name=isEducationDisplay].'+item.resumeEducationId).val('N');
						}

						var resumeEducationId = item.resumeEducationId;
						var isEducationDisplay = $('input[name=isEducationDisplay].'+item.resumeEducationId).val();

						var data = {
							resumeEducationId : resumeEducationId,
							isEducationDisplay : isEducationDisplay
						};

						$.ajax({
							url: '/studio/resume/isEducation',
							type: 'post',
							data: data,
							dataType: 'json',
							success: function(response){
								var result = response.data;
								if(result == true){					
									console.log("seccess");
								}else{
									alert(response.message);
								}
							},
							error : function(xhr, status) {
					               console.log(xhr + " : " + status);
					         }
						});
					});
					return true;
				});
				$('#educationList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 교육 삭제
	function deleteEducation(id) {
		var resumeId = $('input[name=resumeId]').val();
		var data = {
			resumeId : resumeId,
			resumeEducationId : id
		};
		if(confirm('<spring:message code="resume.alert.delete" text="삭제 하시겠습니까?" />') == true) {
			$.ajax({
				url: '/studio/resume/educationDelete',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var resultList = response.data;
					var html = '';
					if(resultList.length != 0) {
						$.each(resultList, function(index, item) {
							if(item.isDelete != 'Y') {
								html += '<div class="box box-career">';
								html += '	<div class="check-item">';
								html += '		<input type="checkbox" id="inputCheck6_'+item.resumeEducationId+'" name="isEducationDisplay" class="'+item.resumeEducationId+'" onclick="isEducationCheck('+item.resumeEducationId+');">';
								html += '		<label for="inputCheck6_'+item.resumeEducationId+'"><spring:message code="resume.text8" text="Include" /></label>';
								html += '	</div>';
								if(item.isWork == 'N') {
									html += '	<span class="date">'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
								} else {
									html += '	<span class="date">'+item.admissionMonth+'.'+item.admissionYear+'</span>';
								}
								html += '	<span class="name">'+item.school+'</span>';
								html += '	<span class="position">'+item.major+'</span>';
								html += '	<div class="info-ctrl">';
								html += '		<a href="javascript:;" class="btn btn-edit layer-education" onclick="modEducationPopup('+item.resumeEducationId+');">edit</a>';
								html += '		<button typ="button" class="btn btn-delete education" onclick="deleteEducation('+item.resumeEducationId+');">delete</button>';
								html += '	</div>';
								html += '</div>';
							}
							$("#inputCheck6_"+item.resumeEducationId).ready(function() {
								if(item.isEducationDisplay == 'N') {
									$("#inputCheck6_"+item.resumeEducationId).prop("checked", true);
									$('input[name=isEducationDisplay].'+item.resumeEducationId).val('N');
								} else {
									$("#inputCheck6_"+item.resumeEducationId).prop("checked", false);
									$('input[name=isEducationDisplay].'+item.resumeEducationId).val('Y');
								}
							});

							$(document).on('click', '#inputCheck6_'+item.resumeEducationId, function() {
								if($("#inputCheck6_"+item.resumeEducationId).is(':checked') == false) {
									$('input[name=isEducationDisplay].'+item.resumeEducationId).val('Y');
								} else {
									$('input[name=isEducationDisplay].'+item.resumeEducationId).val('N');
								}

								var resumeEducationId = item.resumeEducationId;
								var isEducationDisplay = $('input[name=isEducationDisplay].'+item.resumeEducationId).val();

								var data = {
									resumeEducationId : resumeEducationId,
									isEducationDisplay : isEducationDisplay
								};

								$.ajax({
									url: '/studio/resume/isEducation',
									type: 'post',
									data: data,
									dataType: 'json',
									success: function(response){
										var result = response.data;
										if(result == true){					
											console.log("seccess");
										}else{
											alert(response.message);
										}
									},
									error : function(xhr, status) {
							               console.log(xhr + " : " + status);
							         }
								});
							});
							return true;
						});
						$('#educationList').html(html);
					} else if (resultList.length == 0){
						$('div').remove('#educationList.info-area');
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			return false;
		}
	}

	//교육 modal 리셋
	function resetEducation() {
		$('input[name=resumeEducationId]').val('');
		$('input[name=school]').val('');
		$('input[name=major]').val('');
		$('#inputCheck4').val('N');
		$('input[name=admissionYear]').val('');
		$('input[name=admissionMonth]').val('');
		$('input[name=graduatedYear]').val('');
		$('input[name=graduatedMonth]').val('');

		$('#inputCheck4').prop('checked', false);
		
		$('dl.dropdown-select.up').removeClass('on');
		$('a.btn.admissionYear').text('<spring:message code="resume.text10" text="Año" />');
		$('a.btn.admissionMonth').text('<spring:message code="resume.text11" text="Mes" />');
		$('a.btn.graduatedYear').text('<spring:message code="resume.text10" text="Año" />');
		$('a.btn.graduatedMonth').text('<spring:message code="resume.text11" text="Mes" />');

		//월 활성화
		$('a.btn.graduatedMonth').unbind('click', false);
		$('a.btn.graduatedMonth').css('cursor', 'pointer');
		$('a.btn.graduatedMonth').css('background-color', '#fff');
		//연도 활성화
		$('a.btn.graduatedYear').unbind('click', false);
		$('a.btn.graduatedYear').css('cursor', 'pointer');
		$('a.btn.graduatedYear').css('background-color', '#fff');
	}

	//교육 등록 modal
	function regEducationPopup() {
		$('#createEducationBtn').prop('disabled', true); //처음 버튼 비활성화
		$('#createEducationBtn').show();
		$('#editEducationBtn').prop('disabled', true);
		$('#editEducationBtn').hide();
		resetEducation();
		openModal('#layer-education');

		//필수값 체크
		$('input[name=school]').on('propertychange change keyup paste input', processkey);
		$('input[name=major]').on('propertychange change keyup paste input', processkey);
		$('li.admissionYear').on('propertychange change keyup paste input click', processkey);
		$('li.admissionMonth').on('propertychange change keyup paste input click', processkey);
		$('li.graduatedYear').on('propertychange change keyup paste input click', processkey);
		$('li.graduatedMonth').on('propertychange change keyup paste input click', processkey);
		$('#inputCheck4').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var school = $('input[name=school]').val();
			var major = $('input[name=major]').val();
			var admissionYear = $('input[name=admissionYear]').val();
			var admissionMonth = $('input[name=admissionMonth]').val();
			var graduatedYear = $('input[name=graduatedYear]').val();
			var graduatedMonth = $('input[name=graduatedMonth]').val();
			var isWork = $('#inputCheck4').val();

			if(isWork == 'N') {
				if(school == '' || major == '' || admissionYear == '' || admissionMonth == '' || graduatedYear == '' || graduatedMonth == '') {
					$('#createEducationBtn').prop('disabled', true);
				} else {
					$('#createEducationBtn').prop('disabled', false);
				}
			} else {
				if(school == '' || major == '' || admissionYear == '' || admissionMonth == '') {
					$('#createEducationBtn').prop('disabled', true);
				} else {
					$('#createEducationBtn').prop('disabled', false);
				}
			}
			
		}

		//byte수 체크
		$('input[name=school]').on('input', {maxByte : 100}, strByteCheck);
		$('input[name=major]').on('input', {maxByte : 100}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//교육 수정  modal
	function modEducationPopup(id) {
		$('#createEducationBtn').prop('disabled', true);
		$('#createEducationBtn').hide();
		$('#editEducationBtn').prop('disabled', false);
		$('#editEducationBtn').show();
		resetEducation();
		
		$.ajax({
			url: '/studio/resume/educationEditView?resumeEducationId='+id,
			type: 'get',
			data: id,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				
				$('input[name=resumeEducationId]').val(result.resumeEducationId);
				var reSchool = result.school;
				var newSchool = reSchool.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=school]').val(newSchool);
				var reMajor = result.major;
				var newMajor = reMajor.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=major]').val(newMajor);
				$('#inputCheck4').val(result.isWork);
				$('input[name=admissionYear]').val(result.admissionYear);
				$('input[name=admissionMonth]').val(result.admissionMonth);
				$('input[name=graduatedYear]').val(result.graduatedYear);
				$('input[name=graduatedMonth]').val(result.graduatedMonth);
				
				var isWork = $('#inputCheck4').val();
				if(isWork == 'Y') {
					$('#inputCheck4').prop('checked', true);
					//월 비활성화
					$('a.btn.graduatedMonth').bind('click', false);
					$('a.btn.graduatedMonth').css('cursor', 'default');
					$('a.btn.graduatedMonth').css('background-color', '#eeeeee');
					//연도 비활성화
					$('a.btn.graduatedYear').bind('click', false);
					$('a.btn.graduatedYear').css('cursor', 'default');
					$('a.btn.graduatedYear').css('background-color', '#eeeeee');
				} else {
					$('#inputCheck4').prop('checked', false);
					//월 활성화
					$('a.btn.graduatedMonth').unbind('click', false);
					$('a.btn.graduatedMonth').css('cursor', 'pointer');
					$('a.btn.graduatedMonth').css('background-color', '#fff');
					//연도 활성화
					$('a.btn.graduatedYear').unbind('click', false);
					$('a.btn.graduatedYear').css('cursor', 'pointer');
					$('a.btn.graduatedYear').css('background-color', '#fff');
				}

				if(result.graduatedYear == '0' || result.graduatedMonth == '0') {
					$('dl.dropdown-select.always').addClass('on');
				} else {
					$('dl.dropdown-select').addClass('on');
				}
				var admissionYear = $('input[name=admissionYear]').val();
				var admissionMonth = $('input[name=admissionMonth]').val();
				if(result.graduatedYear == '0' || result.graduatedYear == '') {
					var graduatedYear = '<spring:message code="resume.text10" text="Año" />';
				} else {
					var graduatedYear = $('input[name=graduatedYear]').val();
				}
				if(result.graduatedMonth == '0' || result.graduatedMonth == '') {
					var graduatedMonth = '<spring:message code="resume.text11" text="Mes" />';
				} else {
					var graduatedMonth = $('input[name=graduatedMonth]').val();
				}
				

				$('a.btn.admissionYear').text(admissionYear);
				$('a.btn.admissionMonth').text(admissionMonth);
				$('a.btn.graduatedYear').text(graduatedYear);
				$('a.btn.graduatedMonth').text(graduatedMonth);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
		
		openModal('#layer-education');

		//필수값 체크
		$('input[name=school]').on('propertychange change keyup paste input', processkey);
		$('input[name=major]').on('propertychange change keyup paste input', processkey);
		$('li.admissionYear').on('propertychange change keyup paste input click', processkey);
		$('li.admissionMonth').on('propertychange change keyup paste input click', processkey);
		$('li.graduatedYear').on('propertychange change keyup paste input click', processkey);
		$('li.graduatedMonth').on('propertychange change keyup paste input click', processkey);
		$('#inputCheck4').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var school = $('input[name=school]').val();
			var major = $('input[name=major]').val();
			var admissionYear = $('input[name=admissionYear]').val();
			var admissionMonth = $('input[name=admissionMonth]').val();
			var graduatedYear = $('input[name=graduatedYear]').val();
			var graduatedMonth = $('input[name=graduatedMonth]').val();
			var isWork = $('#inputCheck4').val();

			if(isWork == 'N') {
				if(school == '' || major == '' || admissionYear == '' || admissionMonth == '' || graduatedYear == '0' || graduatedMonth == '0') {
					$('#editEducationBtn').prop('disabled', true);
				} else {
					$('#editEducationBtn').prop('disabled', false);
				}
			} else {
				if(school == '' || major == '' || admissionYear == '' || admissionMonth == '') {
					$('#editEducationBtn').prop('disabled', true);
				} else {
					$('#editEducationBtn').prop('disabled', false);
				}
			}
			
		}

		//byte수 체크
		$('input[name=school]').on('input', {maxByte : 100}, strByteCheck);
		$('input[name=major]').on('input', {maxByte : 100}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//이력서 스킬 등록
	function skillCreateForm() {
		var resumeId = $('input[name=resumeId]').val();
		var skillName = $('input[name=skillName]').val();
		var measureTypeCode = $('input[name=measureTypeCode].skill').val();
		var measureLevel = $('input[name=measureLevel].skill:checked').val();
		var data = {
			resumeId : resumeId,
			skillName : skillName,
			measureTypeCode : measureTypeCode,
			measureLevel : measureLevel
		}; 

		$.ajax({
			url: '/studio/resume/skillCreate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-skills');
				if(resultList.length == 1) {
					var htmlAdd = '<div id="skillList" class="level-area"></div>';
					$('#skillBottom').after(htmlAdd);
				}
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<input type="hidden" class="skillCode '+item.resumeHaveSkillId+'" value="'+item.measureLevel+'">';
						html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
						html += '	<div class="box box-level skill '+item.resumeHaveSkillId+'">';
						html += '		<div class="info-area">';
						html += '			<div class="level-title">';
						html += '				<span class="name">'+item.skillName+'</span>';
						html += '				<span class="level skill '+item.resumeHaveSkillId+'">'+item.levelName+'</span>';
						html += '			</div>';
						html += '			<ul class="level-state skill">';
						html += '				<li class="skill1 '+item.resumeHaveSkillId+'">Not Applicable</li>';
						html += '				<li class="skill2 '+item.resumeHaveSkillId+'">Basic</li>';
						html += '				<li class="skill3 '+item.resumeHaveSkillId+'">Intermediate</li>';
						html += '				<li class="skill4 '+item.resumeHaveSkillId+'">Upper Intermediate</li>';
						html += '				<li class="skill5 '+item.resumeHaveSkillId+'">Advanced</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '		<div class="info-ctrl">';
						html += '			<a href="javascript:;" class="btn btn-edit layer-skill" onclick="modSkillPopup('+item.resumeHaveSkillId+');">edit</a>';
						html += '			<button type="button" class="btn btn-delete skill" onclick="deleteSkill('+item.resumeHaveSkillId+');">delete</button>';
						html += '		</div>';
						html += '	</div>';
					}
					$('div.box.box-level.skill.'+item.resumeHaveSkillId).ready(function() {
						var skillCode = $('.skillCode.'+item.resumeHaveSkillId).val();

						if(item.measureLevel == '1' && skillCode == '1') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level1');
							$('.skill1.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '2' && skillCode == '2') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level2');
							$('.skill2.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '3' && skillCode == '3') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level3');
							$('.skill3.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '4' && skillCode == '4') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level4');
							$('.skill4.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '5' && skillCode == '5') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level5');
							$('.skill5.'+item.resumeHaveSkillId).addClass('on'); 
						} 
					});
					return true;
				});
				$('#skillList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 스킬 수정
	function skillEditForm() {
		var resumeId = $('input[name=resumeId]').val();
		var resumeHaveSkillId = $('input[name=resumeHaveSkillId]').val();
		var skillName = $('input[name=skillName]').val();
		var measureTypeCode = $('input[name=measureTypeCode].skill').val();
		var measureLevel = $('input[name=measureLevel].skill:checked').val();
		var data = {
			resumeId : resumeId,
			resumeHaveSkillId : resumeHaveSkillId,
			skillName : skillName,
			measureTypeCode : measureTypeCode,
			measureLevel : measureLevel
		}; 

		$.ajax({
			url: '/studio/resume/skillEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-skills');
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<input type="hidden" class="skillCode '+item.resumeHaveSkillId+'" value="'+item.measureLevel+'">';
						html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
						html += '	<div class="box box-level skill '+item.resumeHaveSkillId+'">';
						html += '		<div class="info-area">';
						html += '			<div class="level-title">';
						html += '				<span class="name">'+item.skillName+'</span>';
						html += '				<span class="level skill '+item.resumeHaveSkillId+'">'+item.levelName+'</span>';
						html += '			</div>';
						html += '			<ul class="level-state skill">';
						html += '				<li class="skill1 '+item.resumeHaveSkillId+'">Not Applicable</li>';
						html += '				<li class="skill2 '+item.resumeHaveSkillId+'">Basic</li>';
						html += '				<li class="skill3 '+item.resumeHaveSkillId+'">Intermediate</li>';
						html += '				<li class="skill4 '+item.resumeHaveSkillId+'">Upper Intermediate</li>';
						html += '				<li class="skill5 '+item.resumeHaveSkillId+'">Advanced</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '		<div class="info-ctrl">';
						html += '			<a href="javascript:;" class="btn btn-edit layer-skill" onclick="modSkillPopup('+item.resumeHaveSkillId+');">edit</a>';
						html += '			<button type="button" class="btn btn-delete skill" onclick="deleteSkill('+item.resumeHaveSkillId+');">delete</button>';
						html += '		</div>';
						html += '	</div>';
					}
					$('div.box.box-level.skill.'+item.resumeHaveSkillId).ready(function() {
						var skillCode = $('.skillCode.'+item.resumeHaveSkillId).val();

						if(item.measureLevel == '1' && skillCode == '1') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level1');
							$('.skill1.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '2' && skillCode == '2') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level2');
							$('.skill2.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '3' && skillCode == '3') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level3');
							$('.skill3.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '4' && skillCode == '4') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level4');
							$('.skill4.'+item.resumeHaveSkillId).addClass('on');
						} else if(item.measureLevel == '5' && skillCode == '5') {
							$('.level.skill.'+item.resumeHaveSkillId).addClass('level5');
							$('.skill5.'+item.resumeHaveSkillId).addClass('on'); 
						} 
					});
					return true;
				});
				$('#skillList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 스킬 삭제
	function deleteSkill(id) {
		var resumeId = $('input[name=resumeId]').val();
		var data = {
			resumeId : resumeId,
			resumeHaveSkillId : id
		};
		if(confirm('<spring:message code="resume.alert.delete" text="삭제 하시겠습니까?" />') == true) {
			$.ajax({
				url: '/studio/resume/skillDelete',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var resultList = response.data;
					var html = '';
					if(resultList.length != 0) {
						$.each(resultList, function(index, item) {
							if(item.isDelete != 'Y') {
								html += '<input type="hidden" class="skillCode '+item.resumeHaveSkillId+'" value="'+item.measureLevel+'">';
								html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
								html += '	<div class="box box-level skill '+item.resumeHaveSkillId+'">';
								html += '		<div class="info-area">';
								html += '			<div class="level-title">';
								html += '				<span class="name">'+item.skillName+'</span>';
								html += '				<span class="level skill '+item.resumeHaveSkillId+'">'+item.levelName+'</span>';
								html += '			</div>';
								html += '			<ul class="level-state skill">';
								html += '				<li class="skill1 '+item.resumeHaveSkillId+'">Not Applicable</li>';
								html += '				<li class="skill2 '+item.resumeHaveSkillId+'">Basic</li>';
								html += '				<li class="skill3 '+item.resumeHaveSkillId+'">Intermediate</li>';
								html += '				<li class="skill4 '+item.resumeHaveSkillId+'">Upper Intermediate</li>';
								html += '				<li class="skill5 '+item.resumeHaveSkillId+'">Advanced</li>';
								html += '			</ul>';
								html += '		</div>';
								html += '		<div class="info-ctrl">';
								html += '			<a href="javascript:;" class="btn btn-edit layer-skill" onclick="modSkillPopup('+item.resumeHaveSkillId+');">edit</a>';
								html += '			<button type="button" class="btn btn-delete skill" onclick="deleteSkill('+item.resumeHaveSkillId+');">delete</button>';
								html += '		</div>';
								html += '	</div>';
							}
							$('div.box.box-level.skill.'+item.resumeHaveSkillId).ready(function() {
								var skillCode = $('.skillCode.'+item.resumeHaveSkillId).val();

								if(item.measureLevel == '1' && skillCode == '1') {
									$('.level.skill.'+item.resumeHaveSkillId).addClass('level1');
									$('.skill1.'+item.resumeHaveSkillId).addClass('on');
								} else if(item.measureLevel == '2' && skillCode == '2') {
									$('.level.skill.'+item.resumeHaveSkillId).addClass('level2');
									$('.skill2.'+item.resumeHaveSkillId).addClass('on');
								} else if(item.measureLevel == '3' && skillCode == '3') {
									$('.level.skill.'+item.resumeHaveSkillId).addClass('level3');
									$('.skill3.'+item.resumeHaveSkillId).addClass('on');
								} else if(item.measureLevel == '4' && skillCode == '4') {
									$('.level.skill.'+item.resumeHaveSkillId).addClass('level4');
									$('.skill4.'+item.resumeHaveSkillId).addClass('on');
								} else if(item.measureLevel == '5' && skillCode == '5') {
									$('.level.skill.'+item.resumeHaveSkillId).addClass('level5');
									$('.skill5.'+item.resumeHaveSkillId).addClass('on'); 
								} 
							});
							return true;
						});
						$('#skillList').html(html);
					} else if (resultList.length == 0){
						$('div').remove('#skillList.level-area');
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			return false;
		}
	}

	//스킬 제한 check
	function skillCheck(id) {
		var resumeId = $('#skillCkResumeId').val();

		$.ajax({
			url: '/studio/resume/skillCk',
			type: 'post',
			data: {resumeId : resumeId},
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result < 10){					
					console.log('seccess');
					regSkillPopup();
				}else if(result >= 10){
					alert('<spring:message code="resume.alert.have-skill" text="최대 10개의 스킬을 등록할 수 있습니다." />');
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
		
	}

	//스킬 modal 리셋
	function resetSkill() {
		$('input[name=resumeHaveSkillId]').val('');
		$('input[name=skillName]').val('');
		$('input[name=measureLevel].skill').val('');

		$('input[type=radio].skill').prop('checked', false);
	}

	//스킬 등록 modal
	function regSkillPopup() {
		$('#createSkillBtn').prop('disabled', true); //처음 버튼 비활성화
		$('#createSkillBtn').show();
		$('#editSkillBtn').prop('disabled', true);
		$('#editSkillBtn').hide();
		resetSkill();
		openModal('#layer-skills');
		$('input[type=radio].skill').click(function() {
			$('#inputLevel1_1').val('1');
			$('#inputLevel1_2').val('2');
			$('#inputLevel1_3').val('3');
			$('#inputLevel1_4').val('4');
			$('#inputLevel1_5').val('5');
			var value = $('input[name=measureLevel].skill:checked').val();
		});

		//필수값 체크
		$('input[name=skillName]').on('propertychange change keyup paste input', processkey);
		$('input[type=radio].skill').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var skillName = $('input[name=skillName]').val();
			var measureLevel = $('input[type=radio].skill:checked').val();

			if(skillName == '' || measureLevel == undefined) {
				$('#createSkillBtn').prop('disabled', true);
			} else {
				$('#createSkillBtn').prop('disabled', false);
			}
		}

		//byte수 체크
		$('input[name=skillName]').on('input', {maxByte : 100}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//스킬 수정  modal
	function modSkillPopup(id) {
		$('#createSkillBtn').prop('disabled', true);
		$('#createSkillBtn').hide();
		$('#editSkillBtn').prop('disabled', false);
		$('#editSkillBtn').show();
		resetSkill();
		
		$.ajax({
			url: '/studio/resume/skillEditView?resumeHaveSkillId='+id,
			type: 'get',
			data: id,
			dataType: 'json',
			success: function(response){
				var result = response.data;

				$('input[name=resumeHaveSkillId]').val(result.resumeHaveSkillId);
				var reSkillName = result.skillName;
				var newSkillName = reSkillName.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=skillName]').val(newSkillName);
				$('input[name=measureTypeCode].skill').val(result.measureTypeCode);
				$('input[name=measureLevel].skill').val(result.measureLevel);
				
				var skillCode = $('input[name=measureLevel].skill').val();
				if(skillCode == '1') {
					$('#inputLevel1_1').prop('checked', true);
				} else if(skillCode == '2'){
					$('#inputLevel1_2').prop('checked', true);
				} else if(skillCode == '3'){
					$('#inputLevel1_3').prop('checked', true);
				} else if(skillCode == '4'){
					$('#inputLevel1_4').prop('checked', true);
				} else if(skillCode == '5'){
					$('#inputLevel1_5').prop('checked', true);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});

		openModal('#layer-skills');
		$('input[type=radio].skill').click(function() {
			$('#inputLevel1_1').val('1');
			$('#inputLevel1_2').val('2');
			$('#inputLevel1_3').val('3');
			$('#inputLevel1_4').val('4');
			$('#inputLevel1_5').val('5');
			var value = $('input[name=measureLevel].skill:checked').val();
		});

		//필수값 체크
		$('input[name=skillName]').on('propertychange change keyup paste input', processkey);
		$('input[type=radio].skill').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var skillName = $('input[name=skillName]').val();
			var measureLevel = $('input[type=radio].skill:checked').val();

			if(skillName == '' || measureLevel == undefined) {
				$('#editSkillBtn').prop('disabled', true);
			} else {
				$('#editSkillBtn').prop('disabled', false);
			}
		}

		//byte수 체크
		$('input[name=skillName]').on('input', {maxByte : 100}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//이력서 프로그램 중복체크
	function programCheckForm() {
		var resumeId = $('input[name=resumeId]').val();
		var programingId = $('input[name=programingId]').val();
		var program = $('input[name=program]').val();
		var isDelete = $('input[name=isDelete]').val();
		var data = {
				resumeId : resumeId,
				programingId : programingId,
				program : program,
				isDelete : isDelete
			}; 

		var resumeProgramId = $('input[name=resumeProgramId]').val();
		var preProgramingId = $('input[name=preProgramingId]').val();
		var preProgram = $('input[name=preProgram]').val();

		if(programingId != preProgramingId || program != preProgram) {
			$.ajax({
				url: '/studio/resume/programCk',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var result = response.data;
					if(result == true){					
						console.log("seccess");
						if(resumeProgramId == '' || resumeProgramId == null) {
							programCreateForm();
						} else {
							programEditForm();
						}
					}else{
						alert('<spring:message code="resume.alert.program" text="이미 등록된 프로그램입니다." />');
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			programEditForm();
		}
	}

	//이력서 프로그램 등록
	function programCreateForm() {
		var resumeId = $('input[name=resumeId]').val();
		var programingId = $('input[name=programingId]').val();
		var program = $('input[name=program]').val();
		var measureTypeCode = $('input[name=measureTypeCode].program').val();
		var measureLevel = $('input[name=measureLevel].program:checked').val();
		var data = {
			resumeId : resumeId,
			programingId : programingId,
			program : program,
			measureTypeCode : measureTypeCode,
			measureLevel : measureLevel
		}; 

		$.ajax({
			url: '/studio/resume/programCreate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-program');
				if(resultList.length == 1) {
					var htmlAdd = '<div id="programList" class="level-area"></div>';
					$('#programBottom').after(htmlAdd);
				}
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<input type="hidden" class="programCode '+item.resumeProgramId+'" value="'+item.measureLevel+'">';
						html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
						html += '	<div class="box box-level program '+item.resumeProgramId+'">';
						html += '		<div class="info-area">';
						html += '			<div class="level-title">';
						if(item.programingId != '9999') {
							html += '			<span class="name">'+item.programingName+'</span>';
						} else if(item.programingId == '9999') {
							html += '			<span class="name">'+item.program+'</span>';
						}
						html += '				<span class="level program '+item.resumeProgramId+'">'+item.levelName+'</span>';
						html += '			</div>';
						html += '			<ul class="level-state program">';
						html += '				<li class="program1 '+item.resumeProgramId+'">Not Applicable</li>';
						html += '				<li class="program2 '+item.resumeProgramId+'">Basic</li>';
						html += '				<li class="program3 '+item.resumeProgramId+'">Intermediate</li>';
						html += '				<li class="program4 '+item.resumeProgramId+'">Upper Intermediate</li>';
						html += '				<li class="program5 '+item.resumeProgramId+'">Advanced</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '		<div class="info-ctrl">';
						html += '			<a href="javascript:;" class="btn btn-edit layer-program" onclick="modProgramPopup('+item.resumeProgramId+');">edit</a>';
						html += '			<button type="button" class="btn btn-delete program" onclick="deleteProgram('+item.resumeProgramId+')">delete</button>';
						html += '		</div>';
						html += '	</div>';
					}
					$('div.box.box-level.program.'+item.resumeProgramId).ready(function() {
						var programCode = $('.programCode.'+item.resumeProgramId).val();

						if(item.measureLevel == '1' && programCode == '1') {
							$('.level.program.'+item.resumeProgramId).addClass('level1');
							$('.program1.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '2' && programCode == '2') {
							$('.level.program.'+item.resumeProgramId).addClass('level2');
							$('.program2.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '3' && programCode == '3') {
							$('.level.program.'+item.resumeProgramId).addClass('level3');
							$('.program3.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '4' && programCode == '4') {
							$('.level.program.'+item.resumeProgramId).addClass('level4');
							$('.program4.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '5' && programCode == '5') {
							$('.level.program.'+item.resumeProgramId).addClass('level5');
							$('.program5.'+item.resumeProgramId).addClass('on');
						} 
					});
					return true;
				});
				$('#programList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 프로그램 수정
	function programEditForm() {
		var resumeId = $('input[name=resumeId]').val();
		var resumeProgramId = $('input[name=resumeProgramId]').val();
		var programingId = $('input[name=programingId]').val();
		var program = $('input[name=program]').val();
		var measureTypeCode = $('input[name=measureTypeCode].program').val();
		var measureLevel = $('input[name=measureLevel].program:checked').val();
		var data = {
			resumeId : resumeId,
			resumeProgramId : resumeProgramId,
			programingId : programingId,
			program : program,
			measureTypeCode : measureTypeCode,
			measureLevel : measureLevel
		}; 

		$.ajax({
			url: '/studio/resume/programEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-program');
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<input type="hidden" class="programCode '+item.resumeProgramId+'" value="'+item.measureLevel+'">';
						html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
						html += '	<div class="box box-level program '+item.resumeProgramId+'">';
						html += '		<div class="info-area">';
						html += '			<div class="level-title">';
						if(item.programingId != '9999') {
							html += '			<span class="name">'+item.programingName+'</span>';
						} else if(item.programingId == '9999') {
							html += '			<span class="name">'+item.program+'</span>';
						}
						html += '				<span class="level program '+item.resumeProgramId+'">'+item.levelName+'</span>';
						html += '			</div>';
						html += '			<ul class="level-state program">';
						html += '				<li class="program1 '+item.resumeProgramId+'">Not Applicable</li>';
						html += '				<li class="program2 '+item.resumeProgramId+'">Basic</li>';
						html += '				<li class="program3 '+item.resumeProgramId+'">Intermediate</li>';
						html += '				<li class="program4 '+item.resumeProgramId+'">Upper Intermediate</li>';
						html += '				<li class="program5 '+item.resumeProgramId+'">Advanced</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '		<div class="info-ctrl">';
						html += '			<a href="javascript:;" class="btn btn-edit layer-program" onclick="modProgramPopup('+item.resumeProgramId+');">edit</a>';
						html += '			<button type="button" class="btn btn-delete program" onclick="deleteProgram('+item.resumeProgramId+')">delete</button>';
						html += '		</div>';
						html += '	</div>';
					}
					$('div.box.box-level.program.'+item.resumeProgramId).ready(function() {
						var programCode = $('.programCode.'+item.resumeProgramId).val();

						if(item.measureLevel == '1' && programCode == '1') {
							$('.level.program.'+item.resumeProgramId).addClass('level1');
							$('.program1.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '2' && programCode == '2') {
							$('.level.program.'+item.resumeProgramId).addClass('level2');
							$('.program2.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '3' && programCode == '3') {
							$('.level.program.'+item.resumeProgramId).addClass('level3');
							$('.program3.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '4' && programCode == '4') {
							$('.level.program.'+item.resumeProgramId).addClass('level4');
							$('.program4.'+item.resumeProgramId).addClass('on');
						} else if(item.measureLevel == '5' && programCode == '5') {
							$('.level.program.'+item.resumeProgramId).addClass('level5');
							$('.program5.'+item.resumeProgramId).addClass('on');
						} 
					});
					return true;
				});
				$('#programList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 프로그램 삭제
	function deleteProgram(id) {
		var resumeId = $('input[name=resumeId]').val();
		var data = {
			resumeId : resumeId,
			resumeProgramId : id
		};
		if(confirm('<spring:message code="resume.alert.delete" text="삭제 하시겠습니까?" />') == true) {
			$.ajax({
				url: '/studio/resume/programDelete',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var resultList = response.data;
					var html = '';
					if(resultList.length != 0) {
						$.each(resultList, function(index, item) {
							if(item.isDelete != 'Y') {
								html += '<input type="hidden" class="programCode '+item.resumeProgramId+'" value="'+item.measureLevel+'">';
								html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
								html += '	<div class="box box-level program '+item.resumeProgramId+'">';
								html += '		<div class="info-area">';
								html += '			<div class="level-title">';
								if(item.programingId != '9999') {
									html += '			<span class="name">'+item.programingName+'</span>';
								} else if(item.programingId == '9999') {
									html += '			<span class="name">'+item.program+'</span>';
								}
								html += '				<span class="level program '+item.resumeProgramId+'">'+item.levelName+'</span>';
								html += '			</div>';
								html += '			<ul class="level-state program">';
								html += '				<li class="program1 '+item.resumeProgramId+'">Not Applicable</li>';
								html += '				<li class="program2 '+item.resumeProgramId+'">Basic</li>';
								html += '				<li class="program3 '+item.resumeProgramId+'">Intermediate</li>';
								html += '				<li class="program4 '+item.resumeProgramId+'">Upper Intermediate</li>';
								html += '				<li class="program5 '+item.resumeProgramId+'">Advanced</li>';
								html += '			</ul>';
								html += '		</div>';
								html += '		<div class="info-ctrl">';
								html += '			<a href="javascript:;" class="btn btn-edit layer-program" onclick="modProgramPopup('+item.resumeProgramId+');">edit</a>';
								html += '			<button type="button" class="btn btn-delete program" onclick="deleteProgram('+item.resumeProgramId+')">delete</button>';
								html += '		</div>';
								html += '	</div>';
							}
							$('div.box.box-level.program.'+item.resumeProgramId).ready(function() {
								var programCode = $('.programCode.'+item.resumeProgramId).val();

								if(item.measureLevel == '1' && programCode == '1') {
									$('.level.program.'+item.resumeProgramId).addClass('level1');
									$('.program1.'+item.resumeProgramId).addClass('on');
								} else if(item.measureLevel == '2' && programCode == '2') {
									$('.level.program.'+item.resumeProgramId).addClass('level2');
									$('.program2.'+item.resumeProgramId).addClass('on');
								} else if(item.measureLevel == '3' && programCode == '3') {
									$('.level.program.'+item.resumeProgramId).addClass('level3');
									$('.program3.'+item.resumeProgramId).addClass('on');
								} else if(item.measureLevel == '4' && programCode == '4') {
									$('.level.program.'+item.resumeProgramId).addClass('level4');
									$('.program4.'+item.resumeProgramId).addClass('on');
								} else if(item.measureLevel == '5' && programCode == '5') {
									$('.level.program.'+item.resumeProgramId).addClass('level5');
									$('.program5.'+item.resumeProgramId).addClass('on');
								} 
							});
							return true;
						});
						$('#programList').html(html);
					} else if (resultList.length == 0){
						$('div').remove('#programList.level-area');
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			return false;
		}
	}
	
	//프로그램 modal 리셋
	function resetProgram() {
		$('input[name=resumeProgramId]').val('');
		$('input[name=programingId]').val('');
		$('input[name=program]').val('');
		$('input[name=measureLevel].program').val('');

		$('.programInput').hide();
		
		$('dl.dropdown-select.program').removeClass('on');
		$('a.btn.programingNameEng').text('<spring:message code="resume.text13" text="Seleccionar" />');

		$('input[type=radio].program').prop('checked', false);
	}

	//프로그램 선택
	function programingSelete(value) {
		var code = String($(value).val());
		var strValue = "" + code;
		var num = "0000";
		var ans = num.substring(0, num.length - strValue.length) + strValue;
		$('input[name=programingId]').val(ans);
	}

	//프로그램 등록 modal
	function regProgramPopup() {
		$('#createProgramBtn').prop('disabled', true); //처음 버튼 비활성화
		$('#createProgramBtn').show();
		$('#editProgramBtn').prop('disabled', true);
		$('#editProgramBtn').hide();
		resetProgram();
		openModal('#layer-program');
		
		$('ul.dropdown-list li.9999').on('click', function() {
			$('.programInput').show();
		});
		$('ul.dropdown-list li').not('.9999').on('click', function() {
			$('.programInput').hide();
			$('input[name=program]').val('');
		});

		$('input[type=radio].program').click(function() {
			$('#inputLevel6_1').val('1');
			$('#inputLevel6_2').val('2');
			$('#inputLevel6_3').val('3');
			$('#inputLevel6_4').val('4');
			$('#inputLevel6_5').val('5');
			var value = $('input[name=measureLevel].program:checked').val();
		});

		//필수값 체크
		$('li').on('propertychange change keyup paste input click', processkey);
		$('input[name=program]').on('propertychange change keyup paste input', processkey);
		$('input[type=radio].program').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var programingId = $('input[name=programingId]').val();
			var program = $('input[name=program]').val();
			var measureLevel = $('input[type=radio].program:checked').val();

			if(programingId == '9999') {
				if(programingId == '' || program == '' || measureLevel == undefined) {
					$('#createProgramBtn').prop('disabled', true);
				} else {
					$('#createProgramBtn').prop('disabled', false);
				}
			} else {
				if(programingId == '' || measureLevel == undefined) {
					$('#createProgramBtn').prop('disabled', true);
				} else {
					$('#createProgramBtn').prop('disabled', false);
				}
			}
		}

		//byte수 체크
		$('input[name=program]').on('input', {maxByte : 50}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//프로그램 수정  modal
	function modProgramPopup(id) {
		$('#createProgramBtn').prop('disabled', true);
		$('#createProgramBtn').hide();
		$('#editProgramBtn').prop('disabled', false);
		$('#editProgramBtn').show();
		resetProgram();
		
		$.ajax({
			url: '/studio/resume/programEditView?resumeProgramId='+id,
			type: 'get',
			data: id,
			dataType: 'json',
			success: function(response){
				var result = response.data;

				$('input[name=resumeProgramId]').val(result.resumeProgramId);
				var reProgram = result.program;
				var newProgram = reProgram.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=program]').val(newProgram);
				$('input[name=programingId]').val(result.programingId);
				$('input[name=programingNameEng]').val(result.programingName);
				$('input[name=measureTypeCode].program').val(result.measureTypeCode);
				$('input[name=measureLevel].program').val(result.measureLevel);
				$('input[name=isDelete]').val(result.isDelete);

				$('input[name=preProgram]').val(result.program);
				$('input[name=preProgramingId]').val(result.programingId);

				var skillCode = $('input[name=measureLevel].program').val();
				if(skillCode == '1') {
					$('#inputLevel6_1').prop('checked', true);
				} else if(skillCode == '2'){
					$('#inputLevel6_2').prop('checked', true);
				} else if(skillCode == '3'){
					$('#inputLevel6_3').prop('checked', true);
				} else if(skillCode == '4'){
					$('#inputLevel6_4').prop('checked', true);
				} else if(skillCode == '5'){
					$('#inputLevel6_5').prop('checked', true);
				}

				var programName = $('input[name=program]').val();
				if(programName != '') {
					$('.programInput').show();
					$('dl.dropdown-select').addClass('on');
					var programingNameEng = $('input[name=programingNameEng]').val();
					$('a.btn.programingNameEng').text(programingNameEng);
				} else if(programName == '') {
					$('.programInput').hide();
					$('dl.dropdown-select').addClass('on');
					var programingNameEng = $('input[name=programingNameEng]').val();
					$('a.btn.programingNameEng').text(programingNameEng);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});

		openModal('#layer-program');

		$('ul.dropdown-list li.9999').on('click', function() {
			$('.programInput').show();
		});
		$('ul.dropdown-list li').not('.9999').on('click', function() {
			$('.programInput').hide();
			$('input[name=program]').val('');
		});
		
		$('input[type=radio].program').click(function() {
			$('#inputLevel6_1').val('1');
			$('#inputLevel6_2').val('2');
			$('#inputLevel6_3').val('3');
			$('#inputLevel6_4').val('4');
			$('#inputLevel6_5').val('5');
			var value = $('input[name=measureLevel].program:checked').val();
		});

		//필수값 체크
		$('li').on('propertychange change keyup paste input click', processkey);
		$('input[name=program]').on('propertychange change keyup paste input', processkey);
		$('input[type=radio].program').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var programingId = $('input[name=programingId]').val();
			var program = $('input[name=program]').val();
			var measureLevel = $('input[type=radio].program:checked').val();

			if(programingId == '9999') {
				if(programingId == '' || program == '' || measureLevel == undefined) {
					$('#editProgramBtn').prop('disabled', true);
				} else {
					$('#editProgramBtn').prop('disabled', false);
				}
			} else {
				if(programingId == '' || measureLevel == undefined) {
					$('#editProgramBtn').prop('disabled', true);
				} else {
					$('#editProgramBtn').prop('disabled', false);
				}
			}
		}

		//byte수 체크
		$('input[name=program]').on('input', {maxByte : 50}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//이력서 언어 중복체크
	function languageCheckForm() {
		var resumeId = $('input[name=resumeId]').val();
		var langId = $('input[name=langId]').val();
		var langTitle = $('input[name=langTitle]').val();
		var isDelete = $('input[name=isDelete]').val();
		var data = {
				resumeId : resumeId,
				langId : langId,
				langTitle : langTitle,
				isDelete : isDelete
			}; 

		var resumeLangId = $('input[name=resumeLangId]').val();
		var preLangId = $('input[name=preLangId]').val();
		var preLang = $('input[name=preLang]').val();

		if(langId != preLangId || langTitle != preLang) {
			$.ajax({
				url: '/studio/resume/langCk',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var result = response.data;
					if(result == true){					
						console.log("seccess");
						if(resumeLangId == '' || resumeLangId == null) {
							languageCreateForm();
						} else {
							languageEditForm();
						}
					}else{
						alert('<spring:message code="resume.alert.language" text="이미 등록된 언어입니다." />');
					}
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			languageEditForm();
		}
	}

	//이력서 언어 등록
	function languageCreateForm() {
		var resumeId = $('input[name=resumeId]').val();
		var langId = $('input[name=langId]').val();
		var langTitle = $('input[name=langTitle]').val();
		var measureTypeCode = $('input[name=measureTypeCode].lang').val();
		var measureLevel = $('input[name=measureLevel].lang:checked').val();
		var data = {
			resumeId : resumeId,
			langId : langId,
			langTitle : langTitle,
			measureTypeCode : measureTypeCode,
			measureLevel : measureLevel
		}; 

		$.ajax({
			url: '/studio/resume/langCreate',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-language');
				if(resultList.length == 1) {
					var htmlAdd = '<div id="langList" class="level-area"></div>';
					$('#langBottom').after(htmlAdd);
				}
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<input type="hidden" class="langCode '+item.resumeLangId+'" value="'+item.measureLevel+'">';
						html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
						html += '	<div class="box box-level lang '+item.resumeLangId+'">';
						html += '		<div class="info-area">';
						html += '			<div class="level-title">';
						if(item.langId != '9999') {
							html += '			<span class="name">'+item.langName+'</span>';
						} else if(item.langId == '9999') {
							html += '			<span class="name">'+item.langTitle+'</span>';
						}
						html += '				<span class="level lang '+item.resumeLangId+'">'+item.levelName+'</span>';
						html += '			</div>';
						html += '			<ul class="level-state lang">';
						html += '				<li class="lang1 '+item.resumeLangId+'">Not Applicable</li>';
						html += '				<li class="lang2 '+item.resumeLangId+'">Basic</li>';
						html += '				<li class="lang3 '+item.resumeLangId+'">Intermediate</li>';
						html += '				<li class="lang4 '+item.resumeLangId+'">Upper Intermediate</li>';
						html += '				<li class="lang5 '+item.resumeLangId+'">Advanced</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '		<div class="info-ctrl">';
						html += '			<a href="javascript:;" class="btn btn-edit layer-language" onclick="modLanguagePopup('+item.resumeLangId+');">edit</a>';
						html += '			<button type="button" class="btn btn-delete language" onclick="deleteLang('+item.resumeLangId+');">delete</button>';
						html += '		</div>';
						html += '	</div>';
					}
					$('div.box.box-level.lang.'+item.resumeLangId).ready(function() {
						var langCode = $('.langCode.'+item.resumeLangId).val();

						if(item.measureLevel == '1' && langCode == '1') {
							$('.level.lang.'+item.resumeLangId).addClass('level1');
							$('.lang1.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '2' && langCode == '2') {
							$('.level.lang.'+item.resumeLangId).addClass('level2');
							$('.lang2.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '3' && langCode == '3') {
							$('.level.lang.'+item.resumeLangId).addClass('level3');
							$('.lang3.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '4' && langCode == '4') {
							$('.level.lang.'+item.resumeLangId).addClass('level4');
							$('.lang4.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '5' && langCode == '5') {
							$('.level.lang.'+item.resumeLangId).addClass('level5');
							$('.lang5.'+item.resumeLangId).addClass('on');
						} 
					});
					return true;
				});
				$('#langList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 언어 수정
	function languageEditForm() {
		var resumeId = $('input[name=resumeId]').val();
		var resumeLangId = $('input[name=resumeLangId]').val();
		var langId = $('input[name=langId]').val();
		var langTitle = $('input[name=langTitle]').val();
		var measureTypeCode = $('input[name=measureTypeCode].lang').val();
		var measureLevel = $('input[name=measureLevel].lang:checked').val();
		var data = {
			resumeId : resumeId,
			resumeLangId : resumeLangId,
			langId : langId,
			langTitle : langTitle,
			measureTypeCode : measureTypeCode,
			measureLevel : measureLevel
		}; 

		$.ajax({
			url: '/studio/resume/langEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var resultList = response.data;
				closeModal('#layer-language');
				var html = '';
				$.each(resultList, function(index, item) {
					if(item.isDelete != 'Y') {
						html += '<input type="hidden" class="langCode '+item.resumeLangId+'" value="'+item.measureLevel+'">';
						html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
						html += '	<div class="box box-level lang '+item.resumeLangId+'">';
						html += '		<div class="info-area">';
						html += '			<div class="level-title">';
						if(item.langId != '9999') {
							html += '			<span class="name">'+item.langName+'</span>';
						} else if(item.langId == '9999') {
							html += '			<span class="name">'+item.langTitle+'</span>';
						}
						html += '				<span class="level lang '+item.resumeLangId+'">'+item.levelName+'</span>';
						html += '			</div>';
						html += '			<ul class="level-state lang">';
						html += '				<li class="lang1 '+item.resumeLangId+'">Not Applicable</li>';
						html += '				<li class="lang2 '+item.resumeLangId+'">Basic</li>';
						html += '				<li class="lang3 '+item.resumeLangId+'">Intermediate</li>';
						html += '				<li class="lang4 '+item.resumeLangId+'">Upper Intermediate</li>';
						html += '				<li class="lang5 '+item.resumeLangId+'">Advanced</li>';
						html += '			</ul>';
						html += '		</div>';
						html += '		<div class="info-ctrl">';
						html += '			<a href="javascript:;" class="btn btn-edit layer-language" onclick="modLanguagePopup('+item.resumeLangId+');">edit</a>';
						html += '			<button type="button" class="btn btn-delete language" onclick="deleteLang('+item.resumeLangId+');">delete</button>';
						html += '		</div>';
						html += '	</div>';
					}
					$('div.box.box-level.lang.'+item.resumeLangId).ready(function() {
						var langCode = $('.langCode.'+item.resumeLangId).val();

						if(item.measureLevel == '1' && langCode == '1') {
							$('.level.lang.'+item.resumeLangId).addClass('level1');
							$('.lang1.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '2' && langCode == '2') {
							$('.level.lang.'+item.resumeLangId).addClass('level2');
							$('.lang2.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '3' && langCode == '3') {
							$('.level.lang.'+item.resumeLangId).addClass('level3');
							$('.lang3.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '4' && langCode == '4') {
							$('.level.lang.'+item.resumeLangId).addClass('level4');
							$('.lang4.'+item.resumeLangId).addClass('on');
						} else if(item.measureLevel == '5' && langCode == '5') {
							$('.level.lang.'+item.resumeLangId).addClass('level5');
							$('.lang5.'+item.resumeLangId).addClass('on');
						} 
					});
					return true;
				});
				$('#langList').html(html);
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 언어 삭제
	function deleteLang(id) {
		var resumeId = $('input[name=resumeId]').val();
		var data = {
			resumeId : resumeId,
			resumeLangId : id
		}
		if(confirm('<spring:message code="resume.alert.delete" text="삭제 하시겠습니까?" />') == true) {
			$.ajax({
				url: '/studio/resume/langDelete',
				type: 'post',
				data: data,
				dataType: 'json',
				success: function(response){
					var resultList = response.data;
					var html = '';
					if(resultList.length != 0) {
						$.each(resultList, function(index, item) {
							if(item.isDelete != 'Y') {
								html += '<input type="hidden" class="langCode '+item.resumeLangId+'" value="'+item.measureLevel+'">';
								html += '<input type="hidden" name="measureTypeCode" value="'+item.measureTypeCode+'">';
								html += '	<div class="box box-level lang '+item.resumeLangId+'">';
								html += '		<div class="info-area">';
								html += '			<div class="level-title">';
								if(item.langId != '9999') {
									html += '			<span class="name">'+item.langName+'</span>';
								} else if(item.langId == '9999') {
									html += '			<span class="name">'+item.langTitle+'</span>';
								}
								html += '				<span class="level lang '+item.resumeLangId+'">'+item.levelName+'</span>';
								html += '			</div>';
								html += '			<ul class="level-state lang">';
								html += '				<li class="lang1 '+item.resumeLangId+'">Not Applicable</li>';
								html += '				<li class="lang2 '+item.resumeLangId+'">Basic</li>';
								html += '				<li class="lang3 '+item.resumeLangId+'">Intermediate</li>';
								html += '				<li class="lang4 '+item.resumeLangId+'">Upper Intermediate</li>';
								html += '				<li class="lang5 '+item.resumeLangId+'">Advanced</li>';
								html += '			</ul>';
								html += '		</div>';
								html += '		<div class="info-ctrl">';
								html += '			<a href="javascript:;" class="btn btn-edit layer-language" onclick="modLanguagePopup('+item.resumeLangId+');">edit</a>';
								html += '			<button type="button" class="btn btn-delete language" onclick="deleteLang('+item.resumeLangId+');">delete</button>';
								html += '		</div>';
								html += '	</div>';
							}
							$('div.box.box-level.lang.'+item.resumeLangId).ready(function() {
								var langCode = $('.langCode.'+item.resumeLangId).val();

								if(item.measureLevel == '1' && langCode == '1') {
									$('.level.lang.'+item.resumeLangId).addClass('level1');
									$('.lang1.'+item.resumeLangId).addClass('on');
								} else if(item.measureLevel == '2' && langCode == '2') {
									$('.level.lang.'+item.resumeLangId).addClass('level2');
									$('.lang2.'+item.resumeLangId).addClass('on');
								} else if(item.measureLevel == '3' && langCode == '3') {
									$('.level.lang.'+item.resumeLangId).addClass('level3');
									$('.lang3.'+item.resumeLangId).addClass('on');
								} else if(item.measureLevel == '4' && langCode == '4') {
									$('.level.lang.'+item.resumeLangId).addClass('level4');
									$('.lang4.'+item.resumeLangId).addClass('on');
								} else if(item.measureLevel == '5' && langCode == '5') {
									$('.level.lang.'+item.resumeLangId).addClass('level5');
									$('.lang5.'+item.resumeLangId).addClass('on');
								} 
							});
							return true;
						});
						$('#langList').html(html);
					} else if (resultList.length == 0){
						$('div').remove('#langList.level-area');
					}
					
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});
		} else {
			return false;
		}
	}
	
	//언어 modal 리셋
	function resetLanguage() {
		$('input[name=resumeLangId]').val('');
		$('input[name=langId]').val('');
		$('input[name=langTitle]').val('');
		$('input[name=measureLevel].lang').val('');

		$('.languageInput').hide();
		
		$('dl.dropdown-select.lang').removeClass('on');
		$('a.btn.langNameEng').text('<spring:message code="resume.text13" text="Seleccionar" />');

		$('input[type=radio].lang').prop('checked', false);
	}

	//언어 선택
	function languageSelete(value) {
		var code = String($(value).val());
		var strValue = "" + code;
		var num = "0000";
		var ans = num.substring(0, num.length - strValue.length) + strValue;
		$('input[name=langId]').val(ans);
	}

	//언어 등록 modal
	function regLanguagePopup() {
		$('#createLanguageBtn').prop('disabled', true); //처음 버튼 비활성화
		$('#createLanguageBtn').show();
		$('#editLanguageBtn').prop('disabled', true);
		$('#editLanguageBtn').hide();
		resetLanguage();
		openModal('#layer-language');
		
		$('ul.dropdown-list li.9999').on('click', function() {
			$('.languageInput').show();
		});
		$('ul.dropdown-list li').not('.9999').on('click', function() {
			$('.languageInput').hide();
			$('input[name=langTitle]').val('');
		});

		$('input[type=radio].lang').click(function() {
			$('#inputLevel7_1').val('1');
			$('#inputLevel7_2').val('2');
			$('#inputLevel7_3').val('3');
			$('#inputLevel7_4').val('4');
			$('#inputLevel7_5').val('5');
			var value = $('input[name=measureLevel].lang:checked').val();
		});

		//필수값 체크
		$('li').on('propertychange change keyup paste input click', processkey);
		$('input[name=lang]').on('propertychange change keyup paste input', processkey);
		$('input[type=radio].lang').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var langId = $('input[name=langId]').val();
			var langTitle = $('input[name=langTitle]').val();
			var measureLevel = $('input[type=radio].lang:checked').val();

			if(langId == '9999') {
				if(langId == '' || langTitle == '' || measureLevel == undefined) {
					$('#createLanguageBtn').prop('disabled', true);
				} else {
					$('#createLanguageBtn').prop('disabled', false);
				}
			} else {
				if(langId == '' || measureLevel == undefined) {
					$('#createLanguageBtn').prop('disabled', true);
				} else {
					$('#createLanguageBtn').prop('disabled', false);
				}
			}
		}

		//byte수 체크
		$('input[name=langTitle]').on('input', {maxByte : 50}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//언어 수정  modal
	function modLanguagePopup(id) {
		$('#createLanguageBtn').prop('disabled', true);
		$('#createLanguageBtn').hide();
		$('#editLanguageBtn').prop('disabled', false);
		$('#editLanguageBtn').show();
		resetLanguage();
		
		$.ajax({
			url: '/studio/resume/langEditView?resumeLangId='+id,
			type: 'get',
			data: id,
			dataType: 'json',
			success: function(response){
				var result = response.data;

				$('input[name=resumeLangId]').val(result.resumeLangId);
				var reLangTitle = result.langTitle;
				var newLangTitle = reLangTitle.replace(/&lt;/g, '<').replace(/&gt;/g, '>').replace(/&#40;/g, '(').replace(/&#41;/g, ')').replace(/&#39;/g, '\'').replace(/&#34;/g, '\"');
				$('input[name=langTitle]').val(newLangTitle);
				$('input[name=langId]').val(result.langId);
				$('input[name=langNameEng]').val(result.langName);
				$('input[name=measureTypeCode].lang').val(result.measureTypeCode);
				$('input[name=measureLevel].lang').val(result.measureLevel);

				$('input[name=preLangId]').val(result.langId);
				$('input[name=preLang]').val(result.langTitle);
				
				var skillCode = $('input[name=measureLevel].lang').val();
				if(skillCode == '1') {
					$('#inputLevel7_1').prop('checked', true);
				} else if(skillCode == '2'){
					$('#inputLevel7_2').prop('checked', true);
				} else if(skillCode == '3'){
					$('#inputLevel7_3').prop('checked', true);
				} else if(skillCode == '4'){
					$('#inputLevel7_4').prop('checked', true);
				} else if(skillCode == '5'){
					$('#inputLevel7_5').prop('checked', true);
				}

				var langName = $('input[name=langTitle]').val();
				if(langName != '') {
					$('.languageInput').show();
					$('dl.dropdown-select').addClass('on');
					var langNameEng = $('input[name=langNameEng]').val();
					$('a.btn.langNameEng').text(langNameEng);
				} else if(langName == '') {
					$('.languageInput').hide();
					$('dl.dropdown-select').addClass('on');
					var langNameEng = $('input[name=langNameEng]').val();
					$('a.btn.langNameEng').text(langNameEng);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});

		openModal('#layer-language');

		$('ul.dropdown-list li.9999').on('click', function() {
			$('.languageInput').show();
		});
		$('ul.dropdown-list li').not('.9999').on('click', function() {
			$('.languageInput').hide();
			$('input[name=langTitle]').val('');
		});

		$('input[type=radio].lang').click(function() {
			$('#inputLevel7_1').val('1');
			$('#inputLevel7_2').val('2');
			$('#inputLevel7_3').val('3');
			$('#inputLevel7_4').val('4');
			$('#inputLevel7_5').val('5');
			var value = $('input[name=measureLevel].lang:checked').val();
		});

		//필수값 체크
		$('li').on('propertychange change keyup paste input click', processkey);
		$('input[name=langTitle]').on('propertychange change keyup paste input', processkey);
		$('input[type=radio].lang').on('propertychange change keyup paste input click', processkey);

		function processkey() {
			var langId = $('input[name=langId]').val();
			var langTitle = $('input[name=langTitle]').val();
			var measureLevel = $('input[type=radio].lang:checked').val();

			if(langId == '9999') {
				if(langId == '' || langTitle == '' || measureLevel == undefined) {
					$('#editLanguageBtn').prop('disabled', true);
				} else {
					$('#editLanguageBtn').prop('disabled', false);
				}
			} else {
				if(langId == '' || measureLevel == undefined) {
					$('#editLanguageBtn').prop('disabled', true);
				} else {
					$('#editLanguageBtn').prop('disabled', false);
				}
			}
		}

		//byte수 체크
		$('input[name=langTitle]').on('input', {maxByte : 50}, strByteCheck);

		function strByteCheck(e) {
			var str = e.target.value;
			var maxByte = e.data.maxByte;

			var reByte = 0;
			var reLen = 0;
			var oneChar = '';
			var newStr = '';

			for(var i = 0; i < str.length; i++) {
				oneChar = str.charAt(i);
				if(escape(oneChar).length > 4) {
					reByte += 2; //한글일 때
				} else {
					reByte++; //영어일 때
				}
				if(reByte <= maxByte) {
					reLen = i + 1;
				}
			}
			if(reByte > maxByte) {
				alert(maxByte+'byte를 초과하셨습니다.');
				newStr = str.substr(0, reLen); //글자수 자르기
				e.target.value = newStr;
				strByteCheck(e);
			}
		}
	}

	//포트폴리오 선택 및 등록
	function portfolioSelete(value) {
		var code = String($(value).val());
		var qrCode = $(value).data('qr');
		$('input[name=portfolioId]').val(code);
		$('input[name=portfolioName]').val(qrCode);

		var resumeId = $('input[name=resumeId]').val();
		var qrPortfolioId = $('input[name=portfolioId]').val();
		var data = {
			resumeId : resumeId,
			qrPortfolioId : qrPortfolioId
		};

		$.ajax({
			url: '/studio/resume/portfolioEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == true){					
					console.log("seccess");
				}else{
					alert(response.message);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 정보 노출 여부 등록(모바일 버전)
	function exposeCreateForm() {
		//이력서 정보 노출 여부 수정
		var resumeId = $('#infoPopupResumeId').val();
		var isPictureDisplay = $('input[name=isPictureDisplay].expose').val();
		var isYearmonthdayDisplay = $('input[name=isYearmonthdayDisplay].expose').val();
		var isCountryDisplay = $('input[name=isCountryDisplay].expose').val();
		var isCareerDisplay = $('input[name=isCareerDisplay].expose').val();
		var isEducationDisplay = $('input[name=isEducationDisplay].expose').val();
		var isHaveSkillDisplay = $('input[name=isHaveSkillDisplay].expose').val();
		var isProgramDisplay = $('input[name=isProgramDisplay].expose').val();
		var isLangDisplay = $('input[name=isLangDisplay].expose').val();
		var isQrPortfolioDisplay = $('input[name=isQrPortfolioDisplay].expose').val();
		var isAboutMeDisplay = $('input[name=isAboutMeDisplay].expose').val();
		var isSexDisplay = $('input[name=isSexDisplay].expose').val();
		var data = {
			resumeId : resumeId,
			isPictureDisplay : isPictureDisplay,
			isYearmonthdayDisplay : isYearmonthdayDisplay,
			isCountryDisplay : isCountryDisplay,
			isCareerDisplay : isCareerDisplay,
			isEducationDisplay : isEducationDisplay,
			isHaveSkillDisplay : isHaveSkillDisplay,
			isProgramDisplay : isProgramDisplay,
			isLangDisplay : isLangDisplay,
			isQrPortfolioDisplay : isQrPortfolioDisplay,
			isAboutMeDisplay : isAboutMeDisplay,
			isSexDisplay : isSexDisplay
		}; 

		$.ajax({
			url: '/studio/resume/infoEdit',
			type: 'post',
			data: data,
			dataType: 'json',
			success: function(response){
				var result = response.data;
				if(result == true){					
					location.href = '/studio/resume/detail';
				}else{
					alert(response.message);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//이력서 정보 노출 여부 등록 modal(모바일 버전)
	function regExposePopup() {
		var isPictureDisplay = $('input[name=isPictureDisplay]').val();
		var isYearmonthdayDisplay = $('input[name=isYearmonthdayDisplay]').val();
		var isSexDisplay = $('input[name=isSexDisplay]').val();
		var isCountryDisplay =  $('input[name=isCountryDisplay]').val();
		var isAboutMeDisplay = $('input[name=isAboutMeDisplay]').val();
		var isCareerDisplay = $('input[name=isCareerDisplay]').val();
		var isEducationDisplay = $('input[name=isEducationDisplay]').val();
		var isHaveSkillDisplay = $('input[name=isHaveSkillDisplay]').val();
		var isProgramDisplay = $('input[name=isProgramDisplay]').val();
		var isLangDisplay = $('input[name=isLangDisplay]').val();
		var isQrPortfolioDisplay = $('input[name=isQrPortfolioDisplay]').val();
		
		//사진 노출 여부
		if(isPictureDisplay == 'N') {
			$("#inputCheck3_1").prop("checked", true);
			$('input[name=isPictureDisplay].expose').val('N');
		} else {
			$("#inputCheck3_1").prop("checked", false);
			$('input[name=isPictureDisplay].expose').val('Y');
		}

		//년월일 노출 여부
		if(isYearmonthdayDisplay == 'N') {
			$("#inputCheck3_2").prop("checked", true);
			$('input[name=isYearmonthdayDisplay].expose').val('N');
		} else {
			$("#inputCheck3_2").prop("checked", false);
			$('input[name=isYearmonthdayDisplay].expose').val('Y');
		}

		//성별 노출 여부
		if(isSexDisplay == 'N') {
			$("#inputCheck3_3").prop("checked", true);
			$('input[name=isSexDisplay].expose').val('N');
		} else {
			$("#inputCheck3_3").prop("checked", false);
			$('input[name=isSexDisplay].expose').val('Y');
		}

		//국가 노출 여부
		if(isCountryDisplay == 'N') {
			$("#inputCheck3_4").prop("checked", true);
			$('input[name=isCountryDisplay].expose').val('N');
		} else {
			$("#inputCheck3_4").prop("checked", false);
			$('input[name=isCountryDisplay].expose').val('Y');
		}

		//경력 노출 여부
		if(isAboutMeDisplay == 'N') {
			$("#inputCheck4_1").prop("checked", true);
			$('input[name=isAboutMeDisplay].expose').val('N');
		} else {
			$("#inputCheck4_1").prop("checked", false);
			$('input[name=isAboutMeDisplay].expose').val('Y');
		}

		//경력 노출 여부
		if(isCareerDisplay == 'N') {
			$("#inputCheck4_2").prop("checked", true);
			$('input[name=isCareerDisplay].expose').val('N');
		} else {
			$("#inputCheck4_2").prop("checked", false);
			$('input[name=isCareerDisplay].expose').val('Y');
		}

		//교육 노출 여부
		if(isEducationDisplay == 'N') {
			$("#inputCheck4_3").prop("checked", true);
			$('input[name=isEducationDisplay].expose').val('N');
		} else {
			$("#inputCheck4_3").prop("checked", false);
			$('input[name=isEducationDisplay].expose').val('Y');
		}

		//보유스킬 노출 여부
		if(isHaveSkillDisplay == 'N') {
			$("#inputCheck4_4").prop("checked", true);
			$('input[name=isHaveSkillDisplay].expose').val('N');
		} else {
			$("#inputCheck4_4").prop("checked", false);
			$('input[name=isHaveSkillDisplay].expose').val('Y');
		}

		//프로그램 노출 여부
		if(isProgramDisplay == 'N') {
			$("#inputCheck4_5").prop("checked", true);
			$('input[name=isProgramDisplay].expose').val('N');
		} else {
			$("#inputCheck4_5").prop("checked", false);
			$('input[name=isProgramDisplay].expose').val('Y');
		}

		//언어 노출 여부
		if(isLangDisplay == 'N') {
			$("#inputCheck4_6").prop("checked", true);
			$('input[name=isLangDisplay].expose').val('N');
		} else {
			$("#inputCheck4_6").prop("checked", false);
			$('input[name=isLangDisplay].expose').val('Y');
		}

		//QR 포트폴리오 노출 여부
		if(isQrPortfolioDisplay == 'N') {
			$("#inputCheck4_7").prop("checked", true);
			$('input[name=isQrPortfolioDisplay].expose').val('N');
		} else {
			$("#inputCheck4_7").prop("checked", false);
			$('input[name=isQrPortfolioDisplay].expose').val('Y');
		}
		
		openModal('#layer-expose');

	}

	//이력서 템플릿1
	function openTemplate1() {
		//이력서 템플릿 view
		$.ajax({
			url: '/studio/resume/template',
			type: 'get',
			dataType: 'json',
			success: function(response){
				var result = response.data;
				//프로필
				var profile = '';
					profile += '<span class="name">'+result.name+' '+result.firstName+'</span>';
					profile += '<span class="email">'+result.email+' / '+result.tell+'</span>';
					if(result.isSexDisplay == 'N'){
						if(result.isCountryDisplay == 'N' || result.isYearmonthdayDisplay == 'N') {
							profile += '<span class="personal">'+result.sex+'<span class="text-bar">|</span>';
						} else {
							profile += '<span class="personal">'+result.sex;
						}
					} else {
						profile += '<span class="personal">';
					}
					if(result.isYearmonthdayDisplay == 'N') {
						if(result.isCountryDisplay == 'N') {
							profile += result.day+'.'+result.month+'.'+result.year+'<span class="text-bar">|</span>';
						} else {
							profile += result.day+'.'+result.month+'.'+result.year;
						}
							
					} else {
						profile += '';
					}
					if(result.isCountryDisplay == 'N') {
						if(result.cityName == null || result.cityName == '') {
							profile += result.countryName+'</span>';
						} else {
							profile += result.countryName+', '+result.cityName+'</span>';
						}
					} else {
						profile += '</span>';
					}
					
				$('div.resume-profile.template1').html(profile);

				//자기소개
				if(result.isAboutMeDisplay == 'N') {
					var content = '';
					if(result.selfIntroduction == null) {
						content = '<p></p>';
					} else {
						content = '<p style="white-space: pre-line;">'+result.selfIntroduction+'</p>';
					}
					$('div.resume-self.template1.self').show();
					$('div.content.template1').html(content);
				} else {
					$('div.resume-self.template1.self').hide();
				}
				
				//경력
				if(result.isCareerDisplay == 'N') {
					var careerList = result.careerList;
					var career = '';
					$.each(careerList, function(index, item) {
						if(item.isDelete == 'N' && item.isCareerDisplay == 'N') {
							career += '<li>';
							career += '	<div class="date">';
							if(item.isWork == 'Y') {
								career += '		<span>'+item.joinMonth+'.'+item.joinYear+'</span>';
							} else {
								career += '		<span>'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
							}
							career += '	</div>';
							career += '	<div class="info-area">';
							career += '		<span class="name">'+item.company+'</span>';
							career += '		<span class="position">'+item.position+'</span>';
							career += '		<div class="content">';
							career += '			<p style="white-space: pre-line;">'+item.jobContents+'</p>';
							career += '		</div>';
							career += '	</div>';
							career += '</li>';
						}
						return true;
					});
					$('div.resume-career.template1.career').show();
					$('ul.list.template1.career').html(career);
				} else {
					$('div.resume-career.template1.career').hide();
				}

				//교육
				if(result.isEducationDisplay == 'N') {
					var educationList = result.educationList;
					var education = '';
					$.each(educationList, function(index, item) {
						if(item.isDelete == 'N' && item.isEducationDisplay == 'N') {
							education += '<li>';
							education += '	<div class="date">';
							if(item.isWork == 'Y') {
								education += '		<span>'+item.admissionMonth+'.'+item.admissionYear+'</span>';
							} else {
								education += '		<span>'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
							}
							education += '	</div>';
							education += '	<div class="info-area">';
							education += '		<span class="name">'+item.school+'</span>';
							education += '		<span class="position">'+item.major+'</span>';
							education += '	</div>';
							education += '</li>';
						}
						return true;
					});
					$('div.resume-career.template1.education').show();
					$('ul.list.template1.education').html(education);
				} else {
					$('div.resume-career.template1.education').hide();
				}

				//포트폴리오
				if(result.isQrPortfolioDisplay == 'N') {
					var qr = '';
					if(result.portfolioName == null) {
						qr += '<span class="name"></span>';
					} else {
						qr += '<span class="name">'+result.portfolioName+'</span>';
						qr += '<div id="qr-type1" class="qrcode"></div>';
					}
					$('div.resume-qr.template1.qr').show();
					$('div.info-area.template1').html(qr);
				} else {
					$('div.resume-qr.template1.qr').hide();
				}

				//qr코드
				//url예시 - http://clic-habilidades.org/iscream/selfrb
				//http://localhost:8080/studio/project/portfolioOthersMemberView?otherUserId=6571c845d7194ef38a4318ab5be71a07&otherEmail=jmh10243@naver.com&portfolioId=2&type=out&lang=en
				$('#qr-type1').qrcode({
					width: 150,
					height: 150,
					text: server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+ result.userId+"&otherEmail="+result.encryptEmail+"&portfolioId="+result.qrPortfolioId+"&type=out&lang=en"
				});	
				
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});

		setTimeout(function() {
			openModal('#layer-template1');
		}, 500);
		
	}

	//이력서 템플릿2
	function openTemplate2() {
		$.ajax({
			url: '/studio/resume/template',
			type: 'get',
			dataType: 'json',
			success: function(response){
				var result = response.data;

				//프로필
				var profile = '';
					profile += '<div class="info-area">';
					profile += '<span class="name">'+result.name+' '+result.firstName+'</span>';
					profile += '</div>';
					if(result.isPictureDisplay == 'N') {
						profile += '<div class="photo">';
						if(result.imagePath == '' || result.imagePath == null) {
							profile += '	<img src="'+result.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
						} else {
							profile += '	<img src="'+result.imagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
						}
						profile += '</div>';
					}
				$('div.resume-profile.template2').html(profile);
				var email = result.email;
				$('dd.template2.email').html(email);
				var tell = result.tell;
				$('dd.template2.tell').html(tell);
				//생년월일
				var year = '';
					if(result.isYearmonthdayDisplay == 'N' && result.isSexDisplay == 'N') {
						$('li.template2.year').show();
						year += '<li>'+result.day+'.'+result.month+'.'+result.year+'</li>';
						year += '<li>'+result.sex+'</li>';
					} else if(result.isYearmonthdayDisplay == 'Y' && result.isSexDisplay == 'N'){
						$('li.template2.year').show();
						year += '<li>'+result.sex+'</li>';
					} else if(result.isYearmonthdayDisplay == 'N' && result.isSexDisplay == 'Y'){
						$('li.template2.year').show();
						year += '<li>'+result.day+'.'+result.month+'.'+result.year+'</li>';
					} else {
						$('li.template2.year').hide();
					}
				$('ul.info-list.template2.year').html(year);
				//국가-도시
				if(result.isCountryDisplay == 'N') {
					var country = '';
						country += '<span class="country">';
						country += '	<img src="https://flagcdn.com/w640/'+result.countryCode.toLowerCase()+'.png" alt="">';
						country += '</span>';
						if(result.cityName == null || result.cityName == '') {
							$('li.template2.country').show();
							country += '<span class="capital"></span>';
						} else {
							$('li.template2.country').show();
							country += '<span class="capital">'+result.cityName+'</span>';
						}
					$('dd.template2.country').html(country);
				} else {
					$('li.template2.country').hide();
				}

				//자기소개
				if(result.isAboutMeDisplay == 'N') {
					var content = '';
					if(result.selfIntroduction == null) {
						content = '<p></p>';
					} else {
						content = '<p style="white-space: pre-line;">'+result.selfIntroduction+'</p>';
					}
					$('dl.resume-info-item.resume-self.template2.self').show();
					$('div.content.template2').html(content);
				} else {
					$('dl.resume-info-item.resume-self.template2.self').hide();
				}
				
				//경력
				if(result.isCareerDisplay == 'N') {
					var careerList = result.careerList;
					var career = '';
					$.each(careerList, function(index, item) {
						if(item.isDelete == 'N' && item.isCareerDisplay == 'N') {
							career += '<li>';
							career += '	<div class="date">';
							if(item.isWork == 'Y') {
								career += '		<span>'+item.joinMonth+'.'+item.joinYear+'</span>';
							} else {
								career += '		<span>'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
							}
							career += '	</div>';
							career += ' <div class="info-area">';
							career += '		<span class="name">';
							career += '			<em class="ico ico-resume-career2"></em>';
							career += 			item.company;
							career += '		</span>';
							career += '		<span class="position">'+item.position+'</span>';
							career += '	</div>';
							career += '	<div class="content">';
							career += '		<p style="white-space: pre-line;">'+item.jobContents+'</p>';
							career += '	</div>';
							career += '</li>';
						}
						return true;
					});
					$('dl.resume-info-item.resume-career.template2.career').show();
					$('ul.list.template2.career').html(career);
				} else {
					$('dl.resume-info-item.resume-career.template2.career').hide();
				}

				//교육
				if(result.isEducationDisplay == 'N') {
					var educationList = result.educationList;
					var education = '';
					$.each(educationList, function(index, item) {
						if(item.isDelete == 'N' && item.isEducationDisplay == 'N') {
							education += '<li>';
							education += '	<div class="date">';
							if(item.isWork == 'Y') {
								education += '		<span>'+item.admissionMonth+'.'+item.admissionYear+'</span>';
							} else {
								education += '		<span>'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
							}
							education += '	</div>';
							education += ' <div class="info-area">';
							education += '		<span class="name">';
							education += '			<em class="ico ico-resume-education2"></em>';
							education += 			item.school;
							education += '		</span>';
							education += '		<span class="position">'+item.major+'</span>';
							education += '	</div>';
							education += '</li>';
						}
						return true;
					});
					$('dl.resume-info-item.resume-career.resume-education.template2.education').show();
					$('ul.list.template2.education').html(education);
				} else {
					$('dl.resume-info-item.resume-career.resume-education.template2.education').hide();
				}

				//스킬
				if(result.isHaveSkillDisplay == 'N') {
					var skillList = result.skillList;
					var skill ='';
					$.each(skillList, function(index, item) {
						if(item.isDelete == 'N') {
							skill += '<li>';
							skill += '	<div class="level-title">';
							skill += '		<span class="name">'+item.skillName+'</span>';
							skill += '		<span class="level">'+item.levelName+'</span>';
							skill += '	</div>';
							skill += '	<div class="level-state">';
							skill += '		<div class="bar">';
							if(item.measureLevel == '1') {
								skill += '		<span class="fill" style="width: 20%;"></span>';
							} else if(item.measureLevel == '2') {
								skill += '		<span class="fill" style="width: 40%;"></span>';
							} else if(item.measureLevel == '3') {
								skill += '		<span class="fill" style="width: 60%;"></span>';
							} else if(item.measureLevel == '4') {
								skill += '		<span class="fill" style="width: 80%;"></span>';
							} else if(item.measureLevel == '5') {
								skill += '		<span class="fill" style="width: 100%;"></span>';
							}
							skill += '		</div>';
							skill += '	</div>';
							skill += '</li>';
						}
						return true;
					});
					$('dl.resume-info-item.resume-level.resume-skills.template2.skill').show();
					$('ul.list.template2.skill').html(skill);
				} else {
					$('dl.resume-info-item.resume-level.resume-skills.template2.skill').hide();
				}

				//프로그램
				if(result.isProgramDisplay == 'N') {
					var programList = result.programList;
					var program ='';
					$.each(programList, function(index, item) {
						if(item.isDelete == 'N') {
							program += '<li>';
							program += '	<div class="level-title">';
							if(item.program == '') {
								program += '		<span class="name">'+item.programingName+'</span>';
							} else {
								program += '		<span class="name">'+item.program+'</span>';
							}
							program += '		<span class="level">'+item.levelName+'</span>';
							program += '	</div>';
							program += '	<div class="level-state">';
							program += '		<div class="bar">';
							if(item.measureLevel == '1') {
								program += '		<span class="fill" style="width: 20%;"></span>';
							} else if(item.measureLevel == '2') {
								program += '		<span class="fill" style="width: 40%;"></span>';
							} else if(item.measureLevel == '3') {
								program += '		<span class="fill" style="width: 60%;"></span>';
							} else if(item.measureLevel == '4') {
								program += '		<span class="fill" style="width: 80%;"></span>';
							} else if(item.measureLevel == '5') {
								program += '		<span class="fill" style="width: 100%;"></span>';
							}
							program += '		</div>';
							program += '	</div>';
							program += '</li>';
						}
						return true;
					});
					$('dl.resume-info-item.resume-level.resume-program.template2.program').show();
					$('ul.list.template2.program').html(program);
				} else {
					$('dl.resume-info-item.resume-level.resume-program.template2.program').hide();
				}

				//언어
				if(result.isLangDisplay == 'N') {
					var langList = result.langList;
					var lan ='';
					$.each(langList, function(index, item) {
						if(item.isDelete == 'N') {
							lan += '<li>';
							lan += '	<div class="level-title">';
							if(item.langTitle == '') {
								lan += '		<span class="name">'+item.langName+'</span>';
							} else {
								lan += '		<span class="name">'+item.langTitle+'</span>';
							}
							lan += '		<span class="level">'+item.levelName+'</span>';
							lan += '	</div>';
							lan += '	<div class="level-state">';
							lan += '		<div class="bar">';
							if(item.measureLevel == '1') {
								lan += '		<span class="fill" style="width: 20%;"></span>';
							} else if(item.measureLevel == '2') {
								lan += '		<span class="fill" style="width: 40%;"></span>';
							} else if(item.measureLevel == '3') {
								lan += '		<span class="fill" style="width: 60%;"></span>';
							} else if(item.measureLevel == '4') {
								lan += '		<span class="fill" style="width: 80%;"></span>';
							} else if(item.measureLevel == '5') {
								lan += '		<span class="fill" style="width: 100%;"></span>';
							}
							lan += '		</div>';
							lan += '	</div>';
							lan += '</li>';
						}
						return true;
					});
					$('dl.resume-info-item.resume-level.resume-language.template2.lang').show();
					$('ul.list.template2.lang').html(lan);
				} else {
					$('dl.resume-info-item.resume-level.resume-language.template2.lang').hide();
				}

				//포트폴리오
				if(result.isQrPortfolioDisplay == 'N') {
					var qr = '';
					if(result.portfolioName == null) {
						qr += '<span class="name"></span>';
					} else {
						qr += '<div id="qr-type2" class="qrcode"></div>';
						qr += '<span class="name">'+result.portfolioName+'</span>';
					}
					$('dl.resume-info-item.resume-qr.template2.qr').show();
					$('div.info-area.template2').html(qr);
				} else {
					$('dl.resume-info-item.resume-qr.template2.qr').hide();
				}

				//qr코드
				//url예시 - http://clic-habilidades.org/iscream/selfrb
				$('#qr-type2').qrcode({
					width: 150,
					height: 150,
					text: server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+ result.userId+"&otherEmail="+result.encryptEmail+"&portfolioId="+result.qrPortfolioId+"&type=out&lang=en"
				});	
				
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
					
		setTimeout(function() {
			openModal('#layer-template2');
		}, 500);

	}

	//이력서 템플릿3
	function openTemplate3() {
			$.ajax({
				url: '/studio/resume/template',
				type: 'get',
				dataType: 'json',
				success: function(response){
					var result = response.data;

					//프로필
					var profile = '';
						if(result.isPictureDisplay == 'N') {
							profile += '<div class="photo">';
							if(result.imagePath == '' || result.imagePath == null) {
								profile += '	<img src="'+result.userImagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
							} else {
								profile += '	<img src="'+result.imagePath+'" onerror="this.src=\'/static/assets/images/common/img-sm-profile-default.png\'" alt="">';
							}
							profile += '</div>';
						}
						profile += '<span class="name">'+result.name+' '+result.firstName+'</span>';
					$('div.resume-profile.template3').html(profile);
					var year = '';
					if(result.isYearmonthdayDisplay == 'N') {
						$('li.template3.year').show();
						year = result.day+'.'+result.month+'.'+result.year;
					} else {
						$('li.template3.year').hide();
					}
					$('dd.template3.year').html(year);
					var sex = '';
					if(result.isSexDisplay == 'N') {
						$('li.template3.sex').show();
						sex = result.sex;
					} else {
						$('li.template3.sex').hide();
					}
					$('dd.template3.sex').html(sex);
					var email = result.email;
					$('dd.template3.email').html(email);
					var tell = result.tell;
					$('dd.template3.tell').html(tell);
					if(result.isCountryDisplay == 'N') {
						if(result.cityName == null || result.cityName == '') {
							$('li.template3.country').show();
							var country = result.countryName;
						} else {
							$('li.template3.country').show();
							var country = result.countryName+', '+result.cityName;
						}
					} else {
						$('li.template3.country').hide();
					}
					$('dd.template3.country').html(country);

					//포트폴리오
					if(result.isQrPortfolioDisplay == 'N') {
						var qr = '';
						if(result.portfolioName == null) {
							qr += '<span class="name"></span>';
						} else {
							qr += '<span class="name">'+result.portfolioName+'</span>';
							qr += '<div id="qr-type3" class="qrcode"></div>';
						}
						$('div.resume-qr.template3.qr').show();
						$('div.info-area.template3').html(qr);
						$('div.resume-career.template3.education').css('margin-left', '10%');
					} else {
						$('div.resume-qr.template3.qr').hide();
						$('div.resume-career.template3.education').css('margin-left', '37%');
					}

					//qr코드
					//url예시 - http://clic-habilidades.org/iscream/selfrb
					$('#qr-type3').qrcode({
						width: 150,
						height: 150,
						text: server[server.env]+"/studio/project/portfolioOthersMemberView?otherUserId="+ result.userId+"&otherEmail="+result.encryptEmail+"&portfolioId="+result.qrPortfolioId+"&type=out&lang=en"
					});	

					//자기소개
					if(result.isAboutMeDisplay == 'N') {
						var content = '';
						if(result.selfIntroduction == null) {
							content = '<p></p>';
						} else {
							content = '<p style="white-space: pre-line;">'+result.selfIntroduction+'</p>';
						}
						$('div.resume-self.template3.self').show();
						$('div.content.template3').html(content);
					} else {
						$('div.resume-self.template3.self').hide();
					}
	
					//경력
					if(result.isCareerDisplay == 'N') {
						var careerList = result.careerList;
						var career = '';
						$.each(careerList, function(index, item) {
							if(item.isDelete == 'N' && item.isCareerDisplay == 'N') {
								career += '<li>';
								career += '	<div class="date">';
								if(item.isWork == 'Y') {
									career += '		<span>'+item.joinMonth+'.'+item.joinYear+'</span>';
								} else {
									career += '		<span>'+item.joinMonth+'.'+item.joinYear+' ~ '+item.leaveMonth+'.'+item.leaveYear+'</span>';
								}
								career += '	</div>';
								career += ' <div class="info-area" style="padding-right: 3%;">';
								career += '		<span class="name">'+item.company+'</span>';
								career += '		<span class="position">'+item.position+'</span>';
								career += '	</div>';
								career += '	<div class="content">';
								career += '		<p style="white-space: pre-line;">'+item.jobContents+'</p>';
								career += '	</div>';
								career += '</li>';
							}
							return true;
						});
						$('div.resume-career.template3.career').show();
						$('ul.list.template3.career').html(career);
					} else {
						$('div.resume-career.template3.career').hide();
					}
					
					//교육
					if(result.isEducationDisplay == 'N') {
						var educationList = result.educationList;
						var education = '';
						$.each(educationList, function(index, item) {
							if(item.isDelete == 'N' && item.isEducationDisplay == 'N') {
								education += '<li>';
								education += '	<div class="date">';
								if(item.isWork == 'Y') {
									education += '		<span>'+item.admissionMonth+'.'+item.admissionYear+'</span>';
								} else {
									education += '		<span>'+item.admissionMonth+'.'+item.admissionYear+' ~ '+item.graduatedMonth+'.'+item.graduatedYear+'</span>';
								}
								education += '	</div>';
								education += '	<div class="info-area">';
								education += '		<span class="name">'+item.school+'</span>';
								education += '		<span class="position">'+item.major+'</span>';
								education += '	</div>';
								education += '</li>';
							}
							return true;
						});
						$('div.resume-career.template3.education').show();
						$('ul.list.template3.education').html(education);
					} else {
						$('div.resume-career.template3.education').hide();
					}
	
					//스킬
					if(result.isHaveSkillDisplay == 'N') {
						var skillList = result.skillList;
						var skill ='';
						$.each(skillList, function(index, item) {
							if(item.isDelete == 'N') {
								skill += '<li>';
								skill += '	<div class="level-title">';
								skill += '		<span class="name">'+item.skillName+'</span>';
								skill += '		<span class="level">'+item.levelName+'</span>';
								skill += '	</div>';
								skill += '	<ul class="level-state">';
								if(item.measureLevel == '1') {
									skill += '		<li class="on">Not Applicable</li>';
									skill += '		<li>Basic</li>';
									skill += '		<li>Intermediate</li>';
									skill += '		<li>Upper Intermediate</li>';
									skill += '		<li>Advanced</li>';
								} else if(item.measureLevel == '2') {
									skill += '		<li class="on">Not Applicable</li>';
									skill += '		<li class="on">Basic</li>';
									skill += '		<li>Intermediate</li>';
									skill += '		<li>Upper Intermediate</li>';
									skill += '		<li>Advanced</li>';
								} else if(item.measureLevel == '3') {
									skill += '		<li class="on">Not Applicable</li>';
									skill += '		<li class="on">Basic</li>';
									skill += '		<li class="on">Intermediate</li>';
									skill += '		<li>Upper Intermediate</li>';
									skill += '		<li>Advanced</li>';
								} else if(item.measureLevel == '4') {
									skill += '		<li class="on">Not Applicable</li>';
									skill += '		<li class="on">Basic</li>';
									skill += '		<li class="on">Intermediate</li>';
									skill += '		<li class="on">Upper Intermediate</li>';
									skill += '		<li>Advanced</li>';
								} else if(item.measureLevel == '5') {
									skill += '		<li class="on">Not Applicable</li>';
									skill += '		<li class="on">Basic</li>';
									skill += '		<li class="on">Intermediate</li>';
									skill += '		<li class="on">Upper Intermediate</li>';
									skill += '		<li class="on">Advanced</li>';
								}
								skill += '	</ul>';
								skill += '</li>';
							}
							return true;
						});
						$('div.resume-level.resume-skills.template3.skill').show();
						$('ul.list.template3.skill').html(skill);
					} else {
						$('div.resume-level.resume-skills.template3.skill').hide();
					}
	
					//프로그램
					if(result.isProgramDisplay == 'N') {
						var programList = result.programList;
						var program ='';
						$.each(programList, function(index, item) {
							if(item.isDelete == 'N') {
								program += '<li>';
								program += '	<div class="level-title">';
								if(item.program == '') {
									program += '		<span class="name">'+item.programingName+'</span>';
								} else {
									program += '		<span class="name">'+item.program+'</span>';
								}
								program += '		<span class="level">'+item.levelName+'</span>';
								program += '	</div>';
								program += '	<ul class="level-state">';
								if(item.measureLevel == '1') {
									program += '		<li class="on">Not Applicable</li>';
									program += '		<li>Basic</li>';
									program += '		<li>Intermediate</li>';
									program += '		<li>Upper Intermediate</li>';
									program += '		<li>Advanced</li>';
								} else if(item.measureLevel == '2') {
									program += '		<li class="on">Not Applicable</li>';
									program += '		<li class="on">Basic</li>';
									program += '		<li>Intermediate</li>';
									program += '		<li>Upper Intermediate</li>';
									program += '		<li>Advanced</li>';
								} else if(item.measureLevel == '3') {
									program += '		<li class="on">Not Applicable</li>';
									program += '		<li class="on">Basic</li>';
									program += '		<li class="on">Intermediate</li>';
									program += '		<li>Upper Intermediate</li>';
									program += '		<li>Advanced</li>';
								} else if(item.measureLevel == '4') {
									program += '		<li class="on">Not Applicable</li>';
									program += '		<li class="on">Basic</li>';
									program += '		<li class="on">Intermediate</li>';
									program += '		<li class="on">Upper Intermediate</li>';
									program += '		<li>Advanced</li>';
								} else if(item.measureLevel == '5') {
									program += '		<li class="on">Not Applicable</li>';
									program += '		<li class="on">Basic</li>';
									program += '		<li class="on">Intermediate</li>';
									program += '		<li class="on">Upper Intermediate</li>';
									program += '		<li class="on">Advanced</li>';
								}
								program += '	</ul>';
								program += '</li>';
							}
							return true;
						});
						$('div.resume-level.resume-program.template3.program').show();
						$('ul.list.template3.program').html(program);
					} else {
						$('div.resume-level.resume-program.template3.program').hide();
					}
	
					//언어
					if(result.isLangDisplay == 'N') {
						var langList = result.langList;
						var lan ='';
						$.each(langList, function(index, item) {
							if(item.isDelete == 'N') {
								lan += '<li>';
								lan += '	<div class="level-title">';
								if(item.langTitle == '') {
									lan += '		<span class="name">'+item.langName+'</span>';
								} else {
									lan += '		<span class="name">'+item.langTitle+'</span>';
								}
								lan += '		<span class="level">'+item.levelName+'</span>';
								lan += '	</div>';
								lan += '	<ul class="level-state">';
								if(item.measureLevel == '1') {
									lan += '		<li class="on">Not Applicable</li>';
									lan += '		<li>Basic</li>';
									lan += '		<li>Intermediate</li>';
									lan += '		<li>Upper Intermediate</li>';
									lan += '		<li>Advanced</li>';
								} else if(item.measureLevel == '2') {
									lan += '		<li class="on">Not Applicable</li>';
									lan += '		<li class="on">Basic</li>';
									lan += '		<li>Intermediate</li>';
									lan += '		<li>Upper Intermediate</li>';
									lan += '		<li>Advanced</li>';
								} else if(item.measureLevel == '3') {
									lan += '		<li class="on">Not Applicable</li>';
									lan += '		<li class="on">Basic</li>';
									lan += '		<li class="on">Intermediate</li>';
									lan += '		<li>Upper Intermediate</li>';
									lan += '		<li>Advanced</li>';
								} else if(item.measureLevel == '4') {
									lan += '		<li class="on">Not Applicable</li>';
									lan += '		<li class="on">Basic</li>';
									lan += '		<li class="on">Intermediate</li>';
									lan += '		<li class="on">Upper Intermediate</li>';
									lan += '		<li>Advanced</li>';
								} else if(item.measureLevel == '5') {
									lan += '		<li class="on">Not Applicable</li>';
									lan += '		<li class="on">Basic</li>';
									lan += '		<li class="on">Intermediate</li>';
									lan += '		<li class="on">Upper Intermediate</li>';
									lan += '		<li class="on">Advanced</li>';
								}
								lan += '	</ul>';
								lan += '</li>';
							}
							return true;
						});
						$('div.resume-level.resume-language.template3.lang').show();
						$('ul.list.template3.lang').html(lan);
					} else {
						$('div.resume-level.resume-language.template3.lang').hide();
					}
					
				},
				error : function(xhr, status) {
		               console.log(xhr + " : " + status);
		         }
			});

		setTimeout(function() {
			openModal('#layer-template3');
		}, 500);
		
	}

	var renderedImg = new Array;

	var contWidth = 200, // 너비(mm) (a4에 맞춤)
	    padding = 5; //상하좌우 여백(mm)

	function createPdf(code, value) { //이미지를 pdf로 만들기
	  var lists = document.querySelectorAll("."+code),
	      deferreds = [],
	      doc = new jsPDF("p", "mm", "a4"),
	      listsLeng = lists.length;

	  for (var i = 0; i < listsLeng; i++) { // template1Pdf 적용된 태그 개수만큼 이미지 생성
	    var deferred = $.Deferred();
	    deferreds.push(deferred.promise());
	    generateCanvas(i, doc, deferred, lists[i]);
	  }

	  $.when.apply($, deferreds).then(function () { // 이미지 렌더링이 끝난 후
	    var sorted = renderedImg.sort(function(a,b){return a.num < b.num ? -1 : 1;}), // 순서대로 정렬
	        curHeight = padding, //위 여백 (이미지가 들어가기 시작할 y축)
	        sortedLeng = sorted.length;

	    for (var i = 0; i < sortedLeng; i++) {
	      var sortedHeight = sorted[i].height, //이미지 높이
	          sortedImage = sorted[i].image; //이미지

	      if( curHeight + sortedHeight > 297 - padding * 2 ){ // a4 높이에 맞게 남은 공간이 이미지높이보다 작을 경우 페이지 추가
	        doc.addPage(); // 페이지를 추가함
	        curHeight = padding; // 이미지가 들어갈 y축을 초기 여백값으로 초기화
	        doc.addImage(sortedImage, 'jpeg', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
	        curHeight += sortedHeight; // y축 = 여백 + 새로 들어간 이미지 높이
	      } else { // 페이지에 남은 공간보다 이미지가 작으면 페이지 추가하지 않음
	        doc.addImage(sortedImage, 'jpeg', padding , curHeight, contWidth, sortedHeight); //이미지 넣기
	        curHeight += sortedHeight; // y축 = 기존y축 + 새로들어간 이미지 높이
	      }
	    }
	    doc.save('resume_template'+value+'.pdf'); //pdf 저장

	    curHeight = padding; //y축 초기화
	    renderedImg = new Array; //이미지 배열 초기화
	  });
	}

	function generateCanvas(i, doc, deferred, curList){ //페이지를 이미지로 만들기
	  var pdfWidth = $(curList).outerWidth() * 0.2645, //px -> mm로 변환
	      pdfHeight = $(curList).outerHeight() * 0.2645,
	      heightCalc = contWidth * pdfHeight / pdfWidth; //비율에 맞게 높이 조절
	  html2canvas( curList, {
		background: '#fff', useCORS : true
	  }).then(
	    function (canvas) {
	      var img = canvas.toDataURL('image/jpeg', 1.0); //이미지 형식 지정
	      renderedImg.push({num:i, image:img, height:heightCalc}); //renderedImg 배열에 이미지 데이터 저장(뒤죽박죽 방지)     
	      deferred.resolve(); //결과 보내기
	    });
	}

	//template1 pdf 다운로드
	function downloadPdf1() {
		$('.template1Pdf').css('padding-bottom', '50px');
		createPdf('template1Pdf', '1');
		$('.template1Pdf').css('padding-bottom', '');
	}

	//template2 pdf 다운로드
	function downloadPdf2() {
		$('.template2Pdf').css('background','linear-gradient(to right, #fed000 20%, #ffffff 20%, #ffffff 20%, #ffffff 20%, #ffffff 20%)');
		$('.template2Pdf').css('padding-bottom', '50px');
		createPdf('template2Pdf', '2');
		$('.template2Pdf').css('background','');
		$('.template2Pdf').css('padding-bottom', '');
	}

	//template3 pdf 다운로드
	function downloadPdf3() {
		$('.template3Pdf').css('background','linear-gradient(to right, #fafafc 33.3333333%, #ffffff 33.3333333%, #ffffff 33.3333333%)');
		$('.template3Pdf').css('padding-bottom', '50px');
		createPdf('template3Pdf', '3');
		$('.template3Pdf').css('background','');
		$('.template3Pdf').css('padding-bottom', '');
	}

	//화면 상단에 있는 이력서 미리보기
	function openTemplate() {
		$.ajax({
			url: '/studio/resume/template',
			type: 'get',
			dataType: 'json',
			success: function(response){
				var resumeTemplateCode = response.data.resumeTemplateCode;
				if(resumeTemplateCode == '' || resumeTemplateCode == '1601') {
					setTimeout(function() {
						openTemplate1();
					}, 500);
				} else if(resumeTemplateCode == '1602') {
					setTimeout(function() {
						openTemplate2();
					}, 500);
				} else if(resumeTemplateCode == '1603') {
					setTimeout(function() {
						openTemplate3();
					}, 500);
					
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	//상단 pdf버튼 눌렀을 때 
	function downloadPdf() {
		$.ajax({
			url: '/studio/resume/template',
			type: 'get',
			dataType: 'json',
			success: function(response){
				var resumeTemplateCode = response.data.resumeTemplateCode;
				if(resumeTemplateCode == '' || resumeTemplateCode == '1601') {
					setTimeout(function() {
						openTemplate1();
					}, 500);
					setTimeout(function() {
						downloadPdf1();
					}, 1500);
				} else if(resumeTemplateCode == '1602') {
					setTimeout(function() {
						openTemplate2();
					}, 500);
					setTimeout(function() {
						downloadPdf2();
					}, 1500);
				} else if(resumeTemplateCode == '1603') {
					setTimeout(function() {
						openTemplate3();
					}, 500);
					setTimeout(function() {
						downloadPdf3();
					}, 1500);
				}
			},
			error : function(xhr, status) {
	               console.log(xhr + " : " + status);
	         }
		});
	}

	function fnAddBlank() {
		$('dl.resume-info-item.resume-qr.template2.qr').before('<br class="qrBlank">');
		$('div.resume-qr.template1.qr.template1Pdf').before('<br class="qrBlank">');
		alert('<spring:message code="resume.alert.add" text="공백이 추가되었습니다." />');
	}

	function fnRemoveBlank() {
		if(confirm('<spring:message code="resume.alert.reset" text="초기화 하시겠습니까?" />') == true) {
			$('br.qrBlank').remove();
		} else {
			return false;
		}
		
	}
	</script>
</head>

<body>
	<div class="wrapper">
		
		<!-- header Start -->
		<jsp:include page="../common/header.jsp"></jsp:include>
		<!-- header End -->
				
		<div id="container">
			<aside id="sidebar">
				<%@ include file="../common/side-profile.jsp" %>
				<form action="#" id="infoCkForm">
				<input type="hidden" id="infoCkResumeId" name="resumeId" value="">
					<dl class="total-info info-setting">
						<dt class="title"><spring:message code="resume.text4" text="Información Personal para incluir en tu currículo" /></dt>
						<dd class="content">
							<ul class="list">
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck1_1" name="isPictureDisplay" onclick="isInfoCheck();">
										<label for="inputCheck1_1"><spring:message code="resume.text6" text="Foto" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck1_2" name="isYearmonthdayDisplay" onclick="isInfoCheck();">
										<label for="inputCheck1_2"><spring:message code="contact.text.10" text="Fecha de nacimiento" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck1_3" name="isSexDisplay" onclick="isInfoCheck();">
										<label for="inputCheck1_3"><spring:message code="contact.text.12" text="Sexo" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
									<input type="checkbox" id="inputCheck1_4" name="isCountryDisplay" onclick="isInfoCheck();">
									<label for="inputCheck1_4"><spring:message code="contact.text.11" text="Nacionalidad" /></label>
									</span>
								</li>
							</ul>
						</dd>
						<dt class="title"><spring:message code="resume.text7" text="Información" /></dt>
						<dd class="content">
							<ul class="list">
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_1" name="isAboutMeDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_1"><spring:message code="resume.self" text="Acerca de mi" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_2" name="isCareerDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_2"><spring:message code="resume.career1" text="Experiencia Laboral" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_3" name="isEducationDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_3"><spring:message code="resume.education1" text="Educación" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_4" name="isHaveSkillDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_4"><spring:message code="resume.have-skill1" text="Habilidades y competencias" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_5" name="isProgramDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_5"><spring:message code="resume.program1" text="Programas" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_6" name="isLangDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_6"><spring:message code="resume.language1" text="Idiomas" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" id="inputCheck2_7" name="isQrPortfolioDisplay" onclick="isInfoCheck();">
										<label for="inputCheck2_7"><spring:message code="resume.portfolio1" text="QR portafolio" /></label>
									</span>
								</li>
							</ul>
						</dd>
					</dl>
				</form>
			</aside>
			<article id="content">
				<h2 class="content-title"><spring:message code="menu7-1" text="Mi Currículo" /></h2>
				<div class="resume-wrap">
					<div class="resume-ctrl">
						<div class="left">
							<a href="javascript:;" class="btn btn-sm btn-outline-gray btn-expose d-down-md" onclick="regExposePopup();"><spring:message code="resume.text3" text="Exposición" /></a>
							<a href="javascript:;" class="btn btn-sm btn-outline-gray btn-preview" onclick="openTemplate();"><spring:message code="resume.text9" text="Avance" /></a>
						</div>
						<div class="right">
							<a href="javascript:;" class="btn btn-sm btn-primary btn-down template" onclick="downloadPdf();"><spring:message code="button.download.pdf" text="PDF Descargar" /></a>
						</div>
					</div>

					<div class="personal-info">
						<h3 class="title1 d-up-lg"><spring:message code="resume.text5" text="Intimidad" /></h3>
						<div class="info-area">
							<div class="profile-area">
								<div class="profile-frame">
									<div class="photo mainpage"></div>
									<label for="lb_upload" class="btn-upload">Photo upload</label>
									<form id="img_upload">
										<input type="hidden" id="photoResumeId" name="resumeId" value="">
										<input type="file" id="lb_upload"  onChange="uploadFile()" name="filename" accept="*">
									</form>
								</div>
							</div>
							<div class="profile-info">
								<dl class="item">
									<dt class="mainpage name"><spring:message code="resume.text15" text="Nombre" /></dt>
								</dl>
								<dl class="item">
									<dt class="mainpage birth"><spring:message code="contact.text.10" text="Fecha De Nacimiento" /></dt>
								</dl>
								<dl class="item">
									<dt class="mainpage gender"><spring:message code="contact.text.12" text="Sexo" /></dt>
								</dl>
								<dl class="item">
									<dt class="mainpage email"><spring:message code="contact.text.4" text="E-mail" /></dt>
								</dl>
								<dl class="item">
									<dt class="mainpage tell"><spring:message code="contact.text.13" text="Teléfono De Contacto" /></dt>
								</dl>
								<dl class="item">
									<dt class="mainpage country"><spring:message code="contact.text.11" text="Nacionalidad" /></dt>
								</dl>
							</div>
						</div>
					</div>

					<div class="resume-info">
						<div class="item">
							<div class="self-intro">
								<div id="selfBottom" class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.self" text="Acerca de mi" /></h3>
									</div>
									<div class="right">
										<!-- 수정, 삭제 -->
										<div class="info-ctrl myself"></div>
										<!-- // 수정, 삭제 -->
									</div>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="career-info">
								<div id="careerBottom" class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.career1" text="Experiencia Laboral" /></h3>
									</div>
									<div class="right">
										<a href="javascript:;" class="btn btn-md btn-secondary btn-register" onclick="regCareerPopup();">
											<spring:message code="resume.text1" text="Agregar" /><em class="ico ico-plus-white ml-1"></em>
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="education-info">
								<div id="educationBottom" class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.education1" text="Educación" /></h3>
									</div>
									<div class="right">
										<a href="javascript:;" class="btn btn-md btn-secondary btn-register" onclick="regEducationPopup();">
											<spring:message code="resume.text1" text="Agregar" /><em class="ico ico-plus-white ml-1"></em>
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="skills-info">
								<div id="skillBottom" class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.have-skill1" text="Habilidades y competencias" /></h3>
									</div>
									<input type="hidden" id="skillCkResumeId" name="resumeId" value="">
									<div id="regSkillBottom" class="right">
										<a href="javascript:;" class="btn btn-md btn-secondary btn-register" onclick="skillCheck();">
											<spring:message code="resume.text1" text="Agregar" /><em class="ico ico-plus-white ml-1"></em>
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="program-info">
								<div id="programBottom" class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.program1" text="Programas" /></h3>
									</div>
									<div class="right">
										<a href="javascript:;" class="btn btn-md btn-secondary btn-register" onclick="regProgramPopup();">
											<spring:message code="resume.text1" text="Agregar" /><em class="ico ico-plus-white ml-1"></em>
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="language-info">
								<div id="langBottom" class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.language1" text="Idiomas" /></h3>
									</div>
									<div class="right">
										<a href="javascript:;" class="btn btn-md btn-secondary btn-register" onclick="regLanguagePopup();">
											<spring:message code="resume.text1" text="Agregar" /><em class="ico ico-plus-white ml-1"></em>
										</a>
									</div>
								</div>
							</div>
						</div>
						<div class="item">
							<div style="display: flex; justify-content: flex-end; padding-bottom: 10px;">
								<div class="right">
									<a href="javascript:;" class="btn btn-md btn-secondary btn-register" style="min-width: 75px;" onclick="fnAddBlank();">
										<p style="color: white; font-size: 14px;"><spring:message code="button.add" text="Add" /></p>
									</a>
								</div>
								<div class="right" style="margin-left: 3px;">
									<a href="javascript:;" class="btn btn-md btn-primary btn-down template" style="min-width: 75px;" onclick="fnRemoveBlank();">
										<p style="color: white; font-size: 14px;"><spring:message code="button.reset" text="Reset" /></p>
									</a>
								</div>
							</div>
							<div class="qr-portfolio">
								<div class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.portfolio1" text="QR portafolio" /></h3>
									</div>
									<input type="hidden" name="portfolioId" value="">
									<input type="hidden" name="portfolioName" value="">
									<div id="portfolioBottom" class="right"></div>
								</div>
							</div>
						</div>
						<div class="item">
							<div class="resume-template">
								<div class="info-top">
									<div class="left">
										<h3 class="title1"><spring:message code="resume.template" text="Formato de diseño de currículum" /></h3>
									</div>
								</div>
								<div class="info-area">
									<ul class="list">
										<li>
											<span class="check-item">
												<input type="radio" name="resumeTemplateCode" id="inputRadio1_1" onclick="isTemplateCk();">
												<label for="inputRadio1_1">
													<a href="javascript:;" class="image-wrap" onclick="openTemplate1(); templateResize();">
														<img src="/static/assets/images/content/img-resume1.png" alt="">
													</a>
													<span class="title"><spring:message code="resume.text16" text="TYPE 1" /></span>
												</label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" name="resumeTemplateCode" id="inputRadio1_2" onclick="isTemplateCk();">
												<label for="inputRadio1_2">
													<a href="javascript:;" class="image-wrap" onclick="openTemplate2(); templateResize();">
														<img src="/static/assets/images/content/img-resume2.png" alt="">
													</a>
													<span class="title"><spring:message code="resume.text17" text="TYPE 2" /></span>
												</label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" name="resumeTemplateCode" id="inputRadio1_3" onclick="isTemplateCk();">
												<label for="inputRadio1_3">
													<a href="javascript:;" class="image-wrap" onclick="openTemplate3(); templateResize();">
														<img src="/static/assets/images/content/img-resume3.png" alt="">
													</a>
													<span class="title"><spring:message code="resume.text18" text="TYPE 3" /></span>
												</label>
											</span>
										</li>
									</ul>
								</div>
							</div>
						</div>
					</div>
				</div>
			</article>
		</div>
		
		<!-- footer Start -->	
		<jsp:include page="../common/footer.jsp"></jsp:include>
		<!-- footer End -->		
	</div>
	
	<!-- 레이어팝업 -->
	<div class="modal-popup modal-md2 hide" id="layer-self">
		<div class="dimed"></div>
		<input type="hidden" id="selfResumeId" name="resumeId" value="">
		<form action="#">
			<div class="popup-inner popup-self">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="resume.self" text="Acerca de mi" /></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-self');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="sr-only"><label for="lb_intro">Acerca de mi</label></dt>
								<dd>
									<textarea id="lb_intro" class="form-control selfIntro" placeholder="placeholder" name="selfIntroduction"></textarea>
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-self');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button type="button" id="editSelfBtn" onclick="selfEditForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
					</div>
				</div>
			</div>
		</form>
	</div>
	
	<!-- 레이어팝업 -->
	<div class="modal-popup modal-md2 hide" id="layer-career">
		<div class="dimed"></div>
		<input type="hidden" id="careerResumeId" name="resumeId" value="">
		<input type="hidden" name="joinYear" value="">
		<input type="hidden" name="joinMonth" value="">
		<input type="hidden" name="leaveYear" value="">
		<input type="hidden" name="leaveMonth" value="">
		<input type="hidden" name="isDelete" value="N">
		<input type="hidden" name="resumeCareerMattersId" value="">
		<div class="popup-inner popup-career">
			<div class="popup-header">
				<h2 class="popup-title"><spring:message code="resume.career1" text="Experiencia Laboral" /></h2>
				<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-career');">Close</button>
			</div>
			<div class="popup-body">
				<div class="form-area style2">
					<div class="form-item">
						<dl class="form-group">
							<dt class="title2 mt-0"><label for="lb_company"><spring:message code="resume.career2" text="Nombre De Empresa" />*</label></dt>
							<dd>
								<input type="text" id="lb_company" class="form-control" name="company" value="">
							</dd>
						</dl>
					</div>
					<div class="form-item">
						<dl class="form-group">
							<dt class="title2"><label for="lb_position"><spring:message code="resume.career3" text="Rango" />*</label></dt>
							<dd>
								<input type="text" id="lb_position" class="form-control" name="position">
							</dd>
						</dl>
					</div>
					<div class="form-item">
						<dl class="form-group">
							<dt class="title2"><spring:message code="resume.career4" text="Entrar" />*</dt>
							<dd>
								<div class="form-row">
									<div class="input-item">
										<dl class="dropdown-select always career">
											<dt><a href="javascript:;" class="btn joinMonth">Mes</a></dt>
											<dd style="bottom: -500px;"><!-- // bottom: -{레이어 높이값}px 변경 -->
												<div class="dimed"></div>
												<div class="dropdown-inner custom-scroll" style="height: 500px;"><!-- // height: {레이어 높이값}px 변경 -->
													<span class="dropdown-title"><spring:message code="resume.text11" text="Mes" /></span>
													<ul class="dropdown-list" id="joinMonth"><!-- // 선택된 항목 클래스 .on 추가 -->
													</ul>
												</div>
											</dd>
										</dl>
									</div>
									<div class="input-item">
										<dl class="dropdown-select always career">
											<dt><a href="javascript:;" class="btn joinYear">Año</a></dt>
											<dd style="bottom: -500px;">
												<div class="dimed"></div>
												<div class="dropdown-inner custom-scroll" style="height: 500px;">
													<span class="dropdown-title"><spring:message code="resume.text10" text="Año" /></span>
													<ul class="dropdown-list" id="joinYear"><!-- // 선택된 항목 클래스 .on 추가 -->
													</ul>
												</div>
											</dd>
										</dl>
									</div>
								</div>
							</dd>
						</dl>
						<dl class="form-group">
							<dt class="title2">
								<span class="clearfix">
									<span class="float-left"><spring:message code="resume.career5" text="Licencia" />*</span>
									<span class="float-right check-item">
										<input type="checkbox" id="inputCheck3" name="isWork" onclick="isWorkCheck();">
										<label for="inputCheck3"><spring:message code="resume.career7" text="Actualmente trabajando" /></label>
									</span>
								</span>
							</dt>
							<dd>
								<div class="form-row">
									<div class="input-item">
										<dl class="dropdown-select career">
											<dt><a href="javascript:;" class="btn leaveMonth">Mes</a></dt>
											<dd style="bottom: -500px;">
												<div class="dimed"></div>
												<div class="dropdown-inner custom-scroll" style="height: 500px;">
													<span class="dropdown-title"><spring:message code="resume.text11" text="Mes" /></span>
													<ul class="dropdown-list" id="leaveMonth"><!-- // 선택된 항목 클래스 .on 추가 -->
													</ul>
												</div>
											</dd>
										</dl>
									</div>
									<div class="input-item">
										<dl class="dropdown-select career">
											<dt><a href="javascript:;" class="btn leaveYear">Año</a></dt>
											<dd style="bottom: -500px;">
												<div class="dimed"></div>
												<div class="dropdown-inner custom-scroll" style="height: 500px;">
													<span class="dropdown-title"><spring:message code="resume.text10" text="Año" /></span>
													<ul class="dropdown-list" id="leaveYear"><!-- // 선택된 항목 클래스 .on 추가 -->
													</ul>
												</div>
											</dd>
										</dl>
									</div>
								</div>
							</dd>
						</dl>
					</div>
					<div class="form-item">
						<dl class="form-group">
							<dt class="title2"><label for="lb_content"><spring:message code="resume.career6" text="Información de negocios" /></label></dt>
							<dd>
								<textarea id="lb_content" class="form-control" rows="5" placeholder="placeholder" name="jobContents"></textarea>
							</dd>
						</dl>
					</div>
				</div>
			</div>
			<div class="popup-footer">
				<div class="btn-group-default btn-fixed">
					<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-career');"><spring:message code="button.cancel" text="cancelar" /></a>
					<button id="createCareerBtn" type="button" onclick="careerCreateForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
					<button id="editCareerBtn" type="button" onclick="careerEditForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
				</div>
			</div>
		</div>
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-education">
		<div class="dimed"></div>
		<input type="hidden" id="eduResumeId" name="resumeId" value="">
		<input type="hidden" name="admissionYear" value="">
		<input type="hidden" name="admissionMonth" value="">
		<input type="hidden" name="graduatedYear" value="">
		<input type="hidden" name="graduatedMonth" value="">
		<input type="hidden" name="resumeEducationId" value="">
		<form action="#">
			<div class="popup-inner popup-education">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="resume.education1" text="Educación" /></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-education');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="lb_school"><spring:message code="resume.education2" text="Nombre De Escuela" />*</label></dt>
								<dd>
									<input type="text" id="lb_school" class="form-control" name="school">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><label for="lb_major"><spring:message code="resume.education3" text="Importante" />*</label></dt>
								<dd>
									<input type="text" id="lb_major" class="form-control" name="major">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><spring:message code="resume.education4" text="Admisión" />*</dt>
								<dd>
									<div class="form-row">
										<div class="input-item">
											<dl class="dropdown-select up always">
												<dt><a href="javascript:;" class="btn admissionMonth">Mes</a></dt>
												<dd style="bottom: -500px;"><!-- // bottom: -{레이어 높이값}px 변경 -->
													<div class="dimed"></div>
													<div class="dropdown-inner custom-scroll" style="height: 500px;"><!-- // height: {레이어 높이값}px 변경 -->
														<span class="dropdown-title"><spring:message code="resume.text11" text="Mes" /></span>
														<ul class="dropdown-list" id="admissionMonth">
														</ul>
													</div>
												</dd>
											</dl>
										</div>
										<div class="input-item">
											<dl class="dropdown-select up always">
												<dt><a href="javascript:;" class="btn admissionYear">Año</a></dt>
												<dd style="bottom: -500px;">
													<div class="dimed"></div>
													<div class="dropdown-inner custom-scroll" style="height: 500px;">
														<span class="dropdown-title"><spring:message code="resume.text10" text="Año" /></span>
														<ul class="dropdown-list" id="admissionYear">
														</ul>
													</div>
												</dd>
											</dl>
										</div>
									</div>
								</dd>
							</dl>
							<dl class="form-group">
								<dt class="title2">
									<span class="clearfix">
										<span class="float-left"><spring:message code="resume.education5" text="Graduado" />*</span>
										<span class="float-right check-item">
											<input type="checkbox" id="inputCheck4" name="isWork" onclick="isWorkCheck();">
											<label for="inputCheck4"><spring:message code="resume.education6" text="Actualmente asistiendo" /></label>
										</span>
									</span>
								</dt>
								<dd>
									<div class="form-row">
										<div class="input-item">
											<dl class="dropdown-select up">
												<dt><a href="javascript:;" class="btn graduatedMonth">Mes</a></dt>
												<dd style="bottom: -500px;">
													<div class="dimed"></div>
													<div class="dropdown-inner custom-scroll" style="height: 500px;">
														<span class="dropdown-title"><spring:message code="resume.text11" text="Mes" /></span>
														<ul class="dropdown-list" id="graduatedMonth">
														</ul>
													</div>
												</dd>
											</dl>
										</div>
										<div class="input-item">
											<dl class="dropdown-select up">
												<dt><a href="javascript:;" class="btn graduatedYear">Año</a></dt>
												<dd style="bottom: -500px;">
													<div class="dimed"></div>
													<div class="dropdown-inner custom-scroll" style="height: 500px;">
														<span class="dropdown-title"><spring:message code="resume.text10" text="Año" /></span>
														<ul class="dropdown-list" id="graduatedYear">
														</ul>
													</div>
												</dd>
											</dl>
										</div>
									</div>
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-education');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button id="createEducationBtn" type="button" onclick="educationCreateForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
						<button id="editEducationBtn" type="button" onclick="educationEditForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
					</div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="modal-popup modal-md2 hide" id="layer-skills">
		<div class="dimed"></div>
		<input type="hidden" id="skillResumeId" name="resumeId" value="">
		<input type="hidden" name="resumeHaveSkillId" value="">
		<input type="hidden" class="skill" name="measureTypeCode" value="2304">
		<form action="#">
			<div class="popup-inner popup-skills">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="resume.have-skill1" text="Habilidades y competencias" /></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-skills');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><label for="lb_name"><spring:message code="resume.have-skill2" text="Nombre de la habilidad" />*</label></dt>
								<dd>
									<input type="text" class="form-control" id="lb_name" name="skillName">
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><spring:message code="resume.program3" text="capacidad de usar" />*</dt>
								<dd>
									<ul class="level-check">
										<li>
											<span class="check-item">
												<input type="radio" class="skill" name="measureLevel" id="inputLevel1_1">
												<label for="inputLevel1_1"><spring:message code="resume.skill1" text="Not applicable" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="skill" name="measureLevel" id="inputLevel1_2">
												<label for="inputLevel1_2"><spring:message code="resume.skill2" text="Basic" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="skill" name="measureLevel" id="inputLevel1_3">
												<label for="inputLevel1_3"><spring:message code="resume.skill3" text="Intermediate" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="skill" name="measureLevel" id="inputLevel1_4">
												<label for="inputLevel1_4"><spring:message code="resume.skill4" text="Upper intermediate" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="skill" name="measureLevel" id="inputLevel1_5">
												<label for="inputLevel1_5"><spring:message code="resume.skill5" text="Advanced" /></label>
											</span>
										</li>
									</ul>
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-skills');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button id="createSkillBtn" type="button" onclick="skillCreateForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
						<button id="editSkillBtn" type="button" onclick="skillEditForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-program">
		<div class="dimed"></div>
		<input type="hidden" id="proResumeId" name="resumeId" value="">
		<input type="hidden" name="programingNameEng" value="">
		<input type="hidden" name="programingId" value="">
		<input type="hidden" name="resumeProgramId" value="">
		<input type="hidden" name="isDelete" value="">
		<input type="hidden" class="program" name="measureTypeCode" value="2305">
		<input type="hidden" name="preProgramingId" value="">
		<input type="hidden" name="preProgram" value="">
		<form action="#">
			<div class="popup-inner popup-program">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="resume.program1" text="Programas" /></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-program');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><spring:message code="resume.program2" text="Nombre del programa" />*</dt>
								<dd>
									<div style="width: 100%;">
										<dl class="dropdown-select program">
											<dt><a href="javascript:;" class="btn programingNameEng">Seleccionar</a></dt>
											<dd style="bottom: -500px;"><!-- // bottom: -{레이어 높이값}px 변경 -->
												<div class="dimed"></div>
												<div class="dropdown-inner custom-scroll" style="height: 500px;"><!-- // height: {레이어 높이값}px 변경 -->
													<span class="dropdown-title"><spring:message code="resume.program2" text="Nombre del programa" /></span>
													<ul class="dropdown-list programingList"></ul>
												</div>
											</dd>
										</dl>
										<!-- 직접 입력 선택 시 노출 -->
										<input type="text" class="form-control mt-2 programInput" name="program">
										<!-- // 직접 입력 선택 시 노출 -->
									</div>
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><spring:message code="resume.program3" text="capacidad de usar" />*</dt>
								<dd>
									<ul class="level-check">
										<li>
											<span class="check-item">
												<input type="radio" class="program" name="measureLevel" id="inputLevel6_1">
												<label for="inputLevel6_1"><spring:message code="resume.skill1" text="Not applicable" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="program" name="measureLevel" id="inputLevel6_2">
												<label for="inputLevel6_2"><spring:message code="resume.skill2" text="Basic" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="program" name="measureLevel" id="inputLevel6_3">
												<label for="inputLevel6_3"><spring:message code="resume.skill3" text="Intermediate" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="program" name="measureLevel" id="inputLevel6_4">
												<label for="inputLevel6_4"><spring:message code="resume.skill4" text="Upper intermediate" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="program" name="measureLevel" id="inputLevel6_5">
												<label for="inputLevel6_5"><spring:message code="resume.skill5" text="Advanced" /></label>
											</span>
										</li>
									</ul>
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-program');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button id="createProgramBtn" type="button" onclick="programCheckForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
						<button id="editProgramBtn" type="button" onclick="programCheckForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div class="modal-popup modal-md2 hide" id="layer-language">
		<div class="dimed"></div>
		<input type="hidden" id="langResumeId" name="resumeId" value="">
		<input type="hidden" name="langNameEng" value="">
		<input type="hidden" name="langId" value="">
		<input type="hidden" name="resumeLangId" value="">
		<input type="hidden" name="isDelete" value="">
		<input type="hidden" class="lang" name="measureTypeCode" value="2306">
		<input type="hidden" name="preLangId" value="">
		<input type="hidden" name="preLang" value="">
		<form action="#">
			<div class="popup-inner popup-language">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="resume.language1" text="Idiomas" /></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-language');">Close</button>
				</div>
				<div class="popup-body">
					<div class="form-area style2">
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2 mt-0"><spring:message code="resume.language2" text="Nombre del idiomas" />*</dt>
								<dd>
									<div style="width: 100%;">
										<dl class="dropdown-select lang">
											<dt><a href="javascript:;" class="btn langNameEng">Seleccionar</a></dt>
											<dd style="bottom: -500px;"><!-- // bottom: -{레이어 높이값}px 변경 -->
												<div class="dimed"></div>
												<div class="dropdown-inner custom-scroll" style="height: 500px;"><!-- // height: {레이어 높이값}px 변경 -->
													<span class="dropdown-title"><spring:message code="resume.language2" text="Nombre del idiomas" /></span>
													<ul class="dropdown-list languageList"></ul>
												</div>
											</dd>
										</dl>
									<!-- 직접 입력 선택 시 노출 -->
										<input type="text" class="form-control mt-2 languageInput" name="langTitle">
									<!-- // 직접 입력 선택 시 노출 -->
									</div>
								</dd>
							</dl>
						</div>
						<div class="form-item">
							<dl class="form-group">
								<dt class="title2"><spring:message code="resume.language3" text="capacidad de usar" />*</dt>
								<dd>
									<ul class="level-check">
										<li>
											<span class="check-item">
												<input type="radio" class="lang" name="measureLevel" id="inputLevel7_1">
												<label for="inputLevel7_1"><spring:message code="resume.skill1" text="Not applicable" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="lang" name="measureLevel" id="inputLevel7_2">
												<label for="inputLevel7_2"><spring:message code="resume.skill2" text="Basic" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="lang" name="measureLevel" id="inputLevel7_3">
												<label for="inputLevel7_3"><spring:message code="resume.skill3" text="Intermediate" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="lang" name="measureLevel" id="inputLevel7_4">
												<label for="inputLevel7_4"><spring:message code="resume.skill4" text="Upper intermediate" /></label>
											</span>
										</li>
										<li>
											<span class="check-item">
												<input type="radio" class="lang" name="measureLevel" id="inputLevel7_5">
												<label for="inputLevel7_5"><spring:message code="resume.skill5" text="Advanced" /></label>
											</span>
										</li>
									</ul>
								</dd>
							</dl>
						</div>
					</div>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-language');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button id="createLanguageBtn" type="button" onclick="languageCheckForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
						<button id="editLanguageBtn" type="button" onclick="languageCheckForm();" class="btn btn-md btn-secondary"><spring:message code="button.save" text="Ahorrar" /></button>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div class="modal-popup modal-md2 hide d-down-md" id="layer-expose">
		<div class="dimed"></div>
		<form action="#">
			<input type="hidden" id="infoPopupResumeId" name="resumeId" value="">
			<div class="popup-inner popup-expose">
				<div class="popup-header">
					<h2 class="popup-title"><spring:message code="resume.text3" text="Ajuste de exposición" /></h2>
					<button type="button" class="btn btn-close-popup d-down-md" onclick="closeModal('#layer-expose');">Close</button>
				</div>
				<div class="popup-body">
					<dl class="total-info info-setting">
						<dt class="title"><spring:message code="resume.text4" text="Información Personal para incluir en tu currículo" /></dt>
						<dd class="content">
							<ul class="list">
								<li>
									<span class="check-item">
										<input type="checkbox" name="isPictureDisplay" id="inputCheck3_1" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck3_1"><spring:message code="resume.text6" text="Foto" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isYearmonthdayDisplay" id="inputCheck3_2" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck3_2"><spring:message code="contact.text.10" text="Fecha de nacimiento" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isSexDisplay" id="inputCheck3_3" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck3_3"><spring:message code="contact.text.12" text="Sexo" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isCountryDisplay" id="inputCheck3_4" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck3_4"><spring:message code="contact.text.11" text="Nacionalidad" /></label>
									</span>
								</li>
							</ul>
						</dd>
						<dt class="title"><spring:message code="resume.text7" text="Información" /></dt>
						<dd class="content">
							<ul class="list">
								<li>
									<span class="check-item">
										<input type="checkbox" name="isAboutMeDisplay" id="inputCheck4_1" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_1"><spring:message code="resume.self" text="Acerca de mi" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isCareerDisplay" id="inputCheck4_2" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_2"><spring:message code="resume.career1" text="Experiencia Laboral" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isEducationDisplay" id="inputCheck4_3" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_3"><spring:message code="resume.education1" text="Educación" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isHaveSkillDisplay" id="inputCheck4_4" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_4"><spring:message code="resume.have-skill1" text="Habilidades y competencias" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isProgramDisplay" id="inputCheck4_5" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_5"><spring:message code="resume.program1" text="Programas" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isLangDisplay" id="inputCheck4_6" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_6"><spring:message code="resume.language1" text="Idiomas" /></label>
									</span>
								</li>
								<li>
									<span class="check-item">
										<input type="checkbox" name="isQrPortfolioDisplay" id="inputCheck4_7" class="expose" onclick="isInfoPopCk();">
										<label for="inputCheck4_7"><spring:message code="resume.portfolio1" text="QR portafolio" /></label>
									</span>
								</li>
							</ul>
						</dd>
					</dl>
				</div>
				<div class="popup-footer">
					<div class="btn-group-default btn-fixed">
						<a href="javascript:;" class="btn btn-md btn-gray" onclick="closeModal('#layer-expose');"><spring:message code="button.cancel" text="cancelar" /></a>
						<button type="button" class="btn btn-md btn-secondary" onclick="exposeCreateForm();"><spring:message code="button.save" text="Ahorrar" /></button>
					</div>
				</div>
			</div>
		</form>
	</div>
	
	<div class="modal-popup modal-xl hide" id="layer-template1">
		<div class="dimed"></div>
		<form action="#">
			<div class="popup-inner popup-template">
				<div class="popup-header">
					<h2 class="popup-title">
						<span class="d-up-lg"><spring:message code="resume.text9-1" text="Avance" /></span>
						<span class="d-down-md"><spring:message code="resume.text9-1" text="Avance" /></span>
					</h2>
					<button type="button" class="btn btn-close-popup" onclick="closeModal('#layer-template1');">Close</button>
				</div>
				<div class="popup-body">
					<div class="template-ctrl">
						<span class="template-type d-down-md">TYPE 1</span>
						<a href="javascript:;" class="btn btn-sm btn-primary btn-down template1" onclick="downloadPdf1();"><spring:message code="button.download.pdf" text="PDF Descargar" /></a>
					</div>
					<div id="template1MobilePdf" class="template-wrap type1" style="overflow-x: hidden;">
						<div id="template1Pdf" class="template-preview">
							<div class="template-inner">
								<div class="resume-profile template1 template1Pdf"></div>
								
								<div class="resume-self template1 self template1Pdf">
									<h3 class="title"><spring:message code="resume.self" text="Acerca de mi" /></h3>
									<div class="content template1"></div>
								</div>
	
								<div class="resume-career template1 career template1Pdf">
									<h3 class="title"><spring:message code="resume.career1" text="Experiencia Laboral" /></h3>
									<ul class="list template1 career"></ul>
								</div>
	
								<div class="resume-career template1 education template1Pdf">
									<h3 class="title"><spring:message code="resume.education1" text="Educación" /></h3>
									<ul class="list template1 education"></ul>
								</div>

								<div class="resume-qr template1 qr template1Pdf">
									<h3 class="title"><spring:message code="resume.portfolio1" text="QR portafolio" /></h3>
									<div class="info-area template1"></div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div class="modal-popup modal-xl hide" id="layer-template2">
		<div class="dimed"></div>
		<form action="#">
			<div class="popup-inner popup-template">
				<div class="popup-header">
					<h2 class="popup-title">
						<span class="d-up-lg"><spring:message code="resume.text9-2" text="Avance" /></span>
						<span class="d-down-md"><spring:message code="resume.text9-2" text="Avance" /></span>
					</h2>
					<button type="button" class="btn btn-close-popup" onclick="closeModal('#layer-template2');">Close</button>
				</div>
				<div class="popup-body">
					<div class="template-ctrl">
						<span class="template-type d-down-md">TYPE 2</span>
						<a href="javascript:;" class="btn btn-sm btn-primary btn-down template2" onclick="downloadPdf2();"><spring:message code="button.download.pdf" text="PDF Descargar" /></a>
					</div>
					<div class="template-wrap type2" style="overflow-x: hidden;">
						<div id="template2Pdf" class="template-preview">
							<div class="template-inner">
								<div class="resume-profile template2 template2Pdf"></div>
		
								<dl class="resume-info-item resume-personal template2Pdf">
									<dt class="title"><spring:message code="resume.text5" text="Intimidad" /></dt>
									<dd>
										<div class="info-area">
											<ul class="list">
												<li>
													<dl class="personal-item">
														<dt>
															<em class="ico ico-resume-email"></em>
															<span class="sr-only">Email</span>
														</dt>
														<dd class="template2 email"></dd>
													</dl>
												</li>
												<li>
													<dl class="personal-item">
														<dt>
															<em class="ico ico-resume-phone"></em>
															<span class="sr-only">Teléfono</span>
														</dt>
														<dd class="template2 tell"></dd>
													</dl>
												</li>
												<li class="template2 year">
													<dl class="personal-item">
														<dt>
															<em class="ico ico-resume-self"></em>
															<span class="sr-only"></span>
														</dt>
														<dd>
															<ul class="info-list template2 year">
															</ul>
														</dd>
													</dl>
												</li>
												<li class="template2 country">
													<dl class="personal-item">
														<dt>
															<em class="ico ico-resume-location"></em>
															<span class="sr-only"></span>
														</dt>
														<dd class="template2 country"></dd>
													</dl>
												</li>
											</ul>
										</div>
									</dd>
								</dl>
								
								<dl class="resume-info-item resume-self template2 self template2Pdf">
									<dt class="title"><spring:message code="resume.self" text="Acerca de mi" /></dt>
									<dd>
										<div class="content template2"></div>
									</dd>
								</dl>

								<dl class="resume-info-item resume-career template2 career template2Pdf">
									<dt class="title"><spring:message code="resume.career1" text="Experiencia Laboral" /></dt>
									<dd>
										<ul class="list template2 career"></ul>
									</dd>
								</dl>

								<dl class="resume-info-item resume-career resume-education template2 education template2Pdf">
									<dt class="title"><spring:message code="resume.education1" text="Educación" /></dt>
									<dd>
										<ul class="list template2 education"></ul>
									</dd>
								</dl>

								<dl class="resume-info-item resume-level resume-skills template2 skill template2Pdf">
									<dt class="title"><spring:message code="resume.have-skill1" text="Habilidades y competencias" /></dt>
									<dd>
										<div class="info-area">
											<ul class="list template2 skill"></ul>
										</div>
									</dd>
								</dl>

								<dl class="resume-info-item resume-level resume-program template2 program template2Pdf">
									<dt class="title"><spring:message code="resume.program1" text="Programas" /></dt>
									<dd>
										<div class="info-area">
											<ul class="list template2 program"></ul>
										</div>
									</dd>
								</dl>

								<dl class="resume-info-item resume-level resume-language template2 lang template2Pdf">
									<dt class="title"><spring:message code="resume.language1" text="Idiomas" /></dt>
									<dd>
										<div class="info-area">
											<ul class="list template2 lang"></ul>
										</div>
									</dd>
								</dl>

								<dl class="resume-info-item resume-qr template2 qr template2Pdf">
									<dt class="title"><spring:message code="resume.portfolio1" text="QR portafolio" /></dt>
									<dd>
										<div class="info-area template2"></div>
									</dd>
								</dl>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>

	<div class="modal-popup modal-xl hide" id="layer-template3">
		<div class="dimed"></div>
		<form action="#">
			<div class="popup-inner popup-template">
				<div class="popup-header">
					<h2 class="popup-title">
						<span class="d-up-lg"><spring:message code="resume.text9-3" text="Avance" /></span>
						<span class="d-down-md"><spring:message code="resume.text9-3" text="Avance" /></span>
					</h2>
					<button type="button" class="btn btn-close-popup" onclick="closeModal('#layer-template3');">Close</button>
				</div>
				<div class="popup-body">
					<div class="template-ctrl">
						<span class="template-type d-down-md">TYPE 3</span>
						<a href="javascript:;" class="btn btn-sm btn-primary btn-down template3" onclick="downloadPdf3();"><spring:message code="button.download.pdf" text="PDF Descargar" /></a>
					</div>
					<div class="template-wrap type3" style="overflow-x: hidden;">
						<div id="template3Pdf" class="template-preview">
							<div class="template-inner">
								<div class="template3Pdf" style="display: flex;">
									<div class="resume-profile template3"></div>
									<div class="resume-self template3 self" style="margin-left: 10%; width: 596px;">
										<h3 class="title mt-0">
											<em class="ico ico-resume-self"></em>
											<spring:message code="resume.self" text="Acerca de mi" />
										</h3>
										<div class="content template3"></div>
									</div>
								</div>

								<div class="template3Pdf" style="display: flex;">
									<div class="resume-personal">
										<h3 class="title"><spring:message code="resume.text5" text="Intimidad" /></h3>
										<ul class="list">
											<li class="template3 year">
												<dl class="personal-item">
													<dt><spring:message code="contact.text.10" text="Fecha de nacimiento" /></dt>
													<dd class="template3 year"></dd>
												</dl>
											</li>
											<li class="template3 sex">
												<dl class="personal-item">
													<dt><spring:message code="contact.text.12" text="Sexo" /></dt>
													<dd class="template3 sex"></dd>
												</dl>
											</li>
											<li>
												<dl class="personal-item">
													<dt><spring:message code="contact.text.4" text="E-mail" /></dt>
													<dd class="template3 email"></dd>
												</dl>
											</li>
											<li>
												<dl class="personal-item">
													<dt><spring:message code="contact.text.13" text="Teléfono De Contacto" /></dt>
													<dd class="template3 tell"></dd>
												</dl>
											</li>
											<li class="template3 country">
												<dl class="personal-item">
													<dt><spring:message code="contact.text.11" text="Nacionalidad" /></dt>
													<dd class="template3 country"></dd>
												</dl>
											</li>
										</ul>
									</div>
									<div class="resume-career template3 career" style="margin-left: 10%; width: 596px;">
										<h3 class="title">
											<em class="ico ico-resume-career"></em>
											<spring:message code="resume.career1" text="Experiencia Laboral" />
										</h3>
										<ul class="list template3 career"></ul>
									</div>
								</div>
								
								<div class="template3Pdf" style="display: flex;">
									<div class="resume-qr template3 qr">
										<h3 class="title"><spring:message code="resume.portfolio1" text="QR portafolio" /></h3>
										<div class="info-area template3"></div>
									</div>
									<div class="resume-career template3 education" style="width: 596px;">
										<h3 class="title">
											<em class="ico ico-resume-education"></em>
											<spring:message code="resume.education1" text="Educación" />
										</h3>
										<ul class="list template3 education"></ul>
									</div>
								</div>
								
								<div class="template3Pdf" style="display: flex;">
									<div style="width: 250px; left: 50px;"><p style="width: 250px;"></p></div>
									<div class="resume-level resume-skills template3 skill" style="margin-left: 10%; width: 596px;">
										<h3 class="title">
											<em class="ico ico-resume-skills"></em>
											<spring:message code="resume.have-skill1" text="Habilidades y competencias" />
										</h3>
										<div class="info-area">
											<ul class="list template3 skill"></ul>
										</div>
									</div>
								</div>
								

								<div class="template3Pdf" style="display: flex;">
									<div style="width: 250px; left: 50px;"><p style="width: 250px;"></p></div>
									<div class="resume-level resume-program template3 program" style="margin-left: 10%; width: 596px;">
										<h3 class="title">
											<em class="ico ico-resume-program"></em>
											<spring:message code="resume.program1" text="Programas" />
										</h3>
										<div class="info-area">
											<ul class="list template3 program"></ul>
										</div>
									</div>
								</div>
								
								
								<div class="template3Pdf" style="display: flex;">
									<div style="width: 250px; left: 50px;"><p style="width: 250px;"></p></div>
									<div class="resume-level resume-language template3 lang" style="margin-left: 10%; width: 596px;">
										<h3 class="title">
											<em class="ico ico-resume-language"></em>
											<spring:message code="resume.language1" text="Idiomas" />
										</h3>
										<div class="info-area">
											<ul class="list template3 lang"></ul>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
		</form>
	</div>
	<!-- 공통 UI 컴포넌트 -->
	<script src="/static/assets/js/jquery.mCustomScrollbar.js"></script>
	<script src="/static/assets/js/ui-common.js"></script
	<script src="/static/common/js/init.js"></script>>
	<!-- PDF 관련 js -->
	<script src="/static/common/js/jspdf.min.js"></script>
	<script src="/static/common/js/html2canvas.min.js"></script>
</body>
</html>