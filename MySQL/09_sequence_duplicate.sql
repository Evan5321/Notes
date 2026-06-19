-- ============================================================
-- MySQL 学习笔记 09: 序列(AUTO_INCREMENT) 和 重复数据处理
-- ============================================================

USE school;

-- ============================================================
-- 第一部分: 序列 (AUTO_INCREMENT)
-- ============================================================
/*
MySQL 的序列主要通过 AUTO_INCREMENT 属性实现。
特点:
    1. 只能用于整数列
    2. 每个表只能有一个 AUTO_INCREMENT 列
    3. 必须定义在键（主键/唯一键）上
*/

-- 1.1 AUTO_INCREMENT 基础
CREATE TABLE IF NOT EXISTS seq_demo (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO seq_demo (name) VALUES ('A'), ('B'), ('C');
SELECT * FROM seq_demo;
-- id 会自动生成: 1, 2, 3

-- 1.2 手动指定 ID（之后的自增值会从最大值+1继续）
INSERT INTO seq_demo (id, name) VALUES (10, 'D');
INSERT INTO seq_demo (name) VALUES ('E');
-- E 的 id = 11（不是 4，因为指定了10后自增值跳到11）

-- 查看当前自增值
SHOW TABLE STATUS LIKE 'seq_demo';
-- 或
SELECT AUTO_INCREMENT
FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'school' AND TABLE_NAME = 'seq_demo';

-- 1.3 重置自增值
-- 方法1: ALTER TABLE（当前自增值设为1001，慎用）
ALTER TABLE seq_demo AUTO_INCREMENT = 1001;

-- 方法2: TRUNCATE（清空表并重置）
-- TRUNCATE TABLE seq_demo;    -- 自增值会回到 1（前提是 InnoDB）

-- 1.4 获取最后插入的 ID
INSERT INTO seq_demo (name) VALUES ('F');
SELECT LAST_INSERT_ID();
-- 连接级别的函数，返回当前会话最后一次 INSERT 生成的自增值

-- 1.5 自增值不连续的原因
/*
    1. 事务回滚: 自增值不会回退（已分配的值就被跳过了）
    2. INSERT 失败: 自增值一旦分配就不会回收
    3. 手动指定更大的 ID
    4. DELETE 删除行: 删除不会导致自增值回退
    5. REPLACE / INSERT ... ON DUPLICATE KEY UPDATE
       也会消耗自增值
*/


-- ============================================================
-- 第二部分: 自定义序列（模拟 Oracle 的 SEQUENCE）
-- ============================================================

-- MySQL 没有内置 SEQUENCE 对象，可以通过表模拟
CREATE TABLE IF NOT EXISTS sequence (
    name VARCHAR(50) PRIMARY KEY COMMENT '序列名称',
    current_value INT UNSIGNED NOT NULL COMMENT '当前值',
    increment INT UNSIGNED NOT NULL DEFAULT 1 COMMENT '步长'
) ENGINE=InnoDB;

-- 创建序列（初始化）
INSERT INTO sequence (name, current_value, increment) VALUES ('order_seq', 0, 1);

-- 获取下一个值的函数
/*
DELIMITER $$
CREATE FUNCTION nextval(seq_name VARCHAR(50))
RETURNS INT UNSIGNED
DETERMINISTIC
BEGIN
    UPDATE sequence SET current_value = current_value + increment WHERE name = seq_name;
    RETURN (SELECT current_value FROM sequence WHERE name = seq_name);
END$$
DELIMITER ;

-- 使用
-- SELECT nextval('order_seq');  -- 返回 1
-- SELECT nextval('order_seq');  -- 返回 2
*/


-- ============================================================
-- 第三部分: 处理重复数据
-- ============================================================

-- 准备有重复数据的表
CREATE TABLE IF NOT EXISTS user_with_dup (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    email VARCHAR(100)
) ENGINE=InnoDB;

INSERT INTO user_with_dup (name, email) VALUES
    ('张三', 'zhangsan@test.com'),
    ('李四', 'lisi@test.com'),
    ('张三', 'zhangsan@test.com'),        -- 重复数据
    ('王五', 'wangwu@test.com'),
    ('李四', 'lisi@test.com'),             -- 重复数据
    ('张三', 'zhangsan@test.com');         -- 重复数据

SELECT * FROM user_with_dup;

-- ============================================================
-- 3.1 防止重复的方法
-- ============================================================

-- 方法1: 设置 UNIQUE 约束（从源头防止）
ALTER TABLE user_with_dup
ADD CONSTRAINT uk_email UNIQUE (email);
-- 如果再 INSERT 相同的 email 会报错

-- 方法2: INSERT IGNORE（忽略重复，不报错）
INSERT IGNORE INTO user_with_dup (name, email) VALUES ('赵六', 'lisi@test.com');
-- email 重复，该行被忽略

-- 方法3: REPLACE（存在则替换，不存在则插入）
-- REPLACE INTO user_with_dup (name, email) VALUES ('赵六', 'lisi@test.com');
-- 注意: REPLACE 会先 DELETE 原有行再 INSERT

-- 方法4: INSERT ... ON DUPLICATE KEY UPDATE
-- 如果重复则更新，不重复则插入
INSERT INTO user_with_dup (name, email) VALUES ('赵六', 'lisi@test.com')
ON DUPLICATE KEY UPDATE name = VALUES(name);
-- 如果有重复则更新 name 为 '赵六'


-- ============================================================
-- 3.2 查找重复数据
-- ============================================================

-- 查找 email 重复的记录（分组计数法）
SELECT email, COUNT(*) AS cnt
FROM user_with_dup
GROUP BY email
HAVING cnt > 1;

-- 查找所有重复记录的详细信息
SELECT *
FROM user_with_dup
WHERE email IN (
    SELECT email
    FROM user_with_dup
    GROUP BY email
    HAVING COUNT(*) > 1
)
ORDER BY email, id;

-- 查找 name 和 email 都重复的记录
SELECT name, email, COUNT(*) AS cnt
FROM user_with_dup
GROUP BY name, email
HAVING cnt > 1;

-- 查找 id 重复（理论上不会有，但迁移数据时可能遇到）
-- SELECT id FROM user_with_dup GROUP BY id HAVING COUNT(*) > 1;


-- ============================================================
-- 3.3 删除重复数据（保留一条）
-- ============================================================

-- 方法1: 使用中间表（最安全）
-- 步骤1: 创建临时表存放去重后的数据
CREATE TABLE user_deduped LIKE user_with_dup;

-- 步骤2: 插入去重数据（每个 email 保留 id 最小的那条）
INSERT INTO user_deduped
SELECT MIN(id), name, email
FROM user_with_dup
GROUP BY email;

-- 步骤3: 检查数据是否正确
SELECT * FROM user_deduped;

-- 步骤4: 替换原表
-- DROP TABLE user_with_dup;
-- RENAME TABLE user_deduped TO user_with_dup;


-- 方法2: 使用 DELETE + JOIN（一步到位，谨慎使用）
-- 删除重复记录，只保留每个 email 组中 id 最小的那条
DELETE u1 FROM user_with_dup u1
JOIN user_with_dup u2
ON u1.email = u2.email AND u1.id > u2.id;
-- 解释: 对于每个 email，保留 id 最小的，删除 id 更大的

-- 验证重复是否已清除
SELECT * FROM user_with_dup;

-- 最后加上 UNIQUE 约束防止再出现重复
ALTER TABLE user_with_dup ADD CONSTRAINT uk_email UNIQUE (email);


-- 方法3: 使用分区删除（MySQL 8.0+）
/*
DELETE FROM user_with_dup
WHERE id NOT IN (
    SELECT MIN(id)
    FROM user_with_dup
    GROUP BY email
);
*/


-- ============================================================
-- 3.4 统计重复数据
-- ============================================================

-- 统计总记录数和去重后的记录数
SELECT
    COUNT(*)             AS '总记录数',
    COUNT(DISTINCT email) AS '去重后的记录数',
    COUNT(*) - COUNT(DISTINCT email) AS '重复的记录数'
FROM user_with_dup;

-- 查看某个邮箱的重复次数
SELECT
    email,
    COUNT(*) AS '出现次数',
    GROUP_CONCAT(id ORDER BY id) AS '对应的ID列表'
FROM user_with_dup
WHERE email = 'zhangsan@test.com';


-- ============================================================
-- 3.5 导入数据时处理重复
-- ============================================================

-- 导入 CSV 或数据时常用的重复处理策略
/*
-- 策略1: 忽略重复
LOAD DATA INFILE 'data.csv'
IGNORE                       -- 重复行直接忽略
INTO TABLE user_with_dup
FIELDS TERMINATED BY ','
(name, email);

-- 策略2: 遇到重复则更新
INSERT INTO user_with_dup (name, email)
VALUES ('新用户', 'test@test.com')
ON DUPLICATE KEY UPDATE
    name = VALUES(name),      -- VALUES() 获取本次插入的值
    id = LAST_INSERT_ID(id);  -- 更新 LAST_INSERT_ID

-- 策略3: 先清空后导入（全量更新）
-- TRUNCATE TABLE user_with_dup;
-- INSERT INTO user_with_dup SELECT ... FROM 源表;
*/
