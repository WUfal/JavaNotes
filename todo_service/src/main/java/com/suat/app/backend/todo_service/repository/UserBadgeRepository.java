package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.entity.UserBadge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;
import java.util.Optional; // (我们稍后会用到，先加上)

@Repository
public interface UserBadgeRepository extends JpaRepository<UserBadge, Long> {

    // (这个是 B 路径“收藏夹”用的)
    boolean existsByAppUserAndBadgeId(AppUser appUser, String badgeId);

    // (这个是 A 路径“我的徽章”页面用的)
    List<UserBadge> findByAppUser(AppUser appUser);

    // --- ⬇️ (关键修复) ⬇️ ---
    // (这是 BeginnerLearnService 需要的 "检查" 方法)
    // (Spring Data JPA 会自动实现它:
    //  "SELECT CASE WHEN COUNT(ub) > 0 THEN true ELSE false END FROM UserBadge ub WHERE ub.appUser = ?1")
    boolean existsByAppUser(AppUser appUser);
    // --- ⬆️ (修复结束) ⬆️ ---
}