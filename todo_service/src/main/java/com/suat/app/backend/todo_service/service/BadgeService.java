package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.dto.BadgeDto;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.Badge;
import com.suat.app.backend.todo_service.entity.UserBadge;
import com.suat.app.backend.todo_service.repository.BadgeRepository;
import com.suat.app.backend.todo_service.repository.UserBadgeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
public class BadgeService {

    @Autowired
    private UserBadgeRepository userBadgeRepository;

    @Autowired
    private BadgeRepository badgeRepository; // (用于获取徽章“定义”)

    /**
     * API 1 (查看): 获取一个用户的所有徽章
     */
    @Transactional(readOnly = true)
    public List<BadgeDto> getMyBadges(AppUser user) {
        List<UserBadge> userBadges = userBadgeRepository.findByAppUser(user);
        return userBadges.stream()
                .map(BadgeDto::fromEntity)
                .collect(Collectors.toList());
    }

    /**
     * 逻辑 1 (授予): 尝试授予一个徽章
     * (这是一个内部调用的方法)
     */
    @Transactional
    public void checkAndAwardBadge(AppUser user, String badgeId) {
        // 1. 检查用户是否 *已* 拥有此徽章
        if (userBadgeRepository.existsByAppUserAndBadgeId(user, badgeId)) {
            return; // (已拥有，什么也不做)
        }

        // 2. 检查徽章“定义”是否存在
        Optional<Badge> badgeOpt = badgeRepository.findById(badgeId);
        if (badgeOpt.isEmpty()) {
            System.err.println("BadgeService: 无法找到徽章定义: " + badgeId);
            return; // (徽章定义不存在)
        }

        // 3. (授予徽章) 创建 UserBadge 记录
        UserBadge userBadge = new UserBadge();
        userBadge.setAppUser(user);
        userBadge.setBadge(badgeOpt.get());

        userBadgeRepository.save(userBadge);
    }
}