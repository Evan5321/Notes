#include <iostream>

using namespace std;

int main()
{
    int student[5][4] = {{1,100,89,80},{2,99,70,88},{3,90,91,89},{4,99,100,70},{5,95,60,99}};
    int n,m;
    int tmp;

    for(n=0;n<5;n++)
    {
        for(m=0;m<5;m++)
        {
            int t1 = student[n][1]+student[n][2]+student[n][3];
            int t2 = student[m][1]+student[m][2]+student[m][3];

            if(t1<t2)
            {
                int i;

                for(i=0;i<4;i++)
                {
                    tmp = student[n][i];
                    student[n][i] = student[m][i];
                    student[m][i] = tmp;
                }
            }
        }
    }

    for(n=0;n<5;n++)
    {
        for(m=0;m<4;m++)
        {
            cout<<student[n][m]<<"\t";
        }
        cout<<endl;
    }


    return 0;
}
