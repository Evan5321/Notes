#include <iostream>
#include <vector>
/* run this program using the console pauser or add your own getch, system("pause") or input loop */
using namespace std;
int main(int argc, char** argv) {
	
	string a;
	cin>>a;
	int i;
	vector<int> buf;
	
	for(i=0;i<a.size();i++){
		
		buf.push_back(a[i]-'0');	
		
	}
	
	i=2;
	int c;
	int ys=0;
	vector<int> ret,buf1;
	
	while(1)
	{
		ret.erase(ret.begin(),ret.end());
		buf1 = buf;
		ys=0;
		//遍历大整数每一位 
		for(c=0;c<buf1.size();c++){
			
			buf1[c] += ys*10;
			
			if(buf1[c]<i){
				ys = buf1[c];
				ret.push_back(0);
			}
			else{
				
				ret.push_back(buf1[c] / i);
				ys = buf1[c]%i;
			}			
		}		
		if(ys==0){
			cout<<i<<endl;
			break;
		}
		
		i+=1;
	}
	
	bool isfirst=true;
	for(i=0;i<ret.size();i++)
	{
		if(ret[i]==0 && isfirst==true)
			continue;
		else
			isfirst = false;
		cout<<ret[i];
	}
	
	return 0;
}
