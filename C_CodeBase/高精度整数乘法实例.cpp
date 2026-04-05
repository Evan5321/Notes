#include <iostream>
#include <string>
#include <vector>
#include <map>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
using namespace std;

void mul(int op,vector<int> buf_a,vector<int> buf_b)
{
	int m,n;
	int i;
	map<int,vector<int> > ret;
	
	for(n=0;n<buf_b.size();n++)//乘数 
	{
		for(m=0;m<buf_a.size();m++)//被乘数 
		{
			ret[n].push_back(buf_b[n] * buf_a[m]);
		}
		
		for(i=0;i<buf_b.size()-n-1;i++)
		{
			ret[n].push_back(0);
		}
	}
	
	/*
	n代表乘数当前位数 
	12345*1201
	n    b.size()-n-1
	0     3
	
	1     2
	
	2     1
	
	3	  0	
	*/
	
	//-------------------------------------------
	map<int,vector<int> >::iterator it = ret.begin();
	int* result = new int[buf_a.size()+buf_b.size()];
	int nsize = buf_a.size()+buf_b.size();
	
	for(i=0;i<nsize;i++)
		result[i]=0;
	
	for(i=0;i<nsize;i++)
	{
		it = ret.begin();
		for(;it!=ret.end();it++)
		{
			int lastid = it->second.size()-1-i;
			
			if(lastid>=0)
				result[nsize-i-1]+=  it->second[lastid];
		}
	}
	
		
	it = ret.begin();
	//遍历ret里面所有相乘的积 
	for(;it!=ret.end();it++)
	{
		vector<int>::iterator ct = it->second.begin();
		cout<<it->first<<":";
		for(;ct!=it->second.end();ct++)
		{
			cout<<*ct<<",";
		}
		cout<<endl;
	}
	
	for(i=nsize-1;i>0;i--)
	{
		int zhi = result[i]%10;
		int jw = result[i]/10;
		result[i] = zhi;
		result[i-1]+=jw;
	}

	bool isfirst=true;
	
	if(op==-1)
		cout<<"-";
	
	for(i=0;i<nsize;i++){
		
		if(isfirst==true && result[i]==0)
			continue;
		else
			isfirst = false;
			
		cout<<result[i];
	}
}


int main(int argc, char** argv) {
	
	string a,b;
	
	cin>>a;
	cin>>b;
	
	int op = 1;
	
	if(a[0]!=b[0] && (a[0]=='-' || b[0]=='-') )
		op = -1;
	
	vector<int> buf_a,buf_b;
	int i;
	
	for(i=0;i<a.size();i++)
	{
		if(a[i]!='-')
		{
			buf_a.push_back(a[i]-'0');
		}
	}

	for(i=0;i<b.size();i++)
	{
		if(b[i]!='-')
		{
			buf_b.push_back(b[i]-'0');
		}
	}	
	
	if(buf_a.size()<buf_b.size())
	{
		mul(op,buf_b,buf_a);
	}
	else
	{
		mul(op,buf_a,buf_b);
	}
	
	system("pause");
	return 0;
}
