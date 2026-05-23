package com.suat.app.backend.todo_service.config;

import com.suat.app.backend.todo_service.service.AppUserDetailsService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter; // 导入这个
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.annotation.authentication.builders.AuthenticationManagerBuilder;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;

@Configuration // 告诉 Spring 这是一个配置类
@EnableWebSecurity // 启用 Spring Security
public class SecurityConfig {

    @Autowired
    private AppUserDetailsService appUserDetailsService;

    // Bean 1: 密码加密器
    // 我们必须定义这个，Spring Security 才能知道用什么算法加密/比较密码
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }
    // 1. 注入(Inject) 我们新的过滤器
    @Autowired
    private JwtRequestFilter jwtRequestFilter;
    // Bean 2: 认证管理器 (AuthenticationManager)
    // 这个是 "登录" API 需要用到的
    @Bean
    public AuthenticationManager authenticationManager(HttpSecurity http) throws Exception {
        AuthenticationManagerBuilder authBuilder =
                http.getSharedObject(AuthenticationManagerBuilder.class);
        authBuilder
                .userDetailsService(appUserDetailsService) // 使用我们的 "用户查找器"
                .passwordEncoder(passwordEncoder());      // 使用我们的 "密码加密器"
        return authBuilder.build();
    }

    // Bean 3: 安全过滤器链 (最核心的配置)
    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                // 1. 禁用 CSRF
                // (因为我们用 JWT，是无状态的，不需要 CSRF 保护)
                .csrf(csrf -> csrf.disable())

                // 2. 授权规则 (Authorization Rules)
                .authorizeHttpRequests(auth -> auth
                        // 2a. 允许 (permit) 任何人访问 /api/auth/** (登录/注册 API)
                        .requestMatchers("/api/auth/**").permitAll()
                        .requestMatchers("/viz/**").permitAll()
                        // 2b. (临时) 允许任何人访问我们的内容 API，方便调试
                        .requestMatchers("/api/v1/**").authenticated()
                        // --- ⬇️ (关键修复) 允许访问全局错误路径 ⬇️ ---
                        .requestMatchers("/error").permitAll()
                        .requestMatchers("/api/user/**").authenticated()
                        // 2c. 其他所有请求都需要认证 (虽然上面已经全放了)
                        .anyRequest().authenticated()
                )

                // 3. 禁用 HTTP Basic Auth (就是那个浏览器登录弹窗)
                .httpBasic(httpBasic -> httpBasic.disable())

                // 4. (关键) 设置 Session 管理为 STATELESS (无状态)
                // Spring Security 不会再创建或使用 HTTP Session
                .sessionManagement(session ->
                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                );

        // (我们稍后会在这里添加 JWT 过滤器)
        http.addFilterBefore(jwtRequestFilter, UsernamePasswordAuthenticationFilter.class);
        return http.build();
    }
}