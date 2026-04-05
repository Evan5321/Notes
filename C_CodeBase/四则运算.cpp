#include <iostream>
#include <vector>
#include <string>
#include <stdlib.h>

using namespace std;

int get_level(vector<int> level){
	int i;
	int cid = -1;
	int max_level = -1;
	
	for(i=0;i<level.size();i++){
		if(level[i]>max_level){
			cid = i;
			max_level = level[i];
		}
	}
	
	return cid;
}

int main(int argc, char** argv) {
	
	vector<char> op;
	vector<int> num;
	vector<int> level;
	
	string ch;
	int c_level = 0;
	cin>>ch;
	
	while(ch!="#"){
		
		if(ch=="+" || ch=="-"){
			op.push_back(ch[0]);
			level.push_back(1+c_level);
		}
		else if(ch=="*" || ch=="/"){
			op.push_back(ch[0]);
			level.push_back(2+c_level);
		}
		else if(ch=="("){
			c_level+=100;
		}
		else if(ch==")"){
			c_level-=100;
		}
		else{
			num.push_back(atoi(ch.c_str()));
		}
		cin>>ch;
	}
	//========================
	int nid = get_level(level);
	
	while(nid!=-1){
		switch(op[nid]){
			case '+':
				num[nid] += num[nid+1];
				break;
			case '-':
				num[nid] -= num[nid+1];
				break;
			case '*':
				num[nid] *= num[nid+1];
				break;
			case '/':
				num[nid] /= num[nid+1];
				break;
		}
		op.erase(op.begin()+nid);
		num.erase(num.begin()+nid+1);
		level.erase(level.begin()+nid);
		
		nid = get_level(level);
	}
	cout<<num[0]<<endl;
	return 0;
}
