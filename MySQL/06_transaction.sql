-- ============================================================
-- MySQL 学习笔记 06: 事务 (Transaction)
-- ============================================================
/*
事务: 一组 SQL 操作，要么全部成功，要么全部失败回滚。

ACID 四大特性:
    A (Atomicity)       原子性 - 事务不可分割，全部成功或全部失败
    C (Consistency)     一致性 - 数据从一种一致状态变到另一种一致状态
    I (Isolation)       隔离性 - 并发事务之间互不干扰
    D (Durability)      持久性 - 事务提交后数据永久保存

隔离级别（由低到高）:
    READ UNCOMMITTED    读未提交（可能读到未提交的数据→脏读）
    READ COMMITTED      读已提交（可能两次读到不同数据→不可重复读）
    REPEATABLE READ     可重复读（MySQL默认，可能读到幻影行→幻读）
    SERIALIZABLE        串行化（最严格，性能最差）

事务相关命令:
    START TRANSACTION / BEGIN    开启事务
    COMMIT                       提交事务（保存更改）
    ROLLBACK                     回滚事务（撤销更改）
    SAVEPOINT                    设置保存点
    ROLLBACK TO SAVEPOINT        回滚到保存点
    SET AUTOCOMMIT               设置自动提交模式
*/

USE school;

