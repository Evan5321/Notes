#include <bits/stdc++.h>
using namespace std;

int main()
{
	int a[10] = {0,0,0,0,0,0,0,0,0,0};
	int *ap = a;
	int tmp;
	cin>>a[0]>>a[1]>>a[2]>>a[3]>>a[4]>>a[5]>>a[6]>>a[7]>>a[8]>>a[9];
	for (int j = 0;j<9;j++)
	{
		for (int x = j+1;x<10;x++)
		{
			if (a[j]<a[x])
			{
				tmp = a[j];
				a[j] = a[x];
				a[x] = tmp;
			}
		}
			
		
	}
	for (int i = 0;i<10;i++)
	{
		cout<<*ap<<',';
		*ap++;
	}
	return 0;
}
