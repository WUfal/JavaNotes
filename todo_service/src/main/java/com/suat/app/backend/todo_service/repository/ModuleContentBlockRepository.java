package com.suat.app.backend.todo_service.repository;


import com.suat.app.backend.todo_service.entity.ModuleContentBlock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface ModuleContentBlockRepository extends JpaRepository<ModuleContentBlock, Long> {
    // 暂时不需要
}