#include "translater.h"

Translater::Translater(FILE* fp){
    this->fp = fp;
    this->type = NULL;
    this->labelID = 0;
    this->stack_p = 0;
}

Translater::~Translater(){
    ;
}

void Translater::genDATA(TreeNode* node){
    for (TreeNode* curNode = node->child; curNode != NULL; curNode = curNode->sibling){
        this->genDATA(curNode);
    }
    if (node->nodeType == NODE_CONST && node->type->type == VALUE_STRING){
        fprintf(this->fp, "string%d:\n", node->nodeID);
        fprintf(this->fp, "\t.string %s\n", node->str_val.data());
    }
}

void Translater::genBSS(struct Yields* yields){
    for(long unsigned int i = 0; i < yields->yields.size(); i = i + 1){
        for (struct Symbol * symbol = yields->yields[i].symbols; symbol != NULL; symbol = symbol->next){
            if (symbol->isFunc != 0){
                continue;
            }
            else if (symbol->type->type == VALUE_INT){
                fprintf(this->fp, "\t.align 4\n%s", symbol->name.data());
                fprintf(this->fp, "%d:\n\t.zero 4\n", symbol->ID);
            }
            else if (symbol->type->type == VALUE_CHAR){
                fprintf(this->fp, "\t.align 4\n%s", symbol->name.data());
                fprintf(this->fp, "%d:\n\t.zero 1\n", symbol->ID);
            }
        }
    }
}

void Translater::genTEXT(TreeNode* node, struct Yields* yields){
    this->genFunc(node, yields);
    this->genTEXT_TRVSIB(node->child, yields);
}

void Translater::translate(TreeNode* node, struct Yields* yields){
    //node->printAST();
    fprintf(this->fp, "\t.data\n");
    this->genDATA(node);
    fprintf(this->fp, "\t.bss\n");
    this->genBSS(yields);
    fprintf(this->fp, "\t.text\n");
    this->genTEXT(node, yields);
}

void Translater::genFunc(TreeNode* node, struct Yields* yields){
    for(long unsigned int i = 0; i < yields->yields.size(); i = i + 1){
        for (struct Symbol * symbol = yields->yields[i].symbols; symbol != NULL; symbol = symbol->next){
            if (symbol->isFunc != 1){
                continue;
            }
            fprintf(this->fp, "\t.global %s\n", symbol->name.data());
            fprintf(this->fp, "\t.type %s, @function\n", symbol->name.data());
        }
    }
}

void Translater::genExprs(TreeNode* node, struct Yields* yields){
    if (node->sibling != NULL){
        // 率先遍历右兄弟
        this->genExprs(node->sibling, yields);
    }
    this->genExpr(node, yields);
}

void Translater::genExpr(TreeNode* node, struct Yields* yields){
    /* 子表达式结果压栈，先压左值，后压右值 */
    if (node->nodeType == NODE_EXPR){
        // 表达式节点
        if (node->optype == OP_ASSIGN || node->optype == OP_PLUSEQ || node->optype == OP_SUBEQ ||
            node->optype == OP_MULTEQ || node->optype == OP_DIVEQ || node->optype == OP_MODEQ){
            this->genExpr_ASSIGN(node, yields); // 赋值表达式
        }
        else if (node->optype == OP_PLUS || node->optype == OP_SUB || node->optype == OP_MULT ||
                 node->optype == OP_DIV || node->optype == OP_MOD || node->optype == OP_AND ||
                 node->optype == OP_OR || node->optype == OP_G || node->optype == OP_L ||
                 node->optype == OP_GEQ || node->optype == OP_LEQ || node->optype == OP_EQ ||
                 node->optype == OP_NEQ){
            this->genExpr_LR(node, yields); // 左右孩子都可以是表达式
        }
        else if (node->optype == OP_GETADDR || node->optype == OP_NOT || node->optype == OP_UNARYP ||
                 node->optype == OP_UNARYS || node->optype == OP_FRONTPP || node->optype == OP_FRONTSS ||
                 node->optype == OP_TAILPP || node->optype == OP_TAILSS){
            this->genExpr_UNARY(node, yields);
        }
    }
    else if (node->nodeType == NODE_VAR){
        // ID节点
        Symbol* symbol = node->symbol_p;
        if (symbol->type->type == VALUE_INT){
            fprintf(this->fp, "\tmovl %s%d, %%eax\n", symbol->name.data(), symbol->ID);
            fprintf(this->fp, "\tpushl %%eax\n");
            this->stack_p = this->stack_p + 4;
        }
        else if (symbol->type->type == VALUE_CHAR){
            fprintf(this->fp, "\tmovb %s%d, %%al\n", symbol->name.data(), symbol->ID);
            fprintf(this->fp, "\tpushl %%eax\n");
            this->stack_p = this->stack_p + 4;
        }
    }
    else if (node->nodeType == NODE_CONST){
        // 常量节点
        if (node->type->type == VALUE_STRING){
            fprintf(this->fp, "\tpushl $string%d\n", node->nodeID);
            this->stack_p = this->stack_p + 4;
        }
        else if (node->type->type == VALUE_INT){
            fprintf(this->fp, "\tmovl $%d, %%eax\n\tpushl %%eax\n", node->int_val);
            this->stack_p = this->stack_p + 4;
        }
        else if (node->type->type == VALUE_CHAR){
            fprintf(this->fp, "\tmovb $%d, %%al\n\tpushl %%eax\n", node->ch_val);
            this->stack_p = this->stack_p + 4;
        }
    }
}

