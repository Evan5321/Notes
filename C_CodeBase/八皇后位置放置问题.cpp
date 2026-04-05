#include<bits/stdc++.h>
using namespace std;

int main(){

    /*
    0,1,2,3,4,5,6,7,8
    1 x
    2 x
    3 x
    4 x
    5 x
    6 x
    7 x
    8 x
    */



    int x,y,num=0;

    for(y=0;y<8;y++){
        for(x=0;x<8;x++){
            num++;
            cout<<y<<' '<<x<<' '<<' '<<num<<endl;
        }
    }
    cout<<num<<endl;

    return 1;
}
