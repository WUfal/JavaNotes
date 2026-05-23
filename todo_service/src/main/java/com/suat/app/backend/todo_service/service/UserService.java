package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
public class UserService {

    @Autowired
    private AppUserRepository appUserRepository;

    @Transactional
    public void updateProfile(String username, String nickname, String avatarId) {
        AppUser user = appUserRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        // 仅当字段不为空时更新
        if (nickname != null && !nickname.isBlank()) {
            user.setNickname(nickname);
        }
        if (avatarId != null && !avatarId.isBlank()) {
            user.setAvatarId(avatarId);
        }

        appUserRepository.save(user);
    }

    // (可选) 你可以在这里添加更多用户相关的业务逻辑
}