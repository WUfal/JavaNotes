package com.suat.app.backend.todo_service.service;

import com.suat.app.backend.todo_service.dto.CodeRunResponse;
import com.suat.app.backend.todo_service.entity.AppUser;
import com.suat.app.backend.todo_service.repository.AppUserRepository;
import com.suat.app.backend.todo_service.repository.UserBadgeRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import javax.tools.JavaCompiler;
import javax.tools.ToolProvider;
import java.io.ByteArrayOutputStream;
import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.concurrent.TimeUnit;

@Service
public class SandboxService {

    private static final int TIMEOUT_SECONDS = 5; // 限制代码最长运行5秒

    @Autowired
    private BadgeService badgeService;

    @Autowired
    private AppUserRepository appUserRepository;

    @Autowired
    private UserBadgeRepository userBadgeRepository;

    public CodeRunResponse compileAndRun(String code, String username) {

        // 1. 获取 Java 编译器
        // 注意：运行 Jar 包的环境必须安装 JDK，而不仅仅是 JRE，否则这里会返回 null
        JavaCompiler compiler = ToolProvider.getSystemJavaCompiler();
        if (compiler == null) {
            return new CodeRunResponse("", "Fatal Error: JDK Compiler not found.\n请确保服务器安装了 JDK，并且运行命令使用的是 JDK 中的 java。");
        }

        // 2. 创建一个临时目录
        Path tempDir;
        try {
            tempDir = Files.createTempDirectory("java-sandbox-");
        } catch (IOException e) {
            return new CodeRunResponse("", "Failed to create temp directory: " + e.getMessage());
        }

        Path javaFile = null;
        Path classFile = null;

        try {
            // 3. 从代码中提取类名
            String className = extractClassName(code);
            if (className == null) {
                return new CodeRunResponse("", "Could not find 'public class ...' definition.");
            }

            javaFile = tempDir.resolve(className + ".java");
            classFile = tempDir.resolve(className + ".class");

            // 4. 预置 Import
            String imports = """
                import java.util.*;
                import java.util.stream.*;
                import java.text.*;
                import java.math.*;
                import java.io.*;
                """;

            // 拼接代码
            String fullCode = imports + "\n" + code;

            // 写入完整代码
            Files.writeString(javaFile, fullCode);

            // 5. 编译
            ByteArrayOutputStream compileErrStream = new ByteArrayOutputStream();
            int compileResult = compiler.run(null, null, compileErrStream, javaFile.toString());

            if (compileResult != 0) {
                return new CodeRunResponse("", "Compilation Failed:\n" + compileErrStream.toString());
            }

            // --- 徽章逻辑 ---
            try {
                AppUser user = appUserRepository.findByUsername(username)
                        .orElseThrow(() -> new RuntimeException("User not found"));
                final String badgeId = "CODE_RUNNER";
                if (!userBadgeRepository.existsByAppUserAndBadgeId(user, badgeId)) {
                    badgeService.checkAndAwardBadge(user, badgeId);
                }
            } catch (Exception e) {
                // 忽略徽章错误，不要影响代码运行
                System.err.println("Badge award failed: " + e.getMessage());
            }
            // ----------------

            // 6. (关键修复) 获取当前 JVM 的绝对路径来运行代码
            // 解决 error=2, no such file or directory
            String javaHome = System.getProperty("java.home");
            String javaBin = javaHome + File.separator + "bin" + File.separator + "java";
            // Windows 系统需要加 .exe 后缀
            if (System.getProperty("os.name").toLowerCase().contains("win")) {
                javaBin += ".exe";
            }

            // 使用绝对路径启动 java
            ProcessBuilder pb = new ProcessBuilder(javaBin, "-cp", tempDir.toString(), className);
            pb.redirectErrorStream(true); // 将 stderr 合并到 stdout

            Process p = pb.start();

            // 7. 添加超时
            if (!p.waitFor(TIMEOUT_SECONDS, TimeUnit.SECONDS)) {
                p.destroy(); // 强行终止
                return new CodeRunResponse("", "Execution timed out (Limit: " + TIMEOUT_SECONDS + "s).");
            }

            // 8. 获取输出
            String output = new String(p.getInputStream().readAllBytes());
            return new CodeRunResponse(output, ""); // 成功

        } catch (IOException | InterruptedException e) {
            return new CodeRunResponse("", "Runtime error: " + e.getMessage());
        } finally {
            // 9. 清理临时文件
            try {
                if (javaFile != null) Files.deleteIfExists(javaFile);
                if (classFile != null) Files.deleteIfExists(classFile);
                if (tempDir != null) Files.deleteIfExists(tempDir);
            } catch (IOException e) {
                System.err.println("Failed to clean up temp files: " + e.getMessage());
            }
        }
    }

    private String extractClassName(String code) {
        String[] lines = code.split("\n");
        for (String line : lines) {
            line = line.trim();
            if (line.startsWith("public class ")) {
                // 截取 "public class " 之后的部分，并在 "{" 之前停止
                String temp = line.substring(13).trim();
                if (temp.contains("{")) {
                    return temp.substring(0, temp.indexOf("{")).trim();
                } else {
                    return temp.trim();
                }
            }
        }
        return "HelloWorld";
    }
}