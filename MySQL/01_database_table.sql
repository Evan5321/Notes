-- ============================================================
-- MySQL 学习笔记 01: 数据库/数据表的创建、删除、选择 及 数据类型
-- ============================================================
-- 本文包含:
--   1. 创建/删除/选择数据库
--   2. MySQL 常用数据类型
--   3. 创建/删除/查看数据表
-- ============================================================

-- ============================================================
-- 第一部分: 数据库操作
-- ============================================================

-- 查看所有数据库
SHOW DATABASES;

-- 创建数据库
-- 语法: CREATE DATABASE [IF NOT EXISTS] 数据库名 [DEFAULT CHARSET 字符集];
CREATE DATABASE IF NOT EXISTS school
    DEFAULT CHARSET utf8mb4      -- 推荐使用 utf8mb4（支持emoji）
    DEFAULT COLLATE utf8mb4_unicode_ci;

-- 选择/使用数据库
-- 后续所有操作都在此数据库中进行
USE school;

-- 查看当前选中的数据库
SELECT DATABASE();

-- 删除数据库（危险操作，生产环境慎用）
-- DROP DATABASE IF EXISTS school;


-- ============================================================
-- 第二部分: MySQL 常用数据类型
-- ============================================================
/*
整数类型:
    TINYINT      1字节   范围: -128~127 或 0~255
    SMALLINT     2字节   范围: -32768~32767
    MEDIUMINT    3字节   范围: -8388608~8388607
    INT          4字节   范围: -21亿~21亿
    BIGINT       8字节   范围: -2^63~2^63-1

    可用 UNSIGNED 表示非负整数（如年龄用 TINYINT UNSIGNED）

浮点数/定点数:
    FLOAT        4字节   单精度浮点数
    DOUBLE       8字节   双精度浮点数
    DECIMAL(M,D) 定点数   M=总位数, D=小数位数（精确计算用，如金额）

字符串类型:
    CHAR(N)      定长字符串    N最大255, 不足补空格（性能好）
    VARCHAR(N)   变长字符串    N最大65535, 按实际长度存储（省空间）
    TEXT         文本        最大65535字节
    MEDIUMTEXT   中等文本    最大16777215字节
    LONGTEXT     长文本      最大4GB

日期时间类型:
    DATE         日期        格式: 'YYYY-MM-DD'
    TIME         时间        格式: 'HH:MM:SS'
    DATETIME     日期时间    格式: 'YYYY-MM-DD HH:MM:SS'（范围大）
    TIMESTAMP    时间戳      范围: 1970~2038（自动时区转换）
    YEAR         年份        格式: 'YYYY'

其他:
    ENUM('val1','val2',...)  枚举类型（单选）
    SET('val1','val2',...)   集合类型（多选）
    JSON                     存储JSON数据（MySQL 5.7+）
    BLOB                     二进制大对象（存储图片、文件等）
*/


-- ============================================================
-- 第三部分: 数据表操作
-- ============================================================

-- 创建学生表（演示各种数据类型）
CREATE TABLE IF NOT EXISTS student (
    -- 主键: 自增整数, 每行记录的唯一标识
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '学生编号',

    -- 字符串: 变长, NOT NULL 表示不能为空
    name VARCHAR(50) NOT NULL COMMENT '姓名',

    -- 枚举: 只能从指定列表中选一个值
    gender ENUM('男', '女', '其他') NOT NULL DEFAULT '其他' COMMENT '性别',

    -- 整数: UNSIGNED 表示非负
    age TINYINT UNSIGNED NOT NULL COMMENT '年龄',

    -- 日期: 仅存储日期部分
    birth_date DATE COMMENT '出生日期',

    -- 字符串: 固定长度11位的手机号
    phone CHAR(11) COMMENT '手机号',

    -- 浮点数: DECIMAL 适合存储金额/分数（精确）
    score DECIMAL(5,2) DEFAULT 0.00 COMMENT '总分',

    -- 大文本: 存储较长的文字
    address TEXT COMMENT '家庭地址',

    -- 时间戳: 插入时自动填充当前时间
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间',

    -- 时间戳: 更新时自动填充当前时间
    updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP COMMENT '更新时间',

    -- 定义主键（另一种写法）
    -- PRIMARY KEY (id),

    -- 唯一索引: 手机号不能重复
    UNIQUE KEY uk_phone (phone)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='学生信息表';

-- ENGINE=InnoDB     : 使用 InnoDB 引擎（支持事务、外键、行级锁）
-- DEFAULT CHARSET   : 默认字符集
-- COMMENT           : 表/字段的注释说明


-- 创建课程表（演示更多数据类型）
CREATE TABLE IF NOT EXISTS course (
    id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '课程编号',
    name VARCHAR(100) NOT NULL COMMENT '课程名称',
    credit DECIMAL(3,1) NOT NULL COMMENT '学分（如 3.0）',
    type ENUM('必修', '选修', '公共') NOT NULL DEFAULT '选修' COMMENT '课程类型',
    is_active TINYINT(1) DEFAULT 1 COMMENT '是否启用: 1=是, 0=否',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP COMMENT '创建时间'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='课程表';


-- 查看当前数据库中的所有表
SHOW TABLES;

-- 查看表结构
DESC student;
-- 或
-- DESCRIBE student;

-- 查看创建表的完整SQL语句
SHOW CREATE TABLE student;

-- 修改表名
-- RENAME TABLE student TO student_backup;

-- 删除表（危险操作）
-- DROP TABLE IF EXISTS course;

-- 清空表数据（保留表结构, AUTO_INCREMENT 会重置）
-- TRUNCATE TABLE student;

-- ============================================================
-- 练习: 创建一个教师表
-- ============================================================
CREATE TABLE IF NOT EXISTS teacher (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY COMMENT '教师编号',
    name VARCHAR(50) NOT NULL COMMENT '姓名',
    title VARCHAR(20) COMMENT '职称（教授/副教授/讲师）',
    email VARCHAR(100) COMMENT '邮箱',
    hire_date DATE COMMENT '入职日期',
    salary DECIMAL(10,2) COMMENT '工资'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='教师表';
