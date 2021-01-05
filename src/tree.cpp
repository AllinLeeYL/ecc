#include "tree.h"

yieldNode::yieldNode(int father){
    this->father = father;
}

Yields::Yields(){
    if (this->yields.size() == 0){
        this->newYield(-1);
    }
}

int Yields::newYield(int father){
    if ((long unsigned int)father >= this->yields.size() && this->yields.size() != 0){
        return -1;
    }
    struct yieldNode *yield = new yieldNode(father);
    yield->symbols = NULL;
    this->yields.emplace_back(*(yield));
    //delete yield;
    return this->yields.size() - 1;
}

struct Symbol * Yields::ifExists(int curYield, std::string name, int * diff){
    int yieldDiff = 0;
    /*遍历当前域和父域*/
    for (; curYield >= 0; curYield = this->yields[curYield].father){
        /*遍历域中符号表*/
        for (struct Symbol * symbol = this->yields[curYield].symbols; symbol != NULL; symbol = symbol->next){
            if (symbol->name == name){
                if (diff != NULL){
                    *diff = yieldDiff;
                }
                return symbol;
            }
        }
        yieldDiff = yieldDiff + 1;
    }
    return NULL;
}

struct Symbol * Yields::addSym(int curYield, std::string name){
    if (this->yields[curYield].symbols == NULL){
        this->yields[curYield].symbols = (struct Symbol *)malloc(sizeof(struct Symbol));
        this->yields[curYield].symbols->next = NULL;
        this->yields[curYield].symbols->isFunc = 0;
        this->yields[curYield].symbols->name = name;
        return this->yields[curYield].symbols;
    }
    else{
        struct Symbol * symbol;
        for (symbol = this->yields[curYield].symbols; symbol->next != NULL; symbol = symbol->next){
            ;
        }
        symbol->next = (struct Symbol *)malloc(sizeof(struct Symbol));
        symbol = symbol->next;
        symbol->isFunc = 0;
        symbol->next = NULL;
        symbol->name = name;
        return symbol;
    }
}

void Yields::genSymID(int ID){
    for(long unsigned int i = 0; i < this->yields.size(); i = i + 1){
        for (struct Symbol * symbol = this->yields[i].symbols; symbol != NULL; symbol = symbol->next){
            symbol->ID = ID;
            ID = ID + 1;
        }
    }
}

void Yields::printYield(){
    cout<<"----------------------------Yield----------------------------"<<endl;
    for (long unsigned int i = 0; i < this->yields.size(); i = i + 1){
        cout<<i<<"\t"<<this->yields[i].father<<endl;
    }
}

void Yields::printSymTable(){
    cout<<"-------------------------Symbol Table-------------------------"<<endl;
    cout<<"ID\t"<<"name\t"<<"yield\n";
    for(long unsigned int i = 0; i < this->yields.size(); i = i + 1){
        for (struct Symbol * symbol = this->yields[i].symbols; symbol != NULL; symbol = symbol->next){
            cout<<symbol->ID<<"\t";
            cout<<symbol->name<<"\t";
            cout<<i<<endl;
        }
    }
}

void TreeNode::addChild(TreeNode* child) {
    TreeNode * curNode = this;

    if (curNode->child != NULL){
        for (curNode = curNode->child; curNode->sibling != NULL; curNode = curNode->sibling){
            ;
        }
        curNode->sibling = (TreeNode *)malloc(sizeof(TreeNode));
        curNode = curNode->sibling;
    }
    else{
        curNode->child = (TreeNode *)malloc(sizeof(TreeNode));
        curNode = curNode->child;
    }

    bstrcpy((char *)curNode, (char *)child, sizeof(TreeNode));
}

void TreeNode::addSibling(TreeNode* sibling){
    TreeNode *curNode;

    for (curNode = this; curNode->sibling != NULL; curNode = curNode->sibling){
        ;
    }

    curNode->sibling = (TreeNode *)malloc(sizeof(TreeNode));
    curNode = curNode->sibling;
    bstrcpy((char *)curNode, (char *)sibling, sizeof(TreeNode));
}

TreeNode::TreeNode(int lineno, NodeType type) {
    this->lineno = lineno;
    this->nodeType = type;
    this->nodeID = -1;

    this->child = NULL;
    this->sibling = NULL;
    this->type = NULL;
}

int TreeNode::genNodeId(int startID) {
    TreeNode *curNode = this;
    curNode->nodeID = startID;
    startID = startID + 1;

    for (curNode = this->child; curNode != NULL; curNode = curNode->sibling){
        startID = curNode->genNodeId(startID);
    }

    return startID;
}

int TreeNode::allocTypeForDECL(Type* type){
    for (TreeNode* curNode = this->child; curNode != NULL; curNode = curNode->sibling){
        curNode->allocTypeForDECL(type);
    }
    if (this->nodeType == NODE_VAR){
        this->symbol_p->type = type;
    }
    return 0;
}

int TreeNode::typeCheck(Type* type){
    if (this->nodeType == NODE_VAR){
        if (this->symbol_p->type->type != type->type){
            printf("Type Error at line ");
            printf("%d", this->lineno);
            exit(0);
        }
    }
    else if (this->type == NULL){
        printf("Type Error at line ");
        printf("%d", this->lineno);
        exit(0);
    }
    else if (this->type->type != type->type){
        printf("Type Error at line ");
        printf("%d", this->lineno);
        exit(0);
    }
    return 1;
}

int TreeNode::rtTypeCheck(Type* type){
    for (TreeNode* curNode = this->child; curNode != NULL; curNode = curNode->sibling){
        curNode->rtTypeCheck(type);
    }
    if (this->nodeType == NODE_STMT && this->stype == STMT_RETURN){
        if (this->type->type != type->type){
            printf("Type Error at line ");
            printf("%d", this->lineno);
            exit(0);
        }
    }
    return 1;
}

