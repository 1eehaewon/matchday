package kr.co.matchday;

import javax.sql.DataSource;

import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.PathMatchingResourcePatternResolver;
import org.springframework.scheduling.annotation.EnableScheduling; // 스케줄러를 활성화하기 위해 추가
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.jdbc.datasource.DataSourceTransactionManager;

@SpringBootApplication
@EnableTransactionManagement // 트랜잭션 관리를 활성화합니다.
@EnableScheduling // 스케줄링을 활성화합니다.
@ComponentScan(basePackages = {"kr.co.matchday", "com.example.websocket"})
public class MatchdayApplication {

    public static void main(String[] args) {
        SpringApplication.run(MatchdayApplication.class, args);
    }//main end

    // MyBatis Framework 관련 환경 설정
    // Mapper 객체 생성
    @Bean // Spring 컨테이너(톰캣)가 자동으로 객체를 생성합니다.
    public SqlSessionFactory sqlSessionFactory(DataSource dataSource) throws Exception {
        System.out.println("-----sqlSessionFactory() 호출됨");
        SqlSessionFactoryBean bean = new SqlSessionFactoryBean();
        bean.setDataSource(dataSource);
        Resource[] res = new PathMatchingResourcePatternResolver().getResources("classpath:mappers/*.xml");
        bean.setMapperLocations(res);
        return bean.getObject();
    }//sqlSessionFactory end
    
    @Bean
    public SqlSessionTemplate sqlSession(SqlSessionFactory factory) {
        System.out.println("-----sqlSession() 호출됨");
        return new SqlSessionTemplate(factory);
    }//sqlSession() end
    
    // 트랜잭션 매니저 설정
    @Bean
    public PlatformTransactionManager transactionManager(DataSource dataSource) {
        return new DataSourceTransactionManager(dataSource);
    }//transactionManager end
    
}//class end
