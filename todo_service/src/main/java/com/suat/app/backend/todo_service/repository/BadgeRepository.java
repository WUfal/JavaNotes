package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.Badge;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface BadgeRepository extends JpaRepository<Badge, String> {
}