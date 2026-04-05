# JavaCodeBase

## 1. [String] 删去字符串中的某个字符

**法1：使用replace()方法**
```Java
import java.util.Scanner;

public class StringUtil{
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String input = scanner.nextLine();
    
        String result = input.replace(" ", "");
        System.out.println(result);
        scanner.close();
    }   
}
```

**法2：使用for循环检查字符串**
```Java
import java.util.Scanner;  
public class StringUtil {  
    public static void main(String[] args) {  
        Scanner in =new Scanner(System.in);  
        //获取String值  
        String a=in.nextLine();  
        StringBuilder stringBuilder = new StringBuilder(a);  
        for (int i = 0; i < stringBuilder.length(); i++) {  
            if (stringBuilder.charAt(i)==' ') {  
                stringBuilder.deleteCharAt(i);  
                i--;  
            }  
        }  
        System.out.println(stringBuilder.toString());  
    }  
}  
```

## 2. [String]比较字符串是否一致
**法1:使用equal()方法**
```Java
import java.util.Scanner;

public class ContrastString2 {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String a = scanner.nextLine();
        String b = scanner.nextLine();
        if(a.equals(b)){
            System.out.println("相同");
        }else{
            System.out.println("不相同");
        }
        scanner.close();
    }
}

```

**法2:使用for循环比较字符串的每一位**
```Java
import java.util.Scanner;
public class ContrastString {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        String a = scanner.nextLine();
        String b = scanner.nextLine();
        boolean isSame = true;
        if (a.length() != b.length()){
            isSame = false;
        }else{
            for(int i=0;i<a.length();i++){
                if (a.charAt(i)!= b.charAt(i)) {
                    isSame = false;
                    break;                    
                }
            }
        }
        if(isSame){
            System.out.println("相同");
        }else{
            System.out.println("不相同");
        }
        scanner.close();
    }
}
```

## 3. [Arrays]Arrays类常用方法

| 方法签名 | 功能描述 | 代码示例 |
| :--- | :--- | :--- |
| `<T> List<T> asList(T... a)` | 将指定的数组转换为固定长度的 `List` 集合 | `List<String> list = Arrays.asList("A", "B", "C");` |
| `void sort(Object[] a)` | 对指定的对象数组按照升序进行排列 | `Arrays.sort(arr);` |
| `void fill(Object[] a, Object val)` | 将指定对象引用赋值给指定数组的所有元素 | `Arrays.fill(arr, "DefaultValue");` |
| `boolean equals(Object[] a, Object[] a2)` | 如果两个指定数组彼此相等，则返回 `true` | `boolean isSame = Arrays.equals(arr1, arr2);` |
| `int binarySearch(Object[] a, Object key)` | 使用二分搜索法对已排序的数组进行搜索 | `int index = Arrays.binarySearch(arr, "Key");` |

>补充说明
> - 关于 asList：返回的 List 是由原数组 backed（支持）的，这意味着修改 List 中的元素会同步修改原数组，且该 List 的长度是固定的，不能进行 add 或 remove 操作。
> - 关于 sort：对于对象数组，它使用的是经过优化的归并排序（或 TimSort），保证了排序的稳定性。
> - 关于 binarySearch：在使用此方法之前，必须先对数组进行排序（调用 sort()），否则结果是不确定的。如果找不到元素，它通常返回一个负数。

## 4. [StringBuilder]StringBuilder类常用方法
| 方法名 | 功能描述 | 代码示例 |
| :--- | :--- | :--- |
| `append()` | 追加：在末尾添加内容 | `sb.append("Java")` |
| `insert()` | 插入：在指定位置插入内容 | `sb.insert(0, "Hello ")` |
| `delete()` | 删除：删除指定范围的字符 | `sb.delete(0, 1)` |
| `replace()` | 替换：替换指定范围的字符 | `sb.replace(0, 5, "World")` |
| `reverse()` | 反转：将字符串倒序 | `sb.reverse()` |
| `toString()` | 转换：变回普通的 String | `String s = sb.toString()` |
| `length()` | 长度：获取字符个数 | `int len = sb.length()` |<websource>source_group_web_6</websource>|

样例:
```Java 
public class StringBuilderDemo {
    public static void main(String[] args) {
        // 1. 创建 StringBuilder 对象
        // 可以传入初始字符串，也可以 new StringBuilder() 创建空的
        StringBuilder sb = new StringBuilder("Hello");

        // 2. append() - 追加内容 (最常用)
        sb.append(" World"); 
        sb.append("!");
        // 当前内容: "Hello World!"

        // 3. insert() - 插入内容
        // 在索引 5 的位置（即 "Hello" 后面）插入逗号
        sb.insert(5, ",");
        // 当前内容: "Hello, World!"

        // 4. replace() - 替换内容
        // 将索引 0 到 5 的内容（"Hello,"）替换为 "Hi"
        sb.replace(0, 6, "Hi");
        // 当前内容: "Hi World!"

        // 5. delete() - 删除内容
        // 删除索引 2 到 4 的内容（" Wo"）
        sb.delete(2, 5);
        // 当前内容: "Hild!"

        // 6. reverse() - 反转字符串
        sb.reverse();
        // 当前内容: "!dliH"

        // 7. length() - 获取长度
        System.out.println("当前长度: " + sb.length()); 

        // 8. toString() - 转换为 String
        // 当需要把结果赋值给 String 变量时，必须调用此方法
        String result = sb.toString();
        
        System.out.println("最终结果: " + result);
    }
}
```
