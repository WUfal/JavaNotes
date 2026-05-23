package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.BeginnerLevel;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface BeginnerLevelRepository extends JpaRepository<BeginnerLevel, Long> {

    // Spring Data JPA 魔法：按 sortOrder 升序查找所有
    List<BeginnerLevel> findByOrderBySortOrderAsc();
}