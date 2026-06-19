-- ============================================================
-- MySQL 学习笔记 03: UNION 和 ORDER BY 语句
-- ============================================================

USE school;

-- ============================================================
-- 第一部分: ORDER BY - 排序
-- ============================================================

-- 准备工作：插入一些测试数据
INSERT INTO student (name, gender, age, score) VALUES
    ('Alice', '女', 20, 510.00),
    ('Bob', '男', 22, 490.00),
    ('Charlie', '男', 21, 530.00),
    ('Diana', '女', 20, 470.00);

-- 1.1 单列排序
-- ASC  = 升序（从小到大，默认）
-- DESC = 降序（从大到小）
SELECT name, age, score FROM student ORDER BY score DESC;

-- 1.2 多列排序
-- 先按 age 升序排，age 相同的再按 score 降序排
SELECT name, age, score FROM student
ORDER BY age ASC, score DESC;

-- 1.3 按表达式/别名排序
SELECT name, (score + 100) AS new_score FROM student
ORDER BY new_score DESC;
-- 或直接用表达式: ORDER BY (score + 100) DESC

-- 1.4 按字段位置排序（不推荐，难以维护）
-- 1 = 第1列(name), 2 = 第2列(age)
SELECT name, age, score FROM student ORDER BY 2 ASC, 3 DESC;

-- 1.5 结合 WHERE 和 LIMIT
-- 查询年龄≥20的学生，按分数降序排，取前3名
SELECT name, age, score FROM student
WHERE age >= 20
ORDER BY score DESC
LIMIT 3;

-- 1.6 空值排序
-- 默认 NULL 在升序中排在最后，降序中排在最前
SELECT name, address FROM student ORDER BY address ASC;
-- NULLS FIRST / NULLS LAST 可控制空值位置（MySQL 8.0+）
-- SELECT name, address FROM student ORDER BY address ASC NULLS LAST;

-- 1.7 随机排序（RAND函数，大表慎用，性能较差）
SELECT name FROM student ORDER BY RAND() LIMIT 3;


-- ============================================================
-- 第二部分: UNION - 合并查询结果
-- ============================================================
/*
UNION 用于合并两个或多个 SELECT 语句的结果集。
规则:
    1. 每个 SELECT 的列数必须相同
    2. 对应列的数据类型必须兼容
    3. UNION（默认）会自动去重
    4. UNION ALL 会保留所有行（性能更好）

    如果两个子查询中有相同的列，UNION会自动去重
*/

-- 2.1 UNION 基础用法
-- 查询所有男生和分数≥500的学生（合并两个结果集，自动去重）
SELECT id, name, age, score, '男生' AS tag FROM student WHERE gender = '男'
UNION
SELECT id, name, age, score, '高分' AS tag FROM student WHERE score >= 500;

-- 2.2 UNION ALL（不去重，更快）
-- 对比 UNION 和 UNION ALL:
SELECT 'UNION 结果:' AS info;
SELECT name FROM student WHERE age < 21
UNION
SELECT name FROM student WHERE score > 500;

SELECT 'UNION ALL 结果:' AS info;
SELECT name FROM student WHERE age < 21
UNION ALL
SELECT name FROM student WHERE score > 500;

-- 2.3 多个 UNION 子句
SELECT name, '学生' AS role FROM student
UNION
SELECT name, '老师'    FROM teacher
UNION
SELECT '管理员', '员工';

-- 2.4 UNION 与 ORDER BY 结合
-- ORDER BY 必须放在最后一个 SELECT 后面（对整个结果集排序）
-- 而且必须用第一个 SELECT 的列名
SELECT id, name, score FROM student WHERE score >= 500
UNION
SELECT id, name, score FROM student WHERE age < 21
ORDER BY score DESC;

-- 2.5 给 UNION 结果集中的行加来源标记
SELECT
    name,
    score,
    '高分学生' AS category
FROM student
WHERE score >= 500

UNION ALL

SELECT
    name,
    score,
    '低分学生'
FROM student
WHERE score <= 450

ORDER BY score DESC;

-- 2.6 UNION 与 LIMIT 结合
-- 从每个查询中分别取前2条，再合并去重
(SELECT id, name, score FROM student ORDER BY score DESC LIMIT 2)
UNION
(SELECT id, name, score FROM student ORDER BY age ASC LIMIT 2);


-- ============================================================
-- 第三部分: 实际应用场景
-- ============================================================

-- 3.1 合并不同类型的数据（如：学生和教师列表）
SELECT
    id,
    name,
    '学生' AS type,
    score AS info
FROM student
UNION ALL
SELECT
    id,
    name,
    '教师',
    salary
FROM teacher
ORDER BY type, name;

-- 3.2 补零查询（如果某个表没有数据，UNION 可以补充默认值）
SELECT id, name, '有数据' AS status FROM student WHERE id = 1
UNION ALL
SELECT 0, '无数据', '默认' WHERE NOT EXISTS (SELECT 1 FROM student WHERE id = 999);

-- 3.3 分页场景中用 UNION 加速
-- 当需要从不同范围查询并合并时，UNION 比 OR 可能更快（能分别走索引）
(SELECT * FROM student WHERE age = 20 ORDER BY id LIMIT 10)
UNION ALL
(SELECT * FROM student WHERE age = 21 ORDER BY id LIMIT 10);
