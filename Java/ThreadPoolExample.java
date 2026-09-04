import java.util.concurrent.ExecutorService;
import java.util.concurrent.Executors;

/**
 * Java 线程池使用范例
 * 
 * 本文件演示了 Java 中三种常见的线程池类型：
 * 1. 固定核心线程池（FixedThreadPool）
 * 2. 单线程池（SingleThreadExecutor）
 * 3. 可缓存线程池（CachedThreadPool）
 * 
 * 每种线程池都有其独特的特点和适用场景，详见下方注释说明。
 */
public class ThreadPoolExample {

    // ============================
    // 定义一个通用的任务：模拟一个耗时操作
    // ============================
    /**
     * 创建一个实现了 Runnable 接口的任务类
     * 每个任务会打印当前线程名称和任务编号，然后休眠 1 秒来模拟耗时操作
     */
    static class Task implements Runnable {
        private int taskId; // 任务编号

        public Task(int taskId) {
            this.taskId = taskId;
        }

        @Override
        public void run() {
            try {
                // 打印任务开始信息，包含当前执行该任务的线程名称
                System.out.println("任务 " + taskId + " 正在执行，线程：" + Thread.currentThread().getName());
                // 模拟耗时操作，休眠 1 秒
                Thread.sleep(1000);
                // 打印任务完成信息
                System.out.println("任务 " + taskId + " 执行完毕，线程：" + Thread.currentThread().getName());
            } catch (InterruptedException e) {
                // 如果线程在休眠中被中断，捕获中断异常
                e.printStackTrace();
            }
        }
    }

    // ============================================================
    // 方案一：固定核心线程池（FixedThreadPool）
    // ============================================================
    /**
     * 【特点】
     * - 线程池中的线程数量是固定的，创建时指定核心线程数
     * - 当所有线程都在忙碌时，新提交的任务会被放入等待队列中排队
     * - 线程池中的线程不会因为空闲而被回收（除非线程池被关闭）
     * - 如果某个线程因异常终止，线程池会自动创建一个新的线程来替代
     * 
     * 【使用场景】
     * - 适用于负载较重、任务量较大且需要长期运行的场景
     * - 适用于需要控制并发线程数量的场景，防止过多线程消耗系统资源
     * - 例如：Web 服务器处理 HTTP 请求、数据库连接池管理、批量数据处理等
     * 
     * 【注意事项】
     * - 需要根据系统资源和任务特性合理设置线程数量
     * - 线程数过多会导致内存占用增加和上下文切换开销
     * - 线程数过少会导致任务排队时间过长，降低吞吐量
     */
    public static void fixedThreadPoolExample() {
        System.out.println("\n========== 固定核心线程池示例 ==========");
        System.out.println("创建一个固定大小为 3 的线程池，提交 5 个任务");
        System.out.println("由于线程池只有 3 个线程，所以最多同时执行 3 个任务，其余 2 个任务需要排队等待\n");

        // 创建一个固定大小为 3 的线程池
        // 这意味着线程池中始终维护 3 个工作线程
        ExecutorService fixedPool = Executors.newFixedThreadPool(3);

        // 提交 5 个任务到线程池
        // 由于线程池大小为 3，所以前 3 个任务会立即执行
        // 后 2 个任务会进入等待队列，等待有空闲线程时再执行
        for (int i = 1; i <= 5; i++) {
            fixedPool.execute(new Task(i));
        }

        // 关闭线程池
        // shutdown() 方法会等待已提交的任务全部执行完毕后再关闭线程池
        // 调用 shutdown() 后，线程池不再接受新的任务提交
        fixedPool.shutdown();
    }

