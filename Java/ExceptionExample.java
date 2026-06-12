/**
 * Java 异常处理全面范例
 *
 * 涵盖以下内容：
 *   1. 异常体系结构 (Error, RuntimeException, Checked Exception)
 *   2. try-catch-finally 三种组合
 *   3. 多 catch 块与异常匹配顺序
 *   4. try-with-resources（自动资源管理）
 *   5. throws 声明异常
 *   6. throw 手动抛出异常
 *   7. 自定义异常
 *   8. 异常链 (Exception Chaining)
 *   9. 常见运行时异常演示
 *  10. Error 演示（StackOverflowError / OutOfMemoryError）
 */

import java.io.*;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.Date;

// ============================================================
// 7. 自定义异常
// ============================================================

/** 自定义受检异常：余额不足 */
class InsufficientBalanceException extends Exception {
    public InsufficientBalanceException(String message) {
        super(message);
    }

    public InsufficientBalanceException(String message, Throwable cause) {
        super(message, cause); // 支持异常链
    }
}

/** 自定义运行时异常：非法转账 */
class IllegalTransferException extends RuntimeException {
    public IllegalTransferException(String message) {
        super(message);
    }
}

/** 自定义异常：取款异常（继承 Exception） */
class WithdrawException extends Exception {
    public WithdrawException(String message) {
        super(message);
    }

    public WithdrawException(String message, Throwable cause) {
        super(message, cause);
    }
}

// ============================================================
// 资源类：用于演示 try-with-resources
// ============================================================
class DatabaseConnection implements AutoCloseable {
    private String name;

    public DatabaseConnection(String name) {
        this.name = name;
        System.out.println("   [资源] " + name + " 连接已打开。");
    }

    public void query(String sql) {
        System.out.println("   [数据库] 执行查询: " + sql);
    }

    @Override
    public void close() {
        System.out.println("   [资源] " + name + " 连接已关闭。");
    }
}

// ============================================================
// 银行账户类：演示异常的多种使用场景
// ============================================================
class BankAccount {
    private String owner;
    private double balance;

    public BankAccount(String owner, double balance) {
        this.owner = owner;
        this.balance = balance;
    }

    public double getBalance() {
        return balance;
    }

    // 演示 throw + 自定义受检异常
    public void withdraw(double amount) throws InsufficientBalanceException {
        if (amount < 0) {
            throw new IllegalArgumentException("取款金额不能为负数: " + amount);
        }
        if (amount > balance) {
            throw new InsufficientBalanceException(
                owner + " 余额不足: 需要 " + amount + ", 可用 " + balance);
        }
        balance -= amount;
        System.out.println("   [取款] " + owner +  " 成功取款 " + amount + ", 剩余 " + balance);
    }

    // 演示 throws + 多个异常
    public void transfer(BankAccount target, double amount)
            throws InsufficientBalanceException, IllegalArgumentException {

        if (target == null) {
            throw new IllegalArgumentException("目标账户不能为 null");
        }
        if (amount <= 0) {
            throw new IllegalArgumentException("转账金额必须大于 0: " + amount);
        }

        // 先检查余额
        if (this.balance < amount) {
            throw new InsufficientBalanceException(
                this.owner + " 余额不足, 无法转账 " + amount + " 给 " + target.owner);
        }

        this.balance -= amount;
        target.balance += amount;
        System.out.println("   [转账] " + this.owner + " 向 " + target.owner
            + " 转账 " + amount + " 成功");
    }

    @Override
    public String toString() {
        return owner + " 余额: " + balance;
    }
}

// ============================================================
// 主类
// ============================================================
public class ExceptionExample {

    // ----------------------------------------------------------
    // 9. 常见运行时异常演示
    // ----------------------------------------------------------

