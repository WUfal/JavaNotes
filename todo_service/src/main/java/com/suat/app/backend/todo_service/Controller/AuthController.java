package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.AuthRequest;
import com.suat.app.backend.todo_service.dto.AuthResponse;
import com.suat.app.backend.todo_service.dto.UpdateProfileRequest;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.util.JwtUtil;
import com.suat.app.backend.todo_service.service.UserService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/auth") // 路径前缀
public class AuthController {

    @Autowired
    private AuthenticationManager authenticationManager; // 来自 SecurityConfig

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private PasswordEncoder passwordEncoder; // 来自 SecurityConfig

    @Autowired
    private JwtUtil jwtUtil; // 来自 util

    @Autowired
    private UserService userService;

    /**
     * API 1: 用户注册
     */
    @PostMapping("/register")
    public ResponseEntity<?> registerUser(@RequestBody AuthRequest authRequest) {
        // 1. 检查用户名是否已被占用
        if (appUserRepository.findByUsername(authRequest.username()).isPresent()) {
            return ResponseEntity
                    .status(HttpStatus.BAD_REQUEST) // 400 错误
                    .body("Error: Username is already taken!");
        }

        // 2. 创建新用户
        AppUser user = new AppUser();
        user.setUsername(authRequest.username());
        // 3. (关键) 必须加密密码
        user.setPassword(passwordEncoder.encode(authRequest.password()));
// --- ⬇️ (关键新增) 设置默认资料 ⬇️ ---
        user.setNickname(authRequest.username()); // <--- 改成 authRequest
        user.setAvatarId("default");          // 默认头像 = default
        // --- ⬆️ (新增结束) ⬆️ ---
        // 4. 保存到数据库
        appUserRepository.save(user);

        return ResponseEntity.ok("User registered successfully!");
    }

    /**
     * API 2: 用户登录
     */
    @PostMapping("/login")
    public ResponseEntity<?> authenticateUser(@RequestBody AuthRequest authRequest) {
        // 1. (关键) Spring Security 执行认证
        // 它会自己调用 AppUserDetailsService 和 PasswordEncoder
        Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(
                        authRequest.username(),
                        authRequest.password()
                )
        );

        // 2. 如果认证成功 (没有抛出异常)，Security 会返回一个 Authentication 对象
        // 我们从中获取 UserDetails
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();

        // 3. 使用 JwtUtil 生成 Token
        String jwt = jwtUtil.generateToken(userDetails);
        // 4. (新增) 从数据库中获取完整的 AppUser 实体
        //    我们利用刚认证过的 userDetails.getUsername() 来查询
        AppUser appUser = appUserRepository.findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found after authentication")); // (理论上不应该发生)

        // 5. (新增) 从实体中获取 selectedPath
        String selectedPath = appUser.getSelectedPath();

        // 4. 将 Token 返回给前端
        return ResponseEntity.ok(new AuthResponse(jwt, selectedPath));

    }
    @PutMapping("/api/user/profile")
    public ResponseEntity<Void> updateProfile(
            @RequestBody UpdateProfileRequest request,
            Authentication authentication) {
        userService.updateProfile(authentication.getName(), request.nickname(), request.avatarId());
        return ResponseEntity.ok().build();
    }

}