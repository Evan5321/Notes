// 1. 父类：员工 (基类)
class Employee {
    // 属性：使用 protected 修饰符，允许子类直接访问，但对外隐藏
    protected String name;
    protected int age;
    protected String employeeId;
    protected double baseSalary; // 基础薪资

    // 构造方法
    public Employee(String name, int age, String employeeId, double baseSalary) {
        this.name = name;
        this.age = age;
        this.employeeId = employeeId;
        this.baseSalary = baseSalary;
    }

    // 通用方法：工作
    public void work() {
        System.out.println(name + " 正在以员工身份进行日常工作...");
    }

    // 通用方法：计算薪资 (子类可以重写此方法)
    public double calculateSalary() {
        return baseSalary;
    }

    // Getter 和 Setter 方法 (封装性)
    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }
}

// 2. 子类：程序员 (继承自 Employee)
class Developer extends Employee {
    // 特有属性
    private String programmingLanguage; // 擅长编程语言
    private int linesOfCodeWritten;     // 代码行数

    // 构造方法
    public Developer(String name, int age, String employeeId, double baseSalary, String programmingLanguage) {
        // super() 必须放在第一行，用于调用父类的构造方法
        super(name, age, employeeId, baseSalary);
        this.programmingLanguage = programmingLanguage;
        this.linesOfCodeWritten = 0;
    }

    // 重写父类方法：程序员的工作方式
    @Override
    public void work() {
        System.out.println(name + " 正在使用 " + programmingLanguage + " 编写代码...");
    }

    // 重写薪资计算：程序员有项目奖金
    @Override
    public double calculateSalary() {
        double bonus = linesOfCodeWritten * 0.5; // 简单示例：每行代码0.5元奖金
        return baseSalary + bonus;
    }

    // 特有方法
    public void writeCode(int lines) {
        this.linesOfCodeWritten += lines;
        System.out.println(name + " 刚刚写了 " + lines + " 行代码。");
    }
}

// 3. 子类：经理 (继承自 Employee)
class Manager extends Employee {
    // 特有属性
    private int teamSize;      // 团队人数
    private double bonusRate;  // 管理奖金比例

    // 构造方法
    public Manager(String name, int age, String employeeId, double baseSalary, int teamSize) {
        super(name, age, employeeId, baseSalary);
        this.teamSize = teamSize;
        this.bonusRate = 0.2; // 默认奖金比例 20%
    }

    // 重写父类方法：经理的工作方式
    @Override
    public void work() {
        System.out.println(name + " 正在召开团队会议并分配任务...");
    }

    // 重写薪资计算：经理有管理津贴
    @Override
    public double calculateSalary() {
        return baseSalary + (baseSalary * bonusRate);
    }

    // 特有方法
    public void holdMeeting() {
        System.out.println(name + " 正在管理 " + teamSize + " 人的团队。");
    }
}

// 4. 测试主类
public class InheritanceExample {
    public static void main(String[] args) {
        System.out.println("=== 员工管理系统演示 ===\n");

        // 创建一个程序员对象
        Developer dev = new Developer("张三", 25, "D001", 10000, "Java");
        dev.work(); // 调用重写后的方法
        dev.writeCode(200);
        System.out.println("张三的总薪资: " + dev.calculateSalary());
        System.out.println("-------------------------");

        // 创建一个经理对象
        Manager mgr = new Manager("李四", 35, "M001", 20000, 10);
        mgr.work(); // 调用重写后的方法
        mgr.holdMeeting();
        System.out.println("李四的总薪资: " + mgr.calculateSalary());
        System.out.println("-------------------------");

        // 演示多态性：父类引用指向子类对象
        Employee emp = new Developer("王五", 28, "D002", 12000, "Python");
        emp.work(); // 虽然声明为Employee，但运行的是Developer的逻辑
    }
}