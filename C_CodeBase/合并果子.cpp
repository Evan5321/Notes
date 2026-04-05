#include <iostream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <fstream>

using namespace std;

void sort(vector<int>& buf){
	int i,j,T;
	
	for(i=0;i<buf.size();i++){
		for(j=i+1;j<buf.size();j++){
			if(buf[i]>buf[j]){
				T = buf[i];
				buf[i] = buf[j];
				buf[j] = T;
			}
		}
	}
}

int main(int argc, char** argv) {
	
	freopen("fruit.in","r",stdin);
	freopen("fruit.out","w",stdout);
	
	int i,T,num;
	vector<int> buf;
	
	cin>>num;
	for(i=0;i<num;i++){
		cin>>T;
		buf.push_back(T);
	}
	
	sort(buf);
	int ret=0;
	
	ret = buf[0] + buf[1];
	buf[0] = buf[0]+buf[1];
	buf.erase(buf.begin()+1);
	
	while(buf.size()>1){
		sort(buf);
		buf[0] = buf[0]+buf[1];
		ret += buf[0];
		buf.erase(buf.begin()+1);
	}
	cout<<ret<<endl;

	fclose(stdin);
	fclose(stdout);
	return 0;
}
