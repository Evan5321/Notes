-- ============================================================
-- MySQL 学习笔记 02: CRUD 操作 + WHERE/UPDATE/DELETE 详解
-- ============================================================
-- CRUD = Create(INSERT) / Read(SELECT) / Update(UPDATE) / Delete(DELETE)
-- ============================================================

-- 先选择数据库
USE school;

-- ============================================================
-- 第一部分: INSERT - 插入/添加数据
-- ============================================================

-- 1.1 插入完整行（值与列一一对应）
INSERT INTO student (name, gender, age, birth_date, phone, score, address)
VALUES ('张三', '男', 20, '2004-03-15', '13800138001', 450.50, '北京市海淀区');

-- 1.2 插入多行（一次插入多条数据，效率更高）
INSERT INTO student (name, gender, age, birth_date, phone, score, address)
VALUES
    ('李四', '男', 22, '2002-07-20', '13800138002', 520.00, '上海市浦东新区'),
    ('王五', '女', 21, '2003-01-10', '13800138003', 488.50, '广州市天河区'),
    ('赵六', '女', 23, '2001-11-05', '13800138004', 532.00, '深圳市南山区'),
    ('孙七', '男', 19, '2005-05-25', '13800138005', 410.00, '杭州市西湖区');

-- 1.3 只插入指定列（未指定的列会用默认值）
INSERT INTO student (name, age, phone)
VALUES ('周八', 20, '13800138006');

-- 1.4 INSERT ... SET 语法（另一种写法）
INSERT INTO student SET name = '吴九', age = 21, phone = '13800138007', score = 470.00;

-- 1.5 INSERT IGNORE（忽略重复键错误）
INSERT IGNORE INTO student (name, phone) VALUES ('郑十', '13800138001');
-- 如果 phone 有 UNIQUE 约束且 '13800138001' 已存在，此行会被忽略而非报错

-- 1.6 REPLACE（存在则替换，不存在则插入）
-- REPLACE INTO student (name, phone) VALUES ('郑十', '13800138001');
-- 注意: REPLACE 实际上是 DELETE + INSERT，会影响自增ID

-- 插入课程数据
INSERT INTO course (name, credit, type) VALUES
    ('高等数学', 5.0, '必修'),
    ('线性代数', 4.0, '必修'),
    ('大学英语', 3.0, '公共'),
    ('数据结构', 4.0, '必修'),
    ('Web前端开发', 2.0, '选修'),
    ('人工智能导论', 2.5, '选修');


-- ============================================================
-- 第二部分: SELECT - 查询数据
-- ============================================================

-- 2.1 查询所有列
SELECT * FROM student;

-- 2.2 查询指定列
SELECT id, name, age, score FROM student;

-- 2.3 给列起别名（AS 可省略）
SELECT
    name   AS '姓名',
    age    AS '年龄',
    score  AS '分数'
FROM student;

-- 2.4 查询并计算（表达式）
SELECT
    name,
    score,
    score * 0.1 AS '加分后成绩',       -- 所有成绩加10%
    score + 50  AS '加50分后的成绩'
FROM student;

-- 2.5 去重查询（DISTINCT）
SELECT DISTINCT gender FROM student;

-- 2.6 限制返回行数
SELECT * FROM student LIMIT 3;           -- 只返回前3行
SELECT * FROM student LIMIT 2, 3;        -- 跳过前2行，返回3行（分页用）
-- LIMIT 2, 3 等价于 LIMIT 3 OFFSET 2;

-- 2.7 排序查询
SELECT name, score FROM student ORDER BY score DESC;  -- 降序
SELECT name, score FROM student ORDER BY score ASC;   -- 升序（默认）
SELECT name, age, score FROM student ORDER BY age DESC, score ASC;  -- 多字段排序


-- ============================================================
-- 第三部分: WHERE 子句详解（条件查询）
-- ============================================================
/*
WHERE 支持的运算符:
    比较:  =, >, <, >=, <=, != 或 <>
    范围:  BETWEEN ... AND ...
    集合:  IN (...)
    模糊:  LIKE  (% 任意多个字符, _ 单个字符)
    空值:  IS NULL, IS NOT NULL
    逻辑:  AND, OR, NOT
*/

-- 3.1 等值查询
SELECT * FROM student WHERE name = '张三';

