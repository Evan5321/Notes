#include <iostream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <fstream>
#include <map>
#include <math.h>

using namespace std;

int comput_w(int num){
	int ret = 0;
	
	while(num!=0){
		ret+=1;
		num/=10;
	}
	return ret;
}

void comput_num(int w,int& min,int& max){
	min = pow(10,w-1); 
	max = pow(10,w)-1;
}

int main(int argc, char** argv) {
	
	map<int,int> gz;
	int num,k,i;
	
	for(i=0;i<9;i++)
		gz[i] = -1;
	
	cin>>num;
	cin>>k;
	
	for(i=0;i<k;i++){
		int a,b;
		cin>>a>>b;
		gz[a] = b;
	}
	
	int num_w = comput_w(num);
	
	int min_n,max_n;
	comput_num(num_w,min_n,max_n);
	
	int total=0;
	for(;min_n<=max_n;min_n++){
		
		if(num == min_n){
			total+=1;
		}
		else{
			int m;
			int T0 = num;
			int T1 = min_n;
			bool isChange = true;
			for(m=0;m<num_w;m++){
				
				int y0 = T0%10;
				int y1 = T1%10;
				
				if(y0!=y1 && gz[y0]!=y1){
					isChange=false;
					break;
				}
				
				T0 /=10;
				T1 /=10;
				
			}
			
			if(isChange==true){
				total+=1;
			}
		}
	}
	cout<<total<<endl;
	return 0;
}
