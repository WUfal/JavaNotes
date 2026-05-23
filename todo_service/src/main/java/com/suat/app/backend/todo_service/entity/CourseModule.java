package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*;
import java.util.List;
import lombok.Getter;
import lombok.Setter;

@Entity
@Table(name = "course_module")
@Getter
@Setter
public class CourseModule {

    @Id // 标记这是主键
    // 注意：这里没有 @GeneratedValue
    // 因为我们将使用我们自己的ID，比如 "core_oop", "core_collections"
    private String id;

    @Column(nullable = false)
    private String title;

    @Column(columnDefinition = "TEXT") // 允许存储长文本
    private String description;

    // 关键：建立“多对一”关系
    // "多个模块项 (Many)" 属于 "一个分组 (One)"
    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "group_id") // 在 'course_module' 表中创建一个 'group_id' 列作为外键
    private ModuleGroup group;

    // 关键：“一对多”关系
    // "一个课程模块 (One)" 包含 "多个内容块 (Many)"
    @OneToMany(mappedBy = "module", cascade = CascadeType.ALL, orphanRemoval = true)
    @OrderBy("sortOrder ASC") // 内容块必须按顺序排列！
    private List<ModuleContentBlock> contentBlocks;
}