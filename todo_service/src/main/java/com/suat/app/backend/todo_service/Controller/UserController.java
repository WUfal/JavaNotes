package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.UpdateProfileRequest; // (确保导入)
import com.suat.app.backend.todo_service.dto.UserProfileResponse;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.service.UserService; // (确保导入)
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

import java.util.Map;

@RestController
@RequestMapping("/api/user") // (保持这个路径不变，匹配前端 _userBaseUrl)
public class UserController {

    @Autowired
    private AppUserRepository appUserRepository; // (旧代码用的)

    @Autowired
    private UserService userService; // (新代码用的)

    /**
     * (旧功能) API: 保存用户的路径选择
     * POST /api/user/path
     */
    @PostMapping("/path")
    public ResponseEntity<?> updateUserPath(@RequestBody Map<String, String> payload) {
        // ... (保留你原有的逻辑，不要删除) ...
        Authentication authentication = SecurityContextHolder.getContext().getAuthentication();
        String username = ((UserDetails) authentication.getPrincipal()).getUsername();

        AppUser appUser = appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        String path = payload.get("path");
        if (path == null || !(path.equals("BEGINNER") || path.equals("ADVANCED"))) {
            return ResponseEntity.badRequest().body("Invalid path value.");
        }

        appUser.setSelectedPath(path);
        appUserRepository.save(appUser);

        return ResponseEntity.ok("Path updated successfully.");
    }

    /**
     * (新功能) API: 更新用户资料 (昵称/头像)
     * PUT /api/user/profile
     */
    @PutMapping("/profile")
    public ResponseEntity<Void> updateProfile(
            @RequestBody UpdateProfileRequest request,
            Authentication authentication) {

        // 调用新的 Service 处理逻辑
        userService.updateProfile(
                authentication.getName(),
                request.nickname(),
                request.avatarId()
        );
        return ResponseEntity.ok().build();
    }
    /**
     * API: 获取个人资料
     * GET /api/user/profile
     */
    @GetMapping("/profile")
    public ResponseEntity<UserProfileResponse> getProfile(Authentication authentication) {
        String username = authentication.getName();

        // 复用 AppUserRepository 查找用户
        AppUser user = appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // 构建响应 (如果字段为空，使用默认值)
        String displayNick = user.getNickname() != null ? user.getNickname() : user.getUsername();
        String displayAvatar = user.getAvatarId() != null ? user.getAvatarId() : "default";

        return ResponseEntity.ok(new UserProfileResponse(
                user.getUsername(),
                displayNick,
                displayAvatar
        ));
    }
}