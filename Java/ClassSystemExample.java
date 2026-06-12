/**
 * 演示 Java 继承、方法重写、构造器传参、super/this 等语法
 */
public class  ClassSystemExample {

    // ---------- 父类：Vehicle（交通工具） ----------
    static class Vehicle {
        protected String brand;
        protected int speed;

        // 父类构造器（有参）
        public Vehicle(String brand, int speed) {
            this.brand = brand;
            this.speed = speed;
            System.out.println("Vehicle 构造器执行，brand=" + brand + ", speed=" + speed);
        }

        // 父类方法：移动
        public void move() {
            System.out.println(brand + " 正在移动，当前速度：" + speed + " km/h");
        }

        // 父类方法：加速，返回新速度
        public int accelerate(int increment) {
            this.speed += increment;
            System.out.println(brand + " 加速了 " + increment + " km/h，现速度：" + speed);
            return this.speed;
        }

        // 父类方法：获取信息（将被重写）
        public String getInfo() {
            return "品牌：" + brand + "，速度：" + speed;
        }
    }

    // ---------- 子类1：Car（汽车）继承 Vehicle ----------
    static class Car extends Vehicle {
        private final int doors;   // 子类特有属性：车门数

        // 子类构造器：使用 super 调用父类构造器
        public Car(String brand, int speed, int doors) {
            super(brand, speed);   // 必须第一行，初始化父类部分
            this.doors = doors;
            System.out.println("Car 构造器执行，doors=" + doors);
        }

        // 子类重写 move() 方法
        @Override
        public void move() {
            System.out.println(brand + " 汽车正在飞驰，速度：" + speed + " km/h，车门数：" + doors);
        }

        // 子类特有方法：鸣笛
        public void honk() {
            System.out.println(brand + " 汽车鸣笛：滴滴！");
        }

        // 重写 getInfo，同时调用父类方法获取基础信息
        @Override
        public String getInfo() {
            return super.getInfo() + "，车门数：" + doors;
        }
    }

    // ---------- 子类2：Bike（自行车）继承 Vehicle ----------
    static class Bike extends Vehicle {
        private boolean hasBasket;   // 是否有车篮

        // 子类构造器
        public Bike(String brand, int speed, boolean hasBasket) {
            super(brand, speed);
            this.hasBasket = hasBasket;
            System.out.println("Bike 构造器执行，hasBasket=" + hasBasket);
        }

        // 重写 move() 方法
        @Override
        public void move() {
            System.out.println(brand + " 自行车正在骑行，速度：" + speed + " km/h，有车篮：" + hasBasket);
        }

        // 子类特有方法：响铃
        public void ringBell() {
            System.out.println(brand + " 自行车铃铛：叮铃铃～");
        }
    }

    // ---------- 测试类 ----------
    public static void main(String[] args) {
        // 1. 使用子类构造器创建对象（自动调用父类构造器）
        System.out.println("=== 创建 Car 对象 ===");
        Car myCar = new Car("Tesla", 0, 4);
        System.out.println();

        System.out.println("=== 创建 Bike 对象 ===");
        Bike myBike = new Bike("Giant", 10, true);
        System.out.println();

        // 2. 调用子类重写的方法（多态）
        System.out.println("=== 调用 move() 方法 ===");
        myCar.move();
        myBike.move();
        System.out.println();

        // 3. 调用子类特有方法
        System.out.println("=== 调用特有方法 ===");
        myCar.honk();
        myBike.ringBell();
        System.out.println();

        // 4. 调用从父类继承的方法（未重写）
        System.out.println("=== 调用父类方法 accelerate ===");
        myCar.accelerate(30);
        myBike.accelerate(5);
        System.out.println();

        // 5. 调用重写的 getInfo，内部使用了 super.getInfo()
        System.out.println("=== 调用 getInfo ===");
        System.out.println("Car info: " + myCar.getInfo());
        System.out.println("Bike info: " + myBike.getInfo());
        System.out.println();

        // 6. 演示向上转型（子类对象赋给父类引用）
        System.out.println("=== 向上转型 & 多态 ===");
        Vehicle v1 = myCar;
        Vehicle v2 = myBike;
        v1.move();   // 动态绑定，实际调用 Car 的 move()
        v2.move();   // 调用 Bike 的 move()
        // v1.honk();  错误：父类引用不能调用子类特有方法
        System.out.println();

        // 7. 演示向下转型（需要先 instanceof 判断）
        System.out.println("=== 向下转型 ===");
        if (v1 instanceof Car) {
            Car carAgain = (Car) v1;
            carAgain.honk();   // 转型成功，可以调用特有方法
        }

        // 8. 方法参数传递：接收 Vehicle 类型，实现多态参数
        System.out.println("\n=== 多态参数传递 ===");
        printVehicleInfo(myCar);
        printVehicleInfo(myBike);
    }

    // 多态参数方法：接受任何继承自 Vehicle 的对象
    public static void printVehicleInfo(Vehicle v) {
        System.out.println("【打印信息】" + v.getInfo());
    }
}