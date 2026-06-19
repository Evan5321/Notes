-- ============================================================
-- MySQL 学习笔记 08: 索引、临时表、复制表、元数据
-- ============================================================

USE school;

-- ============================================================
-- 第一部分: 索引 (INDEX)
-- ============================================================
/*
索引的作用: 加快查询速度，但会降低写入性能并占用磁盘空间。

索引类型:
    PRIMARY KEY     主键索引（唯一且非空）
    UNIQUE          唯一索引（值不能重复，允许NULL）
    INDEX / KEY     普通索引（加速查询）
    FULLTEXT        全文索引（大文本搜索，MyISAM/InnoDB支持）
    SPATIAL         空间索引（地理数据）

索引策略:
    单列索引         在单个列上创建
    复合索引         多列组合（最左前缀原则）
    前缀索引         只索引字符串的前 N 个字符
*/

-- 1.1 创建索引的多种方式

-- 方式1: 建表时创建
CREATE TABLE IF NOT EXISTS example_index (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,           -- 主键索引
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100),
    UNIQUE KEY uk_email (email),                          -- 唯一索引
    INDEX idx_name (name),                                -- 普通索引
    INDEX idx_name_email (name, email)                    -- 复合索引
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 方式2: 使用 CREATE INDEX
-- 语法: CREATE [UNIQUE|FULLTEXT] INDEX 索引名 ON 表名 (列名)
CREATE INDEX idx_score ON student (score);
CREATE UNIQUE INDEX idx_phone ON student (phone);
CREATE INDEX idx_age_score ON student (age, score);       -- 复合索引

-- 方式3: 使用 ALTER TABLE（见 07_alter.sql）
-- ALTER TABLE student ADD INDEX idx_name (name);

-- 1.2 前缀索引（对大文本字段只索引前N个字符）
CREATE INDEX idx_address_prefix ON student (address(20));

-- 1.3 删除索引
DROP INDEX idx_score ON student;
-- 或 ALTER TABLE student DROP INDEX idx_score;

-- 1.4 查看索引
SHOW INDEX FROM student;

/*
EXPLAIN 查看查询是否使用索引（非常重要）:
    EXPLAIN SELECT * FROM student WHERE name = '张三';
    如果 type=ref, key=idx_name 说明走了索引
    如果 type=ALL 说明全表扫描（需要优化）
*/

-- 1.5 复合索引的最左前缀原则
-- 有复合索引 (age, score)，以下查询能用到索引:
-- WHERE age = 20                  -- 用到了 age 部分
-- WHERE age = 20 AND score > 500  -- 用到了全部
-- WHERE score > 500               -- 用不到索引！因为没从最左列开始

-- 1.6 索引使用建议
/*
    ✅ 适合加索引的场景:
        - WHERE 条件中频繁使用的列
        - JOIN 的连接列（外键）
        - ORDER BY 排序的列
        - 有唯一性要求的列

    ❌ 不适合加索引的场景:
        - 数据量很小的表（全表扫描更快）
        - 频繁更新的列（索引维护成本高）
        - 值几乎不重复的列（如性别只有男/女，加了也没用）
        - 大文本/二进制字段（可用前缀索引替代）
*/


-- ============================================================
-- 第二部分: 临时表 (TEMPORARY TABLE)
-- ============================================================
/*
临时表特点:
    1. 只在当前会话中可见
    2. 会话结束自动销毁
    3. 不同会话的同名临时表互不干扰
    4. 可用于存储中间结果
*/

