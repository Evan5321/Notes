/*TODO:
1 编写模板及函数 T add(T x,T y),并调用
2 编写模板及函数 auto minus(P a,S b),并调用 
*/

#include <bits/stdc++.h>

using namespace std; 

template <typename T>
T add(T x,T y){
	return (x + y);
}

template <typename X,typename Y>
X add_different(X a,Y b){
	return (a + b);
}

int main(){
	
	cout<< add(1,2) <<endl;
	cout<< add(1.7,2.2)<<endl;
	cout<< add_different(1.7,1)<<endl;
	getchar();
	return 0;
}