void TreeNode::printNodeInfo() {
    cout<<"lno@"<<this->lineno<<"\t";
    cout<<"@"<<this->nodeID<<"\t";
    cout<<nodeType2String(this->nodeType)<<"\t";
    return;
}

void TreeNode::printChildrenId() {
    if (this->child != NULL){
        TreeNode *curNode;
        printf("children: [");
        for(curNode = this->child; curNode != NULL; curNode = curNode->sibling){
            printf("@%d ", curNode->nodeID);
        }
        printf("]");
    }
    return;
}

void TreeNode::printAST() {
    TreeNode *curNode;
    this->printNodeInfo();
    this->printSpecialInfo();
    this->printChildrenId();
    printf("\n");
    for (curNode = this->child; curNode != NULL; curNode = curNode->sibling){
        curNode->printAST();
    }
    return;
}

// You can output more info...
void TreeNode::printSpecialInfo() {
    switch(this->nodeType){
        case NODE_CONST:
            if (this->type->type == VALUE_CHAR){
                cout<<this->ch_val<<"\t";
            }
            else if(this->type->type == VALUE_INT){
                cout<<this->int_val<<"\t";
            }
            else if(this->type->type == VALUE_STRING){
                cout<<this->str_val<<"\t";
            }
            break;
        case NODE_VAR:
            cout<<this->var_name<<"\t";
            if (this->symbol_p != NULL){
                cout<<"ID "<<this->symbol_p->ID<<"\t";
            }
            break;
        case NODE_EXPR:
            if (this->optype == OP_NOT){
                cout<<"!"<<"\t";
            }
            else if (this->optype == OP_MULT){
                cout<<"*"<<"\t";
            }
            else if (this->optype == OP_DIV){
                cout<<"/"<<"\t";
            }
            else if (this->optype == OP_MOD){
                cout<<"%"<<"\t";
            }
            else if (this->optype == OP_PLUS){
                cout<<"+"<<"\t";
            }
            else if (this->optype == OP_SUB){
                cout<<"-"<<"\t";
            }
            else if (this->optype == OP_G){
                cout<<">"<<"\t";
            }
            else if (this->optype == OP_L){
                cout<<"<"<<"\t";
            }
            else if (this->optype == OP_GEQ){
                cout<<">="<<"\t";
            }
            else if (this->optype == OP_LEQ){
                cout<<"<="<<"\t";
            }
            else if (this->optype == OP_EQ){
                cout<<"=="<<"\t";
            }
            else if (this->optype == OP_NEQ){
                cout<<"!="<<"\t";
            }
            else if (this->optype == OP_AND){
                cout<<"&&"<<"\t";
            }
            else if (this->optype == OP_OR){
                cout<<"||"<<"\t";
            }
            else if (this->optype == OP_ASSIGN){
                cout<<"="<<"\t";
            }
            else if (this->optype == OP_GETADDR){
                cout<<"&"<<"\t";
            }
            else if (this->optype == OP_PLUSEQ){
                cout<<"+="<<"\t";
            }
            else if (this->optype == OP_SUBEQ){
                cout<<"-="<<"\t";
            }
            else if (this->optype == OP_MULTEQ){
                cout<<"*="<<"\t";
            }
            else if (this->optype == OP_DIVEQ){
                cout<<"/="<<"\t";
            }
            else if (this->optype == OP_MODEQ){
                cout<<"%="<<"\t";
            }
            else if (this->optype == OP_FRONTPP){
                cout<<"++"<<"\t";
            }
            else if (this->optype == OP_TAILPP){
                cout<<"++"<<"\t";
            }
            else if (this->optype == OP_FRONTSS){
                cout<<"--"<<"\t";
            }
            else if (this->optype == OP_TAILSS){
                cout<<"--"<<"\t";
            }
            else if (this->optype == OP_UNARYP){
                cout<<"+"<<"\t";
            }
            else if (this->optype == OP_UNARYS){
                cout<<"-"<<"\t";
            }
            break;
        case NODE_STMT:
            cout<<sType2String(this->stype)<<"\t";
            break;
        case NODE_TYPE:
            if (this->type->type == VALUE_INT){
                cout<<"int "<<"\t";
            }
            else if(this->type->type == VALUE_CHAR){
                cout<<"char"<<"\t";
            }
            else if(this->type->type == VALUE_VOID){
                cout<<"void"<<"\t";
            }
            else if(this->type->type == VALUE_STRING){
                cout<<"string"<<"\t";
            }
            break;
        default:
            break;
    }
}

string TreeNode::sType2String(StmtType type) {
    switch (type){
        case STMT_EXPR:
            return "expr";
            break;
        case STMT_FUNC_DECL:
            return "funcDecl";
            break;
        case STMT_DECL:
            return "declration";
            break;
        case STMT_SKIP:
            return "SEMICOLON";
            break;
        case STMT_RETURN:
            return "return";
            break;
        case STMT_IF:
            return "if";
            break;
        case STMT_WHILE:
            return "while";
            break;
        case STMT_FOR:
            return "for";
            break;
        case STMT_PRINTF:
            return "printf";
            break;
        case STMT_SCANF:
            return "scanf";
            break;
        default:
            return "?";
            break;
    }
}


string TreeNode::nodeType2String (NodeType type){
    switch(type){
        case NODE_CONST:
            return "const";
            break;
        case NODE_VAR:
            return "vari";
            break;
        case NODE_EXPR:
            return "expr";
            break;
        case NODE_TYPE:
            return "type";
            break;
        case NODE_STMT:
            return "stmt";
            break;
        case NODE_PROG:
            return "program";
            break;
        default:
            return "?";
    }
}