-- 2.1 创建临时表
CREATE TEMPORARY TABLE temp_high_score (
    id INT UNSIGNED,
    name VARCHAR(50),
    score DECIMAL(6,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- 向临时表插入数据
INSERT INTO temp_high_score
SELECT id, name, score FROM student WHERE score >= 500;

-- 查询临时表（只在当前会话有效）
SELECT * FROM temp_high_score;

-- 2.2 用查询结果直接创建临时表（更方便）
CREATE TEMPORARY TABLE temp_male_student
SELECT id, name, age, score
FROM student
WHERE gender = '男';

SELECT * FROM temp_male_student;

-- 2.3 临时表与普通表重名
-- 如果有同名的普通表，临时表会隐藏普通表（会话内）
-- DROP TEMPORARY TABLE 只删临时表，不影响普通表

-- 手动删除临时表（非必需，会话结束自动删除）
DROP TEMPORARY TABLE temp_high_score;
DROP TEMPORARY TABLE temp_male_student;

-- 2.4 临时表的实际应用场景
/*
-- 复杂报表计算（分步查询）
CREATE TEMPORARY TABLE step1 AS SELECT ...;
CREATE TEMPORARY TABLE step2 AS SELECT ... FROM step1 JOIN ...;
SELECT * FROM step2;

-- 去重/导出中间结果
CREATE TEMPORARY TABLE deduped
SELECT * FROM source_table GROUP BY unique_col;
*/


-- ============================================================
-- 第三部分: 复制表 (复制表结构和/或数据)
-- ============================================================

-- 3.1 只复制表结构（不含数据）
CREATE TABLE student_empty LIKE student;

-- 3.2 复制表结构+数据
CREATE TABLE student_backup AS
SELECT * FROM student;
-- 注意: 这种方式不会复制索引、外键、自增属性等

-- 3.3 只复制部分数据
CREATE TABLE student_female AS
SELECT id, name, age, score
FROM student
WHERE gender = '女';

-- 3.4 完整复制表（结构 + 索引 + 数据）
-- 步骤1: 复制结构（含索引）
CREATE TABLE student_fullcopy LIKE student;
-- 步骤2: 复制数据
INSERT INTO student_fullcopy SELECT * FROM student;

-- 3.5 跨数据库复制
-- CREATE TABLE target_db.new_table LIKE source_db.old_table;
-- INSERT INTO target_db.new_table SELECT * FROM source_db.old_table;

-- 3.6 复制部分列和行
CREATE TABLE student_top3 AS
SELECT id, name, score
FROM student
ORDER BY score DESC
LIMIT 3;


-- ============================================================
-- 第四部分: 元数据 (Metadata)
-- ============================================================
/*
元数据: 关于数据的数据，如表结构、数据库信息等。

常用元数据命令:
    SHOW DATABASES            列出所有数据库
    SHOW TABLES               列出所有表
    SHOW COLUMNS FROM 表      列出表的列信息（同 DESC 表）
    SHOW INDEX FROM 表        列出表的索引
    SHOW TABLE STATUS         列出表的详细信息
    SHOW CREATE TABLE 表      显示建表SQL
    SELECT ... FROM information_schema...
*/

-- 4.1 SHOW 类元数据查询
-- 查看当前数据库所有表
SHOW TABLES;

-- 查看表的详细信息（引擎、行数、字符集等）
SHOW TABLE STATUS LIKE 'student'\G
-- \G 表示纵向显示（在命令行中有效）

-- 查看所有表的详细信息
-- SHOW TABLE STATUS;

-- 4.2 使用 information_schema 查询元数据
-- information_schema 是系统数据库，包含所有数据库的元信息

-- 查询当前数据库中有哪些表
SELECT TABLE_NAME, ENGINE, TABLE_ROWS, CREATE_TIME
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'school';

-- 查询 student 表的所有列信息
SELECT COLUMN_NAME, DATA_TYPE, IS_NULLABLE, COLUMN_DEFAULT, COLUMN_COMMENT
FROM information_schema.COLUMNS
WHERE TABLE_SCHEMA = 'school' AND TABLE_NAME = 'student';

-- 4.3 查询表的大小（近似值）
SELECT
    TABLE_NAME,
    ROUND(DATA_LENGTH / 1024 / 1024, 2) AS '数据大小(MB)',
    ROUND(INDEX_LENGTH / 1024 / 1024, 2) AS '索引大小(MB)',
    ROUND((DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS '总大小(MB)'
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'school';

-- 4.4 查询数据库中的所有外键
SELECT
    TABLE_NAME,
    COLUMN_NAME,
    CONSTRAINT_NAME,
    REFERENCED_TABLE_NAME,
    REFERENCED_COLUMN_NAME
FROM information_schema.KEY_COLUMN_USAGE
WHERE TABLE_SCHEMA = 'school' AND REFERENCED_TABLE_NAME IS NOT NULL;

-- 4.5 查询表的字符集和排序规则
SELECT
    TABLE_NAME,
    TABLE_COLLATION
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'school';

-- 4.6 查询所有数据库的大小
SELECT
    TABLE_SCHEMA AS '数据库名',
    COUNT(*) AS '表数量',
    ROUND(SUM(DATA_LENGTH + INDEX_LENGTH) / 1024 / 1024, 2) AS '总大小(MB)'
FROM information_schema.TABLES
GROUP BY TABLE_SCHEMA
ORDER BY 总大小 DESC;
