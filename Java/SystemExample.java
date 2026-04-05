import java.util.Arrays;

public class SystemExample {
    public static void main(String[] args) {
        int[] a = {7, 8, 9, 10, 11};
        int[] b = {1, 2, 3, 4, 5, 6};
        //从数组a的第二个元素开始，复制到b数组的第三个位置 复制的元素长度为3
        System.arraycopy(a, 1, b, 2, 3);
        //输出结果 [1, 2, 8, 9, 10, 6]
        System.out.println(Arrays.toString(b));
        //输出以毫秒为单位的当前时间(从1970年到现在的毫秒数)
        System.out.println("当前时间：" + System.currentTimeMillis());
        System.out.println("java版本信息：" + System.getProperty("java.version"));
        
        //运行垃圾收集器
        System.gc();
        // 大量临时对象使用完毕后，优先调用集合clear清空元素并将引用置null切断强引用，缩小对象作用域方便JVM自动GC回收;
        // 禁止业务代码频繁调用System.gc()触发FullGC造成卡顿，仅任务空闲收尾阶段可酌情建议GC，同时注意及时清理静态集合、ThreadLocal避免内存泄漏;
        
        //退出
        System.exit(0);
    }
}
