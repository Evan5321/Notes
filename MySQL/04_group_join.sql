-- ============================================================
-- MySQL 学习笔记 04: 分组(GROUP BY) 和 连接(JOIN)
-- ============================================================

USE school;

-- 先清理并插入测试数据
DELETE FROM student;
INSERT INTO student (name, gender, age, score) VALUES
    ('张三', '男', 20, 450),
    ('李四', '男', 22, 520),
    ('王五', '女', 21, 488),
    ('赵六', '女', 23, 532),
    ('孙七', '男', 19, 410),
    ('周八', '女', 20, 550),
    ('吴九', '男', 21, 470),
    ('郑十', '女', 22, 510);
-- 注意: 自增ID不会重置为1，如果需要:
-- TRUNCATE student;  -- 会重置自增ID

-- ============================================================
-- 第一部分: GROUP BY - 分组聚合
-- ============================================================
/*
GROUP BY 配合聚合函数使用:
    COUNT()   计数
    SUM()     求和
    AVG()     平均值
    MAX()     最大值
    MIN()     最小值

执行顺序: WHERE → GROUP BY → HAVING → ORDER BY → LIMIT
*/

-- 1.1 基本的 GROUP BY
-- 按性别分组，统计每组人数
SELECT gender, COUNT(*) AS '人数'
FROM student
GROUP BY gender;

-- 1.2 多个聚合函数一起用
SELECT
    gender,
    COUNT(*)    AS '人数',
    AVG(score)  AS '平均分',
    MAX(score)  AS '最高分',
    MIN(score)  AS '最低分',
    SUM(score)  AS '总分'
FROM student
GROUP BY gender;

-- 1.3 按年龄分组统计
SELECT
    age,
    COUNT(*)   AS '人数',
    AVG(score) AS '平均分'
FROM student
GROUP BY age
ORDER BY age;

-- 1.4 多列分组
-- 先按性别分组，再按年龄分组
SELECT
    gender,
    age,
    COUNT(*) AS '人数'
FROM student
GROUP BY gender, age
ORDER BY gender, age;

-- 1.5 HAVING 过滤分组结果
-- WHERE 过滤行，HAVING 过滤分组
-- 查询平均分≥500的性别组
SELECT
    gender,
    AVG(score) AS avg_score
FROM student
GROUP BY gender
HAVING avg_score >= 500;

-- WHERE → GROUP BY → HAVING 完整示例
-- 筛选年龄≥20的，按性别分组，取平均分≥500的组
SELECT
    gender,
    COUNT(*)   AS 人数,
    AVG(score) AS 平均分
FROM student
WHERE age >= 20              -- 先过滤行
GROUP BY gender
HAVING 平均分 >= 500         -- 再过滤分组
ORDER BY 平均分 DESC;

-- 1.6 GROUP_CONCAT - 将组内值拼接成字符串
-- 查询每个性别有哪些学生（名字拼接在一起）
SELECT
    gender,
    GROUP_CONCAT(name)          AS '成员（默认逗号分隔）',
    GROUP_CONCAT(name SEPARATOR ' | ') AS '成员（自定义分隔符）'
FROM student
GROUP BY gender;

-- 1.7 ROLLUP - 分组汇总（小计+总计）
SELECT
    gender,
    SUM(score) AS total_score
FROM student
GROUP BY gender WITH ROLLUP;
-- 最后一行是总计: gender=NULL, total_score=所有学生总分

-- 1.8 统计每个分数段的人数
SELECT
    CASE
        WHEN score >= 500 THEN '优秀(≥500)'
        WHEN score >= 450 THEN '良好(450-499)'
        ELSE '一般(<450)'
    END AS score_level,
    COUNT(*) AS 人数
FROM student
GROUP BY score_level
ORDER BY 人数 DESC;


-- ============================================================
-- 第二部分: JOIN - 连接查询
-- ============================================================
/*
连接类型:
    INNER JOIN   = 只返回匹配的行（交集）
    LEFT JOIN    = 返回左表所有行，右表无匹配则填 NULL
    RIGHT JOIN   = 返回右表所有行，左表无匹配则填 NULL
    FULL JOIN    = MySQL 不支持（可用 UNION 模拟）
    CROSS JOIN   = 笛卡尔积（每行×每行）
*/

