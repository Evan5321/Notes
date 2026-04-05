#include <iostream>
#include <string>
#include <map>
using namespace std;

void sample_01()
{
	string s;
	cin>>s;
	int a,b,c;
	for(a=0;a<3;a++){
		for(b=0;b<3;b++){
			for(c=0;c<3;c++){
				
				if(a!=b && b!=c && a!=c){
					cout<<s[a]<<s[b]<<s[c]<<endl;
				}
			}
		}
	}
}

int comput_tj(int num)
{
	if(num==1)
		return 1;
	else if(num==2)
		return 2;
	else if(num==3)
		return 4;
	else if(num<1)
		return 0;
		
	int ret = comput_tj(num-1) + comput_tj(num-2)+comput_tj(num-3);
	
	return ret; 
}

void sample_02()
{
	int num;
	cin>>num;
	
	cout<<comput_tj(num)<<endl;
}

int main(int argc, char** argv) {
	/*
	char room[5][5] = {
						{ '~','~','~','~','#'},
						{ '~','@','~','~','~'},
						{ '~','~','~','~','~'},
						{ '#','#','#','~','~'},
						{ '~','~','~','~','~'},
				      };
	*/
	
	int n;
	cin>>n;
	
	char* room = new room[n*n];
	
	for(n=0;n<5;n++){
		
		cin>>room[n*5+0]>>room[n*5+1]>>room[n*5+2]>>room[n*5+3]>>room[n*5+4];
	} 
	
	
	int day;
	cin>>day;
	
	int n,i,j;
	for(n=0;n<day;n++)
	{
		map<int,int> check;
		
		for(i=0;i<5;i++){
			for(j=0;j<5;j++){
				
				if(room[i*5+j]=='@' && check[i]!=j){
					//up
					if(i-1>=0){
						if(room[(i-1)*5+j]=='~'){
							room[(i-1)*5+j] = '@';
							check[i-1] = j;
						}						
					}
					
					//down
					if(i+1<5){
						if(room[i+1][j]=='~'){
							room[i+1][j] = '@';
							check[i+1] = j;
						}						
					}
					
					//left
					if(j-1>=0){
						if(room[i][j-1]=='~'){
							room[i][j-1] = '@';
							check[i] = j-1;
						}						
					}
					
					//right
					if(j+1<5){
						if(room[i][j+1]=='~'){
							room[i][j+1] = '@';
							check[i] = j+1;
						}						
					}
					
				}
			}
		}
	}
	
	for(i=0;i<5;i++){
		for(j=0;j<5;j++){
			cout<<room[i][j];
		}
		cout<<endl;
	}
	
	
	
	return 0;
}
