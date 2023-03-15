package com.iscreammedia.clic.front.configuration;

import javax.sql.DataSource;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.jdbc.DataSourceBuilder;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class DatabaseConfig {

	// @Value("${spring.datasource.username}")
	// private String sqlUser;

	// @Value("${spring.datasource.password}")
	// private String sqlPass;

	@Value("${spring.datasource.driverClassName}")
	private String driverClassName;

	@Value("${spring.datasource.jdbcUrl}")
	private String jdbcUrl;

	// azure.keyvault 값
	@Value("${SQLPass}")
	private String sqlPass;

	// azure.keyvault 값
	@Value("${SQLUser}")
	private String sqlUser;

	@Bean
	public DataSource createSecondaryDataSource() {
		return DataSourceBuilder
				.create()
				.driverClassName(driverClassName)
				.url(jdbcUrl)
				.username(sqlUser)
				.password(sqlPass)
				.build();
	}

}
