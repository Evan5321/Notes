#include<bits/stdc++.h>
using namespace std;

int move(int num,char a,char b,char c)
{
	if(num==1){
		cout<<num<<' '<<a<<">>"<<c<<endl;
		return 1;
	}
	else{
		move(num-1,a,c,b);
		cout<<num<<' '<<a<<">>"<<c<<endl;
		move(num-1,b,a,c);
		}
}
int main()
{
	int num;

	cin>>num;
	char a = 'a',b ='b',c = 'c';

	move(num,a,b,c);



	return 1;

}
