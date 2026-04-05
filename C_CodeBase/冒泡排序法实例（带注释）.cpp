#include <iostream>
using namespace std;

int main() {
    int arr[] = {22,55,64,23,66,142,5235,663,52,62};
    int len = sizeof(arr) / sizeof(arr[0]); // 数组长度

    // 冒泡排序（标准）
    for (int i = 0; i < len - 1; i++) {          // 外层：轮数
        for (int j = 0; j < len - 1 - i; j++) {   // 内层：相邻比较
            if (arr[j] > arr[j + 1]) {
                // 交换
                int temp = arr[j];
                arr[j] = arr[j + 1];
                arr[j + 1] = temp;
            }
        }
    }

    // 排序完成后，统一输出
    for (int i = 0; i < len; i++) {
        cout << arr[i] << "\t";
    }

    getchar();
    return 0;
}