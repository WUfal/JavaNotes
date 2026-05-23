package com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.SearchResultDto;
import com.suat.app.backend.todo_service.service.SearchService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/search") // 搜索 API 的统一前缀
public class SearchController {

    @Autowired
    private SearchService searchService;

    /**
     * API: 执行搜索
     * (这个 API 会被 /api/v1/** 规则自动保护)
     * (URL 示例: /api/v1/search?q=java)
     *
     * @param query 用户的搜索词 (来自 "q" 参数)
     */
    @GetMapping
    public List<SearchResultDto> search(@RequestParam("q") String query) {
        return searchService.search(query);
    }
}