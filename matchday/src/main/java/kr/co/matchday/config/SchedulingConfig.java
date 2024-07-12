package kr.co.matchday.config;

import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import org.springframework.scheduling.annotation.EnableScheduling;

@Configuration
@ComponentScan(basePackages = "kr.co.matchday")
@EnableScheduling
public class SchedulingConfig {
    // 스케줄링을 사용하기 위한 설정 클래스
}
