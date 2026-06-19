-- ============================================================
-- MySQL 学习笔记 05: 正则表达式
-- ============================================================
/*
MySQL 使用 REGEXP 或 RLIKE 进行正则匹配。
注意: 与 LIKE 不同，REGEXP 只要部分匹配就返回 TRUE。

常用正则符号:
    ^           字符串开头
    $           字符串结尾
    .           匹配任意单个字符
    *           前面的元素出现 0 次或多次
    +           前面的元素出现 1 次或多次
    ?           前面的元素出现 0 次或 1 次
    [abc]       匹配方括号中任意字符
    [^abc]      匹配不在方括号中的任意字符
    [a-z]       匹配 a 到 z 范围内的任意字符
    |           逻辑 OR
    \\\\         转义（在MySQL中需要用双反斜杠）
    {n}         前面的元素正好出现 n 次
    {n,}        前面的元素至少出现 n 次
    {n,m}       前面的元素出现 n 到 m 次
    [:class:]   字符类, 如 [:digit:] 表示数字

MySQL 8.0+ 还支持正则替换:
    REGEXP_REPLACE()  替换
    REGEXP_INSTR()    返回匹配位置
    REGEXP_LIKE()     判断是否匹配
    REGEXP_SUBSTR()   提取子串
*/

USE school;

-- ============================================================
-- 第一部分: REGEXP 基础用法
-- ============================================================

-- 准备测试数据
DELETE FROM student;
INSERT INTO student (name, gender, age, phone, address, score) VALUES
    ('张三', '男', 20, '13812345678', '北京市海淀区中关村大街1号', 450),
    ('李四', '男', 22, '13998765432', '上海市浦东新区张江路88号', 520),
    ('王五', '女', 21, '15022334455', '广州市天河区体育西路100号', 488),
    ('赵六', '女', 23, '18655667788', '深圳市南山区科技园A座', 532),
    ('孙七', '男', 19, '17799887766', '杭州市西湖区文三路200号', 410),
    ('周八', '女', 20, '18812340987', '北京市朝阳区建国路', 550),
    ('吴九', '男', 21, '13600001111', '成都市高新区天府大道', 470),
    ('郑十', '女', 22, '15266667777', '武汉市东湖高新区光谷大道', 510);

-- ============================================================
-- 1.1 基本模式匹配
-- ============================================================

-- 名字以"张"开头
SELECT * FROM student WHERE name REGEXP '^张';

-- 地址以"区"结尾
SELECT * FROM student WHERE address REGEXP '区$';

-- 名字包含 数字（本例无数字）
SELECT * FROM student WHERE name REGEXP '[0-9]';

-- 名字包含"三"或"四"
SELECT * FROM student WHERE name REGEXP '三|四';

-- 名字以"张"或"李"开头
SELECT * FROM student WHERE name REGEXP '^[张李]';


-- ============================================================
-- 1.2 电话号码匹配
-- ============================================================

-- 13x 或 15x 开头的手机号
SELECT name, phone FROM student WHERE phone REGEXP '^1[35]';

-- 以 88 结尾的手机号
SELECT name, phone FROM student WHERE phone REGEXP '88$';

-- 包含连续两个相同数字的手机号（如 11, 22, 33...）
SELECT name, phone FROM student WHERE phone REGEXP '(\\d)\\1';
-- (\\d) 表示一个数字，\\1 表示重复前面的那个数字
-- 注意: MySQL 中反斜杠需要写成 \\\\

-- 手机号尾号是连号（如 678, 789）
SELECT name, phone FROM student WHERE phone REGEXP '678|789';


-- ============================================================
-- 1.3 地址匹配
-- ============================================================

-- 包含"北京"的地址
SELECT name, address FROM student WHERE address REGEXP '北京';

-- 包含"区"且以"号"结尾的地址
SELECT name, address FROM student WHERE address REGEXP '区.*号$';
-- .* 表示任意字符出现任意次（0次或多次）

-- 地址在"路"或"街"或"大道"上
SELECT name, address FROM student WHERE address REGEXP '(路|街|大道)';

-- 地址包含字母（如 A座, B座）
SELECT name, address FROM student WHERE address REGEXP '[A-Z]座';


-- ============================================================
-- 1.4 更多匹配模式
-- ============================================================

-- 名字长度为2个字（汉字在MySQL中每个占3个字节，但 . 可以匹配）
-- 注意: MySQL 的 . 在 utf8mb4 下可以匹配汉字
SELECT * FROM student WHERE name REGEXP '^..$';
-- 等价于 CHAR_LENGTH(name) = 2

-- 名字不包含"五"（用 ^ 表示取反字符类，注意和行首区分）
SELECT * FROM student WHERE name REGEXP '[^五]';
-- 这条会返回所有行，因为只要名字里有一个字符不是"五"就匹配

-- 正确写法：名字不是"五"开头的
SELECT * FROM student WHERE name NOT REGEXP '^五';


-- ============================================================
-- 第二部分: MySQL 8.0+ 高级正则函数
-- ============================================================

-- 2.1 REGEXP_LIKE() - 判断是否匹配（与 REGEXP 同义）
SELECT name, REGEXP_LIKE(name, '^张') AS '是否姓张' FROM student;

-- 2.2 REGEXP_REPLACE() - 正则替换
-- 将手机号的中间4位替换为 ****
SELECT
    phone,
    REGEXP_REPLACE(phone, '^(\\d{3})\\d{4}(\\d{4})$', '$1****$2') AS '脱敏手机号'
FROM student;

-- 将地址中的"区"替换为"区/"
SELECT name, REGEXP_REPLACE(address, '区', '区/') AS new_address FROM student;

-- 2.3 REGEXP_SUBSTR() - 提取匹配的子串
-- 提取地址中的数字部分
SELECT name, address, REGEXP_SUBSTR(address, '[0-9]+') AS '提取的数字' FROM student;

-- 提取地址中的"路"或"街"前面的部分
SELECT
    name,
    address,
    REGEXP_SUBSTR(address, '[^路街]+[路街]') AS '街道名'
FROM student;

-- 2.4 REGEXP_INSTR() - 返回匹配的起始位置
SELECT name, REGEXP_INSTR(phone, '123') AS '123出现的位置' FROM student;


-- ============================================================
-- 第三部分: 常用正则示例汇总
-- ============================================================

-- 验证手机号格式（1开头的11位数字）
SELECT name, phone,
    REGEXP_LIKE(phone, '^1[3-9]\\d{9}$') AS '是否有效手机号'
FROM student;

-- 匹配邮箱格式（假设有email字段）
-- SELECT email FROM users WHERE email REGEXP '^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$';

-- 匹配纯中文
SELECT * FROM student WHERE name REGEXP '^[\\x{4e00}-\\x{9fa5}]+$';
-- 注意: 上面这种写法需要 MySQL 8.0+ 支持 Unicode 属性

-- 更通用的写法（匹配汉字）
SELECT * FROM student WHERE name NOT REGEXP '[a-zA-Z0-9]' AND name != '';
