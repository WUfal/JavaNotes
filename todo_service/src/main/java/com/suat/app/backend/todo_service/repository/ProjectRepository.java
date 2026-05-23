package com.suat.app.backend.todo_service.repository;

import com.suat.app.backend.todo_service.entity.Project;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query; // <--- (新增) 导入
import org.springframework.stereotype.Repository;

import java.util.List; // <--- (新增) 导入

@Repository
public interface ProjectRepository extends JpaRepository<Project, String> {

    // --- ⬇️ (关键修改) ⬇️ ---
    // (我们不再信任 findAll())
    // (我们自己写一个 JPQL 查询来获取所有 'Project' 实体，
    //  并且 'LEFT JOIN FETCH p.steps' 告诉它立即“抓取”所有关联的步骤，
    //  这是一个很好的性能优化)
    @Query("SELECT DISTINCT p FROM Project p LEFT JOIN FETCH p.steps")
    List<Project> findAllWithSteps();
    List<Project> findByTitleContainingIgnoreCaseOrDescriptionContainingIgnoreCase(String title, String description);
}