#include <iostream>
#include <fstream>
#include <string>
#include <conio.h>
#include <string.h>
using namespace std;


struct   stu
{
    char name[8];
    int  yw,sx,yy;
    struct stu*  next;
    struct stu*  prev;
};

/*
1:   name1,yw,sx,yy
	 name2,yw,sx,yy
	 ...
2:  二进制块写入 
*/ 


//----------------------------------------
int show_main()
{
	system("cls");
	cout << "\t\t班级成绩管理系统 V2.0"<<endl;
	cout << "\t1:增加学生\t2:删除学生\t3:录入成绩"<<endl; 
	cout << "\t4:成绩排序\t5:保存成绩\t6:退出程序"<<endl;
	cout<<endl;
	cout<<">>>>";
	int sel;
	cin>>sel;
	
	return sel;
}
//----------------------------------------
stu* add_student(stu* head)
{
	while(1)
	{
		stu* np = new stu;
		
		cout<<"name:";
		cin>>np->name;

		
		if(strcmp(np->name,"x")==0)
		{
			delete np;
			break;
		}
		
		np->prev = NULL;
		np->next = NULL;
		
		if(head==NULL)
		{
			head = np;
		}
		else
		{
			head->prev = np;
			np->next = head;
			head = np;
		}
	}
	return head;
}
//---------------------------------------
int sort_cj(stu* head,int val,int style)
{
	stu* p = head;
	int nid = 1;:class MyClass : public QObject {
	  Q_OBJECT;
	public:
	
	explicit MyClass(QObject *parent = nullptr);
	  
	signals:
	
	public slots:
	};
	
	
	while(p!=NULL)
	{
		int vv=0;
		switch(style)
		{
			case 1:
				vv = p->yw;
				break;
			case 2:
				vv = p->sx;
				break;
			case 3:
				vv = p->yy;
				break;
			case 4:
				vv = p->yw+p->sx+p->yy;
				break;		
		}
		
		if(val<vv)
			nid+=1;
		
		p = p->next;
	}
	return nid;
}

//---------------------------------------
void sort_student(stu* head)
{
	cout<<"\tName\tYW\tSX\tYY\tTotal\tyw_id\tsx_id\tyy_id\ttotal_id"<<endl;
	stu* p = head;
	
	while(p!=NULL)
	{
		cout<<"\t"<<p->name;
		cout<<"\t"<<p->yw<<"\t"<<p->sx<<"\t"<<p->yy<<"\t"<<p->yw+p->sx+p->yy;
		cout<<"\t"<<sort_cj(head,p->yw,1);
		cout<<"\t"<<sort_cj(head,p->sx,2);
		cout<<"\t"<<sort_cj(head,p->yy,3);
		cout<<"\t"<<sort_cj(head,p->yw+p->sx+p->yy,4)<<endl;
		p = p->next;
	}
	getch();
	return;
}
//---------------------------------------
stu* del_student(stu* head)
{
	string name;
	cout<<"delete name:";
	cin>>name;
	
	stu* p=head;
	while(p!=NULL)
	{
		if(p->name==name)
		{
			if(p==head)
			{
				head = head->next;
				if(head!=NULL)
				{
					head->prev = NULL;
				}
			}
			else if(p!=head)
			{
				p->prev->next = p->next;
				if(p->next!=NULL)
				{
					p->next->prev = p->prev;
				}
			}
			delete p;
			break;
		}
		
		p=p->next;	
	}	
	return head;
}
//---------------------------------------
void write_cj(stu* head)
{
	stu* p = head;
	int tmp=0;
	
	while(p!=NULL)
	{
		cout<<p->name<<"_YW:";
		cin>>tmp;
		if(tmp>=0)
			p->yw=tmp;
		else if(tmp==-2)
			break;
		
		cout<<p->name<<"_SX:";
		cin>>tmp;
		if(tmp>=0)
			p->sx=tmp;
		else if(tmp==-2)
			break;
		
		cout<<p->name<<"_YY:";
		cin>>tmp;
		if(tmp>=0)
			p->yy=tmp;
		else if(tmp==-2)
			break;
		
		p=p->next;
	}
}
//----------------------------------------
void save_student(stu* head)
{
	ofstream out_file;
	out_file.open("stu.db",ios::binary | ios::trunc);
	
	if(out_file.is_open()==false)
	{
		cout<<"save is error !"<<endl;
	}
	else
	{
		stu* p = head;
		while(p!=NULL)
		{
			//写入一个学生的信息到文件 
			out_file.write((char*)p,sizeof(stu));
			p=p->next;
		}
	}
	
	out_file.close();
}
//----------------------------------------
stu* load_student()
{
	ifstream in_file;
	in_file.open("stu.db",ios::binary);
	stu*  head = NULL;
	stu  tmp;
	
	in_file.read((char*)(&tmp),sizeof(stu));
		
	while(in_file.eof()==0)
	{
		stu* p = new stu;
		strcpy(p->name,tmp.name);
		p->yw = tmp.yw;
		p->sx = tmp.sx;
		p->yy = tmp.yy;
		p->next = NULL;
		p->prev = NULL;
		
		
		if(head==NULL)
			head = p;
		else
		{
			p->next = head;
			head->prev = p;
			head = p;
		}
		in_file.read((char*)(&tmp),sizeof(stu));
			
	}
	
	in_file.close();
	return head;
}

//---------------------------------------
int main(int argc, char** argv) 
{
	int sel=0;
	stu*  student=NULL;
	
	student = load_student();
	
	while(1)
	{
		sel = show_main();
	
		switch(sel)
		{
			case 1:
				student = add_student(student);
				break;
			case 2:
				student = del_student(student);
				break;
			case 3:
				write_cj(student);
				break;
			case 4:
				sort_student(student);
				break;
			case 5:
				save_student(student);
				break;
			case 6:
				break;
		}
		
		if(sel==6)
			break;
	}
	
	return 1;
}
