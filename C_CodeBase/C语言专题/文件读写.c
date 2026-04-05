#include <stdio.h>

int WriteIn(){
	
	char te[50] = "There is something to write in...\n";
	
	FILE *fp = NULL; //建立一个文件读写对象
	
	//打开文件
	fp = fopen("../C语言专题/test.txt","w+");
	//写入字符串的一个函数 第一个参数为文件读写对象 第二个参数为字符串、
	fprintf(fp,te);
	//写入字符串的一个函数等价于fputc() 第一个参数为字符串 第二个参数为文件读写对象、
	fputs(te,fp);
	//关闭文件
	fclose(fp);
	
	return 0;
}

int ReadFile(){
	
	FILE *fp = NULL;
	char text[1024];
	
	fp = fopen("../C语言专题/test.txt","r");
	
	//读取整个文件
	while(fgets(text,1024,fp)!=NULL){
		puts(text);
	}
	fclose(fp);
	
	//只读一行
	fgets(text,1024,fp);
	puts(text);
	
}



int main(){
	
	WriteIn();
	
	ReadFile();
}
