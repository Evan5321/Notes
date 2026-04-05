#include <iostream>
using namespace std;

int main(int argc, char** argv) {
	
	int num;
	cin>>num;
	
	int* buf = new int[num];
	int i,j;
	
	for(i=0;i<num;i++){
		cin>>buf[i];
	}
	
	int max_len = 0;
	int sum;
	for(i=0;i<num;i++){
		for(j=i+1;j<num;j++){
			sum=0;
			if(buf[i]<buf[j]){
				sum+=2;
				int c=j;
				int d=j+1;
				
				for(;d<num;d++){
					if(buf[c]<buf[d]){
						sum+=1;
						c=d;
					}
				}
			}
			if(sum>max_len)
				max_len = sum;			
		}
	}
	cout<<max_len<<endl;
	return 0;
}
