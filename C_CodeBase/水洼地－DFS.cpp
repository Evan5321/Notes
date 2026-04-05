#include <iostream>
#include <string.h>
using namespace std;

int dfs(const char map[10][10],int buf[10][10],int y,int x){
	
	//左右上下，左上，右上，右下，左下 
	int xx[] = {-1,1,0,0,-1,1,1,-1};
	int yy[] = {0,0,-1,1,-1,-1,1,1};
	
	int i;
	
	buf[y][x]=1;
	
	for(i=0;i<8;i++)
	{
		int sx = x+xx[i];
		int sy = y+yy[i];
		
		if(sx<0 || sx>9 || sy<0 || sy>9)
			continue;
			
		if(buf[sy][sx]==1)
			continue;
		
		if(map[sy][sx]=='W')
			dfs(map,buf,sy,sx);	
	} 
	
	return 1;
}


int main(int argc, char** argv) {
	
	const char map[10][10] = { {' ',' ','W',' ',' ',' ',' ',' ',' ',' '},
							   {' ',' ','W',' ',' ',' ',' ',' ',' ',' '},
							   {' ','W','W','W',' ',' ',' ','W','W',' '},
							   {' ','W','W',' ',' ',' ',' ',' ','W','W'},
							   {' ',' ',' ',' ',' ',' ',' ',' ','W',' '},
							   {' ',' ',' ',' ',' ',' ',' ','W',' ','W'},
							   {' ',' ',' ',' ',' ',' ',' ',' ',' ',' '},
							   {' ',' ','W','W','W',' ',' ',' ',' ',' '},
							   {' ',' ','W',' ',' ',' ',' ','W','W',' '},
							   {' ','W',' ','W',' ',' ',' ','W',' ','W'},	
							};
							
	int buf[10][10];
	memset(buf,0,sizeof(buf));
	
	int y,x;
	int num = 0;
	for(y=0;y<10;y++){
		for(x=0;x<10;x++)
		{
			if(map[y][x]=='W' && buf[y][x]==0)
			{
				num += dfs(map,buf,y,x);
			}
		}
	}
	
	cout<<num<<endl;
	return 0;
}