    // ============================================================
    // 方案二：单线程池（SingleThreadExecutor）
    // ============================================================
    /**
     * 【特点】
     * - 线程池中只有一个工作线程
     * - 所有提交的任务都会按照提交顺序依次执行（串行执行）
     * - 保证所有任务在同一个线程中按顺序执行
     * - 如果唯一的线程因异常终止，线程池会自动创建一个新的线程来替代
     * 
     * 【使用场景】
     * - 适用于需要保证任务顺序执行的场景
     * - 适用于不需要并发执行的任务，但希望统一任务管理的场景
     * - 适用于需要避免线程安全问题的场景（因为只有一个线程，无需考虑并发）
     * - 例如：日志写入、文件备份、定时任务调度、消息队列消费等
     * 
     * 【注意事项】
     * - 由于只有一个线程，所以任务只能串行执行，吞吐量较低
     * - 如果某个任务执行时间过长，会导致后续任务长时间等待
     * - 适合任务量不大但对执行顺序有严格要求的场景
     */
    public static void singleThreadExecutorExample() {
        System.out.println("\n========== 单线程池示例 ==========");
        System.out.println("创建一个单线程池，提交 3 个任务");
        System.out.println("由于线程池只有 1 个线程，所以 3 个任务会严格按照提交顺序依次执行\n");

        // 创建一个单线程池
        // 线程池中只有一个工作线程，所有任务都会在这个线程中串行执行
        ExecutorService singlePool = Executors.newSingleThreadExecutor();

        // 依次提交 3 个任务
        // 这 3 个任务会按照 1 -> 2 -> 3 的顺序依次执行
        // 每个任务必须等前一个任务完成后才能开始
        for (int i = 1; i <= 3; i++) {
            singlePool.execute(new Task(i));
        }

        // 关闭线程池
        // 等待所有任务执行完毕后关闭
        singlePool.shutdown();
    }

    // ============================================================
    // 方案三：可缓存线程池（CachedThreadPool）
    // ============================================================
    /**
     * 【特点】
     * - 线程池的大小不固定，可以根据需要动态创建新线程
     * - 当有新任务提交时，如果有空闲线程则复用该线程，否则创建新线程
     * - 空闲线程在 60 秒后会被自动回收销毁，释放资源
     * - 理论上可以创建无限数量的线程（受限于系统资源）
     * 
     * 【使用场景】
     * - 适用于执行大量短期任务（任务执行时间短、任务数量多）
     * - 适用于任务提交频率高但每个任务执行时间短的场景
     * - 适用于需要快速响应的场景，不需要等待线程池中的空闲线程
     * - 例如：处理大量并发的短时间 HTTP 请求、批量数据校验等
     * 
     * 【注意事项】
     * - 由于线程数不固定，如果任务执行时间较长或提交速度过快，
     *   可能会创建大量线程，导致系统资源耗尽（OOM）
     * - 不适合用于长期运行的任务或任务提交频率不可控的场景
     * - 在这种场景下，建议使用 FixedThreadPool 或自定义线程池
     */
    public static void cachedThreadPoolExample() {
        System.out.println("\n========== 可缓存线程池示例 ==========");
        System.out.println("创建一个可缓存线程池，提交 5 个任务");
        System.out.println("线程池会根据需要自动创建线程，5 个任务可以同时执行\n");

        // 创建一个可缓存的线程池
        // 线程池大小不固定，会根据任务数量自动创建新线程
        // 空闲超过 60 秒的线程会被自动回收
        ExecutorService cachedPool = Executors.newCachedThreadPool();

        // 提交 5 个任务
        // 由于是可缓存线程池，会创建 5 个线程来同时执行这 5 个任务
        // 所有任务几乎同时开始执行，无需排队等待
        for (int i = 1; i <= 5; i++) {
            cachedPool.execute(new Task(i));
        }

        // 关闭线程池
        // 等待所有任务执行完毕后关闭
        cachedPool.shutdown();
    }

    // ============================================================
    // 主方法：演示三种线程池的使用
    // ============================================================
    public static void main(String[] args) {
        System.out.println("====================================");
        System.out.println("    Java 线程池使用范例");
        System.out.println("    演示三种常见的线程池类型");
        System.out.println("====================================");

        // 演示方案一：固定核心线程池
        // 特点：线程数固定，适合长期运行的重型任务
        fixedThreadPoolExample();

        // 等待上一个线程池的所有任务执行完毕后再执行下一个示例
        // 这里使用简单的休眠来等待，实际项目中可以使用 CountDownLatch 等工具
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // 演示方案二：单线程池
        // 特点：只有一个线程，任务串行执行，保证执行顺序
        singleThreadExecutorExample();

        // 等待上一个线程池的所有任务执行完毕
        try {
            Thread.sleep(5000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        // 演示方案三：可缓存线程池
        // 特点：线程数不固定，适合大量短期任务
        cachedThreadPoolExample();

        // 等待所有示例执行完毕
        try {
            Thread.sleep(3000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        System.out.println("\n====================================");
        System.out.println("    所有线程池示例执行完毕！");
        System.out.println("====================================");
    }
}
