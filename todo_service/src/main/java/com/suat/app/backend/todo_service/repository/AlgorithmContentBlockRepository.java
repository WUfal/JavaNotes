package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.AlgorithmContentBlock;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

@Repository
public interface AlgorithmContentBlockRepository extends JpaRepository<AlgorithmContentBlock, Long> {
}