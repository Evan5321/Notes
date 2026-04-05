#include <iostream>
#include <string>
#include <string.h>
using namespace std;



int dfs(const string map[4][7],int buf[4][7],int x,int y){
	
	buf[y][x] = 1;
	int sx,sy;
	int i;
	int nsize=1;
	
	int xx[] = {-1,0,1,0};
	int yy[] = {0,-1,0,1};
	
	for(i=0;i<4;i++){
		if(map[y][x][i]=='0'){
			sy=y+yy[i];
			sx=x+xx[i];
			
			if(sy<0 || sy>3 || sx<0 || sx>6)
				continue;
			
			if(buf[sy][sx]==0)
				nsize += dfs(map,buf,sx,sy);
		}
	
	}
	return nsize;
}

int main(int argc, char** argv) {
	
	const string map[4][7] = {{"0001","0010","1001","0010","1010","1000","0000"}, 
							  {"0110","1001","0110","1011","1010","1001","0001"},
							  {"0000","0101","0011","1111","1000","0100","0100"},
							  {"0010","1100","0100","0100","0000","0000","0000"},
						   };
	int buf[4][7];
	memset(buf,0,sizeof(buf));
	
	int x,y;
	int num=0;
	int max_room = 0;
	
	for(y=0;y<4;y++){
		for(x=0;x<7;x++){
			if(buf[y][x]==0){
				int tsize = dfs(map,buf,x,y);
				if(tsize>max_room)
					max_room = tsize;
				num+=1;
			}
		}
	}
	cout<<num<<","<<max_room<<endl;
	return 0;
}













