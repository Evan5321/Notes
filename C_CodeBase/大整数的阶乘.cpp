#include <iostream>
using namespace std;
/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int main(int argc, char** argv) {
	
	int n;
	int i;
	int s[10000];
	cin>>n;
	
	for(i=0;i<10000;i++)
		s[i]=0;
	
	s[0] = 1;
	
	//阶乘从1开始 
	for(i=1;i<=n;i++){
		
		int c;
		//数组每一位去乘以i 
		for(c=0;c<10000;c++){
			
			s[c] *= i;	
		}
		
		//每一位进行进位的处理 
		for(c=0;c<10000;c++){
			int jw = s[c] /10;
			int zhi = s[c]%10;
			
			s[c] = zhi;
			s[c+1] += jw;
		}
	}	
	
	bool isfirst=true;
	for(i=9999;i>=0;i--)
	{
		if(isfirst==true && s[i]==0)
			continue;
		else
			isfirst = false;
			
		cout<<s[i];
	}
	cout<<endl;
		
	return 0;
}
