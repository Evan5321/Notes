
class MutiThreadbyExtendsThread extends Thread{
    @Override
    public void run() {
        for(int i= 0;i<10;i++){
            System.out.println(Thread.currentThread().getName()+"is running at:"+i);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }

    }
}

class MutiThreadbyImplementsRunnable implements Runnable{

    @Override
    public void run() {
        for(int i= 0;i<10;i++){
            System.out.println(Thread.currentThread().getName()+"is running at:"+i);
            try {
                Thread.sleep(1000);
            } catch (InterruptedException e) {
                e.printStackTrace();
            }
        }
    }
    
}

public class MultiThreadExample {
    public static void main(String[] args) {
        MutiThreadbyExtendsThread t1 = new MutiThreadbyExtendsThread();
        MutiThreadbyExtendsThread t2 = new MutiThreadbyExtendsThread();
        t1.setName("ThreadbyExtendsThread1");
        t2.setName("ThreadbyExtendsThread2");
        t1.start();
        t2.start();

        //阻塞等待t1和t2线程执行完毕后再执行下面的代码
        try {
            t1.join();
            t2.join();
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        try {
            System.out.println("Main thread is sleeping for 2 seconds before starting Runnable threads");
            Thread.sleep(2000);
        } catch (InterruptedException e) {
            e.printStackTrace();
        }

        MutiThreadbyImplementsRunnable r1 = new MutiThreadbyImplementsRunnable();
        Thread t3 = new Thread(r1,"ThreadbyImplementsRunnable1");
        Thread t4 = new Thread(r1,"ThreadbyImplementsRunnable2");
        t3.start();
        t4.start();
    }
}
