#include <iostream>
using namespace std;
 

int *sort(int apple[], int n){
     int d, i, j, tmp;
     for(d = n/2;d >= 1;d = d/2){
        for(i = d; i < n;i++){
            tmp = apple[i];
            for(j = i - d;(j >= 0) && (apple[j] > tmp);j = j-d){
                apple[j + d] = apple[j];
            }
            apple[j + d] = tmp;
       }
    }
    return apple;
}

int main(int argc, char** argv) {
	
	int apple[10] = {55455,33,3,32323,5534,54331,5434,243,455343,645};
	
	int *get_apple;
	
	get_apple = sort(apple,10);
	
	
	for(int i=0;i<10;i++)
	{
		cout<<get_apple[i]<<',';
	}
	
			
}
