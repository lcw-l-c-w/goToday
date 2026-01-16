package config;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.annotation.MapperScan;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.beans.factory.config.PropertyPlaceholderConfigurer;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.Primary;
import org.springframework.core.io.ClassPathResource;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.web.multipart.commons.CommonsMultipartResolver;
import org.springframework.web.servlet.config.annotation.DefaultServletHandlerConfigurer;
import org.springframework.web.servlet.config.annotation.EnableWebMvc;
import org.springframework.web.servlet.config.annotation.ViewResolverRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;

import com.zaxxer.hikari.HikariDataSource;

@Configuration
@MapperScan(annotationClass = Mapper.class, basePackages = "kr.co.gotoday")
@ComponentScan(basePackages = {"kr.co.gotoday"})
@EnableWebMvc
@EnableTransactionManagement
public class MvcConfig implements WebMvcConfigurer{
	
	@Value("${db.driver}")
	private String driver;
	@Value("${db.url}")
	private String url;
	@Value("${db.username}")
	private String username;
	@Value("${db.password}")
	private String password;
	

    // Kakao
    @Value("${kakao.rest-api-key}")
    private String kakaoRestApiKey;
    @Value("${kakao.redirect-uri}")
    private String kakaoRedirectUri;
    
	public void configureDefaultServletHandling(DefaultServletHandlerConfigurer configurer) {
		configurer.enable();
	}
	
	// JSP 占쏙옙占� (ViewResolver)
	@Override
	public void configureViewResolvers(ViewResolverRegistry registry) {
		registry.jsp("/WEB-INF/views/", ".jsp");
	}
	
	// hikaricp
	@Bean
	@Primary
	public HikariDataSource dataSource() {
		HikariDataSource dataSource = new HikariDataSource();
//		dataSource.setDriverClassName("org.mariadb.jdbc.Driver");
		dataSource.setDriverClassName(driver);
//		dataSource.setJdbcUrl("jdbc:mariadb://localhost:3306/study");
		dataSource.setJdbcUrl(url);
		dataSource.setUsername(username);
		dataSource.setPassword(password);
		return dataSource;
	}
	// mybatis
	@Bean
	public SqlSessionFactory sqlSessionFactory() throws Exception{
		SqlSessionFactoryBean ssf = new SqlSessionFactoryBean();
		ssf.setDataSource(dataSource()); 

		return ssf.getObject();
	}

	@Bean 
	public CommonsMultipartResolver multipartResolver() {
		CommonsMultipartResolver resolver = new CommonsMultipartResolver();
		resolver.setMaxUploadSize(5*1024*1024);
		resolver.setDefaultEncoding("utf-8");
		return resolver;
	}
	

	@Bean
	public PlatformTransactionManager transactionManager() {
		DataSourceTransactionManager dtm = new DataSourceTransactionManager(dataSource());
//			dtm.setDataSource(dataSource()); //setter
		return dtm; //
	}
	

	//DB property, API properties 등록
	@Bean
	public static PropertyPlaceholderConfigurer properties() {
		PropertyPlaceholderConfigurer config = new PropertyPlaceholderConfigurer();
		config.setLocations(
				new ClassPathResource("db.properties"), 
				new ClassPathResource("api.properties")
			);
		return config;
	}
	
	
}










