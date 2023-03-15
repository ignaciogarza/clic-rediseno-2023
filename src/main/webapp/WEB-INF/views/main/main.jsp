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
</head>
<body>
<div class="wrapper">
	<jsp:include page="../common/header.jsp"></jsp:include>
	<!-- mainpage -->
		<div id="main-container">
			<article id="content">
				<section class="section section-visual">
					<div class="thumb">
						<img src="/static/assets/images/main/img-visual.jpg" alt="">
					</div>
					<div class="info-area">
						<p class="main-text"><spring:message code="main.header.text1" text="Meet Clic!" /></p>
						<p class="sub-text">
							<spring:message code="main.header.text2" text="Clic connects your skills and opportunities." /><br>
							<spring:message code="main.header.text3" text="Assess, certify, and showcase your skills on Clic." /><br>
							<spring:message code="main.header.text4" text="Here’s how we do." />
						</p>
					</div>
				</section>
				<%-- <section class="section section-content section-know">
					<div class="section-inner">
						<div class="info-area">
							<h2 class="title"><spring:message code="main.aptitude.text1" text="Know Yourself" /></h2>
							<p class="content">
								<spring:message code="main.aptitude.text2" text="Do you know what you’re good at?" /><br>
								<spring:message code="main.aptitude.text3" text="What are the most important values in your life?" /><br>
								<spring:message code="main.aptitude.text4" text="What are your top areas of interest?" /><br>
								<spring:message code="main.aptitude.text5" text="Get to know yourself now" />
							</p>
							<div class="btn-area">
								<a href="javascript:;" class="btn btn-go"><spring:message code="main.aptitude.text6" text="Go to Conocete"/></a>
							</div>
						</div>
						<div class="thumb">
							<img src="/static/assets/images/main/img-photo1.jpg" alt="">
						</div>
					</div>
				</section> --%>
				<section class="section section-content section-evaluate type2">
					<div class="section-inner">
						<div class="info-area">
							<h2 class="title"><spring:message code="main.eval.text1" text="Assess and Certify" /><br> <spring:message code="main.eval.text2" text="Your Skills" /></h2>
							<p class="content">
								<spring:message code="main.eval.text3" text="Test your skills with our 3-way verification methods." /><br>
								<spring:message code="main.eval.text4" text="Through self-assessment, behavioral assessment, and peer endorsement, find what you’re good at and can get better." /><br>
								<spring:message code="main.eval.text5" text="Once you successfully complete them, you’ll earn your badge." /><br>
								<spring:message code="main.eval.text6" text="Start your certification journey today!" />
							</p>
							<div class="btn-area">
								<a href="/eval/list" class="btn btn-go"><spring:message code="main.eval.text7" text="Go to Evaluate" /></a>
							</div>
						</div>
						<div class="thumb">
							<img src="/static/assets/images/main/img-photo2.jpg" alt="">
						</div>
					</div>
				</section>
				<section class="section section-connect">
					<div class="thumb">
						<img src="/static/assets/images/main/img-photo3.jpg" alt="">
					</div>
					<div class="info-area">
						<h2 class="title"><spring:message code="main.community.text1" text="Connect with Others" /></h2>
						<p class="content">
							<spring:message code="main.community.text2" text="Networking can help you reach the place you want to move." /><br>
							<spring:message code="main.community.text3" text="Connect with your peers and mentors on Clic." />
						</p>
						<div class="btn-area">
							<a href="/community/communityMainView" class="btn btn-go"><spring:message code="main.community.text4" text="Go to Conectate" /></a>
						</div>
					</div>
				</section>
				<section class="section section-content section-cv type2">
					<div class="section-inner">
						<div class="info-area">
							<h2 class="title"><spring:message code="main.cv.text1" text="Clic Studio -" /><br> <spring:message code="main.cv.text2" text="CV" /></h2>
							<p class="content">
								<spring:message code="main.cv.text3" text="Without a good CV, it may be difficult to pass through the screening stage." /><br>
								<spring:message code="main.cv.text4" text="Clic Studio helps you effectively showcase your qualifications on CV." /><br>
								<spring:message code="main.cv.text5" text="Create your CV to communicate your skills." />
							</p>
							<div class="btn-area">
								<a href="/studio/resume/detail" class="btn btn-go"><spring:message code="main.cv.text6" text="Go to Clic Studio - CV" /></a>
							</div>
						</div>
						<div class="thumb">
							<img src="/static/assets/images/main/img-photo4.jpg" alt="">
						</div>
					</div>
				</section>
				<section class="section section-content section-portfolio">
					<div class="section-inner">
						<div class="info-area">
							<h2 class="title"><spring:message code="main.portfolio.text1" text="Clic Studio –" /><br> <spring:message code="main.portfolio.text2" text="Portfolio" /></h2>
							<p class="content">
								<spring:message code="main.portfoilo.text3" text="Actions speak louder than words." /><br>
								<spring:message code="main.portfoilo.text4" text="Effectively showcase your skills through your portfolio." /><br>
								<spring:message code="main.portfolio.text5" text="Create your portfolio to showcase your skills and work." />
							</p>
							<div class="btn-area">
								<a href="/studio/portfolio/portfolioFrom" class="btn btn-go"><spring:message code="main.portfolio.text6" text="Go to Clic Studio - Portfolio" /></a>
							</div>
						</div>
						<div class="thumb">
							<img src="/static/assets/images/main/img-photo5.jpg" alt="">
						</div>
					</div>
				</section>
				<section class="section section-content section-learn type2">
					<div class="section-inner">
						<div class="info-area">
							<h2 class="title"><spring:message code="main.edu.text1" text="Learn" /></h2>
							<p class="content">
								<spring:message code="main.edu.text2" text="21st century skills can help you better navigate challenges." /><br>
								<spring:message code="main.edu.text3" text="Learn and improve your 21st century skills!" /><br>
								<spring:message code="main.edu.text4" text="We gather all learning content." />
							</p>
							<div class="btn-area">
								<a href="/education/list" class="btn btn-go"><spring:message code="main.edu.text5" text="Go to Aprende" /></a>
							</div>
						</div>
						<div class="thumb">
							<img src="/static/assets/images/main/img-photo6.jpg" alt="">
						</div>
					</div>
				</section>
				<section class="section section-info">
					<div class="section-inner">
						<p class="main-text"><spring:message code="main.footer.text1" text="We're striving to nurture transversal skills" /><br class="d-up-lg"> <spring:message code="main.footer.text2" text="around the world." /></p>
						<p class="sub-text">
							<spring:message code="main.footer.text3" text="Clic is a part of the 21st Century Skills initiative led by the Inter-American Development Bank that brings public and private sector stakeholders together." /><br> 
							<spring:message code="main.footer.text4" text="The 21st Century Skills Coalition supports to implement a new generation of education and training policies in Latin America and the Caribbean. The Coalition is a multi-sector partnership that promotes the development and strengthening of transversal skills in Latin America and the Caribbean." /><br class="d-up-lg">
							<spring:message code="main.footer.text5" text="The 21st Century Skills initiative strengthens learning ecosystems to equip Latin American and Caribbean citizens with transversal skills." />
						</p>
					</div>
				</section>
			</article>
		</div>
	<jsp:include page="../common/footer.jsp"></jsp:include>
</div>
<script>
$(document).ready(function() {
	fnIsComplete();
});

//회원 설문조사 참여조회
function fnIsComplete() {
	$.ajax({
		url: '/main',
		type: 'post',
		dataType: 'json',
		success: function(response) {
			var result = response.data;

			if(result == 'N' || result == 'yesUser') {
				$('.btn-area').on('click', function() {
					alert('<spring:message code="profile.message24" javaScriptEscape="true" text="설문 등록해주세요." />');
					$('.btn-area>a.btn.btn-go').attr('href', 'javascript:;');
				});
			}
		}
	});
}
</script>
</body>
</html>