void Translater::genExpr_ASSIGN(TreeNode* node, struct Yields* yields){
    // 赋值表达式，先计算右侧节点
    this->genExpr(node->child->sibling, yields);
    Symbol* symbol = node->child->symbol_p;
    fprintf(this->fp, "\tpopl %%eax\n");
    fprintf(this->fp, "\tmovl $%s%d, %%ebx\n", symbol->name.data(), symbol->ID);
    if (node->optype == OP_ASSIGN){
        if (symbol->type->type == VALUE_INT){
            fprintf(this->fp, "\tmovl %%eax, (%%ebx)\n");
            this->stack_p = this->stack_p - 4;
        }
        else if (symbol->type->type == VALUE_CHAR){
            fprintf(this->fp, "\tmovb %%al, (%%ebx)\n");
            fprintf(this->fp, "\tpushl %%eax\n");
            this->stack_p = this->stack_p - 4;
            return;
        }
    }
    else if (node->optype == OP_PLUSEQ){
        if (symbol->type->type == VALUE_INT){
            fprintf(this->fp, "\tmovl %s%d, %%ecx\n", symbol->name.data(), symbol->ID);
            fprintf(this->fp, "\taddl %%ecx, %%eax\n\tmovl %%eax, (%%ebx)\n");
            this->stack_p = this->stack_p - 4;
        }
        else if (symbol->type->type == VALUE_CHAR){
            fprintf(this->fp, "\tmovl %s%d, %%ecx\n", symbol->name.data(), symbol->ID);
            fprintf(this->fp, "\taddl %%ecx, %%eax\n\tmovb %%al, (%%ebx)\n");
            fprintf(this->fp, "\tpushl %%eax\n");
            this->stack_p = this->stack_p - 4;
            return;
        }
    }
    else if (node->optype == OP_SUBEQ){
        if (symbol->type->type == VALUE_INT){
            fprintf(this->fp, "\tmovl %s%d, %%ecx\n", symbol->name.data(), symbol->ID);
            fprintf(this->fp, "\tsubl %%eax, %%ecx\n\tmovl %%ecx, (%%ebx)\n");
            fprintf(this->fp, "\tmovl %%ecx, %%eax\n");
            this->stack_p = this->stack_p - 4;
        }
        else if (symbol->type->type == VALUE_CHAR){
            fprintf(this->fp, "\tmovl %s%d, %%ecx\n", symbol->name.data(), symbol->ID);
            fprintf(this->fp, "\tsubl %%eax, %%ecx\n\tmovb %%cl, (%%ebx)\n");
            fprintf(this->fp, "\tpushl %%ecx\n");
            this->stack_p = this->stack_p - 4;
        }
    }
    fprintf(this->fp, "\tpushl %%eax\n");
}

void Translater::genExpr_LR(TreeNode* node, struct Yields* yields){
    this->genExpr(node->child, yields);
    this->genExpr(node->child->sibling, yields);
    fprintf(this->fp, "\tpopl %%ebx\n\tpopl %%eax\n");
    if (node->optype == OP_PLUS){
        fprintf(this->fp, "\taddl %%ebx, %%eax\n");
         this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_SUB){
        fprintf(this->fp, "\tsubl %%ebx, %%eax\n");
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_MULT){
        fprintf(this->fp, "\timull %%ebx\n");
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_DIV){
        fprintf(this->fp, "\tcltd\n\tidivl %%ebx\n");
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_MOD){
        fprintf(this->fp, "\tcltd\n\tidivl %%ebx\n\tmovl %%edx, %%eax\n");
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_G){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "\tcmpl %%ebx, %%eax\n\tjg label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_L){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "\tcmpl %%ebx, %%eax\n\tjl label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_GEQ){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "\tcmpl %%ebx, %%eax\n\tjge label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_LEQ){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "\tcmpl %%ebx, %%eax\n\tjle label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_EQ){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "\tcmpl %%ebx, %%eax\n\tje label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_NEQ){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "\tcmpl %%ebx, %%eax\n\tjne label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_AND){
        fprintf(this->fp, "\tandl %%ebx, %%eax\n");
        this->stack_p = this->stack_p - 4;
    }
    else if (node->optype == OP_OR){
        fprintf(this->fp, "\torl %%ebx, %%eax\n");
        this->stack_p = this->stack_p - 4;
    }
    fprintf(this->fp, "\tpushl %%eax\n");
}

