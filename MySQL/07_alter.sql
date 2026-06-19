-- ============================================================
-- MySQL 学习笔记 07: ALTER 命令（修改表结构）
-- ============================================================
/*
ALTER 用于修改数据库表的结构，包括:
    添加/删除/修改列
    添加/删除索引和约束
    修改表名、引擎、字符集
    修改列的默认值
*/

USE school;

-- ============================================================
-- 第一部分: 列操作
-- ============================================================

-- 1.1 添加列
-- 在 student 表末尾添加一列
ALTER TABLE student
ADD COLUMN email VARCHAR(100) COMMENT '邮箱';

-- 指定位置添加列: FIRST（最前面）
ALTER TABLE student
ADD COLUMN stu_no CHAR(10) COMMENT '学号' FIRST;

-- 指定位置添加列: AFTER 某列
ALTER TABLE student
ADD COLUMN nickname VARCHAR(30) COMMENT '昵称' AFTER name;

-- 1.2 一次添加多个列
ALTER TABLE student
    ADD COLUMN wechat VARCHAR(50) COMMENT '微信' AFTER phone,
    ADD COLUMN qq VARCHAR(20) COMMENT 'QQ号' AFTER wechat;

-- 1.3 删除列
ALTER TABLE student
DROP COLUMN qq;

-- 一次删除多列
ALTER TABLE student
    DROP COLUMN wechat,
    DROP COLUMN nickname;

-- 1.4 修改列的数据类型
-- 将 score 从 DECIMAL(5,2) 改为 DECIMAL(6,2)
ALTER TABLE student
MODIFY COLUMN score DECIMAL(6,2) COMMENT '总分（修改后）';
-- MODIFY 需要重新写完整的列定义（包括可能丢失的 NOT NULL 和 COMMENT）

-- 1.5 修改列的名称和类型
-- CHANGE 可以重命名列（MODIFY 不能改名）
-- 语法: CHANGE 旧列名 新列名 新数据类型
ALTER TABLE student
CHANGE COLUMN stu_no student_no VARCHAR(20) COMMENT '学号（修改后）';

-- 1.6 修改列的默认值
-- 设置默认值
ALTER TABLE student
ALTER COLUMN score SET DEFAULT 0.00;

-- 删除默认值
ALTER TABLE student
ALTER COLUMN score DROP DEFAULT;

-- 1.7 设置列为 NOT NULL 或 NULL
-- 将 phone 改为允许为空
ALTER TABLE student
MODIFY COLUMN phone CHAR(11) NULL;

-- 将 phone 改为不允许为空
-- ALTER TABLE student MODIFY COLUMN phone CHAR(11) NOT NULL;
-- 注意: 如果已有 NULL 值，需要先处理数据


-- ============================================================
-- 第二部分: 约束操作
-- ============================================================

-- 2.1 添加主键
ALTER TABLE student
ADD PRIMARY KEY (id);
-- 通常建表时已定义，这里仅为演示

-- 2.2 删除主键
-- ALTER TABLE student DROP PRIMARY KEY;
-- 注意: 自增列必须先去自增属性才能删主键

-- 2.3 添加唯一约束
ALTER TABLE student
ADD CONSTRAINT uk_email UNIQUE (email);
-- CONSTRAINT 关键字可选，uk_email 是约束名

-- 2.4 删除唯一约束
ALTER TABLE student
DROP INDEX uk_email;

-- 2.5 添加外键约束
-- 在 enrollment 表上添加外键（如果之前删了）
ALTER TABLE enrollment
ADD CONSTRAINT fk_student FOREIGN KEY (student_id) REFERENCES student(id)
ON DELETE CASCADE          -- 级联删除: 学生删了，选课记录也删
ON UPDATE CASCADE;         -- 级联更新

-- 2.6 删除外键约束
ALTER TABLE enrollment
DROP FOREIGN KEY fk_student;
-- 外键不删除只是 DROP INDEX，需要用 DROP FOREIGN KEY


-- ============================================================
-- 第三部分: 索引操作
-- ============================================================

-- 3.1 添加索引
-- 普通索引
ALTER TABLE student
ADD INDEX idx_name (name);

