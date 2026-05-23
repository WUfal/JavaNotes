-- -----------------------------------------------------
-- E-commerce Backend API Project (Java) SQL Insertion Script
-- -----------------------------------------------------
-- This script inserts the full project tutorial based on the provided document.
-- Project ID: 'proj_ecommerce_api'
-- -----------------------------------------------------
-----------------------------------------------------
-- 2. B 路径：项目 (Project)
-----------------------------------------------------
-- (Project 摘要)
-- (Project 摘要)
INSERT INTO project (id, title, description, tech_stack) VALUES
                                                             ('proj_ecommerce_api', '电商后端API实战', '使用Spring Boot构建一个简单的电商API', 'Spring Boot, JPA'),
                                                             ('proj_chat_app', '简易聊天室', '使用WebSocket和Spring构建实时聊天', 'Spring WebSocket');
-- Step 1: 项目介绍 (Introduction)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (1, '电商后端API实战(Java项目)全流程步骤', 1, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '电商后端API的核心是实现“用户-商品-订单-支付”的完整业务闭环,以下是基于Spring Boot生态的实战全流程,从需求分析到部署上线,覆盖开发、测试、优化全环节,适合新手入门到实战进阶。',
        NULL, 1, 'text', 1
    );

-- Step 2: 阶段1: 前期准备 (Phase 1: Prep)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (2, '阶段1: 前期准备 (需求分析 + 技术选型)', 2, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '1.1 核心需求分析 (明确“做什么”)',
        NULL, 1, 'sub-header', 2
    ),
    (
        '(1) 功能需求 (核心模块)',
        NULL, 2, 'sub-header', 2
    ),
    (
        '**核心模块功能需求**
- **用户模块**: 注册、登录、个人信息查询/修改、地址管理(新增/编辑/删除)
- **商品模块**: 商品列表(分页+条件查询)、商品详情、分类查询、库存查询
- **购物车模块**: 新增商品、修改数量、删除商品、查询购物车、清空购物车
- **订单模块**: 创建订单、订单列表(分页)、订单详情、订单状态更新(待支付/已支付/已发货)、取消订单
- **支付模块**: 对接第三方支付(支付宝/微信沙箱)、支付回调处理、支付状态查询
- **通用功能**: 全局异常处理、统一返回结果、数据校验、登录拦截、日志记录',
        NULL, 3, 'text', 2
    ),
    (
        '(2) 非功能需求 (技术指标)',
        NULL, 4, 'sub-header', 2
    ),
    (
        '- **性能**: 接口响应时间 ≤ 500ms, 支持 1000+ QPS (普通场景)
- **安全性**: 密码加密存储、接口权限控制、防SQL注入/XSS攻击
- **可用性**: 核心接口可用性 ≥ 99.9%, 支持单机/集群部署
- **可扩展性**: 模块解耦, 支持后续微服务拆分、功能迭代',
        NULL, 5, 'text', 2
    ),
    (
        '1.2 技术选型 (明确“用什么”)',
        NULL, 6, 'sub-header', 2
    ),
    (
        '基于Java主流生态, 兼顾“易用性”和“实战性”, 选型如下:',
        NULL, 7, 'text', 2
    ),
    (
        '**技术选型方案**
- **核心框架**: Spring Boot 3.x (简化配置, 快速开发)
- **持久层**: MyBatis-Plus 3.x (简化CRUD, 支持分页、条件构造)
- **数据库**: MySQL 8.0 (关系型数据库, 适配电商结构化数据)
- **缓存**: Redis 6.x (缓存热点商品、购物车、用户Token, 提升性能)
- **消息队列**: RabbitMQ 3.x (异步处理订单创建、支付回调, 解耦服务)
- **接口文档**: Knife4j (基于Swagger, 可视化接口调试, 支持导出文档)
- **身份认证**: JWT (无状态登录, 支持分布式部署)
- **数据校验**: Spring Validation (参数合法性校验, 如手机号、密码格式)
- **工具类**: Hutool (简化日期、加密、字符串处理)
- **测试工具**: JUnit 5 (单元测试)、Postman (接口测试)、JMeter (性能测试)
- **部署环境**: JDK 17、Linux (CentOS 7+/Ubuntu 20.04)、Maven 3.8+',
        NULL, 8, 'text', 2
    );