    /** NullPointerException */
    static void demoNullPointer() {
        System.out.println("--- [NPE] NullPointerException ---");
        try {
            String str = null;
            str.length(); // 触发 NPE
        } catch (NullPointerException e) {
            System.out.println("   捕获 NullPointerException: " + e.getMessage());
            // 通常 NPE 的 message 为 null，但我们可以打印异常类型
            System.out.println("    → 调用了 null 对象的方法");
        }
        System.out.println();
    }

    /** ArrayIndexOutOfBoundsException */
    static void demoArrayIndexOutOfBounds() {
        System.out.println("--- [AIOOB] ArrayIndexOutOfBoundsException ---");
        try {
            int[] arr = {1, 2, 3};
            System.out.println("   arr[5] = " + arr[5]); // 越界
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("   捕获 ArrayIndexOutOfBoundsException: " + e.getMessage());
            System.out.println("    → 访问数组不存在的索引");
        }
        System.out.println();
    }

    /** ArithmeticException */
    static void demoArithmetic() {
        System.out.println("--- [Arithmetic] ArithmeticException ---");
        try {
            int result = 10 / 0; // 除零
        } catch (ArithmeticException e) {
            System.out.println("   捕获 ArithmeticException: " + e.getMessage());
            System.out.println("    → 整数除以零");
        }
        System.out.println();
    }

    /** ClassCastException */
    static void demoClassCast() {
        System.out.println("--- [ClassCast] ClassCastException ---");
        try {
            Object obj = "这是一个字符串";
            Integer num = (Integer) obj; // 类型转换失败
        } catch (ClassCastException e) {
            System.out.println("   捕获 ClassCastException: " + e.getMessage());
            System.out.println("    → 不兼容的类型转换");
        }
        System.out.println();
    }

    /** NumberFormatException */
    static void demoNumberFormat() {
        System.out.println("--- [NumberFormat] NumberFormatException ---");
        try {
            int num = Integer.parseInt("abc123");
        } catch (NumberFormatException e) {
            System.out.println("   捕获 NumberFormatException: " + e.getMessage());
            System.out.println("    → 字符串无法解析为数字");
        }
        System.out.println();
    }

    /** IllegalArgumentException */
    static void demoIllegalArgument() {
        System.out.println("--- [IllegalArgument] IllegalArgumentException ---");
        try {
            new BankAccount("测试", -100); // 虽然这里不会抛异常，但演示用
            Thread.sleep(-1); // 非法参数
        } catch (IllegalArgumentException e) {
            System.out.println("   捕获 IllegalArgumentException: " + e.getMessage());
            System.out.println("    → 方法接收到非法参数");
        } catch (InterruptedException e) {
            System.out.println("   InterruptedException: " + e.getMessage());
        }
        System.out.println();
    }

    /** StringIndexOutOfBoundsException */
    static void demoStringIndexOutOfBounds() {
        System.out.println("--- [StringIndex] StringIndexOutOfBoundsException ---");
        try {
            String s = "Hello";
            s.charAt(10); // 超出字符串长度
        } catch (StringIndexOutOfBoundsException e) {
            System.out.println("   捕获 StringIndexOutOfBoundsException: " + e.getMessage());
            System.out.println("    → 访问字符串中不存在的索引位置");
        }
        System.out.println();
    }

    // ----------------------------------------------------------
    // 1. try-catch-finally 三种组合
    // ----------------------------------------------------------

    /** try-catch 基本组合 */
    static void demoBasicTryCatch() {
        System.out.println("--- [基本] try-catch ---");
        try {
            int[] nums = {1, 2, 3};
            System.out.println("   nums[5] = " + nums[5]);
        } catch (ArrayIndexOutOfBoundsException e) {
            System.out.println("   捕获异常: " + e.getMessage());
        }
        // 程序继续执行
        System.out.println("   程序未中断，继续执行...\n");
    }