void Translater::genExpr_UNARY(TreeNode* node, struct Yields* yields){
    if (node->optype == OP_GETADDR){
        Symbol* symbol = node->child->symbol_p;
        fprintf(this->fp, "\tpushl $%s%d\n", symbol->name.data(), symbol->ID);
        this->stack_p = this->stack_p + 4;
    }
    else if (node->optype == OP_NOT){
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        this->genExpr(node->child, yields);
        fprintf(this->fp, "\tpopl %%eax\n\tcmpl $1, %%eax\n\tje label%d\n", ifID);
        /*-------------------------else-------------------------*/
        fprintf(this->fp, "\tmovl $1, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        fprintf(this->fp, "\tmovl $0, %%eax\n");
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n\tpushl %%eax\n", endID);
    }
    else if (node->optype == OP_UNARYS){
        this->genExpr(node->child, yields);
        fprintf(this->fp, "\tpopl %%eax\n\tmovl $0, %%ebx\n\tsubl %%eax, %%ebx\n\tpushl %%ebx\n");
    }
    else{
        this->genExpr(node->child, yields);
    }
}

void Translater::genSTMT(TreeNode* node, struct Yields* yields){
    if (node->stype == STMT_FUNC_DECL){
        // 函数声明语句
        Symbol* symbol = node->child->sibling->symbol_p;
        fprintf(this->fp, "%s:\n", symbol->name.data());
        this->genTEXT_TRVSIB(node->child->sibling->sibling, yields);
    }
    else if (node->stype == STMT_IF){
        // IF语句
        this->labelID = this->labelID + 2;
        int ifID = this->labelID - 2;
        int endID = this->labelID - 1;
        this->genExpr(node->child->child, yields);
        fprintf(this->fp, "\tpopl %%eax\n\tcmp $1, %%eax\n\tje label%d\n", ifID);
        /*-------------------------else-------------------------*/
        TreeNode* stBlock = node->child->sibling->sibling;
        if (stBlock != NULL) {this->genTEXT_TRVSIB(stBlock->child, yields);}
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------if-------------------------*/
        fprintf(this->fp, "label%d:\n", ifID);
        this->genTEXT_TRVSIB(node->child->sibling->child, yields);
        fprintf(this->fp, "\tjmp label%d\n", endID);
        /*-------------------------finally-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
    }
    else if (node->stype == STMT_WHILE){
        /*-------------------------while-------------------------*/
        this->labelID = this->labelID + 2;
        int whileID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "label%d:\n", whileID);
        this->genExpr(node->child->child, yields);
        fprintf(this->fp, "\tpopl %%eax\n\tcmp $0, %%eax\n\tje label%d\n", endID);
        this->genTEXT_TRVSIB(node->child->sibling->child, yields);
        fprintf(this->fp, "\tjmp label%d\n", whileID);
        /*-------------------------end-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
    }
    else if (node->stype == STMT_FOR){
        this->genSTMT(node->child->child, yields);
        /*-------------------------for-------------------------*/
        this->labelID = this->labelID + 2;
        int forID = this->labelID - 2;
        int endID = this->labelID - 1;
        fprintf(this->fp, "label%d:\n", forID);
        this->genExpr(node->child->sibling->child, yields);
        fprintf(this->fp, "\tpopl %%eax\n\tcmp $0, %%eax\n\tje label%d\n", endID);
        this->genTEXT_TRVSIB(node->child->sibling->sibling->sibling->child, yields);
        this->genExpr(node->child->sibling->sibling->child, yields);
        fprintf(this->fp, "\taddl $4, %%esp\n");
        fprintf(this->fp, "\tjmp label%d\n", forID);
        /*-------------------------end-------------------------*/
        fprintf(this->fp, "label%d:\n", endID);
    }
    else if (node->stype == STMT_EXPR){
        // 表达式语句
        this->genExpr(node->child, yields);
        fprintf(this->fp, "\taddl $4, %%esp\n");
    }
    else if (node->stype == STMT_DECL){
        // 声明语句
        for (TreeNode* curNode = node->child->sibling; curNode != NULL; curNode = curNode->sibling){
            if (curNode->optype == OP_ASSIGN){
                this->genExpr(curNode, yields);
                fprintf(this->fp, "\taddl $4, %%esp\n");
            }
        }
    }
    else if (node->stype == STMT_PRINTF){
        // PRINTF
        this->stack_p = 0;
        this->genExprs(node->child, yields);
        fprintf(this->fp, "\tcall printf\n");
        fprintf(this->fp, "\taddl $%d, %%esp\n", this->stack_p);
        this->stack_p = 0;
    }
    else if (node->stype == STMT_SCANF){
        // SCANF
        this->stack_p = 0;
        this->genExprs(node->child, yields);
        fprintf(this->fp, "\tcall scanf\n");
        fprintf(this->fp, "\taddl $%d, %%esp\n", this->stack_p);
        this->stack_p = 0;
    }
}

void Translater::genTEXT_TRVSIB(TreeNode* node, struct Yields* yields){
    // 遍历节点所有兄弟，用于语句块的遍历
    for (TreeNode* curNode = node; curNode != NULL; curNode = curNode->sibling){
        if (curNode->nodeType == NODE_STMT){
            this->genSTMT(curNode, yields);
        }
    }
}