-- Step 3: 阶段2: 架构设计 (Phase 2: Architecture)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (3, '阶段2: 架构设计 (搭建“骨架”)', 3, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '2.1 整体架构 (单体架构, 适合快速落地)',
        NULL, 1, 'sub-header', 3
    ),
    (
        '**电商后端API (Spring Boot) 架构**
1. **控制层 (Controller)**: 暴露API接口, 接收请求/返回响应
2. **业务层 (Service)**: 核心业务逻辑处理 (事务控制)
3. **数据访问层 (Mapper/DAO)**: 操作数据库 (MyBatis-Plus)
4. **实体层 (Entity/Model)**: 数据库实体(Entity)、DTO(入参)、VO(出参)
5. **通用层 (Common)**: 全局异常、统一返回、工具类、常量
6. **配置层 (Config)**: Redis、RabbitMQ、MyBatis等配置
7. **拦截器/过滤器 (Interceptor/Filter)**: 登录验证、权限控制',
        NULL, 2, 'text', 3
    ),
    (
        '2.2 数据库设计 (核心表结构)',
        NULL, 3, 'sub-header', 3
    ),
    (
        '遵循“三范式”, 核心表设计如下 (字段简化, 实战需补充更多字段):',
        NULL, 4, 'text', 3
    ),
    (
        '**核心表结构**
- **user (用户表)**: id、username、password(加密)、phone、avatar、create_time、update_time
- **user_address (用户地址表)**: id、user_id、receiver、phone、province、city、detail_address、is_default
- **category (分类表)**: id、name、parent_id(父分类)、sort、status(启用/禁用)
- **product (商品表)**: id、name、category_id、price、stock、sales、pic_url、description、status
- **cart (购物车表)**: id、user_id、product_id、quantity、select_status(是否选中)、create_time
- **order (订单表)**: id、order_no(订单号)、user_id、total_amount、pay_amount、status(状态)、pay_time、create_time
- **order_item (订单项表)**: id、order_no、product_id、product_name、price、quantity、sub_amount
- **pay_log (支付日志表)**: id、order_no、pay_no(支付单号)、pay_type、amount、status、callback_data',
        NULL, 5, 'text', 3
    ),
    (
        '关键设计',
        NULL, 6, 'sub-header', 3
    ),
    (
        '- **订单号 (order_no)**: 采用“时间戳+随机数”生成 (如20251116123456789012), 确保唯一
- **密码存储**: 用BCrypt加密 (不可逆), 避免明文存储
- **关联关系**: 订单(1)→订单项(N)、用户(1)→地址(N)、商品(1)→分类(1)',
        NULL, 7, 'text', 3
    ),
    (
        '2.3 接口设计 (RESTful风格)',
        NULL, 8, 'sub-header', 3
    ),
    (
        '遵循“资源导向”, 接口命名规范:
- **GET**: 查询资源 (如 /api/v1/products: 查询商品列表)
- **POST**: 创建资源 (如 /api/v1/orders: 创建订单)
- **PUT**: 更新资源 (如 /api/v1/users/address: 修改地址)
- **DELETE**: 删除资源 (如 /api/v1/cart/{productId}: 删除购物车商品)',
        NULL, 9, 'text', 3
    ),
    (
        '核心接口示例',
        NULL, 10, 'sub-header', 3
    ),
    (
        '**用户模块**
- `POST /api/v1/users/register`: 用户注册
- `POST /api/v1/users/login`: 用户登录 (返回Token)
- `GET /api/v1/users/info`: 查询个人信息
**商品模块**
- `GET /api/v1/products`: 商品列表 (分页+)
- `GET /api/v1/products/{id}`: 商品详情
**购物车模块**
- `POST /api/v1/cart`: 添加商品到购物车
- `GET /api/v1/cart`: 查询购物车
**订单模块**
- `POST /api/v1/orders`: 创建订单
- `GET /api/v1/orders/{orderNo}`: 订单详情
**支付模块**
- `POST /api/v1/pay/alipay/{orderNo}`: 支付宝支付
- `POST /api/v1/pay/callback/alipay`: 支付宝支付回调',
        NULL, 11, 'text', 3
    );

