package com.suat.app.backend.todo_service.config;

import com.suat.app.backend.todo_service.service.AppUserDetailsService;
import com.suat.app.backend.todo_service.util.JwtUtil;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.JwtException;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.web.authentication.WebAuthenticationDetailsSource;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter; // 关键

import java.io.IOException;

@Component // 告诉 Spring 这是一个 Bean
public class JwtRequestFilter extends OncePerRequestFilter { // 保证每个请求只过一次此过滤器

    @Autowired
    private JwtUtil jwtUtil;

    @Autowired
    private AppUserDetailsService userDetailsService;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain)
            throws ServletException, IOException {

        // 1. 从请求头中获取 'Authorization'
        final String authHeader = request.getHeader("Authorization");

        String username = null;
        String jwt = null;

        // 2. 检查 Header 是否存在，并且是否以 "Bearer " 开头
        if (authHeader != null && authHeader.startsWith("Bearer ")) {
            jwt = authHeader.substring(7); // "Bearer " 之后的部分就是 Token
            try {
                username = jwtUtil.extractUsername(jwt);
            } catch (ExpiredJwtException e) {
                System.err.println("JWT Token has expired");
            } catch (JwtException e) {
                System.err.println("JWT Token is invalid");
            }
        }

        // 3. 如果我们成功获取了用户名，并且 (关键) "当前安全上下文中还没有认证信息"
        if (username != null && SecurityContextHolder.getContext().getAuthentication() == null) {

            // 4. 从数据库中加载用户信息
            UserDetails userDetails = this.userDetailsService.loadUserByUsername(username);

            // 5. 验证 Token 是否有效 (签名是否匹配, 是否未过期, 用户名是否一致)
            if (jwtUtil.validateToken(jwt, userDetails)) {

                // 6. (关键) 创建一个"认证凭证"
                UsernamePasswordAuthenticationToken authToken = new UsernamePasswordAuthenticationToken(
                        userDetails, null, userDetails.getAuthorities());

                authToken.setDetails(new WebAuthenticationDetailsSource().buildDetails(request));

                // 7. (最关键) 将这个"凭证"放入 Spring Security 的"安全上下文"中
                // 从这一刻起，Spring Security 就知道这个用户是"已登录"的！
                SecurityContextHolder.getContext().setAuthentication(authToken);
            }
        }

        // 8. 无论如何，都放行请求，让它进入下一个过滤器
        filterChain.doFilter(request, response);
    }
}