-- 3.2 比较运算符
SELECT * FROM student WHERE score >= 500;
SELECT * FROM student WHERE age != 20;
SELECT * FROM student WHERE score > 450 AND score < 520;

-- 3.3 BETWEEN（闭区间，包含边界）
SELECT * FROM student WHERE score BETWEEN 450 AND 500;
-- 等价于: score >= 450 AND score <= 500

-- 3.4 IN（匹配列表中的任意值）
SELECT * FROM student WHERE age IN (19, 21, 23);
-- 等价于: age = 19 OR age = 21 OR age = 23

-- 3.5 LIKE 模糊匹配
SELECT * FROM student WHERE name LIKE '张%';     -- 以"张"开头的所有名字
SELECT * FROM student WHERE name LIKE '%五';     -- 以"五"结尾的所有名字
SELECT * FROM student WHERE name LIKE '%小%';    -- 名字中包含"小"的所有记录
SELECT * FROM student WHERE phone LIKE '138%';   -- 138开头的手机号
SELECT * FROM student WHERE name LIKE '张_';     -- "张"后面跟恰好1个字（如"张三"）

-- 3.6 IS NULL / IS NOT NULL（判断空值）
-- 注意: 不能用 = NULL 来判断，因为 NULL ≠ NULL
SELECT * FROM student WHERE address IS NULL;
SELECT * FROM student WHERE address IS NOT NULL;

-- 3.7 AND / OR 组合条件
-- AND 优先级高于 OR，建议加括号明确
SELECT * FROM student
WHERE (age >= 20 AND score >= 450)     -- 年龄≥20 且 分数≥450
   OR (age < 20 AND score >= 400);     -- 或者 年龄<20 且 分数≥400

-- 3.8 NOT 取反
SELECT * FROM student WHERE NOT (score >= 500);
-- 等价于: score < 500


-- ============================================================
-- 第四部分: UPDATE - 修改数据
-- ============================================================
/*
语法:
    UPDATE 表名
    SET 列1 = 新值1, 列2 = 新值2
    [WHERE 条件];

!!! 非常重要: 不加 WHERE 条件会更新所有行 !!!
*/

-- 4.1 更新单列
UPDATE student SET score = 460.00 WHERE name = '张三';

-- 4.2 更新多列
UPDATE student
SET score = 530.00, address = '上海市徐汇区'
WHERE name = '李四';

-- 4.3 带表达式的更新
UPDATE student
SET score = score + 10       -- 所有学生加10分
WHERE score < 500;

-- 4.4 使用 LIMIT 限制更新行数
UPDATE student
SET score = score + 5
WHERE score < 450
LIMIT 2;                     -- 只更新前2条符合条件的记录

-- 4.5 排序后更新
UPDATE student
SET score = 600.00
ORDER BY score DESC           -- 分数最高的
LIMIT 1;                      -- 只更新1条


-- ============================================================
-- 第五部分: DELETE - 删除数据
-- ============================================================
/*
语法:
    DELETE FROM 表名 [WHERE 条件];

!!! 非常重要: 不加 WHERE 条件会删除所有行 !!!
*/

-- 5.1 按条件删除
DELETE FROM student WHERE name = '郑十';

-- 5.2 删除所有行（保留表结构）
-- DELETE FROM student;
-- 注意: 自增ID不会重置

-- 5.3 TRUNCATE（快速清空表，重置自增ID）
-- TRUNCATE TABLE student;
-- 比 DELETE 更快，但不能带 WHERE 条件，且无法回滚（事务中除外）

-- 5.4 带 ORDER BY 和 LIMIT 的删除
DELETE FROM student
WHERE score < 430
ORDER BY score ASC            -- 分数最低的
LIMIT 1;                      -- 只删1条

-- 5.5 删除前先查询确认（安全做法）
-- 先查
SELECT * FROM student WHERE name = '周八';
-- 确认无误后再删
-- DELETE FROM student WHERE name = '周八';


-- ============================================================
-- 总结: WHERE 在 SELECT/UPDATE/DELETE 中的用法完全一致
-- ============================================================
/*
    SELECT 列 FROM 表    [WHERE 条件] [ORDER BY ...] [LIMIT ...]
    UPDATE 表 SET 列=值   [WHERE 条件] [ORDER BY ...] [LIMIT ...]
    DELETE FROM 表        [WHERE 条件] [ORDER BY ...] [LIMIT ...]
*/
