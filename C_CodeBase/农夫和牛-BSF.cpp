#include <iostream>
#include <string.h>

using namespace std;

//获取农夫所在位置的数组索引值 
int get_fid(int x,int farmer[10000][2]){
	int i;
	
	for(i=0;i<10000;i++){
		if(farmer[i][0]==x)
			return i;
	}
	return -1;
}

int main(int argc, char** argv) {
	
	//农夫和牛,BSF算法 
	int N,K;
	cin>>N>>K;
	
	bool road[10000];//位置是否走过 
	int farmer[10000][2]; //[][0]位置，[][1]时间,
	memset(road,false,sizeof(road)); 
	memset(farmer,0,sizeof(farmer));
	
	int head=0,tail=0;
	
	road[N] = true;
	farmer[head][0] = N;//初始位置 
	farmer[head][1] = 0;//初始时间 
	
	int i;
	do{	
		int x,j;
		
		for(j=0;j<3;j++){
			x = farmer[head][0];
			if(j==0)
				x-=1;
			else if(j==1)
				x+=1;
			else
				x*=2;
		
			if(x<0 || x>9999)
				continue;
			
			int fid = get_fid(x,farmer);
			
			if(road[x]==false){	//如果该位置没走过 
				road[x] = true;
				tail++;	
				farmer[tail][0] = x;
				farmer[tail][1] = farmer[head][1] + 1;
			}
			else if( road[x]==true && farmer[fid][1]>farmer[head][1]+1)//如果该位置已经走过 
			{
				farmer[fid][1] = farmer[head][1] + 1;

			}
		}	
		head++;
	}while(head<tail);//当head大于tail值时退出。即超出现有数据范围 
	//------------------
	//查找位置对应K值的数值 ，输出其时间 
	for(i=0;i<10000;i++){
		if(farmer[i][0]==K)
			cout<<farmer[i][1]<<endl;
	}
	
	
	return 0;
}