-- 准备测试表：银行账户
CREATE TABLE IF NOT EXISTS account (
    id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL,
    balance DECIMAL(10,2) NOT NULL DEFAULT 0.00
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COMMENT='银行账户表';

-- 注意: 事务需要 InnoDB 引擎，MyISAM 不支持事务
-- 查看表的引擎: SHOW TABLE STATUS WHERE Name = 'account';

-- 插入测试数据
INSERT INTO account (name, balance) VALUES ('张三', 1000.00), ('李四', 500.00);


-- ============================================================
-- 第一部分: 基本事务操作
-- ============================================================

-- 示例: 张三给李四转账 200 元
-- 需要两条 UPDATE 语句作为同一个事务

-- 开启事务
START TRANSACTION;

-- 第1步: 张三扣款
UPDATE account SET balance = balance - 200 WHERE name = '张三';

-- 第2步: 李四加款
UPDATE account SET balance = balance + 200 WHERE name = '李四';

-- 提交事务（正式生效）
COMMIT;

-- 如果中间出错或想取消，可以:
-- ROLLBACK;   -- 回滚，撤销所有更改


-- ============================================================
-- 第二部分: 手动演示事务的原子性
-- ============================================================

-- 查看当前余额
SELECT * FROM account;

-- 开启事务
BEGIN;  -- START TRANSACTION 的简写

-- 尝试给不存在的用户扣款
UPDATE account SET balance = balance - 100 WHERE name = '张三';
-- 更新不存在的用户（这行会成功但不会影响任何行）
UPDATE account SET balance = balance + 100 WHERE name = '王五(不存在)';

-- 如果此时检查数据，张三已扣100，但王五不存在所以没加上（钱丢了！）
-- 所以应该回滚
ROLLBACK;

-- 验证余额恢复
SELECT * FROM account;


-- ============================================================
-- 第三部分: SAVEPOINT - 保存点
-- ============================================================
/*
保存点允许在事务中设置断点，回滚时可以只回滚到某个保存点
而不是回滚整个事务。
*/

START TRANSACTION;

UPDATE account SET balance = balance - 100 WHERE name = '张三';
SAVEPOINT sp1;                  -- 设置保存点 sp1

UPDATE account SET balance = balance + 100 WHERE name = '李四';
-- 突然发现不想给李四加了，想换一种方式

ROLLBACK TO SAVEPOINT sp1;      -- 回滚到 sp1（张三的扣款保留，李四的加款撤销）

-- 换个方式操作
UPDATE account SET balance = balance + 50 WHERE name = '李四';
UPDATE account SET balance = balance + 50 WHERE name = '张三';

COMMIT;                         -- 提交最终结果

-- 保存点只在事务内有效，提交或回滚后自动释放
-- RELEASE SAVEPOINT sp1;       -- 可以手动释放保存点


-- ============================================================
-- 第四部分: 自动提交模式
-- ============================================================

-- 查看当前自动提交模式
SELECT @@AUTOCOMMIT;    -- 1 = 开启（默认每条SQL自动提交）

-- 关闭自动提交
SET AUTOCOMMIT = 0;

-- 此时所有 SQL 都在一个隐式事务中，直到手动 COMMIT 或 ROLLBACK
UPDATE account SET balance = balance + 10 WHERE name = '张三';
-- 数据并没有真正保存！

COMMIT;                 -- 提交

-- 恢复自动提交
SET AUTOCOMMIT = 1;


-- ============================================================
-- 第五部分: 事务隔离级别演示
-- ============================================================

-- 查看当前隔离级别
SELECT @@TRANSACTION_ISOLATION;   -- MySQL 8.0
-- SELECT @@TX_ISOLATION;          -- MySQL 5.x

-- 设置隔离级别（当前会话）
SET SESSION TRANSACTION ISOLATION LEVEL READ COMMITTED;

-- 设置全局隔离级别
-- SET GLOBAL TRANSACTION ISOLATION LEVEL REPEATABLE READ;

/*
隔离级别效果对比（需要在两个会话中测试）:

会话A执行:                         会话B执行:
1. START TRANSACTION;              1. START TRANSACTION;
2. SELECT balance FROM account;
   → 看到 1000
                                    2. UPDATE account SET balance=0 WHERE name='张三';
                                    3. 未提交
3. SELECT balance FROM account;
   → READ UNCOMMITTED: 看到 0（脏读）
   → READ COMMITTED:   看到 1000（未提交不可见）
                                    4. COMMIT;
5. SELECT balance FROM account;
   → READ UNCOMMITTED: 看到 0
   → READ COMMITTED:   看到 0（不可重复读：两次读取结果不同）
   → REPEATABLE READ:  看到 1000（一致读，MVCC机制）
6. COMMIT;
*/


-- ============================================================
-- 第六部分: 死锁示例与处理
-- ============================================================

/*
死锁: 两个事务互相等待对方释放资源。

示例（需要在两个会话中同时执行）:
会话A:                             会话B:
START TRANSACTION;                 START TRANSACTION;
UPDATE account SET balance=balance  UPDATE account SET balance=balance
  -100 WHERE id=1;                    -100 WHERE id=2;
UPDATE account SET balance=balance  UPDATE account SET balance=balance
  +100 WHERE id=2;                    +100 WHERE id=1;
COMMIT;                             COMMIT;

如果A和B同时执行第一条后，A锁住id=1等待id=2，B锁住id=2等待id=1 → 死锁。
MySQL 会自动检测死锁并回滚其中一个事务。
*/

-- 查看当前运行的事务
-- SELECT * FROM information_schema.INNODB_TRX;

-- 查看锁信息
-- SELECT * FROM performance_schema.data_locks;


-- ============================================================
-- 第七部分: 事务的最佳实践
-- ============================================================

-- 示例: 带错误处理的事务（用存储过程演示）
-- 实际应用中可以在应用层或存储过程中实现

/*
DELIMITER $$

CREATE PROCEDURE transfer(IN from_name VARCHAR(50), IN to_name VARCHAR(50), IN amount DECIMAL(10,2))
BEGIN
    -- 声明异常处理
    DECLARE EXIT HANDLER FOR SQLEXCEPTION
    BEGIN
        ROLLBACK;       -- 发生异常回滚
        SELECT '转账失败，已回滚' AS result;
    END;

    START TRANSACTION;
        -- 扣款方余额检查
        IF (SELECT balance FROM account WHERE name = from_name) < amount THEN
            SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = '余额不足';
        END IF;

        UPDATE account SET balance = balance - amount WHERE name = from_name;
        UPDATE account SET balance = balance + amount WHERE name = to_name;
    COMMIT;
    SELECT '转账成功' AS result;
END$$

DELIMITER ;

-- 调用存储过程
-- CALL transfer('张三', '李四', 100);
*/
