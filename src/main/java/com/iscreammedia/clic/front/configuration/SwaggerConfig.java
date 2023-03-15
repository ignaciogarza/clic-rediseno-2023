package com.iscreammedia.clic.front.configuration;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import springfox.documentation.builders.ApiInfoBuilder;
import springfox.documentation.builders.PathSelectors;
import springfox.documentation.builders.RequestHandlerSelectors;
import springfox.documentation.spi.DocumentationType;
import springfox.documentation.spring.web.plugins.Docket;

@Configuration
public class SwaggerConfig {

	@Bean
    public Docket apiEcoMarketplace(){
        return new Docket(DocumentationType.OAS_30)
        		.select()                
                .apis(RequestHandlerSelectors.basePackage("com.iscreammedia.clic.front.controller"))
                .paths(PathSelectors.any())
                .build().apiInfo(
                		new ApiInfoBuilder()
                		.title("API")
                        .description("API 연동 문서 입니다.")
                        .version("3.0.0")
                        .build()
                		).useDefaultResponseMessages(false);
                
    }
}
