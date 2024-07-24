/*
 * package kr.co.matchday.config;
 * 
 * import javax.sql.DataSource;
 * 
 * import org.springframework.context.annotation.Bean; import
 * org.springframework.context.annotation.Configuration; import
 * org.springframework.security.config.annotation.web.builders.HttpSecurity;
 * import org.springframework.security.config.annotation.web.configuration.
 * EnableWebSecurity; import
 * org.springframework.security.core.userdetails.UserDetailsService; import
 * org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder; import
 * org.springframework.security.crypto.password.PasswordEncoder; import
 * org.springframework.security.web.SecurityFilterChain; import
 * org.springframework.security.web.firewall.HttpFirewall; import
 * org.springframework.security.web.firewall.StrictHttpFirewall; import
 * org.springframework.security.web.session.HttpSessionEventPublisher;
 * 
 * import kr.co.matchday.admin.CustomUserDetailsService;
 * 
 * @Configuration
 * 
 * @EnableWebSecurity public class WebSecurityConfig {
 * 
 * @Bean public SecurityFilterChain securityFilterChain(HttpSecurity http)
 * throws Exception { http .authorizeHttpRequests(authorize -> authorize
 * .requestMatchers("/admin/**").hasRole("ADMIN") // 관리자 페이지 접근 권한 설정
 * .requestMatchers("/member/login", "/member/login.do",
 * "/member/logout").permitAll() // 로그인 및 로그아웃 페이지 접근 허용
 * .anyRequest().authenticated() // 나머지 요청은 인증된 사용자만 접근 허용 ) .formLogin(form ->
 * form .loginPage("/member/login") .loginProcessingUrl("/member/login.do")
 * .defaultSuccessUrl("/home.do", true) // 로그인 성공 후 이동할 URL .permitAll() )
 * .logout(logout -> logout .logoutUrl("/member/logout")
 * .logoutSuccessUrl("/home.do") // 로그아웃 성공 후 이동할 URL .permitAll() ) .csrf(csrf
 * -> csrf.disable()) // CSRF 비활성화 .exceptionHandling(exception -> exception
 * .accessDeniedHandler((request, response, accessDeniedException) -> {
 * response.setContentType("text/html;charset=UTF-8"); response.getWriter().
 * write("<script>alert('관리자만 접근 가능합니다.'); location.href='/member/login';</script>"
 * ); }) ); return http.build(); }
 * 
 * @Bean public PasswordEncoder passwordEncoder() { return new
 * BCryptPasswordEncoder(); // 비밀번호 암호화 }
 * 
 * @Bean public UserDetailsService userDetailsService(DataSource dataSource) {
 * return new CustomUserDetailsService(dataSource); // 사용자 정보 서비스 구현체 }
 * 
 * @Bean public HttpSessionEventPublisher httpSessionEventPublisher() { return
 * new HttpSessionEventPublisher(); // 세션 이벤트 처리 }
 * 
 * @Bean public HttpFirewall allowUrlEncodedSlashHttpFirewall() {
 * StrictHttpFirewall firewall = new StrictHttpFirewall();
 * firewall.setAllowUrlEncodedDoubleSlash(true); // Double slashes 허용
 * firewall.setAllowUrlEncodedSlash(true); // URL 인코딩된 슬래시 허용 return firewall; }
 * }
 */