package com.suat.app.backend.todo_service.entity;

import jakarta.persistence.*; // 导入 Java/Jakarta Persistence API
import java.util.List;
import lombok.Getter; // 使用 Lombok 来自动生成 Getter/Setter
import lombok.Setter;

@Entity
@Table(name = "module_group") // 告诉 JPA 这对应数据库中的 'module_group' 表
@Getter
@Setter
public class ModuleGroup {

    @Id // 标记这是主键 (Primary Key)
    @GeneratedValue(strategy = GenerationType.IDENTITY) // 告诉数据库：这个ID是自动递增的
    private Long id;

    @Column(nullable = false) // 不允许为空
    private String title; // "核心基础", "高级主题", ...

    @Column(name = "sort_order") // 数据库里的列名叫 'sort_order'
    private int sortOrder; // 用于排序

    // 关键：建立“一对多”关系
    // "一个分组 (One)" 对应 "多个模块项 (Many)"
    // 'mappedBy = "group"' 告诉 JPA，这个关系的配置在 CourseModule 类的 'group' 字段上
    @OneToMany(mappedBy = "group", cascade = CascadeType.ALL, fetch = FetchType.LAZY)
    @OrderBy("title ASC") // 让组内的模块按标题排序
    private List<CourseModule> modules;
}