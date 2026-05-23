package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.BadgeDto;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.service.BadgeService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/badges") // (受 /api/v1/** 保护)
public class BadgeController {

    @Autowired
    private BadgeService badgeService;

    @Autowired
    private AppUserRepository appUserRepository; // (用于根据用户名查找 AppUser)

    /**
     * API 1: 获取当前用户的所有徽章
     */
    @GetMapping("/my")
    public List<BadgeDto> getMyBadges(Authentication authentication) {
        String username = authentication.getName();
        AppUser user = appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        return badgeService.getMyBadges(user);
    }
}