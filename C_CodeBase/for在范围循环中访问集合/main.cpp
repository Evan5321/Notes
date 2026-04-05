/*TODO
1 使用for循环访问集合（vector）
2 使用for循环对集合内的值进行操作
*/
#include <bits/stdc++.h>

using namespace std;

int main(){

  vector<int> s={1,2,3,4,5,6};
  for(auto i:s){
    cout<<i<<' ';//遍历输出s里的值
  }

  for(auto& i:s){
    i= 2*i;//对从s里取出的的值翻倍计算
    cout<<i<<' ';
  }

   getchar();
  return 0;

}