-- Step 4: 阶段3: 环境搭建 (Phase 3: Env Setup)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (4, '阶段3: 环境搭建 (搭建“开发环境”)', 4, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '3.1 本地环境准备',
        NULL, 1, 'sub-header', 4
    ),
    (
        '**1. 安装基础软件:**
- JDK 17 (配置环境变量 JAVA_HOME)
- IDE: IntelliJ IDEA (安装Lombok、MyBatis-Plus插件)
- Maven 3.8+ (配置阿里云镜像, 加速依赖下载)
- 中间件: MySQL 8.0、Redis 6.x、RabbitMQ 3.x (本地启动或用Docker容器)

**2. 验证环境:**
- 命令行输入 `java -version`: 显示JDK17版本
- 连接MySQL: 用Navicat测试连接 (地址 localhost:3306, 用户名 root)
- Redis: `redis-cli ping` 返回 PONG
- RabbitMQ: 访问 http://localhost:15672 (默认账号 guest/guest)',
        NULL, 2, 'text', 4
    ),
    (
        '3.2 项目初始化 (Spring Boot项目创建)',
        NULL, 3, 'sub-header', 4
    ),
    (
        '**1. 用Spring Initializr创建项目 (官网: https://start.spring.io/):**
- **配置**: Group (如 com.ecommerce)、Artifact (如 ecommerce-api)、Spring Boot 3.2.x
- **依赖选择**: Spring Web、MyBatis-Plus、MySQL Driver、Redis Starter、Spring Validation、Lombok、Knife4j、Spring AMQP (RabbitMQ)',
        NULL, 4, 'text', 4
    ),
    (
        '2. 配置 application.yml (核心配置)',
        NULL, 5, 'sub-header', 4
    ),
    (
        E'spring:
  # 数据库配置
  datasource:
    url: jdbc:mysql://localhost:3306/ecommerce_db?useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: 123456
    driver-class-name: com.mysql.cj.jdbc.Driver

  # Redis配置
  redis:
    host: localhost
    port: 6379
    password:
    database: 0

  # RabbitMQ配置
  rabbitmq:
    host: localhost
    port: 5672
    username: guest
    password: guest
    virtual-host: /

# MyBatis-Plus配置
mybatis-plus:
  mapper-locations: classpath:mapper/*.xml # Mapper.xml路径
  type-aliases-package: com.ecommerce.entity #实体类别名包
  configuration:
    map-underscore-to-camel-case: true #下划线转驼峰
    log-impl: org.apache.ibatis.logging.stdout.StdoutImpl # 打印SQL日志

# 服务器配置
server:
  port: 8080
  servlet:
    context-path: /api/v1 #接口前缀

# Knife4j接口文档配置
knife4j:
  enable: true
  openapi:
    title: 电商后端API文档
    version: 1.0
    description: 电商项目核心接口文档(用户、商品、订单、支付)',
        'yaml', 6, 'code', 4
    ),
    (
        '3. 初始化数据库',
        NULL, 7, 'sub-header', 4
    ),
    (
        '- 在MySQL中创建数据库 `ecommerce_db`
- 用Navicat执行“表结构SQL脚本” (创建上述核心表)
- 可选: 插入测试数据 (如商品分类、测试商品)',
        NULL, 8, 'text', 4
    );

-- Step 5: 阶段4: 核心模块开发 (通用层)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (5, '阶段4: 核心模块开发 (通用层)', 5, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '按“通用层→基础模块→核心模块”的顺序开发, 避免重复编码。',
        NULL, 1, 'text', 5
    ),
    (
        '4.1 通用层开发 (先搭“工具架”)',
        NULL, 2, 'sub-header', 5
    ),
    (
        '(1) 统一返回结果类 (Result.java)',
        NULL, 3, 'sub-header', 5
    ),
    (
        E'import lombok.Data;

@Data
public class Result<T> {
    // 响应码(200成功, 500失败, 401未登录)
    private int code;
    private String message; // 响应信息
    private T data; // 响应数据

    // (私有构造函数)
    private Result(int code, String message, T data) {
        this.code = code;
        this.message = message;
        this.data = data;
    }

    // 静态工厂方法 (简化调用)
    public static <T> Result<T> success(T data) {
        return new Result<>(200, "操作成功", data);
    }

    public static <T> Result<T> error(String message) {
        return new Result<>(500, message, null);
    }

    public static <T> Result<T> unAuth() {
        return new Result<>(401, "未登录或Token失效", null);
    }
}',
        'java', 4, 'code', 5
    ),
    (
        '(2) 全局异常处理 (GlobalExceptionHandler.java)',
        NULL, 5, 'sub-header', 5
    ),
    (
        E'import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
// (注: Spring Boot 3.x 需导入 jakarta.validation.ConstraintViolationException)
// (注: BusinessException 需要自行定义, 如下)

@RestControllerAdvice // 全局异常拦截
public class GlobalExceptionHandler {

    // 处理业务异常 (自定义异常)
    @ExceptionHandler(BusinessException.class)
    public Result<Void> handleBusinessException(BusinessException e) {
        return Result.error(e.getMessage());
    }

    // 处理参数校验异常
    @ExceptionHandler(MethodArgumentNotValidException.class)
    public Result<Void> handleValidException(MethodArgumentNotValidException e) {
        // 获取第一个校验失败的字段的错误信息
        String message = e.getBindingResult().getFieldError().getDefaultMessage();
        return Result.error(message);
    }

    // 处理系统异常 (兜底)
    @ExceptionHandler(Exception.class)
    public Result<Void> handleException(Exception e) {
        e.printStackTrace(); // 实际项目中应使用日志框架记录
        return Result.error("系统异常, 请联系管理员");
    }
}

// 自定义业务异常
public class BusinessException extends RuntimeException {
    public BusinessException(String message) {
        super(message);
    }
}',
        'java', 6, 'code', 5
    ),
    (
        '(3) JWT登录拦截器 (LoginInterceptor.java) 与配置',
        NULL, 7, 'sub-header', 5
    ),
    (
        E'import org.springframework.context.annotation.Configuration;
import org.springframework.web.servlet.HandlerInterceptor;
import org.springframework.web.servlet.config.annotation.InterceptorRegistry;
import org.springframework.web.servlet.config.annotation.WebMvcConfigurer;
// (注: Spring Boot 3.x 需导入 jakarta.servlet.http.HttpServletRequest 等)
// (假设 JwtUtil 和 UserContext (ThreadLocal) 工具类已存在)

public class LoginInterceptor implements HandlerInterceptor {

    @Override
    public boolean preHandle(HttpServletRequest request, HttpServletResponse response, Object handler) throws Exception {
        // 1. 获取请求头中的Token
        String token = request.getHeader("Authorization");

        // 2. 检查Token是否存在或格式是否正确
        if (token == null || !token.startsWith("Bearer ")) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"message\":\"未登录\",\"data\":null}");
            return false;
        }

        // 3. 验证Token (JWT工具类解析, 判断是否过期、合法)
        token = token.substring(7); // 去掉"Bearer "前缀

        boolean valid = JwtUtil.verifyToken(token); // (假设 JwtUtil.verifyToken 存在)
        if (!valid) {
            response.setContentType("application/json;charset=UTF-8");
            response.getWriter().write("{\"code\":401,\"message\":\"Token失效\",\"data\":null}");
            return false;
        }

        // 4. Token合法, 放行 (将用户ID存入ThreadLocal, 供后续业务使用)
        Long userId = JwtUtil.getUserIdFromToken(token); // (假设 JwtUtil.getUserIdFromToken 存在)
        UserContext.setUserId(userId); // (假设 UserContext.setUserId 存在)

        return true;
    }

    @Override
    public void afterCompletion(HttpServletRequest request, HttpServletResponse response, Object handler, Exception ex) throws Exception {
        // 请求结束后, 清理ThreadLocal, 防止内存泄漏
        UserContext.removeUserId();
    }
}

// 注册拦截器 (WebConfig.java)
@Configuration
public class WebConfig implements WebMvcConfigurer {

    @Override
    public void addInterceptors(InterceptorRegistry registry) {
        registry.addInterceptor(new LoginInterceptor())
                .addPathPatterns("/**") // 拦截所有接口
                .excludePathPatterns( // 放行无需登录的接口
                    "/users/register",
                    "/users/login",
                    "/products/**", // 商品查询通常无需登录
                    "/doc.html", // Knife4j 文档
                    "/webjars/**", // Knife4j 静态资源
                    "/v3/api-docs/**" // OpenAPI 规范
                );
    }
}',
        'java', 8, 'code', 5
    );

-- Step 6: 阶段4: 核心模块开发 (用户模块 - 1. 实体类)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (6, '阶段4: 核心模块开发 (用户模块 - 1. 实体类)', 6, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '4.2 核心模块开发 (按模块实现)
以“用户模块”为例, 开发流程:',
        NULL, 1, 'text', 6
    ),
    (
        '1. 实体类设计',
        NULL, 2, 'sub-header', 6
    ),
    (
        '数据库实体 (User.java): 对应 user 表',
        NULL, 3, 'sub-header', 6
    ),
    (
        E'import com.baomidou.mybatisplus.annotation.IdType;
import com.baomidou.mybatisplus.annotation.TableId;
import com.baomidou.mybatisplus.annotation.TableName;
import lombok.Data;
import java.time.LocalDateTime;

@Data
@TableName("user") // 对应数据库表名
public class User {
    @TableId(type = IdType.AUTO) // 主键自增
    private Long id;

    private String username;
    private String password; // 加密存储
    private String phone;
    private String avatar;

    // (MyBatis-Plus 自动填充功能, 此处暂不展示)
    private LocalDateTime createTime;
    private LocalDateTime updateTime;
}',
        'java', 4, 'code', 6
    ),
    (
        '入参DTO (UserLoginDTO.java): 接收前端登录参数',
        NULL, 5, 'sub-header', 6
    ),
    (
        E'import lombok.Data;
// (注: Spring Boot 3.x 应使用 jakarta.validation.constraints.NotBlank)
import javax.validation.constraints.NotBlank;

@Data
public class UserLoginDTO {
    @NotBlank(message = "用户名不能为空")
    private String username;

    @NotBlank(message = "密码不能为空")
    private String password;
}',
        'java', 6, 'code', 6
    ),
    (
        '出参VO (UserLoginVO.java): 返回给前端的登录结果',
        NULL, 7, 'sub-header', 6
    ),
    (
        E'import lombok.Data;

@Data
public class UserLoginVO {
    private Long userId;
    private String username;
    private String token; // JWT令牌
}',
        'java', 8, 'code', 6
    );

-- Step 7: 阶段4: 核心模块开发 (用户模块 - 2. Mapper层)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (7, '阶段4: 核心模块开发 (用户模块 - 2. Mapper层)', 7, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '2. Mapper层 (MyBatis-Plus)',
        NULL, 1, 'sub-header', 7
    ),
    (
        'UserMapper.java (接口)',
        NULL, 2, 'sub-header', 7
    ),
    (
        E'import com.baomidou.mybatisplus.core.mapper.BaseMapper;
import org.springframework.stereotype.Repository;
import com.ecommerce.entity.User; // (假设路径)

@Repository
public interface UserMapper extends BaseMapper<User> {
    // 基础CRUD方法 (如selectById、insert、updateById) 由 BaseMapper 提供

    // 自定义查询: 根据用户名查询用户
    // (实际项目中, 简单查询可用 Wrapper 代替, 此处演示 XML 写法)
    User selectByUsername(String username);
}',
        'java', 3, 'code', 7
    ),
    (
        'UserMapper.xml (SQL映射)',
        NULL, 4, 'sub-header', 7
    ),
    (
        E'<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE mapper PUBLIC "-//mybatis.org//DTD Mapper 3.0//EN"
        "http://mybatis.org/dtd/mybatis-3-mapper.dtd">
<mapper namespace="com.ecommerce.mapper.UserMapper">

    <select id="selectByUsername" resultType="com.ecommerce.entity.User">
        select * from user where username = #{username}
    </select>

</mapper>',
        NULL, 5, 'code', 7
    );

-- Step 8: 阶段4: 核心模块开发 (用户模块 - 3. Service层)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (8, '阶段4: 核心模块开发 (用户模块 - 3. Service层)', 8, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '3. Service层 (业务逻辑)',
        NULL, 1, 'sub-header', 8
    ),
    (
        E'import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.time.LocalDateTime;
// (假设 DTOs, VOs, User, UserMapper, JwtUtil, BusinessException 已导入)

@Service
public class UserService {

    @Autowired
    private UserMapper userMapper;

    // (最好将 PasswordEncoder 注册为 Bean, 此处为简化)
    private final BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

    // 登录业务
    public UserLoginVO login(UserLoginDTO loginDTO) {
        // 1. 查询用户是否存在
        // (实际项目推荐用 Wrapper 查询, 避免 XML)
        User user = userMapper.selectByUsername(loginDTO.getUsername());
        if (user == null) {
            throw new BusinessException("用户名不存在");
        }

        // 2. 验证密码 (BCrypt解密比对)
        boolean match = encoder.matches(loginDTO.getPassword(), user.getPassword());
        if (!match) {
            throw new BusinessException("密码错误");
        }

        // 3. 生成JWT令牌 (假设 JwtUtil 已实现)
        String token = JwtUtil.generateToken(user.getId(), user.getUsername());

        // 4. 封装返回结果
        UserLoginVO vo = new UserLoginVO();
        vo.setUserId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setToken(token);
        return vo;
    }

    // 注册业务 (事务控制: 确保数据一致性)
    @Transactional // 开启事务
    public void register(UserRegisterDTO registerDTO) {
        // 1. 校验用户名是否已存在
        User existUser = userMapper.selectByUsername(registerDTO.getUsername());
        if (existUser != null) {
            throw new BusinessException("用户名已被占用");
        }

        // 2. 密码加密
        String encryptedPwd = encoder.encode(registerDTO.getPassword());

        // 3. 保存用户信息
        User user = new User();
        user.setUsername(registerDTO.getUsername());
        user.setPassword(encryptedPwd);
        user.setPhone(registerDTO.getPhone());
        user.setCreateTime(LocalDateTime.now());
        user.setUpdateTime(LocalDateTime.now());

        userMapper.insert(user);

        // (如果注册后还有其他操作, 如发放优惠券, 事务可确保一致性)
    }

    // (供 Controller 调用)
    public User getUserById(Long userId) {
        User user = userMapper.selectById(userId);
        if (user == null) {
            throw new BusinessException("用户不存在");
        }
        return user;
    }
}',
        'java', 2, 'code', 8
    );

-- Step 9: 阶段4: 核心模块开发 (用户模块 - 4. Controller层)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (9, '阶段4: 核心模块开发 (用户模块 - 4. Controller层)', 9, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '4. Controller层 (接口暴露)',
        NULL, 1, 'sub-header', 9
    ),
    (
        E'import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
// (假设 Result, DTOs, VOs, UserService, UserContext 已导入)

@RestController
@RequestMapping("/users") // 统一前缀 (application.yml 中 /api/v1 基础上)
public class UserController {

    @Autowired
    private UserService userService;

    // 登录接口
    @PostMapping("/login")
    public Result<UserLoginVO> login(@Validated @RequestBody UserLoginDTO loginDTO) {
        UserLoginVO vo = userService.login(loginDTO);
        return Result.success(vo);
    }

    // 注册接口
    @PostMapping("/register")
    public Result<Void> register(@Validated @RequestBody UserRegisterDTO registerDTO) {
        userService.register(registerDTO);
        return Result.success(null);
    }

    // 查询个人信息接口 (需要登录)
    @GetMapping("/info")
    public Result<UserInfoVO> getUserInfo() {
        // 从ThreadLocal获取登录用户ID (由拦截器设置)
        Long userId = UserContext.getUserId();
        User user = userService.getUserById(userId);

        // 封装VO (隐藏密码等敏感信息)
        UserInfoVO vo = new UserInfoVO();
        // (此处可用 BeanUtils.copyProperties 简化)
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setPhone(user.getPhone());
        vo.setAvatar(user.getAvatar());

        return Result.success(vo);
    }
}',
        'java', 2, 'code', 9
    ),
    (
        '其他模块开发重点',
        NULL, 3, 'sub-header', 9
    ),
    (
        '- **商品模块**: 分页查询 (MyBatis-Plus的 Page 对象)、库存扣减 (需加锁, 防止超卖)
- **订单模块**: 创建订单时需关联购物车选中商品、扣减库存、生成订单号、事务控制
- **支付模块**: 对接支付宝沙箱 (调用SDK生成支付链接)、处理支付回调 (验签+更新订单状态)
- **购物车模块**: 用Redis存储 (Key: `cart:userId:{userId}`, Value: Hash结构存储商品ID和数量)',
        NULL, 4, 'text', 9
    );

-- Step 10: 阶段5: 中间件集成 (Redis)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (10, '阶段5: 通用功能与中间件集成 (Redis)', 10, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '5.1 缓存集成 (Redis)',
        NULL, 1, 'sub-header', 10
    ),
    (
        '**热点商品缓存**: 查询商品详情时, 先查Redis, 无则查数据库并缓存 (设置过期时间1小时)',
        NULL, 2, 'text', 10
    ),
    (
        '// 商品Service层 (ProductService) 示例
// (假设 redisTemplate, JSON, ProductVO, productMapper 已注入/存在)
// (假设 Product, BusinessException 已导入)
@Autowired
private StringRedisTemplate redisTemplate; // 推荐使用 StringRedisTemplate 存 JSON

public ProductVO getProductById(Long id) {
    // 1. 定义 Redis Key
    String key = "product:id:" + id;

    // 2. 先查Redis
    String json = redisTemplate.opsForValue().get(key);

    // 3. 缓存命中, 直接返回
    if (json != null && !json.isEmpty()) {
        // (此处应处理缓存穿透的空值)
        return JSON.parseObject(json, ProductVO.class);
    }

    // 4. 缓存未命中, 查数据库
    Product product = productMapper.selectById(id);
    if (product == null) {
        // (此处应处理缓存穿透: 缓存空值)
        throw new BusinessException("商品不存在");
    }

    // 5. 数据库查到, 转换VO
    ProductVO vo = convertToVO(product); // (假设存在转换方法)

    // 6. 存入Redis (设置1小时过期 + 随机扰动, 防雪崩)
    redisTemplate.opsForValue().set(
        key,
        JSON.toJSONString(vo),
        1,
        TimeUnit.HOURS // (可加随机秒)
    );

    return vo;
}',
        'java', 3, 'code', 10
    );

-- Step 11: 阶段5: 中间件集成 (RabbitMQ)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (11, '阶段5: 通用功能与中间件集成 (RabbitMQ)', 11, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '5.2 消息队列集成 (RabbitMQ)',
        NULL, 1, 'sub-header', 11
    ),
    (
        '**异步处理订单创建**: 用户下单后, 发送消息到RabbitMQ, 异步更新商品销量、记录日志, 实现服务解耦。',
        NULL, 2, 'text', 11
    ),
    (
        '// 订单Service层 (OrderService) - 生产者
// (假设 rabbitTemplate 已注入, OrderMessage 实体已定义)
@Autowired
private RabbitTemplate rabbitTemplate;

@Transactional
public OrderVO createOrder(OrderCreateDTO dto) {
    // 1. 扣减库存、创建订单、创建订单项 (核心业务)
    // ... 省略核心逻辑...
    Order order = ...; // (假设已创建订单)
    Long userId = UserContext.getUserId();

    // 2. 发送消息到RabbitMQ (异步处理非核心业务)
    OrderMessage message = new OrderMessage();
    message.setOrderNo(order.getOrderNo());
    message.setUserId(userId);

    // (需要配置好 Exchange 和 RoutingKey)
    rabbitTemplate.convertAndSend("order.exchange", "order.create", message);

    // 3. 返回订单信息
    return convertToVO(order); // (假设存在转换方法)
}


// 消息消费者 (OrderMessageConsumer)
@Component
public class OrderMessageConsumer {

    @Autowired
    private ProductService productService; // (假设 ProductService 存在)

    private static final Logger log = LoggerFactory.getLogger(OrderMessageConsumer.class);


    @RabbitListener(queues = "order.create.queue") // 监听指定队列
    public void handleOrderCreate(OrderMessage message) {
        try {
            // 异步更新商品销量 (非核心)
            productService.updateSalesByOrderNo(message.getOrderNo());

            // 异步记录订单日志 (如存入数据库或ELK)
            log.info("订单创建成功 (异步任务): " + message.getOrderNo());

            // (如果消费失败, RabbitMQ 应配置重试机制)
        } catch (Exception e) {
            log.error("处理订单创建消息失败: ", e);
            // (抛出异常, 触发重试或进入死信队列)
            throw e;
        }
    }
}',
        'java', 3, 'code', 11
    );

-- Step 12: 阶段5: 中间件集成 (支付宝沙箱)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (12, '阶段5: 通用功能与中间件集成 (支付宝沙箱)', 12, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '5.3 支付集成 (支付宝沙箱)',
        NULL, 1, 'sub-header', 12
    ),
    (
        '1. 申请支付宝沙箱账号 (https://openhome.alipay.com/platform/appDaily.htm)',
        NULL, 2, 'text', 12
    ),
    (
        '2. 引入支付宝SDK依赖 (pom.xml)',
        NULL, 3, 'sub-header', 12
    ),
    (
        E'<dependency>
    <groupId>com.alipay.sdk</groupId>
    <artifactId>alipay-sdk-java</artifactId>
    <version>4.38.0.ALL</version> </dependency>',
        NULL, 4, 'code', 12
    ),
    (
        '3. 支付接口实现 (AlipayService.java)',
        NULL, 5, 'sub-header', 12
    ),
    (
        E'import com.alipay.api.AlipayApiException;
import com.alipay.api.AlipayClient;
import com.alipay.api.DefaultAlipayClient;
import com.alipay.api.internal.util.AlipaySignature;
import com.alipay.api.request.AlipayTradePagePayRequest;
import com.alipay.api.response.AlipayTradePagePayResponse;
import org.json.JSONObject; // (注意: 示例使用 org.json, 推荐 Fastjson 或 Jackson)
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import java.math.BigDecimal;
import java.util.Map;
// (假设 orderService 已注入, BusinessException 已定义)

@Service
public class AlipayService {

    // 支付宝配置 (从 application.yml 读取)
    @Value("${alipay.app-id}")
    private String appId;
    @Value("${alipay.private-key}")
    private String privateKey;
    @Value("${alipay.public-key}")
    private String alipayPublicKey; // (修正变量名)
    @Value("${alipay.notify-url}")
    private String notifyUrl; // 支付回调地址

    // 沙箱环境网关
    private final String GATEWAY_URL = "https://openapi.alipaydev.com/gateway.do";

    // 生成支付宝支付链接
    public String createPayUrl(String orderNo, BigDecimal amount, String subject) {
        AlipayClient client = new DefaultAlipayClient(GATEWAY_URL, appId,
                privateKey, "json", "UTF-8", alipayPublicKey, "RSA2");

        AlipayTradePagePayRequest request = new AlipayTradePagePayRequest();
        // 同步回调地址 (支付成功后浏览器跳转的地址)
        request.setReturnUrl("http://localhost:8080/api/v1/pay/return");
        // 异步回调地址 (支付宝服务器通知的地址)
        request.setNotifyUrl(notifyUrl);

        // 构建请求参数
        JSONObject bizContent = new JSONObject();
        bizContent.put("out_trade_no", orderNo); // 商家订单号
        bizContent.put("total_amount", amount.toString()); // 支付金额 (String)
        bizContent.put("subject", subject); // 商品名称
        bizContent.put("product_code", "FAST_INSTANT_TRADE_PAY"); // 支付产品码
        request.setBizContent(bizContent.toString());

        try {
            AlipayTradePagePayResponse response = client.pageExecute(request);
            if (response.isSuccess()) {
                return response.getBody(); // 返回支付宝支付页面HTML
            } else {
                throw new BusinessException("支付链接生成失败: " + response.getSubMsg());
            }
        } catch (AlipayApiException e) {
            e.printStackTrace();
            throw new BusinessException("支付链接生成异常");
        }
    }

    // 支付回调处理 (验签 + 更新订单状态)
    public String handleNotify(Map<String, String> params) {
        // 1. 验签 (验证回调是否来自支付宝)
        try {
            boolean signVerified = AlipaySignature.rsaCheckV1(params, alipayPublicKey, "UTF-8", "RSA2");
            if (!signVerified) {
                return "fail"; // 验签失败, 返回失败
            }
        } catch (AlipayApiException e) {
            e.printStackTrace();
            return "fail";
        }

        // 2. 解析回调参数
        String orderNo = params.get("out_trade_no");
        String tradeStatus = params.get("trade_status");

        // 3. 处理支付状态 (TRADE_SUCCESS: 支付成功)
        if ("TRADE_SUCCESS".equals(tradeStatus)) {
            // 4. (重要) 处理业务: 更新订单状态、记录支付日志
            // 此处必须做幂等性处理 (检查订单是否已是 "已支付" 状态)
            orderService.updateOrderPayStatus(orderNo, params.get("trade_no"));
        }

        return "success"; // 回调处理成功, 通知支付宝
    }
}',
        'java', 6, 'code', 12
    );

-- Step 13: 阶段6: 测试与优化 (测试环节)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (13, '阶段6: 测试与优化 (测试环节)', 13, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '6.1 测试环节',
        NULL, 1, 'sub-header', 13
    ),
    (
        '(1) 单元测试 (JUnit5)',
        NULL, 2, 'sub-header', 13
    ),
    (
        '测试Service层核心逻辑 (如用户登录、订单创建):',
        NULL, 3, 'text', 13
    ),
    (
        E'import org.junit.jupiter.api.Test;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.boot.test.context.SpringBootTest;
import static org.junit.jupiter.api.Assertions.*;

@SpringBootTest // 加载 Spring 上下文
public class UserServiceTest {

    @Autowired
    private UserService userService;

    @Test
    public void testLoginSuccess() {
        // (前提: 数据库中存在 "test" / "123456" 的加密后用户)
        UserLoginDTO dto = new UserLoginDTO();
        dto.setUsername("test");
        dto.setPassword("123456");

        UserLoginVO vo = userService.login(dto);
        assertNotNull(vo.getToken()); // 验证Token不为空
    }

    @Test
    public void testLoginFail() {
        UserLoginDTO dto = new UserLoginDTO();
        dto.setUsername("test"); // (假设 "test" 用户存在)
        dto.setPassword("wrongpassword"); // (使用错误密码)

        // 预期抛出 BusinessException 异常 (密码错误)
        assertThrows(BusinessException.class, () -> {
            userService.login(dto);
        });
    }
}',
        'java', 4, 'code', 13
    ),
    (
        '(2) 接口测试 (Postman/Knife4j)',
        NULL, 5, 'sub-header', 13
    ),
    (
        '- **Knife4j访问地址**: http://localhost:8080/api/v1/doc.html
- **测试场景**:
  - **正常场景**: 用户注册 → 登录 → 添加购物车 → 创建订单 → 支付
  - **异常场景**: 未登录创建订单、商品不存在、库存不足、支付超时',
        NULL, 6, 'text', 13
    );

-- Step 14: 阶段6: 测试与优化 (性能测试与项目优化)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (14, '阶段6: 测试与优化 (性能测试与项目优化)', 14, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '(3) 性能测试 (JMeter)',
        NULL, 1, 'sub-header', 14
    ),
    (
        '- **测试高并发场景**: 如商品列表查询、订单创建
- **配置**: 1000用户并发, 循环10次, 观察响应时间和错误率
- **优化方向**: 若响应时间过长, 优化SQL(加索引)、增加缓存、异步化处理',
        NULL, 2, 'text', 14
    ),
    (
        '6.2 项目优化',
        NULL, 3, 'sub-header', 14
    ),
    (
        '(1) SQL优化',
        NULL, 4, 'sub-header', 14
    ),
    (
        '- 为高频查询字段加索引 (如 product.id、order.user_id、order.order_no)
- 避免 `SELECT *`, 只查询需要的字段 (在 VO 和 DTO 中明确定义)
- 复杂查询用分页, 避免一次性查询大量数据',
        NULL, 5, 'text', 14
    ),
    (
        '(2) 缓存优化',
        NULL, 6, 'sub-header', 14
    ),
    (
        '- **缓存穿透**: (查不存在的数据) 查询不存在的商品时, 缓存空值 (设置短过期时间, 如5分钟)
- **缓存击穿**: (热点数据过期) 热点商品缓存过期时, 用分布式锁 (Redis SETNX) 防止大量请求同时打到数据库
- **缓存雪崩**: (大面积数据过期) 缓存过期时间加随机值 (如1小时±5分钟), 避免同时过期',
        NULL, 7, 'text', 14
    ),
    (
        '(3) 并发优化',
        NULL, 8, 'sub-header', 14
    ),
    (
        '- **超卖问题**: (高并发扣库存) 用Redis分布式锁或MySQL乐观锁 (version 字段) 控制库存扣减
- **接口限流**: (防刷) 用Redis (如 Sliding Window) 或 Sentinel 实现限流 (如每分钟每个用户最多创建5个订单)',
        NULL, 9, 'text', 14
    );

-- Step 15: 阶段7: 部署上线 (Phase 7: Deployment)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (15, '阶段7: 部署上线', 15, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '7.1 项目打包',
        NULL, 1, 'sub-header', 15
    ),
    (
        '- 用Maven打包: `mvn clean package -Dmaven.test.skip=true` (跳过单元测试)
- 生成的jar包在 target/ 目录下 (如 ecommerce-api-1.0.jar)',
        NULL, 2, 'text', 15
    ),
    (
        '7.2 服务器环境准备 (Linux)',
        NULL, 3, 'sub-header', 15
    ),
    (
        '**1. 安装依赖:**
- JDK 17: `yum install -y java-17-openjdk-devel` (CentOS)
- MySQL、Redis、RabbitMQ: 推荐用Docker安装 (简化配置)',
        NULL, 4, 'text', 15
    ),
    (
        'Docker 安装中间件示例:',
        NULL, 5, 'sub-header', 15
    ),
    (
        E'# 安装Docker后, 启动MySQL 8.0
docker run -d --name mysql -p 3306:3306 -e MYSQL_ROOT_PASSWORD=123456 mysql:8.0

# 启动Redis 6
docker run -d --name redis -p 6379:6379 redis:6

# 启动RabbitMQ (带管理界面)
docker run -d --name rabbitmq -p 5672:5672 -p 15672:15672 rabbitmq:3-management',
        'bash', 6, 'code', 15
    ),
    (
        '**2. 上传jar包:**
- 用 SCP、Xftp 或 rsync 将本地 `target/ecommerce-api-1.0.jar` 上传到服务器 (如 /opt/ecommerce/ 目录)',
        NULL, 7, 'text', 15
    ),
    (
        '7.3 启动项目',
        NULL, 8, 'sub-header', 15
    ),
    (
        '- **后台启动**: `nohup java -jar ecommerce-api-1.0.jar --spring.profiles.active=prod > app.log 2>&1 &`
  (使用 `prod` 配置文件, 将日志输出到 `app.log` 并后台运行)
- **查看日志**: `tail -f app.log` (验证是否启动成功)
- **访问接口**: `http://<服务器IP>:8080/api/v1/products` (测试商品列表接口)',
        NULL, 9, 'text', 15
    ),
    (
        '7.4 可选: 集群部署与监控',
        NULL, 10, 'sub-header', 15
    ),
    (
        '- **集群部署**: 多台服务器启动相同jar包, 用Nginx做反向代理和负载均衡
- **监控**: 集成Spring Boot Admin监控项目运行状态, ELK (Elasticsearch, Logstash, Kibana) 栈收集和分析日志',
        NULL, 11, 'text', 15
    );

-- Step 16: 阶段8: 项目拓展 (Phase 8: Extension)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (16, '阶段8: 项目拓展 (可选)', 16, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '1. **微服务改造**: 将单体拆分为用户服务、商品服务、订单服务、支付服务, 用Spring Cloud Alibaba (Nacos注册中心、Feign远程调用、Sentinel限流熔断)
2. **分布式事务**: (微服务改造后) 用Seata解决跨服务数据一致性问题 (如订单服务扣减库存、支付服务更新订单状态)
3. **搜索引擎**: 集成Elasticsearch实现商品全文检索 (支持关键词搜索、过滤、排序)
4. **秒杀功能**: 开发商品秒杀模块, 实现限流(Redis+Lua)、熔断、降级, 应对高并发
5. **后台管理系统**: 开发一个配套的后台管理前端 (如 Vue+Element UI), 调用本项目的API, 用于商品管理、订单管理、用户管理',
        NULL, 1, 'text', 16
    );

-- Step 17: 实战关键注意事项 (Key Notes)
INSERT INTO project_step (id, step_title, sort_order, project_id)
VALUES (17, '实战关键注意事项', 17, 'proj_ecommerce_api');

INSERT INTO project_content_block (content, language, sort_order, type, step_id)
VALUES
    (
        '1. **安全性**: 密码必须BCrypt加密、接口权限控制(JWT+拦截器)、防SQL注入(MyBatis-Plus参数绑定)、防XSS(过滤请求参数)
2. **数据一致性**: 库存扣减与订单创建必须原子操作(事务+锁), 支付回调需幂等处理(避免重复更新订单状态)
3. **可扩展性**: 模块解耦(Service层专注业务, Controller层专注接口), 关键配置外置(用Nacos配置中心或 application-prod.yml)
4. **日志与监控**: 关键业务(订单、支付)必须记录详细日志, 便于问题排查; 核心接口需监控响应时间和错误率',
        NULL, 1, 'text', 17
    ),
    (
        '按以上步骤, 可完成一个“功能完整、性能稳定、可落地”的电商后端API项目, 适合用于实战练习或求职项目展示。',
        NULL, 2, 'text', 17
    ),
    (
        '(注: 文档部分内容可能由AI生成)',
        NULL, 3, 'text', 17
    );

-- -----------------------------------------------------
-- (重要) 更新所有被修改表的序列号
-- -----------------------------------------------------

SELECT setval('project_step_id_seq', (SELECT MAX(id) FROM project_step));
SELECT setval('project_content_block_id_seq', (SELECT MAX(id) FROM project_content_block));