    /** try-catch-finally */
    static void demoFinally() {
        System.out.println("--- [Finally] try-catch-finally ---");
        Reader reader = null;
        try {
            reader = new FileReader("不存在的文件.txt");
        } catch (FileNotFoundException e) {
            System.out.println("   捕获 FileNotFoundException: " + e.getMessage());
        } finally {
            // finally 块无论是否发生异常都会执行
            System.out.println("   [finally] 清理资源...");
            if (reader != null) {
                try {
                    reader.close();
                } catch (IOException e) {
                    System.out.println("   关闭资源时异常: " + e.getMessage());
                }
            }
        }
        System.out.println();
    }

    /** 多个 catch 块 — 子类异常在前，父类异常在后 */
    static void demoMultiCatch() {
        System.out.println("--- [多catch] 多个异常类型捕获 ---");
        try {
            String input = "abc";
            System.out.println("   尝试解析 '" + input + "' 为数字...");
            int value = Integer.parseInt(input);
            // 如果在 parse 之前访问数组，会触发 AIOOB，但不会执行到这里
            int[] arr = new int[value];
            System.out.println("   创建数组完成");
        } catch (NumberFormatException e) {
            System.out.println("   捕获 NumberFormatException: " + e.getMessage());
        } catch (NegativeArraySizeException e) {
            System.out.println("   捕获 NegativeArraySizeException: " + e.getMessage());
        } catch (RuntimeException e) {
            System.out.println("   捕获 RuntimeException(父类): " + e.getMessage());
        }
        System.out.println();
    }

    /** Java 7+ | 多异常合并捕获 */
    static void demoMultiCatchPipe() {
        System.out.println("--- [|] 多异常合并捕获 ---");
        try {
            // 随机选择一种异常触发
            if (Math.random() > 0.5) {
                int[] arr = new int[3];
                System.out.println("   arr[10] = " + arr[10]);
            } else {
                String s = null;
                s.length();
            }
        } catch (ArrayIndexOutOfBoundsException | NullPointerException e) {
            // 使用 | 合并捕获多个异常（要求这些异常之间无继承关系）
            System.out.println("   合并捕获: " + e.getClass().getSimpleName()
                + " → " + e.getMessage());
        }
        System.out.println();
    }

    // ----------------------------------------------------------
    // 4. try-with-resources (AutoCloseable)
    // ----------------------------------------------------------
    static void demoTryWithResources() {
        System.out.println("--- [TWR] try-with-resources ---");
        // try-with-resources 会自动调用资源的 close() 方法
        try (DatabaseConnection conn = new DatabaseConnection("MySQL-主库");
             DatabaseConnection conn2 = new DatabaseConnection("Redis-缓存")) {
            conn.query("SELECT * FROM users");
            conn2.query("GET user:1001");
            // 故意触发异常，观察资源是否正常关闭
            if (true) {
                throw new IOException("模拟查询超时");
            }
        } catch (IOException e) {
            System.out.println("   捕获 IOException: " + e.getMessage());
        }
        // 不需要 finally 来关闭资源，TWR 自动处理
        System.out.println();
    }

    // ----------------------------------------------------------
    // 5. throws 声明异常
    // ----------------------------------------------------------

    /** throws 声明方法可能抛出异常，由调用方处理 */
    static void readConfigFile(String path) throws IOException {
        System.out.println("   [throws] 尝试读取配置文件: " + path);
        try (BufferedReader br = new BufferedReader(new FileReader(path))) {
            String line = br.readLine();
            System.out.println("   配置内容: " + line);
        }
        // 方法声明了 throws IOException，调用方必须处理
    }

    /** 演示 throws 异常的传播 */
    static void demoThrows() {
        System.out.println("--- [throws] 异常声明与传播 ---");
        try {
            readConfigFile("/etc/unknown_config.properties");
        } catch (IOException e) {
            System.out.println("   调用方捕获到 IOException: " + e.getMessage());
            System.out.println("   → 异常从 readConfigFile 传播到此处");
        }
        System.out.println();
    }

