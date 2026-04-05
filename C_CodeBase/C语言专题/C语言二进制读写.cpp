#include <stdio.h>
#include <string.h>

struct Student{
	char name[100];
	int age;
	int grade;
};

int WriteIn(Student *stu1){
	
	FILE *fp;
	fp = fopen("student.dat","wb");
	fwrite(stu1,sizeof(stu1[0]),2,fp);
	fclose(fp);
	
	return 0;
}

int ReadFile(){
	
	Student stu[2];
	
	FILE *fp;
	
	fp = fopen("student.dat","rb");
	fread(stu,sizeof(stu[0]),2,fp);
	fclose(fp);
	printf("%s\n",stu[0].name);
	printf("%s\n",stu[1].name);
	
	return 0;
}

int main(){
	
	Student stu[2];
	
	strcpy(stu[0].name,"Zhangsan");
	stu[0].age = 14;
	stu[0].grade = 7;
	
	strcpy(stu[1].name,"Lisi");
	stu[1].age = 14;
	stu[1].grade = 7;
	
	WriteIn(stu);
	ReadFile();
	
	return 0;
}
