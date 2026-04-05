#include <iostream>
#include <string>
using namespace std;

struct node
{
    string name;
    int v;
    node* next;
};
//----------------------------------------
node* append_node(node* buf,string name,int v)
{
    //分配内存，构建一个元素
    node* newp = new node[1];
    newp->v = v;
    newp->name = name;
    newp->next=NULL;

    //判断是否空链表
    if(buf==NULL)
    {
        buf = newp;
    }
    else
    {
        //不是空链表
        node* n_head = buf;

        //移到最后一个元素
        while(n_head->next!=NULL){
            n_head = n_head->next;
        }
        //更改元素的后继地址
        n_head->next = newp;
    }
    free(newp);
    return buf;
}
//-------------------------------------------
void show(node* buf)
{
    node* n_head = buf;

    while(n_head!=NULL)
    {
        cout<<n_head->name<<"\t"<<n_head->v<<endl;

        n_head = n_head->next;
    }
}
//-----------------------------------------
node* insert_node(node* buf,int i,string name,int v)
{
    //分配内存，构建一个元素
    node* newp = new node[1];
    newp->v = v;
    newp->name = name;
    newp->next=NULL;

    //判断是否空链表
    if(buf==NULL)
    {
        buf = newp;
    }
    else
    {
        int c=0;
        node* n_head = buf;

        while(c!=i-1)
        {
            n_head = n_head->next;
            c+=1;
        }

        newp->next = n_head->next;
        n_head->next = newp;
    }
    return buf;
}
//-----------------------------------------
node* delete_node(node* buf,int i)
{
    node* n_head = buf;
    //如果删除第一个元素
    if(i==0)
    {
        //node* dd = n_head;
        n_head = n_head->next;
        buf = n_head;
        //delete dd;
    }
    else
    {
        int c=0;

        //移动要删除元素的前一位
        while(c!=i-1)
        {
            c++;
            n_head=n_head->next;
        }

        //获取要删除元素指针
        node* dd = n_head->next;
        //要删除元素前一位元素的新后继节点指针
        n_head->next = dd->next;
        //释放内存
        delete dd;
    }

    return buf;
}
//------------------------------------------
int count_node(node* buf)
{
    node* n_head = buf;
    int num=0;

    while(n_head!=NULL)
    {
        num++;

        n_head=n_head->next;
    }
    return num;
}
//-----------------------------------------
int get_node(node* buf,int i)
{
    node* n_head = buf;
    int c=0;

    while(c!=i)
    {
        n_head = n_head->next;
        c++;
    }

    return n_head->v;
}
//------------------------------------------
void sort_node(node* buf)
{
    node* p1 = buf;

    while(p1!=NULL)
    {
        node* p2 = p1->next;

        while(p2!=NULL)
        {
            if(p1->v < p2->v)
            {
                string tn = p1->name;
                int tv = p1->v;

                p1->name = p2->name;
                p1->v = p2->v;

                p2->name = tn;
                p2->v = tv;
            }
            p2 = p2->next;
        }

        p1 = p1->next;
    }
}


//-----------------------------------------
int main()
{
    node* buf=NULL;

    buf = append_node(buf,"zs",70);
    buf = append_node(buf,"ls",60);
    buf = append_node(buf,"hw",90);
    buf = append_node(buf,"cl",80);

    buf = insert_node(buf,2,"gq",50);

    buf = delete_node(buf,3);

    show(buf);

    cout<<"==============排序==========="<<endl;

    sort_node(buf);
    show(buf);

    return 0;
}
