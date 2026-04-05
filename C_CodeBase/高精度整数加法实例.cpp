#include <iostream>
#include <string>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
using namespace std;

void add_child(int* buf_a,int a_len,int op_a,int* buf_b,int b_len,int op_b)
{
	//----------两个数进行运算－－－－－－－－－ 
	int* ret = new int[a_len+1];
	int i;
	for(i=0;i<a_len+1;i++)
		ret[i] = 0;
	
	int m=a_len-1,n=b_len-1;
	int c=a_len;
	
	for(;m>=0;m--)
	{
		if(n>=0){
			if(op_a==op_b)
				ret[c] = buf_a[m] + buf_b[n];
			else
				ret[c] = buf_a[m] - buf_b[n];
		}
		else
		{
			ret[c] = buf_a[m];
		}
		c--;
		n--;
	}
	/*
	12345
	  789
	0,1,2,11,13,14
	  1	3	1  3	4
				
	
	*/ 

	
	//--------整理相加的和--------
	int he,jw;
	for(i=a_len;i>0;i--)
	{
		if(ret[i]>=0)
		{
			he = ret[i] % 10;
			jw = ret[i] / 10;
		
			ret[i] = he;
			ret[i-1] += jw;
		}
		else
		{//负值借位计算 
			he = ret[i] + 10;
			jw = 1;
			
			ret[i] = he;
			ret[i-1]-=jw;
		}
	}
	
	
	bool isfirst=true;
	for(i=0;i<a_len+1;i++)
	{
		if(isfirst==true && ret[i]==0)
			continue;
		else
			isfirst=false;
			
		cout<<ret[i];
	}
	
}

//--------------------------------------
void add(string a,string b)
{
	//------抽取符号 
	int a_len = a.size();
	int b_len = b.size();
	
	int op_a=1,op_b=1;
	
	if(a[0]=='-')
	{
		op_a = -1;
		a_len-=1;
	}
	
	if(b[0]=='-')
	{
		op_b = -1;
		b_len-=1;
	}
	
	//--------把绝对值存数组-------------
	int* buf_a = new int[a_len];
	int* buf_b = new int[b_len];
	
	int i;
	int c=0;
	for(i=0;i<a.size();i++)
	{
		if(a[i]!='-'){
			buf_a[c] = a[i]-'0';
			c++;
		}
	}
	c=0;
	for(i=0;i<b.size();i++)
	{
		if(b[i]!='-'){
			buf_b[c] = b[i]-'0';
			c++;
		}
	}
	//--------比较大小--------------
	if(a_len>b_len){
		add_child(buf_a,a_len,op_a,buf_b,b_len,op_b);
	}
	else if(a_len<b_len){
		add_child(buf_b,b_len,op_b,buf_a,a_len,op_a);
	}
	else
	{
		int a_is_big = 0;
		
		for(i=0;i<a_len;i++)
		{
			if(buf_a[i]>buf_b[i])
			{
				a_is_big = 1;
				break;
			}
			else if(buf_a[i]<buf_b[i])
			{
				a_is_big = -1;
				break;
			}
		}
		
		if(a_is_big==1)
			add_child(buf_a,a_len,op_a,buf_b,b_len,op_b);
		else
			add_child(buf_b,b_len,op_b,buf_a,a_len,op_a);
	}


	//------------------------------------
}
//====================================
int main(int argc, char** argv) {
	
	string a,b;
		
	cin>>a;
	cin>>b;
	
	add(a,b);
	
	return 0;
}