-- 前缀索引（只索引前 N 个字符，大文本字段常用）
ALTER TABLE student
ADD INDEX idx_address (address(10));

-- 复合索引（多列组合）
ALTER TABLE student
ADD INDEX idx_age_score (age, score);

-- 3.2 删除索引
ALTER TABLE student
DROP INDEX idx_name;

-- 查看表中的所有索引
SHOW INDEX FROM student;


-- ============================================================
-- 第四部分: 表级操作
-- ============================================================

-- 4.1 重命名表
-- 语法: RENAME TABLE 旧名 TO 新名;
-- ALTER TABLE old_name RENAME TO new_name;  -- 另一种写法
-- RENAME TABLE student TO student_old;

-- 4.2 修改表的字符集
ALTER TABLE student
CONVERT TO CHARACTER SET utf8mb4
COLLATE utf8mb4_unicode_ci;

-- 仅修改默认字符集（不影响已有列）
ALTER TABLE student
DEFAULT CHARACTER SET utf8mb4;

-- 4.3 修改表的存储引擎
-- ALTER TABLE student ENGINE = InnoDB;

-- 4.4 修改表的自增值
ALTER TABLE student AUTO_INCREMENT = 100;


-- ============================================================
-- 第五部分: ALTER 完整实战
-- ============================================================

-- 创建一个原始表做演示
CREATE TABLE IF NOT EXISTS product (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    price DECIMAL(10,2)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='商品表';

-- 添加库存字段（在 price 之后）
ALTER TABLE product
ADD COLUMN stock INT UNSIGNED NOT NULL DEFAULT 0 COMMENT '库存数量' AFTER price;

-- 添加分类和描述字段
ALTER TABLE product
    ADD COLUMN category VARCHAR(50) COMMENT '商品分类' AFTER name,
    ADD COLUMN description TEXT COMMENT '商品描述' AFTER stock;

-- 修改 price 列名并改变类型
ALTER TABLE product
CHANGE COLUMN price original_price DECIMAL(10,2) COMMENT '原价';

-- 添加折扣价
ALTER TABLE product
ADD COLUMN discount_price DECIMAL(10,2) COMMENT '折扣价' AFTER original_price;

-- 添加索引
ALTER TABLE product
    ADD INDEX idx_category (category),
    ADD INDEX idx_name (name);

-- 添加 CHECK 约束（MySQL 8.0.16+ 支持）
ALTER TABLE product
ADD CONSTRAINT chk_price CHECK (discount_price < original_price);

-- 查看最终表结构
DESC product;
SHOW CREATE TABLE product;


-- ============================================================
-- 第六部分: 常用 ALTER 速查表
-- ============================================================
/*
添加列:              ALTER TABLE t ADD COLUMN c type [AFTER col];
删除列:              ALTER TABLE t DROP COLUMN c;
修改列类型:          ALTER TABLE t MODIFY COLUMN c new_type;
重命名列:            ALTER TABLE t CHANGE old_c new_c type;
添加主键:            ALTER TABLE t ADD PRIMARY KEY (col);
删除主键:            ALTER TABLE t DROP PRIMARY KEY;
添加外键:            ALTER TABLE t ADD CONSTRAINT fk FOREIGN KEY (col) REFERENCES t2(col);
删除外键:            ALTER TABLE t DROP FOREIGN KEY fk_name;
添加唯一约束:        ALTER TABLE t ADD CONSTRAINT uq UNIQUE (col);
删除唯一约束:        ALTER TABLE t DROP INDEX uq_name;
添加索引:            ALTER TABLE t ADD INDEX idx_name (col);
删除索引:            ALTER TABLE t DROP INDEX idx_name;
修改默认值:          ALTER TABLE t ALTER COLUMN c SET DEFAULT val;
删除默认值:          ALTER TABLE t ALTER COLUMN c DROP DEFAULT;
重命名表:            ALTER TABLE t RENAME TO new_t;
修改字符集:          ALTER TABLE t CONVERT TO CHARACTER SET utf8mb4;
修改引擎:            ALTER TABLE t ENGINE = InnoDB;
*/
