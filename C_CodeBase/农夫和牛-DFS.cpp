#include <iostream>
#include <string.h>
using namespace std;

//PN为上级位置，N为当前位置，K为终点 
void dfs(bool road[],int farmer[],int PN,int N,int K){
	
	if(N<0 || N>9999)//越界退出 
		return;
		
	//当前位置没有走过 
	if(road[N]==false){
		road[N] = true;
		if(PN==-1)
			farmer[N] = 0;
		else
			farmer[N] = farmer[PN]+1;
		
	}//当前位置走过了 
	else if(road[N]==true){
		if(farmer[N]>farmer[PN]+1){
		
			farmer[N] = farmer[PN]+1;
		}
		else
			return;
	}
	
	int i;
	for(i=0;i<3;i++){
		int x = N;
		
		if(i==0)
			x-=1;
		else if(i==1)
			x+=1;
		else
			x*=2;
			
		dfs(road,farmer,N,x,K);
			
	}
}

int main(int argc, char** argv) {
	
	//农夫和牛,DFS算法 
	int N,K;
	cin>>N>>K;
	
	bool road[10000];//位置是否走过 
	int farmer[10000]; //位置所需时间,
	memset(road,false,sizeof(road)); 
	memset(farmer,0,sizeof(farmer));
	
	dfs(road,farmer,-1,N,K);

	cout<<farmer[K]<<endl;
	return 0;
}
