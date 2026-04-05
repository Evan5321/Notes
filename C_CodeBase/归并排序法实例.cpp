#include <iostream>
#include <stdlib.h>
#include <fstream>
#include <string.h>
using namespace std;
/*
归并法排序
（１）随机生成１０００个整数，存入文件db.txt
（２）每次只能对１００个数据排序 

*/

void sort(int buf[],int id)
{
	int i,j,t;
	
	for(i=0;i<100;i++)
	{
		for(j=i+1;j<100;j++)
		{
			if(buf[i]<buf[j])
			{
				t = buf[i];buf[i]=buf[j];buf[j]=t;
			}
		}
	}
	
	char fname[10];
	sprintf(fname,"db%d.txt",id);
	
	ofstream out_file;
	out_file.open(fname,ios::trunc);
	
	for(t=0;t<100;t++)
		out_file<<buf[t]<<endl;
	out_file.close();
}
//----------------------------------
void sort_child(char* fname1,char* fname2,int id)
{
	ifstream if1,if2;
	ofstream of1;
	char fname[10];
	
	sprintf(fname,"db2%d",id);
	
	if1.open(fname1);
	if2.open(fname2);
	of1.open(fname,ios::trunc);
	
	int n;
	int a=0,b=0;
	int isa=true,isb=true;
	int v1,v2;
	for(n=0;n<200;n++)
	{
		if(a<=100 && isa==true)
		{
			a+=1;
			 
			if(a>100)
				break;
				
			if1>>v1;	
		}
		
		if(b<=100 && isb==true)
		{				
			b+=1;
			if(b>100)
				break; 
			if2>>v2;
			
			
		}
		
		if(v1>v2){
			of1<<v1<<endl;
			isa=true;
			isb=false;
		}
		else{
			of1<<v2<<endl;
			isa=false;
			isb=true;
		}

	}
	
	while(a<=100)
	{
		if1>>v1;
		of1<<v1<<endl;
		a++;
	}
	
	while(b<=100)
	{
		if2>>v2;
		of1<<v2<<endl;
		b++;
	}
	
	if1.close();
	if2.close();
	of1.close();
}

//-------------------
int main(int argc, char** argv) {
	
	int n;
	ofstream out_file;
	
	out_file.open("db.txt",ios::trunc); 
	
	for(n=0;n<1000;n++)
	{
		out_file<<rand()<<endl;
	}
	out_file.close();
	//----------------------------------
	
	ifstream in_file;
	in_file.open("db.txt");
	int i,j,v[100];
	
	for(i=0;i<10;i++)
	{
		for(j=0;j<100;j++)
		{
			in_file>>v[j];
		}
		sort(v,i);
	}
	//--------------------------------
	char fname1[10];
	char fname2[10];
	
	for(i=0;i<5;i++)
	{
		sprintf(fname1,"db%d.txt",i*2);
		sprintf(fname2,"db%d.txt",i*2+1);
		sort_child(fname1,fname2,i);
	}
	 
	
	
	return 0;
}
