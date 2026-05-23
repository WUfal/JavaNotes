package   com.suat.app.backend.todo_service.Controller;

import com.suat.app.backend.todo_service.dto.AlgorithmDetail;
import com.suat.app.backend.todo_service.dto.AlgorithmSummary;
import com.suat.app.backend.todo_service.service.AlgorithmService; // 1. 导入新 Service
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

@RestController
@RequestMapping("/api/v1/algorithms") // 算法API的统一前缀
public class AlgorithmController {

    // 2. 注入(Inject) Service
    @Autowired
    private AlgorithmService algorithmService;

    /**
     * API 1: 获取所有算法题的摘要列表 (已改造)
     */
    @GetMapping
    public List<AlgorithmSummary> getAllAlgorithms() {
        // 3. 调用 Service
        return algorithmService.getAllAlgorithms();
    }

    /**
     * API 2: 获取单个算法题的详细内容 (已改造)
     */
    @GetMapping("/{problemId}")
    public ResponseEntity<AlgorithmDetail> getAlgorithmDetail(@PathVariable String problemId) {
        try {
            // 4. 调用 Service
            AlgorithmDetail detail = algorithmService.getAlgorithmDetail(problemId);
            return ResponseEntity.ok(detail); // 返回 200 OK
        } catch (RuntimeException e) {
            // 5. 没找到则返回 404
            return ResponseEntity.notFound().build();
        }
    }

    // 6. 所有硬编码的辅助方法 (createTwoSumProblem 等)
    //    都已被删除！
}