-- 准备连接用的表
CREATE TABLE IF NOT EXISTS class (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL COMMENT '班级名称'
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO class (name) VALUES ('计算机一班'), ('计算机二班'), ('数学一班');

-- 给 student 表加班级ID字段
ALTER TABLE student ADD COLUMN class_id INT UNSIGNED DEFAULT NULL COMMENT '班级ID' AFTER address;

-- 分配班级
UPDATE student SET class_id = 1 WHERE id IN (1,2,3);
UPDATE student SET class_id = 2 WHERE id IN (4,5,6);
UPDATE student SET class_id = 3 WHERE id IN (7,8);


-- 2.1 INNER JOIN（内连接）
-- 只返回学生和班级都匹配的数据
-- 语法1: JOIN ... ON
SELECT
    s.name  AS '学生',
    s.age   AS '年龄',
    c.name  AS '班级'
FROM student    AS s
JOIN class      AS c ON s.class_id = c.id;

-- 语法2: INNER JOIN（效果一样）
SELECT s.name, c.name FROM student s INNER JOIN class c ON s.class_id = c.id;

-- 语法3: 隐式内连接（不推荐，可读性差）
-- SELECT s.name, c.name FROM student s, class c WHERE s.class_id = c.id;


-- 2.2 LEFT JOIN（左连接）
-- 左表(student)的所有行都保留，右表(class)无匹配则显示 NULL
SELECT
    s.name  AS '学生',
    c.name  AS '班级'
FROM student AS s
LEFT JOIN class AS c ON s.class_id = c.id;


-- 2.3 RIGHT JOIN（右连接）
-- 右表(class)的所有行都保留，左表(student)无匹配则显示 NULL
SELECT
    s.name  AS '学生',
    c.name  AS '班级'
FROM student AS s
RIGHT JOIN class AS c ON s.class_id = c.id;


-- 2.4 多表连接（3张表以上）
-- 创建选修课成绩表
CREATE TABLE IF NOT EXISTS enrollment (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    student_id INT UNSIGNED NOT NULL,
    course_id SMALLINT UNSIGNED NOT NULL,
    grade DECIMAL(5,2) COMMENT '成绩',
    FOREIGN KEY (student_id) REFERENCES student(id),
    FOREIGN KEY (course_id) REFERENCES course(id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

INSERT INTO enrollment (student_id, course_id, grade) VALUES
    (1, 1, 85), (1, 2, 90),
    (2, 1, 78), (2, 3, 88),
    (3, 4, 92), (4, 1, 70);

-- 学生 + 课程 + 成绩 三表连接
SELECT
    s.name      AS '学生',
    c.name      AS '课程',
    e.grade     AS '成绩'
FROM enrollment    AS e
JOIN student       AS s ON e.student_id = s.id
JOIN course        AS c ON e.course_id  = c.id
ORDER BY s.name, c.name;

-- LEFT JOIN 确保显示所有课程（即使没人选）
SELECT
    c.name  AS '课程',
    s.name  AS '选课学生'
FROM course c
LEFT JOIN enrollment e ON c.id = e.course_id
LEFT JOIN student    s ON e.student_id = s.id;


-- 2.5 SELF JOIN（自连接）
-- 同一张表自己连接自己（必须用别名）
-- 示例: 查询学生以及比TA年龄大的学生
SELECT
    a.name      AS '学生',
    a.age       AS 'TA的年龄',
    b.name      AS '比TA年长的学生',
    b.age       AS '年龄'
FROM student a
JOIN student b ON a.age < b.age;

-- 示例: 查询同名的学生（如果有重名的话）
-- SELECT a.name, a.id, b.id FROM student a JOIN student b
-- ON a.name = b.name AND a.id < b.id;


-- 2.6 CROSS JOIN（交叉连接/笛卡尔积）
-- 每行 × 每行，通常不这么用
SELECT s.name, c.name
FROM student s
CROSS JOIN class c;
-- 如果 student 有10行, class 有3行 → 结果30行


-- 2.7 用 UNION 模拟 FULL OUTER JOIN
-- MySQL 没有 FULL JOIN，用 LEFT JOIN + RIGHT JOIN + UNION 实现
SELECT s.name, c.name FROM student s LEFT JOIN class c ON s.class_id = c.id
UNION
SELECT s.name, c.name FROM student s RIGHT JOIN class c ON s.class_id = c.id;


-- ============================================================
-- 第三部分: 分组 + 连接 综合示例
-- ============================================================

-- 查询每个课程的平均分、选课人数
SELECT
    c.name          AS '课程',
    COUNT(e.id)     AS '选课人数',
    AVG(e.grade)    AS '平均分',
    MAX(e.grade)    AS '最高分',
    MIN(e.grade)    AS '最低分'
FROM course c
LEFT JOIN enrollment e ON c.id = e.course_id
GROUP BY c.id, c.name
ORDER BY 平均分 DESC;

-- 查询每个班级的平均分
SELECT
    cl.name                 AS '班级',
    COUNT(s.id)             AS '学生人数',
    ROUND(AVG(s.score), 2)  AS '班级平均分'
FROM class cl
LEFT JOIN student s ON cl.id = s.class_id
GROUP BY cl.id, cl.name;
