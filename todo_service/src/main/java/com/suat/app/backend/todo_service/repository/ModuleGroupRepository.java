package com.suat.app.backend.todo_service.repository;


import com.suat.app.backend.todo_service.entity.ModuleGroup;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository // 告诉 Spring 这是一个数据仓库 Bean
public interface ModuleGroupRepository extends JpaRepository<ModuleGroup, Long> {

    // Spring Data JPA 会自动根据方法名“猜”出我们要的SQL！
    // "findBy..."  -> "SELECT * FROM module_group ..."
    // "...OrderBySortOrderAsc" -> "... ORDER BY sort_order ASC"
    //
    // 功能：查找所有分组，并按 sortOrder 字段升序排列
    List<ModuleGroup> findByOrderBySortOrderAsc();
}