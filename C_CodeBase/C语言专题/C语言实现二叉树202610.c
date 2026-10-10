#include <stdio.h>
#include <stdlib.h>

typedef struct Node {
    int data;
    struct Node* left;
    struct Node* right;
} Node;

typedef struct tree{
    Node* root;
} Tree;

void insert(Tree* tree, int value){
    Node* node = (Node*)malloc(sizeof(Node));
    node->data = value;
    node->left = NULL;
    node->right = NULL;

    if(tree->root == NULL){
        tree->root = node;
    }else{
        Node* temp = tree->root;
        while (temp != NULL){
            if(value < temp -> data){
                if(temp->left == NULL){
                    temp -> left = node;
                    return ;
                }else{
                    temp = temp -> left;
                }
            }else if (value > temp -> data){
                if(temp->right == NULL){
                    temp -> right = node;
                    return ;
                }else{
                    temp = temp -> right;
                }
            }
            
        }
        
    }


}


int main(){

    int arr[7] = [6,5,4,7,2,9,1,3];

    Tree tree;
    tree.root = NULL;

    for(int i=0;i<;;){
        
    }

    return 0;
}