#include <iostream>
#include <vector>
#include <map>
#include <string>
using namespace std;
/* run this program using the console pauser or add your own getch, system("pause") or input loop */

int main(int argc, char** argv)
{
	vector<int>  buf1;
	buf1.push_back(10);
	buf1.push_back(300);
	buf1.push_back(30);

	cout<<buf1.size()<<","<<buf1[1]<<endl;

	vector<int>::iterator it = buf1.begin();

	for(;it!=buf1.end();it++)
	{
		cout<<*it<<",";
	}
	//----------------------------------
	map<string,int> buf2;
	buf2["zs"] = 10;
	buf2["ls"] = 12;
	buf2["ww"] = 13;

	cout<<endl<<buf2.size()<<","<<buf2["zs"]<<endl;

	map<string,int>::iterator pt = buf2.begin();
	for(;pt!=buf2.end();pt++)
	{
		cout<<pt->first<<","<<pt->second<<endl;
	}

	return 0;
}