    // ----------------------------------------------------------
    // 6. throw 手动抛出异常
    // ----------------------------------------------------------
    static void demoThrow() {
        System.out.println("--- [throw] 手动抛出异常 ---");
        try {
            throw new RuntimeException("这是一个手动抛出的运行时异常");
        } catch (RuntimeException e) {
            System.out.println("   捕获到手动抛出的异常: " + e.getMessage());
        }

        // throw 也常用于方法内部前置校验
        try {
            validateAge(-5);
        } catch (IllegalArgumentException e) {
            System.out.println("   参数校验失败: " + e.getMessage());
        }
        System.out.println();
    }

    private static void validateAge(int age) {
        if (age < 0) {
            throw new IllegalArgumentException("年龄不能为负数: " + age);
        }
        System.out.println("   年龄合法: " + age);
    }

    // ----------------------------------------------------------
    // 3. 受检异常 (Checked Exception) 演示
    // ----------------------------------------------------------

    /** InterruptedException */
    static void demoInterrupted() {
        System.out.println("--- [Interrupted] InterruptedException ---");
        Thread t = new Thread(() -> {
            try {
                System.out.println("   线程开始休眠...");
                Thread.sleep(5000); // 休眠 5 秒
            } catch (InterruptedException e) {
                System.out.println("   捕获 InterruptedException: " + e.getMessage());
                System.out.println("   → 线程在休眠时被中断");
                // 恢复中断状态
                Thread.currentThread().interrupt();
            }
        });
        t.start();
        try {
            Thread.sleep(200); // 等子线程开始休眠
        } catch (InterruptedException e) {
            // ignore
        }
        t.interrupt(); // 中断子线程
        try {
            t.join();
        } catch (InterruptedException e) {
            // ignore
        }
        System.out.println();
    }

    /** ParseException */
    static void demoParseException() {
        System.out.println("--- [Parse] ParseException ---");
        SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd");
        try {
            Date date = sdf.parse("2025年13月32日"); // 格式错误
        } catch (ParseException e) {
            System.out.println("   捕获 ParseException: " + e.getMessage());
            System.out.println("   → 日期字符串格式不匹配，错误偏移: " + e.getErrorOffset());
        }
        System.out.println();
    }

    /** ClassNotFoundException */
    static void demoClassNotFound() {
        System.out.println("--- [ClassNotFound] ClassNotFoundException ---");
        try {
            Class.forName("com.unknown.Driver");
        } catch (ClassNotFoundException e) {
            System.out.println("   捕获 ClassNotFoundException: " + e.getMessage());
            System.out.println("   → 指定的类不存在于 classpath 中");
        }
        System.out.println();
    }

    // ----------------------------------------------------------
    // 8. 异常链 (Exception Chaining)
    // ----------------------------------------------------------
    static void demoExceptionChaining() throws WithdrawException {
        System.out.println("--- [链] 异常链 (Exception Chaining) ---");
        BankAccount account = new BankAccount("张三", 100);

        try {
            // 调用 withdraw，捕获 InsufficientBalanceException
            account.withdraw(9999);
        } catch (InsufficientBalanceException e) {
            // 将原始异常包装为新的异常，形成异常链
            WithdrawException we = new WithdrawException("取款流程失败", e);
            // throw 出去，由调用方处理
            throw we;
        } catch (IllegalArgumentException e) {
            throw new WithdrawException("取款参数异常", e);
        }
    }

    // ----------------------------------------------------------
    // 9. Error 演示
    // ----------------------------------------------------------

    private static int depth = 0;

    /** StackOverflowError （递归过深） */
    static void demoStackOverflow() {
        System.out.println("--- [Error] StackOverflowError ---");
        try {
            recursiveCall();
        } catch (StackOverflowError e) {
            System.out.println("   捕获 StackOverflowError: 递归深度 = " + depth);
            System.out.println("   → 方法调用栈溢出（无限递归或递归过深）");
        }
        System.out.println();
    }

