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
