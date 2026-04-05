#include <iostream>
#include <vector>
#include <string>
#include <stdlib.h>
#include <fstream>
#include <map>
#include <math.h>

using namespace std;

struct tree{
	tree* parent;
	tree* left;
	tree* right;
	bool  val;
	int   cid;
	int   level;
};

void make_tree(tree* c_tree,int level){
	
	if(c_tree->level == level)
		return;
	
	c_tree->left->parent = c_tree;
	c_tree->left->left = NULL;
	c_tree->left->right = NULL;
	c_tree->left->cid = c_tree->cid*2;
	c_tree->left->val = false;
	c_tree->left->level = c_tree->level+1;
	make_tree(c_tree->left,level);
	
	c_tree->right->parent = c_tree;
	c_tree->right->left = NULL;
	c_tree->right->right = NULL;
	c_tree->right->cid = c_tree->cid*2+1;
	c_tree->right->val = false;
	c_tree->right->level = c_tree->level+1;
	make_tree(c_tree->right,level);
	
}

int main(int argc, char** argv) {
	
	tree* c_tree = new tree;
	
	c_tree->parent = NULL;
	c_tree->left = NULL;
	c_tree->right = NULL;
	c_tree->cid = 1;
	c_tree->val = false;
	c_tree->level = 1;
	
	tree* head = c_tree;
	
	int level,num;
	cout>>level>>num;
	
	make_tree(c_tree,level);
		
	return 0;
}