    private static void recursiveCall() {
        depth++;
        // 不能无限递归下去，否则 JVM 可能崩溃，
        // 所以加一个安全边界来演示
        if (depth > 50000) {
            // 不做事，只是不断递归
        }
        recursiveCall();
    }

    /** OutOfMemoryError 演示（内存溢出） */
    static void demoOutOfMemory() {
        System.out.println("--- [Error] OutOfMemoryError ---");
        try {
            // 尝试分配超大的数组触发 OOM
            // 注意：这个可能在演示时导致 JVM 不稳定，
            // 因此用一个相对温和的方式
            @SuppressWarnings("unused")
            long[] huge = new long[Integer.MAX_VALUE]; // 约 16GB
        } catch (OutOfMemoryError e) {
            System.out.println("   捕获 OutOfMemoryError: " + e.getMessage());
            System.out.println("   → Java 堆空间不足，无法分配大对象");
        } catch (Exception e) {
            // 某些 JVM 实现可能抛出 RuntimeException 变体
            System.out.println("   捕获异常: " + e.getClass().getName() + ": " + e.getMessage());
        }
        System.out.println();
    }

    // ============================================================
    // main — 调用所有演示
    // ============================================================
    public static void main(String[] args) {

        System.out.println("============================================");
        System.out.println("   Java 异常处理全面范例");
        System.out.println("============================================\n");

        // -------- 运行时异常 --------
        demoNullPointer();
        demoArrayIndexOutOfBounds();
        demoArithmetic();
        demoClassCast();
        demoNumberFormat();
        demoIllegalArgument();
        demoStringIndexOutOfBounds();

        // -------- try-catch-finally 组合 --------
        demoBasicTryCatch();
        demoFinally();
        demoMultiCatch();
        demoMultiCatchPipe();

        // -------- try-with-resources --------
        demoTryWithResources();

        // -------- throws --------
        demoThrows();

        // -------- throw --------
        demoThrow();

        // -------- 受检异常 --------
        demoInterrupted();
        demoParseException();
        demoClassNotFound();

        // -------- 自定义异常 + 异常链 --------
        System.out.println("--- [自定义异常] BankAccount.withdraw() ---");
        BankAccount alice = new BankAccount("Alice", 500);
        try {
            alice.withdraw(600); // 会触发 InsufficientBalanceException
        } catch (InsufficientBalanceException e) {
            System.out.println("   捕获自定义异常: " + e.getMessage());
        } catch (IllegalArgumentException e) {
            System.out.println("   捕获 IllegalArgumentException: " + e.getMessage());
        }
        System.out.println();

        System.out.println("--- [转账] BankAccount.transfer() ---");
        BankAccount bob = new BankAccount("Bob", 100);
        try {
            alice.transfer(null, 50);            // null 目标 → IllegalArgumentException
        } catch (IllegalArgumentException e) {
            System.out.println("   捕获: " + e.getMessage());
        } catch (InsufficientBalanceException e) {
            System.out.println("   捕获: " + e.getMessage());
        }

        try {
            alice.transfer(bob, 10000);           // 余额不足 → InsufficientBalanceException
        } catch (IllegalArgumentException | InsufficientBalanceException e) {
            System.out.println("   捕获: " + e.getClass().getSimpleName() + " → " + e.getMessage());
        }
        System.out.println();

        // -------- 异常链 --------
        System.out.println("--- [异常链] ---");
        try {
            demoExceptionChaining();
        } catch (WithdrawException e) {
            System.out.println("   捕获 WithdrawException: " + e.getMessage());
            Throwable cause = e.getCause();
            if (cause != null) {
                System.out.println("   原始原因 (cause): "
                    + cause.getClass().getName() + " → " + cause.getMessage());
            }
        }
        System.out.println();

        // -------- Error --------
        demoStackOverflow();
        demoOutOfMemory();

        System.out.println("============================================");
        System.out.println("   所有异常范例演示完毕！");
        System.out.println("============================================");
    }
}