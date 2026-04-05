#include <iostream>
#include <string>
#include <vector>
#include <string.h>
#include <math.h>
using namespace std;
int bb[101];
int cc[101]={0};//标记 

void comput_1A()
{
	int buf[1000];
	buf[0] = 1;
	buf[1] = 1;
	buf[2] = 2;
	
	int n;
	cin>>n;
	int i;
	
	for(i=3;i<n;i++){	
		buf[i] = buf[i-1]+buf[i-2]+buf[i-3];
	}
	
	cout<<buf[n-1]<<endl;
}

int digui(int n){
	
	if(n==0 || n==1)
		return 1;
	else if(n==2)
		return 2;
	
	return digui(n-1)+digui(n-2)+digui(n-3);
	
}

void comput_1B(){
	int n;
	cin>>n;
	
	cout<<digui(n);
}




void cpl(string s,int n){
	int i;
	for(i=0;i<s.size();i++){//每种排列第i个字符开关 
		if(cc[i]==0){
			bb[n]=i;//用了下标是i的字符的索引 
			cc[i]=1;//i已经使用过了 
			cpl(s,n+1);//求下一位字符 
			cc[i]=0;//i取消使用状态 
		}
	}
		
	if(n==s.size()-1){
		for(i=0;i<s.size();i++){
			cout<<s[bb[i]];
		}
		cout<<endl;
	}
	
}

void comput_A2(){
	string s; 
	cin>>s;
	
	cpl(s,0);
}

void comput_A3(){
	//+ 20 * 300 2.15
	vector<char> op;
	vector<float> num;
	char cc[100];
	while(1){
		cin>>cc;
		
		if(cc[0]=='+' || cc[0]=='-' || cc[0]=='*' || cc[0]=='/')
			op.push_back(cc[0]);
		else if(cc[0]=='@')
			break;
		else
			num.push_back(atof(cc));
	}
	
	int i;
	float ret=0;
	float aa,bb;
	int idx = num.size()-1;
	for(i=op.size()-1;i>=0;i--)
	{
		if(i==op.size()-1){
			aa = num[idx--];
			bb = num[idx--];
		}
		else
		{
			aa=ret;
			bb=num[idx--];
		}
		
		switch(op[i])
		{
			case '+':
				ret = aa+bb;
				break;
			case '-':
				ret = aa-bb;
				break;
			case '*':
				ret = aa*bb;
				break;
			case '/':
				ret = aa/bb;
				break;
		}
	}
	cout<<ret<<endl;
}

void comput_A4()
{
	string s;
	cin>>s;
	
	int n;
	int ret=0;
	for(n=0;n<s.size();n++){
		
		if(s[n]=='('){
			ret+=1;
		}
		else if(s[n]==')'){
			ret-=1;
		}
		
		if(ret<0){
			cout<<"error"<<endl;
			break;
		}
	}
	
	if(ret==0){
		cout<<"ok"<<endl;
	}
	else if(ret>0)
		cout<<"error"<<endl; 
}

int digui2(int m,int n,int x,int y){
	
	if(x==0 && y==n-2)
		return 1;
	else if(y==n-1 && x==1)
		return 1;
	else if(x==0 && y==n-1)
		return 0;
	
	int left =0;
	int down =0;
	
	if(x>0){
		left = digui2(m,n,x-1,y);
	}
	
	if(y<n-1){
		down = digui2(m,n,x,y+1);
	}
	
	return left+down;
}

void comput_A5()
{
	int m,n;
	cin>>m>>n;
	
	cout<<digui2(m,n,(m-1),0)<<endl;
}

int main(int argc, char** argv) {
	
	
	
	return 0;
}
