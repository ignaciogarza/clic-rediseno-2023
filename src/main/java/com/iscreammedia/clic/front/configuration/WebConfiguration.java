package com.iscreammedia.clic.front.configuration;

import java.util.List;
import java.util.Locale;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.web.servlet.FilterRegistrationBean;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.EnableAspectJAutoProxy;
import org.springframework.context.support.ReloadableResourceBundleMessageSource;
import org.springframework.http.MediaType;
import org.springframework.scheduling.annotation.EnableAsync;
import org.springframework.scheduling.annotation.EnableScheduling;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.method.support.HandlerMethodArgumentResolver;
import org.springframework.web.servlet.LocaleResolver;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.ResourceHandlerRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
import org.springframework.web.servlet.i18n.CookieLocaleResolver;
import org.springframework.web.servlet.i18n.LocaleChangeInterceptor;
import org.springframework.web.servlet.view.json.MappingJackson2JsonView;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.module.SimpleModule;
import com.iscreammedia.clic.front.configuration.filter.XSSFilter;
import com.iscreammedia.clic.front.configuration.servlet.handler.BaseHandlerInterceptor;
import com.iscreammedia.clic.front.domain.BaseCodeLabelEnum;
import com.iscreammedia.clic.front.framework.data.web.MySQLPageRequestHandleMethodArgumentResolver;

@EnableAsync
@EnableTransactionManagement
@EnableScheduling
@EnableAspectJAutoProxy
@Configuration
public class WebConfiguration implements WebMvcConfigurer {
	@Value("${main.locale}")
	private String mainLocale;
	
	@Value("${resource.path}")
	private String resourcePath;
	
	@Value("${upload.path}")
	private String uploadPath;
	
	@Autowired
	private BaseHandlerInterceptor baseHandlerInterceptor;
	
	private Logger logger = LoggerFactory.getLogger(getClass());
	
	@Bean
	public FilterRegistrationBean<XSSFilter> getFilterRegistrationBean(){
		FilterRegistrationBean<XSSFilter> registrationBean = new FilterRegistrationBean<>();
		registrationBean.setFilter(new XSSFilter());
		registrationBean.setOrder(1);
		registrationBean.addUrlPatterns("/*");
		return registrationBean;
	}

	@Bean
	public ReloadableResourceBundleMessageSource messageSource() {
		ReloadableResourceBundleMessageSource source = new ReloadableResourceBundleMessageSource();
		source.setBasename("classpath:/messages/message");
		source.setDefaultEncoding("UTF-8");
		source.setCacheSeconds(60);
		logger.info("##########  mainLocale : {}", mainLocale);
		source.setUseCodeAsDefaultMessage(true);
		return source;
	}
	
	@Bean
	public LocaleResolver localeResolver() {
		CookieLocaleResolver resolver = new CookieLocaleResolver();
		if(mainLocale.equals("ko")) {
			resolver.setDefaultLocale(Locale.KOREAN);
		}else if(mainLocale.equals("en")) {
			resolver.setDefaultLocale(Locale.ENGLISH);
		}else if(mainLocale.equals("es")){
			resolver.setDefaultLocale(new Locale("es"));
		}
			
		resolver.setCookieName("lang");
		
		return resolver;
	}
	

	@Bean
	public LocaleChangeInterceptor localeChangeInterceptor() {
		LocaleChangeInterceptor lci = new LocaleChangeInterceptor();
		lci.setParamName("lang");
		
		return lci;
	}
	
	
	@Bean
	public BaseHandlerInterceptor baseHandlerInterceptor() {
		return new BaseHandlerInterceptor();
	}
	
	@Override
	public void addResourceHandlers(ResourceHandlerRegistry registry) {
		registry.addResourceHandler("/static/**").addResourceLocations("classpath:/static/");
		registry.addResourceHandler(uploadPath).addResourceLocations(resourcePath);
	}
	
	@Override
	public void addInterceptors(InterceptorRegistry registry) {
		registry.addInterceptor(localeChangeInterceptor());
		// @formatter:off
		final String[] publicMatchers = {
				"/static/**"
				,"/favicon.ico"	 
				,"/mypage/main"
				,"/login/login"
				,"/login/signIn"  
				,"/login/passwordFindView"			//비밀번호 
				,"/login/emailPasswordSend"
				,"/login/signOut"					//로그아웃
				,"/login/signOutDash"
				,"/error"
				,"/api/common/**"
				,"/user/userForm"					//회원가입
				,"/user/termsList"					//이용약관 조회 
				,"/user/userInsert"					//회원가입 저장
				,"/user/getEamilCk"					//이메일중보체크
				,"/user/getEamilNoStatusCk"
				,"/user/emailSend"					//이메일 보내기
				,"/user/emailCertificationView"		//이메일 인증 화면 	
				,"/user/getEmailNoConfirm"			//이메일 인증번호 확인
				,"/swagger-ui"
				,"/swagger-resources"
				,"/common/terms-and-conditions/api"
				,"/common/privacy-policy/api"
				,"/common/contact-us/send"
				,"/common/faq/list"
//				,"/main"
//				,"/common/**"
//				,"/studio/project/portfolioOthersMemberView"  //포토폴리오 프로젝트 화면 
//				,"/studio/project/portfolioOthersMemberList"
//				,"/studio/project/portfolioOthersMemberProjectView"  //포토폴리오 프로젝트 화면 
//				,"/studio/project/portfolioOthersMemberProjectList" 				
//				,"/studio/project/projectContentsOutImageFrom"  //포토폴리오 프로젝트 화면 
//				,"/studio/project/projectContentsImageList"
//				,"/studio/project/projectContentsList"
//				,"/studio/project/portfolioOthersMemberProjectView"
		}; 
		// @formatter:on
		registry.addInterceptor(baseHandlerInterceptor).addPathPatterns("/**").excludePathPatterns(publicMatchers);		
	}
	
	@Bean
	public ObjectMapper objectMapper() {
		ObjectMapper objectMapper = new ObjectMapper();
		SimpleModule simpleModule = new SimpleModule();
		simpleModule.addSerializer(BaseCodeLabelEnum.class, new BaseCodeLabelEnumJsonSerializer());
		objectMapper.registerModule(simpleModule);

		return objectMapper;
	}
	
	@Bean 
	public MappingJackson2JsonView mappingJackson2JsonView() {
		MappingJackson2JsonView jsonView = new MappingJackson2JsonView();
		jsonView.setContentType(MediaType.APPLICATION_JSON_VALUE);
		jsonView.setObjectMapper(objectMapper());
		
		return jsonView;
	}
	
	@Override
	public void addArgumentResolvers(List<HandlerMethodArgumentResolver> resolvers) {
		resolvers.add(new MySQLPageRequestHandleMethodArgumentResolver());
	}

}
