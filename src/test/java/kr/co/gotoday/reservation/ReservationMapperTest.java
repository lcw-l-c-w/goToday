package kr.co.gotoday.reservation;

import static org.junit.jupiter.api.Assertions.*;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.junit.jupiter.api.Test;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.annotation.AnnotationConfigApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

import com.zaxxer.hikari.HikariDataSource;

class ReservationMapperTest {

    @Test
    void 예약_생성_테스트() throws Exception {
        // 1. 스프링 컨텍스트 직접 생성
        AnnotationConfigApplicationContext ctx = 
            new AnnotationConfigApplicationContext(TestConfig.class);
        
        // 2. Mapper 가져오기
        SqlSessionTemplate sqlSession = ctx.getBean(SqlSessionTemplate.class);
        ReservationMapper mapper = sqlSession.getMapper(ReservationMapper.class);
        
        // 3. 예약 VO 생성
        ReservationVO vo = new ReservationVO();
        vo.setReservation_code("SIMPLE-TEST-" + System.currentTimeMillis());
        vo.setReserved_for_at("20260128");
        vo.setTime_zone("10:00~12:00");
        vo.setReservation_status("DONE");
        vo.setTotal_price(30000);
        vo.setAdult_qty(2);
        vo.setChild_qty(0);
        vo.setTeen_qty(0);
        vo.setUser_id(22);
        vo.setContent_id(5);
        vo.setReservation_type("NORMAL");
        vo.setReceiver_name("간단테스트");
        vo.setReceiver_birth("1995-01-01");
        vo.setReceiver_phone("01012341234");
        vo.setReceive_type("ONLINE");
        vo.setSchedule_id(2);
        
        // 4. 실행
        int result = mapper.createReservation(vo);
        
        // 5. 검증
        assertEquals(1, result);
        assertNotNull(vo.getReservation_id());
        
        System.out.println("✅✅✅ 성공! 생성된 ID: " + vo.getReservation_id());
        
        // 6. 정리
        ctx.close();
    }
    
    @Configuration
    static class TestConfig {
        
        @Bean
        public DataSource dataSource() {
            HikariDataSource ds = new HikariDataSource();
            ds.setJdbcUrl("jdbc:mysql://localhost:3306/gotoday?serverTimezone=Asia/Seoul");
            ds.setUsername("root");
            ds.setPassword("1234");  // ⚠️⚠️⚠️ 여기만 수정!
            ds.setDriverClassName("com.mysql.cj.jdbc.Driver");
            return ds;
        }
        
        @Bean
        public SqlSessionFactory sqlSessionFactory() throws Exception {
            SqlSessionFactoryBean factory = new SqlSessionFactoryBean();
            factory.setDataSource(dataSource());
            factory.setTypeAliasesPackage("kr.co.gotoday");
            return factory.getObject();
        }
        
        @Bean
        public SqlSessionTemplate sqlSessionTemplate() throws Exception {
            return new SqlSessionTemplate(sqlSessionFactory());
        }
    }
}