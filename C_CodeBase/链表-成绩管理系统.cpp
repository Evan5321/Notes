#include <iostream>
#include <string>
#include <conio.h>
using namespace std;

struct   stu
{
    string name;
    int  yw,sx,yy;
    struct stu*  next;
    struct stu*  prev;
};

//------------------------------------------
int show_main()
{
	system("cls");
	cout <<"\t\t成绩管理系统 v2.0"<<endl;
	cout <<"\t1:增加学生\t2:删除学生\t3:录入成绩"<<endl;
	cout <<"\t4:显示信息\t5:保存信息\t6:退出系统"<<endl;
	
	cout << ">>";
	int sel;
	cin >> sel;
	return sel;
}
//-------------------------------------------
stu* add_stu(stu* head)
{
	while(1)
	{
		stu* np = new stu;
		np->next=NULL;
		np->prev=NULL;
		
		cout<<"name:";
		cin>>np->name;
		
		if(np->name=="x")
		{
			delete np;
			break;
		}
		
		if(head==NULL)
		{
			head = np;
		}
		else if(head!=NULL)
		{
			head->prev = np;
			np->next = head;
			head = np;
		}
	}
	
	return head;
}
//------------------------------------------
stu* del_stu(stu* head)
{
	string name;
	cout<<"del name:";
	cin>>name;
	
	stu* p = head;
	
	while(p!=NULL)
	{
		if(p->name == name)
		{
			if(p==head)
			{
				head = head->next;
				head->prev = NULL;
				delete p;
			}
			else
			{
				p->prev->next = p->next;
				
				if(p->next!=NULL)
				{
					p->next->prev = p->prev;
				}
				
				delete p;
			}
			break;	
		}
		
		p = p->next;
	}
	return head;
}
//-----------------------------------------
int sort_cj(stu* head,int val,int style)
{
	stu* p = head;
	int cid = 1;
	
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
				vv = p->yw+p->yy+p->sx;
				break;
		}
		
		if(val<vv)
		{
			cid+=1;
		}
		
		p = p->next;
	}
	return cid;
}
//-----------------------------------------
void show_cj(stu* head)
{
	cout<<"\tName\tYW\tSX\tYY\tTotal\tYW_ID\tSX_ID\tYY_ID\tTOTAL_ID"<<endl;
	
	stu* p = head;
	while(p!=NULL)
	{
		cout<<"\t"<<p->name;
		cout<<"\t"<<p->yw;
		cout<<"\t"<<p->sx;
		cout<<"\t"<<p->yy;
		cout<<"\t"<<p->yw+p->sx+p->yy;
		
		cout<<"\t"<<sort_cj(head,p->yw,1);
		cout<<"\t"<<sort_cj(head,p->sx,2);
		cout<<"\t"<<sort_cj(head,p->yy,3);
		cout<<"\t"<<sort_cj(head,p->yw+p->sx+p->yy,4);
		
		cout<<endl;
		p = p->next;
	}
	getch();
}
//------------------------------------------
void write_cj(stu* head)
{
	stu* p = head;
	
	while(p!=NULL)
	{
		cout<<p->name<<"_YW:";
		cin>>p->yw;
		
		cout<<p->name<<"_SX:";
		cin>>p->sx;
		
		cout<<p->name<<"_YY:";
		cin>>p->yy;
		
		p = p->next;
	}
}

//------------------------------------------
int main(int argc, char** argv) 
{
	int sel;
	stu* student = NULL;
	
	while(1)
	{
		sel = show_main();
		
		switch(sel)
		{
			case 1:
				student = add_stu(student);
				break;
			case 2:
				student = del_stu(student);
				break;
			case 3:
				write_cj(student);
				break;
			case 4:
				show_cj(student);
				break;
			case 5:
				break;
			case 6:
				break;
		}
		
		if(sel==6)
			break;
	}
		
	return 1;
}
