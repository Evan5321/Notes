/*TODO：
1 使用冒泡排序法排列已知数组
*/ 

#include <bits/stdc++.h>

using namespace std; 

int main(){
	
	int buf[10] = {22,43,11,65,45,90,26,61,77,31};
	
	for(int i = 0;i<10-1;i++){
		
		for(int j = 0;j<10-1-i;j++){
			
			if(buf[j]>buf[j+1]){
				int tmp;
				tmp = buf[j];
				buf[j] = buf[j+1];
				buf[j+1] = tmp;
			}
		}
	}
	
	for(int x = 0;x<10;x++){
		
		cout<< buf[x] <<' ';
		
	}
	cout<<endl;
	getchar();
}
