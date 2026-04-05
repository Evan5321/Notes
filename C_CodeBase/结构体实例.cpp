#include <iostream>
#include <string>
#include <string.h>
using namespace std;

struct stu
{
    string name;
    float yw;
    float sx;
};

union s2
{
    int num;
    char code;//unsinged short int
};

enum color
{
    red=10,yellow,blue,green
};

struct teacher_style
{
    char km[8];
    int grade;
    int cclass;
};

struct student_style
{
    int grade;
    int cclass;
    float yw,sx,yy;
};

union c_style
{
    teacher_style  s1;
    student_style  s2;
    char s3[18];
};

struct people
{
    string name;
    int age;
    int sex;

    c_style  cc;
};

int main()
{
    cout<<sizeof(stu)<<endl;

    stu aaa[50];
    aaa[0].name="zhangshan";
    aaa[0].yw = 100;
    aaa[0].sx = 90;

    cout<<aaa[0].name<<endl;

    s2 bbb;
    bbb.code='A';
    cout<<bbb.num<<endl;

    enum color vv;
    vv = blue;

    cout<<vv<<endl;

    people a1;

    a1.name = "aaa";
    strcpy(a1.cc.s1.km ,"yw");
    a1.cc.s1.grade=2;
    a1.cc.s1.cclass=5;

    return 0;
}
