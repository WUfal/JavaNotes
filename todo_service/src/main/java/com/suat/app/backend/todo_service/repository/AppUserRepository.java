package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AppUser;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface AppUserRepository extends JpaRepository<AppUser, Long> {

    // Spring Data JPA 魔法：
    // 自动创建一个 "SELECT * FROM app_user WHERE username = ?" 查询
    Optional<AppUser> findByUsername(String username);
}